/* Copyright 2015-2016 Whitewood Encryption Systems, Inc. */
#include "stdafx.h"
#include "utilities.h"
#include "internal.h"
#include "logging.h"
#include "wnr.h"
#include <G:\!!SkyCipher\Clients\WhitewoodEncryption\Projects\netRandom\Code\SharedSourceCode\extern\mbedtls-2.2.1\include\mbedtls\base64.h>
#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

struct instream_parsenode  ipnarr[] = { INSTREAM_MKLIST(F_ARR) };
struct drbg_parsenode      dpnarr[] = { DRBG_MKLIST(F_ARR) };

void
hexdump(void *mem, unsigned int len)
{
  for(int i = 0;
      i < len + ((len % HEXDUMP_COLS) ? (HEXDUMP_COLS - len % HEXDUMP_COLS) : 0);
      i++) {
    /* print offset */
    if(i % HEXDUMP_COLS == 0)
      printf("0x%06x:\t", i);

    /* print hex data */
    if(i < len)
      printf("%02x ", 0xFF & ((char*)mem)[i]);
    else /* end of block, just aligning for ASCII dump */
      printf("  ");
    if(i % 8 == 7)
      putchar(' ');

    /* print ASCII dump */
    if(i % HEXDUMP_COLS == (HEXDUMP_COLS - 1)) {
      printf("\t");
      for(int j = i - (HEXDUMP_COLS - 1); j <= i; j++) {
        if(j >= len) /* end of block, not really printing */
          putchar(' ');
        else if(isprint(((char*)mem)[j])) /* printable char */
          putchar(0xFF & ((char*)mem)[j]);
        else /* other char */
          putchar('.');
        if(j % 8 == 7)
          putchar(' ');
      }
      putchar('\n');
    }
  }
}

int
base64_decode(char *in, size_t in_len, unsigned char **out, size_t *out_len)
{
  unsigned char *out_buf = NULL;
  CHECK(mbedtls_base64_self_test(0) == 0, "mbedTLS base64 self test failed, aborting");
  *out_len = 0;
  mbedtls_base64_decode(NULL, 0, out_len, (unsigned char*)in, in_len);
  CHECK(*out_len > 0, "mbedtls_base64_decode() error");
  out_buf = (unsigned char*)malloc(*out_len);
  CHECK_MEM(out_buf);
  CHECK(mbedtls_base64_decode(out_buf, *out_len, out_len, (unsigned char*)in, in_len) == 0,
    "mbedtls_base64_decode() error");
  *out = out_buf;
  return WNR_ERROR_NONE;
cleanup:
  if (out_buf)
    free(out_buf);
  return WNR_ERROR_GENERAL;
}

char* get_exec_name(char *lname)
{
    int i = 0;
    size_t len = strlen(lname);

    while (lname[len - i] != '/') {
        i++;
    }

    return lname + (len - i + 1);
}

int recursive_mkdir(char *path)
{
    char *p   = NULL;
    size_t len;

    if (path == NULL) {
        LOGERROR("Error parsing path '%s': %s.\n",
                path, strerror(errno));
        return 1;
    }

    len = strlen(path);

    // delete last '/' if exists
    if (path[len - 1] == '/') {
        path[len - 1] = 0;
    }

    // create each directory from in the path
    for (p = path + 1; *p != 0; p++) {
        if (*p == '/') {
            *p = 0;
            if ((_mkdir(path, S_IRWXU) != 0) && (errno != EEXIST)) {
                LOGERROR("Error creating file path '%s'.\n", path);
                return 1;
            }
            *p = '/';
        }
    }

    if ((_mkdir(path, S_IRWXU) != 0) && (errno != EEXIST)) {
        LOGERROR("Error creating file path '%s'.\n", path);
        return 1;
    }

    return WNR_ERROR_NONE;
}

enum t_instream get_instream_enum(const char *instream) {
    for (int i = 0; i < sizeof(ipnarr)/sizeof(ipnarr[0]); i++) {
        if (strcmp(instream, ipnarr[i].str) == 0) {
            return ipnarr[i].tis;
        }
    }

    return -1;
}

enum t_drbg get_drbg_enum(const char *drbg) {
    for (int i = 0; i < sizeof(dpnarr)/sizeof(dpnarr[0]); i++) {
        if (strcmp(drbg, dpnarr[i].str) == 0) {
            return dpnarr[i].tdrbg;
        }
    }

    return (t_drbg )-1;
}


char* get_instream_str(enum t_instream type)
{
    if (type <= sizeof(ipnarr)/sizeof(ipnarr[0])) {
        return ipnarr[type].str;
    }
    return NULL;
}

void cpuid (cpuid_t *info, unsigned int leaf, unsigned int subleaf)
{
    __asm__ volatile("cpuid"
    : "=a" (info->eax), "=b" (info->ebx), "=c" (info->ecx), "=d" (info->edx)
    : "a" (leaf), "c" (subleaf)
    );
}

bool
wnr_cmp_init(cmp_ctx_t *ctx, void *buf, size_t buf_size, cmp_reader read, cmp_writer write)
{
  ctx->error = 0;
  if (buf && buf_size > 0) {
    cmp_buf *cmpbuf = (cmp_buf*)calloc(1, sizeof(cmp_buf) + buf_size - 1);
    if (!cmpbuf)
      return false;
    cmpbuf->buf_size = buf_size;
    memcpy(cmpbuf->buf, buf, buf_size);
    ctx->buf = (void*)cmpbuf;
  } else {
    ctx->buf = NULL;
  }
  ctx->read = read;
  ctx->write = write;
  return true;
}

bool
wnr_cmp_reader(cmp_ctx_t *ctx, void *data, size_t limit) {
  cmp_buf *buf = (cmp_buf*)ctx->buf;
  assert(buf);
  size_t read_len = (buf->buf_size - buf->pos > limit) ? limit : buf->buf_size - buf->pos;
  if (read_len == 0)
    return false;
  if (data) // if data == NULL, just move pos forward
    memcpy(data, (uint8_t*)buf->buf + buf->pos, read_len);
  buf->pos += read_len;
  return true;
}

size_t
wnr_cmp_writer(cmp_ctx_t *ctx, const void *data, size_t count) {
  if (count == 0)
    return 0;
  cmp_buf *buf = (cmp_buf*)ctx->buf;
  if (buf) {
    buf = (cmp_buf*)realloc(buf, sizeof(cmp_buf) + buf->buf_size - 1 + count);
  } else {
    buf = (cmp_buf*)realloc(buf, sizeof(cmp_buf) + count - 1);
    memset(buf, 0, sizeof(cmp_buf) + count - 1);
  }
  if (!buf)
    return 0;
  ctx->buf = buf;
  if (data)
    memcpy((uint8_t*)buf->buf + buf->buf_size, data, count);
  else
    memset((uint8_t*)buf->buf + buf->buf_size, 0, count);
  buf->buf_size += count;
  return count;
}


int wnr_pack_bits(uint8_t *dest, uint8_t *in, int bit_offset, int numbits_in)
{
    int dest_boundry_offset = bit_offset % 8;   // Offset from byte boundry
    int dest_num_bytes      = bit_offset / 8;   // Number of whole bytes
    uint8_t *buf = dest + dest_num_bytes;
    uint8_t tmp;

    if (dest_boundry_offset == 0) {
        // Simply copy all of in to the desitination.
        memcpy(buf, in, (numbits_in+7)/8);
    }
    else {
        for (int i = 0; i < (numbits_in+7)/8; i++) {
            // Copy in[i] bits dest_boundry_offset -> 8 to
            //   next byte boundry in dest
            buf[i+1] = in[i] << (8 - dest_boundry_offset);

            // Copy in[i] bits 0 -> 8 - dest_boundry_offset to
            //   buf[i] bits dest_boundry_offset -> 8
            buf[i] &= ((1 << dest_boundry_offset) - 1) <<  // Zero end of byte
                      (8 - dest_boundry_offset);   //   to prep for copy
            buf[i] |= in[i] >> dest_boundry_offset;     // Copy rest of byte
        }
    }

    return WNR_ERROR_NONE;
}


int wnr_binstr_add(uint8_t *astr, uint8_t *bstr, uint8_t *outstr,
                   int nbits_astr, int nbits_bstr, int nbits)
{
    uint8_t *a = NULL;
    uint8_t *b = NULL;
    int free_a = 0;
    int free_b = 0;

    if (nbits_astr < nbits) {
        // Zero pad left
        a =(uint8_t *) calloc((nbits+7)/8, sizeof(uint8_t)); // TODO check calloc return, free memory
        wnr_pack_bits(a, astr, nbits - nbits_astr, nbits_astr);
        free_a = 1;
    }
    else {
        a = astr;
    }

    if (nbits_bstr < nbits) {
        // Zero pad left
        b = (uint8_t *)calloc((nbits+7)/8, sizeof(uint8_t)); // TODO check calloc return, free memory
        wnr_pack_bits(b, bstr, nbits - nbits_bstr, nbits_bstr);
        free_b = 1;
    }
    else {
        b = bstr;
    }

    int carry = 0;
    int sum = 0;

    for (int i = ((nbits+7)/8) - 1; i >= 0; i--) {
        sum = a[i] + b[i] + carry;
        outstr[i] = sum & 0xFF;
        carry = sum >> 8;
    }

    if (free_a) {
        free(a);
    }
    if (free_b) {
        free(b);
    }

    return 0;
}

/**
 * Reverse byte order of instr if running on a little endian system.
 *
 * @param   instr   Input buffer.
 * @param   outstr  Output buffer.
 * @param   size    Size of instr and outstr.
 *
 * @return WNR_ERROR_NONE on success.
 * @return WNR_ERROR_GENERAL on error.
 */
int wnr_binstr_endian(uint8_t *instr, uint8_t *outstr, int size) {
    int x = 1;
    uint8_t *y = (uint8_t *)&x;

    // If little endian, reverse string
    if (*y == 1) {
        for (int i = 0; i < size; i++) {
            outstr[i] = instr[size-1-i];
        }
    }
    else {
        memcpy(outstr, instr, size);
    }

    return 0;
}
