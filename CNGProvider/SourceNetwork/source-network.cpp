/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

// TODO: THIS LIBWEBSOCKET STUFF MUST GO. Totally unsafe in addition to the fact it is not portable.
// replacing with OpenSSL and leaving stunnel in for now. Not sure why this is layer caked.

//#include "stdafx.h"
#include "..\..\Include\source-network.h"
#include "..\..\Include\config_parse.h"
#include "..\..\Include\internal.h"
#include "..\..\Include\utilities.h"
#include "..\..\Include\poll.h"
#include "..\..\Include\wnr.h"
#include <G:\!!SkyCipher\Clients\WhitewoodEncryption\Projects\netRandom\Code\SharedSourceCode\extern\mbedtls-2.2.1\include\mbedtls\aes.h>
#include <G:\!!SkyCipher\Clients\WhitewoodEncryption\Projects\netRandom\Code\SharedSourceCode\extern\mbedtls-2.2.1\include\mbedtls/md.h>
#include <assert.h>
#include <G:\!!SkyCipher\Clients\WhitewoodEncryption\Projects\netRandom\Code\SharedSourceCode\sys.time.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

#if defined(_MSC_VER)
#include <BaseTsd.h>
typedef SSIZE_T ssize_t;
#endif
#define WNR_MSG_MAGIC   "WNR1"
#define HMAC_LEN        32        // SHA256

typedef enum _netsrc_conn_state {
  netsrc_conn_state_PRE_INIT = 0,
  netsrc_conn_state_INIT,
  netsrc_conn_state_EXPECT_HELLO,
  netsrc_conn_state_STEADY,
  netsrc_conn_state_EXPECT_DATA,
  netsrc_conn_state_CONN_ERROR
} netsrc_conn_state;

typedef size_t (*wnr_message_constructor)(instream_network *net_ctx, unsigned char **out);
static int _wnr_lws_callback(struct libwebsocket_context *lws_ctx,
	struct libwebsocket *lws_wsi,
	enum libwebsocket_callback_reasons reason,
	void *user, void *in, size_t len);

/* The following are used for AES-128-CTR encrypting received entropy */
typedef struct _aes_ctx_s {
  bool initialized;
  mbedtls_aes_context mbedtls_ctx;
  unsigned char nonce_counter[16];
  unsigned char stream_block[16];
  unsigned char key[16];
  size_t nc_off;
  uint8_t rekey_interval;
  uint8_t rekey_counter;
} aes_ctx_t;

typedef struct _netsrc_state {
  aes_ctx_t aes_ctx;
  netsrc_conn_state conn_state;
  struct libwebsocket_context *wnr_lws_ctx;
  struct libwebsocket *wnr_lws_wsi;
  struct libwebsocket_protocols *wnr_lws_protocols;
  uint64_t client_msg_number;
  uint64_t server_msg_number;
  bool request_entropy;
  uint32_t bytes_requested;
  time_t last_reconnect;
  int reconnect_interval;
  int reconnect_attempts;
  unsigned char *static_hmac_key;
  size_t static_hmac_key_len;
  mbedtls_md_context_t md_ctx;
} netsrc_state;

char *urandom_filename = "/dev/urandom";


static int
_wnr_get_static_hmac_key(instream_default *ctx, const char *client_id,
  unsigned char **key, size_t *key_len)
{
  instream_network *net_ctx = (instream_network*)ctx;
  CHECK(net_ctx, "Empty network source context object");
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  CHECK(state, "Uninitialized network source context object");
  CHECK(state->static_hmac_key, "No static HMAC key has been set");
  *key = state->static_hmac_key;
  *key_len = state->static_hmac_key_len;
  return WNR_ERROR_NONE;
cleanup:
  return WNR_ERROR_GENERAL;
}

int
wnr_netsrc_set_static_hmac_key(instream_default *_net_ctx, unsigned char *key, size_t key_len)
{
  instream_network *net_ctx = (instream_network*)_net_ctx;
  assert(net_ctx);
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  assert(state);

  if (state->static_hmac_key)
    free(state->static_hmac_key);
  state->static_hmac_key =(unsigned char*) malloc(key_len);
  CHECK_MEM(state->static_hmac_key);
  memcpy(state->static_hmac_key, key, key_len);
  state->static_hmac_key_len = key_len;
  ((instream_network*)net_ctx)->get_key = _wnr_get_static_hmac_key;
  return WNR_ERROR_NONE;
cleanup:
  return WNR_ERROR_GENERAL;
}

static int
_wnr_hmac_message(instream_network *net_ctx, uint8_t msg_type,
  uint64_t msg_number, unsigned char *data, size_t data_len,
  unsigned char *hmac_buf, size_t hmac_buf_len)
{
  int ret = WNR_ERROR_GENERAL;
  cmp_ctx_t cmp;
  CMP_INIT(&cmp, NULL, 0);

  netsrc_state *state = (netsrc_state*)net_ctx->state;

  assert(net_ctx->client_id);
  CHECK(data_len <= UINT32_MAX
      && data_len + sizeof(msg_type) + sizeof(msg_number) <= SIZE_MAX,
    "Too much data to HMAC"); // otherwise will be too long for hmac hash
  CHECK(hmac_buf_len >= HMAC_LEN, "HMAC buffer too small");

  // fetch HMAC key
  unsigned char *hmac_key;
  size_t hmac_key_len;
  CHECK(net_ctx->get_key((instream_default*)net_ctx, net_ctx->client_id,
      &hmac_key, &hmac_key_len) == WNR_ERROR_NONE
    && hmac_key && hmac_key_len > 0,
    "Failed to fetch HMAC key");

  CHECK(cmp_write_array(&cmp, 3), "cmp_write_array() error");
  CHECK(cmp_write_uint(&cmp, msg_type), "cmp_write_uint() error");
  CHECK(cmp_write_uint(&cmp, msg_number), "cmp_write_uint() error");
  CHECK(cmp_write_bin(&cmp, data, (uint32_t)data_len), "cmp_write_bin() error");

  if (!state->md_ctx.md_info) {
    const mbedtls_md_info_t *md_info = mbedtls_md_info_from_type(MBEDTLS_MD_SHA256);
    assert(HMAC_LEN == (uint8_t)mbedtls_md_get_size(md_info));
    mbedtls_md_init(&state->md_ctx);
    CHECK(mbedtls_md_setup(&state->md_ctx, md_info, 1) == 0, "mbedtls_md_setup() error");
    CHECK(mbedtls_md_hmac_starts(&state->md_ctx, hmac_key, hmac_key_len) == 0,
      "mbedtls_md_hmac_starts() error");
  } else {
    CHECK(mbedtls_md_hmac_reset(&state->md_ctx) == 0, "mbedtls_md_hmac_reset() error");
  }

  CHECK(mbedtls_md_hmac_update(&state->md_ctx, ((cmp_buf*)cmp.buf)->buf,
      ((cmp_buf*)cmp.buf)->buf_size) == 0,
    "mbedtls_md_hmac_update() error");
  CHECK(mbedtls_md_hmac_finish(&state->md_ctx, hmac_buf) == 0, "mbedtls_md_hmac_finish() error");

  ret = WNR_ERROR_NONE;
cleanup:
  CMP_CLOSE(&cmp);
  return ret;
}

/**
 * message format:
 * string: magic,
 * bytes[32]: HMAC (SHA256) of msg type, msg number, msg data
 * uint8: message type,
 * uint64: message number,
 * bytes[]: message data (format specific to message type),
 */
static size_t
_wnr_construct_message(instream_network *net_ctx, wnr_msg_type msg_type,
  unsigned char *data, size_t data_len, unsigned char **out)
{
  assert(msg_type <= UINT8_MAX);
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  size_t ret = 0;
  cmp_ctx_t cmp;
  CHECK(data_len <= UINT32_MAX, "Message too long");
  CHECK(CMP_INIT(&cmp, NULL, 0), "CMP_INIT() error");
  CHECK(cmp_write_array(&cmp, 5), "cmp_write_array() error");
  CHECK(cmp_write_str(&cmp, WNR_MSG_MAGIC, strlen(WNR_MSG_MAGIC)),
    "cmp_write_str() error");
  CHECK(cmp_write_bin_marker(&cmp, HMAC_LEN), "cmp_write_bin_marker() error");
  size_t hmac_pos = ((cmp_buf*)cmp.buf)->buf_size;
  CHECK(wnr_cmp_writer(&cmp, NULL, HMAC_LEN) > 0, "Message writing error"); // zero-pad space for HMAC
  CHECK(cmp_write_uint(&cmp, msg_type), "cmp_write_uint() error");
  CHECK(cmp_write_uint(&cmp, state->client_msg_number), "cmp_write_uint() error");
  CHECK(cmp_write_bin(&cmp, data, (uint32_t)data_len), "cmp_write_bin() error");

  CHECK(_wnr_hmac_message(net_ctx, msg_type, state->client_msg_number,
      data, data_len,
      ((cmp_buf*)cmp.buf)->buf + hmac_pos, HMAC_LEN) == WNR_ERROR_NONE,
    "Failed to HMAC message");
// JUNK!

#define LWS_SEND_BUFFER_PRE_PADDING 12
#define LWS_SEND_BUFFER_POST_PADDING 1
// END OF JUNK
  *out = (unsigned char*)malloc(((cmp_buf*)cmp.buf)->buf_size
    + LWS_SEND_BUFFER_PRE_PADDING + LWS_SEND_BUFFER_POST_PADDING);
  CHECK_MEM(*out);
  memcpy(*out + LWS_SEND_BUFFER_PRE_PADDING, ((cmp_buf*)cmp.buf)->buf, ((cmp_buf*)cmp.buf)->buf_size);

  ret = ((cmp_buf*)cmp.buf)->buf_size;
cleanup:
  CMP_CLOSE(&cmp);
  return ret;
}

static size_t
_wnr_construct_message_hello(instream_network *net_ctx, unsigned char **out)
{
  size_t ret = _wnr_construct_message(net_ctx, WNR_MSG_CLIENT_HELLO,
    (unsigned char*)net_ctx->client_id, strlen(net_ctx->client_id), out);
  if (ret == 0)
    LOGERROR("Error constructing client hello message");
  return ret;
}

static size_t
_wnr_construct_message_data_request(instream_network *net_ctx, unsigned char **out)
{
  size_t ret = 0;
  cmp_ctx_t cmp;
  netsrc_state *state = (netsrc_state*)net_ctx->state;

  // if buf_filled + total bytes requested below threshold, request number of additional bytes to fill up buffer
  CHECK(net_ctx->_header.buf_filled + state->bytes_requested <= net_ctx->_header.threshold,
    "No need to request more entropy");

  uint32_t bytes_to_request = net_ctx->_header.buf_size - net_ctx->_header.buf_filled - state->bytes_requested;

  // If need to re-key for AES encryption, request some additional entropy
  if (!state->aes_ctx.initialized)
    bytes_to_request += 16 + 8 + 1; // 16-byte AES key, 8-byte nonce, 1-byte re-key interval
  else if (state->aes_ctx.rekey_counter >= state->aes_ctx.rekey_interval)
    bytes_to_request += 16 + 1; // 16-byte AES key, 1-byte re-key interval (nonce already set)

  CHECK(CMP_INIT(&cmp, NULL, 0), "CMP_INIT() error");
  CHECK(cmp_write_uint(&cmp, bytes_to_request), "cmp_write_uint() error");
  ret = _wnr_construct_message(net_ctx, WNR_MSG_DATA_REQUEST, ((cmp_buf*)cmp.buf)->buf,
      ((cmp_buf*)cmp.buf)->buf_size, out);
  CHECK(ret > 0,
    "Error constructing entropy request message");

  state->bytes_requested += bytes_to_request;

cleanup:
  CMP_CLOSE(&cmp);
  return ret;
}

static int
_wnr_send_message(instream_network *net_ctx, wnr_message_constructor constructor)
{
  int ret = WNR_ERROR_GENERAL;
  unsigned char *msg = NULL;
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  size_t msg_len = constructor(net_ctx, &msg);
  CHECK(msg_len > 0 && msg, "Failed to construct message");
  int bytes_sent = 00; // libwebsocket_write(state->wnr_lws_wsi, msg + LWS_SEND_BUFFER_PRE_PADDING,
   // msg_len, LWS_WRITE_BINARY);
  CHECK(bytes_sent > 0, "Failed to write message to LWS socket");
  state->client_msg_number++;

  ret = WNR_ERROR_NONE;
cleanup:
  if (msg)
    free(msg);
  return ret;
}

static int
_wnr_handle_message_hello(instream_network *net_ctx, unsigned char *data,
  size_t data_len)
{
  int ret = WNR_ERROR_GENERAL;
  cmp_ctx_t cmp;
  CHECK(CMP_INIT(&cmp, data, data_len), "CMP_INIT() error");
  uint64_t page_size;
  CHECK(cmp_read_uinteger(&cmp, &page_size), "cmp_read_uinteger() error");
  // TODO do something with page size

  netsrc_state *state = (netsrc_state*)net_ctx->state;
  state->conn_state = netsrc_conn_state_STEADY;
  ret = WNR_ERROR_NONE;
cleanup:
  CMP_CLOSE(&cmp);
  return ret;
}

static int
_wnr_fill_from_urandom(unsigned char *buf, size_t buf_size)
{
  int fd = 0;
  int ret = WNR_ERROR_GENERAL;

  fd = _open(urandom_filename, O_RDONLY);
  CHECK(fd > 0, "Failed to open /dev/urandom for reading");
  ssize_t r = _read(fd, buf, buf_size);
  CHECK(r == buf_size, "Failed to read %d bytes from /dev/urandom", buf_size);

  ret = WNR_ERROR_NONE;
cleanup:
  if (fd > 0)
    _close(fd);
  return ret;
}

// set AES nonce (is static for remainder of process or until counter overflows)
static int
_wnr_reset_aes_nonce(instream_network *net_ctx, unsigned char **data, size_t *data_len)
{
  netsrc_state *state = (netsrc_state*)net_ctx->state;

  CHECK(*data_len > 8, // 8-byte nonce
    "Did not receive enough entropy to calculate AES nonce");

  memset(state->aes_ctx.nonce_counter, 0, 16);
  memset(state->aes_ctx.stream_block, 0, 16);
  state->aes_ctx.nc_off = 0;

  unsigned char random_nonce[8] = {0};
  CHECK(_wnr_fill_from_urandom(random_nonce, 8) == WNR_ERROR_NONE,
    "Failed to generate random AES nonce");

  // XOR random nonce with 8 bytes of network entropy
  for (int i = 0; i < 8; i++)
    state->aes_ctx.nonce_counter[i] = random_nonce[i] ^ (*data)[i];
  *data_len -= 8;
  *data += 8;

  return WNR_ERROR_NONE;
cleanup:
  return WNR_ERROR_GENERAL;
}

static int
_wnr_aes_rekey(instream_network *net_ctx, unsigned char **data, size_t *data_len)
{
  netsrc_state *state = (netsrc_state*)net_ctx->state;

  CHECK(*data_len > 16 + 1,
    "Did not receive enough entropy to generate 128-bit AES key and re-key interval");

  if (!state->aes_ctx.initialized) {
    CHECK(mbedtls_aes_self_test(0) == 0, "mbedTLS AES self test failed, aborting");
    mbedtls_aes_init(&state->aes_ctx.mbedtls_ctx);
  }

  unsigned char random_buf[16] = {0};
  CHECK(_wnr_fill_from_urandom(random_buf, 16) == WNR_ERROR_NONE,
    "_wnr_fill_from_urandom() error");

  // XOR current key with buffer from /dev/urandom and network data
  for (int i = 0; i < 16; i++)
    state->aes_ctx.key[i] = state->aes_ctx.key[i] ^ random_buf[i] ^ (*data)[i];
  *data += 16;
  *data_len -= 16;

  CHECK(mbedtls_aes_setkey_enc(&state->aes_ctx.mbedtls_ctx, state->aes_ctx.key, 16 * 8) == 0,
    "Failed to set new AES key");

  // use another byte to set re-key interval
  unsigned char random_char[1] = {0};
  CHECK(_wnr_fill_from_urandom(random_char, 1) == WNR_ERROR_NONE,
    "_wnr_fill_from_urandom() error");
  state->aes_ctx.rekey_interval =
    (uint8_t)(state->aes_ctx.rekey_interval ^ random_char[0] ^ (*data)[0]);
  *data += 1;
  *data_len -= 1;

  state->aes_ctx.rekey_counter = 0;
  state->aes_ctx.initialized = true;
  return WNR_ERROR_NONE;
cleanup:
  return WNR_ERROR_GENERAL;
}

static int
_wnr_handle_message_data(instream_network *net_ctx, unsigned char *data,
  size_t data_len)
{
  netsrc_state *state = (netsrc_state*)net_ctx->state;

  int ret = WNR_ERROR_GENERAL;
  unsigned char *buf = NULL;

  CHECK(net_ctx->_header.buf_filled < net_ctx->_header.buf_size,
    "Network entropy source buffer already full");

  // reset AES nonce if AES context not initialized or counter overflow
  bool counter_overflow = (memcmp(state->aes_ctx.nonce_counter + 8, "\xff\xff\xff\xff\xff\xff\xff\xff", 8) == 0)
    ? true : false;
  if (counter_overflow)
    LOGINFO("AES counter overflow, forcing reset of nonce");
  if (!state->aes_ctx.initialized || counter_overflow) {
    CHECK(_wnr_reset_aes_nonce(net_ctx, &data, &data_len) == WNR_ERROR_NONE,
      "Failed to reset AES nonce");
  }

  // LOGINFO("counter / interval: %d / %d", aes_ctx.rekey_counter, aes_ctx.rekey_interval);
  // If needed, re-key (or generate first key)
  if (!state->aes_ctx.initialized || state->aes_ctx.rekey_counter >= state->aes_ctx.rekey_interval) {
    LOGINFO("Re-keying network entropy source encryption");
    CHECK(_wnr_aes_rekey(net_ctx, &data, &data_len) == WNR_ERROR_NONE,
      "Failed to re-key for network entropy AES encryption");
  }

  CHECK(data_len > 0, "No data left to fill entropy buffer");

  uint32_t bytes_to_copy = (data_len < net_ctx->_header.buf_size - net_ctx->_header.buf_filled)
    ? data_len : net_ctx->_header.buf_size - net_ctx->_header.buf_filled;

  // AES encrypt received entropy
  buf = (unsigned char*)malloc(bytes_to_copy);
  CHECK_MEM(buf);
  memcpy(buf, data, bytes_to_copy);
  CHECK(mbedtls_aes_crypt_ctr(&state->aes_ctx.mbedtls_ctx, bytes_to_copy,
      &state->aes_ctx.nc_off, state->aes_ctx.nonce_counter, state->aes_ctx.stream_block, buf,
      net_ctx->_header.buf + net_ctx->_header.buf_filled) == 0,
    "Failed to encrypt received entropy");

  net_ctx->_header.buf_filled += bytes_to_copy;
  state->bytes_requested = (bytes_to_copy < state->bytes_requested)
    ? state->bytes_requested - bytes_to_copy : 0;

  if (state->bytes_requested == 0)
    state->conn_state = netsrc_conn_state_STEADY;

  state->aes_ctx.rekey_counter++;

  ret = WNR_ERROR_NONE;
cleanup:
  if (buf)
    free(buf);
  return ret;
}

static int
_wnr_handle_message(instream_network *net_ctx, void *msg, size_t msg_len)
{
  int ret = WNR_ERROR_GENERAL;
  cmp_ctx_t cmp;
  CHECK(CMP_INIT(&cmp, msg, msg_len), "CMP_INIT() error");

  netsrc_state *state = (netsrc_state*)net_ctx->state;

#ifdef WNR_DEBUG
  if (_minlvl >= DEBUG) {
    LOGDEBUG("Received message from server:");
    hexdump(msg, msg_len);
  }
#endif

  // parse message fields
  uint32_t array_size;
  CHECK(cmp_read_array(&cmp, &array_size) && array_size == 5,
    "cmp_read_array() error");
  char magic[sizeof(WNR_MSG_MAGIC)] = {0};
  uint32_t str_size = sizeof(WNR_MSG_MAGIC);
  CHECK(cmp_read_bin(&cmp, magic, &str_size), "cmp_read_bin() error");
  CHECK(memcmp(magic, WNR_MSG_MAGIC, sizeof(WNR_MSG_MAGIC) - 1) == 0,
    "Invalid magic field");
  uint32_t hmac_len;
  CHECK(cmp_read_bin_size(&cmp, &hmac_len), "cmp_read_bin_size() error");
  CHECK(hmac_len == HMAC_LEN, "Received invalid HMAC length %d != %d", hmac_len, HMAC_LEN);
  unsigned char *hmac = ((cmp_buf*)cmp.buf)->buf + ((cmp_buf*)cmp.buf)->pos;
  CHECK(wnr_cmp_reader(&cmp, NULL, hmac_len), "Message reading error"); // move ((cmp_buf*)cmp.buf)->pos foward
  uint64_t message_type;
  CHECK(cmp_read_uinteger(&cmp, &message_type), "cmp_read_uinteger() error");
  uint64_t message_number;
  CHECK(cmp_read_uinteger(&cmp, &message_number), "cmp_read_uinteger() error");
  uint32_t data_len;
  CHECK(cmp_read_bin_size(&cmp, &data_len), "cmp_read_bin_size() error");
  unsigned char *data = ((cmp_buf*)cmp.buf)->buf + ((cmp_buf*)cmp.buf)->pos;

  // validate HMAC
  unsigned char my_hmac[HMAC_LEN] = {0};
  CHECK(_wnr_hmac_message(net_ctx, message_type, message_number, data,
      data_len, my_hmac, HMAC_LEN) == WNR_ERROR_NONE,
    "Failed to HMAC message data");
  CHECK(memcmp(hmac, my_hmac, HMAC_LEN) == 0, "Received invalid HMAC");

  // check message number
  CHECK(message_number == state->server_msg_number,
    "Received invalid message number from server");
  state->server_msg_number++;

  // handle message data
  switch (message_type) {
    case WNR_MSG_SERVER_HELLO:
      CHECK(state->conn_state == netsrc_conn_state_EXPECT_HELLO,
        "Received unexpected hello message from server");
      CHECK(_wnr_handle_message_hello(net_ctx, data, data_len) == WNR_ERROR_NONE,
        "Failed to handle hello message from server");
        break;
    case WNR_MSG_DATA_DELIVERY:
      CHECK(state->conn_state == netsrc_conn_state_EXPECT_DATA,
        "Received unexpected data from server");
      CHECK(_wnr_handle_message_data(net_ctx, data, data_len) == WNR_ERROR_NONE,
        "Failed to handle data sent from server");
        break;
    default:
      LOGERROR("Received invalid message type from server: %d", message_type);
      goto cleanup;
  }

  ret = WNR_ERROR_NONE;
cleanup:
  CMP_CLOSE(&cmp);
  return ret;
}
  
//struct libwebsocket_pollfd  pfd;

static int
_wnr_netsrc_poll_cb(wnr_context *ctx, int fd, int revents, void *data)
{
  instream_network *net_ctx = (instream_network*)data;
  assert(net_ctx);
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  assert(state);



  // libwebsocket_service_fd() handles any events, e.g. POLLIN|POLLOUT|POLLHUP
  // TODO check what the possible return codes are for this function
  if (state->wnr_lws_ctx)
  //  libwebsocket_service_fd(state->wnr_lws_ctx, &pfd);
  return WNR_ERROR_NONE;
}

static int _wnr_lws_callback(struct libwebsocket_context *lws_ctx,
                 struct libwebsocket *lws_wsi,
			           enum libwebsocket_callback_reasons reason,
					       void *user, void *in, size_t len)
{
 /* instream_network *net_ctx =
//    (instream_network*)libwebsocket_context_user(lws_ctx);
 // assert(net_ctx);
//  netsrc_state *state = (netsrc_state*)net_ctx->state;
 // assert(state);
  //struct libwebsocket_pollargs *pa = (struct libwebsocket_pollargs *)in;

  /*
  switch (reason) {
  //  case LWS_CALLBACK_ADD_POLL_FD:
  //    if (wnr_poll_add_socket(pa->fd, pa->events, _wnr_netsrc_poll_cb, (void*)net_ctx) != WNR_ERROR_NONE) {
  //      LOGERROR("Error adding LWS socket to event loop");
  //      return -1;
    //  }
      LOGINFO("Registered LWS socket with event loop");
      break;
   // case LWS_CALLBACK_DEL_POLL_FD:
   //   if (wnr_poll_remove_socket(pa->fd) != WNR_ERROR_NONE) {
    //    LOGERROR("Error removing LWS socket from event loop");
   //     return -1;
    //  }
    //  LOGINFO("Removed LWS socket from event loop");
    //  break;
  //  case LWS_CALLBACK_CHANGE_MODE_POLL_FD:
   ///   if (wnr_poll_modify_socket(pa->fd, pa->events, _wnr_netsrc_poll_cb, (void*)net_ctx) != WNR_ERROR_NONE) {
   //     LOGERROR("Error modifying LWS socket with event loop");
   //     return -1;
     // }
    //  break;
    case LWS_CALLBACK_CLIENT_ESTABLISHED:
      LOGINFO("LWS_CALLBACK_CLIENT_ESTABLISHED");
      assert(state->conn_state == netsrc_conn_state_INIT);
      state->reconnect_interval = 0;
      state->reconnect_attempts = 0;
      // request a callback for writing so we can send Hello message to server
 //     if (libwebsocket_callback_on_writable(lws_ctx, lws_wsi) == -1) {
  //      LOGERROR("libwebsocket_callback_on_writable() error");
        return -1;
      //}
      break;
    case LWS_CALLBACK_CLIENT_CONNECTION_ERROR:
      LOGINFO("LWS_CALLBACK_CLIENT_CONNECTION_ERROR");
      if (in)
        LOGINFO("LWS error string: %s", (char*)in);
      state->conn_state = netsrc_conn_state_CONN_ERROR;
      state->reconnect_attempts++;
      if (state->reconnect_attempts % 2 == 0) { // LWS_CALLBACK_CLIENT_CONNECTION_ERROR happens twice per failed reconnect attempt
        if (state->reconnect_interval == 0)
          state->reconnect_interval = 1;
        else if (state->reconnect_interval < WNR_NETSRC_MAX_RECONNECT_INTERVAL)
          state->reconnect_interval *= 2;
        LOGERROR("Error connecting to entropy server, trying again in %d seconds", state->reconnect_interval);
      }
      LOGINFO("Will try again in %d seconds", state->reconnect_interval);
      break;
    case LWS_CALLBACK_CLOSED:
      LOGINFO("LWS_CALLBACK_CLOSED");
      state->conn_state = netsrc_conn_state_CONN_ERROR;
      break;
    case LWS_CALLBACK_CLIENT_RECEIVE:
      LOGINFO("LWS_CALLBACK_CLIENT_RECEIVE");
      if(_wnr_handle_message(net_ctx, in, len) != WNR_ERROR_NONE) {
        LOGERROR("Failed to handle message from server");
        return -1;
      }
      break;
    case LWS_CALLBACK_CLIENT_WRITEABLE:
      // LOGINFO("LWS_CALLBACK_CLIENT_WRITEABLE");
      switch (state->conn_state) {
        case netsrc_conn_state_INIT:
          if (_wnr_send_message(net_ctx, _wnr_construct_message_hello) != WNR_ERROR_NONE) {
            LOGERROR("Failed to send hello message to server");
            return -1;
          }
          state->conn_state = netsrc_conn_state_EXPECT_HELLO;
          break;
        case netsrc_conn_state_STEADY:
        case netsrc_conn_state_EXPECT_DATA:
          if (state->request_entropy) {
            state->request_entropy = false;
            if (_wnr_send_message(net_ctx, _wnr_construct_message_data_request) != WNR_ERROR_NONE) {
              LOGERROR("Failed to send request for entropy");
              return -1;
            }
            state->conn_state = netsrc_conn_state_EXPECT_DATA;
          }
        default:
          break;
      }
      break;
    default:
      break;
  }
*/
	return WNR_ERROR_NONE;
}

static void
_wnr_netsrc_log(int level, const char *str)
{
  logerror(level, str);
}

instream_default *
wnr_netsrc_create(const char *client_id, const char *remote_addr,
  const char *remote_host, int port, const char *uri, wnr_hmac_key get_key,
  int max_reconnects, int buffer_size, int buffer_threshold)
{
  instream_network *net_ctx = (instream_network*)calloc(1, sizeof(instream_network));
  CHECK_MEM(net_ctx);
  net_ctx->_header.type = NETWORK;
  net_ctx->_header.buf = (unsigned char*)calloc(buffer_size, sizeof(unsigned char));
  CHECK_MEM(net_ctx->_header.buf);
  net_ctx->_header.buf_size = buffer_size;
  net_ctx->_header.buf_filled = 0;
  net_ctx->_header.threshold = buffer_threshold;
  net_ctx->_header.get_entropy = wnr_netsrc_get_entropy;
  net_ctx->_header.init = wnr_netsrc_init;
  net_ctx->_header.destroy = wnr_netsrc_destroy;

  net_ctx->client_id = _strdup(client_id);
  CHECK_MEM(net_ctx->client_id);
  net_ctx->remote_addr = _strdup(remote_addr);
  CHECK_MEM(net_ctx->remote_addr);
  net_ctx->remote_host = _strdup(remote_host);
  CHECK_MEM(net_ctx->remote_host);
  net_ctx->port = port;
  net_ctx->uri = _strdup(uri);
  CHECK_MEM(net_ctx->uri);
  net_ctx->get_key = get_key;
  net_ctx->max_reconnects = max_reconnects;

  netsrc_state *state = (netsrc_state*)calloc(1, sizeof(netsrc_state));
  CHECK_MEM(state);
  state->conn_state = netsrc_conn_state_PRE_INIT;
  net_ctx->state = (void*)state;

#ifndef WNR_DEBUG
 // lws_set_log_level(LLL_ERR | LLL_WARN, _wnr_netsrc_log);
#endif

  return (instream_default*)net_ctx;
cleanup:
  wnr_netsrc_destroy((instream_default*)net_ctx);
  return NULL;
}

int
wnr_netsrc_set_hmac_callback(instream_default *net_ctx, wnr_hmac_key get_key)
{
  ((instream_network*)net_ctx)->get_key = get_key;
  return WNR_ERROR_NONE;
}

// assumes all members of net_ctx (including _header members) have been already set
int
wnr_netsrc_init(instream_default *_net_ctx)
{
  int ret = WNR_ERROR_GENERAL;
  instream_network *net_ctx = (instream_network*)_net_ctx;
 // struct lws_context_creation_info lws_info; // = { 0 };
  assert(net_ctx);
  assert(net_ctx->_header.buf);
  assert(net_ctx->client_id);
  assert(net_ctx->remote_addr);
  assert(net_ctx->remote_host);
  assert(net_ctx->port);
  assert(net_ctx->uri);
  assert(net_ctx->get_key);
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  assert(state);

 


  return WNR_ERROR_NONE;
cleanup:
  wnr_netsrc_disconnect((instream_default*)net_ctx);
  return ret;
}

int wnr_netsrc_get_entropy(instream_default *_net_ctx)
{
  instream_network *net_ctx = (instream_network*)_net_ctx;
  assert(net_ctx);
  assert(net_ctx->_header.buf);
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  assert(state);
  if (state->conn_state == netsrc_conn_state_CONN_ERROR) {
    wnr_netsrc_disconnect((instream_default*)net_ctx);
  }
  if (state->conn_state == netsrc_conn_state_PRE_INIT) {
    //LOGWARN("Cannot fill network entropy source buffer, not connected to server");
    if (net_ctx->max_reconnects && state->reconnect_attempts > 2 * net_ctx->max_reconnects) {
      LOGERROR("Reached maximum number of reconnect attempts, giving up attempting to reconnect to entropy server");
      return WNR_ERROR_GENERAL;
    }
    struct timeval now;
    CHECK(gettimeofday(&now, NULL) == 0, "gettimeofday() error");
    if (now.tv_sec - state->last_reconnect >= state->reconnect_interval) {
      state->last_reconnect = now.tv_sec;
      LOGINFO("Attempting to reconnect to entropy server...");
      CHECK(wnr_netsrc_init((instream_default*)net_ctx) == WNR_ERROR_NONE,
        "Error initializing connection to entropy server");
    } else {
      return WNR_ERROR_WAIT;
    }
  }

  // First check if we need to request more entropy from server or not
  if (net_ctx->_header.buf_filled + state->bytes_requested < net_ctx->_header.threshold) {
    state->request_entropy = true;
  //  CHECK(libwebsocket_callback_on_writable(state->wnr_lws_ctx, state->wnr_lws_wsi) != -1,
 //     "libwebsocket_callback_on_writable() error");
  }

  return WNR_ERROR_NONE;
cleanup:
  return WNR_ERROR_GENERAL;
}

int
wnr_netsrc_disconnect(instream_default *_net_ctx)
{
  instream_network *net_ctx = (instream_network*)_net_ctx;
  if (!net_ctx)
    return WNR_ERROR_NONE;

  netsrc_state *state = (netsrc_state*)net_ctx->state;
  assert(state);

  state->client_msg_number = 0;
  state->server_msg_number = 0;

  if (state->wnr_lws_ctx) {
    //libwebsocket_context_destroy(state->wnr_lws_ctx);
    state->wnr_lws_ctx = NULL;
  }
  if (state->wnr_lws_protocols) {
    free(state->wnr_lws_protocols);
    state->wnr_lws_protocols = NULL;
  }
  state->wnr_lws_wsi = NULL;
  state->conn_state = netsrc_conn_state_PRE_INIT;
  return WNR_ERROR_NONE;
}

int
wnr_netsrc_destroy(instream_default *_net_ctx)
{
  instream_network *net_ctx = (instream_network*)_net_ctx;
  if (!net_ctx)
    return WNR_ERROR_NONE;
  netsrc_state *state = (netsrc_state*)net_ctx->state;
  if (state) {
    if (state->conn_state != netsrc_conn_state_PRE_INIT)
      wnr_netsrc_disconnect(_net_ctx);
    if (state->static_hmac_key)
      free(state->static_hmac_key);
    mbedtls_md_free(&state->md_ctx);
    free(state);
  }
  if (net_ctx->_header.buf)
    free(net_ctx->_header.buf);
  if (net_ctx->client_id)
    free(net_ctx->client_id);
  if (net_ctx->remote_addr)
    free(net_ctx->remote_addr);
  if (net_ctx->remote_host)
    free(net_ctx->remote_host);
  if (net_ctx->uri)
    free(net_ctx->uri);
  free(net_ctx);
  return WNR_ERROR_NONE;
}
