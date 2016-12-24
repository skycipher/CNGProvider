// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

/*++

Abstract:
    Implementation of the sample CNG RSA key storage provider
--*/


///////////////////////////////////////////////////////////////////////////////
//
// Headers
//
///////////////////////////////////////////////////////////////////////////////
#include <windows.h>
#include <wincrypt.h>
#include <bcrypt.h>
#include <ncrypt.h>
#include "../inc/SampleKSP.h"

///////////////////////////////////////////////////////////////////////////////
//
// Ncrypt key storage provider function table
//
///////////////////////////////////////////////////////////////////////////////
NCRYPT_KEY_STORAGE_FUNCTION_TABLE SampleKSPFunctionTable =
{
    SAMPLEKSP_INTERFACE_VERSION,
    SampleKSPOpenProvider,
    SampleKSPOpenKey,
    SampleKSPCreatePersistedKey,
    SampleKSPGetProviderProperty,
    SampleKSPGetKeyProperty,
    SampleKSPSetProviderProperty,
    SampleKSPSetKeyProperty,
    SampleKSPFinalizeKey,
    SampleKSPDeleteKey,
    SampleKSPFreeProvider,
    SampleKSPFreeKey,
    SampleKSPFreeBuffer,
    SampleKSPEncrypt,
    SampleKSPDecrypt,
    SampleKSPIsAlgSupported,
    SampleKSPEnumAlgorithms,
    SampleKSPEnumKeys,
    SampleKSPImportKey,
    SampleKSPExportKey,
    SampleKSPSignHash,
    SampleKSPVerifySignature,
    SampleKSPPromptUser,
    SampleKSPNotifyChangeKey,
    SampleKSPSecretAgreement,
    SampleKSPDeriveKey,
    SampleKSPFreeSecret
};

///////////////////////////////////////////////////////////////////////////////
//
// Variables
//
///////////////////////////////////////////////////////////////////////////////
HINSTANCE g_hInstance;
//List of keys/providers
LIST_ENTRY g_SampleKspEnumStateList;

///////////////////////////////////////////////////////////////////////////////
//
// Dll entry
//
///////////////////////////////////////////////////////////////////////////////

BOOL
WINAPI
DllMain(
    HMODULE hInstDLL,
    DWORD dwReason,
    LPVOID lpvReserved)
{
    UNREFERENCED_PARAMETER(lpvReserved);
    g_hInstance = (HINSTANCE)hInstDLL;

    if(dwReason == DLL_PROCESS_ATTACH)
    {
        InitializeListHead(&g_SampleKspEnumStateList);
    }
    else if(dwReason == DLL_PROCESS_DETACH)
    {
        if (g_hRSAProvider)
        {
            BCryptCloseAlgorithmProvider(g_hRSAProvider,0);
        }
    }
    return TRUE;
}


///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
* DESCRIPTION :     Get the sample KSP key storage Interface function
*                   dispatch table
*
* INPUTS :
*            LPCWSTR pszProviderName        Name of the provider (unused)
*            DWORD   dwFlags                Flags (unused)
* OUTPUTS :
*            char    **ppFunctionTable      The key storage interface function
*                                           dispatch table
* RETURN :
*            ERROR_SUCCESS                  The function was successful.
*/
NTSTATUS
WINAPI
GetKeyStorageInterface(
    __in   LPCWSTR pszProviderName,
    __out  NCRYPT_KEY_STORAGE_FUNCTION_TABLE **ppFunctionTable,
    __in   DWORD dwFlags)
{

    UNREFERENCED_PARAMETER(pszProviderName);
    UNREFERENCED_PARAMETER(dwFlags);

    *ppFunctionTable = &SampleKSPFunctionTable;

    return ERROR_SUCCESS;
}

/*******************************************************************
* DESCRIPTION :     Load and initialize the Sample KSP provider
*
* INPUTS :
*            LPCWSTR pszProviderName         Name of the provider
*            DWORD   dwFlags                 Flags (unused)
* OUTPUTS :
*            NCRYPT_PROV_HANDLE *phProvider  The provider handle
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*/
SECURITY_STATUS
WINAPI
SampleKSPOpenProvider(
    __out   NCRYPT_PROV_HANDLE *phProvider,
    __in    LPCWSTR pszProviderName,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    DWORD cbLength =0;
    size_t cbProviderName =0;
    UNREFERENCED_PARAMETER(dwFlags);

    // Validate input parameters.
    if(phProvider==NULL)
    {
        status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }
    if(pszProviderName==NULL)
    {
        status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    //The size of the provider name should be limited.
    cbProviderName = (wcslen(pszProviderName) + 1) * sizeof(WCHAR);
    if(cbProviderName > MAXUSHORT)
    {
        status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    // Allocate memory for provider object.
    cbLength = sizeof(SAMPLEKSP_PROVIDER) + (DWORD)cbProviderName;
    pProvider = (SAMPLEKSP_PROVIDER*)HeapAlloc (GetProcessHeap (), 0, cbLength);;
    if(NULL==pProvider)
    {
        status = NTE_NO_MEMORY;
        goto cleanup;
    }

    //Assign values to fields of the provider handle.
    pProvider->cbLength = cbLength;
    pProvider->dwMagic  = SAMPLEKSP_PROVIDER_MAGIC;
    pProvider->dwFlags  = 0;
    pProvider->pszName  = (LPWSTR)(pProvider + 1);
    CopyMemory(pProvider->pszName, pszProviderName, cbProviderName);
    pProvider->pszContext = NULL;

    //Assign the output value.
    *phProvider = (NCRYPT_PROV_HANDLE)pProvider;
    pProvider = NULL;
    status = ERROR_SUCCESS;
cleanup:
    if(pProvider)
    {
        HeapFree(GetProcessHeap(), 0, pProvider);
    }
    return status;
}



/******************************************************************************
* DESCRIPTION :     Release a handle to the sample KSP provider
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*/
SECURITY_STATUS
WINAPI
SampleKSPFreeProvider(
    __in    NCRYPT_PROV_HANDLE hProvider)
{
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;

    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider==NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    // Free context.
    if (pProvider->pszContext)
    {
        HeapFree(GetProcessHeap(),0,pProvider->pszContext);
        pProvider->pszContext = NULL;
    }

    ZeroMemory(pProvider,pProvider->cbLength);
    HeapFree(GetProcessHeap(), 0,pProvider);

    Status = ERROR_SUCCESS;
cleanup:

    return Status;
}


/******************************************************************************
* DESCRIPTION :     Open a key in the SAMPLE key storage provider
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
*            LPCWSTR pszKeyName              Name of the key
             DWORD  dwLegacyKeySpec          Flags for legacy key support (unused)
*            DWORD   dwFlags                 Flags (unused)
* OUTPUTS:
*            NCRYPT_KEY_HANDLE               A handle to the opened key
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*/
SECURITY_STATUS
WINAPI
SampleKSPOpenKey(
    __inout NCRYPT_PROV_HANDLE hProvider,
    __out   NCRYPT_KEY_HANDLE *phKey,
    __in    LPCWSTR pszKeyName,
    __in_opt DWORD  dwLegacyKeySpec,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    SAMPLEKSP_KEY *pKey = NULL;

    //
    // Validate input parameters.
    //
    UNREFERENCED_PARAMETER(dwLegacyKeySpec);
    UNREFERENCED_PARAMETER(dwFlags);

    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((phKey == NULL)||(pszKeyName == NULL))
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    //Initialize the key object.
    Status=CreateNewKeyObject(pszKeyName,&pKey);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Get path to user's key file.
    Status = GetSampleKeyStorageArea(&pKey->pszKeyFilePath);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Read and validate key file header from the key file.
    Status = ReadKeyFile(pKey);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Parse key file.
    Status=ParseKeyFile(pKey);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    pKey->fFinished = TRUE;
    *phKey = (NCRYPT_KEY_HANDLE)pKey;
    pKey = NULL;
    Status = ERROR_SUCCESS;

cleanup:

    if(pKey)
    {
        DeleteKeyObject(pKey);
    }

    return Status;
}


/******************************************************************************
* DESCRIPTION :     Create a new key and stored it into the user profile
*                   key storage area
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
*            LPCWSTR pszAlgId                Cryptographic algorithm to create the key
*            LPCWSTR pszKeyName              Name of the key
*            DWORD  dwLegacyKeySpec          Flags for legacy key support (unused)
*            DWORD   dwFlags                 0|NCRYPT_OVERWRITE_KEY_FLAG
* OUTPUTS:
*            NCRYPT_KEY_HANDLE               A handle to the opened key
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_EXISTS                      The key already exists.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*            NTE_NOT_SUPPORTED               The algorithm is not supported.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*/
SECURITY_STATUS
WINAPI
SampleKSPCreatePersistedKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __out   NCRYPT_KEY_HANDLE *phKey,
    __in    LPCWSTR pszAlgId,
    __in_opt LPCWSTR pszKeyName,
    __in    DWORD   dwLegacyKeySpec,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS       Status = NTE_INTERNAL_ERROR;
    NTSTATUS              ntStatus = STATUS_INTERNAL_ERROR;
    DWORD                 dwBitLength = 0;
    SAMPLEKSP_PROVIDER    *pProvider = NULL;
    SAMPLEKSP_KEY         *pKey = NULL;

    //
    // Validate input parameters.
    //
    UNREFERENCED_PARAMETER(dwLegacyKeySpec);

    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((phKey == NULL)||(pszAlgId == NULL))
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_SILENT_FLAG|NCRYPT_OVERWRITE_KEY_FLAG)) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    if (wcscmp(pszAlgId, NCRYPT_RSA_ALGORITHM) != 0)
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    //Create the key object.
    Status = CreateNewKeyObject(pszKeyName,
                                   &pKey);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    // If the overwrite flag is not set then check to
    // make sure the key doesn't already exist.
    if ((pszKeyName != NULL) && (dwFlags & NCRYPT_OVERWRITE_KEY_FLAG) == 0)
    {
        Status = ValidateKeyFileExistence(pKey);
        if(Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }
    }

    //Set the key length to the default length.
    dwBitLength = SAMPLEKSP_DEFAULT_KEY_LENGTH;
    pKey->dwKeyBitLength = dwBitLength;

    //Set the key blob type to BCRYPT_RSAPRIVATE_BLOB.
    pKey->pszKeyBlobType = BCRYPT_RSAPRIVATE_BLOB;

    //Generate the key handle.
    ntStatus = BCryptGenerateKeyPair(
                pKey->hProvider,
                &pKey->hPrivateKey,
                SAMPLEKSP_DEFAULT_KEY_LENGTH,
                0);
    if(!NT_SUCCESS( ntStatus))
    {
        Status = NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    //Get path to user's key file storage area.
    Status = GetSampleKeyStorageArea(&pKey->pszKeyFilePath);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //
    // Set return values.
    //

    *phKey = (NCRYPT_KEY_HANDLE)pKey;
    pKey = NULL;

    Status = ERROR_SUCCESS;

cleanup:
    if (pKey)
    {
        DeleteKeyObject(pKey);
    }
    return Status;
}

/******************************************************************************
* DESCRIPTION :  Retrieves the value of a named property for a key storage
*                provider object.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
*            LPCWSTR pszProperty             Name of the property
*            DWORD   cbOutput                Size of the output buffer
*            DWORD   dwFlags                 Flags
* OUTPUTS:
*            PBYTE   pbOutput                Output buffer containing the value
*                                            of the property.  If pbOutput is NULL,
*                                            required buffer size will return in
*                                            *pcbResult.
*            DWORD * pcbResult               Required size of the output buffer
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_NOT_FOUND                   Cannot find such a property.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BUFFER_TOO_SMALL            Output buffer is too small.
*            NTE_NOT_SUPPORTED               The property is not supported.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*/
SECURITY_STATUS
WINAPI
SampleKSPGetProviderProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{

    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    DWORD cbResult = 0;
    DWORD dwProperty = 0;

    //
    // Validate input parameters.
    //

    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((pszProperty == NULL)||(pcbResult == NULL))
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if(wcslen(pszProperty) > NCRYPT_MAX_PROPERTY_NAME)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }


    if((dwFlags & ~(NCRYPT_SILENT_FLAG)) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    //
    //Determine the size of the properties.
    //

    if(wcscmp(pszProperty, NCRYPT_IMPL_TYPE_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_IMPL_TYPE_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_MAX_NAME_LENGTH_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_MAX_NAME_LEN_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_NAME_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_NAME_PROPERTY;
        cbResult = (DWORD)((wcslen(pProvider->pszName) + 1) * sizeof(WCHAR));
    }
    else if(wcscmp(pszProperty, NCRYPT_VERSION_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_VERSION_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_USE_CONTEXT_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_USE_CONTEXT_PROPERTY;
        cbResult = 0;

        if (pProvider->pszContext)
        {
            cbResult =
                (DWORD)(wcslen(pProvider->pszContext) + 1) * sizeof(WCHAR);
        }

        if (cbResult == 0)
        {
            goto cleanup;
        }
    }
    else if(wcscmp(pszProperty, NCRYPT_SECURITY_DESCR_SUPPORT_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_SECURITY_DESCR_SUPPORT_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

     *pcbResult = cbResult;

    //Output buffer is empty, this is a property length query, and we can exit early.
    if (pbOutput == NULL)
    {
        Status= ERROR_SUCCESS;
        goto cleanup;
    }

    //Otherwise, validate the size.
    if(cbOutput < *pcbResult)
    {
        Status = NTE_BUFFER_TOO_SMALL;
        goto cleanup;
    }

    //
    //Retrieve the requested property data
    //if the property is not supported, we have already returned NTE_NOT_SUPPORTED.
    //
    switch(dwProperty)
    {
        case SAMPLEKSP_IMPL_TYPE_PROPERTY:
            *(DWORD *)pbOutput = NCRYPT_IMPL_SOFTWARE_FLAG;
            break;

        case SAMPLEKSP_MAX_NAME_LEN_PROPERTY:
            *(DWORD *)pbOutput = MAX_PATH;
            break;

        case SAMPLEKSP_NAME_PROPERTY:
            CopyMemory(pbOutput, pProvider->pszName, cbResult);
            break;

        case SAMPLEKSP_VERSION_PROPERTY:
            *(DWORD *)pbOutput = SAMPLEKSP_VERSION;
            break;

        case SAMPLEKSP_USE_CONTEXT_PROPERTY:
             CopyMemory(pbOutput, pProvider->pszContext, cbResult);
             break;

        case SAMPLEKSP_SECURITY_DESCR_SUPPORT_PROPERTY:
            *(DWORD *)pbOutput = SAMPLEKSP_SUPPORT_SECURITY_DESCRIPTOR ;
            break;
    }

    Status = ERROR_SUCCESS;

cleanup:
    
    return Status;
}

/******************************************************************************
* DESCRIPTION :  Retrieves the value of a named property for a key storage
*                key object.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key object
*            LPCWSTR pszProperty             Name of the property
*            DWORD   cbOutput                Size of the output buffer
*            DWORD   dwFlags                 Flags
* OUTPUTS:
*            PBYTE   pbOutput                Output buffer containing the value
*                                            of the property.  If pbOutput is NULL,
*                                            required buffer size will return in
*                                            *pcbResult.
*            DWORD * pcbResult               Required size of the output buffer
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_NOT_FOUND                   Cannot find such a property.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BUFFER_TOO_SMALL            Output buffer is too small.
*            NTE_NOT_SUPPORTED               The property is not supported.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*/
SECURITY_STATUS
WINAPI
SampleKSPGetKeyProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{

    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    SAMPLEKSP_KEY *pKey = NULL;
    SAMPLEKSP_PROPERTY *pProperty = NULL;
    DWORD dwProperty =0;
    DWORD cbResult = 0;
    LPWSTR pszAlgorithm = NULL;
    LPWSTR pszAlgorithmGroup = NULL;
    PBYTE pbSecurityInfo = NULL;
    DWORD cbSecurityInfo = 0;
    DWORD cbTmp = 0;

    //
    // Validate input parameters.
    //

    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    pKey = SampleKspValidateKeyHandle(hKey);

    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((pszProperty == NULL)||
       (wcslen(pszProperty) > NCRYPT_MAX_PROPERTY_NAME)||
       (pcbResult == NULL))
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    //NCRYPT_SILENT_FLAG is ignored in this sample KSP.
    dwFlags &= ~NCRYPT_SILENT_FLAG;

    //If this is to get the security descriptor, the flags
    //must be one of the OWNER_SECURITY_INFORMATION |GROUP_SECURITY_INFORMATION |
    //DACL_SECURITY_INFORMATION|LABEL_SECURITY_INFORMATION | SACL_SECURITY_INFORMATION.
    if(wcscmp(pszProperty, NCRYPT_SECURITY_DESCR_PROPERTY) == 0)
    {

        if((dwFlags == 0)||((dwFlags & ~(OWNER_SECURITY_INFORMATION |
                        GROUP_SECURITY_INFORMATION |
                        DACL_SECURITY_INFORMATION  |
                        LABEL_SECURITY_INFORMATION |
                        SACL_SECURITY_INFORMATION)) != 0))
        {
            Status = NTE_BAD_FLAGS;
            goto cleanup;
        }
    }
    else
    {
        //Otherwise,Only NCRYPT_PERSIST_ONLY_FLAG is a valid flag.
        if(dwFlags & ~NCRYPT_PERSIST_ONLY_FLAG)
        {
            Status = NTE_BAD_FLAGS;
            goto cleanup;
        }
    }

    //If NCRYPT_PERSIST_ONLY_FLAG is supported, properties must
    //be read from the property list.
    if(dwFlags & NCRYPT_PERSIST_ONLY_FLAG)
    {   //@@Critical section code would need to be added here for
		//multi-threaded support@@.
        // Lookup property.
        Status = LookupExistingKeyProperty(
                        pKey,
                        pszProperty,
                        &pProperty);
        if(Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }

        // Validate the size of the output buffer.
        cbResult = pProperty->cbPropertyData;

        *pcbResult = cbResult;
        if(pbOutput == NULL)
        {
            Status = ERROR_SUCCESS;
            goto cleanup;
        }
        if(cbOutput < *pcbResult)
        {
            Status = NTE_BUFFER_TOO_SMALL;
            goto cleanup;
        }

        // Copy the property data to the output buffer.
        CopyMemory(pbOutput, (PBYTE)(pProperty+1), cbResult);

        Status = ERROR_SUCCESS;
        goto cleanup;

    }

    //
    //Determine length of requested property.
    //
    if(wcscmp(pszProperty, NCRYPT_ALGORITHM_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_ALGORITHM_PROPERTY;
        pszAlgorithm = BCRYPT_RSA_ALGORITHM;
        cbResult = (DWORD)(wcslen(pszAlgorithm) + 1) * sizeof(WCHAR);
    }
    else if(wcscmp(pszProperty, NCRYPT_BLOCK_LENGTH_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_BLOCK_LENGTH_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_EXPORT_POLICY_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_EXPORT_POLICY_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_KEY_USAGE_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_KEY_USAGE_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_KEY_TYPE_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_KEY_TYPE_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_LENGTH_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_LENGTH_PROPERTY;
        cbResult = sizeof(DWORD);
    }
    else if(wcscmp(pszProperty, NCRYPT_LENGTHS_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_LENGTHS_PROPERTY;
        cbResult = sizeof(NCRYPT_SUPPORTED_LENGTHS);
    }
    else if(wcscmp(pszProperty, NCRYPT_NAME_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_NAME_PROPERTY;
        if(pKey->pszKeyName == NULL)
        {
            // This should only happen if this is an ephemeral key.
            Status = NTE_NOT_SUPPORTED;
            goto cleanup;
        }
        cbResult = (DWORD)(wcslen(pKey->pszKeyName) + 1) * sizeof(WCHAR);
    }
    else if(wcscmp(pszProperty, NCRYPT_SECURITY_DESCR_PROPERTY) == 0)
    {
         //@@Synchronization schemes would need to be added here for
		 //multi-threaded support@@.
         dwProperty = SAMPLEKSP_SECURITY_DESCR_PROPERTY;
         Status = GetSecurityOnKeyFile(
                        pKey,
                        dwFlags,
                        (PSECURITY_DESCRIPTOR*)&pbSecurityInfo,
                        &cbSecurityInfo);
         if(Status != ERROR_SUCCESS)
         {
            goto cleanup;
         }

         cbResult = cbSecurityInfo;
    }
    else if(wcscmp(pszProperty, NCRYPT_ALGORITHM_GROUP_PROPERTY) == 0)
    {
        dwProperty = SAMPLEKSP_ALGORITHM_GROUP_PROPERTY;
        pszAlgorithmGroup = NCRYPT_RSA_ALGORITHM_GROUP;
        cbResult = (DWORD)(wcslen(pszAlgorithmGroup) + 1) * sizeof(WCHAR);
    }
    else if(wcscmp(pszProperty, NCRYPT_UNIQUE_NAME_PROPERTY) == 0)
    {
        //For this sample, the unique name property and the name property are
		//the same, which is the name of the key file.
        dwProperty = SAMPLEKSP_UNIQUE_NAME_PROPERTY;

        if(pKey->pszKeyName == NULL)
        {
            // This should only happen if this is a public key object.
            Status = NTE_NOT_SUPPORTED;
            goto cleanup;
        }

        cbResult = (DWORD)(wcslen(pKey->pszKeyName) + 1) * sizeof(WCHAR);
    }
    else
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }


    //
    // Validate the size of the output buffer.
    //

    *pcbResult = cbResult;

    if(pbOutput == NULL)
    {
        Status = ERROR_SUCCESS;
        goto cleanup;
    }

    if(cbOutput < *pcbResult)
    {
        Status = NTE_BUFFER_TOO_SMALL;
        goto cleanup;
    }

    //
    // Retrieve the requested property data.
    //
    switch(dwProperty)
    {
    case SAMPLEKSP_ALGORITHM_PROPERTY:
        CopyMemory(pbOutput, pszAlgorithm, cbResult);
        break;

    case SAMPLEKSP_BLOCK_LENGTH_PROPERTY:
        *(DWORD *)pbOutput =(pKey->dwKeyBitLength+7)/8;
        break;

    case SAMPLEKSP_EXPORT_POLICY_PROPERTY:
        *(DWORD *)pbOutput = pKey->dwExportPolicy;
        break;

    case SAMPLEKSP_KEY_USAGE_PROPERTY:
        *(DWORD *)pbOutput = pKey->dwKeyUsagePolicy;
        break;

    case SAMPLEKSP_KEY_TYPE_PROPERTY:
        //This sample KSP does not support machine keys.
        *(DWORD *)pbOutput = 0;
        break;

    case SAMPLEKSP_LENGTH_PROPERTY:
        *(DWORD *)pbOutput = pKey->dwKeyBitLength;
        break;

    case SAMPLEKSP_LENGTHS_PROPERTY:
    {
        NCRYPT_SUPPORTED_LENGTHS UNALIGNED *pLengths = (NCRYPT_SUPPORTED_LENGTHS *)pbOutput;

        Status = BCryptGetProperty(pKey->hProvider,
                                   BCRYPT_KEY_LENGTHS,
                                   pbOutput,
                                   cbOutput,
                                   &cbTmp,
                                   0);
        if (ERROR_SUCCESS != Status)
        {
            goto cleanup;
        }

        pLengths->dwDefaultLength = SAMPLEKSP_DEFAULT_KEY_LENGTH;
        break;
    }

    case SAMPLEKSP_NAME_PROPERTY:
        CopyMemory(pbOutput, pKey->pszKeyName, cbResult);
        break;

    case SAMPLEKSP_UNIQUE_NAME_PROPERTY:
        CopyMemory(pbOutput, pKey->pszKeyName, cbResult);
        break;

    case SAMPLEKSP_SECURITY_DESCR_PROPERTY:
        CopyMemory(pbOutput, pbSecurityInfo, cbResult);
        break;

    case SAMPLEKSP_ALGORITHM_GROUP_PROPERTY:
        CopyMemory(pbOutput, pszAlgorithmGroup, cbResult);
        break;

    }

    Status = ERROR_SUCCESS;

cleanup:
    
    if(pbSecurityInfo)
    {
        HeapFree(GetProcessHeap(),0,pbSecurityInfo);
    }

    return Status;
}

/******************************************************************************
* DESCRIPTION :  Sets the value for a named property for a CNG key storage
*                provider object.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
*            LPCWSTR pszProperty             Name of the property
*            PBYTE   pbInput                 Input buffer containing the value
*                                            of the property
*            DWORD   cbOutput                Size of the input buffer
*            DWORD   dwFlags                 Flags
*
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_NOT_SUPPORTED               The property is not supported.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*/
SECURITY_STATUS
WINAPI
SampleKSPSetProviderProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    LPCWSTR pszProperty,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;


    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((pszProperty == NULL)||
       (wcslen(pszProperty) > NCRYPT_MAX_PROPERTY_NAME)||
       (pbInput == NULL))
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_SILENT_FLAG)) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    //Update the property.
    if(wcscmp(pszProperty, NCRYPT_USE_CONTEXT_PROPERTY) == 0)
    {

        if (pProvider->pszContext)
        {
            HeapFree(GetProcessHeap(),0,pProvider->pszContext);
        }

        pProvider->pszContext = (LPWSTR)HeapAlloc(GetProcessHeap(),0,cbInput);
        if(pProvider->pszContext == NULL)
        {
            Status = NTE_NO_MEMORY;
            goto cleanup;
        }

        CopyMemory(pProvider->pszContext, pbInput, cbInput);

    }
    else
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }


    Status = ERROR_SUCCESS;

cleanup:
    return Status;
}

/******************************************************************************
* DESCRIPTION :  Set the value of a named property for a key storage
*                key object.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key object
*            LPCWSTR pszProperty             Name of the property
*            PBYTE   pbInput                 Input buffer containing the value
*                                            of the property
*            DWORD   cbOutput                Size of the input buffer
*            DWORD   dwFlags                 Flags
*
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle or a valid key handle
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_NOT_SUPPORTED               The property is not supported.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*/
SECURITY_STATUS
WINAPI
SampleKSPSetKeyProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __inout NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR pszProperty,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __in    DWORD   dwFlags)
{

    SECURITY_STATUS         Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER      *pProvider = NULL;
    SAMPLEKSP_KEY           *pKey = NULL;
    SAMPLEKSP_PROPERTY      *pProperty = NULL;
    SAMPLEKSP_PROPERTY      *pExistingProperty = NULL;
    DWORD                   dwTempFlags = dwFlags;

    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    pKey = SampleKspValidateKeyHandle(hKey);

    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((pszProperty == NULL)||
      (wcslen(pszProperty) > NCRYPT_MAX_PROPERTY_NAME)||
      (pbInput == NULL))
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    // Ignore the silent flag if it is turned on.
    dwTempFlags &= ~NCRYPT_SILENT_FLAG;
    if(wcscmp(pszProperty, NCRYPT_SECURITY_DESCR_PROPERTY) == 0)
    {
        // At least one flag must be set.
        if(dwTempFlags == 0)
        {
            Status = NTE_BAD_FLAGS;
            goto cleanup;
        }

        // Reject flags *not* in the list below.
        if((dwTempFlags & ~(OWNER_SECURITY_INFORMATION |
                        GROUP_SECURITY_INFORMATION |
                        DACL_SECURITY_INFORMATION  |
                        LABEL_SECURITY_INFORMATION |
                        SACL_SECURITY_INFORMATION  |
                        NCRYPT_PERSIST_FLAG)) != 0)
        {
            Status = NTE_BAD_FLAGS;
            goto cleanup;
        }
    }
    else
    {
        if((dwTempFlags & ~(NCRYPT_PERSIST_FLAG |
                        NCRYPT_PERSIST_ONLY_FLAG)) != 0)
        {
            Status = NTE_BAD_FLAGS;
            goto cleanup;
        }
    }

    if((dwTempFlags & NCRYPT_PERSIST_ONLY_FLAG) == 0)
    {
        //The property is one of the built-in key properties.
        Status = SetBuildinKeyProperty(pKey,
                                    pszProperty,
                                    pbInput,
                                    cbInput,
                                    &dwTempFlags);
        if (Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }

        if ((dwTempFlags & NCRYPT_PERSIST_FLAG) == 0)
        {
            //we are done here.
            goto cleanup;
        }
    }

    //Remove the existing property
    Status=LookupExistingKeyProperty(pKey,
                                pszProperty,
                                &pExistingProperty);

    if (Status != NTE_NOT_FOUND)
    {
         RemoveEntryList(&pExistingProperty->ListEntry);
         HeapFree(GetProcessHeap(),0,pExistingProperty);
    }

    //Create a new property and attach it to the key object.
    Status = CreateNewProperty(
                        pszProperty,
                        pbInput,
                        cbInput,
                        dwTempFlags,
                        &pProperty);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }
    InsertTailList(&pKey->PropertyList, &pProperty->ListEntry);

    //Write the new properties to the file system
    //if it should be persisted.
    if(pProperty->fPersisted && pKey->fFinished)
    {
        Status = WriteKeyToStore(pKey);

        if(Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }
    }

    Status = ERROR_SUCCESS;

cleanup:
    return Status;
}

/******************************************************************************
* DESCRIPTION :     Completes a sample key storage key. The key cannot be used
*                   until this function has been called.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key
*            DWORD   dwFlags                 Flags
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*            NTE_BAD_FLAGS                   The dwFlags parameter contains a
*                                            value that is not valid.
*/
SECURITY_STATUS
WINAPI
SampleKSPFinalizeKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    SAMPLEKSP_KEY *pKey = NULL;

    //
    // Validate input parameters.
    //

    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    pKey = SampleKspValidateKeyHandle(hKey);

    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if (pKey->fFinished == TRUE)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_NO_KEY_VALIDATION |
                    NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG |
                    NCRYPT_SILENT_FLAG )) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    if (dwFlags & NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG)
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    if (pKey->pbPrivateKey)
    {
        //Private key is provisioned by NCryptSetProperty
        //or NCryptImportKey.
        //Once the key blob is imported as a BCrypt key handle,
        //the key is finalized.
        Status = ImportRsaKeyPair(pKey);
        if (Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }
    }
    else
    {
        //
        //Finalize the key.
        //
        Status = FinalizeKey(pKey);
        if(Status != ERROR_SUCCESS)
        {
             goto cleanup;
        }
    }

    //
    //Write key to the file system, if the key is persisted.
    //
    //
    if(pKey->pszKeyName != NULL)
    {
        Status = WriteKeyToStore(pKey);
        if (Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }
    }

    pKey->fFinished = TRUE;
    Status = ERROR_SUCCESS;

cleanup:
    return Status;
}

/******************************************************************************
* DESCRIPTION :     Deletes a CNG sample KSP key
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
*            NCRYPT_KEY_HANDLE hKey          Handle to a sample KSP key
*            DWORD   dwFlags                 Flags
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider or key handle.
*            NTE_BAD_FLAGS                   The dwFlags parameter contains a
*                                            value that is not valid.
*            NTE_INTERNAL_ERROR              Key file deletion failed.
*/
SECURITY_STATUS
WINAPI
SampleKSPDeleteKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __inout NCRYPT_KEY_HANDLE hKey,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS Status = ERROR_SUCCESS;
    SAMPLEKSP_PROVIDER *pProvider;
    SAMPLEKSP_KEY *pKey = NULL;

    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    pKey = SampleKspValidateKeyHandle(hKey);

    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_SILENT_FLAG))!= 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    //Delete the key if it is already stored in the file system
    if (pKey->fFinished == TRUE);
    {
        Status = RemoveKeyFromStore(pKey);
    }

cleanup:

    return Status;
}

/******************************************************************************
* DESCRIPTION :     Free a CNG sample KSP key object
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to the sample KSP provider
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*/
SECURITY_STATUS
WINAPI
SampleKSPFreeKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey)
{
    SECURITY_STATUS Status;
    SAMPLEKSP_PROVIDER *pProvider;
    SAMPLEKSP_KEY *pKey = NULL;

    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    pKey = SampleKspValidateKeyHandle(hKey);

    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }


    //
    // Free key object.
    //
    Status = DeleteKeyObject(pKey);

cleanup:

     return Status;
}

/******************************************************************************
* DESCRIPTION :     free a CNG sample KSP memory buffer object
*
* INPUTS :
*            PVOID   pvInput                 The buffer to free.
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*/
SECURITY_STATUS
WINAPI
SampleKSPFreeBuffer(
    __deref PVOID   pvInput)
{
    SAMPLEKSP_MEMORY_BUFFER *pBuffer;
    SAMPLEKSP_ENUM_STATE *pEnumState;

    //
    // Is this one of the enumeration buffers, that needs to be
    // freed?
    //

    pBuffer = RemoveMemoryBuffer(&g_SampleKspEnumStateList, pvInput);

    if(pBuffer)
    {
        pEnumState = (SAMPLEKSP_ENUM_STATE *)pBuffer->pvBuffer;

        FindClose(pEnumState->hFind);

        HeapFree(GetProcessHeap(),0,pEnumState);
        HeapFree(GetProcessHeap(),0,pBuffer);

        goto cleanup;
    }

    //
    // Free the buffer from the heap.
    //

    HeapFree(GetProcessHeap(),0,pvInput);

cleanup:

    return ERROR_SUCCESS;
}


/******************************************************************************
* DESCRIPTION :  encrypts a block of data.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object.
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key object.
*            PBYTE   pbInput                 Plain text data to be encrypted.
*            DWORD   cbInput                 Size of the plain text data.
*            VOID    *pPaddingInfo           Padding information if padding sheme
*                                            is used.
*            DWORD   cbOutput                Size of the output buffer.
*            DWORD   dwFlags                 Flags
* OUTPUTS:
*            PBYTE   pbOutput                Output buffer containing encrypted
*                                            data.  If pbOutput is NULL,
*                                            required buffer size will return in
*                                            *pcbResult.
*            DWORD * pcbResult               Required size of the output buffer
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_BAD_KEY_STATE               The key identified by the hKey
*                                            parameter has not been finalized
*                                            or is incomplete.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider or key handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BUFFER_TOO_SMALL            Output buffer is too small.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*/
SECURITY_STATUS
WINAPI
SampleKSPEncrypt(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __in    VOID *pPaddingInfo,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{
    SAMPLEKSP_KEY         *pKey = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    NTSTATUS        ntStatus = STATUS_INTERNAL_ERROR;
    UNREFERENCED_PARAMETER(hProvider);

    // Validate input parameters.
    pKey = SampleKspValidateKeyHandle(hKey);

    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }
    if (!pKey->fFinished)
    {
        Status = NTE_BAD_KEY_STATE;
        goto cleanup;
    }

    if(pbInput == NULL || cbInput == 0 ||
       pcbResult == NULL)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_NO_PADDING_FLAG |
                    NCRYPT_PAD_PKCS1_FLAG  |
                    NCRYPT_PAD_OAEP_FLAG   |
                    NCRYPT_SILENT_FLAG) ) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    // Encrypt input buffer.
    ntStatus = BCryptEncrypt(pKey->hPublicKey,
                           pbInput,
                           cbInput,
                           pPaddingInfo,
                           NULL,
                           0,
                           pbOutput,
                           cbOutput,
                           pcbResult,
                           dwFlags);
    if(!NT_SUCCESS(ntStatus))
    {
        Status=NormalizeNteStatus(ntStatus);
        goto cleanup;
    }

    Status = ERROR_SUCCESS;

cleanup:

    return Status;
}

/******************************************************************************
* DESCRIPTION :  Decrypts a block of data.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object.
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key object.
*            PBYTE   pbInput                 Encrypted data blob.
*            DWORD   cbInput                 Size of the encrypted data blob.
*            VOID    *pPaddingInfo           Padding information if padding sheme
*                                            is used.
*            DWORD   cbOutput                Size of the output buffer.
*            DWORD   dwFlags                 Flags
* OUTPUTS:
*            PBYTE   pbOutput                Output buffer containing decrypted
*                                            data.  If pbOutput is NULL,
*                                            required buffer size will return in
*                                            *pcbResult.
*            DWORD * pcbResult               Required size of the output buffer
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_BAD_KEY_STATE               The key identified by the hKey
*                                            parameter has not been finalized
*                                            or is incomplete.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider or key handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BUFFER_TOO_SMALL            Output buffer is too small.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*/

SECURITY_STATUS
WINAPI
SampleKSPDecrypt(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __in    VOID *pPaddingInfo,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{
    SAMPLEKSP_KEY *pKey;
    DWORD BlockLength = 0;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    NTSTATUS    ntStatus = ERROR_SUCCESS;
    UNREFERENCED_PARAMETER(hProvider);

    // Validate input parameters.
    pKey = SampleKspValidateKeyHandle(hKey);

    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if(pbInput == NULL || cbInput == 0 ||
       pcbResult == NULL)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_NO_PADDING_FLAG |
                    NCRYPT_PAD_PKCS1_FLAG  |
                    NCRYPT_PAD_OAEP_FLAG   |
                    NCRYPT_SILENT_FLAG) ) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }


    //
    // Verify that this key is allowed to decrypt.
    //

    if((pKey->dwKeyUsagePolicy & NCRYPT_ALLOW_DECRYPT_FLAG) == 0)
    {
        Status = (DWORD)NTE_PERM;
        goto cleanup;
    }

    BlockLength = (pKey->dwKeyBitLength+7)/8;

    if(cbInput != BlockLength)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    // Decrypt input buffer.
    ntStatus = BCryptDecrypt(pKey->hPrivateKey,
                           pbInput,
                           cbInput,
                           pPaddingInfo,
                           NULL,
                           0,
                           pbOutput,
                           cbOutput,
                           pcbResult,
                           dwFlags);
    if(!NT_SUCCESS(ntStatus))
    {
        Status=NormalizeNteStatus(ntStatus);
        goto cleanup;
    }
    Status = ERROR_SUCCESS;

cleanup:
    return Status;
}

/******************************************************************************
* DESCRIPTION :  Determines if a sample key storage provider supports a
*                specific cryptographic algorithm.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object
*            LPCWSTR pszAlgId                Name of the cryptographic
*                                            Algorithm in question
*            DWORD   dwFlags                 Flags
* RETURN :
*            ERROR_SUCCESS                   The algorithm is supported.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider or key handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*            NTE_NOT_SUPPORTED               This algorithm is not supported.
*/
SECURITY_STATUS
WINAPI
SampleKSPIsAlgSupported(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    LPCWSTR pszAlgId,
    __in    DWORD   dwFlags)
{
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if(pszAlgId == NULL)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~NCRYPT_SILENT_FLAG) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    // This KSP only supports the RSA algorithm.
    if(wcscmp(pszAlgId, NCRYPT_RSA_ALGORITHM) != 0)
    {
        Status= NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    Status = ERROR_SUCCESS;
cleanup:
    return Status;
}

/******************************************************************************
* DESCRIPTION :  Obtains the names of the algorithms that are supported by
*                the sample key storage provider.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object.
*            DWORD   dwAlgOperations         The crypto operations that are to
*                                            be enumerated.
*            DWORD   dwFlags                 Flags
*
* OUTPUTS:
*            DWORD * pdwAlgCount             Number of supported algorithms.
*            NCryptAlgorithmName **ppAlgList List of supported algorithms.
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*            NTE_NOT_SUPPORTED               The crypto operations are not supported.
*/
SECURITY_STATUS
WINAPI
SampleKSPEnumAlgorithms(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    DWORD   dwAlgOperations,
    __out   DWORD * pdwAlgCount,
    __deref_out_ecount(*pdwAlgCount) NCryptAlgorithmName **ppAlgList,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    NCryptAlgorithmName *pCurrentAlg = NULL;
    PBYTE pbCurrent = NULL;
    PBYTE pbOutput = NULL;
    DWORD cbOutput = 0;

    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if(pdwAlgCount == NULL || ppAlgList == NULL)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~NCRYPT_SILENT_FLAG) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }


    if(dwAlgOperations == 0 ||
      ((dwAlgOperations & NCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION)!=0) ||
      ((dwAlgOperations & NCRYPT_SIGNATURE_OPERATION))!=0)
    {
        cbOutput += sizeof(NCryptAlgorithmName) +
                    sizeof(BCRYPT_RSA_ALGORITHM);
    }
    else
    {
        //Sample KSP only supports RSA.
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    //Allocate the output buffer.
    pbOutput = (PBYTE)HeapAlloc(GetProcessHeap(),0,cbOutput);
    if (pbOutput == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    pCurrentAlg = (NCryptAlgorithmName *)pbOutput;
    pbCurrent = pbOutput + sizeof(NCryptAlgorithmName);

    pCurrentAlg->dwFlags = 0;
    pCurrentAlg->dwClass = NCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE;
    pCurrentAlg->dwAlgOperations = NCRYPT_ASYMMETRIC_ENCRYPTION_OPERATION |
                                   NCRYPT_SIGNATURE_OPERATION;

    pCurrentAlg->pszName = (LPWSTR)pbCurrent;
    CopyMemory(pbCurrent,
               BCRYPT_RSA_ALGORITHM,
               sizeof(BCRYPT_RSA_ALGORITHM));
    pbCurrent += sizeof(BCRYPT_RSA_ALGORITHM);

    *pdwAlgCount = 1;
    *ppAlgList = (NCryptAlgorithmName *)pbOutput;

    Status = ERROR_SUCCESS;

cleanup:

    return Status;
}

/******************************************************************************
* DESCRIPTION :  Obtains the names of the keys that are stored by the provider.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object
*            LPCWSTR pszScope                Unused
*            NCryptKeyName **ppKeyName       Name of the retrieved key
*            PVOID * ppEnumState             Enumeration state information
*            DWORD   dwFlags                 Flags
*
* OUTPUTS:
*            PVOID * ppEnumState             Enumeration state information that
*                                            is used in subsequent calls to
*                                            this function.
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*            NTE_NOT_SUPPORTED               NCRYPT_MACHINE_KEY_FLAG is not
*                                            supported.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*/
SECURITY_STATUS
WINAPI
SampleKSPEnumKeys(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in_opt LPCWSTR pszScope,
    __deref_out NCryptKeyName **ppKeyName,
    __inout PVOID * ppEnumState,
    __in    DWORD   dwFlags)
{
    SAMPLEKSP_PROVIDER *pProvider = NULL;
    NCryptKeyName *pKeyName = NULL;
    SAMPLEKSP_MEMORY_BUFFER *pBuffer = NULL;
    PVOID pEnumState = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    UNREFERENCED_PARAMETER(pszScope);
    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);
    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if(ppKeyName == NULL || ppEnumState == NULL)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_MACHINE_KEY_FLAG | NCRYPT_SILENT_FLAG)) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    if (dwFlags & NCRYPT_MACHINE_KEY_FLAG)
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    // Enumerate key files.
    if(dwFlags & NCRYPT_MACHINE_KEY_FLAG)
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    pEnumState = *ppEnumState;
    if(pEnumState == NULL)
    {
        // Find the first key file.
        Status = FindFirstKeyFile(
                        &pEnumState,
                        &pKeyName);

        if(Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }

        // Allocate structure to hold the returned pEnumState buffer.
        pBuffer = (SAMPLEKSP_MEMORY_BUFFER*) HeapAlloc(
                                             GetProcessHeap(),
                                             0,
                                             sizeof(SAMPLEKSP_MEMORY_BUFFER));
        if(pBuffer == NULL)
        {
            Status = NTE_NO_MEMORY;
            goto cleanup;
        }
        ZeroMemory(pBuffer, sizeof(SAMPLEKSP_MEMORY_BUFFER));

        // Add the returned pEnumState buffer to a global list, so that
        // the sample KSP will know the correct way to free the buffer.
        pBuffer->pvBuffer = pEnumState;
        //@@Critical section code would need to be added here for multi-threaded support.@@
        InsertTailList(
            &g_SampleKspEnumStateList,
            &pBuffer->List);
        pBuffer = NULL;
    }
    else
    {
        // Make sure that the passed in pEnumState buffer is one
        // that we recognize.
        if(LookupMemoryBuffer(
            &g_SampleKspEnumStateList,
            pEnumState) == NULL)
        {
            Status = NTE_INVALID_PARAMETER;
            goto cleanup;
        }

        Status = FindNextKeyFile(
                        pEnumState,
                        &pKeyName);

        if(Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }
    }


    // Build output data.
    *ppKeyName = pKeyName;
    pKeyName = NULL;
    *ppEnumState = pEnumState;
    pEnumState = NULL;

    Status = ERROR_SUCCESS;
cleanup:
    if(pKeyName)
    {
        HeapFree(GetProcessHeap(),0,pKeyName);
    }

    if(pBuffer)
    {
        HeapFree(GetProcessHeap(),0,pBuffer);
    }

    if (pEnumState)
    {
        HeapFree(GetProcessHeap(),0,pEnumState);
    }

    return Status;
}

/******************************************************************************
* DESCRIPTION :  Imports a key into the sample KSP from a memory BLOB.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider     A handle to a sample KSP provider
*                                             object.
*            NCRYPT_KEY_HANDLE hImportKey     Unused
*            LPCWSTR pszBlobType              Type of the key blob.
*            NCryptBufferDesc *pParameterList Additional parameter information.
*            PBYTE   pbData                   Key blob.
*            DWORD   cbData                   Size of the key blob.
*            DWORD   dwFlags                  Flags
*
* OUTPUTS:
*            NCRYPT_KEY_HANDLE *phKey        Sample KSP key object imported
*                                            from the key blob.
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*            NTE_NOT_SUPPORTED               The type of the key blob is not
*                                            supported.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*            NTE_INTERNAL_ERROR              Decoding failed.
*/
SECURITY_STATUS
WINAPI
SampleKSPImportKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in_opt NCRYPT_KEY_HANDLE hImportKey,
    __in    LPCWSTR pszBlobType,
    __in_opt NCryptBufferDesc *pParameterList,
    __out   NCRYPT_KEY_HANDLE *phKey,
    __in_bcount(cbData) PBYTE pbData,
    __in    DWORD   cbData,
    __in    DWORD   dwFlags)
{
    SAMPLEKSP_PROVIDER      *pProvider = NULL;
    SAMPLEKSP_KEY           *pKey = NULL;
    DWORD                   cbResult = 0;
    BOOL                    fPkcs7Blob = FALSE;
    BOOL                    fPkcs8Blob = FALSE;
    BOOL                    fPrivateKeyBlob = FALSE;
    LPCWSTR                 pszTmpBlobType = pszBlobType;
    LPWSTR                  pszKeyName = NULL;
    SECURITY_STATUS         Status = NTE_INTERNAL_ERROR;
    NTSTATUS                ntStatus = STATUS_INTERNAL_ERROR;

    UNREFERENCED_PARAMETER(hImportKey);

    //
    //Validate input parameters.
    //
    pProvider = SampleKspValidateProvHandle(hProvider);

    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if((phKey == NULL)||(pbData == NULL) ||(cbData == 0))
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if((dwFlags & ~(NCRYPT_MACHINE_KEY_FLAG | BCRYPT_NO_KEY_VALIDATION |
                    NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG | NCRYPT_DO_NOT_FINALIZE_FLAG |
                    NCRYPT_SILENT_FLAG | NCRYPT_OVERWRITE_KEY_FLAG)) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    if (dwFlags & (NCRYPT_MACHINE_KEY_FLAG|
                   NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG))
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }


    if(wcscmp(pszTmpBlobType, BCRYPT_PUBLIC_KEY_BLOB) == 0 ||
       wcscmp(pszTmpBlobType, BCRYPT_PRIVATE_KEY_BLOB) == 0)
    {
        if (cbData < sizeof(BCRYPT_KEY_BLOB))
        {
            Status = NTE_INVALID_PARAMETER;
            goto cleanup;
        }

        if (wcscmp(pszTmpBlobType, BCRYPT_PRIVATE_KEY_BLOB) == 0)
        {
            fPrivateKeyBlob = TRUE;
        }
    }
    else if(wcscmp(pszTmpBlobType, BCRYPT_RSAPUBLIC_BLOB) == 0)
    {
        fPrivateKeyBlob = FALSE;

    }
    else if(wcscmp(pszTmpBlobType, BCRYPT_RSAPRIVATE_BLOB) == 0||
            wcscmp(pszTmpBlobType, BCRYPT_RSAFULLPRIVATE_BLOB) == 0)
    {
        fPrivateKeyBlob = TRUE;
    }
    else if(wcscmp(pszTmpBlobType, NCRYPT_PKCS7_ENVELOPE_BLOB) == 0)
    {
        fPkcs7Blob = TRUE;
    }
    else if(wcscmp(pszTmpBlobType, NCRYPT_PKCS8_PRIVATE_KEY_BLOB) == 0)
    {
        fPkcs8Blob = TRUE;
    }
    else
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    if ( fPkcs7Blob )
    {

        Status = SampleKspImportPKCS7Blob(pProvider,
                                    &pKey,
                                    pParameterList,
                                    pbData,
                                    cbData,
                                    dwFlags);

        if ( Status != ERROR_SUCCESS )
        {
            goto cleanup;
        }
    }
    else if (fPkcs8Blob)
    {
        // PKCS#8 private key blob
        Status = SampleKspImportPKCS8Blob(
                    hProvider,
                    &pKey,
                    pParameterList,
                    pbData,
                    cbData,
                    dwFlags);

        if ( Status != ERROR_SUCCESS )
        {
            goto cleanup;
        }
    }
    else
    {
        if (fPrivateKeyBlob)
        {
            //Get the name of the key if it is passed in.
            Status = ReadKeyNameFromParams(
                            pParameterList,
                            &pszKeyName);
            if ( Status != ERROR_SUCCESS )
            {
                goto cleanup;
            }
        }

        //Create the key object.
        Status = CreateNewKeyObject(
                            pszKeyName,
                            &pKey);
        if ( Status != ERROR_SUCCESS )
        {
            goto cleanup;
        }

        if (fPrivateKeyBlob)
        {
            //If the key to import is to be persisted, and
            //the flags do not allow overwriting an existing key,
            //we error out if the key already exists.
            if ((pszKeyName != NULL)&&(dwFlags&NCRYPT_OVERWRITE_KEY_FLAG) == 0)
            {
                Status = ValidateKeyFileExistence(pKey);
                if ( Status != ERROR_SUCCESS )
                {
                    goto cleanup;
                }
            }

            // Set the private key blob, key length and key type.
            Status = ProtectAndSetPrivateKey(
                            pszTmpBlobType,
                            pbData,
                            cbData,
                            pKey);
            if (Status != ERROR_SUCCESS)
            {
                Status = NTE_NOT_SUPPORTED;
                goto cleanup;
            }

        }
        else
        {
             if((dwFlags & (NCRYPT_MACHINE_KEY_FLAG |
                       NCRYPT_WRITE_KEY_TO_LEGACY_STORE_FLAG |
                       NCRYPT_DO_NOT_FINALIZE_FLAG |
                       NCRYPT_OVERWRITE_KEY_FLAG)) != 0)
            {
                Status = NTE_BAD_FLAGS;
                goto cleanup;
            }

            //Create the primitive public key
            ntStatus = BCryptImportKeyPair(
                            pKey->hProvider,
                            NULL,
                            pszTmpBlobType,
                            &pKey->hPublicKey,
                            pbData,
                            cbData,
                            dwFlags & NCRYPT_NO_KEY_VALIDATION);

            if(!NT_SUCCESS(ntStatus))
            {
                Status = NormalizeNteStatus(ntStatus);
                goto cleanup;
            }

            // Obtain the bit length.
            ntStatus = BCryptGetProperty(
                            pKey->hPublicKey,
                            BCRYPT_KEY_STRENGTH,
                            (PBYTE)&pKey->dwKeyBitLength,
                            sizeof(DWORD),
                            &cbResult,
                            0);
            if(!NT_SUCCESS(ntStatus))
            {
                Status = NormalizeNteStatus(ntStatus);
                goto cleanup;
            }

        }
    }

    //Finalize key: pkcs7 or pkcs8 keys is already finalized in
    //SampleKspImportPKCS7Blob or SampleKspImportPKCS8Blob,
    //depending on dwFlags values passed to the KspImportPKCS7Blob function.
    if (!fPkcs7Blob && !fPkcs8Blob)
    {
        if ((fPrivateKeyBlob)&&((dwFlags & NCRYPT_DO_NOT_FINALIZE_FLAG)==0))
        {
            //Create the private key handle and the public key handle.
            Status = ImportRsaKeyPair(pKey);
            if (Status != ERROR_SUCCESS)
            {
                goto cleanup;
            }

            //Write the persistent key to the key store.
            if (pKey->pszKeyName != NULL)
            {
                Status = WriteKeyToStore(pKey);

                if(Status != ERROR_SUCCESS)
                {
                    goto cleanup;
                }
            }

            pKey->fFinished = TRUE;

        }

    }

    Status = ERROR_SUCCESS;
    *phKey = (NCRYPT_KEY_HANDLE)pKey;
    pKey= NULL;
cleanup:
    if (pKey)
    {
        DeleteKeyObject(pKey);
        pKey = NULL;
    }

    return Status;
}

/******************************************************************************
* DESCRIPTION :  Exports a sample key storage key into a memory BLOB.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider     A handle to a sample KSP provider
*                                             object.
*            NCRYPT_KEY_HANDLE hKey           A handle to the sample KSP key
*                                             object to export.
*            NCRYPT_KEY_HANDLE hExportKey     Unused
*            LPCWSTR pszBlobType              Type of the key blob.
*            NCryptBufferDesc *pParameterList Additional parameter information.
*            DWORD   cbOutput                 Size of the key blob.
*            DWORD   dwFlags                  Flags
*
* OUTPUTS:
*            PBYTE pbOutput                  Key blob.
*            DWORD * pcbResult               Required size of the key blob.
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*            NTE_NOT_SUPPORTED               The type of the key blob is not
*                                            supported.
*            NTE_NO_MEMORY                   A memory allocation failure occurred.
*            NTE_INTERNAL_ERROR              Encoding failed.
*/
SECURITY_STATUS
WINAPI
SampleKSPExportKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in_opt NCRYPT_KEY_HANDLE hExportKey,
    __in    LPCWSTR pszBlobType,
    __in_opt NCryptBufferDesc *pParameterList,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{
    SAMPLEKSP_PROVIDER        *pProvider = NULL;
    SAMPLEKSP_KEY             *pKey = NULL;
    PBYTE               pbTemp = NULL;
    BOOL                fPkcs7Blob = FALSE;
    BOOL                fPkcs8Blob = FALSE;
    BOOL                fPublicKeyBlob = FALSE;
    BOOL                fPrivateKeyBlob = FALSE;
    NTSTATUS            ntStatus = STATUS_INTERNAL_ERROR;
    SECURITY_STATUS     Status = NTE_INTERNAL_ERROR;
    UNREFERENCED_PARAMETER(hExportKey);

    // Validate input parameters.
    pProvider = SampleKspValidateProvHandle(hProvider);
    if(pProvider == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }
    pKey = SampleKspValidateKeyHandle(hKey);
    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }
    if(pcbResult == NULL)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }
    if((dwFlags & ~(NCRYPT_SILENT_FLAG | NCRYPT_EXPORT_LEGACY_FLAG)) != 0)
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }
    if (dwFlags & NCRYPT_EXPORT_LEGACY_FLAG)
    {
        Status = NTE_NOT_SUPPORTED;
        goto cleanup;
    }

    //
    // Export key.
    //
    if(wcscmp(pszBlobType, BCRYPT_PUBLIC_KEY_BLOB) == 0)
    {
        fPublicKeyBlob = TRUE;
    }
    else if(wcscmp(pszBlobType, BCRYPT_PRIVATE_KEY_BLOB) == 0)
    {
        fPrivateKeyBlob = TRUE;
    }
    else if(wcscmp(pszBlobType, BCRYPT_RSAPUBLIC_BLOB) == 0)
    {
        fPublicKeyBlob = TRUE;
    }
    else if(wcscmp(pszBlobType, BCRYPT_RSAPRIVATE_BLOB) == 0 ||
            wcscmp(pszBlobType, BCRYPT_RSAFULLPRIVATE_BLOB) == 0 )
    {

        fPrivateKeyBlob = TRUE;
    }
    else if(wcscmp(pszBlobType, NCRYPT_PKCS7_ENVELOPE_BLOB) == 0)
    {
        fPrivateKeyBlob = TRUE;
        fPkcs7Blob = TRUE;
    }
    else if(wcscmp(pszBlobType, NCRYPT_PKCS8_PRIVATE_KEY_BLOB) == 0)
    {
        fPrivateKeyBlob = TRUE;
        fPkcs8Blob = TRUE;
    }
    else
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    //Export the public key blob.
    if (fPublicKeyBlob)
    {
        // Obtain the key blob from the primitive layer.
        ntStatus = BCryptExportKey(
                        pKey->hPublicKey,
                        NULL,
                        pszBlobType,
                        pbOutput,
                        cbOutput,
                        pcbResult,
                        0);
        if(!NT_SUCCESS(ntStatus))
        {
            Status = NormalizeNteStatus(ntStatus);
            goto cleanup;
        }
    }

    if (fPrivateKeyBlob)
    {
        // Check to see if plaintext exports are permitted.
        if(!fPkcs7Blob && ((pKey->dwExportPolicy & NCRYPT_ALLOW_PLAINTEXT_EXPORT_FLAG) == 0) &&
            !(fPkcs8Blob && IsPkcs8KeyExportable(pKey, pParameterList)))
        {
            Status = NTE_NOT_SUPPORTED;
            goto cleanup;
        }

        if ( fPkcs7Blob )
        {
            Status = SampleKspExportPKCS7Blob(pKey,
                                        pParameterList,
                                        pbOutput,
                                        cbOutput,
                                        pcbResult);
            if (Status != ERROR_SUCCESS)
            {
                goto cleanup;
            }
        }
        else if (fPkcs8Blob)
        {
            Status = SampleKspExportPKCS8Blob (
                            pKey,
                            pParameterList,
                            pbOutput,
                            cbOutput,
                            pcbResult);
            if (Status != ERROR_SUCCESS)
            {
                goto cleanup;
            }
        }
        else
        {
             Status= AllocAndGetRsaPrivateKeyBlob(
                             pKey,
                             pszBlobType,
                             &pbTemp,
                             pcbResult);
             if (Status != ERROR_SUCCESS)
             {
                goto cleanup;
             }
             if (pbOutput != NULL)
             {
                if (cbOutput<*pcbResult)
                {
                    Status = NTE_BUFFER_TOO_SMALL;
                    goto cleanup;
                }
                CopyMemory(pbOutput,pbTemp,*pcbResult);
             }
        }


    }

    Status = ERROR_SUCCESS;
cleanup:
    if (pbTemp)
    {
       SecureZeroMemory(pbTemp,*pcbResult);
       HeapFree(GetProcessHeap(),0,pbTemp);
    }
    return Status;
}

/******************************************************************************
* DESCRIPTION :  creates a signature of a hash value.
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key object
*            VOID    *pPaddingInfo           Padding information is padding sheme
*                                            is used
*            PBYTE  pbHashValue              Hash to sign.
*            DWORD  cbHashValue              Size of the hash.
*            DWORD  cbSignature              Size of the signature
*            DWORD  dwFlags                  Flags
* OUTPUTS:
*            PBYTE  pbSignature              Output buffer containing signature.
*                                            If pbOutput is NULL, required buffer
*                                            size will return in *pcbResult.
*            DWORD * pcbResult               Required size of the output buffer.
* RETURN :
*            ERROR_SUCCESS                   The function was successful.
*            NTE_BAD_KEY_STATE               The key identified by the hKey
*                                            parameter has not been finalized
*                                            or is incomplete.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider or key handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BUFFER_TOO_SMALL            Output buffer is too small.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*/
SECURITY_STATUS
WINAPI
SampleKSPSignHash(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in_opt    VOID  *pPaddingInfo,
    __in_bcount(cbHashValue) PBYTE pbHashValue,
    __in    DWORD   cbHashValue,
    __out_bcount_part_opt(cbSignaturee, *pcbResult) PBYTE pbSignature,
    __in    DWORD   cbSignaturee,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{
    SECURITY_STATUS     Status = NTE_INTERNAL_ERROR;
    NTSTATUS            ntStatus = STATUS_INTERNAL_ERROR;
    SAMPLEKSP_KEY       *pKey = NULL;
    DWORD               cbTmpSig = 0;
    DWORD               cbTmp = 0;
    UNREFERENCED_PARAMETER(hProvider);

    //
    // Validate input parameters.
    //
    pKey = SampleKspValidateKeyHandle(hKey);
    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if (pcbResult == NULL)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if(dwFlags & ~(BCRYPT_PAD_PKCS1 | BCRYPT_PAD_PSS | NCRYPT_SILENT_FLAG))
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }

    if(pKey->fFinished == FALSE)
    {
        Status = NTE_BAD_KEY_STATE;
        goto cleanup;
    }

    //
    // Verify that this key is allowed to perform sign operations.
    //

    if((pKey->dwKeyUsagePolicy & NCRYPT_ALLOW_SIGNING_FLAG) == 0)
    {
        Status = (DWORD)NTE_PERM;
        goto cleanup;
    }

    if (pbSignature == NULL)
    {
       //This call is to query the size.
       ntStatus = BCryptGetProperty(pKey->hPublicKey,
                           BCRYPT_SIGNATURE_LENGTH,
                           (BYTE*)&cbTmpSig,
                           sizeof(DWORD),
                           &cbTmp,
                           0);
        if (!NT_SUCCESS(ntStatus))
        {
            Status = NormalizeNteStatus(ntStatus);
            goto cleanup;
        }

        Status = ERROR_SUCCESS;
        *pcbResult = cbTmpSig;
        goto cleanup;
    }

    if(pbHashValue == NULL || cbHashValue == 0)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }


    Status = BCryptSignHash(
                    pKey->hPrivateKey,
                    pPaddingInfo,
                    pbHashValue,
                    cbHashValue,
                    pbSignature,
                    cbSignaturee,
                    pcbResult,
                    dwFlags);

    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(Status);
        goto cleanup;
    }

    Status = ERROR_SUCCESS;

cleanup:
 return Status;
}

/******************************************************************************
* DESCRIPTION :  Verifies that the specified signature matches the specified hash
*
* INPUTS :
*            NCRYPT_PROV_HANDLE hProvider    A handle to a sample KSP provider
*                                            object.
*            NCRYPT_KEY_HANDLE hKey          A handle to a sample KSP key object
*            VOID    *pPaddingInfo           Padding information is padding sheme
*                                            is used.
*            PBYTE  pbHashValue              Hash data
*            DWORD  cbHashValue              Size of the hash
*            PBYTE  pbSignature              Signature data
*            DWORD  cbSignaturee             Size of the signature
*            DWORD  dwFlags                  Flags
*
* RETURN :
*            ERROR_SUCCESS                   The signature is a valid signature.
*            NTE_BAD_KEY_STATE               The key identified by the hKey
*                                            parameter has not been finalized
*                                            or is incomplete.
*            NTE_INVALID_HANDLE              The handle is not a valid sample KSP
*                                            provider or key handle.
*            NTE_INVALID_PARAMETER           One or more parameters are invalid.
*            NTE_BAD_FLAGS                   dwFlags contains invalid value.
*/
SECURITY_STATUS
WINAPI
SampleKSPVerifySignature(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in_opt    VOID *pPaddingInfo,
    __in_bcount(cbHashValue) PBYTE pbHashValue,
    __in    DWORD   cbHashValue,
    __in_bcount(cbSignaturee) PBYTE pbSignature,
    __in    DWORD   cbSignaturee,
    __in    DWORD   dwFlags)
{
    NTSTATUS    ntStatus = STATUS_INTERNAL_ERROR;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    SAMPLEKSP_KEY *pKey;
    UNREFERENCED_PARAMETER(hProvider);

    // Validate input parameters.
    pKey = SampleKspValidateKeyHandle(hKey);
    if(pKey == NULL)
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    if (pKey->fFinished == FALSE)
    {
        Status = NTE_BAD_KEY_STATE;
        goto cleanup;
    }

    if(pbHashValue == NULL || cbHashValue == 0)
    {
        Status = NTE_INVALID_PARAMETER;
        goto cleanup;
    }

    if(dwFlags & ~(BCRYPT_PAD_PKCS1 | BCRYPT_PAD_PSS | NCRYPT_SILENT_FLAG))
    {
        Status = NTE_BAD_FLAGS;
        goto cleanup;
    }


    //Verify the signature.
    ntStatus = BCryptVerifySignature(
                    pKey->hPublicKey,
                    pPaddingInfo,
                    pbHashValue,
                    cbHashValue,
                    pbSignature,
                    cbSignaturee,
                    dwFlags);

    if(!NT_SUCCESS(ntStatus))
    {
        Status = NormalizeNteStatus(Status);
        goto cleanup;
    }

    Status = ERROR_SUCCESS;
cleanup:

    return Status;
}

SECURITY_STATUS
WINAPI
SampleKSPPromptUser(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in_opt NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR  pszOperation,
    __in    DWORD   dwFlags)
{
    UNREFERENCED_PARAMETER(hProvider);
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(pszOperation);
    UNREFERENCED_PARAMETER(dwFlags);
    return NTE_NOT_SUPPORTED;
}

SECURITY_STATUS
WINAPI
SampleKSPNotifyChangeKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __inout HANDLE *phEvent,
    __in    DWORD   dwFlags)
{
    UNREFERENCED_PARAMETER(hProvider);
    UNREFERENCED_PARAMETER(phEvent);
    UNREFERENCED_PARAMETER(dwFlags);
    return NTE_NOT_SUPPORTED;
}


SECURITY_STATUS
WINAPI
SampleKSPSecretAgreement(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hPrivKey,
    __in    NCRYPT_KEY_HANDLE hPubKey,
    __out   NCRYPT_SECRET_HANDLE *phAgreedSecret,
    __in    DWORD   dwFlags)
{
    UNREFERENCED_PARAMETER(hProvider);
    UNREFERENCED_PARAMETER(hPrivKey);
    UNREFERENCED_PARAMETER(hPubKey);
    UNREFERENCED_PARAMETER(phAgreedSecret);
    UNREFERENCED_PARAMETER(dwFlags);
    return NTE_NOT_SUPPORTED;
}


SECURITY_STATUS
WINAPI
SampleKSPDeriveKey(
    __in        NCRYPT_PROV_HANDLE   hProvider,
    __in_opt    NCRYPT_SECRET_HANDLE hSharedSecret,
    __in        LPCWSTR              pwszKDF,
    __in_opt    NCryptBufferDesc     *pParameterList,
    __out_bcount_part_opt(cbDerivedKey, *pcbResult) PUCHAR pbDerivedKey,
    __in        DWORD                cbDerivedKey,
    __out       DWORD                *pcbResult,
    __in        ULONG                dwFlags)
{
    UNREFERENCED_PARAMETER(hProvider);
    UNREFERENCED_PARAMETER(hSharedSecret);
    UNREFERENCED_PARAMETER(pwszKDF);
    UNREFERENCED_PARAMETER(pParameterList);
    UNREFERENCED_PARAMETER(pbDerivedKey);
    UNREFERENCED_PARAMETER(cbDerivedKey);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);
    return NTE_NOT_SUPPORTED;
}

SECURITY_STATUS
WINAPI
SampleKSPFreeSecret(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_SECRET_HANDLE hSharedSecret)
{
    UNREFERENCED_PARAMETER(hProvider);
    UNREFERENCED_PARAMETER(hSharedSecret);
    return NTE_NOT_SUPPORTED;
}
