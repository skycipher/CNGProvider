/*++

Abstract:

    This sample illustrates how to write a custom user-mode cryptographic
    provider for the CNG system.

    NOTES:

        Before installing this provider with the configuration program, 
        copy the provider DLL to the proper directory:

            %systemroot%\system32   -   if this is a native provider 
                                        (i.e., 32-bit DLL on a 32-bit
                                        platform, or a 64-bit DLL on
                                        a 64-bit platform).

            %systemroot%\sysWOW64   -   if this is a 32-bit provider
                                        running in compatibility mode
                                        (servicing 32-bit clients) on 
                                        a 64-bit platform.

        You will need to be running as an administrator to copy the
        provider DLL to these directories, and to use the configuration
        program to install the provider.


    THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
    ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
    PARTICULAR PURPOSE.

    Copyright (c) 2005-2007 by Microsoft Corporation. All rights reserved.

--*/


///////////////////////////////////////////////////////////////////////////////
//
// Headers...
//
///////////////////////////////////////////////////////////////////////////////
#include "stdafx.h"

#include <windows.h>
#include <malloc.h>
#include <bcrypt.h>
#include <bcrypt_provider.h>

#include "..\inc\symmprov.h"

///////////////////////////////////////////////////////////////////////////////
//
// Local definitions...
//
///////////////////////////////////////////////////////////////////////////////
//
// These NTSTATUS items are not currently defined in BCRYPT.H. Unitl this is
// corrected, the easiest way to make them available is to cut and paste them 
// from NTSTATUS.H...
//
#ifndef NTSTATUS
typedef LONG NTSTATUS, *PNSTATUS;
#endif

#ifndef NT_SUCCESS
#define NT_SUCCESS(status) (status >= 0)
#endif

#ifndef STATUS_SUCCESS
#define STATUS_SUCCESS              ((NTSTATUS)0x00000000L)
#define STATUS_NOT_SUPPORTED        ((NTSTATUS)0xC00000BBL)
#define STATUS_UNSUCCESSFUL         ((NTSTATUS)0xC0000001L)
#define STATUS_HMAC_NOT_SUPPORTED   ((NTSTATUS)0xC000A001L)
#define STATUS_BUFFER_TOO_SMALL     ((NTSTATUS)0xC0000023L)
#define STATUS_NOT_IMPLEMENTED      ((NTSTATUS)0xC0000002L)
#endif


#ifdef _MANAGED
#pragma managed(push, off)
#endif

///////////////////////////////////////////////////////////////////////////////
//
// Globals...
//
///////////////////////////////////////////////////////////////////////////////
HINSTANCE g_hInstance = NULL;

//
// Function pointer table for symmetric cipher operations
//
BCRYPT_CIPHER_FUNCTION_TABLE SymmCipherFunctionTable = {
    BCRYPT_CIPHER_INTERFACE_VERSION_1,
    SymmOpenCipherProvider,
    SymmGetCipherProperty,
    SymmSetCipherProperty,
    SymmCloseCipherProvider,
    SymmGenerateKey,
    SymmEncrypt,
    SymmDecrypt,
    SymmImportKey,
    SymmExportKey,
    SymmDuplicateKey,
    SymmDestroyKey,
};


///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of local functions...
//
///////////////////////////////////////////////////////////////////////////////
static SYMM_CIPHER_KEY *
ValidateKeyHandle(
    BCRYPT_KEY_HANDLE hKey
    );

static SYMM_CIPHER_ALGORITHM *
ValidateAlgHandle(
    BCRYPT_ALG_HANDLE hAlg
    );

static void 
XorBuffer(
__in_bcount(cbBufSize) BYTE *pbIn, 
__out_bcount(cbBufSize) BYTE *pbOut, 
__in    DWORD cbBufSize, 
__in_bcount(cbKeySize)    BYTE *pbKey, 
__in     DWORD cbKeySize
    );
///////////////////////////////////////////////////////////////////////////////

BOOL 
WINAPI
DllMain(
    IN CONST HINSTANCE    hInstDLL,
    IN CONST DWORD        dwReason,
    IN CONST LPVOID       lpvReserved
    )
/*++

Routine Description:

    Main entry point for DLL.

Arguments:

Return Value:

    Boolean result

--*/
{
    UNREFERENCED_PARAMETER(lpvReserved);

    g_hInstance = (HINSTANCE)hInstDLL;

    if(dwReason == DLL_PROCESS_ATTACH)
    {
        //
        // Initialize stuff
        //
    }
    else if(dwReason == DLL_PROCESS_DETACH)
    {
        //
        // Cleanup stuff
        //
   }

    return TRUE;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
WINAPI
GetCipherInterface(
    __in    LPWSTR                       pszProviderName,
    __in    LPWSTR                       pszAlgId,
    __out   BCRYPT_CIPHER_FUNCTION_TABLE   **ppFunctionTable,
    __in    DWORD                        dwFlags
    )
/*++

Routine Description:

    When a client tries to open our algorithm provider, the CNG router/loader 
    will first load this DLL using LoadLibrary. Then it determines if the 
    provider supports symmetric cipher operations by looking for a well-known
    function ('GetCipherInterface') in the DLL. Finally, it calls GetCipherInterface
    to validate the algorithm ID, and to get a copy of the provider's function
    dispatch table for symmetric cipher operations.

    NOTES: 

        See the CNG SDK help file for the well-known function names that 
        correspond to other algorithm classes.

        The .DEF file for this project shows how to export one of these
        functions. One of the most common problems encountered by
        provider writers is that their provider DLL isn't exporting
        these functions correctly.

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    NTSTATUS    Status  = STATUS_NOT_SUPPORTED;

    UNREFERENCED_PARAMETER(pszProviderName);
    UNREFERENCED_PARAMETER(dwFlags);

    if(wcscmp(SYMM_CIPHER_ALGID, pszAlgId) == 0)
    {
        *ppFunctionTable = &SymmCipherFunctionTable;
        Status = STATUS_SUCCESS;
    }
    else
    {
        Status = STATUS_NOT_SUPPORTED;
    }
    
    return Status;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmOpenCipherProvider(
    __out   BCRYPT_ALG_HANDLE   *phAlgorithm,
    __in    LPCWSTR             pszAlgId,
    __in    DWORD               dwFlags
    )
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    NTSTATUS                Status          = STATUS_UNSUCCESSFUL;
    SYMM_CIPHER_ALGORITHM   *pAlgorithm     = NULL;

    UNREFERENCED_PARAMETER(dwFlags);
    

    //validate params
    if(NULL == phAlgorithm || NULL == pszAlgId)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    if (wcscmp(pszAlgId, SYMM_CIPHER_ALGID))
    {
        Status = STATUS_NOT_SUPPORTED;
        goto Cleanup;
    }

    pAlgorithm = (SYMM_CIPHER_ALGORITHM*)MALLOC(sizeof(SYMM_CIPHER_ALGORITHM));

    if(NULL == pAlgorithm)
    {
        Status = STATUS_NO_MEMORY;
        goto Cleanup;
    }

    pAlgorithm->Header.dwMagic = SYMM_CIPHER_ALG_MAGIC;
    pAlgorithm->Header.cbLength = sizeof(SYMM_CIPHER_ALGORITHM);
    pAlgorithm->cbKey = sizeof(SYMM_CIPHER_KEY);

    //return the handle
    *phAlgorithm = (BCRYPT_ALG_HANDLE)pAlgorithm;

    Status = STATUS_SUCCESS;

Cleanup:
    return Status;

}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmCloseCipherProvider(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __in    DWORD               dwFlags
    )
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    NTSTATUS                Status  = STATUS_UNSUCCESSFUL;
    SYMM_CIPHER_ALGORITHM   *pAlg   = NULL;
    DWORD                   cbAlg   = 0;

    UNREFERENCED_PARAMETER(dwFlags);

    pAlg = (SYMM_CIPHER_ALGORITHM *)hAlgorithm;

    //validate in handle
    if(!ValidateAlgHandle(hAlgorithm))
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }


    //clean up the memory
    cbAlg = pAlg->Header.cbLength;

    RtlZeroMemory(pAlg, cbAlg);

    FREE(pAlg);

    Status = STATUS_SUCCESS;

Cleanup:

    return Status;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmGetCipherProperty(
    __in                                        BCRYPT_HANDLE   hObject,
    __in                                        LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    )
{
    SYMM_HEADER            *pHdr        = NULL;
    NTSTATUS                Status      = STATUS_UNSUCCESSFUL;
    SYMM_CIPHER_ALGORITHM  *pAlg        = NULL;


    UNREFERENCED_PARAMETER(dwFlags);

    pHdr = (SYMM_HEADER*)hObject;

    if( NULL == pHdr)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }

    if( SYMM_CIPHER_KEY_MAGIC != pHdr->dwMagic &&
        SYMM_CIPHER_ALG_MAGIC != pHdr->dwMagic)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }


    if(NULL == pcbResult)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    if (!wcscmp(pszProperty, BCRYPT_ALGORITHM_NAME))
    {
        *pcbResult = (DWORD)((wcslen(SYMM_CIPHER_ALGID) + 1)* sizeof(WCHAR));

        if (NULL == pbOutput)
        {
            Status = STATUS_SUCCESS;
            goto Cleanup;
        }

        if (cbOutput < *pcbResult)
        {
            Status = STATUS_BUFFER_TOO_SMALL;
            goto Cleanup;
        }

        memcpy(pbOutput, (PBYTE)SYMM_CIPHER_ALGID, *pcbResult);
    }
    else if(!wcscmp(pszProperty, BCRYPT_BLOCK_LENGTH) )
    {
        *pcbResult = sizeof(DWORD);

        
        if (NULL == pbOutput)
        {
            Status = STATUS_SUCCESS;
            goto Cleanup;
        }

        if (cbOutput < *pcbResult)
        {
            Status = STATUS_BUFFER_TOO_SMALL;
            goto Cleanup;
        }

        *(DWORD *)pbOutput = 1;  // block length of 1 indicates a stream cipher
        
    }
    else if(!wcscmp(pszProperty, BCRYPT_KEY_LENGTH))
    {
        *pcbResult = sizeof(DWORD);

        
        if (NULL == pbOutput)
        {
            Status = STATUS_SUCCESS;
            goto Cleanup;
        }

        if (cbOutput < *pcbResult)
        {
            Status = STATUS_BUFFER_TOO_SMALL;
            goto Cleanup;
        }

        *(DWORD *)pbOutput = SYMM_CIPHER_KEY_SIZE;  
        
    }
    else if(!wcscmp(pszProperty, BCRYPT_OBJECT_LENGTH))
    {

        pAlg =  ValidateAlgHandle(hObject);

        if( !pAlg )
        {
            Status = STATUS_NOT_SUPPORTED;
            goto Cleanup;
        }

        *pcbResult = sizeof(DWORD);

        if (NULL == pbOutput)
        {
            Status = STATUS_SUCCESS;
            goto Cleanup;
        }

        if (cbOutput < *pcbResult)
        {
            Status = STATUS_BUFFER_TOO_SMALL;
            goto Cleanup;
        }

        *(DWORD *)pbOutput = pAlg->cbKey;
    }
    else
    {
        Status = STATUS_NOT_SUPPORTED;
        goto Cleanup;
    }
    
    Status = STATUS_SUCCESS;

Cleanup:

    return Status;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmSetCipherProperty(
    __inout                 BCRYPT_HANDLE   hObject,
    __in                    LPCWSTR pszProperty,
    __in_bcount(cbInput)    PUCHAR   pbInput,
    __in                    ULONG   cbInput,
    __in                    ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hObject);
    UNREFERENCED_PARAMETER(pszProperty);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_NOT_SUPPORTED;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmGenerateKey(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_KEY_HANDLE   *phKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in_bcount(cbSecret)           PUCHAR   pbSecret,
    __in                            ULONG   cbSecret,
    __in                            ULONG   dwFlags
    )
{
    NTSTATUS Status = STATUS_UNSUCCESSFUL;
    SYMM_CIPHER_ALGORITHM *pAlg = ValidateAlgHandle(hAlgorithm);


    UNREFERENCED_PARAMETER(dwFlags);

    
    if ( !pAlg || !pbKeyObject || !pbSecret || (cbSecret != SYMM_CIPHER_KEY_SIZE) )
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    if ( cbKeyObject < pAlg->cbKey ||
         cbKeyObject < sizeof(SYMM_CIPHER_KEY) )
    {
        Status = STATUS_BUFFER_TOO_SMALL;
        goto Cleanup;
    }

    SYMM_CIPHER_KEY *pKey = (SYMM_CIPHER_KEY*)pbKeyObject;

    pKey->Header.dwMagic = SYMM_CIPHER_KEY_MAGIC;
    pKey->Header.cbLength = cbKeyObject;
    memcpy(pKey->rgbKey, pbSecret, SYMM_CIPHER_KEY_SIZE);

    *phKey = (BCRYPT_KEY_HANDLE)pKey;
    Status = STATUS_SUCCESS;

Cleanup:
    return Status;
}
///////////////////////////////////////////////////////////////////////////////

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
    __in                                        ULONG   dwFlags
    )

{
    NTSTATUS Status = STATUS_UNSUCCESSFUL;
    SYMM_CIPHER_KEY *pKey = ValidateKeyHandle(hKey);

    UNREFERENCED_PARAMETER(pPaddingInfo);
    UNREFERENCED_PARAMETER(pbIV);
    UNREFERENCED_PARAMETER(cbIV);
    UNREFERENCED_PARAMETER(dwFlags);

    if ( !pKey || !pcbResult )
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    *pcbResult = cbInput;

    if ( pbOutput == NULL )
    {
        Status = STATUS_SUCCESS;
        goto Cleanup;
    }

    if(0 == cbInput)
    {
        Status = STATUS_SUCCESS;
        goto Cleanup;
    }

    if(cbInput > cbOutput)
    {
        Status = STATUS_BUFFER_TOO_SMALL;
        goto Cleanup;
    }

    if(NULL == pbInput)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    // do the encryption
    XorBuffer(pbInput, pbOutput, cbInput, pKey->rgbKey, SYMM_CIPHER_KEY_SIZE);


    Status = STATUS_SUCCESS;


Cleanup:
    return Status;
}
///////////////////////////////////////////////////////////////////////////////

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
    __in                                        ULONG   dwFlags
    )
{
        // decryption = encryption with XOR
        return SymmEncrypt(hKey, pbInput, cbInput, pPaddingInfo, pbIV, cbIV, pbOutput, cbOutput, pcbResult, dwFlags);
}
///////////////////////////////////////////////////////////////////////////////

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
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(hImportKey);
    UNREFERENCED_PARAMETER(pszBlobType);
    UNREFERENCED_PARAMETER(phKey);
    UNREFERENCED_PARAMETER(pbKeyObject);
    UNREFERENCED_PARAMETER(cbKeyObject);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_NOT_SUPPORTED;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmExportKey(
    __in                                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                                    BCRYPT_KEY_HANDLE   hExportKey,
    __in                                        LPCWSTR pszBlobType,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(hExportKey);
    UNREFERENCED_PARAMETER(pszBlobType);
    UNREFERENCED_PARAMETER(pbOutput);
    UNREFERENCED_PARAMETER(cbOutput);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_NOT_SUPPORTED;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmDuplicateKey(
__in                            BCRYPT_KEY_HANDLE   hKey,
__out                           BCRYPT_KEY_HANDLE   *phNewKey,
__out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(phNewKey);
    UNREFERENCED_PARAMETER(pbKeyObject);
    UNREFERENCED_PARAMETER(cbKeyObject);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_NOT_SUPPORTED;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
WINAPI
SymmDestroyKey(
    __inout BCRYPT_KEY_HANDLE   hKey
    )
{
    NTSTATUS                Status  = STATUS_UNSUCCESSFUL;
    SYMM_CIPHER_KEY         *pKey   = NULL;
    DWORD                   cbKey   = 0;

    pKey = (SYMM_CIPHER_KEY *)hKey;

    //validate in handle
    if(!ValidateKeyHandle(hKey))
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }

    //clean up the memory
    cbKey = pKey->Header.cbLength;

    RtlZeroMemory(pKey, cbKey);

    Status = STATUS_SUCCESS;

Cleanup:

    return Status;
}
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
//
// Helper functions...
//
///////////////////////////////////////////////////////////////////////////////
SYMM_CIPHER_ALGORITHM *
ValidateAlgHandle(
    BCRYPT_ALG_HANDLE hAlg
    )
{
    SYMM_CIPHER_ALGORITHM *pAlg = (SYMM_CIPHER_ALGORITHM *)hAlg;

    // validate alg handle
    if(NULL != pAlg && SYMM_CIPHER_ALG_MAGIC == pAlg->Header.dwMagic)
    {
        return pAlg;
    }

    return NULL;

}
///////////////////////////////////////////////////////////////////////////////

SYMM_CIPHER_KEY *
ValidateKeyHandle(
    BCRYPT_KEY_HANDLE hKey
    )
{
    SYMM_CIPHER_KEY *pKey = (SYMM_CIPHER_KEY *)hKey;

    // validate alg handle
    if(NULL != pKey && SYMM_CIPHER_KEY_MAGIC == pKey->Header.dwMagic)
    {
        return pKey;
    }

    return NULL;
}
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
// Implementation details of super secret encryption algorithm
//
///////////////////////////////////////////////////////////////////////////////
void 
XorBuffer(
    __in_bcount(cbBufSize) BYTE *pbIn, 
    __out_bcount(cbBufSize) BYTE *pbOut, 
    __in DWORD cbBufSize, 
    __in_bcount(cbKeySize) BYTE *pbKey, 
    __in DWORD cbKeySize
    )
{
    memcpy(pbOut, pbIn, cbBufSize);

    for ( DWORD dwBufIndex = 0; dwBufIndex < cbBufSize; dwBufIndex++)
    {
        for ( DWORD dwKeyIndex = 0; dwKeyIndex < cbKeySize; dwKeyIndex++)
        {
            pbOut[dwBufIndex] ^= pbKey[dwKeyIndex];
        }

    }
}
///////////////////////////////////////////////////////////////////////////////


#ifdef _MANAGED
#pragma managed(pop)
#endif
