// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

/*++

Abstract:
    The helper functions for managing the key files

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
#include <Userenv.h>
#include <intsafe.h>
#include <strsafe.h>
#include <Aclapi.h>
#include "../inc/SampleKSP.h"

///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of local routines...
//
///////////////////////////////////////////////////////////////////////////////
SECURITY_STATUS
IsThreadWellKnownSid(
    __in    DWORD   dwRID,
    __out   BOOL *  pfIsLocalSystem);


SECURITY_STATUS
ValidateKeyFile(
    __in_bcount(cbFile) PBYTE pbFile,
    __in DWORD cbFile);

SECURITY_STATUS
BuildKeyFilePath(
    __in SAMPLEKSP_KEY* pKey,
    __deref_out LPWSTR* pszFile);

SECURITY_STATUS
WriteKeyFile(
    __in SAMPLEKSP_KEY *pKey);

SECURITY_STATUS
ZeroizeFile(
    __in LPCWSTR pszFilePath);

SECURITY_STATUS
ConvertContainerSecurityDescriptor(
    __in  PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __deref_out_bcount(*pcbNewSD) PSECURITY_DESCRIPTOR *ppNewSD,
    __out DWORD *pcbNewSD);

SECURITY_STATUS
CheckAndChangeAccessMasks(
    __inout PACL    pAcl);

VOID
ComputeSerializedPropertyListLength(
    __in SAMPLEKSP_KEY *pKey,
    __out DWORD *pcbProperties);

SECURITY_STATUS
SerializeProperties(
    __in SAMPLEKSP_KEY *pKey,
    __deref_out_bcount(*pcbProperties) PBYTE *ppbProperties,
    __out DWORD *pcbProperties);

SECURITY_STATUS
DeserializeProperties(
    __inout SAMPLEKSP_KEY *pKey,
    __in_bcount(cbProperties) PBYTE pbProperties,
    __in DWORD cbProperties);


SECURITY_STATUS
SerializeKeyForStorage(
    __in SAMPLEKSP_KEY *pKey,
    __deref_out_bcount(*pcbKeyFile) PBYTE *ppbKeyFile,
    __out DWORD *pcbKeyFile);

SECURITY_STATUS
SetSecurityOnKeyFile(
    __in    SAMPLEKSP_KEY *pKey,
    __in    DWORD   dwSecurityFlags,
    __in_bcount(cbSecurityDescr) PSECURITY_DESCRIPTOR pSecurityDescr,
    __in    DWORD   cbSecurityDescr);

///////////////////////////////////////////////////////////////////////////////
/******************************************************************************
* DESCRIPTION :    Validate sample KSP key file blob
*
* INPUTS :
*           PBYTE pbFile            The key file blob
*
* RETURN :
*           ERROR_SUCCESS       The key file blob is valid.
*           NTE_BAD_KEY         The key file blob is invalid.
*/
SECURITY_STATUS
ValidateKeyFile(
    __in_bcount(cbFile) PBYTE pbFile,
    __in DWORD cbFile)
{
    SAMPLEKSP_KEYFILE_HEADER *pHeader = NULL;
    DWORD cbBlob = 0;

    pHeader = (SAMPLEKSP_KEYFILE_HEADER *) pbFile;

    //Check the version of the sample KSP key.
    if (pHeader->dwVersion != SAMPLEKSP_KEY_FILE_VERSION )
    {
        return NTE_BAD_KEY;
    }

    //This sample KSP only supports the RSA algorithm.
    if(pHeader->dwAlgorithm != SAMPLEKSP_RSA_ALGID)
    {
        return NTE_BAD_KEY;
    }

    //Validate the size of all fields.
    if(pHeader->cbPrivateKey ==0||
       pHeader->cbName==0 )
    {
        return NTE_BAD_KEY;
    }

    //Check for overflow while checking total blob size.
    if ((ULongAdd(cbBlob, sizeof(SAMPLEKSP_KEYFILE_HEADER), &cbBlob) != S_OK)||
        (ULongAdd(cbBlob, pHeader->cbProperties,&cbBlob)!=S_OK)||
        (ULongAdd(cbBlob, pHeader->cbPrivateKey,&cbBlob)!=S_OK)||
        (ULongAdd(cbBlob, pHeader->cbName,&cbBlob)!=S_OK))
    {
        return NTE_BAD_KEY;
    }

    if (cbBlob != cbFile)
    {
        return NTE_BAD_KEY;
    }

    return ERROR_SUCCESS;

}

/******************************************************************************
* DESCRIPTION :    Check if the key file already exists.
*
* INPUTS :
*           SAMPLEKSP_KEY       A handle to the sample KSP key object.
*
* RETURN :
*           ERROR_SUCCESS       The key file does not exist, yet.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_EXISTS          The key file already exists.
*/
SECURITY_STATUS
ValidateKeyFileExistence(
    __in SAMPLEKSP_KEY* pKey)
{
    HANDLE  hFile = NULL;
    LPWSTR  pszFilePath = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    //Build path to the file.
    Status = BuildKeyFilePath(pKey,&pszFilePath);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }
    //Open file.
    hFile = CreateFileW(pszFilePath,
                    GENERIC_READ,
                    FILE_SHARE_READ,
                    NULL,
                    OPEN_EXISTING,
                    FILE_FLAG_SEQUENTIAL_SCAN,
                    NULL);
    if(hFile != INVALID_HANDLE_VALUE)
    {
        Status = NTE_EXISTS;
        goto cleanup;
    }

    Status = ERROR_SUCCESS;
cleanup:
    if (pszFilePath)
    {
       HeapFree(GetProcessHeap(),0,pszFilePath);
    }
    if (hFile)
    {
       CloseHandle(hFile);
    }
    return Status;
}

/******************************************************************************
* DESCRIPTION : This function determines if the user associated with the
*               specified token is a local system account.
* INPUTS :
*           SAMPLEKSP_KEY       A handle to the sample KSP key object.
*
* RETURN :
*           ERROR_SUCCESS       The user is a local system account.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  An internal error occurred.
*/
SECURITY_STATUS
IsThreadWellKnownSid(
    __in    DWORD   dwRID,
    __out   BOOL *  pfIsLocalSystem)
{
    DWORD dwReturn = ERROR_INTERNAL_ERROR;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    BOOL fSts = FALSE;
    HANDLE  hToken = 0;
    UCHAR defaultBuffer[1024];
    DWORD dwInfoBufferSize = sizeof(defaultBuffer);
    PTOKEN_USER dynamicBuffer = NULL;
    PTOKEN_USER pTokenUser = (PTOKEN_USER)defaultBuffer;
    PISID psidLocalSystem = NULL;
    SID_IDENTIFIER_AUTHORITY siaNtAuthority = SECURITY_NT_AUTHORITY;

    *pfIsLocalSystem = FALSE;

    //Get the token.
    fSts = OpenThreadToken(GetCurrentThread(), TOKEN_QUERY, TRUE, &hToken);
    if (!fSts)
    {
        dwReturn = GetLastError();
        if (dwReturn != ERROR_NO_TOKEN)
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }

        fSts = OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken);
        if (!fSts)
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }
    }

    fSts = GetTokenInformation(hToken, TokenUser, pTokenUser,
                               dwInfoBufferSize, &dwInfoBufferSize);

    //
    // If fast buffer wasn't big enough, allocate enough storage
    // and try again.
    //
    if (!fSts)
    {
        dwReturn = GetLastError();
        if (dwReturn !=ERROR_INSUFFICIENT_BUFFER)
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }

        dynamicBuffer = (PTOKEN_USER)HeapAlloc(GetProcessHeap(),0,dwInfoBufferSize);
        if (dynamicBuffer == NULL)
        {
            Status = NTE_NO_MEMORY;
            goto cleanup;
        }

        pTokenUser = dynamicBuffer;
        fSts = GetTokenInformation(hToken, TokenUser, pTokenUser,
                                   dwInfoBufferSize, &dwInfoBufferSize);
        if (!fSts)
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }
    }

    //Build the well-known system SID.
    fSts = AllocateAndInitializeSid(&siaNtAuthority,
                                         1,
                                         dwRID,
                                         0, 0, 0, 0, 0, 0, 0,
                                         &psidLocalSystem);
    if (!fSts)
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }
    if (EqualSid(psidLocalSystem, pTokenUser->User.Sid))
    {
        *pfIsLocalSystem = TRUE;
    }
    Status = ERROR_SUCCESS;

cleanup:
    if (dynamicBuffer)
    {
        HeapFree(GetProcessHeap(),0,dynamicBuffer);
    }
    if (psidLocalSystem)
    {
        FreeSid(psidLocalSystem);
    }
    if (hToken != NULL)
    {
        CloseHandle(hToken);
    }
    return Status;
}

/******************************************************************************
* DESCRIPTION : Get the path to the sample KSP key storage area.
*
* OUTPUTS :
*           LPWSTR *ppwszKeyFilePath  Path to the key storage area.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  An internal error occurred.
*/
SECURITY_STATUS
GetSampleKeyStorageArea(
    __deref_out LPWSTR *ppwszKeyFilePath)
{
     SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
     DWORD  dwReturn = ERROR_INTERNAL_ERROR;
     BOOL fIsLocalSystem = FALSE;
     HANDLE hToken = NULL;
     BOOL fSts;
     WCHAR wszUserStorageRoot[MAX_PATH+1];
     DWORD cchUserStorageRoot =0;
     DWORD cbUserStorageRoot =0;

     //Check if running in the LocalSystem context.
     Status =  IsThreadWellKnownSid(SECURITY_LOCAL_SYSTEM_RID,
                                     &fIsLocalSystem);
     if (Status != ERROR_SUCCESS)
     {
        goto cleanup;
     }

     if (fIsLocalSystem)
     {
        //This is running in the LocalSystem context.
        cchUserStorageRoot = RTL_NUMBER_OF(wszUserStorageRoot);
        if (!GetAllUsersProfileDirectoryW(
                                wszUserStorageRoot,
                                &cchUserStorageRoot))
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }

     }
     else
     {
        fSts = OpenThreadToken(GetCurrentThread(),
                    TOKEN_QUERY|TOKEN_IMPERSONATE,
                    TRUE,
                    &hToken);
        if (!fSts)
        {
            dwReturn = GetLastError();
            if (dwReturn != ERROR_NO_TOKEN)
            {
                Status = NTE_INTERNAL_ERROR;
                goto cleanup;
            }

            fSts = OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken);
            if (!fSts)
            {
                Status = NTE_INTERNAL_ERROR;
                goto cleanup;
            }
        }

        cchUserStorageRoot = RTL_NUMBER_OF(wszUserStorageRoot);
        //Get use profile directory
        if (!GetUserProfileDirectoryW(
                hToken,
                wszUserStorageRoot,
                &cchUserStorageRoot))
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }
     }

     //Append  L"\\AppData\\Roaming\\\Microsoft\Crypto\\SampleKSP\\".
     wcscat_s(wszUserStorageRoot,
            RTL_NUMBER_OF(wszUserStorageRoot),
            SAMPLEKSP_KEYFOLDER_NAME);

     //Copy the path to the output buffer.
     cbUserStorageRoot = (cchUserStorageRoot +
                (DWORD)wcslen(SAMPLEKSP_KEYFOLDER_NAME)) * sizeof(WCHAR);
     *ppwszKeyFilePath = (LPWSTR)HeapAlloc(GetProcessHeap(),0,cbUserStorageRoot);
     if (ppwszKeyFilePath == NULL)
     {
        Status=NTE_NO_MEMORY;
        goto cleanup;
     }
     CopyMemory(*ppwszKeyFilePath,wszUserStorageRoot,cbUserStorageRoot);

     dwReturn = ERROR_SUCCESS;
cleanup:

    if (hToken != NULL)
    {
        CloseHandle(hToken);
    }
    return Status;
}

/******************************************************************************
* DESCRIPTION : Get the absolute path to the gkey file.
*
* INPUTS:
*           SAMPLEKSP_KEY pKey        A handle to the key object.
* OUTPUTS :
*           LPWSTR* pszFilePath       Path to the key file.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*/
SECURITY_STATUS
BuildKeyFilePath(
    __in SAMPLEKSP_KEY* pKey,
    __deref_out LPWSTR* pszKeyFilePath)
{
    LPWSTR  pszFilePath = NULL;
    PBYTE   pbCurrent = NULL;
    DWORD   cbKeyFileName = 0;
    DWORD   cbKeyFilePath = 0;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    if (pKey->pszKeyName == 0)
    {
        //This is not a persisted key.
        Status = NTE_BAD_DATA;
        goto cleanup;
    }

    if (pKey->pszKeyFilePath == 0)
    {
        Status = GetSampleKeyStorageArea(&pKey->pszKeyFilePath);
        if (Status!=ERROR_SUCCESS)
        {
            goto cleanup;
        }
    }

    cbKeyFileName = (DWORD)wcslen(pKey->pszKeyName) * sizeof(WCHAR);
    cbKeyFilePath = (DWORD)wcslen(pKey->pszKeyFilePath) * sizeof(WCHAR);

    //Build path to the file.
    pszFilePath = (LPWSTR)HeapAlloc(
                            GetProcessHeap(),
                            0,
                            cbKeyFileName+cbKeyFilePath+ sizeof(WCHAR));
    if (pszFilePath == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    pbCurrent = (PBYTE)pszFilePath;
    CopyMemory(pbCurrent, pKey->pszKeyFilePath, cbKeyFilePath);
    pbCurrent += cbKeyFilePath;
    CopyMemory(pbCurrent, pKey->pszKeyName, cbKeyFileName + sizeof(WCHAR));
    *pszKeyFilePath = pszFilePath;
    Status = ERROR_SUCCESS;

cleanup:

    return Status;
}

/******************************************************************************
* DESCRIPTION : Zero the content of the key file before deletion.
*
* INPUTS:
*           LPCWSTR pszFilePath     Path to the key file.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  Deletion failed.
*/
SECURITY_STATUS
ZeroizeFile(
    __in LPCWSTR pszFilePath)
{
    DWORD   dwReturn = ERROR_INTERNAL_ERROR;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    HANDLE  hFile = INVALID_HANDLE_VALUE;
    BYTE    *pbFileBuffer = NULL;
    DWORD   cbFileBuffer =0;
    DWORD   dwBytesWritten = 0;

    hFile = CreateFileW(pszFilePath,
                        GENERIC_WRITE,
                        0,
                        NULL,
                        OPEN_EXISTING,
                        FILE_ATTRIBUTE_SYSTEM,
                        NULL);
    if (INVALID_HANDLE_VALUE == hFile)
    {
        dwReturn = GetLastError();
        if (ERROR_FILE_NOT_FOUND == dwReturn ||
            ERROR_PATH_NOT_FOUND == dwReturn)
        {
            Status = NTE_BAD_KEYSET;
        }
        else
        {
            Status = NTE_INTERNAL_ERROR;
        }
        goto cleanup;
    }

    cbFileBuffer = GetFileSize(hFile, NULL);
    if ((DWORD)(-1) == cbFileBuffer)
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    pbFileBuffer = (PBYTE)HeapAlloc(GetProcessHeap(),0,cbFileBuffer);

    if(pbFileBuffer == NULL)
    {
        goto cleanup;
    }
    ZeroMemory(pbFileBuffer, cbFileBuffer);

    if(!WriteFile(hFile, pbFileBuffer, cbFileBuffer, &dwBytesWritten, NULL))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    dwReturn = ERROR_SUCCESS;

cleanup:

    if(pbFileBuffer)
    {
        HeapFree(GetProcessHeap(),0,pbFileBuffer);
    }

    if(hFile != INVALID_HANDLE_VALUE)
    {
        CloseHandle(hFile);
    }

    return dwReturn;
}

/******************************************************************************
* DESCRIPTION : Remove the key file from the key storage.
*
* INPUTS:
*           SAMPLEKSP_KEY pKey         A handle to the key object.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  Deletion failed.
*/
SECURITY_STATUS
RemoveKeyFromStore(
    __in SAMPLEKSP_KEY *pKey)
{
    LPWSTR pszFilePath = NULL;
    DWORD dwReturn = 0;
    SECURITY_STATUS Status;

    if ((pKey->pszKeyName==NULL)||(pKey->pszKeyFilePath==NULL))
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    //Build path to the file.
    Status = BuildKeyFilePath(pKey,&pszFilePath);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Zeroize the file first.
    Status = ZeroizeFile(pszFilePath);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Delete the file.
    if(!DeleteFileW(pszFilePath))
    {
        dwReturn = GetLastError();
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    Status = ERROR_SUCCESS;

cleanup:

    if(pszFilePath)
    {
        HeapFree(GetProcessHeap(),0,pszFilePath);
    }

    return Status;
}

/******************************************************************************
* DESCRIPTION : Read the name of the key from the key file.
*
* INPUTS:
*           LPWSTR  pszFilePath   Path to the key file.
*
* OUTPUS:
*           NCryptKeyName **ppKeyName    Name of the key.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  Open file operation failed.
*/
SECURITY_STATUS
ReadKeyNameFromFile(
    __in LPWSTR  pszKeyStorageArea,
    __in LPWSTR  pszFileName,
    __deref_out NCryptKeyName **ppKeyName)
{
    SECURITY_STATUS   Status = NTE_INTERNAL_ERROR;
    HANDLE            hFile = NULL;
    DWORD             cbFile = 0;
    DWORD             cbRead = 0;
    PBYTE             pbFile = NULL;
    PBYTE             pbCurrent = NULL;
    LPWSTR            pszFullFilePath = NULL;
    DWORD             cbKeyStorageArea = 0;
    DWORD             cbFileName = 0;
    SAMPLEKSP_KEYFILE_HEADER *pHeader = NULL;
    NCryptKeyName         *pOutput =NULL;
    DWORD cbOutput =0 ;
    DWORD cbKeyName =0;
    DWORD cbAlgName = 0;
    PBYTE pbKeyName = NULL;

    //Build the file path.
    cbKeyStorageArea = (DWORD)wcslen(pszKeyStorageArea) * sizeof(WCHAR);
    cbFileName = (DWORD)wcslen(pszFileName) * sizeof(WCHAR);
    pszFullFilePath = HeapAlloc(
                            GetProcessHeap(),
                            0,
                            cbKeyStorageArea+cbFileName+sizeof(WCHAR));
    if(pszFullFilePath == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    pbCurrent = (PBYTE)pszFullFilePath ;

    CopyMemory(pbCurrent, pszKeyStorageArea, cbKeyStorageArea);
    pbCurrent += cbKeyStorageArea;

    CopyMemory(pbCurrent, pszFileName, cbFileName + sizeof(WCHAR));


    //Open file.
    hFile = CreateFileW(pszFullFilePath,
                        GENERIC_READ,
                        FILE_SHARE_READ,
                        NULL,
                        OPEN_EXISTING,
                        FILE_FLAG_SEQUENTIAL_SCAN| FILE_FLAG_BACKUP_SEMANTICS,
                        NULL);
    if (hFile == INVALID_HANDLE_VALUE )
    {
         Status = NTE_INTERNAL_ERROR;
         goto cleanup;
    }

    //Read in the key from file system.
    cbFile = GetFileSize(hFile, NULL);
    if(cbFile == INVALID_FILE_SIZE ||
       cbFile < sizeof(SAMPLEKSP_KEY))
    {
        Status = NTE_BAD_KEY;
        goto cleanup;
    }

    pbFile= (PBYTE)HeapAlloc(GetProcessHeap(),0,cbFile);
    if(pbFile == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    if(!ReadFile(   hFile,
                    pbFile,
                    cbFile,
                    &cbRead,
                    NULL))
    {
         Status = NTE_INTERNAL_ERROR;
         goto cleanup;
    }

    if(cbRead != cbFile)
    {
        Status = NTE_BAD_KEY;
        goto cleanup;
    }

    //Validate the key file.
    Status = ValidateKeyFile(pbFile, cbFile);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Build the output data.
    pHeader = (SAMPLEKSP_KEYFILE_HEADER *)pbFile;
    cbKeyName = pHeader->cbName;
    pbKeyName = (PBYTE)pHeader+
                sizeof(SAMPLEKSP_KEYFILE_HEADER)+
                pHeader->cbProperties +
                pHeader->cbPrivateKey;
    cbAlgName = (DWORD)wcslen(BCRYPT_RSA_ALGORITHM) * sizeof(WCHAR);
    cbOutput = sizeof(NCryptKeyName) +
               cbKeyName + sizeof(WCHAR) +
               cbAlgName + sizeof(WCHAR);
    pOutput = (NCryptKeyName *)HeapAlloc(GetProcessHeap(),0,cbOutput);
    if(pOutput == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    pbCurrent = (PBYTE)(pOutput+1);
    pOutput->dwFlags=0;
    //Sample KSP does not support legacy keys.
    pOutput->dwLegacyKeySpec=0;
    //Name of the key.
    pOutput->pszName = (LPWSTR)pbCurrent;
    pbCurrent = (PBYTE)(pOutput + 1);
    CopyMemory(pbCurrent, pbKeyName, cbKeyName);
    pbCurrent += cbKeyName;
    *(LPWSTR)pbCurrent = L'\0';
    pbCurrent += sizeof(WCHAR);
    //Name of the algorithm.
    pOutput->pszAlgid = (LPWSTR)pbCurrent;
    CopyMemory(pbCurrent, NCRYPT_RSA_ALGORITHM, cbAlgName);
    pbCurrent += cbAlgName;
    *(LPWSTR)pbCurrent = L'\0';
    pbCurrent += sizeof(WCHAR);

    *ppKeyName = pOutput;

    Status = ERROR_SUCCESS;
cleanup:
    if(hFile != INVALID_HANDLE_VALUE)
    {
        CloseHandle(hFile);
    }
    if (pszFullFilePath)
    {
        HeapFree(GetProcessHeap(),0,pszFullFilePath);
    }
    return Status;
}

/******************************************************************************
* DESCRIPTION : Read key file and store the key file blob into the key object.
*
* INPUTS:
*           SAMPLEKSP_KEY *pKey         A handle to the key object
*
* OUTPUS:
*           SAMPLEKSP_KEY *pKey         Key object with the key file information
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_BAD_KEYSET      Key file does not exists.
*           NTE_INTERNAL_ERROR  Read file operation failed.
*/
SECURITY_STATUS
ReadKeyFile(
    __inout SAMPLEKSP_KEY *pKey)
{
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;
    HANDLE  hFile = NULL;
    DWORD   cbFile = 0;
    DWORD   cbRead = 0;
    PBYTE   pbFile = NULL;
    LPWSTR  pszFilePath = NULL;

    //Build path to the file.
    Status = BuildKeyFilePath(pKey,&pszFilePath);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Open file.
    hFile = CreateFileW(pszFilePath,
                        GENERIC_READ,
                        FILE_SHARE_READ,
                        NULL,
                        OPEN_EXISTING,
                        FILE_FLAG_SEQUENTIAL_SCAN| FILE_FLAG_BACKUP_SEMANTICS,
                        NULL);
    if (hFile == INVALID_HANDLE_VALUE )
    {
         Status = NTE_BAD_KEYSET;
         goto cleanup;
    }

    //Read in the key from file system.
    cbFile = GetFileSize(hFile, NULL);
    if(cbFile == INVALID_FILE_SIZE ||
       cbFile < sizeof(SAMPLEKSP_KEY))
    {
        Status = NTE_BAD_KEY;
        goto cleanup;
    }

    pbFile= (PBYTE)HeapAlloc(GetProcessHeap(),0,cbFile);
    if(pbFile == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    if(!ReadFile(   hFile,
                    pbFile,
                    cbFile,
                    &cbRead,
                    NULL))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    if(cbRead != cbFile)
    {
        Status = NTE_BAD_KEY;
        goto cleanup;
    }

    //Validate the key file.
    Status = ValidateKeyFile(pbFile, cbFile);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Store the key file header into the key handle.
    pKey->pbKeyFile = (PBYTE)HeapAlloc(GetProcessHeap(),0,cbFile);
    if (pKey->pbKeyFile == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    CopyMemory(pKey->pbKeyFile,pbFile,cbFile);

cleanup:
    if(hFile != INVALID_HANDLE_VALUE)
    {
        CloseHandle(hFile);
    }

    if(pszFilePath)
    {
        HeapFree(GetProcessHeap(),0,pszFilePath);
    }
    if (pbFile)
    {
        SecureZeroMemory(pbFile,cbFile);
        HeapFree(GetProcessHeap(),0,pbFile);
    }
    return Status;
}


/******************************************************************************
* DESCRIPTION : Write key material into a key file.
*
* INPUTS:
*           SAMPLEKSP_KEY *pKey         A handle to the key object.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  File operation failed.
*/
SECURITY_STATUS
WriteKeyFile(
    __in SAMPLEKSP_KEY *pKey)
{
    SECURITY_STATUS   Status = ERROR_INTERNAL_ERROR;
    LPWSTR pszFilePath = NULL;
    HANDLE hFile = INVALID_HANDLE_VALUE;
    DWORD dwReturn = ERROR_INTERNAL_ERROR;
    DWORD dwBytesWritten = 0;

    //Build path to the file.
    Status = BuildKeyFilePath(pKey,&pszFilePath);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Create the key folder if it does not exit.
    if (!CreateDirectoryW(
                pKey->pszKeyFilePath,
                NULL))
    {
        dwReturn = GetLastError();
    }
    if(dwReturn == ERROR_ALREADY_EXISTS)
    {
        Status = ERROR_SUCCESS;
    }
    else
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    //Open file.
    hFile = CreateFileW(pszFilePath,
                        GENERIC_WRITE,
                        0,
                        NULL,
                        OPEN_ALWAYS,
                        FILE_ATTRIBUTE_SYSTEM| FILE_FLAG_BACKUP_SEMANTICS,
                        NULL);
    if (hFile == INVALID_HANDLE_VALUE )
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    //Write into file.
    if(!WriteFile(hFile, pKey->pbKeyFile, pKey->cbKeyFile, &dwBytesWritten, NULL))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

cleanup:
    if(hFile != INVALID_HANDLE_VALUE)
    {
        CloseHandle(hFile);
    }

    if(pszFilePath)
    {
        HeapFree(GetProcessHeap(),0,pszFilePath);
    }

    return Status;

}

/******************************************************************************
* DESCRIPTION : Write the key into key storage.
*
* INPUTS:
*           SAMPLEKSP_KEY *pKey         A handle to the key object.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  File operation failed.
*/
SECURITY_STATUS
WriteKeyToStore(
    __inout SAMPLEKSP_KEY *pKey
    )
{
    SECURITY_STATUS Status;
    PBYTE pbPrivateKeyBlob = NULL;
    DWORD cbPrivateKeyBlob = 0;
    PBYTE pbKeyFile = NULL;
    DWORD cbKeyFile = 0;

    PSECURITY_DESCRIPTOR securityDescriptor = NULL;
    DWORD securityFlags=0;

    if (pKey->pbPrivateKey == NULL)
    {
        //Export the private key from BCrypt private key handle.
        Status = AllocAndGetRsaPrivateKeyBlob(
                    pKey,
                    pKey->pszKeyBlobType,
                    &pbPrivateKeyBlob,
                    &cbPrivateKeyBlob);
        if (Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }
        //Protect the key blob and attach it to the key object.
        Status = ProtectAndSetPrivateKey(
                        pKey->pszKeyBlobType,
                        pbPrivateKeyBlob,
                        cbPrivateKeyBlob,
                        pKey);
        if (Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }

    }

    //Serialize key into the data blob to be stored in file the system.
    Status = SerializeKeyForStorage(pKey, &pbKeyFile, &cbKeyFile);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Update the file image in the key object.
    if(pKey->pbKeyFile)
    {
        SecureZeroMemory(pKey->pbKeyFile,pKey->cbKeyFile);
        HeapFree(GetProcessHeap(),0,pKey->pbKeyFile);
    }
    pKey->pbKeyFile = pbKeyFile;
    pKey->cbKeyFile = cbKeyFile;

    //Get path to user's key file storage area.
    if (pKey->pszKeyFilePath == NULL)
    {
        Status = GetSampleKeyStorageArea(&pKey->pszKeyFilePath);
        if(Status != ERROR_SUCCESS)
        {
            goto cleanup;
        }

    }

    //Write file to the file system.
    Status = WriteKeyFile(pKey);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Configure security on the private key file.
    if(pKey->pbSecurityDescr)
    {
        //
        // Take ownership of the security descriptor.
        //
        securityDescriptor      =pKey->pbSecurityDescr;
        pKey->pbSecurityDescr   =NULL;
        securityFlags           =pKey->dwSecurityFlags;
    }

    //Set the security descriptor on the file.
    if (securityDescriptor != NULL)
    {
        Status = SetSecurityOnKeyFile(
                    pKey,
                    securityFlags,
                    securityDescriptor,
                    pKey->cbSecurityDescr
                    );
        if (Status !=ERROR_SUCCESS)
        {
            goto cleanup;
        }
    }

    Status = ERROR_SUCCESS;
cleanup:
    if (pbPrivateKeyBlob)
    {
        HeapFree(GetProcessHeap(),0,pbPrivateKeyBlob);
    }
    if(securityDescriptor)
    {
        HeapFree(GetProcessHeap(),0,securityDescriptor);
    }
    return Status;
}

/******************************************************************************
* DESCRIPTION : Parse the key file blob to get the private and public key and
*               properties.
* INPUTS:
*           SAMPLEKSP_KEY *pKey         A handle to the key object
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*/
SECURITY_STATUS
ParseKeyFile(
    __inout SAMPLEKSP_KEY *pKey)
{
    SAMPLEKSP_KEYFILE_HEADER *pHeader = NULL;
    PBYTE pbProperties = NULL;
    DWORD cbProperties = 0;
    PBYTE pbPrivateKey = NULL;
    DWORD cbPrivateKey =0;
    PBYTE pbKeyName = NULL;
    DWORD cbKeyName = 0;
    SAMPLEKSP_PROPERTY* pProperty = NULL;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    pHeader =  (SAMPLEKSP_KEYFILE_HEADER *)pKey->pbKeyFile;
    //The algorithm field must be RSA.
    if (pHeader->dwAlgorithm != SAMPLEKSP_RSA_ALGID)
    {
        Status = NTE_BAD_KEY;
        goto cleanup;
    }

    //Find the property fields.
    pbProperties = (PBYTE)pHeader+sizeof(SAMPLEKSP_KEYFILE_HEADER);
    cbProperties = pHeader->cbProperties;

    //Find the private key blob.
    pbPrivateKey = pbProperties + cbProperties;
    cbPrivateKey = pHeader->cbPrivateKey;

    //Find the name of the key.
    pbKeyName = pbPrivateKey + cbPrivateKey;
    cbKeyName = pHeader->cbName;

    //Copy the private key into the key blob.
    if (pKey->pbPrivateKey)
    {
        SecureZeroMemory(pKey->pbPrivateKey,pKey->cbPrivateKey);
        HeapFree(GetProcessHeap(),0,pKey->pbPrivateKey);
    }
    pKey->pbPrivateKey=(PBYTE)HeapAlloc(GetProcessHeap(),0,cbPrivateKey);
    if(pKey->pbPrivateKey==NULL)
    {
        Status=NTE_NO_MEMORY;
        goto cleanup;
    }
    CopyMemory(pKey->pbPrivateKey,pbPrivateKey,cbPrivateKey);
    pKey->cbPrivateKey=cbPrivateKey;

    //Get the private and the public key handle.
    Status = ImportRsaKeyPair(pKey);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Deserialize properties and add them to the key object.
    Status = DeserializeProperties(
                        pKey,
                        pbProperties,
                        cbProperties);
    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //Copy the name of the key.
    if (pKey->pszKeyName)
    {
        HeapFree(GetProcessHeap(),0,pKey->pszKeyName);
    }
    pKey->pszKeyName = (LPWSTR)HeapAlloc(
                                GetProcessHeap(),
                                0,
                                cbKeyName+sizeof(WCHAR));
    if (pKey->pszKeyName == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    CopyMemory(pKey->pszKeyName,pbKeyName,cbKeyName);
    pKey->pszKeyName[cbKeyName/sizeof(WCHAR)]=L'\0';

    //Set the export policy if it is set.
    Status = LookupExistingKeyProperty(
                    pKey,
                    NCRYPT_EXPORT_POLICY_PROPERTY,
                    &pProperty);
    if ((Status==ERROR_SUCCESS)&&pProperty->fBuildin)
    {
        if (pProperty->cbPropertyData != sizeof(DWORD))
        {
            Status = NTE_BAD_KEY;
            goto cleanup;
        }
        CopyMemory(&pKey->dwExportPolicy,pProperty+1,sizeof(DWORD));
    }

    //Set the key usage policy if it is set.
    Status = LookupExistingKeyProperty(
                    pKey,
                    NCRYPT_KEY_USAGE_PROPERTY,
                    &pProperty);
    if ((Status==ERROR_SUCCESS)&&pProperty->fBuildin)
    {
        if (pProperty->cbPropertyData != sizeof(DWORD))
        {
            Status = NTE_BAD_KEY;
            goto cleanup;
        }
        CopyMemory(&pKey->dwKeyUsagePolicy,pProperty+1,sizeof(DWORD));
    }

    Status = ERROR_SUCCESS;
cleanup:

    return Status;
}

/******************************************************************************
* DESCRIPTION : Converts a security descriptor if it is not self relative.
*
* INPUTS:
*           PSECURITY_DESCRIPTOR pSecurityDescriptor   A security descriptor.
*
* OUTPUS:
*           PSECURITY_DESCRIPTOR *ppNewSD   The security descritor which is
*                                           self relative.
*           DWORD *pcbNewSD                 The size of the converted security
*                                           descriptor.
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*/
SECURITY_STATUS
ConvertContainerSecurityDescriptor(
    __in  PSECURITY_DESCRIPTOR pSecurityDescriptor,
    __deref_out_bcount(*pcbNewSD) PSECURITY_DESCRIPTOR *ppNewSD,
    __out DWORD *pcbNewSD)
{
    SECURITY_STATUS             Status = NTE_INTERNAL_ERROR;
    DWORD                       cbSD = 0;
    SECURITY_DESCRIPTOR_CONTROL Control =0 ;
    DWORD                       dwRevision =0;

    // Get the control on the security descriptor to check if self relative.
    if (!GetSecurityDescriptorControl(pSecurityDescriptor,
                                             &Control, &dwRevision))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }


    // Get the length of the security descriptor and alloc space for a copy.
    cbSD = GetSecurityDescriptorLength(pSecurityDescriptor);
    *ppNewSD =(PSECURITY_DESCRIPTOR)HeapAlloc(GetProcessHeap(),0,cbSD);
    if (*ppNewSD ==NULL)
    {
        Status = STATUS_NO_MEMORY;
        goto cleanup;
    }

    if (SE_SELF_RELATIVE & Control)
    {
        // If the Security Descriptor is self relative then make a copy.
        CopyMemory(*ppNewSD, pSecurityDescriptor, cbSD);
    }
    else
    {
        // If not self relative then make a self relative copy.
        if (!MakeAbsoluteSD(pSecurityDescriptor,
                                *ppNewSD,
                                &cbSD,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL))
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }

    }

    Status = STATUS_SUCCESS;

cleanup:
    *pcbNewSD = cbSD;
    return Status;
}

/******************************************************************************
* DESCRIPTION : Loops through the ACEs of an ACL and checks for special access
*               bits for files and adds the equivalent generic access bits.
*
* INPUTS:
*           PACL pAcl           The ACL to process
*
* OUTPUS:
*           PACL pAcl           The ACL to process with generic access bits
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*           NTE_INTERNAL_ERROR  Failed to get the ace information
*/
SECURITY_STATUS
CheckAndChangeAccessMasks(
    __inout PACL    pAcl)
{
    SECURITY_STATUS         Status = NTE_INTERNAL_ERROR;
    ACL_SIZE_INFORMATION    AclSizeInfo ={0} ;
    DWORD                   i=0;
    ACCESS_ALLOWED_ACE      *pAce = NULL;

    memset(&AclSizeInfo, 0, sizeof(AclSizeInfo));

    // Get the number of ACEs in the ACL.
    if (!GetAclInformation(pAcl, &AclSizeInfo, sizeof(AclSizeInfo),
                           AclSizeInformation))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    // Loop through the ACEs checking and grant generic access bits.
    for (i = 0; i < AclSizeInfo.AceCount; i++)
    {
        if (!GetAce(pAcl, i, (LPVOID*)&pAce))
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }

        // Check if the specific access bits are set, if so add generic equivalent.
        if ((pAce->Mask & FILE_READ_DATA) == FILE_READ_DATA)
        {
            pAce->Mask |= GENERIC_READ;
        }

        if ((pAce->Mask & FILE_WRITE_DATA) == FILE_WRITE_DATA)
        {
            pAce->Mask |= GENERIC_WRITE;
        }

        if ((pAce->Mask & FILE_ALL_ACCESS) == FILE_ALL_ACCESS)
        {
            pAce->Mask |= GENERIC_ALL;
        }
    }

    Status = ERROR_SUCCESS;

cleanup:
    return Status;
}

/******************************************************************************
* DESCRIPTION : Get the security descriptor on the key file.
* INPUTS:
*           SAMPLEKSP_KEY *pKey         A handle to the key object.
*           DWORD   dwSecurityFlags     Flags
*
* OUTPUS:
*    PSECURITY_DESCRIPTOR *ppSecurityDescr  Security descriptor on the key file
*    DWORD * pcbSecurityDescr               Size of the security descriptor
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_INVALID_HANDLE  The key handle is invalid.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*/
SECURITY_STATUS
GetSecurityOnKeyFile(
    __in    SAMPLEKSP_KEY *pKey,
    __in    DWORD   dwSecurityFlags,
    __deref_out_bcount(*pcbSecurityDescr) PSECURITY_DESCRIPTOR *ppSecurityDescr,
    __out   DWORD * pcbSecurityDescr)
{
    LPWSTR pszFilePath = NULL;
    PSECURITY_DESCRIPTOR pSD = NULL;
    PSECURITY_DESCRIPTOR pNewSD = NULL;
    DWORD  cbNewSD =0;
    DWORD  dwReturn = ERROR_INTERNAL_ERROR;
    SECURITY_STATUS Status=NTE_INTERNAL_ERROR;

    if ((pKey->pszKeyName == NULL)||(pKey->pszKeyFilePath == NULL))
    {
        Status = NTE_INVALID_HANDLE;
        goto cleanup;
    }

    //Build the path to the key file.
    Status = BuildKeyFilePath(pKey,&pszFilePath);

    //Read the security descriptor off of the file.
    dwReturn = GetNamedSecurityInfoW(pszFilePath,
                                   SE_FILE_OBJECT,
                                   (SECURITY_INFORMATION)dwSecurityFlags,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   &pSD);
    if (dwReturn != ERROR_SUCCESS)
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    //
    // Make sure the security descriptor is self relative.
    //

    Status = ConvertContainerSecurityDescriptor(pSD, &pNewSD, &cbNewSD);

    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }


    // Make sure we always have the generic bits as well as the file specific bits
    // for DACLs.
    if ((dwSecurityFlags & DACL_SECURITY_INFORMATION) == DACL_SECURITY_INFORMATION)
    {
        BOOL fDaclPresent, fDaclDefaulted;
        PACL pDacl;

        // Get the DACL out of the security descriptor.
        if (!GetSecurityDescriptorDacl(pNewSD, &fDaclPresent, &pDacl,
                                        &fDaclDefaulted))
        {
            Status = NTE_INTERNAL_ERROR;
            goto cleanup;
        }
        if (fDaclPresent && pDacl)
        {
            Status = CheckAndChangeAccessMasks(pDacl);
            if (Status != ERROR_SUCCESS)
            {
                goto cleanup;
            }
        }
    }

    //
    // Set output values.
    //

    *ppSecurityDescr = pNewSD;
    *pcbSecurityDescr = cbNewSD;

    pNewSD = NULL;

    Status = ERROR_SUCCESS;

cleanup:

    if(pNewSD)
    {
        HeapFree(GetProcessHeap(),0,pNewSD);
    }

    if(pSD)
    {
        HeapFree(GetProcessHeap(),0,pSD);
    }

    if(pszFilePath)
    {
        HeapFree(GetProcessHeap(),0,pszFilePath);
    }

    return Status;

}

/******************************************************************************
* DESCRIPTION : Set the security descriptor on the key file.
* INPUTS:
*           SAMPLEKSP_KEY *pKey                  A handle to the key object.
*           DWORD   dwSecurityFlags              Flags
*           PSECURITY_DESCRIPTOR pSecurityDescr  Security descriptor to set on
*                                                the file.
*
* RETURN :
*           ERROR_SUCCESS       The function was successful.
*           NTE_NO_MEMORY       Memory allocation failure occurred.
*/
SECURITY_STATUS
SetSecurityOnKeyFile(
    __in    SAMPLEKSP_KEY *pKey,
    __in    DWORD   dwSecurityFlags,
    __in_bcount(cbSecurityDescr) PSECURITY_DESCRIPTOR pSecurityDescr,
    __in    DWORD   cbSecurityDescr)
{
    LPWSTR pszFilePath = NULL;
    PSECURITY_DESCRIPTOR pSD = NULL;
    DWORD  cbSD =0;
    SECURITY_DESCRIPTOR_CONTROL wSDControl = 0;
    DWORD dwRevision =0;
    PSID psidOwner = NULL;
    PSID psidGroup = NULL;
    PACL pDacl = NULL;
    PACL pSacl = NULL;
    BOOL bDefaulted = FALSE;
    BOOL bPresent = FALSE;
    DWORD   dwReturn = ERROR_INTERNAL_ERROR;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    //
    // Make sure the security descriptor is self relative
    //
    Status = ConvertContainerSecurityDescriptor(
                        pSecurityDescr,
                        &pSD,
                        &cbSD);

    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }


    if (!GetSecurityDescriptorControl(pSD, &wSDControl, &dwRevision))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }
    if (!GetSecurityDescriptorOwner(pSD, &psidOwner, &bDefaulted))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }
    if (!GetSecurityDescriptorGroup(pSD, &psidGroup, &bDefaulted))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }
    if (!GetSecurityDescriptorDacl(pSD, &bPresent, &pDacl, &bDefaulted))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }
    if (!GetSecurityDescriptorSacl(pSD, &bPresent, &pSacl, &bDefaulted))
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
   }

    //Build path to the file
    Status = BuildKeyFilePath(pKey,&pszFilePath);
    if (Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    if (dwSecurityFlags & DACL_SECURITY_INFORMATION)
    {
        if (wSDControl & SE_DACL_PROTECTED)
        {
            dwSecurityFlags |= PROTECTED_DACL_SECURITY_INFORMATION;
        }
        else
        {
            dwSecurityFlags |= UNPROTECTED_DACL_SECURITY_INFORMATION;
        }
    }
    if (dwSecurityFlags & SACL_SECURITY_INFORMATION)
    {
        if (wSDControl & SE_SACL_PROTECTED)
        {
            dwSecurityFlags |= PROTECTED_SACL_SECURITY_INFORMATION;
        }
        else
        {
            dwSecurityFlags |= UNPROTECTED_SACL_SECURITY_INFORMATION;
        }
    }

    dwReturn = SetNamedSecurityInfoW(pszFilePath,
                                   SE_FILE_OBJECT,
                                   dwSecurityFlags,
                                   psidOwner,
                                   psidGroup,
                                   pDacl,
                                   pSacl);
    if (dwReturn !=ERROR_SUCCESS)
    {
        Status = NTE_INTERNAL_ERROR;
        goto cleanup;
    }

    Status = ERROR_SUCCESS;

cleanup:

    if(pSD)
    {
        HeapFree(GetProcessHeap(),0,pSD);
    }

    if(pszFilePath)
    {
        HeapFree(GetProcessHeap(),0,pszFilePath);
    }

    return Status;
    UNREFERENCED_PARAMETER(cbSecurityDescr);
}

/******************************************************************************
* DESCRIPTION : Compute the length of the buffer to contain the property values
* INPUTS:
*           SAMPLEKSP_KEY *pKey     A handle to the key object.
*
* OUTPUTS:
*           DWORD *pcbProperties    Length of the buffer.
*/
VOID
ComputeSerializedPropertyListLength(
    __in SAMPLEKSP_KEY *pKey,
    __out DWORD *pcbProperties)
{
    SAMPLEKSP_PROPERTY *pProperty = NULL;
    PLIST_ENTRY pList = pKey->PropertyList.Flink;
    DWORD cbProperties =0;
    DWORD cbPropertyName =0;

    while(pList != &pKey->PropertyList)
    {
        pProperty = CONTAINING_RECORD(pList, SAMPLEKSP_PROPERTY, ListEntry.Flink);
        pList = pList->Flink;

        if(!pProperty->fPersisted)
        {
            continue;
        }

        cbPropertyName = (DWORD)wcslen(pProperty->szName) * sizeof(WCHAR);

        cbProperties += sizeof(SAMPLEKSP_NAMED_PROPERTY) +
                        cbPropertyName +
                        pProperty->cbPropertyData;
    }

    *pcbProperties = cbProperties;
}

/******************************************************************************
* DESCRIPTION : Create the buffer containing the serialized property values.
*
* INPUTS:
*           SAMPLEKSP_KEY *pKey     A handle to the key object.
*           DWORD *cbOutput         Size of the output buffer.
*
* OUTPUTS:
*           PBYTE pbOutput          Serialized property list.
*
* RETURNS:
*           ERROR_SUCCESS           The function was successful.
*           NTE_FAIL                The size of one of the value is long than
*                                   maximal ULONG.
*           NTE_BUFFER_TOO_SMALL    The output buffer is too small.
*/
SECURITY_STATUS
BuildSerializedPropertyList(
    __in  SAMPLEKSP_KEY *pKey,
    __out_bcount(cbOutput) PBYTE pbOutput,
    __in  DWORD cbOutput)
{
    SAMPLEKSP_NAMED_PROPERTY propertyInFile = {0};
    SAMPLEKSP_PROPERTY *pProperty = {0};
    PLIST_ENTRY pList = pKey->PropertyList.Flink;
    PBYTE pbCurrent = pbOutput;
    DWORD cbProperties = 0;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    while(pList != &pKey->PropertyList)
    {
        pProperty = CONTAINING_RECORD(pList, SAMPLEKSP_PROPERTY, ListEntry.Flink);
        pList = pList->Flink;

        if(!pProperty->fPersisted)
        {
            continue;
        }

        //
        // Build local copy of the named property structure, and then
        // copy it to the output buffer. This protects against any
        // awkward alignment issues.
        //

        ZeroMemory(&propertyInFile, sizeof(propertyInFile));

        propertyInFile.cbPropertyName = (DWORD)wcslen(pProperty->szName) * sizeof(WCHAR);

        propertyInFile.cbPropertyData = pProperty->cbPropertyData;

        propertyInFile.cbLength =  sizeof(SAMPLEKSP_NAMED_PROPERTY) +
                               propertyInFile.cbPropertyName +
                               propertyInFile.cbPropertyData;

        propertyInFile.fBuildin = pProperty->fBuildin;

        if(ULongAdd(cbProperties, propertyInFile.cbLength, &cbProperties) != S_OK)
        {
            Status = NTE_FAIL;
            goto cleanup;
        }

        if(cbProperties > cbOutput)
        {
            Status = NTE_BUFFER_TOO_SMALL;
            goto cleanup;
        }

        CopyMemory(pbCurrent, &propertyInFile, sizeof(SAMPLEKSP_NAMED_PROPERTY));
        pbCurrent += sizeof(SAMPLEKSP_NAMED_PROPERTY);

        CopyMemory(pbCurrent, pProperty->szName, propertyInFile.cbPropertyName);
        pbCurrent += propertyInFile.cbPropertyName;

        CopyMemory(pbCurrent, (PBYTE)(pProperty + 1), propertyInFile.cbPropertyData);
        pbCurrent += propertyInFile.cbPropertyData;

    }


    Status = ERROR_SUCCESS;

cleanup:

    return Status;
}

/******************************************************************************
* DESCRIPTION : Serialize the properties of the key object.
*
* INPUTS:
*           SAMPLEKSP_KEY *pKey     A handle to the key object.
*
* OUTPUTS:
*           PBYTE *ppbProperties        Serialized property list.
*           DWORD *pcbProperties        Size of the serilzed property list.
*
* RETURNS:
*           ERROR_SUCCESS           The function was successful.
*           NTE_FAIL                The size of one of the value is long than
*                                   maximal ULONG.
*           NTE_BUFFER_TOO_SMALL    The output buffer is too small.
*/
SECURITY_STATUS
SerializeProperties(
    __in SAMPLEKSP_KEY *pKey,
    __deref_out_bcount(*pcbProperties) PBYTE *ppbProperties,
    __out DWORD *pcbProperties)
{
    PBYTE pbProperties = NULL;
    DWORD cbProperties = 0;
    SECURITY_STATUS Status;

    // Get size of generic properties.
    ComputeSerializedPropertyListLength(
                        pKey,
                        &cbProperties);
    //Allocate space
    pbProperties = HeapAlloc(GetProcessHeap(),0,cbProperties);
    if (pbProperties == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }
    //
    // Serialize properties.
    //

    Status = BuildSerializedPropertyList(
                        pKey,
                        pbProperties,
                        cbProperties);

    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    //
    // Set output values.
    //

    *ppbProperties = pbProperties;
    *pcbProperties = cbProperties;
    pbProperties = NULL;

    Status = ERROR_SUCCESS;

cleanup:

    if(pbProperties)
    {
        HeapFree(GetProcessHeap(),0,pbProperties);
    }

    return Status;

}

/******************************************************************************
* DESCRIPTION : Deserialize the property list and associate the properties to
*               the key object.
*
* INPUTS:
*           SAMPLEKSP_KEY *pKey     A handle to the key object.
*           PBYTE pbProperties      Buffer with the serialized property list.
*           DWORD cbProperties)     Size of the pbProperties input buffer.
*
* OUTPUTS:
*           SAMPLEKSP_KEY *pKey     Key with the property attached.
*
* RETURNS:
*           ERROR_SUCCESS           The function was successful.
*           NTE_KEYSET_ENTRY_BAD    The buffer contains invalid property
*           NTE_NO_MEMORY           Memory allocation failure occurred.
*/
SECURITY_STATUS
DeserializeProperties(
    __inout SAMPLEKSP_KEY *pKey,
    __in_bcount(cbProperties) PBYTE pbProperties,
    __in DWORD cbProperties)
{
    SAMPLEKSP_NAMED_PROPERTY propertyInFile;
    SAMPLEKSP_PROPERTY *pProperty;
    SECURITY_STATUS Status;
    DWORD cbProperty;

    //create the property list
    while(cbProperties)
    {
        if (cbProperties <sizeof( SAMPLEKSP_NAMED_PROPERTY))
        {
            Status = NTE_KEYSET_ENTRY_BAD;
            goto cleanup;
        }

        CopyMemory(&propertyInFile, pbProperties, sizeof(SAMPLEKSP_NAMED_PROPERTY));
        cbProperty = sizeof(SAMPLEKSP_NAMED_PROPERTY) +
                     propertyInFile.cbPropertyName +
                     propertyInFile.cbPropertyData;

        if (propertyInFile.cbPropertyName>NCRYPT_MAX_PROPERTY_NAME * sizeof(WCHAR)||
            propertyInFile.cbPropertyData > NCRYPT_MAX_PROPERTY_DATA||
            cbProperties < cbProperty)
        {
            Status = NTE_KEYSET_ENTRY_BAD;
            goto cleanup;
        }

        pProperty=(SAMPLEKSP_PROPERTY*)HeapAlloc(
                        GetProcessHeap(),
                        0,
                        sizeof(SAMPLEKSP_PROPERTY)+propertyInFile.cbPropertyData);
        if (pProperty==NULL)
        {
            return NTE_NO_MEMORY;
        }

        //Copy the name of the property
        if (propertyInFile.cbPropertyName)
        {
            ZeroMemory(pProperty->szName,NCRYPT_MAX_PROPERTY_NAME + 1);
            CopyMemory(
                pProperty->szName,
                pbProperties+sizeof(SAMPLEKSP_NAMED_PROPERTY),
                propertyInFile.cbPropertyName);
        }

        //Copy the property data
        pProperty->cbPropertyData = propertyInFile.cbPropertyData;
        CopyMemory(
            pProperty+1,
            pbProperties+sizeof(SAMPLEKSP_NAMED_PROPERTY)+propertyInFile.cbPropertyName,
            propertyInFile.cbPropertyData);

        //This is persisted key property
        pProperty->fPersisted = TRUE;

        //Set the size pf the property
        pProperty->cbLength = sizeof(SAMPLEKSP_PROPERTY)+pProperty->cbPropertyData;

        //Set whether the property is build-in property
        pProperty->fBuildin = propertyInFile.fBuildin;

        //Add property to key object.
        InsertTailList(&pKey->PropertyList, &pProperty->ListEntry);

        pbProperties += cbProperty;
        cbProperties -= cbProperty;
    }

    Status = ERROR_SUCCESS;

cleanup:

    return Status;

}


/******************************************************************************
* DESCRIPTION : Serialize the key object into a memory buffer.
*
* INPUTS:
*           SAMPLEKSP_KEY *pKey     A handle to the key object.
*
* OUTPUTS:
*           PBYTE *ppbKeyFile       Serialized key blob.
*           DWORD *pcbKeyFiles      Size of the serilzed key blob.
*
* RETURNS:
*           ERROR_SUCCESS           The function was successful.
*           NTE_FAIL                The size of one of the value is long than
*                                   maximal ULONG.
*           NTE_BUFFER_TOO_SMALL    The output buffer is too small.
*/
SECURITY_STATUS
SerializeKeyForStorage(
    __in SAMPLEKSP_KEY *pKey,
    __deref_out_bcount(*pcbKeyFile) PBYTE *ppbKeyFile,
    __out DWORD *pcbKeyFile)
{

    SAMPLEKSP_KEYFILE_HEADER *pFileHeader;
    PBYTE pbProperties = NULL;
    DWORD cbProperties = 0;
    PBYTE pbKeyFile = NULL;
    PBYTE pbCurrent = NULL;
    DWORD cbKeyFile = 0;
    SECURITY_STATUS Status = NTE_INTERNAL_ERROR;

    // Serialize list of protected properties.
    Status = SerializeProperties(pKey, &pbProperties, &cbProperties);

    if(Status != ERROR_SUCCESS)
    {
        goto cleanup;
    }

    // Place upper limit on the size of properties.
    if(cbProperties >MAX_NUM_PROPERTIES * NCRYPT_MAX_PROPERTY_DATA)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }


    // Allocate the output buffer
    cbKeyFile = sizeof(SAMPLEKSP_KEYFILE_HEADER) +
                cbProperties +
                pKey->cbPrivateKey +
                (DWORD)wcslen(pKey->pszKeyName) * sizeof(WCHAR);
    pbKeyFile = (PBYTE)HeapAlloc(GetProcessHeap(),0,cbKeyFile);
    if(pbKeyFile == NULL)
    {
        Status = NTE_NO_MEMORY;
        goto cleanup;
    }

    pFileHeader = (SAMPLEKSP_KEYFILE_HEADER*)pbKeyFile;
    pFileHeader->cbLength = cbKeyFile;
    pFileHeader->dwVersion = SAMPLEKSP_KEY_FILE_VERSION;
    pFileHeader->dwAlgorithm = SAMPLEKSP_RSA_ALGID;
    pFileHeader->cbProperties = cbProperties;
    pFileHeader->cbPrivateKey = pKey->cbPrivateKey;
    pFileHeader->cbName = (DWORD)wcslen(pKey->pszKeyName) * sizeof(WCHAR);

    pbCurrent = (PBYTE)(pFileHeader + 1);
    if(pFileHeader->cbProperties)
    {
        CopyMemory(pbCurrent, pbProperties, pFileHeader->cbProperties);
        pbCurrent += pFileHeader->cbProperties;
    }
    if(pFileHeader->cbPrivateKey)
    {
        CopyMemory(pbCurrent, pKey->pbPrivateKey, pFileHeader->cbPrivateKey);
        pbCurrent += pFileHeader->cbPrivateKey;
    }
    if(pFileHeader->cbName)
    {
        CopyMemory(pbCurrent, pKey->pszKeyName, pFileHeader->cbName );
        pbCurrent += pFileHeader->cbName;
    }

    //
    // Set return values.
    //

    *ppbKeyFile = pbKeyFile;
    *pcbKeyFile = cbKeyFile;
    pbKeyFile = NULL;

    Status = ERROR_SUCCESS;
cleanup:

    if(pbProperties)
    {
        HeapFree(GetProcessHeap(),0,pbProperties);
    }

    if(pbKeyFile)
    {
       HeapFree(GetProcessHeap(),0, pbKeyFile);
    }

    return Status;
}

