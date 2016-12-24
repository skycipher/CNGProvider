/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */
#include "stdafx.h"
#include "config_parse.h"
#include "networksource.h"
#include "filesource.h"
#ifdef WNR_QRNG
#include "qrngsource.h"
#endif
#include "drbg.h"
#include "utilities.h"
#include "internal.h"
#include "wnr.h"
#include <libconfig.h>
#include <string.h>

static instream_default *
_build_instream_struct(config_setting_t *instream)
{
    instream_default *rtnval = NULL;
    enum t_instream type;

    const char *type_str = NULL;
    config_setting_lookup_string(instream, "type", &type_str);

    CHECK(type_str, "Error parsing \"type\" for %s source.", instream->name);

    type = get_instream_enum(type_str);

    CHECK(type != -1, "Invalid %s type: %s.", instream->name, type_str);

    int buffer_size = 0;
    CHECK(config_setting_lookup_int(instream, "buffer_size", &buffer_size),
      "Must set buffer size for %s source.", instream->name);
    CHECK(buffer_size > 0,
      "Buffer size of input stream must be greater than 0 for %s source.", instream->name);

    int buffer_threshold = 0;
    CHECK(config_setting_lookup_int(instream, "buffer_threshold", &buffer_threshold),
      "Must set buffer threshold for %s source.", instream->name);
    CHECK(buffer_threshold > 0,
      "Buffer threshold of input stream must be greater than 0 for %s source.", instream->name);
    CHECK(buffer_size > buffer_threshold,
      "Buffer size must be greater than buffer threshold for %s source.", instream->name);

    switch (type) {
        case NETWORK:;
            const char *client_id = NULL;
            CHECK(config_setting_lookup_string(instream, "client_id", &client_id),
              "Must set network entropy source client_id");
            const char *address = NULL;
            const char *hostname = NULL;
            config_setting_lookup_string(instream, "address", &address);
            if (!config_setting_lookup_string(instream, "hostname", &hostname)) {
                CHECK(address != NULL,
                  "Must set network entropy source address");
                hostname = address;
            } else if (address == NULL) {
                address = hostname;
            }
            int port;
            CHECK(config_setting_lookup_int(instream, "port", &port),
              "Must set networn entropy source port");
            const char *uri = NULL;
            CHECK(config_setting_lookup_string(instream, "URI", &uri),
              "Must set networn entropy source URI");
            char *hmac_key = NULL;
            int static_key = config_setting_lookup_string(instream, "hmac_key", (const char**)&hmac_key);
            int max_reconnects;
            if (!config_setting_lookup_int(instream, "max_reconnects", &max_reconnects))
            {
              max_reconnects = 5; // default
            }
            wnr_hmac_key get_hmac_key = NULL;
            rtnval = wnr_netsrc_create(client_id, address, hostname,
                                       port, uri, get_hmac_key, max_reconnects,
                                       buffer_size, buffer_threshold);
            CHECK(rtnval, "Error creating network entropy source struct");
            if (static_key == CONFIG_TRUE) {
              unsigned char *hmac_key_bin = NULL;
              size_t hmac_key_bin_len;
              CHECK(base64_decode(hmac_key, strlen(hmac_key), &hmac_key_bin, &hmac_key_bin_len)
                  == WNR_ERROR_NONE,
                "Error base64 decoding static HMAC key");
              if (wnr_netsrc_set_static_hmac_key(rtnval, hmac_key_bin, hmac_key_bin_len)
                  != WNR_ERROR_NONE) {
                LOGERROR("Failed to set static HMAC key for instream source");
                free(hmac_key_bin);
                goto cleanup;
              }
              free(hmac_key_bin);
            }
            break;
        case FILEPATH:;
            const char *filepath = NULL;
            CHECK(config_setting_lookup_string(instream, "path", &filepath),
              "Must set file entropy source path");
            rtnval = wnr_filesrc_create(filepath, buffer_size, buffer_threshold);
            CHECK(rtnval, "Error creating file entropy source struct");
            break;
#ifdef WNR_QRNG
        case QRNG:;
            const char *instance_name = NULL;
            if (!config_setting_lookup_string(instream, "instance_name", &instance_name))
            {
                instance_name = "QRNG_DEFAULT";
            }
            rtnval = wnr_qrngsrc_create(instance_name, buffer_size, buffer_threshold);
            CHECK(rtnval, "Error creating QRNG entropy source struct");
            break;
#endif
        default:
            LOGERROR("Invalid entropy source specified");
            goto cleanup;
    }

    return rtnval;

cleanup:
    if (rtnval)
        rtnval->destroy(rtnval);
    return NULL;

}

static int
_wnr_parse_config(wnr_context *ctx, config_t *cfg)
{
    config_setting_t *seed;
    config_setting_t *stream;
    enum t_drbg type;
    const char *tmp;
    long long itmp;

    // NOTE: libconfig uses 1 as success and 0 as failure
    CHECK(config_lookup_string(cfg, "WnrClient.dir.working", &(tmp)),
          "Error parsing \"WnrClient.dir.working\".");
    ctx->working_dir = strdup(tmp);
    CHECK_MEM(ctx->working_dir);

    CHECK(config_lookup_string(cfg, "WnrClient.dir.socket", &(tmp)),
          "Error parsing \"WnrClient.dir.socket\".");
    ctx->socket_dir = strdup(tmp);
    CHECK_MEM(ctx->socket_dir);

    CHECK(config_lookup_string(cfg, "WnrClient.drbg.type", &(tmp)),
          "Error parsing \"WnrClient.drbg.spec\".");

    type = get_drbg_enum(tmp);

    switch(type) {
        case SHA256:
            ((wnr_drbg_context*)ctx->drbg_cfg)->drbg_type = WNR_DRBG_SHA256;
            break;
        default:
            LOGERROR("Invalid drbg type.");
            goto cleanup;
    }

    CHECK(config_lookup_int64(cfg, "WnrClient.drbg.reseed_interval", &(itmp)),
          "Error parsing \"WnrClient.drbg.reseed_rate\".");
    if (itmp <= 0) {
        LOGWARN(
            "DRBG reseed interval was less than 1. Set reseed interval to 1.");
        ((wnr_drbg_context*)ctx->drbg_cfg)->reseed_interval = 1;
    }
    else {
        ((wnr_drbg_context*)ctx->drbg_cfg)->reseed_interval = itmp;
    }

    if(config_lookup_int64(cfg, "WnrClient.drbg.security_strength", &(itmp))) {
        CHECK(itmp >= 0,
          "DRBG security strength must be greater than or equal to zero.");
        ((wnr_drbg_context*)ctx->drbg_cfg)->security_strength = itmp;
    }
    else {
        ((wnr_drbg_context*)ctx->drbg_cfg)->security_strength = 256;
    }

    if (config_lookup_int64(cfg, "WnrClient.buffer.size", &(itmp))) {
        CHECK(itmp <= MAXIMUM_ENTROPY_REQUEST && itmp >= 1024,
          "Entropy buffer size must be less than or equal to %d and greater "
          "than or equal to 1024",
          MAXIMUM_ENTROPY_REQUEST);
        ctx->_buf_size = itmp;
    }
    else {
        ctx->_buf_size = MAXIMUM_ENTROPY_REQUEST;
    }

    if (config_lookup_int64(cfg, "WnrClient.buffer.threshold", &(itmp))) {
        CHECK(itmp <= ctx->_buf_size && itmp > 0,
          "Entropy buffer threshold level must be less than or equal to "
          "entropy buffer size");
        ctx->_buf_threshold = itmp;
    }
    else {
        ctx->_buf_threshold = DEFAULT_ENTROPY_THRESHOLD;
    }

    if (config_lookup_int64(cfg, "WnrClient.polling.interval", &(itmp))) {
        CHECK(itmp <= MAXIMUM_POLLING_INTERVAL && itmp >= MINIMUM_POLLING_INTERVAL,
          "Polling interval must be at least 5 ms and at most 1 hour");
        ctx->poll_interval = itmp;
    }
    else {
        ctx->poll_interval = MINIMUM_POLLING_INTERVAL;
    }

    seed   = config_lookup(cfg, "WnrClient.source.seed");
    stream = config_lookup(cfg, "WnrClient.source.stream");
    CHECK(seed || stream, "Must configure at least one entropy source");

    if (seed) {
        ctx->seed_source   = _build_instream_struct(seed);
        CHECK(ctx->seed_source, "Failed to build seed entropy source");
        ctx->_generate_mode |= SEED_SOURCE;
    }
    if (stream) {
        ctx->stream_source = _build_instream_struct(stream);
        CHECK(ctx->stream_source, "Failed to build stream entropy source");
        ctx->_generate_mode |= STREAM_SOURCE;
    }

    return WNR_ERROR_NONE;

cleanup:
    return WNR_ERROR_GENERAL;
}

int
wnr_config_loadf(wnr_context *ctx, char *ctxfile)
{
    FILE *fp = NULL;

    fp = fopen(ctxfile, "r");
    CHECK(fp, "Error opening \"%s\": %s.", ctxfile, strerror(errno));

    CHECK(wnr_config_loadfp(ctx, fp) == WNR_ERROR_NONE,
      "Error parsing configuration file.");

    fclose(fp);

    return WNR_ERROR_NONE;

cleanup:
    if (fp) {
        fclose(fp);
    }
    return WNR_ERROR_GENERAL;
}


int
wnr_config_loadfp(wnr_context *ctx, FILE *fp)
{
    config_t cfg = {0};

    config_init(&cfg);

    CHECK(config_read(&cfg, fp),
          "Error reading configuration file \"%s:%d\" - %s.",
          config_error_file(&cfg),
          config_error_line(&cfg),
          config_error_text(&cfg));

    CHECK(_wnr_parse_config(ctx, &cfg) == WNR_ERROR_NONE,
      "Error parsing configuration file.");

    config_destroy(&cfg);

    return WNR_ERROR_NONE;

cleanup:
    config_destroy(&cfg);
    return WNR_ERROR_GENERAL;
}


int
wnr_config_loads(wnr_context *ctx, char *ctxstr)
{
    config_t cfg = {0};

    config_init(&cfg);

    CHECK(config_read_string(&cfg, ctxstr),
          "Error reading configuraton string at line %d: %s.",
          config_error_line(&cfg),
          config_error_text(&cfg));

    CHECK(_wnr_parse_config(ctx, &cfg) == WNR_ERROR_NONE,
      "Error parsing configuration text.");

    config_destroy(&cfg);

    return WNR_ERROR_NONE;

cleanup:
    config_destroy(&cfg);
    return WNR_ERROR_GENERAL;
}
