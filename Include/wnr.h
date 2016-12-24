/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

#ifndef WNR_H_
#define WNR_H_

#include <stdio.h>
#include <stdint.h>

#define WNR_ERROR_NONE                   0
#define WNR_ERROR_GENERAL               -1
#define WNR_ERROR_CONFIG                -2
#define WNR_ERROR_NETWORK               -3
#define WNR_ERROR_WAIT                  -4
#define WNR_ERROR_INSUFFICIENT_ENTROPY  -5

#ifndef WNR_CTX_INTERNAL
typedef void wnr_context;
typedef struct instream_default instream_default;
#endif

typedef int (*wnr_hmac_key)(instream_default *ctx, const char *client_id,
  unsigned char **key, size_t *key_len);

#ifdef __cplusplus
extern "C" {
#endif


/** Allocate and initilize internal memory for the wnr_context object.
 *
 * @param   ctx Context object for the WNR API.
 *
 * @return  WNR_ERROR_NONE on success.
 * @return  WNR_ERROR_GENERAL on error.
 *
 * @note Must be called before any other WNR API functions.
 */
int wnr_create(wnr_context **ctx);


/**
 * Load configuration from a file.
 *
 * @param   ctx     Context object for the WNR API.
 * @param   ctxfile Path of a file containing configuration information.
 *
 * @return  WNR_ERROR_NONE on success.
 * @return  WNR_ERROR_GENERAL on error.
 *
 * @note Must call wnr_create() before calling this function.
 */
int wnr_config_loadf(wnr_context *ctx, char *ctxfile);


/**
 * Load configuration from a file pointer.
 *
 * @param   ctx Context object for the WNR API.
 * @param   fp  File pointer to a file containing configuration information.
 *
 * @return  WNR_ERROR_NONE on success.
 * @return  WNR_ERROR_GENERAL on error.
 *
 * @note Must call wnr_create() before calling this function.
 */
int wnr_config_loadfp(wnr_context *ctx, FILE *fp);


/**
 * Load configuration from a string.
 *
 * @param   ctx    Context object for the WNR API.
 * @param   ctxstr String containing configuration information.
 *
 * @return  WNR_ERROR_NONE on success.
 * @return  WNR_ERROR_GENERAL on error.
 *
 * @note Must call wnr_create() before calling this function.
 */
int wnr_config_loads(wnr_context *ctx, char *ctxstr);


/**
 * Verify configuration struct and setup internal state.
 *
 * @param   ctx           Context object for the WNR API.
 * @param   hmac_callback Callback to supply network client HMAC key.
 *
 * @return  WNR_ERROR_NONE on success.
 * @return  WNR_ERROR_GENERAL on error.
 *
 * @note Must call one of the wnr_config_load*() functions before calling this
 *         function.
 */
int wnr_setup(wnr_context *ctx, wnr_hmac_key hmac_callback);


/** Creates/initializes the internal polling mechanism.
 *
 * @param   ctx     Context object for the WNR API.
 * @param   timeout       If timeout is > 0, block for up to that many
 *     milliseconds attempting to fill internal buffers with entropy. <br>
 *     If timeout == 0, return immediately. <br>
 *     If timeout == -1, block until internal buffers have been refilled.
 *
 * @return  WNR_ERROR_NONE on success.
 * @return  WNR_ERROR_GENERAL on error.
 *
 */
int wnr_poll_create(void);


/** Performs any necessary actions relating to setting up entropy source and
 *    filling the internal entropy buffer. Should be called from the main
 *    loop of the calling program.
 *
 * @param   ctx     Context object for the WNR API.
 * @param   timeout If timeout is > 0, block for up to that many milliseconds
 *    waiting for events. <br>
 *    If timeout == 0, return immediately if no events.
 *
 * @return  WNR_ERROR_NONE on success
 * @return  WNR_ERROR_GENERAL on error.
 *
 * @note Must call wnr_setup() and wnr_poll_create() before calling this
 *         function.
 */
int wnr_poll(wnr_context *ctx, int timeout);


/** Request entropy from the WNR library.
 *
 * @param   ctx           Context object for the WNR API.
 * @param   timeout       If timeout is > 0, block for up to that many
 *     milliseconds attempting to fill buffer with entropy. <br>
 *     If timeout == 0, return immediately. <br>
 *     If timeout == -1, block until requested bytes of entropy have been
 *             collected.
 * @param   buf           Pre-allocated buffer to fill with entropy.
 * @param   buf_size      Size of the pre-allocated buffer.
 * @param   needed_bytes  Number of bytes of entropy to put in buffer.
 *
 * @return  WNR_ERROR_NONE on success.
 * @return  WNR_ERROR_INSUFFICIENT_ENTROPY if not enough entropy was collected
 *              within the timeout.
 * @return WNR_ERROR_GENERAL on other error.
 *
 * @note Must call wnr_setup() with before calling this function.
 */
int wnr_get_entropy(wnr_context *ctx, int timeout, unsigned char *buf,
   size_t buf_size, size_t needed_bytes);


/** Request that the internal polling mechanism quit
 */
void wnr_poll_stop(void);


/** Clean up internal state, close all active file handles,
 *                 and deallocate the WNR context object.
 *
 * @param   ctx Context object for the WNR API.
 */
void wnr_destroy(wnr_context *ctx);


/**
 * wnr_poll_destroy() - Destroy internal polling mechanism
 *
 * NOTE: Must call wnr_destroy() before calling this function.
 */
void wnr_poll_destroy(void);



#ifdef __cplusplus
}
#endif
#endif
