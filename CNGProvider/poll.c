/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

#include "poll.h"
#include "logging.h"
#include "utilities.h"
#include "drbg.h"
#include "internal.h"
#include "wnr.h"
#include <G:\!!SkyCipher\Clients\WhitewoodEncryption\Projects\netRandom\Code\LIbs\cygepoll\sys/epoll.h>
#include "..\SharedSourceCode\sys.time.h"
#include <string.h>

static bool exit_requested = false;

typedef struct _wnr_poll_fd {
  int fd;
  int events;
  wnr_poll_cb poll_cb;
  void *data;

  struct _wnr_poll_fd *_next;
  struct _wnr_poll_fd *_prev;
} wnr_poll_fd;

// static int seed_nbytes_req;
// static int stream_nbytes_req;

int epoll_fd;
wnr_poll_fd *poll_fds;

int
wnr_poll_create(void)
{
  epoll_fd = epoll_create(1);
  if (epoll_fd <= 0) {
    LOGERROR("epoll_create() error");
    return WNR_ERROR_GENERAL;
  }
  return WNR_ERROR_NONE;
}

void
wnr_poll_destroy(void)
{
  wnr_poll_fd *wpfd = poll_fds;
  while (wpfd) {
    wnr_poll_fd *tmp = wpfd;
    wpfd = wpfd->_next;
    close(tmp->fd);
    free(tmp);
  }
  poll_fds = NULL;
}

int
wnr_poll_add_socket(int fd, int events, wnr_poll_cb callback, void *data)
{
  LOGINFO("Adding file descriptor %d to event loop", fd);
  wnr_poll_fd *wpfd = (wnr_poll_fd*)calloc(1,sizeof(wnr_poll_fd));
  if (!wpfd) {
    LOGERROR("calloc() error");
    return WNR_ERROR_GENERAL;
  }
  wpfd->fd = fd;
  wpfd->events = events;
  wpfd->poll_cb = callback;
  wpfd->data = data;

  if (poll_fds)
    poll_fds->_prev = wpfd;
  wpfd->_next = poll_fds;
  poll_fds = wpfd;

  struct epoll_event ev = {0};
  ev.data.ptr = (void*)wpfd;
  ev.events = events;
  if (epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fd, &ev) != 0) {
    LOGERROR("epoll_ctl() error");
    free(wpfd);
    return WNR_ERROR_GENERAL;
  }

  return WNR_ERROR_NONE;
}

int
wnr_poll_modify_socket(int fd, int events, wnr_poll_cb callback, void *data)
{
  // LOGINFO("Modifying file descriptor %d events to %d", fd, events);
  int ret = WNR_ERROR_GENERAL;
  for (wnr_poll_fd *wpfd = poll_fds; wpfd; wpfd = wpfd->_next) {
    if (wpfd->fd == fd) {
      if (events)
        wpfd->events = events;
      if (callback)
        wpfd->poll_cb = callback;
      if (data)
        wpfd->data = data;
      struct epoll_event ev = {0};
      ev.data.ptr = (void*)wpfd;
      ev.events = events;
      if (epoll_ctl(epoll_fd, EPOLL_CTL_MOD, fd, &ev) != 0)
        LOGERROR("epoll_ctl() error");
      else
        ret = WNR_ERROR_NONE;
      break;
    }
  }
  if (ret != WNR_ERROR_NONE)
    LOGWARN("Could not find file descriptor %d to modify, or error", fd);
  return ret;
}

int
wnr_poll_remove_socket(int fd)
{
  LOGINFO("Removing file descriptor %d from event loop", fd);
  int ret = WNR_ERROR_GENERAL;
  for (wnr_poll_fd *wpfd = poll_fds; wpfd; wpfd = wpfd->_next) {
    if (wpfd->fd == fd) {
      if (epoll_ctl(epoll_fd, EPOLL_CTL_DEL, fd, NULL) != 0)
        LOGERROR("epoll_ctl() error");
      else
        ret = WNR_ERROR_NONE;
      if (wpfd == poll_fds) {
        poll_fds = wpfd->_next;
        if (poll_fds)
          poll_fds->_prev = NULL;
      } else {
        if (wpfd->_next) {
          wpfd->_next->_prev = wpfd->_prev;
        }
        wpfd->_prev->_next = wpfd->_next;
      }
      free(wpfd);
      break;
    }
  }
  if (ret != WNR_ERROR_NONE)
    LOGWARN("Could not find file descriptor %d to remove", fd);
  return ret;
}

static int
wnr_process_source_entropy(wnr_context *ctx)
{
    int nbytes_needed;
    int nbytes_avail;
    int nbytes_req;
    int nbytes_rtnd;
    int error;
    uint8_t *fill_buf = NULL;

    wnr_drbg_context *dctx = (wnr_drbg_context*)ctx->drbg_cfg;


    // Check if we need to instantiate the DRBG
    if (ctx->seed_source && !dctx->instantiated) {
        error = wnr_drbg_init(dctx, NULL, 0);
        if (error == WNR_DRBG_ERROR_NOENT) {
            goto cleanup;
        }
        else if (error != WNR_DRBG_ERROR_NONE) {
            return WNR_ERROR_GENERAL;
        }
    }

    // If we need to fill up the buffer
    if (ctx->_buf_filled < ctx->_buf_size)
    {
        if (ctx->stream_source && ctx->seed_source) {
            nbytes_needed = ctx->_buf_size - ctx->_buf_filled;
            nbytes_avail = ctx->stream_source->buf_filled;
            nbytes_req = min(nbytes_needed, nbytes_avail);

            // Set pointer to top of main buffer to start filling
            fill_buf = (uint8_t*)(ctx->_buf + ctx->_buf_filled);

            // Generate DRBG data and fill up main buffer
            // If drbg generates less than requested, only mix that much
            error = dctx->generate_bytes(dctx, fill_buf, nbytes_req*8,
                                         dctx->security_strength,
                                         dctx->prediction_resistance,
                                         NULL, 0);
            if (error != WNR_DRBG_ERROR_NONE) {
              LOGDEBUG("Failed to generate entropy from seed source using DRBG");
              goto cleanup;
            }

            // XOR DRBG data with stream data
            for (int i = 0; i < nbytes_req; i++) {
                fill_buf[i] ^= ctx->stream_source->buf[nbytes_avail-i-1];
            }
            // Decrement stream pool size, and increment main pool size
            ctx->stream_source->buf_filled -= nbytes_req;
            ctx->_buf_filled += nbytes_req;

        }
        else if (ctx->seed_source) {
            nbytes_needed = ctx->_buf_size - ctx->_buf_filled;

            fill_buf = (uint8_t*)(ctx->_buf + ctx->_buf_filled);

            error = dctx->generate_bytes(dctx, fill_buf, nbytes_needed*8,
                                         dctx->security_strength,
                                         dctx->prediction_resistance,
                                         NULL, 0);

            CHECK(error == WNR_DRBG_ERROR_NONE,
              "Failed to generate entropy from seed source using DRBG");

            ctx->_buf_filled += nbytes_needed;
        }
        else if (ctx->stream_source) {
            nbytes_needed = ctx->_buf_size - ctx->_buf_filled;
            nbytes_avail = ctx->stream_source->buf_filled;
            nbytes_rtnd = min(nbytes_needed, nbytes_avail);

            fill_buf = (uint8_t*)(ctx->_buf + ctx->_buf_filled);

            for (int i = 0; i < nbytes_rtnd; i++) {
                fill_buf[i] = ctx->stream_source->buf[nbytes_avail-i];
            }
            ctx->stream_source->buf_filled -= nbytes_rtnd;
            ctx->_buf_filled += nbytes_rtnd;
        }
        else {
            LOGERROR("No seed or stream source found to process.");
            return WNR_ERROR_CONFIG;
        }
    }
    return WNR_ERROR_NONE;

cleanup:
    return WNR_ERROR_INSUFFICIENT_ENTROPY;
}

static int
wnr_poll_internal(wnr_context *ctx, int timeout, size_t threshold)
{
  if (ctx->_buf_filled >= threshold)
    return WNR_ERROR_NONE;

  struct timeval tv;
  CHECK(gettimeofday(&tv, NULL) == 0, "gettimeofday() error");
  uint64_t start_polling = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);

  struct epoll_event pevents[MAX_EVENTS];

  uint64_t now = 0;
  do {
    if (exit_requested) {
      LOGINFO("Exit requested");
      return 1;
    }

    // Check if seed or stream buffers need filled
    if (ctx->seed_source) {
      CHECK(ctx->seed_source->get_entropy(ctx->seed_source) != WNR_ERROR_GENERAL,
        "Error filling seed entropy source.");
    }
    if (ctx->stream_source) {
      CHECK(ctx->stream_source->get_entropy(ctx->stream_source) != WNR_ERROR_GENERAL,
        "Error filling stream entropy source.");
    }

    int n_events = epoll_wait(epoll_fd, pevents, MAX_EVENTS, POLL_TIMEOUT);
    CHECK(n_events >= 0, "Epoll error");

    if (n_events > 0) {
      for (int i = 0; i < n_events; i++) {
        wnr_poll_fd *wpfd = (wnr_poll_fd*)pevents[i].data.ptr;
        CHECK(wpfd->poll_cb(ctx, wpfd->fd, pevents[i].events, wpfd->data) == WNR_ERROR_NONE,
          "Poll callback error");
      }
    }

    if ((ctx->seed_source && !ctx->stream_source && ctx->seed_source->buf_filled > 0) ||
        (ctx->stream_source && !ctx->seed_source && ctx->stream_source->buf_filled > 0) ||
        (ctx->seed_source && ctx->stream_source && ctx->seed_source->buf_filled > 0 &&
          ctx->stream_source->buf_filled > 0)) {
      int ret = wnr_process_source_entropy(ctx);
      if (ret == WNR_ERROR_INSUFFICIENT_ENTROPY)
        LOGWARN("Error processing entropy from seed and stream sources");
    }

    CHECK(gettimeofday(&tv, NULL) == 0, "gettimeofday() error");
    now = (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
  } while (timeout > 0
      && now - start_polling < timeout
      && ctx->_buf_filled < threshold);

  if (ctx->_buf_filled < threshold) {
    LOGWARN("Failed to fill internal entropy buffer within timeout");
    return WNR_ERROR_INSUFFICIENT_ENTROPY;
  }

  return WNR_ERROR_NONE;
cleanup:
  return WNR_ERROR_GENERAL;
}

int
wnr_get_entropy(wnr_context *ctx, int timeout, unsigned char *buf,
  size_t buf_size, size_t needed_bytes)
{
  CHECK(needed_bytes <= buf_size, "Entropy buffer too small");
  CHECK(needed_bytes <= MAXIMUM_ENTROPY_REQUEST,
    "Requested too many bytes of entropy");
//  if (needed_bytes > ctx->_buf_size) {
//    LOGINFO("Increasing internal entropy buffer size to %d", needed_bytes);
//    ctx->_buf = realloc(ctx->_buf, needed_bytes);
//    CHECK_MEM(ctx->_buf);
//  }

  if (ctx->_buf_filled < needed_bytes) {
    // Run internal poll to wait for internal entropy buffer to fill up
    int ret = WNR_ERROR_NONE;
    if (timeout >= 0) {
      ret = wnr_poll_internal(ctx, timeout, needed_bytes);
    } else {
      while (ret == WNR_ERROR_NONE && ctx->_buf_filled < needed_bytes)
        ret = wnr_poll_internal(ctx, POLL_TIMEOUT, needed_bytes);
    }
    if (ret == WNR_ERROR_INSUFFICIENT_ENTROPY) {
      LOGWARN("Requested entropy from sources, but was unable to fill buffer"
        " within timeout");
      return ret;
    }
    CHECK(ret == WNR_ERROR_NONE && ctx->_buf_filled >= needed_bytes,
      "Error filling internal entropy buffer");
  }

  // Move bytes from internal entropy buffer to buf
  memcpy(buf, ctx->_buf, needed_bytes);
  size_t remaining_bytes = ctx->_buf_filled - needed_bytes;
  if (remaining_bytes > 0) {
    memmove(ctx->_buf, ctx->_buf + needed_bytes, remaining_bytes);
  }
  ctx->_buf_filled -= needed_bytes;

  return WNR_ERROR_NONE;
cleanup:
  return WNR_ERROR_GENERAL;
}

int
wnr_poll(wnr_context *ctx, int timeout)
{
  int ret = wnr_poll_internal(ctx, timeout, ctx->_buf_threshold);
  if (ret == WNR_ERROR_NONE || ret == WNR_ERROR_INSUFFICIENT_ENTROPY)
    return WNR_ERROR_NONE;
  return WNR_ERROR_GENERAL;
}

void
wnr_poll_stop(void)
{
  exit_requested = true;
}
