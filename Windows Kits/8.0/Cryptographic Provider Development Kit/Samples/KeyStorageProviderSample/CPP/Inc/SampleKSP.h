// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

/*++

Abstract:
    Sample RSA key storage provider using CNG

--*/

#ifndef __SAMPLE_KSP_H__
#define __SAMPLE_KSP_H__

#include <ncrypt_provider.h>
#include <bcrypt_provider.h>

#define SAMPLEKSP_INTERFACE_VERSION BCRYPT_MAKE_INTERFACE_VERSION(1,0) //version of the sample KSP interface
#define SAMPLEKSP_VERSION 0x00010000                         //version of the sample KSP
#define SAMPLEKSP_SUPPORT_SECURITY_DESCRIPTOR   0x00000001             //This sample KSP supports security descriptor
#define SAMPLEKSP_PROVIDER_NAME           L"Microsoft Sample Key Storage Provider" //name of the sample KSP provider
#define SAMPLEKSP_PROVIDER_MAGIC          0x53504C50      // SPLP
#define SAMPLEKSP_KEY_MAGIC               0x53504C4b      // SPLK
#define SAMPLEKSP_KEY_FILE_VERSION        1               // version of the key file
#define SAMPLEKSP_RSA_ALGID               1               // Algorithm ID RSA
#define SAMPLEKSP_DEFAULT_KEY_LENGTH      1024            // default key length
#define SAMPLEKSP_RSA_MIN_LENGTH          512             // minimal key length
#define SAMPLEKSP_RSA_MAX_LENGTH          16384           // maximal key length
#define SAMPLEKSP_RSA_INCREMENT           64              // increment of key length
#define SAMPLEKSP_KEYFOLDER_NAME          L"\\AppData\\Roaming\\Microsoft\\Crypto\\SampleKSP\\"  //key storage directory
//property ID
#define SAMPLEKSP_IMPL_TYPE_PROPERTY      1
#define SAMPLEKSP_MAX_NAME_LEN_PROPERTY   2
#define SAMPLEKSP_NAME_PROPERTY           3
#define SAMPLEKSP_VERSION_PROPERTY        4
#define SAMPLEKSP_SECURITY_DESCR_SUPPORT_PROPERTY     5
#define SAMPLEKSP_ALGORITHM_PROPERTY      6
#define SAMPLEKSP_BLOCK_LENGTH_PROPERTY   7
#define SAMPLEKSP_EXPORT_POLICY_PROPERTY  8
#define SAMPLEKSP_KEY_USAGE_PROPERTY      9
#define SAMPLEKSP_KEY_TYPE_PROPERTY       10
#define SAMPLEKSP_LENGTH_PROPERTY         11
#define SAMPLEKSP_LENGTHS_PROPERTY        12
#define SAMPLEKSP_SECURITY_DESCR_PROPERTY 13
#define SAMPLEKSP_ALGORITHM_GROUP_PROPERTY 14
#define SAMPLEKSP_USE_CONTEXT_PROPERTY    15
#define SAMPLEKSP_UNIQUE_NAME_PROPERTY    16
#define SAMPLEKSP_UI_POLICY_PROPERTY      17
#define SAMPLEKSP_WINDOW_HANDLE_PROPERTY  18
//const
#define MAXUSHORT   0xffff
#define MAX_NUM_PROPERTIES  100


//error handling
#ifndef NT_SUCCESS
#define NT_SUCCESS(status) (status >= 0)
#endif

#ifndef STATUS_SUCCESS
#define STATUS_SUCCESS                  ((NTSTATUS)0x00000000L)
#define STATUS_NOT_SUPPORTED            ((NTSTATUS)0xC00000BBL)
#define STATUS_BUFFER_TOO_SMALL         ((NTSTATUS)0xC0000023L)
#define STATUS_INSUFFICIENT_RESOURCES   ((NTSTATUS)0xC000009AL)
#define STATUS_INTERNAL_ERROR           ((NTSTATUS)0xC00000E5L)
#define STATUS_INVALID_SIGNATURE        ((NTSTATUS)0xC000A000L)
#endif

#ifndef STATUS_INVALID_PARAMETER
#define STATUS_INVALID_PARAMETER         ((NTSTATUS)0xC000000DL)
#endif

//provider handle
typedef __struct_bcount(sizeof(SAMPLEKSP_PROVIDER)) struct _SAMPLEKSP_PROVIDER
{
    DWORD               cbLength;   //length of the whole data struct
    DWORD               dwMagic;    //type of the provider
    DWORD               dwFlags;    //reserved flags
    LPWSTR              pszName;    //name of the KSP
    BCRYPT_ALG_HANDLE   hRsaAlgorithm;    //bcrypt rsa algorithm handle
    LPWSTR              pszContext;       //context
}SAMPLEKSP_PROVIDER;

//property struct stored in the key file
typedef __struct_bcount(sizeof(SAMPLEKSP_NAMED_PROPERTY) +cbPropertyName+cbPropertyData) struct _SAMPLEKSP_NAMED_PROPERTY
{
    DWORD cbLength;         //length of the whole data blob
    DWORD cbPropertyName;   //length of the property name
    DWORD cbPropertyData;   //length of the property data
    BOOL  fBuildin;         //Whether it is a build-in property or not
    // property name
    // property data
} SAMPLEKSP_NAMED_PROPERTY;

//property struct in the key handle
typedef __struct_bcount(sizeof(SAMPLEKSP_PROPERTY) + cbPropertyData) struct _SAMPLEKSP_PROPERTY
{
    DWORD               cbLength;         //length of the whole data blob
    BOOL                fPersisted;       //is this a persisted property
    WCHAR               szName[NCRYPT_MAX_PROPERTY_NAME + 1];   //name of the property
    DWORD               cbPropertyData;                         //property data
    LIST_ENTRY          ListEntry;                              //ListEntry node
    BOOL                fBuildin;         //whether it is a build-in property or not
    // property data
} SAMPLEKSP_PROPERTY;

//key file header stored in the key file
typedef __struct_bcount(sizeof(SAMPLEKSP_KEYFILE_HEADER)+cbProperties+cbPrivateKey) struct _SAMPLEKSP_KEYFILE_HEADER
{
    DWORD cbLength;         //length of the whole data blob
    DWORD dwVersion;        //the version of the key
    DWORD dwAlgorithm;      //Algorithm ID

    DWORD cbProperties;     //length of the properties
    DWORD cbPrivateKey;     //length of the private key
    DWORD cbName;           //length of the key name

    //properties data
    //private key
    //name of the key
} SAMPLEKSP_KEYFILE_HEADER;

//key handle
typedef __struct_bcount(sizeof(SAMPLEKSP_KEY)) struct _SAMPLEKSP_KEY
{
    DWORD               cbLength;           //length of the whole data blob
    DWORD               dwMagic;            //type of the key
    LPWSTR              pszKeyName;         //name of the key (key file)
    LPWSTR              pszKeyFilePath;     //path of the key file
    LPWSTR              pszKeyBlobType;     //BCRYPT_RSAPRIVATE_BLOB or BCRYPT_RSAFULLPRIVATE_BLOB
    DWORD               dwAlgID;            //Algorithm ID
    DWORD               dwKeyBitLength;     //length of the key
    DWORD               dwExportPolicy;     //export policy
    DWORD               dwKeyUsagePolicy;   //key usage policy
    BOOL                fFinished;          //Whether the key is finalized

    //key file header
    __field_bcount(cbKeyFile) PBYTE               pbKeyFile;
    DWORD               cbKeyFile;

    //encrypted private key blob
    __field_bcount(cbPrivateKey) PBYTE               pbPrivateKey;
    DWORD               cbPrivateKey;

    // handle to cryptography providers needed to perform operations with
    // the key.
    BCRYPT_ALG_HANDLE   hProvider;

    // handle to key objects.
    BCRYPT_KEY_HANDLE   hPublicKey;
    BCRYPT_KEY_HANDLE   hPrivateKey;

    // security descriptor to be set on the private key file.
    DWORD               dwSecurityFlags;
    __field_bcount(cbSecurityDescr) PBYTE               pbSecurityDescr;
    DWORD               cbSecurityDescr;

    //context
    LPWSTR              pszContext;

    // list of properties.
    LIST_ENTRY          PropertyList;

    // multi-read/single write lock can be added here to support synchronization for multi-threading
} SAMPLEKSP_KEY;

//enum state used in enum keys and enum providers
typedef struct _SAMPLEKSP_ENUM_STATE
{
    DWORD  dwIndex;
    HANDLE hFind;
    LPWSTR pszPath;
} SAMPLEKSP_ENUM_STATE;

//list of buffer allocated for enum keys / enum providers
typedef struct _SAMPLEKSP_MEMORY_BUFFER
{
    PVOID pvBuffer;
    LIST_ENTRY List;
} SAMPLEKSP_MEMORY_BUFFER;

//this algorithm handle can be shared by all key handles
static BCRYPT_ALG_HANDLE g_hRSAProvider;

NTSTATUS
WINAPI
GetKeyStorageInterface(
    __in   LPCWSTR pszProviderName,
    __out  NCRYPT_KEY_STORAGE_FUNCTION_TABLE **ppFunctionTable,
    __in   DWORD dwFlags);


SECURITY_STATUS
WINAPI
SampleKSPOpenProvider(
    __out   NCRYPT_PROV_HANDLE *phProvider,
    __in    LPCWSTR pszProviderName,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPFreeProvider(
    __in    NCRYPT_PROV_HANDLE hProvider);

SECURITY_STATUS
WINAPI
SampleKSPOpenKey(
    __inout NCRYPT_PROV_HANDLE hProvider,
    __out   NCRYPT_KEY_HANDLE *phKey,
    __in    LPCWSTR pszKeyName,
    __in_opt DWORD  dwLegacyKeySpec,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPCreatePersistedKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __out   NCRYPT_KEY_HANDLE *phKey,
    __in    LPCWSTR pszAlgId,
    __in_opt LPCWSTR pszKeyName,
    __in    DWORD   dwLegacyKeySpec,
    __in    DWORD   dwFlags);

__success(return == 0)
SECURITY_STATUS
WINAPI
SampleKSPGetProviderProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags);

__success(return == 0)
SECURITY_STATUS
WINAPI
SampleKSPGetKeyProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPSetProviderProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    LPCWSTR pszProperty,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPSetKeyProperty(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR pszProperty,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPFinalizeKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPDeleteKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __inout NCRYPT_KEY_HANDLE hKey,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPFreeKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey);

SECURITY_STATUS
WINAPI
SampleKSPFreeBuffer(
    __deref PVOID   pvInput);

__success(return == 0)
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
    __in    DWORD   dwFlags);

__success(return == 0)
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
    __in    DWORD   dwFlags);


SECURITY_STATUS
WINAPI
SampleKSPIsAlgSupported(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    LPCWSTR pszAlgId,
    __in    DWORD   dwFlags);


SECURITY_STATUS
WINAPI
SampleKSPEnumAlgorithms(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    DWORD   dwAlgOperations, // this is the crypto operations that are to be enumerated
    __out   DWORD * pdwAlgCount,
    __deref_out_ecount(*pdwAlgCount) NCryptAlgorithmName **ppAlgList,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPEnumKeys(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in_opt LPCWSTR pszScope,
    __deref_out NCryptKeyName **ppKeyName,
    __inout PVOID * ppEnumState,
    __in    DWORD   dwFlags);

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
    __in    DWORD   dwFlags);

__success(return == 0)
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
    __in    DWORD   dwFlags);

__success(return == 0)
SECURITY_STATUS
WINAPI
SampleKSPSignHash(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in_opt    VOID  *pPaddingInfo,
    __in_bcount(cbHashValue) PBYTE pbHashValue,
    __in    DWORD   cbHashValue,
    __out_bcount_part_opt(cbSignature, *pcbResult) PBYTE pbSignature,
    __in    DWORD   cbSignature,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPVerifySignature(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in_opt    VOID *pPaddingInfo,
    __in_bcount(cbHashValue) PBYTE pbHashValue,
    __in    DWORD   cbHashValue,
    __in_bcount(cbSignature) PBYTE pbSignature,
    __in    DWORD   cbSignature,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPPromptUser(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in_opt NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR  pszOperation,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPNotifyChangeKey(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __inout HANDLE *phEvent,
    __in    DWORD   dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPSecretAgreement(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_KEY_HANDLE hPrivKey,
    __in    NCRYPT_KEY_HANDLE hPubKey,
    __out   NCRYPT_SECRET_HANDLE *phAgreedSecret,
    __in    DWORD   dwFlags);


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
    __in        ULONG                dwFlags);

SECURITY_STATUS
WINAPI
SampleKSPFreeSecret(
    __in    NCRYPT_PROV_HANDLE hProvider,
    __in    NCRYPT_SECRET_HANDLE hSharedSecret);

SECURITY_STATUS
WINAPI
CreateNewKeyObject(
    __in_opt LPCWSTR pszKeyName,
    __deref_out SAMPLEKSP_KEY **ppKey);

SECURITY_STATUS
WINAPI
DeleteKeyObject(
     __inout SAMPLEKSP_KEY *pKey);

DWORD
ProtectPrivateKey(
    __in SAMPLEKSP_KEY *pKey,
    __deref_out PBYTE *ppbEncPrivateKey,
    __out DWORD *pcbEncPrivateKey);

HRESULT
GetSampleKeyStorageArea(
    __deref_out LPWSTR *ppwszKeyFilePath);

SECURITY_STATUS
ValidateKeyFileExistence(
    __in SAMPLEKSP_KEY* pKey);

SECURITY_STATUS
RemoveKeyFromStore(
    __in SAMPLEKSP_KEY *pKey);

SECURITY_STATUS
ReadKeyNameFromFile(
    __in LPWSTR  pszKeyStorageArea,
    __in LPWSTR  pszFileName,
    __deref_out NCryptKeyName **ppKeyName);

SECURITY_STATUS
ReadKeyFile(
    __inout SAMPLEKSP_KEY *pKey);

SECURITY_STATUS
WriteKeyToStore(
    __inout SAMPLEKSP_KEY *pKey
    );

SECURITY_STATUS
ParseKeyFile(
    __inout SAMPLEKSP_KEY *pKey);

SECURITY_STATUS
GetSecurityOnKeyFile(
    __in    SAMPLEKSP_KEY *pKey,
    __in    DWORD   dwSecurityFlags,
    __deref_out_bcount(*pcbSecurityDescr) PSECURITY_DESCRIPTOR *ppSecurityDescr,
    __out   DWORD * pcbSecurityDescr);

SECURITY_STATUS
SampleKspImportPKCS7Blob(
    __in    SAMPLEKSP_PROVIDER *pProvider,
    __in    SAMPLEKSP_KEY **ppKey,
    __in_opt NCryptBufferDesc *pParameterList,
    __in_bcount(cbData) PBYTE pbData,
    __in    DWORD   cbData,
    __in    DWORD   dwFlags);

__success(return == 0)
SECURITY_STATUS
SampleKspExportPKCS7Blob(
    __in     SAMPLEKSP_KEY *pKey,
    __in_opt NCryptBufferDesc *pParameterList,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult);

SECURITY_STATUS
SampleKspImportPKCS8Blob (
    __in NCRYPT_PROV_HANDLE hProv,
    __deref_out SAMPLEKSP_KEY** ppKey,
    __in_opt NCryptBufferDesc const* pImportParamList,
    __in_bcount (cbIn) BYTE const* pbIn,
    __in DWORD cbIn,
    __in DWORD dwFlags);

SECURITY_STATUS
SampleKspExportPKCS8Blob (
    __in SAMPLEKSP_KEY const* pKey,
    __in_opt NCryptBufferDesc const* pExportParamList,
    __out_bcount_part_opt (cbOut, *pcbResult) BYTE* pbOut,
    __in DWORD cbOut,
    __out DWORD* pcbResult);

SECURITY_STATUS
ReadKeyNameFromParams(
    __in_opt NCryptBufferDesc const* pParamList,
    __out LPWSTR* pszKeyName);

BOOL
IsPkcs8KeyExportable(
    __in SAMPLEKSP_KEY const* pKey,
    __in_opt NCryptBufferDesc const* pExportParamList);

SECURITY_STATUS
NormalizeNteStatus(
    __in NTSTATUS NtStatus);

SAMPLEKSP_PROVIDER *
SampleKspValidateProvHandle(
    __in    NCRYPT_PROV_HANDLE hProvider);

SAMPLEKSP_KEY *
SampleKspValidateKeyHandle(
    __in    NCRYPT_KEY_HANDLE hKey);

SECURITY_STATUS
CreateNewProperty(
    __in_opt                LPCWSTR pszProperty,
    __in_bcount(cbProperty) PBYTE   pbProperty,
    __in                    DWORD   cbProperty,
    __in                    DWORD   dwFlags,
    __deref_out             SAMPLEKSP_PROPERTY    **ppProperty);

SECURITY_STATUS
SetBuildinKeyProperty(
    __inout     SAMPLEKSP_KEY  *pKey,
    __in        LPCWSTR pszProperty,
    __in_bcount(cbInput)    PBYTE pbInput,
    __in                    DWORD   cbInput,
    __inout    DWORD*   dwFlags);

SECURITY_STATUS
ProtectAndSetPrivateKey(
    __in LPCWSTR pszBlobType,
    __in_bcount(cbKeyBlob) PBYTE  pbKeyBlob,
    __in DWORD  cbKeyBlob,
    __inout SAMPLEKSP_KEY* pKey);

SECURITY_STATUS
AllocAndGetRsaPrivateKeyBlob(
    __inout SAMPLEKSP_KEY *pKey,
    __in    LPCWSTR pszExportBlobType,
    __deref_out_bcount(*cbCngKeyBlob) PBYTE *pbCngKeyBlob,
    __out DWORD *cbCngKeyBlob);

HRESULT
ImportRsaKeyPair(
    __inout SAMPLEKSP_KEY *pKey);

SECURITY_STATUS
FinalizeKey(
    __inout SAMPLEKSP_KEY *pKey);

SAMPLEKSP_MEMORY_BUFFER *
RemoveMemoryBuffer(
    __in LIST_ENTRY *pBufferList,
    __in PVOID pvBuffer);

SAMPLEKSP_MEMORY_BUFFER *
LookupMemoryBuffer(
    __in LIST_ENTRY *pBufferList,
    __in PVOID pvBuffer);

SECURITY_STATUS
LookupExistingKeyProperty(
    __in    SAMPLEKSP_KEY *pKey,
    __in    LPCWSTR pszProperty,
    __out   SAMPLEKSP_PROPERTY **ppProperty);

SECURITY_STATUS
CreateNewProperty(
    __in_opt                LPCWSTR pszProperty,
    __in_bcount(cbProperty) PBYTE   pbProperty,
    __in                    DWORD   cbProperty,
    __in                    DWORD   dwFlags,
    __deref_out             SAMPLEKSP_PROPERTY    **ppProperty);

SECURITY_STATUS
FindFirstKeyFile(
    __out PVOID *ppEnumState,
    __deref_out NCryptKeyName **ppKeyName);

SECURITY_STATUS
FindNextKeyFile(
    __inout PVOID pEnumState,
    __deref_out NCryptKeyName **ppKeyName);

//macro for list operation
#define InitializeListHead(ListHead) (\
    (ListHead)->Flink = (ListHead)->Blink = (ListHead))

#define RemoveHeadList(ListHead) \
    (ListHead)->Flink;\
    {RemoveEntryList((ListHead)->Flink)}

#define RemoveEntryList(Entry) {\
    PLIST_ENTRY _EX_Blink;\
    PLIST_ENTRY _EX_Flink;\
    _EX_Flink = (Entry)->Flink;\
    _EX_Blink = (Entry)->Blink;\
    _EX_Blink->Flink = _EX_Flink;\
    _EX_Flink->Blink = _EX_Blink;\
    }

#define InsertTailList(ListHead,Entry) {\
    PLIST_ENTRY _EX_Blink;\
    PLIST_ENTRY _EX_ListHead;\
    _EX_ListHead = (ListHead);\
    _EX_Blink = _EX_ListHead->Blink;\
    (Entry)->Flink = _EX_ListHead;\
    (Entry)->Blink = _EX_Blink;\
    _EX_Blink->Flink = (Entry);\
    _EX_ListHead->Blink = (Entry);\
    }

#endif //__SAMPLE_KSP_H__
