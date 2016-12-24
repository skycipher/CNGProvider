/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */

#ifndef UTILITIES_H_
#define UTILITIES_H_

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include "../Include/cmp.h"

#define HEXDUMP_COLS 16
#ifndef min
#define min(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b; })
#endif
#ifndef max
#define max(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a > _b ? _a : _b; })
#endif
#define CMP_INIT(A,B,C) wnr_cmp_init(A, B, C, wnr_cmp_reader, wnr_cmp_writer)
#define CMP_CLOSE(A) \
  do { \
    if (((cmp_ctx_t*)A)->buf) \
      free(((cmp_ctx_t*)A)->buf); \
  } while(0)

typedef struct _cmp_buf {
  size_t buf_size;
  size_t pos;
  unsigned char buf[1];
} cmp_buf;

typedef struct cpuid_struct {
    unsigned int eax;
    unsigned int ebx;
    unsigned int ecx;
    unsigned int edx;
} cpuid_t;

#ifdef __cplusplus
extern "C" {
#endif

void hexdump(void *mem, unsigned int len);
int base64_decode(char *in, size_t in_len, unsigned char **out, size_t *out_len);
int recursive_mkdir(char *path);
char* get_exec_name(char *lname);
enum t_instream get_instream_enum(const char *instream);
enum t_drbg get_drbg_enum(const char *drbg);
char* get_instream_str(enum t_instream type);
void cpuid (cpuid_t *info, unsigned int leaf, unsigned int subleaf);
bool wnr_cmp_init(cmp_ctx_t *ctx, void *buf, size_t buf_size, cmp_reader read, cmp_writer write);
bool wnr_cmp_reader(cmp_ctx_t *ctx, void *data, size_t limit);
size_t wnr_cmp_writer(cmp_ctx_t *ctx, const void *data, size_t count);
int wnr_pack_bits(uint8_t *dest, uint8_t *in, int bit_offset, int numbits_in);
int wnr_binstr_add(uint8_t *astr, uint8_t *bstr, uint8_t *outstr, 
                   int nbits_astr, int nbits_bstr, int nbits);
int wnr_binstr_endian(uint8_t *instr, uint8_t *outstr, int size);

#ifdef __cplusplus
}
#endif
#endif
