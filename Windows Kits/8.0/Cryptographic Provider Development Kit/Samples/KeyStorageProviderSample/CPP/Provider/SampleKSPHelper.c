// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

/*++

Abstract:
    Helper functions for sample CNG RSA key storage provider

Implementation Note:
   In several places this sample returns a single, generic SECURITY_STATUS error when a called function
   returns any Win32 error.  This is only done for the sake of brevity in the sample.

   As a best practice, production code should provide a function to convert Win32 errors
   to appropriate SECURITY_STATUS errors, and use it to set SECURITY_STATUS error
   variables accurately.  This would allow relevant troubleshooting error information
   to propagate out of the KSP.
--*/

///////////////////////////////////////////////////////////////////////////////
//
// Headers...
//
///////////////////////////////////////////////////////////////////////////////
#include <windows.h>
#include <wincrypt.h>
#include <bcrypt.h>
#include <ncrypt.h>
#include <intsafe.h>
#include <strsafe.h>
#include "..\inc\SampleKSP.h"

///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of local routines
//
///////////////////////////////////////////////////////////////////////////////

BCRYPT_RSAKEY_BLOB*
SampleKspValidateRSACNGPrivateKey(
    __in_bcount(cbKeyBlob)  PBYTE pbKeyBlob,
    __in  DWORD cbKeyBlob);

SECURITY_STATUS
AllocAndDecryptPrivateKey(
    __in_bcount(cbEncPrivateKey) 
          PBYTE pbEncPrivateKey,
    __in  DWORD cbEncPrivateKey,
    __deref_out_bcount(*pcbOutput)
          PBYTE *ppbOutput,
    __out DWORD *pcbOutput);


///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
*
* DESCRIPTION :     Convert NTSTATUS error code to SECURITY_STATUS error code
*
* INPUTS :
*            NTSTATUS NtStatus          Error code of NTSTATUS format
* RETURN :
*            SECURITY_STATUS            Converted error code
*/
SECURITY_STATUS
NormalizeNteStatus(
    __in NTSTATUS NtStatus)
{
    SECURITY_STATUS SecStatus;

    switch (NtStatus)
    {
        case STATUS_SUCCESS:
            SecStatus = ERROR_SUCCESS;
            break;

        case STATUS_NO_MEMORY:
        case STATUS_INSUFFICIENT_RESOURCES:
            SecStatus = NTE_NO_MEMORY;
            break;

        case STATUS_INVALID_PARAMETER:
            SecStatus = NTE_INVALID_PARAMETER;
            break;

        case STATUS_INVALID_HANDLE:
            SecStatus = NTE_INVALID_HANDLE;
            break;

        case STATUS_BUFFER_TOO_SMALL:
            SecStatus = NTE_BUFFER_TOO_SMALL;
            break;

        case STATUS_NOT_SUPPORTED:
            SecStatus = NTE_NOT_SUPPORTED;
            break;

        case STATUS_INTERNAL_ERROR:
        case ERROR_INTERNAL_ERROR:
            SecStatus = NTE_INTERNAL_ERROR;
            break;

        case STATUS_INVALID_SIGNATURE:
            SecStatus = NTE_BAD_SIGNATURE;
            break;

        default:
            SecStatus=NTE_INTERNAL_ERROR;
            break;
    }

    return SecStatus;
}

///////////////////////////////////////////////////////////////////////////////
/*****************************************************************************
* DESCRIPTION :    Validate sample KSP provider handle
*
* INPUTS :
*           NCRYPT_PROV_HANDLE hProvider                A NCRYPT_PROV_HANDLE handle
*
* RETURN :
*           A pointer to a SAMPLEKSP_PROVIDER struct    The function was successful.
*           NULL                                        The handle is invalid.
*/
SAMPLEKSP_PROVIDER *
SampleKspValidateProvHandle(
    __in    NCRYPT_PROV_HANDLE hProvider)
{
    SAMPLEKSP_PROVIDER *pProvider = NULL;

    if(hProvider == 0)
    {
        return NULL;
    }

    pProvider = (SAMPLEKSP_PROVIDER *)hProvider;

    if(pProvider->cbLength < sizeof(SAMPLEKSP_PROVIDER) ||
       pProvider->dwMagic != SAMPLEKSP_PROVIDER_MAGIC)
    {
        return NULL;
    }

    return pProvider;
}

/*****************************************************************************
* DESCRIPTION :    Validate sample KSP key handle
*
* INPUTS :
*           NCRYPT_KEY_HANDLE hKey                 An NCRYPT_KEY_HANDLE handle
*
* RETURN :
*           A pointer to a SAMPLEKSP_KEY struct    The function was successful.
*           NULL                                   The handle is invalid.
*/
SAMPLEKSP_KEY *
SampleKspValidateKeyHandle(
    __in    NCRYPT_KEY_HANDLE hKey)
{
    SAMPLEKSP_KEY *pKey = NULL;

    if(hKey == 0)
    {
        return NULL;
    }

    pKey = (SAMPLEKSP_KEY *)hKey;

    if(pKey->cbLength < sizeof(SAMPLEKSP_KEY) ||
       pKey->dwMagic != SAMPLEKSP_KEY_MAGIC)
    {
        return NULL;
    }

    return pKey;
}

/*****************************************************************************
* DESCRIPTION :    Validate a CNG Key Blob
*
* INPUTS :
*          PBYTE pbKeyBlob               A CNG key Blob
*
* RETURN :
*          A pointer to a BCRYPT_RSAKEY_BLOB struct    The function was successful.
*          NULL                                        The handle is not a valid
*                                                      CNG RSA private key blob.
*/
BCRYPT_RSAKEY_BLOB*
SampleKspValidateRSACNGPrivateKey(
    __in_bcount(cbKeyBlob)
          PBYTE pbKeyBlob,
    __in  DWORD cbKeyBlob)
{
   DWORD    cbCount = 0;
   BCRYPT_RSAKEY_BLOB* rsaCNGKeyBlob = NULL;

   if (pbKeyBlob == 0)
   {
       return NULL;
   }

   if (cbKeyBlob < sizeof(BCRYPT_RSAKEY_BLOB))
   {
       return NULL;
   }

   rsaCNGKeyBlob = (BCRYPT_RSAKEY_BLOB*) pbKeyBlob;

   if((rsaCNGKeyBlob->Magic != BCRYPT_RSAPRIVATE_MAGIC &&
      rsaCNGKeyBlob->Magic != BCRYPT_RSAFULLPRIVATE_MAGIC)||
      rsaCNGKeyBlob->BitLength < SAMPLEKSP_RSA_MIN_LENGTH ||
      rsaCNGKeyBlob->BitLength > SAMPLEKSP_RSA_MAX_LENGTH ||
      rsaCNGKeyBlob->BitLength % SAMPLEKSP_RSA_INCREMENT !=0)
   {
       return NULL;
   }

   if (ULongAdd(rsaCNGKeyBlob->cbModulus,rsaCNGKeyBlob->cbPrime1,&cbCount)!=S_OK||
       ULongAdd(cbCount,rsaCNGKeyBlob->cbPrime2,&cbCount)!=S_OK ||
       ULongAdd(cbCount,rsaCNGKeyBlob->cbPublicExp,&cbCount)!=S_OK)
   {
        return NULL;
   }

   if (rsaCNGKeyBlob->Magic == BCRYPT_RSAFULLPRIVATE_MAGIC)
   {
        if (ULongAdd(cbCount,rsaCNGKeyBlob->cbPrime1*2,&cbCount)!=S_OK||
            ULongAdd(cbCount,rsaCNGKeyBlob->cbPrime2,&cbCount)!=S_OK ||
            ULongAdd(cbCount,rsaCNGKeyBlob->cbModulus,&cbCount)!=S_OK)
        {
            return NULL;
        }
   }
   if (cbKeyBlob<cbCount)
   {
        return NULL;
   }

   return rsaCNGKeyBlob;

}

///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
*
* DESCRIPTION :  Decrypt the private key blob
*
* INPUTS :
*           PBYTE pbEncPrivateKey      Encrypted private key blob
*           DWORD cbEncPrivateKey      Length of the encrypted private key bob
* OUTPUTS :
*           PBYTE *ppbOutput           Plain text private key blob
*           DWORD *pcbOutput           Length of the private key blob in plain text
* RETURN :
*           ERROR_SUCCESS              The function was successful.
*           NTE_NO_MEMORY              A memory allocation failure occurred.
*           NTE_INTERNAL_ERROR         CryptUnprotectData failed
*/
SECURITY_STATUS
AllocAndDecryptPrivateKey(
    __in_bcount(cbEncPrivateKey) PBYTE pbEncPrivateKey,
    __in DWORD cbEncPrivateKey,
    __deref_out PBYTE *ppbOutput,
    __out DWORD *pcbOutput)
{
    CRYPT_DATA_BLOB DataIn = {0};
    CRYPT_DATA_BLOB DataOut = {0};
    BCRYPT_RSAKEY_BLOB* pCNGRsaKeyBlob = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    DataIn.pbData = pbEncPrivateKey;
    DataIn.cbData = cbEncPrivateKey;
    if (!CryptUnprotectData(
                &DataIn,
                NULL,
                NULL,
                NULL,
                NULL,
                CRYPTPROTECT_UI_FORBIDDEN,
                &DataOut))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    //Valide the cng rsa key blob.
    pCNGRsaKeyBlob = SampleKspValidateRSACNGPrivateKey(
                            DataOut.pbData,
                            DataOut.cbData);
    if (pCNGRsaKeyBlob == NULL)
    {
        Status = NTE_BAD_KEY;
        goto cleanup;
    }

    //Assign the output.
    *ppbOutput= (PBYTE)HeapAlloc(GetProcessHeap(),0,DataOut.cbData);

    if(*ppbOutput == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    CopyMemory(*ppbOutput, DataOut.pbData, DataOut.cbData);

    *pcbOutput = DataOut.cbData;

    Status = ERROR_SUCCESS;

cleanup:
    if(DataOut.pbData)
    {
        SecureZeroMemory(DataOut.pbData, DataOut.cbData);
        LocalFree(DataOut.pbData);
    }
    return Status;
}

/******************************************************************************
*
* DESCRIPTION : Protect the plain text private key and attach it to the key
*               object.
*
* INPUTS :
*               LPCWSTR pszBlobType    Type of the key blob
*               PBYTE  pbInput         CNG RSA private key blob
*               DWORD  cbInput         Length of the key blob
*               SAMPLEKSP_KEY* pKey    Sample KSP key handle
* OUTPUTS :
*               SAMPLEKSP_KEY* pKey    Sample KSP key handle with private key
*                                      attached.
* RETURN :
*               ERROR_SUCCESS          The function was successful.
*               NTE_BAD_DATA           The key blob is not valid.
*               NTE_NO_MEMORY          A memory allocation failure occurred.
*               HRESULT                Error information returned by CryptProtectData
*/
SECURITY_STATUS
ProtectAndSetPrivateKey(
    __in LPCWSTR pszBlobType,
    __in_bcount(cbKeyBlob)
         PBYTE  pbKeyBlob,
    __in DWORD  cbKeyBlob,
    __inout SAMPLEKSP_KEY* pKey)
{
   DATA_BLOB DataIn= {0};
   DATA_BLOB DataOut= {0};
   BCRYPT_RSAKEY_BLOB* rsaKeyBlob = NULL;
   SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

   //Validate the blob.
   rsaKeyBlob = SampleKspValidateRSACNGPrivateKey(pbKeyBlob,cbKeyBlob);
   if (rsaKeyBlob == NULL)
   {
        Status = NTE_BAD_KEY;
        goto cleanup;
   }

   //Set the key length.
   pKey->dwKeyBitLength =  rsaKeyBlob->BitLength;
   //Set the key type.
   if(wcscmp(pszBlobType, BCRYPT_PRIVATE_KEY_BLOB) == 0)
   {
        pKey->pszKeyBlobType = BCRYPT_RSAPRIVATE_BLOB;

   }
   else
   {
        pKey->pszKeyBlobType = (LPWSTR)pszBlobType;
   }

   //Encrypt the private key blob
   DataIn.pbData = pbKeyBlob;
   DataIn.cbData = cbKeyBlob;
   if(!CryptProtectData(
                 &DataIn,
                 L"Private Key",
                 NULL,
                 NULL,
                 NULL,
                 CRYPTPROTECT_UI_FORBIDDEN,
                 &DataOut
                 ))
   {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
   }

    // Attach the blob to the key object. It will be processed further
    // once the key is finalized.
    if(pKey->pbPrivateKey)
    {   //If there is already a private key attached to the key object,
        //clean the old key.
        SecureZeroMemory(pKey->pbPrivateKey, pKey->cbPrivateKey);
        HeapFree(GetProcessHeap(),0,pKey->pbPrivateKey);
    }

    pKey->pbPrivateKey = (PBYTE)HeapAlloc(GetProcessHeap(),0, DataOut.cbData);

    if(pKey->pbPrivateKey == NULL)
    {
        Status=NTE_NO_MEMORY;
        goto cleanup;
    }

    CopyMemory(pKey->pbPrivateKey, DataOut.pbData, DataOut.cbData);
    pKey->cbPrivateKey =DataOut.cbData;
    Status = ERROR_SUCCESS;
cleanup:
    if (DataOut.pbData)
    {
        LocalFree(DataOut.pbData);
    }
    return Status;
}

/******************************************************************************
*
* DESCRIPTION : Import the CNG key blob attached to the sample KSP key object
*               to create the BCrypt key handle.
* INPUTS :
*               SAMPLEKSP_KEY *pKey      The key object to update
* RETURN :
*               ERROR_SUCCESS            The function was successful.
*               NTE_BAD_DATA             Invalid key blob type.
*               NTE_NO_MEMORY            A memory allocation failure occurred.
*               NTE_INTERNAL_ERROR       AllocAndDecryptPrivateKey failed.
*/
SECURITY_STATUS
ImportRsaKeyPair(
    __inout SAMPLEKSP_KEY *pKey)
{
    PBYTE pbBlob = NULL;
    DWORD cbBlob = 0;
    PBYTE pbPubKeyBlob = NULL;
    DWORD cbPubKeyBlob = 0;
    BCRYPT_RSAKEY_BLOB* pCNGRSAKeyBlob = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    NTSTATUS ntStatus = STATUS_INTERNAL_ERROR;

    //If the private key already exist, release the private key.
    if(pKey->hPrivateKey)
    {
        BCryptDestroyKey(pKey->hPrivateKey);
        pKey->hPrivateKey = NULL;
    }

    //Unprotect the private key blob.
    Status = AllocAndDecryptPrivateKey(
                pKey->pbPrivateKey,
                pKey->cbPrivateKey,
                &pbBlob,
                &cbBlob);
    if(Status!=ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Assign the key length.
    pCNGRSAKeyBlob = (BCRYPT_RSAKEY_BLOB*)pbBlob;
    pKey->dwKeyBitLength = pCNGRSAKeyBlob->BitLength;
    //Find out the key blob type
    if (pCNGRSAKeyBlob->Magic == BCRYPT_RSAFULLPRIVATE_MAGIC)
    {
        pKey->pszKeyBlobType = BCRYPT_RSAFULLPRIVATE_BLOB;
    }
    else if (pCNGRSAKeyBlob->Magic== BCRYPT_RSAPRIVATE_MAGIC)
    {
        pKey->pszKeyBlobType = BCRYPT_RSAPRIVATE_BLOB;
    }
    else
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    //Import the private key blob that was earlier attached to the key object.
    ntStatus = BCryptImportKeyPair(
                        pKey->hProvider,
                        NULL,
                        pKey->pszKeyBlobType,
                        &pKey->hPrivateKey,
                        pbBlob,
                        cbBlob,
                        0);
    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }


    // Export the key material into a CNG public key blob.
    ntStatus = BCryptExportKey(
                        pKey->hPrivateKey,
                        NULL,
                        BCRYPT_RSAPUBLIC_BLOB,
                        NULL,
                        0,
                        &cbPubKeyBlob,
                        0);

    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    pbPubKeyBlob = (PBYTE) HeapAlloc(GetProcessHeap(),0,cbPubKeyBlob);

    if(pbPubKeyBlob  == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    ntStatus = BCryptExportKey(
                        pKey->hPrivateKey,
                        NULL,
                        BCRYPT_RSAPUBLIC_BLOB,
                        pbPubKeyBlob,
                        cbPubKeyBlob,
                        &cbPubKeyBlob,
                        0);
    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }


    // Import the public key, so that we have a handle
    // to that available if it's needed later.
    ntStatus = BCryptImportKeyPair(
                        pKey->hProvider,
                        NULL,
                        BCRYPT_RSAPUBLIC_BLOB,
                        &pKey->hPublicKey,
                        pbPubKeyBlob,
                        cbPubKeyBlob,
                        0);
    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    Status = ERROR_SUCCESS;

cleanup:

    if(pbBlob)
    {
       SecureZeroMemory(pbBlob,cbBlob);
       HeapFree(GetProcessHeap(),0,pbBlob);
    }
    if(pbPubKeyBlob)
    {
       HeapFree(GetProcessHeap(),0,pbPubKeyBlob);
    }
    return Status;
}

/******************************************************************************
*
* DESCRIPTION : Export the private key into a plain text key blob.
*               If there is a BCrypt private key handle associated with the key,
*               then export the key blob from the BCrypt key handle,
*               otherwise unprotect the private key blob associated with the key
*               object.
* INPUTS :
*               SAMPLEKSP_KEY *pKey         The key object
*               LPWSTR pszExportBlobType    The type of the key
*               PBYTE **pbCngKeyBlob        CNG RSA key blob
*               DWORD *cbCngKeyBlob         Length of the key blob
* RETURN :
*               ERROR_SUCCESS            The function was successful.
*               NTE_BAD_DATA             Invalid key blob type.
*               NTE_NO_MEMORY            A memory allocation failure occurred.
*               NTE_INTERNAL_ERROR       CryptUnprotectData failed.
*/
SECURITY_STATUS
AllocAndGetRsaPrivateKeyBlob(
    __inout SAMPLEKSP_KEY *pKey,
    __in    LPCWSTR pszExportBlobType,
    __deref_out_bcount(cbCngKeyBlob) PBYTE *pbCngKeyBlob,
    __out DWORD *cbCngKeyBlob)
{

    PBYTE pbBlob = NULL;
    DWORD cbBlob = 0;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    NTSTATUS ntStatus = STATUS_INTERNAL_ERROR;

    //We will always use the private key blob when it is not NULL,
    //so the newly set private key will overwrite the old key.
    if(pKey->pbPrivateKey == NULL)
    {
        // Get the plaintext private key.
        ntStatus = BCryptExportKey(pKey->hPrivateKey,
                                 NULL,
                                 pszExportBlobType,
                                 NULL,
                                 cbBlob,
                                 &cbBlob,
                                 0);
        if ( !NT_SUCCESS(ntStatus))
        {
            Status = NormalizeNteStatus(ntStatus);
            goto cleanup;
        }

        pbBlob = (PBYTE)HeapAlloc(GetProcessHeap(),0,cbBlob);
        if (pbBlob == NULL)
        {
            Status =NTE_NO_MEMORY;
            goto cleanup;
        }

        ntStatus = BCryptExportKey(
                             pKey->hPrivateKey,
                             NULL,
                             pszExportBlobType,
                             pbBlob,
                             cbBlob,
                             &cbBlob,
                             0);
        if ( !NT_SUCCESS(ntStatus))
        {
            Status = NormalizeNteStatus(ntStatus);
            goto cleanup;
        }
    }
    else
    {
        //Unprotect the private key blob.
        Status = AllocAndDecryptPrivateKey(
                    pKey->pbPrivateKey,
                    pKey->cbPrivateKey,
                    &pbBlob,
                    &cbBlob);
        if(Status!=ERROR_SUCCESS)
        {
            goto cleanup;
        }

        if(wcscmp( pszExportBlobType, BCRYPT_RSAFULLPRIVATE_BLOB) == 0)
        {
            BCRYPT_KEY_BLOB* pCNGKeyBlob = (BCRYPT_KEY_BLOB*)pbBlob;
            if (pCNGKeyBlob->Magic != BCRYPT_RSAFULLPRIVATE_MAGIC)
            {   BCRYPT_KEY_HANDLE   hKey = NULL;
                DWORD       cbRsaFullKey = 0;
                NTSTATUS    ntStatus = NTE_INTERNAL_ERROR;

                //We need to convert it into a full private key blob.
                ntStatus = BCryptImportKeyPair(
                                    pKey->hProvider,
                                    NULL,
                                    BCRYPT_RSAPRIVATE_BLOB,
                                    &hKey,
                                    pbBlob,
                                    cbBlob,
                                    0);
                if(!NT_SUCCESS(ntStatus))
                {
                    Status = NormalizeNteStatus(ntStatus);
                    goto BailOut;
                }

                // Export the key material into an RSA full private key blob.
                ntStatus = BCryptExportKey(
                        hKey,
                        NULL,
                        BCRYPT_RSAFULLPRIVATE_BLOB,
                        NULL,
                        0,
                        &cbRsaFullKey,
                        0);
                if(!NT_SUCCESS(ntStatus))
                {
                    Status = NormalizeNteStatus(ntStatus);
                    goto BailOut;
                }

                SecureZeroMemory(pbBlob,cbBlob);
                HeapFree(GetProcessHeap(),0,pbBlob);
                pbBlob = HeapAlloc(GetProcessHeap(),0,cbRsaFullKey);
                if (pbBlob == NULL)
                {
                    Status = NTE_NO_MEMORY;
                    goto BailOut;
                }

                ntStatus = BCryptExportKey(
                        hKey,
                        NULL,
                        BCRYPT_RSAFULLPRIVATE_BLOB,
                        pbBlob,
                        cbRsaFullKey,
                        &cbBlob,
                        0);
                if(!NT_SUCCESS(ntStatus))
                {
                    Status = NormalizeNteStatus(ntStatus);
                    goto BailOut;
                }
            BailOut:
                if (hKey)
                {
                    BCryptDestroyKey(hKey);
                }
                if (!NT_SUCCESS(ntStatus))
                {
                    goto cleanup;
                }
            }
        }
    }

    *pbCngKeyBlob = pbBlob;
    pbBlob = NULL;
    *cbCngKeyBlob = cbBlob;
    Status = ERROR_SUCCESS;
cleanup:

    if(pbBlob)
    {
       SecureZeroMemory(pbBlob,cbBlob);
       HeapFree(GetProcessHeap(),0,pbBlob);
    }

    return Status;
}

/******************************************************************************
*
* DESCRIPTION : Finalize the sample KSP key object
*
* INPUTS :
*               SAMPLEKSP_KEY *pKey    The key object to finalize
* OUTPUTS :
*               SAMPLEKSP_KEY* pKey    Finalized key object
* RETURN :
*               ERROR_SUCCESS          The function was successful.
*               NTE_NO_MEMORY          A memory allocation failure occurred.
*
*/
SECURITY_STATUS
FinalizeKey(
    __inout SAMPLEKSP_KEY *pKey)
{
    NTSTATUS ntStatus = STATUS_INTERNAL_ERROR;
    SECURITY_STATUS Status = STATUS_INTERNAL_ERROR;
    PBYTE pbBlob = NULL;
    DWORD cbBlob = 0;
    BCRYPT_RSAKEY_BLOB *pPrivBlob = NULL;
    DWORD cbPublicBlob = 0;
    BCRYPT_RSAKEY_BLOB *pPublicBlob = NULL;

    //Finalize the private key
    ntStatus = BCryptFinalizeKeyPair(pKey->hPrivateKey, 0);
    if (!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    //Export the key into a key blob
    ntStatus = BCryptExportKey(pKey->hPrivateKey,
                             NULL,
                             pKey->pszKeyBlobType,
                             NULL,
                             0,
                             &cbBlob,
                             0);

    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    pbBlob = (PBYTE)HeapAlloc(GetProcessHeap(),0,cbBlob);
    if(pbBlob == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    Status = BCryptExportKey(pKey->hPrivateKey,
                             NULL,
                             pKey->pszKeyBlobType,
                             pbBlob,
                             cbBlob,
                             &cbBlob,
                             0);
    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    pPrivBlob = (BCRYPT_RSAKEY_BLOB *)pbBlob;

    //Import the public key into pkey
    cbPublicBlob = sizeof(BCRYPT_RSAKEY_BLOB) +
                   pPrivBlob->cbPublicExp +
                   pPrivBlob->cbModulus;
    pPublicBlob = (BCRYPT_RSAKEY_BLOB*)HeapAlloc(GetProcessHeap(),0,cbPublicBlob);
    if (pPublicBlob == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    pPublicBlob->Magic       = BCRYPT_RSAPUBLIC_MAGIC;
    pPublicBlob->BitLength   = pPrivBlob->BitLength;
    pPublicBlob->cbPublicExp = pPrivBlob->cbPublicExp;
    pPublicBlob->cbModulus   = pPrivBlob->cbModulus;
    pPublicBlob->cbPrime1    = 0;
    pPublicBlob->cbPrime2    = 0;

    memcpy(pPublicBlob + 1, pPrivBlob + 1, pPrivBlob->cbPublicExp + pPrivBlob->cbModulus);


    ntStatus = BCryptImportKeyPair(
                        pKey->hProvider,
                        NULL,
                        BCRYPT_RSAPUBLIC_BLOB,
                        &pKey->hPublicKey,
                        (PBYTE)pPublicBlob,
                        cbPublicBlob,
                        0);
    if(ntStatus != ERROR_SUCCESS)
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    Status = ERROR_SUCCESS;

cleanup:
    if(pPrivBlob)
    {
        HeapFree(GetProcessHeap(),0,pPrivBlob);
    }
    if(pPublicBlob)
    {
         HeapFree(GetProcessHeap(),0,pPublicBlob);
    }
    return Status;
}

///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
*
* DESCRIPTION : Helper function that removes the memory buffer from the
*               sample KSP's list of allocated memory buffers, and returns
*               the buffer so it can be freed. (This function does not free
*               the buffer's memory from the heap.)
* INPUTS :
*               LIST_ENTRY *pBufferList  The list head.
                PVOID pvBuffer           The buffer to remove from the list.
* RETURN :
*               SAMPLEKSP_MEMORY_BUFFER  The memory buffer found.
*               NULL                     There is no such buffer in the list.
*/
SAMPLEKSP_MEMORY_BUFFER *
RemoveMemoryBuffer(
    __in LIST_ENTRY *pBufferList,
    __in PVOID pvBuffer)
{
    PLIST_ENTRY pList = {0};
    SAMPLEKSP_MEMORY_BUFFER *pBuffer = NULL;
    BOOL fFound = FALSE;

    pList = pBufferList->Flink;

    while(pList != pBufferList)
    {
        pBuffer = CONTAINING_RECORD(pList, SAMPLEKSP_MEMORY_BUFFER, List.Flink);
        pList = pList->Flink;

        if(pBuffer->pvBuffer == pvBuffer)
        {
            RemoveEntryList(&pBuffer->List);
            fFound = TRUE;
            break;
        }
    }

    if(fFound)
    {
        return pBuffer;
    }
    else
    {
        return NULL;
    }
}

/******************************************************************************
*
* DESCRIPTION : Lookup the buffer in the allocated sample KSP memory buffer
*               list.
*
* INPUTS :
*               LIST_ENTRY *pBufferList  The list head.
                PVOID pvBuffer           The buffer to look for.
* RETURN :
*               SAMPLEKSP_MEMORY_BUFFER  The memory buffer found.
*               NULL                     There is no such buffer in the list.
*/
SAMPLEKSP_MEMORY_BUFFER *
LookupMemoryBuffer(
    __in LIST_ENTRY *pBufferList,
    __in PVOID pvBuffer)
{
    PLIST_ENTRY pList = {0};
    SAMPLEKSP_MEMORY_BUFFER *pBuffer = NULL;
    BOOL fFound = FALSE;


    pList = pBufferList->Flink;

    while(pList != pBufferList)
    {
        pBuffer = CONTAINING_RECORD(pList, SAMPLEKSP_MEMORY_BUFFER, List.Flink);
        pList = pList->Flink;

        if(pBuffer->pvBuffer == pvBuffer)
        {
            fFound = TRUE;
            break;
        }
    }


    if(fFound)
    {
        return pBuffer;
    }
    else
    {
        return NULL;
    }

}

///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
*
* DESCRIPTION : Creates a new sample KSP key object.
*
* INPUTS :
*               LPCWSTR                Name of the key (keyfile)
* OUTPUTS :
*               SAMPLEKSP_KEY* pKey    New sample KSP key object
* RETURN :
*               ERROR_SUCCESS          The function was successful.
*               NTE_BAD_DATA           The key blob is not valid.
*               NTE_NO_MEMORY          A memory allocation failure occurred.
*               HRESULT                Error information returned by CryptProtectData.
*/
SECURITY_STATUS
WINAPI
CreateNewKeyObject(
    __in_opt LPCWSTR pszKeyName,
    __deref_out SAMPLEKSP_KEY **ppKey)
{
    SAMPLEKSP_KEY *pKey = NULL;
    DWORD   cbKeyName = 0;
    SECURITY_STATUS   Status = NTE_INTERNAL_ERROR;
    NTSTATUS          ntStatus = STATUS_INTERNAL_ERROR;

    //Initialize the key object.
    pKey = (SAMPLEKSP_KEY *)HeapAlloc (GetProcessHeap (),0,sizeof(SAMPLEKSP_KEY));
    if (pKey==NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    pKey->cbLength = sizeof(SAMPLEKSP_KEY);
    pKey->dwMagic  = SAMPLEKSP_KEY_MAGIC;
    pKey->dwAlgID = SAMPLEKSP_RSA_ALGID;
    pKey->pszKeyFilePath = NULL;
    pKey->pszKeyBlobType = NULL;
    pKey->dwKeyBitLength = 0;
    pKey->fFinished = FALSE;

    //Copy the keyname into the key struct.
    if (pszKeyName != NULL)
    {
        cbKeyName = (DWORD)(wcslen(pszKeyName) + 1)*sizeof(WCHAR);
        if(cbKeyName > MAX_PATH)
        {
            Status = NTE_INVALID_PARAMETER;
            goto cleanup;
        }
        cbKeyName = cbKeyName * sizeof(WCHAR);
        pKey->pszKeyName = (LPWSTR)HeapAlloc (GetProcessHeap (),0,cbKeyName);
        if(pKey->pszKeyName == NULL)
        {
            Status = NTE_NO_MEMORY;
            goto cleanup;
        }
        CopyMemory(pKey->pszKeyName, pszKeyName, cbKeyName);
    }
    else
    {
        pKey->pszKeyName = NULL;
    }

    //Create the BCrypt handle.
    if (g_hRSAProvider==NULL)
    {
        //If cached handle is NULL, open the default RSA algorithm provider.
        ntStatus = BCryptOpenAlgorithmProvider(
                    &g_hRSAProvider,
                    BCRYPT_RSA_ALGORITHM,
                    NULL,
                    0);
        if(!NT_SUCCESS(ntStatus))
        {
            Status = NormalizeNteStatus(ntStatus);
            goto cleanup;
        }

    }
    pKey->hProvider = g_hRSAProvider;

    //Key file is initially NULL.
    pKey->pbKeyFile = NULL;
    pKey->cbKeyFile =0;

    //Priavate key is NULL.
    pKey->pbPrivateKey = NULL;
    pKey->cbPrivateKey = 0;

    //The handles are all NULL.
    pKey->hPublicKey = NULL;
    pKey->hPrivateKey = NULL;

    //Key is exportable.
    pKey->dwExportPolicy = NCRYPT_ALLOW_EXPORT_FLAG|NCRYPT_ALLOW_PLAINTEXT_EXPORT_FLAG;

    //The usage of the key is for encrption or signing.
    pKey->dwKeyUsagePolicy = NCRYPT_ALLOW_DECRYPT_FLAG|NCRYPT_ALLOW_SIGNING_FLAG;

    //Security descriptor is intially NULL.
    pKey->pbSecurityDescr = NULL;
    pKey->cbSecurityDescr = 0;

    //Initialize the property list.
    InitializeListHead(&pKey->PropertyList);

    *ppKey = pKey;
    pKey = NULL;
    Status = ERROR_SUCCESS;

cleanup:
    if (pKey != NULL)
    {
        DeleteKeyObject(pKey);
    }
    return Status;
}


/******************************************************************************
*
* DESCRIPTION : Deletes the passed key object from the sample KSP.
*
* INPUTS :
*               SAMPLEKSP_KEY *pKey    The key object to delete.
* RETURN :
*               ERROR_SUCCESS          The function was successful.
*/
SECURITY_STATUS
WINAPI
DeleteKeyObject(
     __inout SAMPLEKSP_KEY *pKey)
{
    PLIST_ENTRY pList = {0};
    SAMPLEKSP_PROPERTY *pProperty = NULL;
    SECURITY_STATUS Status = ERROR_SUCCESS;
    NTSTATUS ntStatus=STATUS_INTERNAL_ERROR;

    //Delete the path to the key storage area.
    if (pKey->pszKeyFilePath)
    {
        HeapFree(GetProcessHeap(),0,pKey->pszKeyFilePath);
        pKey->pszKeyFilePath = NULL;
    }

    //Delete the key name.
    if (pKey->pszKeyName)
    {
        HeapFree(GetProcessHeap(),0,pKey->pszKeyName);
        pKey->pszKeyName = NULL;
    }

    //Delete key file data blob.
    if (pKey->pbKeyFile)
    {
        HeapFree(GetProcessHeap(),0,pKey->pbKeyFile);
        pKey->pbKeyFile = NULL;
    }

    //Delete public key handle.
    if (pKey->hPublicKey)
    {
        ntStatus = BCryptDestroyKey(pKey->hPublicKey);
        if(!NT_SUCCESS(ntStatus))
        {
            Status=NormalizeNteStatus(ntStatus);
        }
        pKey->hPublicKey = NULL;
    }

    //Delete private key handle.
    if (pKey->hPrivateKey)
    {
        ntStatus = BCryptDestroyKey(pKey->hPrivateKey);
        if(!NT_SUCCESS(ntStatus))
        {
            Status=NormalizeNteStatus(ntStatus);
        }
        pKey->hPrivateKey = NULL;
    }

    //Delete security descriptor.
    if (pKey->pbSecurityDescr)
    {
        HeapFree(GetProcessHeap(),0,pKey->pbSecurityDescr);
        pKey->pbSecurityDescr = NULL;
    }


    //Delete private key blob.
    if (pKey->pbPrivateKey)
    {
        SecureZeroMemory(pKey->pbPrivateKey,pKey->cbPrivateKey);
        HeapFree(GetProcessHeap(),0,pKey->pbPrivateKey);
        pKey->pbPrivateKey = NULL;
    }

    //Delete the property list.
    pList = pKey->PropertyList.Flink;
    while(pList != &pKey->PropertyList)
    {
        pProperty = CONTAINING_RECORD(
                            pList,
                            SAMPLEKSP_PROPERTY,
                            ListEntry.Flink);
        pList = pList->Flink;

        RemoveEntryList(&pProperty->ListEntry);
        HeapFree(GetProcessHeap(),0,pProperty);
    }

    return Status;
}

///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
*
* DESCRIPTION : Create a new property object
*
* INPUTS :
*           LPCWSTR pszProperty     Name of the property
*           PBYTE   pbProperty      Value of the property
*           DWORD   cbProperty      Length of the property
*           DWORD   dwFlags         Persisted property or not
* OUTPUTS:
*           SAMPLEKSP_PROPERTY    **ppProperty   The new property object
* RETURN :
*           ERROR_SUCCESS          The function was successful.
*           NTE_NO_MEMORY          A memory allocation failure occurred.
*           NTE_INVALID_PARAMETER  Invalid parameter
*/
SECURITY_STATUS
CreateNewProperty(
    __in_opt                LPCWSTR pszProperty,
    __in_bcount(cbProperty) PBYTE   pbProperty,
    __in                    DWORD   cbProperty,
    __in                    DWORD   dwFlags,
    __deref_out             SAMPLEKSP_PROPERTY    **ppProperty)
{
    SAMPLEKSP_PROPERTY *pProperty = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    pProperty = (SAMPLEKSP_PROPERTY *)HeapAlloc(
                        GetProcessHeap(),
                        0,
                        sizeof(SAMPLEKSP_PROPERTY) + cbProperty);
    if(pProperty == NULL)
    {
        return NTE_NO_MEMORY;
    }

    //Copy the property name.
    Status = StringCchCopyW(pProperty->szName,
                            sizeof(pProperty->szName)/sizeof(WCHAR),
                            pszProperty);
    if(Status != ERROR_SUCCESS)
    {
            HeapFree(GetProcessHeap(),0,pProperty);
            return NTE_INVALID_PARAMETER;
    }

    pProperty->cbPropertyData = cbProperty;

    if (dwFlags & NCRYPT_PERSIST_ONLY_FLAG)
    {
        pProperty->fBuildin = FALSE;
    }
    else
    {
        pProperty->fBuildin = TRUE;
    }

    if(dwFlags & (NCRYPT_PERSIST_FLAG | NCRYPT_PERSIST_ONLY_FLAG))
    {
        //Persisted property.
        pProperty->fPersisted = TRUE;
    }
    else
    {   //Non-persisted property.
        pProperty->fPersisted = FALSE;
    }
    //Copy the property value.
    CopyMemory((PBYTE)(pProperty + 1), pbProperty, cbProperty);

    *ppProperty = pProperty;

    return ERROR_SUCCESS;
}

/******************************************************************************
*
* DESCRIPTION : Look for property object in the property list of the key.
*
* INPUTS :
*            SAMPLEKSP_KEY *pKey    Key object
*            LPCWSTR pszProperty,   Name of the property
* OUTPUTS:
*           SAMPLEKSP_PROPERTY    **ppProperty   The property object found
* RETURN :
*           ERROR_SUCCESS          The function was successful.
*           NTE_NOT_FOUND          No such property exists.
*/
SECURITY_STATUS
LookupExistingKeyProperty(
    __in    SAMPLEKSP_KEY *pKey,
    __in    LPCWSTR pszProperty,
    __out   SAMPLEKSP_PROPERTY **ppProperty)
{
    PLIST_ENTRY pList;
    SAMPLEKSP_PROPERTY *pProperty;

    pList = pKey->PropertyList.Flink;

    while(pList != &pKey->PropertyList)
    {
        pProperty = CONTAINING_RECORD(pList, SAMPLEKSP_PROPERTY, ListEntry.Flink);
        pList = pList->Flink;

        if(wcscmp(pszProperty, pProperty->szName) == 0)
        {
            *ppProperty = pProperty;
            return ERROR_SUCCESS;
        }
    }

    return NTE_NOT_FOUND;
}


/******************************************************************************
*
* DESCRIPTION : Set a nonpersistent property on the key object.
*
* INPUTS :
*           SAMPLEKSP_KEY *pKey    Key object
*           LPCWSTR pszProperty    Name of the property
*           PBYTE    pbInput       Value of the property
*           DWORD    cbInput       Length of the property value buffer
*           DWORD*   dwFlags       Flags
* OUTPUTS:
*           DWORD*   dwFlags       Whether the property should also be persisted
* RETURN :
*           ERROR_SUCCESS          The function was successful.
*           NTE_BAD_DATA           The property value is invalid.
*           NTE_BAD_KEY_STATE      The key is already written to the file system.
*           NTE_NOT_SUPPORTED      The operation is not supported.
*           NTE_NO_MEMORY          A memory allocation failure occurred.
*/
SECURITY_STATUS
SetBuildinKeyProperty(
    __inout    SAMPLEKSP_KEY           *pKey,
    __in    LPCWSTR pszProperty,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __inout    DWORD*   dwFlags)
{
    SECURITY_STATUS         Status = NTE_INTERNAL_ERROR;
    NTSTATUS                NtStatus = STATUS_INTERNAL_ERROR;
    DWORD                   dwPolicy = 0;
    LPCWSTR                 pszTmpProperty = pszProperty;
    DWORD                   dwTempFlags = *dwFlags;

    if(wcscmp(pszTmpProperty, NCRYPT_EXPORT_POLICY_PROPERTY) == 0)
    {
        if(cbInput != sizeof(DWORD))
        {
            Status = NTE_BAD_DATA;
            goto cleanup;
        }
        if(pKey->fFinished ==TRUE)
        {
            // This property can only be set before the key is written
            // to the file system.
            Status = NTE_BAD_KEY_STATE;
            goto cleanup;
        }

        dwPolicy = *(DWORD *)pbInput;

        if((dwPolicy & ~(NCRYPT_ALLOW_EXPORT_FLAG |
                         NCRYPT_ALLOW_PLAINTEXT_EXPORT_FLAG |
                         NCRYPT_ALLOW_ARCHIVING_FLAG |
                         NCRYPT_ALLOW_PLAINTEXT_ARCHIVING_FLAG)) != 0)
        {
            // Only support the listed set of policy flags.
            Status = NTE_NOT_SUPPORTED;
            goto cleanup;
        }

        pKey->dwExportPolicy = dwPolicy;

        // Allow this copy of the key to be exported if one of the
        // archive flags is set.
        if((dwPolicy & NCRYPT_ALLOW_ARCHIVING_FLAG) != 0)
        {
            pKey->dwExportPolicy |= NCRYPT_ALLOW_EXPORT_FLAG;
        }
        if((dwPolicy & NCRYPT_ALLOW_PLAINTEXT_ARCHIVING_FLAG) != 0)
        {
            pKey->dwExportPolicy |= NCRYPT_ALLOW_PLAINTEXT_EXPORT_FLAG;
        }

        // Clear the archive flags so that they don't get stored to disk.
        dwPolicy &= ~(NCRYPT_ALLOW_ARCHIVING_FLAG | NCRYPT_ALLOW_PLAINTEXT_ARCHIVING_FLAG);
        //This property should be persistent and needs to be written back to the
        //file system.
        dwTempFlags |= NCRYPT_PERSIST_FLAG;

    }
    else if(wcscmp(pszTmpProperty, NCRYPT_KEY_USAGE_PROPERTY) == 0)
    {
        if(cbInput != sizeof(DWORD))
        {
            Status = NTE_BAD_DATA;
            goto cleanup;
        }

        if(pKey->fFinished == TRUE)
        {
            // This property can only be set before the key is finalized.
            Status = NTE_BAD_KEY_STATE;
            goto cleanup;
        }

        pKey->dwKeyUsagePolicy = *(DWORD *)pbInput;

         //This property should be persistent and needs to be written back to the
         //file system.
        dwTempFlags |= NCRYPT_PERSIST_FLAG;
    }
    else if(wcscmp(pszTmpProperty, NCRYPT_LENGTH_PROPERTY) == 0)
    {
        if(cbInput != sizeof(DWORD))
        {
            Status = NTE_BAD_DATA;
            goto cleanup;
        }
        if(pKey->fFinished == TRUE)
        {
            // This property can only be set before the key is finalized.
            Status = NTE_BAD_KEY_STATE;
            goto cleanup;
        }

        pKey->dwKeyBitLength = *(DWORD *)pbInput;
        // Make sure that the specified length is one that we support.
        if(pKey->dwKeyBitLength < SAMPLEKSP_RSA_MIN_LENGTH ||
           pKey->dwKeyBitLength > SAMPLEKSP_RSA_MAX_LENGTH ||
           pKey->dwKeyBitLength % SAMPLEKSP_RSA_INCREMENT)
        {
            Status = NTE_NOT_SUPPORTED;
            goto cleanup;
        }

        // Key length is not persisted, and clear the persisted
        // flag if it's set.
        dwTempFlags &= ~NCRYPT_PERSIST_FLAG;

        //Update the property of the private key.
        NtStatus = BCryptSetProperty(
                        pKey->hPrivateKey,
                        BCRYPT_KEY_LENGTH,
                        pbInput,
                        cbInput,
                        0);
        if (!NT_SUCCESS(NtStatus))
        {
            Status = NormalizeNteStatus(NtStatus);
            goto cleanup;
        }

    }
    else if(wcscmp(pszTmpProperty, NCRYPT_SECURITY_DESCR_PROPERTY) == 0)
    {
        if((cbInput == 0)||
          (!IsValidSecurityDescriptor(pbInput))||
          (GetSecurityDescriptorLength(pbInput) > cbInput))
        {
            Status = NTE_BAD_DATA;
            goto cleanup;
        }

        pKey->dwSecurityFlags = dwTempFlags;

        if(pKey->pbSecurityDescr)
        {
            HeapFree(GetProcessHeap(),0,pKey->pbSecurityDescr);
        }

        pKey->pbSecurityDescr = (PBYTE)HeapAlloc(GetProcessHeap(),0,cbInput);
        if(pKey->pbSecurityDescr == NULL)
        {
            Status = NTE_NO_MEMORY;
            goto cleanup;
        }

        pKey->cbSecurityDescr = cbInput;
        CopyMemory(pKey->pbSecurityDescr, pbInput, cbInput);

        // Security descriptor does not need to be saved into key file
        dwTempFlags &= ~NCRYPT_PERSIST_FLAG;

        // The key has been finalized, so write the file again so that
        // the new security descriptor is set it on the file.
        if(pKey->fFinished)
        {
            Status = WriteKeyToStore(pKey);
            if (Status != ERROR_SUCCESS)
            {
                goto cleanup;
            }
        }

    }
    else if (wcscmp(pszTmpProperty, BCRYPT_PRIVATE_KEY_BLOB) == 0)
    {
       BCRYPT_RSAKEY_BLOB*  keyBlob = (BCRYPT_RSAKEY_BLOB*) pbInput;
       LPWSTR           pszBlobType = NULL;

       if(pKey->fFinished == TRUE)
       {
         // This key has already been finalized.
         Status = NTE_BAD_KEY_STATE;
         goto cleanup;
       }

       if (keyBlob->Magic == BCRYPT_RSAPRIVATE_MAGIC)
       {
            pszBlobType = BCRYPT_RSAPRIVATE_BLOB;
       }
       else if (keyBlob->Magic == BCRYPT_RSAFULLPRIVATE_MAGIC)
       {
            pszBlobType = BCRYPT_RSAFULLPRIVATE_BLOB;
       }
       else
       {
            Status = NTE_BAD_DATA;
            goto cleanup;
       }

       // Private key is not a persisted property.
       // The key will be stored when NCryptFinalizeKey is called.
       dwTempFlags &= ~NCRYPT_PERSIST_FLAG;

       // Set the private key blob, key length and key type.
       Status = ProtectAndSetPrivateKey(
                    (LPCWSTR)pszBlobType,
                    pbInput,
                    cbInput,
                    pKey);
       if (Status != ERROR_SUCCESS)
       {
            goto cleanup;
       }
    }
    else if (wcscmp(pszTmpProperty,NCRYPT_WINDOW_HANDLE_PROPERTY) ==0 ||
             wcscmp(pszTmpProperty,NCRYPT_UI_POLICY_PROPERTY)==0 ||
             wcscmp(pszTmpProperty,NCRYPT_USE_CONTEXT_PROPERTY)==0)
    {
        // Although implementation is not demonstrated by this sample KSP,
        // these properties are required to support certificate enrollment
        // scenarios.  Production KSPs that need to support certificate
        // enrollment must add handling for these properties.
        Status = ERROR_SUCCESS;
        goto cleanup;
    }
    else
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    Status = ERROR_SUCCESS;
cleanup:
    *dwFlags = dwTempFlags;
    return Status;
}

/******************************************************************************
*
* DESCRIPTION : Find the first key in the sample KSP's key storage.
*
* OUTPUTS:
*           PVOID *ppEnumState          The current enumeration state
*           NCryptKeyName **ppKeyName   The name of the first key in the
*                                       container
* RETURN :
*           ERROR_SUCCESS          The function was successful.
*           NTE_NO_MORE_ITEM       We have already traversed all the keys.
*           NTE_INTERNAL_ERROR     FindFirstFileEx failed.
*/
SECURITY_STATUS
FindFirstKeyFile(
    __out PVOID *ppEnumState,
    __deref_out NCryptKeyName **ppKeyName)
{
    LPWSTR              pszCryptoPath = NULL;
    DWORD               cbCryptoPath = 0;
    WCHAR               szSearchString[MAX_PATH];
    NCryptKeyName       *pKeyName = NULL;
    HANDLE              hFind = INVALID_HANDLE_VALUE;
    WIN32_FIND_DATAW    FindData={0};
    BOOL                fFound = FALSE;
    SAMPLEKSP_ENUM_STATE      *pEnumState = NULL;
    DWORD               dwReturn = ERROR_INTERNAL_ERROR;
    SECURITY_STATUS     Status = NTE_INTERNAL_ERROR;

    //Get key storage area.
    Status= (SECURITY_STATUS)GetSampleKeyStorageArea(&pszCryptoPath);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //
    // Find the first file that looks like a key file.
    //
    Status = StringCchCopyW(szSearchString, MAX_PATH,pszCryptoPath);

    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    Status = StringCchCatW(szSearchString, MAX_PATH, L"*");

    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }


    //Find keys in the store
    hFind = FindFirstFileExW(
                szSearchString,
                FindExInfoStandard,
                &FindData,
                FindExSearchNameMatch,
                NULL,
                0);
    if(hFind == INVALID_HANDLE_VALUE)
    {
        dwReturn = (SECURITY_STATUS)GetLastError();

        if(dwReturn == ERROR_FILE_NOT_FOUND ||
           dwReturn == ERROR_PATH_NOT_FOUND)
        {
            Status = NTE_NO_MORE_ITEMS;
        }
        else
        {
            Status = NTE_INTERNAL_ERROR;
        }
        goto cleanup;
    }

    //Read the key name from file
    do
    {
        Status =ReadKeyNameFromFile(
                    pszCryptoPath,
                    FindData.cFileName,
                    &pKeyName);
        if(Status != ERROR_SUCCESS)
        {
            continue;
        }
        fFound = TRUE;
        break;
    }
    while(FindNextFileW(hFind, &FindData));

    //build output buffer
    if(!fFound)
    {
        Status = NTE_NO_MORE_ITEMS;
        goto cleanup;
    }

    cbCryptoPath = (DWORD)(wcslen( pszCryptoPath) + 1) * sizeof(WCHAR);
    pEnumState = (SAMPLEKSP_ENUM_STATE*)HeapAlloc(GetProcessHeap(),0,sizeof(SAMPLEKSP_ENUM_STATE)+cbCryptoPath);
    if(pEnumState == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    pEnumState->dwIndex = 0;

    pEnumState->hFind = hFind;
    hFind = INVALID_HANDLE_VALUE;

    CopyMemory(pEnumState + 1, pszCryptoPath, cbCryptoPath);
    pEnumState->pszPath = (LPWSTR)(pEnumState + 1);
    *ppEnumState = pEnumState;

    *ppKeyName = pKeyName;

    Status = ERROR_SUCCESS;

cleanup:
    if(pszCryptoPath)
    {
        HeapFree(GetProcessHeap(),0,pszCryptoPath);
    }

    if(hFind != INVALID_HANDLE_VALUE)
    {
        FindClose(hFind);
    }
    return Status;
}

/******************************************************************************
*
* DESCRIPTION : Find the next key in the sample KSP's key storage.
*
* INPUT:
*           PVOID *ppEnumState          The current enumeration state
*
* OUTPUTS:
*           PVOID *ppEnumState          The enumeration state after the operation
*           NCryptKeyName **ppKeyName   The name of the next key in the
*                                       container
* RETURN :
*           ERROR_SUCCESS          The function was successful.
*           NTE_NO_MORE_ITEM       We have already travered all the keys.
*           NTE_INTERNAL_ERROR     FindFirstFileEx failed.
*/
SECURITY_STATUS
FindNextKeyFile(
    __inout PVOID pEnumState,
    __deref_out NCryptKeyName **ppKeyName)
{
    WIN32_FIND_DATAW FindData = {0};
    NCryptKeyName *pKeyName = NULL;
    SAMPLEKSP_ENUM_STATE *pState = NULL;
    BOOL fFound = FALSE;
    DWORD   dwReturn = ERROR_INTERNAL_ERROR;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    //Find next key file.
    pState = (SAMPLEKSP_ENUM_STATE *)pEnumState;
    while(!fFound)
    {
        if(!FindNextFileW(pState->hFind, &FindData))
        {
            dwReturn = GetLastError();
            if(dwReturn == ERROR_NO_MORE_FILES)
            {

                Status = NTE_NO_MORE_ITEMS;
                goto cleanup;
            }
            else
            {
                Status = NTE_INTERNAL_ERROR;
                goto cleanup;
            }
        }

        // Read the key name out of the key file.
        Status = ReadKeyNameFromFile(
                        pState->pszPath,
                        FindData.cFileName,
                        &pKeyName);

        if(Status != ERROR_SUCCESS)
        {
            continue;
        }

        fFound = TRUE;
    }

    // Set output values.
    pState->dwIndex++;
    *ppKeyName = pKeyName;

    Status = ERROR_SUCCESS;
cleanup:

    return Status;
}

///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
*
* DESCRIPTION : Read the key name from the parameter list.
*
* INPUT:
*           NCryptBufferDesc const* pParameterList  The parameter list
*
* OUTPUTS:
*           LPWSTR* pszKeyName          Key name
*
* RETURN :
*           ERROR_SUCCESS           The function was successful.
*           NTE_INVALID_PARAMETER   The key name parameter is invalid.
*/
SECURITY_STATUS
ReadKeyNameFromParams(
    __in_opt NCryptBufferDesc const* pParamList,
    __out LPWSTR* pszKeyName)
{
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    size_t cbTmp =0;
    DWORD i=0;
    for (i = 0; i < pParamList->cBuffers; i++)
    {
        switch(pParamList->pBuffers[i].BufferType)
        {
              case NCRYPTBUFFER_PKCS_KEY_NAME:

                if (pParamList->pBuffers[i].pvBuffer != NULL &&
                    pParamList->pBuffers[i].cbBuffer >= sizeof (WCHAR))
                {
                    if (FAILED(StringCbLengthA(
                                (LPCSTR)pParamList->pBuffers[i].pvBuffer,
                                pParamList->pBuffers[i].cbBuffer,
                                &cbTmp)))
                    {
                        Status = NTE_INVALID_PARAMETER;
                        goto cleanup;
                    }
                    else
                    {
                        *pszKeyName =
                            (LPWSTR)pParamList->pBuffers[i].pvBuffer;
                    }
                }

                break;
      }
    }
    Status = ERROR_SUCCESS;
cleanup:
        return Status;
}

