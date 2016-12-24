/** @file Keys.cpp
  * @brief Contains the implementation of the functions 
  *		   SslOpenPrivateKey, SslGetKeyProperty, SslCreateEphemeralKey, SslImportKey, and SslExportKey
**/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"
#include "MasterKey.h"

/** @function SslOpenPrivateKey
  * @brief Server side function that obtains a handle to a private key.  
  *		   The private key is part of a public-private key pair within the certificate. 
  *		   This function merely extracts the private key from the passed in certificate.
  *
  * @param hSslProvider: A handle to a protocol provider.
  * @param phPrivateKey: Variable in which to write the handle to the private key.
  * @param pCertContext: The certificate from which to obtain the private key.
  * @param dwFlags: Not Used.
  *
  * @return ERROR_SUCCESS: On success.
  * @return NTE_FAIL: On failure.
  **/
SECURITY_STATUS
WINAPI
SslOpenPrivateKey(
    __in   NCRYPT_PROV_HANDLE hSslProvider,
    __out  NCRYPT_KEY_HANDLE *phPrivateKey,
    __in   PCCERT_CONTEXT pCertContext,
    __in   DWORD dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	SECURITY_STATUS Status;
	P_KEY_OBJECT pKeyObj = NULL;

	// Declare buffers for CryptAcquireCertificatePrivateKey to write to
	DWORD  dwKeySpec = NULL;
	BOOL   fCallerFreeProvOrNCryptKey = FALSE;

        CHECK_POINTER(phPrivateKey);
	
	// Create a new key object
	pKeyObj = newKeyObject();
	CHECK_POINTER(pKeyObj);

	// Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);


	// Get the handle for the private key from the certificate
	if(!CryptAcquireCertificatePrivateKey(
			pCertContext,							
			CRYPT_ACQUIRE_ONLY_NCRYPT_KEY_FLAG,		
			NULL,									
			&pKeyObj->ncrypt_key_handle,			
			&dwKeySpec,							
			&fCallerFreeProvOrNCryptKey)){			
													
			Status = NTE_FAIL;
			CHECK_STATUS(Status);
	}

	// Ensure that it is the correct type of key
	if(dwKeySpec != CERT_NCRYPT_KEY_SPEC) {
		Status = NTE_FAIL;
		CHECK_STATUS(Status);
	}

	// Actually write the key handle to the caller
	*phPrivateKey = KEY_TO_HANDLE(pKeyObj);

	return ERROR_SUCCESS;
cleanup:
	if(pKeyObj) { FREE(pKeyObj); }
	return Status;
}


/** @function SslCreateEphemeralKey
  * @brief Obtains an ephemeral key handle. This implementation does not support DH ephemeral keys.
  *
  * @param hSslProvider:	Handle to the protocol provider instance
  * @param phEphemeralKey:	Where the created ephemeral key will be written
  * @param dwProtocol:		The protocol to create a key for. This implementation will always use TLS
  * @param dwCipherSuite:	Which cipher suite to use.
  * @param dwKeyType:		Not used (Implementations using a DH cipher suite may use this)
  * @param dwKeyBitLen:		Used to specify the key's bit length
  * @param pbParams:		Not used (Implementations using a DH cipher suite may use this)
  * @param cbParams:		Not used (Implementations using a DH cipher suite may use this)
  * @param dwFlags:			Not used
  **/
SECURITY_STATUS
WINAPI
SslCreateEphemeralKey(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __out   NCRYPT_KEY_HANDLE *phEphemeralKey,
    __in    DWORD   dwProtocol,
    __in    DWORD   dwCipherSuite,
    __in    DWORD   dwKeyType,
    __in    DWORD   dwKeyBitLen,
    __in_bcount_opt(cbParams) PBYTE pbParams,
    __in    DWORD   cbParams,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwKeyType);
	UNREFERENCED_PARAMETER(pbParams);
	UNREFERENCED_PARAMETER(cbParams);
	UNREFERENCED_PARAMETER(dwFlags);
	
	SECURITY_STATUS Status;
	P_KEY_OBJECT pKeyObj = NULL;

	// Validate parameters
	CHECK_POINTER(phEphemeralKey);

	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);
	if(dwProtocol != TLS1_PROTOCOL_VERSION) {
		return NTE_INVALID_PARAMETER;
	}
	if(dwCipherSuite != BASE_CIPHER_SUITE_CODE) {
		return NTE_INVALID_PARAMETER;
	}

	// Convert handle to the custom provider structure pointer
	P_CUSTOM_PROTOCOL_PROVIDER pCustomProvider = HANDLE_TO_PROVIDER(hSslProvider);
	
	// Create a new key object
	pKeyObj = newKeyObject();
	CHECK_POINTER(pKeyObj);

	// Execute the 3 NCrypt functions necessary to create the ephemeral key
	Status = NCryptCreatePersistedKey(
				pCustomProvider->ncrypt_prov_handle,
				&pKeyObj->ncrypt_key_handle,
				CIPHER_SUITE_NAME,
				NULL, // indicates that the key is ephemeral and should not persisted
				NULL,
				NULL);
	CHECK_STATUS(Status)
	
	Status = NCryptSetProperty(
				pKeyObj->ncrypt_key_handle,
                NCRYPT_LENGTH_PROPERTY,
                (BYTE*)&dwKeyBitLen,
                sizeof(dwKeyBitLen),
                0);
    CHECK_STATUS(Status)

	Status = NCryptFinalizeKey(
                pKeyObj->ncrypt_key_handle,
                0);
    CHECK_STATUS(Status)
	

	// Write the new key to a handle for the caller
	*phEphemeralKey = KEY_TO_HANDLE(pKeyObj);

	return ERROR_SUCCESS;

cleanup:										
		if(pKeyObj) {						
			if(pKeyObj->ncrypt_key_handle) {									
				NCryptFreeObject((NCRYPT_HANDLE)pKeyObj->ncrypt_key_handle);	
			}																	
			FREE(pKeyObj);														
		}																		
		return Status;														
}

/** @function SslExportKey
  * @brief Exports an SSL session key or public ephemeral key into a serialized blob.
  *
  * @param hSslProvider: The handle to the protocol provider instance
  * @param hKey: The handle to the key which is being exported
  * @param pszBlobType: The type of blob the key will be exported as
  * @param pbOutput: Where the BLOB will be written to
  * @param cbOutput: The length of the buffer
  * @param pcbResult: SslExportKey will write the number of bytes actually written into the buffer
  * @param dwFlags: Not used
  *
  * @return ERROR_SUCCESS on success.
  **/
SECURITY_STATUS
WINAPI
SslExportKey(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR pszBlobType,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);
	SECURITY_STATUS Status;
	P_KEY_OBJECT pKeyObj = NULL;
	P_SESSION_KEY_OBJECT pKey = NULL;
	DWORD cbResult = 0;


	// Validate Parameters
	CHECK_POINTER(pcbResult);

	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);
	if(!pszBlobType ||
	     !(
		 	(wcscmp(pszBlobType, BCRYPT_OPAQUE_KEY_BLOB) == 0) ||
			(wcscmp(pszBlobType, LEGACY_RSAPUBLIC_BLOB) == 0) ||
			(wcscmp(pszBlobType, BCRYPT_RSAPUBLIC_BLOB) == 0)
		  )
		){
			Status = NTE_INVALID_PARAMETER;
			CHECK_STATUS(Status);
	}

	// If BCRYPT_OPAQUE_KEY_BLOB is blob type use BCrypt else use NCrypt
	if(wcscmp(pszBlobType, BCRYPT_OPAQUE_KEY_BLOB) == 0) {
		Status = validateSessionKey(hKey); 
		CHECK_STATUS(Status);

		pKey = HANDLE_TO_SESSION_KEY(hKey);

		// If pbOutput is NULL then return the minimum buffer length SslExportKey requires
		if(!pbOutput) {
			Status = BCryptExportKey(
						pKey->bcrypt_key_handle,
						0,
						pszBlobType,
						NULL,
						NULL,
						&cbResult,
						0);
			CHECK_STATUS(Status);

			*pcbResult =  MAC_LENGTH + cbResult;
			return ERROR_SUCCESS;
		}

		if (cbOutput < MAC_LENGTH)
		{
			Status = NTE_INVALID_PARAMETER;
			CHECK_STATUS(Status);
		}
		
		// Get BLOB of the key
		Status = BCryptExportKey(
						pKey->bcrypt_key_handle,
						0,
						pszBlobType,
						pbOutput + MAC_LENGTH,
						cbOutput - MAC_LENGTH,
						&cbResult,
						0);
		if(Status == STATUS_BUFFER_TOO_SMALL) 
		{
			*pcbResult =  MAC_LENGTH + cbResult;
		
			Status = NTE_BUFFER_TOO_SMALL;
			CHECK_STATUS(Status);
		}
		CHECK_STATUS(Status);
		
		// Tack on the MAC to the end of the export key
		memcpy(pbOutput, &pKey->pbMac, MAC_LENGTH);
		*pcbResult =  MAC_LENGTH + cbResult;
	} else {
		pKeyObj = HANDLE_TO_KEY(hKey);

		Status = NCryptExportKey(
							pKeyObj->ncrypt_key_handle,
							0,
							pszBlobType,
							NULL,
							pbOutput,
							cbOutput,
							pcbResult,
							0);
		CHECK_STATUS(Status);
	}

	Status = ERROR_SUCCESS;
cleanup:
	return Status;
}


/** @function SslImportKey
  * @brief Imports a public key into the protocol provider, as part of a key
  *		   exchange operation. This function is also used to import session keys, 
  *		   when transferring them from one process to another (i.e. to and from the LSA)
  *
  * @param hSslProvider: The handle to the ssl provider being used
  * @param phKey: Where to write the handle to the key which will be have been imported
  * @param pszBlobType: The specific type of BLOB type the passed in BLOB is.
  * @param pbKeyBlob: The buffer containing the key blob.
  * @param cbKeyBlob: The size of the buffer pointed to by pbKeyBlob.
  * @param dwFlags: Not Used.
  **/
SECURITY_STATUS
WINAPI
SslImportKey(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __out   NCRYPT_KEY_HANDLE *phKey,
    __in    LPCWSTR pszBlobType,
    __in_bcount(cbKeyBlob) PBYTE pbKeyBlob,
    __in    DWORD   cbKeyBlob,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);
	SECURITY_STATUS Status;

	P_KEY_OBJECT pKey = NULL;
	P_SESSION_KEY_OBJECT pSessionKey = NULL;
	
	// Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);
	CHECK_POINTER(phKey);
	if(!pszBlobType ||
	     !(
		 	(wcscmp(pszBlobType, BCRYPT_OPAQUE_KEY_BLOB) == 0) ||
			(wcscmp(pszBlobType, LEGACY_RSAPUBLIC_BLOB) == 0) ||
			(wcscmp(pszBlobType, BCRYPT_RSAPUBLIC_BLOB) == 0)
		  )
		){
			Status = NTE_INVALID_PARAMETER;
			CHECK_STATUS(Status);
	}
	CHECK_POINTER(pbKeyBlob);

	P_CUSTOM_PROTOCOL_PROVIDER pProv = HANDLE_TO_PROVIDER(hSslProvider);
	
	// If it is LEGACY_RSAPUBLIC_BLOB then use NCrypt, else BCrypt
	if(wcscmp(pszBlobType, LEGACY_RSAPUBLIC_BLOB) == 0) {
	
		pKey = newKeyObject();
		CHECK_POINTER(pKey);

		Status = NCryptImportKey(
						pProv->ncrypt_prov_handle,
                        0,
                        pszBlobType,
                        NULL,
						&pKey->ncrypt_key_handle,
                        pbKeyBlob,
                        cbKeyBlob,
                        0);
		CHECK_STATUS(Status);

		*phKey = (NCRYPT_KEY_HANDLE)pKey;

	}else {
		
		pSessionKey = newSessionKey(pProv->rc2_key_obj_length);
		CHECK_POINTER(pSessionKey);

		// Get the MAC key before importing the rest
		memcpy(pSessionKey->pbMac, pbKeyBlob, MAC_LENGTH);
		
		Status = BCryptImportKey(
						pProv->rc2_alg_handle,
						0,
						pszBlobType,
						&pSessionKey->bcrypt_key_handle,
						pSessionKey->pbKeyObjectBuffer,
						pProv->rc2_key_obj_length,
						pbKeyBlob+MAC_LENGTH,
						cbKeyBlob-MAC_LENGTH,
						0);
		CHECK_STATUS(Status);

		*phKey = (NCRYPT_KEY_HANDLE)pSessionKey;
	}
	
	return ERROR_SUCCESS;
cleanup:
	if(pSessionKey) { SslFreeObject((NCRYPT_HANDLE)pSessionKey, 0);	}
	if(pKey) { SslFreeObject((NCRYPT_HANDLE)pKey, 0); }
	return Status;
}





/** @function SslGetKeyProperty
  * @brief Queries information from a key
  *
  * @param hKey: Handle to the key which is being queried.
  * @param pszProperty: Which property of the key you are querying
  * @param ppbOutput: Will write a pointer to a newly allocated buffer 
  *					  which will contain the property that was queried.
  *					  NOTE: it is the caller's responsibility to free this
  *					  buffer via a call to SslFreeBuffer.
  * @param pcbOutput: SslGetKeyProperty will write the number of bytes written
  *					  into the buffer at *ppbOutput.
  * @param dwFlags: Not Used
  *
  * @return ERROR_SUCCESS on success.
  **/
SECURITY_STATUS
WINAPI
SslGetKeyProperty(
    __in    NCRYPT_KEY_HANDLE hKey,
    __in    LPCWSTR pszProperty,
    __deref_out_bcount(*pcbOutput) PBYTE *ppbOutput,
    __out   DWORD * pcbOutput,
    __in    DWORD   dwFlags)
{
	DWORD	cbResult = 0;
	PBYTE	pbResult = NULL;
	SECURITY_STATUS Status;
	P_KEY_OBJECT pKey = NULL;

	// Validate parameters
	UNREFERENCED_PARAMETER(dwFlags);
	CHECK_POINTER(ppbOutput);
	CHECK_POINTER(pcbOutput);
	if(pszProperty == NULL || wcslen(pszProperty) > NCRYPT_MAX_PROPERTY_NAME)
    {
        Status = NTE_INVALID_PARAMETER;
        CHECK_STATUS(Status)
    }
	Status = validateKeyHandle(hKey);
	CHECK_STATUS(Status);


	pKey = HANDLE_TO_KEY(hKey);


	// Get byte count of the property
	Status = NCryptGetProperty(
					  pKey->ncrypt_key_handle,
                      pszProperty,
                      NULL,
                      0,
                      &cbResult,
                      0);
	CHECK_STATUS(Status)
	

	// Allocate buffer for the property
	pbResult = (PBYTE)MALLOC(cbResult);
	CHECK_POINTER(pbResult)

	// Actually get the property
	Status = NCryptGetProperty(
					  pKey->ncrypt_key_handle,
					  pszProperty,
					  pbResult,
					  cbResult,
					  &cbResult,
					  0);
	CHECK_STATUS(Status)

	// Write results to caller
	*ppbOutput = pbResult;
	*pcbOutput = cbResult;

	return ERROR_SUCCESS;

cleanup:
	if(pbResult) FREE(pbResult);
	return Status;
}




///////////////////////////////////////////////////////////////////////
//////////////////    Helper Functions    /////////////////////////////
///////////////////////////////////////////////////////////////////////


/** @helper_function newKeyObject
  * @brief Allocates memory and initializes a new KEY_OBJECT structure.
  *
  * @return Pointer to the structure on success
  * @return NULL if no more memory
  **/
P_KEY_OBJECT
WINAPI
newKeyObject(){
	P_KEY_OBJECT pKeyObj = (P_KEY_OBJECT)MALLOC(sizeof(KEY_OBJECT));
	if(pKeyObj == NULL) return NULL;

	pKeyObj->cbLength = sizeof(KEY_OBJECT);
	pKeyObj->dwHandleType = TYPE_KEY_OBJECT;

	return pKeyObj;
}

/** @helper_function validateKeyObject
  * @brief Determines whether or not the handle passed is a valid key object
  *
  * @param hKey: Handle to the key to be validated
  **/
SECURITY_STATUS
WINAPI
validateKeyHandle(NCRYPT_KEY_HANDLE hKey){
	P_KEY_OBJECT pKey = HANDLE_TO_KEY(hKey);

	if(!pKey) 
		return NTE_INVALID_HANDLE;
	
	if(pKey->cbLength != sizeof(KEY_OBJECT))
			return NTE_INVALID_HANDLE;

	if (pKey->dwHandleType != TYPE_KEY_OBJECT)
			return NTE_INVALID_HANDLE;
	
	return ERROR_SUCCESS;
}


/** @helper_function validateProviderHandle
  * @brief Determines whether or not the handle passed is a valid protocol provider object
  *
  * @param hProv: Handle to the provider to be validated
  **/
SECURITY_STATUS
WINAPI
validateProviderHandle(NCRYPT_PROV_HANDLE hProv){
	P_CUSTOM_PROTOCOL_PROVIDER pProv = HANDLE_TO_PROVIDER(hProv);

	if(!pProv) 
		return NTE_INVALID_HANDLE;

	if(pProv->cbLength != sizeof(CUSTOM_PROTOCOL_PROVIDER)) 
		return NTE_INVALID_HANDLE;

	if(pProv->dwHandleType != TYPE_CUSTOM_PROTOCOL_PROVIDER) 
		return NTE_INVALID_HANDLE;

	return ERROR_SUCCESS;
}




