// provider.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "..\inc\hashprov.h"


#ifdef _MANAGED
#pragma managed(push, off)
#endif


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
#define STATUS_SUCCESS                   ((NTSTATUS)0x00000000L)
#define STATUS_NOT_SUPPORTED             ((NTSTATUS)0xC00000BBL)
#define STATUS_UNSUCCESSFUL              ((NTSTATUS)0xC0000001L)
#define STATUS_HMAC_NOT_SUPPORTED        ((NTSTATUS)0xC000A001L)
#define STATUS_BUFFER_TOO_SMALL          ((NTSTATUS)0xC0000023L)
#define STATUS_NOT_IMPLEMENTED           ((NTSTATUS)0xC0000002L)
#endif



//MD0 defines
#define MSTEST_MD0_NAME                     L"MD0"
#define MSTEST_MD0_DIGESTLENGTH             20
#define MSTEST_MD0_OID_COUNT                2
#define MSTEST_MD0_ALG                      1
#define MSTEST_MD0_BLOCKLENGTH              64

#define MSTEST_NUMBER_HASH_ALGS             1

//dummy oid, same as md2
static CONST BCRYPT_OID md0OIDs[] =
{
    {12, (BYTE *)"\x06\x08\x2a\x86\x48\x86\xf7\x0d\x02\x02\x05\x00"},
    {10, (BYTE *)"\x06\x08\x2a\x86\x48\x86\xf7\x0d\x02\x02"}
};

typedef struct _MSTEST_HASH_ALGORITHM
{
    MSTEST_OBJECT_HEADER    Header;
    DWORD                   cbDigest;           //size of digest
    DWORD                   cbObject;           //object size required
    wchar_t                 szAlgorithmName[256];
    DWORD                   cbBlockLength;
    DWORD                   dwOIDCount;
    BCRYPT_OID              *OIDList;

} MSTEST_HASH_ALGORITHM, *PMSTEST_HASH_ALGORITHM;

//
//generic hash object
//
typedef struct _MSTEST_HASH_OBJECT {
    MSTEST_OBJECT_HEADER    Header;
    DWORD                   cbDigest;
    DWORD                   dwAlgId;
} MSTEST_HASH_OBJECT, *PMSTEST_HASH_OBJECT,
  MSTEST_MD0_HASH,    *PMSTEST_MD0_HASH;


MSTEST_HASH_ALGORITHM rgHashAlgorithm[MSTEST_NUMBER_HASH_ALGS] =
{
    {
        {
            sizeof(MSTEST_HASH_ALGORITHM),  //size of alg object
            MSTEST_HASH_ALG_MAGIC          //hash provider handle magic
        },        
        MSTEST_MD0_DIGESTLENGTH,            //size of digest
        sizeof(MSTEST_MD0_HASH),            //size of hash object
        MSTEST_MD0_NAME,                   //alg name
        MSTEST_MD0_BLOCKLENGTH,            //block length
        MSTEST_MD0_OID_COUNT,              //num oids
        (BCRYPT_OID*)md0OIDs              //oids
    }
};

//
//function pointer table for hash provider
//
BCRYPT_HASH_FUNCTION_TABLE MSTestHashFunctionTable = 
{
    BCRYPT_HASH_INTERFACE_VERSION_1,
    MSTestOpenHashProvider,
    MSTestGetHashProperty,
    MSTestSetHashProperty,
    MSTestCloseHashProvider,
    MSTestCreateHash,
    MSTestHashData,
    MSTestFinishHash,
    MSTestDuplicateHash,
    MSTestDestroyHash,
};


NTSTATUS
WINAPI
GetHashInterface(
    __in   LPWSTR                       pszProviderName,
    __in   LPWSTR                       pszAlgId,
    __out  BCRYPT_HASH_FUNCTION_TABLE   **ppFunctionTable,
    __in   DWORD                        dwFlags)
/*++

Routine Description:

    When the router/loader wants to load our provider, it will look for this
    well known interface after doing a LoadLibrary

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    NTSTATUS    Status  = STATUS_NOT_SUPPORTED;

    UNREFERENCED_PARAMETER(pszProviderName);
    UNREFERENCED_PARAMETER(dwFlags);


    if(wcscmp(MSTEST_MD0_NAME, pszAlgId))
    {
        Status = STATUS_NOT_SUPPORTED;
        goto Cleanup;
    }
    
    *ppFunctionTable = &MSTestHashFunctionTable;

    Status = STATUS_SUCCESS;


Cleanup:

    return Status;

}

NTSTATUS
WINAPI
MSTestOpenHashProvider(
    __out   BCRYPT_ALG_HANDLE   *phAlgorithm,
    __in    LPCWSTR             pszAlgId,
    __in    DWORD               dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    NTSTATUS                Status          = STATUS_UNSUCCESSFUL;
    MSTEST_HASH_ALGORITHM   *pAlgorithm     = NULL;
    DWORD                   dwAlgIndex      = 0;


    //validate params
    if(NULL == phAlgorithm)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    if (NULL == pszAlgId)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    //MD0 is the only hash algs we support

    for( dwAlgIndex = 0; dwAlgIndex < MSTEST_NUMBER_HASH_ALGS; dwAlgIndex++ )
    {
        if ( 0 == wcscmp(pszAlgId, rgHashAlgorithm[dwAlgIndex].szAlgorithmName) )
        {
            break;
        }

    }

    if (MSTEST_NUMBER_HASH_ALGS <= dwAlgIndex)
    {
        Status = STATUS_NOT_SUPPORTED;
        goto Cleanup;
    }

    if(dwFlags & BCRYPT_ALG_HANDLE_HMAC_FLAG)
    {
        //change this if provider will support hmac
        //o/w the router will implement when it gets this return code

        Status = STATUS_HMAC_NOT_SUPPORTED; 
        goto Cleanup;
    }

    //allocate memory for internal algorithm obj

    pAlgorithm = (PMSTEST_HASH_ALGORITHM)MALLOC(rgHashAlgorithm[dwAlgIndex].Header.cbLength);

    if(NULL == pAlgorithm)
    {
        Status = STATUS_NO_MEMORY;
        goto Cleanup;
    }


    //copy the hash provider object to the allocated block
    memcpy(pAlgorithm, &rgHashAlgorithm[dwAlgIndex], sizeof(MSTEST_HASH_ALGORITHM));

    //return the handle
    *phAlgorithm = (BCRYPT_ALG_HANDLE)pAlgorithm;

    Status = STATUS_SUCCESS;

Cleanup:


    return Status;

}

NTSTATUS
WINAPI
MSTestCloseHashProvider(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __in    DWORD               dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    NTSTATUS                Status  = STATUS_UNSUCCESSFUL;
    MSTEST_HASH_ALGORITHM   *pAlg   = NULL;
    DWORD                   cbAlg   = 0;

    UNREFERENCED_PARAMETER(dwFlags);

    pAlg = (MSTEST_HASH_ALGORITHM *)hAlgorithm;

    //validate in handle
    if(NULL == pAlg || MSTEST_HASH_ALG_MAGIC != pAlg->Header.dwMagic)
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


NTSTATUS
WINAPI
MSTestCreateHash(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_HASH_HANDLE  *phHash,
    __out_bcount_full(cbHashObject) PBYTE               pbHashObject,
    __in                            DWORD               cbHashObject,
    __in_bcount_opt(cbSecret)       PBYTE               pbSecret,   // optional
    __in                            DWORD               cbSecret,   // optional
    __in                            DWORD               dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    NTSTATUS                Status      = STATUS_UNSUCCESSFUL;
    PMSTEST_HASH_OBJECT     pHash       = NULL;
    PMSTEST_HASH_ALGORITHM  pAlgorithm  = NULL;
    
    UNREFERENCED_PARAMETER(pbSecret);
    UNREFERENCED_PARAMETER(cbSecret);
    UNREFERENCED_PARAMETER(dwFlags);

    pAlgorithm = (MSTEST_HASH_ALGORITHM *)hAlgorithm;

    //validate in handle
    if(NULL == pAlgorithm || MSTEST_HASH_ALG_MAGIC != pAlgorithm->Header.dwMagic)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }

    if( (NULL == phHash) ||
        (NULL == pbHashObject) )
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    if ( (cbHashObject < pAlgorithm->cbObject) ||
         (cbHashObject < sizeof(MSTEST_HASH_OBJECT)) )
    {
        Status = STATUS_BUFFER_TOO_SMALL;
        goto Cleanup;
    }

    pHash = (PMSTEST_HASH_OBJECT) pbHashObject;   
   
    //inherit some properties from the alg object
    pHash->Header.cbLength = pAlgorithm->cbObject;
    pHash->Header.dwMagic  = MSTEST_HASH_MAGIC;
    pHash->cbDigest        = pAlgorithm->cbDigest;

    *phHash = (BCRYPT_HASH_HANDLE)pbHashObject;
    
    if(!wcscmp(pAlgorithm->szAlgorithmName,MSTEST_MD0_NAME ))
    {

        pHash->dwAlgId = MSTEST_MD0_ALG;
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


NTSTATUS
WINAPI
MSTestHashData(
    __inout                 BCRYPT_HASH_HANDLE  hHash,
    __in_bcount(cbInput)    PBYTE               pbInput,
    __in                    DWORD               cbInput,
    __in                    DWORD               dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    MSTEST_HASH_OBJECT  *pHash      = NULL;
    NTSTATUS            Status      = STATUS_UNSUCCESSFUL;

    UNREFERENCED_PARAMETER(dwFlags);


    pHash = (PMSTEST_HASH_OBJECT)hHash;

    if(NULL == pHash || MSTEST_HASH_MAGIC != pHash->Header.dwMagic)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }

    if(NULL == pbInput || 0 == cbInput)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }


    //we wont really hash anything for MD0

    Status = STATUS_SUCCESS;

Cleanup:

    return Status;
}

NTSTATUS
WINAPI
MSTestFinishHash(
    __inout                     BCRYPT_HASH_HANDLE  hHash,
    __out_bcount_full(cbOutput) PBYTE               pbOutput,
    __in                        DWORD               cbOutput,
    __in                        DWORD               dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    MSTEST_HASH_OBJECT  *pHash  = NULL;
    NTSTATUS            Status  = STATUS_UNSUCCESSFUL;
    UNREFERENCED_PARAMETER(dwFlags);

    pHash = (PMSTEST_HASH_OBJECT)hHash;

    if(NULL == pHash || MSTEST_HASH_MAGIC != pHash->Header.dwMagic)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }

    if( (cbOutput != pHash->cbDigest) ||
        (NULL     == pbOutput) )
    {
        Status = STATUS_INVALID_PARAMETER;
        return Status;
    }


    if(MSTEST_MD0_ALG == pHash->dwAlgId)
    {
        //return fixed hash of 5Cs for any input
        memset(pbOutput, 0xAB, pHash->cbDigest);

    }


    Status = STATUS_SUCCESS;

Cleanup:

    return Status;
}


NTSTATUS
WINAPI
MSTestDuplicateHash(
    __in                            BCRYPT_HASH_HANDLE  hHash,
    __out                           BCRYPT_HASH_HANDLE  *phNewHash,
    __out_bcount_full(cbHashObject) PBYTE   pbHashObject,
    __in                            DWORD   cbHashObject,
    __in                            DWORD   dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    MSTEST_HASH_OBJECT      *pHash   = NULL;
    NTSTATUS                Status  = STATUS_UNSUCCESSFUL;

    UNREFERENCED_PARAMETER(dwFlags);

    pHash = (PMSTEST_HASH_OBJECT)hHash;

    if(NULL == pHash || MSTEST_HASH_MAGIC != pHash->Header.dwMagic)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }

    if( (NULL == phNewHash) ||
        (NULL == pbHashObject) )
    {
        Status = STATUS_INVALID_PARAMETER;
        goto Cleanup;
    }

    if(cbHashObject < pHash->Header.cbLength)
    {
        Status = STATUS_BUFFER_TOO_SMALL;
        goto Cleanup;
    }

    //copy the object over and return its handle
    memcpy(pbHashObject, pHash, pHash->Header.cbLength);

    *phNewHash = (BCRYPT_HASH_HANDLE)pbHashObject;

    Status = STATUS_SUCCESS;

Cleanup:

    return Status;
}


NTSTATUS
WINAPI
MSTestGetHashProperty(
    __in                                        BCRYPT_HASH_HANDLE  hHash,
    __in                                        LPCWSTR             pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE               pbOutput,
    __in                                        DWORD               cbOutput,
    __out                                       DWORD               *pcbResult,
    __in                                        DWORD               dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    MSTEST_OBJECT_HEADER   *pHdr        = NULL;
    MSTEST_HASH_OBJECT     *pHashObj    = NULL;
    NTSTATUS                Status      = STATUS_UNSUCCESSFUL;
    MSTEST_HASH_ALGORITHM  *pAlg        = NULL;


    UNREFERENCED_PARAMETER(dwFlags);

    pHdr = (PMSTEST_OBJECT_HEADER)hHash;

    if( NULL == pHdr)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }

    if( MSTEST_HASH_MAGIC     != pHdr->dwMagic &&
        MSTEST_HASH_ALG_MAGIC != pHdr->dwMagic)
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
        pAlg =  (PMSTEST_HASH_ALGORITHM)hHash;

        *pcbResult = (DWORD)((wcslen(pAlg->szAlgorithmName) + 1)* sizeof(WCHAR));

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

        memcpy(pbOutput, (PBYTE)pAlg->szAlgorithmName, *pcbResult);
    }
    else if(!wcscmp(pszProperty, BCRYPT_HASH_LENGTH))
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

        if(MSTEST_HASH_MAGIC == pHdr->dwMagic)
        {
            pHashObj = (PMSTEST_HASH_OBJECT)hHash;
            *(DWORD *)pbOutput = pHashObj->cbDigest;
        }
        else
        {
            pAlg =  (PMSTEST_HASH_ALGORITHM)hHash;
            *(DWORD *)pbOutput = pAlg->cbDigest;
        }
        
    }
    else if(!wcscmp(pszProperty, BCRYPT_OBJECT_LENGTH))
    {

        pAlg =  (PMSTEST_HASH_ALGORITHM)hHash;

        if( MSTEST_HASH_ALG_MAGIC  != pAlg->Header.dwMagic)
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

        *(DWORD *)pbOutput = pAlg->cbObject;
    }
    else if(!wcscmp(pszProperty, BCRYPT_HASH_BLOCK_LENGTH))
    {
        pAlg =  (PMSTEST_HASH_ALGORITHM)hHash;
        
        if( MSTEST_HASH_ALG_MAGIC  != pAlg->Header.dwMagic)
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

        *(DWORD *)pbOutput = pAlg->cbBlockLength;
    }
    else if(!wcscmp(pszProperty, BCRYPT_HASH_OID_LIST))
    {
        Status = STATUS_NOT_SUPPORTED;
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


NTSTATUS
WINAPI
MSTestSetHashProperty(
    __inout                 BCRYPT_HASH_HANDLE  hHash,
    __in                    LPCWSTR             pszProperty,
    __in_bcount(cbInput)    PBYTE               pbInput,
    __in                    DWORD               cbInput,
    __in                    DWORD               dwFlags)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    UNREFERENCED_PARAMETER(hHash);
    UNREFERENCED_PARAMETER(pszProperty);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_NOT_IMPLEMENTED;
}


NTSTATUS
WINAPI
MSTestDestroyHash(
    __inout BCRYPT_HASH_HANDLE  hHash)
/*++

Routine Description:

Arguments:

Return Value:

    NTSTATUS value

--*/
{
    MSTEST_HASH_OBJECT    *pHash    = NULL;
    NTSTATUS              Status    = STATUS_UNSUCCESSFUL;
    DWORD                 cbHash    = 0;

    pHash = (PMSTEST_HASH_OBJECT)hHash;

    if(NULL == pHash || MSTEST_HASH_MAGIC != pHash->Header.dwMagic)
    {
        Status = STATUS_INVALID_HANDLE;
        goto Cleanup;
    }
    
    //cleanup the object
    cbHash = pHash->Header.cbLength;

    memset(pHash, 0, cbHash);

    Status = STATUS_SUCCESS;

Cleanup:

    return Status;
}

#ifdef _MANAGED
#pragma managed(pop)
#endif

