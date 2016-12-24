/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

#ifndef WNR_NETWORKSOURCE_H
#define WNR_NETWORKSOURCE_H

#include "internal.h"

#define WEBSOCKET_FRAME_MAX_SIZE              2048
#define WEBSOCKET_KEEPALIVE_TIME              5
#define WEBSOCKET_KEEPALIVE_PROBES            5
#define WEBSOCKET_KEEPALIVE_INTERVAL          60
#define WNR_NETSRC_CONNECT_TIMEOUT            30      // timeout for connecting to entropy server
#define WNR_NETSRC_MAX_RECONNECT_INTERVAL     (1<<8)

typedef enum _wnr_msg_type {
  WNR_MSG_NOT_SET = 0,
  WNR_MSG_CLIENT_HELLO = 1,
  WNR_MSG_SERVER_HELLO = 2,
  WNR_MSG_DATA_REQUEST = 3,
  WNR_MSG_DATA_DELIVERY = 4,
  WNR_MSG_STAT_REQUEST = 5,
  WNR_MSG_STAT_DELIVERY = 6,
  WNR_MSG_ERROR = 7
} wnr_msg_type;

typedef int (*wnr_hmac_key)(instream_default *ctx, const char *client_id,
  unsigned char **key, size_t *key_len);

typedef struct _instream_network {
    instream_default _header;
    void *state;
    char *client_id;
    char *remote_addr;
    char *remote_host;
    int port;
    char *uri;
    wnr_hmac_key get_key;
    int max_reconnects;
} instream_network;

#ifdef __cplusplus
extern "C" {
#endif

instream_default *wnr_netsrc_create(
  const char *client_id,
  const char *remote_addr,
  const char *remote_host,
  int port,
  const char *uri,
  wnr_hmac_key get_key,
  int max_reconnects,
  int buffer_size,
  int buffer_threshold);

int wnr_netsrc_set_hmac_callback(instream_default *net_ctx, wnr_hmac_key get_key);

int wnr_netsrc_set_static_hmac_key(instream_default *net_ctx, unsigned char *key, size_t key_len);

/**
 * wnr_netsrc_init() - Connect to networked entropy source
 * @net_ctx: network source context pointer (should be initialized)
 *
 * Connects to Websockets entropy server.
 */
int wnr_netsrc_init(instream_default *net_ctx);

/** wnr_netsrc_get_entropy() - Retrieves entropy from networked entropy
*     server
* @net_ctx: network source context pointer
*
* Requests from network entropy source the number of bytes needed to fill
* internal entropy buffer. Non-blocking.
*/
int wnr_netsrc_get_entropy(instream_default *net_ctx);

/**
 * wnr_netsrc_disconnect() - Disconnect from networked entropy server
 * @net_ctx: network source context pointer
 */
int wnr_netsrc_disconnect(instream_default *net_ctx);

int wnr_netsrc_destroy(instream_default *net_ctx);

#ifdef __cplusplus
}
#endif
#endif
