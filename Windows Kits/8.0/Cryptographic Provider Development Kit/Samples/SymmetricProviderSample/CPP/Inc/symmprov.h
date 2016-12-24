/*++

Abstract:

    This file is part of the CNG symmetric cipher provider sample. It
    contains defintions required jointly by the custom provider, the 
    configuration program, and the client.


    THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
    ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
    PARTICULAR PURPOSE.

    Copyright (c) 2005-2007 by Microsoft Corporation. All rights reserved.

--*/

#ifndef _SYMMPROV_H_
#define _SYMMPROV_H_

#ifdef __cplusplus
extern "C" {
#endif


//helper macros
#define MALLOC(X)   HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, (X));
#define FREE(X)     { if(X) { HeapFree(GetProcessHeap(), 0, X); X = NULL ; } }

#define SYMM_CIPHER_PROVIDER_NAME               L"CNG Demo Symmetric Cipher Provider"
#define SYMM_CIPHER_ALGID                       L"XOR"
#define SYMM_CIPHER_ALG_MAGIC                   0xDEADBEEF
#define SYMM_CIPHER_KEY_MAGIC                   0xBADF00D

struct SYMM_HEADER 
{
    DWORD dwMagic;
    DWORD cbLength;
};

struct SYMM_CIPHER_ALGORITHM
{
    SYMM_HEADER Header;
    DWORD       cbKey;
};

#define SYMM_CIPHER_KEY_SIZE    16

struct SYMM_CIPHER_KEY 
{
    SYMM_HEADER Header;
    BYTE rgbKey[SYMM_CIPHER_KEY_SIZE];
};




//
//declarations
//
NTSTATUS
WINAPI
SymmOpenCipherProvider(
    __out   BCRYPT_ALG_HANDLE   *phAlgorithm,
    __in    LPCWSTR             pszAlgId,
    __in    DWORD               dwFlags);

NTSTATUS
WINAPI
SymmCloseCipherProvider(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __in    DWORD               dwFlags);

NTSTATUS
WINAPI
SymmGetCipherProperty(
    __in                                        BCRYPT_HANDLE   hObject,
    __in                                        LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags);

NTSTATUS
WINAPI
SymmSetCipherProperty(
    __inout                 BCRYPT_HANDLE   hObject,
    __in                    LPCWSTR pszProperty,
    __in_bcount(cbInput)    PUCHAR   pbInput,
    __in                    ULONG   cbInput,
    __in                    ULONG   dwFlags);


NTSTATUS
WINAPI
SymmGenerateKey(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_KEY_HANDLE   *phKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in_bcount(cbSecret)           PUCHAR   pbSecret,
    __in                            ULONG   cbSecret,
    __in                            ULONG   dwFlags);

NTSTATUS
WINAPI
SymmEncrypt(
    __inout                                     BCRYPT_KEY_HANDLE hKey,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __in_opt                                    VOID    *pPaddingInfo,
    __inout_bcount_opt(cbIV)                    PUCHAR   pbIV,
    __in                                        ULONG   cbIV,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags);

NTSTATUS
WINAPI
SymmDecrypt(
    __inout                                     BCRYPT_KEY_HANDLE   hKey,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __in_opt                                    VOID    *pPaddingInfo,
    __inout_bcount_opt(cbIV)                    PUCHAR   pbIV,
    __in                                        ULONG   cbIV,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags);

NTSTATUS
WINAPI
SymmImportKey(
    __in                            BCRYPT_ALG_HANDLE hAlgorithm,
    __in_opt                        BCRYPT_KEY_HANDLE hImportKey,
    __in                            LPCWSTR pszBlobType,
    __out                           BCRYPT_KEY_HANDLE *phKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in_bcount(cbInput)            PUCHAR   pbInput,
    __in                            ULONG   cbInput,
    __in                            ULONG   dwFlags);

NTSTATUS
WINAPI
SymmExportKey(
    __in                                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                                    BCRYPT_KEY_HANDLE   hExportKey,
    __in                                        LPCWSTR pszBlobType,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags);

NTSTATUS
WINAPI
SymmDuplicateKey(
    __in                            BCRYPT_KEY_HANDLE   hKey,
    __out                           BCRYPT_KEY_HANDLE   *phNewKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in                            ULONG   dwFlags);

NTSTATUS
WINAPI
SymmDestroyKey(
    __inout BCRYPT_KEY_HANDLE   hKey);

#ifdef __cplusplus
}
#endif

#endif //_SYMMPROV_H_
