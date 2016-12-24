/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

#ifndef WNR_INTERNAL_H
#define WNR_INTERNAL_H

#define WNR_CTX_INTERNAL
#include "..\Include\logging.h"
#include <errno.h>
#include <stddef.h>
#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif

#define WNR_LOG(L, M, ...) logerror(L, "(%s:%d) " M "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#define LOGDEBUG(M, ...) WNR_LOG(DEBUG, M, ##__VA_ARGS__)
#define LOGINFO(M, ...) WNR_LOG(INFO, M, ##__VA_ARGS__)
#define LOGWARN(M, ...) WNR_LOG(WARNING, M, ##__VA_ARGS__)
#define LOGERROR(M, ...) WNR_LOG(ERROR, M, ##__VA_ARGS__)
#define LOGCRIT(M, ...) WNR_LOG(CRITICAL, M, ##__VA_ARGS__)
#define CHECK(A, M, ...) do { if(!(A)) { LOGERROR(M, ##__VA_ARGS__); errno=0; goto cleanup; } } while(0)
#define CHECK_MEM(A) CHECK((A), "Memory allocation error.")
#define CHECK_ERR(A, E, M, ...) do { if (!(A)) { LOGERROR(M, ##__VA_ARGS__); errno=0; ret=E; goto cleanup; } } while(0)

#define SEED_SOURCE    1
#define STREAM_SOURCE  2

#define MAXIMUM_ENTROPY_REQUEST       65536  // bytes (based on DRBG max_request_size - see drbg.c)
#define DEFAULT_ENTROPY_THRESHOLD     MAXIMUM_ENTROPY_REQUEST - 1024

// polling interval for main daemon loop in milliseconds
#define MINIMUM_POLLING_INTERVAL      5
#define MAXIMUM_POLLING_INTERVAL      3600000

#define WNR_CPP #ifdef __cplusplus \
extern "C" { \
#endif

#define WNR_CPP_END #ifdef __cplusplus \
} \
#endif

// START STR TO ENUM PARSING
#define F_ENUM(x) x,
#define F_ARR(x) {x, #x},

#define INSTREAM_MKLIST(f) \
    f(QRNG) f(NETWORK) f(RDRAND) f(FILEPATH)

enum t_instream { INSTREAM_MKLIST(F_ENUM) };

struct instream_parsenode
{
    enum t_instream tis;
    char *str;
};

extern struct instream_parsenode ipnarr[];

#define DRBG_MKLIST(f) \
    f(SHA256)

enum t_drbg { DRBG_MKLIST(F_ENUM) };

struct drbg_parsenode
{
    enum t_drbg tdrbg;
    char *str;
};

extern struct drbg_parsenode dpnarr[];
// END STR TO ENUM PARSING

typedef struct _wnr_drbg_context wnr_drbg_context;
typedef struct instream_default instream_default;
typedef int (*wnr_source_cb)(instream_default *source);

struct instream_default {
    enum t_instream type;
    unsigned char *buf;
    size_t buf_size;
    size_t buf_filled;
    size_t threshold;
    wnr_source_cb get_entropy;
    wnr_source_cb init;
    wnr_source_cb destroy;
};

typedef struct wnr_context {
    char *working_dir;
    char *socket_dir;
    wnr_drbg_context *drbg_cfg;
    instream_default *seed_source;
    instream_default *stream_source;
    char *_buf;
    size_t _buf_size;
    size_t _buf_threshold;
    size_t _buf_filled;
    char _generate_mode;
    size_t poll_interval;
} wnr_context;

#endif
