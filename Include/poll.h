/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

#ifndef WNR_POLL_H
#define WNR_POLL_H

#include "internal.h"

#define MAX_EVENTS      20
#define POLL_TIMEOUT    5

typedef int (*wnr_poll_cb)(wnr_context *ctx, int fd, int revents, void *data);

#ifdef __cplusplus
extern "C" {
#endif

int wnr_poll_add_socket(int fd, int events, wnr_poll_cb callback, void *data);
int wnr_poll_modify_socket(int fd, int events, wnr_poll_cb callback, void *data);
int wnr_poll_remove_socket(int fd);

#ifdef __cplusplus
}
#endif
#endif
