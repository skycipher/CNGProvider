// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

#ifndef _HASHPROV_H_
#define _HASHPROV_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <malloc.h>
#include <windows.h>

//helper macros
#define MALLOC(X)   HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, (X));

#define FREE(X)     { if(X) { HeapFree(GetProcessHeap(), 0, X); X = NULL ; } }

#include <bcrypt.h>
#include <bcrypt_provider.h>
   
//
//constants
//

#define CHAR_TO_MAGIC(_a_, _b_, _c_, _d_)   ( (((DWORD)_a_)<<24)|(((DWORD)_b_)<<16)|(((DWORD)_c_)<<8)|((DWORD)_d_) )

#define MSTEST_ALG_MAGIC       CHAR_TO_MAGIC('M', 'S', 'A', 'L')
#define MSTEST_HASH_ALG_MAGIC  CHAR_TO_MAGIC('M', 'S', 'H', 'A')
#define MSTEST_HASH_MAGIC      CHAR_TO_MAGIC('M', 'S', 'H', 'H')

//
//algorithm provider object
//
typedef struct _MSTEST_OBJECT_HEADER
{
    DWORD           cbLength;
    DWORD           dwMagic;
}
MSTEST_OBJECT_HEADER, *PMSTEST_OBJECT_HEADER;



//
//declarations
//
NTSTATUS
WINAPI
MSTestOpenHashProvider(
    __out   BCRYPT_ALG_HANDLE   *phAlgorithm,
    __in    LPCWSTR             pszAlgId,
    __in    DWORD               dwFlags);

NTSTATUS
WINAPI
MSTestCloseHashProvider(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __in    DWORD               dwFlags);

NTSTATUS
WINAPI
MSTestCreateHash(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_HASH_HANDLE  *phHash,
    __out_bcount_full(cbHashObject) PBYTE               pbHashObject,
    __in                            DWORD               cbHashObject,
    __in_bcount_opt(cbSecret)       PBYTE               pbSecret,   // optional
    __in                            DWORD               cbSecret,   // optional
    __in                            DWORD               dwFlags);

NTSTATUS
WINAPI
MSTestHashData(
    __inout                 BCRYPT_HASH_HANDLE  hHash,
    __in_bcount(cbInput)    PBYTE               pbInput,
    __in                    DWORD               cbInput,
    __in                    DWORD               dwFlags);

NTSTATUS
WINAPI
MSTestFinishHash(
    __inout                     BCRYPT_HASH_HANDLE  hHash,
    __out_bcount_full(cbOutput) PBYTE               pbOutput,
    __in                        DWORD               cbOutput,
    __in                        DWORD               dwFlags);

NTSTATUS
WINAPI
MSTestDuplicateHash(
    __in                            BCRYPT_HASH_HANDLE  hHash,
    __out                           BCRYPT_HASH_HANDLE  *phNewHash,
    __out_bcount_full(cbHashObject) PBYTE   pbHashObject,
    __in                            DWORD   cbHashObject,
    __in                            DWORD   dwFlags);

NTSTATUS
WINAPI
MSTestGetHashProperty(
    __in                                        BCRYPT_HASH_HANDLE  hHash,
    __in                                        LPCWSTR             pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE               pbOutput,
    __in                                        DWORD               cbOutput,
    __out                                       DWORD               *pcbResult,
    __in                                        DWORD               dwFlags);

NTSTATUS
WINAPI
MSTestSetHashProperty(
    __inout                 BCRYPT_HASH_HANDLE  hHash,
    __in                    LPCWSTR             pszProperty,
    __in_bcount(cbInput)    PBYTE               pbInput,
    __in                    DWORD               cbInput,
    __in                    DWORD               dwFlags);

NTSTATUS
WINAPI
MSTestDestroyHash(
    __inout BCRYPT_HASH_HANDLE  hHash);



#ifdef __cplusplus
}
#endif

#endif //_HASHPROV_H_
