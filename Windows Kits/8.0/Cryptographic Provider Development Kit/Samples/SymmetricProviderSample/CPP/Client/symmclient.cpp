/*++

Abstract:

    This sample illustrates how to use the CNG APIs to open the
    custom symmetric cipher provider and use the 'XOR' algorithm
    to encrypt or decrypt a file.

    NOTES:

        Before running this program, use the 'symmconfig' to register
        the custom provider.

        This program doesn't require any special privileges and it
        can be run from any account.

        To run a 32-bit version of this program on a 64-bit system, it
        will be necessary to install a 32-bit version of the custom
        provider in SYSWOW64.


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
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <io.h>
#include <bcrypt.h>

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
#define STATUS_SUCCESS                  ((NTSTATUS)0x00000000L)
#define STATUS_NOT_SUPPORTED            ((NTSTATUS)0xC00000BBL)
#define STATUS_UNSUCCESSFUL             ((NTSTATUS)0xC0000001L)
#define STATUS_HMAC_NOT_SUPPORTED       ((NTSTATUS)0xC000A001L)
#define STATUS_BUFFER_TOO_SMALL         ((NTSTATUS)0xC0000023L)
#define STATUS_NOT_IMPLEMENTED          ((NTSTATUS)0xC0000002L)
#endif

const DWORD CHUNK_SIZE = 4096;


///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of locatl routines...
//
///////////////////////////////////////////////////////////////////////////////
static void 
DisplayUsage(
    void
    );

static BCRYPT_ALG_HANDLE 
OpenAlgProvider(
    PCWSTR pszAlgID
    );

static BOOL 
CloseAlgProvider(
    BCRYPT_ALG_HANDLE hAlg
    );

static BOOL 
GetPasswordFromUser(
    __in_bcount(dwLength) 
            PWSTR pwszPassword, 
    __in    DWORD dwLength
    );

static BCRYPT_KEY_HANDLE 
CreateKey(
    BCRYPT_ALG_HANDLE hSymAlg, 
    PCWSTR pwszText, 
    PBYTE pbKeyObj, 
    DWORD cbKeyObj
    );

BOOL 
DestroyKey(
    BCRYPT_KEY_HANDLE hKey
    );

void 
ProcessFile(
    LPCWSTR pszInFile, 
    LPCWSTR pszOutFile, 
    BOOL bEncrypt
    );
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
// Main entry point...
//
///////////////////////////////////////////////////////////////////////////////
extern "C" int __cdecl 
wmain(
	__in    int argc,
	__in_ecount(argc) 
            PWSTR *argv
	)
{
    if ( argc > 1 )
    {
        if ( !wcscmp(argv[1], L"-encrypt") ||  !wcscmp(argv[1], L"-decrypt") )
        {
            if ( argc > 3 )
            {
                ProcessFile(argv[2], argv[3], argv[1][1] == L'e');
            }
            else
            {
                DisplayUsage();
            }
        }
        else
		{
            wprintf_s(L"Unrecognized command \"%s\"\n", argv[1]);
			DisplayUsage();
		}
    }
    else
	{
        DisplayUsage();
	}

    return 1;
}
///////////////////////////////////////////////////////////////////////////////

void 
DisplayUsage(
	void
	)
{
	wprintf_s(L"Usage: symmclient -encrypt <infile> <outfile> | -decrypt <infile> <outfile>\n");
    exit(1);
}
///////////////////////////////////////////////////////////////////////////////


BCRYPT_ALG_HANDLE 
OpenAlgProvider(
    PCWSTR pszAlgID
    )
{
    NTSTATUS ntStatus = STATUS_SUCCESS;
    BCRYPT_ALG_HANDLE hAlg = NULL;

    //
    // Get a handle to the 'XOR' algorithm. Note
    // that we don't need to specify a provider name
    // because our provider is the only one offering
    // this algorithm.
    //
    ntStatus = BCryptOpenAlgorithmProvider(
                    &hAlg,      // Algorithm handle
                    pszAlgID,   // Algorithm name
                    NULL,       // Provider name
                    0           // Flags
                    );
    if (!NT_SUCCESS(ntStatus))
    {
        printf("BCryptOpenAlgorithmProvider failed with status: 0x%08x\n", ntStatus);
        hAlg = NULL;
    }

    return hAlg;
}
///////////////////////////////////////////////////////////////////////////////

BOOL 
CloseAlgProvider(
    BCRYPT_ALG_HANDLE hAlg
    )
{
    NTSTATUS ntStatus = STATUS_SUCCESS;

    ntStatus = BCryptCloseAlgorithmProvider(hAlg, 0);
    if (!NT_SUCCESS(ntStatus))
    {
        printf("BCryptCloseAlgorithmProvider failed w/ error code 0x%08x\n", ntStatus);
    }

    return NT_SUCCESS(ntStatus);
}
///////////////////////////////////////////////////////////////////////////////

BOOL 
GetPasswordFromUser(
    __in_bcount(dwLength) 
            PWSTR pwszPassword, 
    __in    DWORD dwLength
    )
{
    ZeroMemory(pwszPassword, dwLength);

    printf("Enter password: ");
    fflush(stdin);
    fgetws(pwszPassword, dwLength-1, stdin);

    return TRUE;
}
///////////////////////////////////////////////////////////////////////////////

/*
    Create a symmetric key by hashing a password
*/
BCRYPT_KEY_HANDLE 
CreateKey(
    BCRYPT_ALG_HANDLE hSymAlg, 
    PCWSTR pwszText, 
    PBYTE pbKeyObj, 
    DWORD cbKeyObj
    )
{
    NTSTATUS ntStatus = STATUS_SUCCESS;
    BCRYPT_KEY_HANDLE hKey = NULL;
    BCRYPT_ALG_HANDLE   hHashAlg = NULL;
    BCRYPT_HASH_HANDLE  hHash = NULL;
    PBYTE               pbHashObject = NULL;
    DWORD               cbHashObject, cbResult;
    BYTE                rgbHash[20];

    ntStatus = BCryptOpenAlgorithmProvider(&hHashAlg,
                                         L"SHA1",
                                         NULL,
                                         0);
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptOpenAlgorithmProvider failed with status: 0x%08x\n", ntStatus);
        goto Cleanup;
    }

    //  Determine the size of the Hash object
    ntStatus = BCryptGetProperty( 
                    hHashAlg,
                    BCRYPT_OBJECT_LENGTH,
                    (PBYTE) &cbHashObject,
                    sizeof(DWORD),
                    &cbResult,
                    0
                    );
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptGetProperty(..., %S,...) failed with status: 0x%08x\n", BCRYPT_OBJECT_LENGTH, ntStatus);
        goto Cleanup;
    }

    pbHashObject = (PBYTE)malloc(cbHashObject);

    if(NULL == pbHashObject)
    {
        printf("Error allocating memory\n");
        goto Cleanup;
    }

    //  Create the Hash object
    ntStatus = BCryptCreateHash(
                    hHashAlg,
                    &hHash,
                    pbHashObject,
                    cbHashObject,
                    NULL, 
                    0,
                    0
                    );
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptCreateHash failed with status: 0x%08x\n", ntStatus);
        goto Cleanup;
    }

    // Hash the data
    ntStatus = BCryptHashData(    
                    hHash,
                    (PBYTE)pwszText,
                    (ULONG)wcslen(pwszText),
                    0
                    );
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptHashData failed with status: 0x%08x\n", ntStatus);
        goto Cleanup;
    }

    // Finish the hash
    ntStatus = BCryptFinishHash(  
                    hHash,
                    rgbHash,
                    sizeof(rgbHash),
                    0
                    );
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptFinishHash failed with status: 0x%08x\n", ntStatus);
        goto Cleanup;
    }

    ntStatus = BCryptGenerateSymmetricKey(
                    hSymAlg,
                    &hKey,
                    pbKeyObj,
                    cbKeyObj,
                    rgbHash,
                    SYMM_CIPHER_KEY_SIZE,
                    0
                    );
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptGenerateSymmetricKey failed with status: 0x%08x\n", ntStatus);
        hKey = NULL;
    }

Cleanup:

    if ( hHash )
        BCryptDestroyHash(hHash);

    if ( pbHashObject )
        free(pbHashObject);

    if ( hHashAlg )
        CloseAlgProvider(hHashAlg);

    return hKey;
}
///////////////////////////////////////////////////////////////////////////////

BOOL 
DestroyKey(
    BCRYPT_KEY_HANDLE hKey
    )
{
    NTSTATUS ntStatus = STATUS_SUCCESS;

    ntStatus = BCryptDestroyKey(hKey);
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptDestroyKey failed w/ error code 0x%08x\n", ntStatus);
    }

    return ntStatus == STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////

void 
ProcessFile(
    LPCWSTR pszInFile, 
    LPCWSTR pszOutFile, 
    BOOL bEncrypt
    )
{
    NTSTATUS ntStatus   = STATUS_SUCCESS;
    BCRYPT_KEY_HANDLE   hKey = NULL;
    BCRYPT_KEY_HANDLE   hAlg = NULL;
    PBYTE               pbKeyObject = NULL;
    DWORD               cbKeyObject, cbResult;
    TCHAR               szPassword[64];

    FILE                *fpIn  = NULL;
    FILE                *fpOut = NULL;
    errno_t             openStatus = 0;

    hAlg = OpenAlgProvider(SYMM_CIPHER_ALGID);
    if ( !hAlg )
    {
        goto Cleanup;
    }

    ntStatus = BCryptGetProperty( 
                    hAlg,
                    BCRYPT_OBJECT_LENGTH,
                    (PBYTE) &cbKeyObject,
                    sizeof(DWORD),
                    &cbResult,
                    0
                    );
    if(STATUS_SUCCESS != ntStatus)
    {
        printf("BCryptGetProperty(..., %S,...) failed with status: 0x%08x\n", BCRYPT_OBJECT_LENGTH, ntStatus);
        goto Cleanup;
    }

    pbKeyObject = (PBYTE)malloc(cbKeyObject);
    if( !pbKeyObject )
    {
        printf("Memory allocation failed\n");
        goto Cleanup;
    }

    openStatus=_wfopen_s(&fpIn, pszInFile, L"rb");
    if( openStatus != 0)
    {
        printf("Error opening file for input.\n");
        goto Cleanup;
    }

    openStatus=_wfopen_s(&fpOut, pszOutFile, L"wb");
    if( openStatus != 0)
    {
        printf("Error opening file for output.\n");
        goto Cleanup;
    }
    
    GetPasswordFromUser((PWSTR)szPassword, sizeof(szPassword));


    hKey = CreateKey(hAlg, (PCWSTR)szPassword, pbKeyObject, cbKeyObject);
    if ( !hKey )
    {
        goto Cleanup;
    }

    while ( !feof(fpIn) )
    {
        DWORD cbSize;
        BYTE  rgbBufIn[CHUNK_SIZE];
        BYTE  rgbBufOut[CHUNK_SIZE];

        cbSize = (DWORD)fread(rgbBufIn, 1, CHUNK_SIZE, fpIn);
        if ( !cbSize )
        {
            printf("Error reading input file\n");
            goto Cleanup;
        }
      
        if ( bEncrypt ) 
        {
            ntStatus = BCryptEncrypt( 
                            hKey,
                            rgbBufIn,
                            cbSize,
                            NULL,
                            NULL,
                            0,
                            rgbBufOut,
                            CHUNK_SIZE,
                            &cbResult,
                            0
                            );
        }
        else
        {
            ntStatus = BCryptDecrypt( 
                            hKey,
                            rgbBufIn,
                            cbSize,
                            NULL,
                            NULL,
                            0,
                            rgbBufOut,
                            CHUNK_SIZE,
                            &cbResult,
                            0
                            );
        }

        if ( ntStatus != STATUS_SUCCESS )
        {
            printf("BCryptEncrypt/BCryptDecrypt failed w/ error code 0x%08x\n", ntStatus);
            goto Cleanup;
        }

        cbSize = (DWORD)fwrite(rgbBufOut, 1, cbSize, fpOut);
        if ( !cbSize )
        {
            printf("Error writing output file\n");
            goto Cleanup;
        }
    }


Cleanup:

    if ( fpIn )
        fclose(fpIn);

    if ( fpOut )
        fclose(fpOut);

    if ( hKey )
        DestroyKey(hKey);

    if ( pbKeyObject )
        free(pbKeyObject);

    if ( hAlg )
        CloseAlgProvider(hAlg);

    return;       

}
///////////////////////////////////////////////////////////////////////////////

