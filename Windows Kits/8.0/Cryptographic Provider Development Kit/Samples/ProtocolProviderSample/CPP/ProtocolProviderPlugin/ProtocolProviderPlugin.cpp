// ProtocolProviderPlugin.cpp : Defines the entry point for the DLL application.
//
/** @file ProtocolProviderPlugin.cpp
  * @brief Contains the implementation of the functions 
  *		   SslOpenProvider, SslLookupCipherSuiteInfo, and SslEnumCipherSuites
  *		   Also contains stubs for unsupported functions.
**/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	UNREFERENCED_PARAMETER(lpReserved);
	UNREFERENCED_PARAMETER(hModule);

	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
    return TRUE;
}



///////////////////////////////////////////////////////////////////////////
///////////  Protocol Provider Function Implementations  //////////////////
///////////////////////////////////////////////////////////////////////////


/** @function SslOpenProvider
  * @brief Allocates memory for a protocol provider and returns a 
  *        handle (i.e. pointer) to the specified protocol provider
  *
  *		   Creates my protocol provider structure. Opens ncrypt provider for keys.
  *		   Opens bcrypt provider for hashes and other crypto.
  *
  *
  * @param phSslProvider: Will write the handle pointer created into this parameter
  * @param pszProviderName: The name of the protocol provider to open.
  * @param dwFlags: Not Supported
  *
  * @return ERROR_SUCCESS: On success.
  **/
SECURITY_STATUS
WINAPI
SslOpenProvider(
    __out   NCRYPT_PROV_HANDLE *phSslProvider,
    __in    LPCWSTR pszProviderName,
    __in    DWORD   dwFlags)
{
	SECURITY_STATUS Status;

	// Validate params
	if(!pszProviderName || (wcscmp(pszProviderName, PROTOCOL_PROVIDER_NAME) != 0)) return NTE_INVALID_PARAMETER;
	if(dwFlags != 0) return NTE_BAD_FLAGS;

	// Allocate memory for the custom protocol provider structure
	P_CUSTOM_PROTOCOL_PROVIDER pbProvider = (P_CUSTOM_PROTOCOL_PROVIDER)MALLOC(sizeof(CUSTOM_PROTOCOL_PROVIDER));
	if(pbProvider == NULL) return NTE_NO_MEMORY;
	pbProvider->cbLength = sizeof(CUSTOM_PROTOCOL_PROVIDER);
	pbProvider->dwHandleType = TYPE_CUSTOM_PROTOCOL_PROVIDER;

	// Open and cache NCrypt and BCrypt Providers for CNG operations later
	Status = NCryptOpenStorageProvider(&pbProvider->ncrypt_prov_handle, MS_KEY_STORAGE_PROVIDER, 0);
	CHECK_STATUS(Status)

	Status = BCryptOpenAlgorithmProvider(&pbProvider->md5_alg_handle, BCRYPT_MD5_ALGORITHM, NULL, 0); 
	CHECK_STATUS(Status)

	Status = BCryptOpenAlgorithmProvider(&pbProvider->sha1_alg_handle, BCRYPT_SHA1_ALGORITHM, NULL, 0); 
	CHECK_STATUS(Status)

	Status = BCryptOpenAlgorithmProvider(&pbProvider->md5_hmac_alg_handle, BCRYPT_MD5_ALGORITHM, NULL, BCRYPT_ALG_HANDLE_HMAC_FLAG);
	CHECK_STATUS(Status)

	Status = BCryptOpenAlgorithmProvider(&pbProvider->sha1_hmac_alg_handle, BCRYPT_SHA1_ALGORITHM, NULL, BCRYPT_ALG_HANDLE_HMAC_FLAG);
	CHECK_STATUS(Status)

	Status = BCryptOpenAlgorithmProvider(&pbProvider->rc2_alg_handle, BCRYPT_RC2_ALGORITHM, NULL, 0);
	CHECK_STATUS(Status);


	// Cache object sizes for hash algorithms
	DWORD cbIgnore;
	Status = BCryptGetProperty(
					pbProvider->md5_alg_handle,
					BCRYPT_OBJECT_LENGTH,
					(PUCHAR)(&pbProvider->md5_obj_length),
					sizeof(DWORD),
					&cbIgnore,
					0); 
	CHECK_STATUS(Status);

	Status = BCryptGetProperty(
					pbProvider->sha1_alg_handle,
					BCRYPT_OBJECT_LENGTH,
					(PUCHAR)(&pbProvider->sha1_obj_length),
					sizeof(DWORD),
					&cbIgnore,
					0); 
	CHECK_STATUS(Status);

	Status = BCryptGetProperty(
					pbProvider->md5_hmac_alg_handle,
					BCRYPT_OBJECT_LENGTH,
					(PUCHAR)(&pbProvider->md5_hmac_obj_length),
					sizeof(DWORD),
					&cbIgnore,
					0); 
	CHECK_STATUS(Status);

	Status = BCryptGetProperty(
					pbProvider->sha1_hmac_alg_handle,
					BCRYPT_OBJECT_LENGTH,
					(PUCHAR)(&pbProvider->sha1_hmac_obj_length),
					sizeof(DWORD),
					&cbIgnore,
					0); 
	CHECK_STATUS(Status);

	Status = BCryptGetProperty(
					pbProvider->rc2_alg_handle,
					BCRYPT_OBJECT_LENGTH,
					(PUCHAR)(&pbProvider->rc2_obj_length),
					sizeof(DWORD),
					&cbIgnore,
					0); 
	CHECK_STATUS(Status);

	pbProvider->rc2_key_obj_length = pbProvider->rc2_obj_length;

	// Return a pointer to the provider struct as the handle
	*phSslProvider = PROVIDER_TO_HANDLE(pbProvider);

	return ERROR_SUCCESS;

cleanup:
	if(pbProvider->ncrypt_prov_handle) {									
		NCryptFreeObject((NCRYPT_HANDLE)pbProvider->ncrypt_prov_handle);
	}																		
	if(pbProvider->md5_alg_handle) {										
		BCryptCloseAlgorithmProvider(pbProvider->md5_alg_handle, NULL);	
	}																	
	if(pbProvider->sha1_alg_handle) {										
		BCryptCloseAlgorithmProvider(pbProvider->sha1_alg_handle, NULL);	
	}
	if(pbProvider->rc2_alg_handle) {										
		BCryptCloseAlgorithmProvider(pbProvider->rc2_alg_handle, NULL);	
	}	
	if(pbProvider->sha1_hmac_alg_handle) {										
		BCryptCloseAlgorithmProvider(pbProvider->sha1_hmac_alg_handle, NULL);	
	}	
	if(pbProvider->md5_hmac_alg_handle) {										
		BCryptCloseAlgorithmProvider(pbProvider->md5_hmac_alg_handle, NULL);	
	}	
	FREE(pbProvider);	
	return Status;		
}


//+-------------------------------------------------------------------------
// SslComputeEapKeyBlock
//
// Computes the key block used by EAP
//     pbRandoms must be client_random + server_random (client random
//     concatenated with the server random).
//--------------------------------------------------------------------------
SECURITY_STATUS
WINAPI
SslComputeEapKeyBlock(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hMasterKey,
    __in_bcount(cbRandoms) PBYTE pbRandoms,
    __in    DWORD   cbRandoms,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{

	UNREFERENCED_PARAMETER(hSslProvider);
	UNREFERENCED_PARAMETER(hMasterKey);
	UNREFERENCED_PARAMETER(pbRandoms);
	UNREFERENCED_PARAMETER(cbRandoms);
	UNREFERENCED_PARAMETER(pbOutput);
	UNREFERENCED_PARAMETER(cbOutput);
	UNREFERENCED_PARAMETER(pcbResult);
	UNREFERENCED_PARAMETER(dwFlags);

	// Unimplemented
	return NTE_NOT_SUPPORTED;
}


SECURITY_STATUS
WINAPI
loadEnumState(ENUM_CIPHER_SUITE_STATE * pEnumState) {
	DWORD i;
	NCRYPT_SSL_CIPHER_SUITE* pCipherSuite;
	
	pEnumState->Index = 0;
	pEnumState->SuiteCount = MAX_CIPHER_SUITE_COUNT;

	for(i = 0; i < MAX_CIPHER_SUITE_COUNT; ++i) {
		pCipherSuite = &pEnumState->SuiteList[i];

		pCipherSuite->dwProtocol			=             TLS1_PROTOCOL_VERSION;                    // = 0x0301
		pCipherSuite->dwCipherSuite			=             CIPHER_SUITE_CODE;						// = 0xFF06
		pCipherSuite->dwBaseCipherSuite     =             BASE_CIPHER_SUITE_CODE;					// = 0x6
		wcscpy_s(pCipherSuite->szCipherSuite, NCRYPT_SSL_MAX_NAME_SIZE, CIPHER_SUITE_NAME);			// = L”TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5”
		wcscpy_s(pCipherSuite->szCipher, NCRYPT_SSL_MAX_NAME_SIZE, BCRYPT_RC2_ALGORITHM);			// = L"RC2"
		pCipherSuite->dwCipherLen           =             CIPHER_BIT_LENGTH;                        // = 40
		pCipherSuite->dwCipherBlockLen      =             BLOCK_LENGTH;                             // = 8
		wcscpy_s(pCipherSuite->szHash, NCRYPT_SSL_MAX_NAME_SIZE, CIPHER_SUITE_HASH);				// = L“MD5”
		pCipherSuite->dwHashLen             =             MD5_LENGTH*BITS_IN_A_BYTE;                // = 16*8 = 128
		wcscpy_s(pCipherSuite->szExchange, NCRYPT_SSL_MAX_NAME_SIZE, BCRYPT_RSA_ALGORITHM);			// = L"RSA"                               
		pCipherSuite->dwMinExchangeLen      =             MIN_EXCHANGE_LEN;							// = 512
		pCipherSuite->dwMaxExchangeLen      =             MAX_EXCHANGE_LEN;							// = 16384
		wcscpy_s(pCipherSuite->szCertificate, NCRYPT_SSL_MAX_NAME_SIZE, BCRYPT_RSA_ALGORITHM);		// = L"RSA"
		pCipherSuite->dwKeyType             =             NULL;										// Used for ECC curve type
		
	}

	return ERROR_SUCCESS;
}

void copyCipherSuite(NCRYPT_SSL_CIPHER_SUITE * pSrc, NCRYPT_SSL_CIPHER_SUITE * pDst) {
	pDst->dwBaseCipherSuite = pSrc->dwBaseCipherSuite;
	pDst->dwCipherBlockLen  = pSrc->dwCipherBlockLen;
	pDst->dwCipherLen		= pSrc->dwCipherLen;
	pDst->dwCipherSuite		= pSrc->dwBaseCipherSuite;
	pDst->dwHashLen			= pSrc->dwHashLen;
	pDst->dwKeyType			= pSrc->dwKeyType;
	pDst->dwMaxExchangeLen	= pSrc->dwMaxExchangeLen;
	pDst->dwMinExchangeLen	= pSrc->dwMinExchangeLen;
	pDst->dwProtocol		= pSrc->dwProtocol;

	wcscpy_s(pDst->szCertificate, NCRYPT_SSL_MAX_NAME_SIZE ,pSrc->szCertificate);
	wcscpy_s(pDst->szCipher,      NCRYPT_SSL_MAX_NAME_SIZE, pSrc->szCipher);
	wcscpy_s(pDst->szCipherSuite, NCRYPT_SSL_MAX_NAME_SIZE, pSrc->szCipherSuite);
	wcscpy_s(pDst->szExchange,    NCRYPT_SSL_MAX_NAME_SIZE, pSrc->szExchange);
	wcscpy_s(pDst->szHash,        NCRYPT_SSL_MAX_NAME_SIZE, pSrc->szHash);
}


/** @function SslEnumCipherSuites
  * @brief  This function is used to enumerate the list of cipher suites supported 
  *			by an SSL protocol provider. If a private key handle is specified, then
  *			this function will only return cipher suites that are compatible with
  *			the private key.
  *
  * @param hSslProvider: Handle to the Protocol Provider being used.
  * @param hPrivateKey: Handle to the optional private key which will 
  *						restrict the cipher suites being enumerated.
  * @param ppCipherSuite: SslEnumCipherSuites will write the address of the next cipher suite in the list into this address.
  * @param ppEnumState: Should point to NULL the first time SslEnumCipherSuites is called. SslEnumCipherSuites
  *						will utilize this address to keep track of where it is in the list of cipher suites it
  *						is enumerating, as such, the caller should pass the pointer back into SslEnumCipherSuites
  *						without modifying it until SslEnumCipherSuites returns NTE_NO_MORE_ITEMS, at which time the
  *						caller should free ppEnumState with a call to SslFreeBuffer.
  * @param dwFlags: Not Used.
  **/
SECURITY_STATUS
WINAPI
SslEnumCipherSuites(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in_opt NCRYPT_KEY_HANDLE hPrivateKey,
    __deref_out NCRYPT_SSL_CIPHER_SUITE **ppCipherSuite,
    __inout PVOID * ppEnumState,
    __in    DWORD   dwFlags)
{
	SECURITY_STATUS Status;
	ENUM_CIPHER_SUITE_STATE* pEnumState; // Use to keep track of where in the cipher suite list you are

	// Validate Parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

	if(hPrivateKey != NULL) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}

	CHECK_POINTER(ppCipherSuite);
	CHECK_POINTER(ppEnumState);

	if(dwFlags != 0) {
		Status = NTE_BAD_FLAGS;
		CHECK_STATUS(Status);
	}

	pEnumState = (ENUM_CIPHER_SUITE_STATE*)*ppEnumState;

	// If this is the initial call (and thus we should enumerate from the beginning of the list)
	// Allocate and load the enum state.
	if(!pEnumState) {
		pEnumState = (ENUM_CIPHER_SUITE_STATE*)MALLOC(sizeof(ENUM_CIPHER_SUITE_STATE));
		CHECK_POINTER(pEnumState);
		loadEnumState(pEnumState);
	}

	// Check if we have enumerated all of the cipher suites
	if(pEnumState->Index == pEnumState->SuiteCount) {
		return NTE_NO_MORE_ITEMS;
	}

	// Create a new NCRYPT_SSL_CIPHER_SUITE that will contain the next cipher suite in the enumeration
	NCRYPT_SSL_CIPHER_SUITE * pCipherSuite = (NCRYPT_SSL_CIPHER_SUITE*)MALLOC(sizeof(NCRYPT_SSL_CIPHER_SUITE));
	CHECK_POINTER(pCipherSuite);

	// Load the cipher suite info
	copyCipherSuite(&pEnumState->SuiteList[pEnumState->Index], pCipherSuite);
	
	*ppCipherSuite = pCipherSuite;

	pEnumState->Index++;

	*ppEnumState = pEnumState;

	return ERROR_SUCCESS;
cleanup:
	return Status;
}


/** @function SslGetProviderProperty
  * @brief Deprecated.
  *
  * @return NTE_NOT_SUPPORTED
  **/
SECURITY_STATUS
WINAPI
SslGetProviderProperty(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    LPCWSTR pszProperty,
    __deref_out_bcount(*pcbOutput) PBYTE *ppbOutput,
    __out   DWORD * pcbOutput,
    __inout_opt PVOID *ppEnumState,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(hSslProvider);
	UNREFERENCED_PARAMETER(pszProperty);
	UNREFERENCED_PARAMETER(ppbOutput);
	UNREFERENCED_PARAMETER(pcbOutput);
	UNREFERENCED_PARAMETER(ppEnumState);
	UNREFERENCED_PARAMETER(dwFlags);


	// Not Supported
	return NTE_NOT_SUPPORTED;
}


/** @function SslLookupCipherSuiteInfo
  * @brief  Looks up cipher suite information given the suite number and a key type. 
  *			The information is obtained via SslLookupCipher writing the information 
  *			specific to the cipher suite into the structure NCRYPT_SSL_CIPHER_SUITE
  *			pointed to by pCipherSuite.
  *
  * @param hSslProvider: The handle to the protocol provider being used.
  * @param dwProtocol: The protocol being used for this connection (Should always be TLS for this case)
  * @param dwCipherSuite: Which cipher suite to look up. (There is only 1 in this case)
  * @param dwKeyType: The ECC curve type. (Will always be NULL since this cipher suite is non-ECC)
  * @param pCipherSuite: This should point to valid memory where SslLookupCipherSuiteInfo will write the 
  *						 cipher suite into the NCRYPT_SSL_CIPHER_SUITE structure.
  * @param dwFlags: Not Used.
  **/
SECURITY_STATUS
WINAPI
SslLookupCipherSuiteInfo(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    DWORD dwProtocol,
    __in    DWORD dwCipherSuite,
    __in    DWORD dwKeyType,
    __out   NCRYPT_SSL_CIPHER_SUITE *pCipherSuite,
    __in    DWORD   dwFlags)
{
	SECURITY_STATUS Status;

	UNREFERENCED_PARAMETER(dwFlags);

	Status = validateProviderHandle(hSslProvider);
	if(dwCipherSuite != BASE_CIPHER_SUITE_CODE) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}
	if(dwKeyType != 0) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}
	CHECK_POINTER(pCipherSuite);

	pCipherSuite->dwProtocol			=             dwProtocol;								// = 0x0301
    pCipherSuite->dwCipherSuite			=             CIPHER_SUITE_CODE;						// = 0xFF06
    pCipherSuite->dwBaseCipherSuite     =             BASE_CIPHER_SUITE_CODE;					// = 0x6
    wcscpy_s(pCipherSuite->szCipherSuite, NCRYPT_SSL_MAX_NAME_SIZE, CIPHER_SUITE_NAME);			// = L”TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5”
    wcscpy_s(pCipherSuite->szCipher, NCRYPT_SSL_MAX_NAME_SIZE, BCRYPT_RC2_ALGORITHM);			// = L"RC2"
    pCipherSuite->dwCipherLen           =             CIPHER_BIT_LENGTH;                        // = 40
    pCipherSuite->dwCipherBlockLen      =             BLOCK_LENGTH;                             // = 16
    wcscpy_s(pCipherSuite->szHash, NCRYPT_SSL_MAX_NAME_SIZE, CIPHER_SUITE_HASH);				// = L“MD5”
    pCipherSuite->dwHashLen             =             MD5_LENGTH*BITS_IN_A_BYTE;                // = 16*8 = 128
    wcscpy_s(pCipherSuite->szExchange, NCRYPT_SSL_MAX_NAME_SIZE, BCRYPT_RSA_ALGORITHM);			// = L"RSA"                               
    pCipherSuite->dwMinExchangeLen      =             MIN_EXCHANGE_LEN;							// = 512
    pCipherSuite->dwMaxExchangeLen      =             MAX_EXCHANGE_LEN;							// = 16384
    wcscpy_s(pCipherSuite->szCertificate, NCRYPT_SSL_MAX_NAME_SIZE, BCRYPT_RSA_ALGORITHM);		// = L"RSA"
    pCipherSuite->dwKeyType             =             NULL;										// Used for ECC curve type

	return ERROR_SUCCESS;
cleanup:
	return Status;
}

