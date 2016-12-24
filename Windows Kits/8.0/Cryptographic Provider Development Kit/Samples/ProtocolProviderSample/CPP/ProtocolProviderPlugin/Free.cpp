/** @file Free.cpp
  * @brief Contains implementations for functions whose purpose is deallocation of memory.
**/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"

#ifdef __cplusplus
extern "C" {
#endif

SECURITY_STATUS 
WINAPI 
freeCustomProvider(P_CUSTOM_PROTOCOL_PROVIDER pProvider);

SECURITY_STATUS 
WINAPI 
freeKey(P_KEY_OBJECT pKey);

SECURITY_STATUS 
WINAPI 
freeHash(P_HASH_OBJECT pHash);

SECURITY_STATUS 
WINAPI 
freeMasterKey(P_MASTERKEY_OBJECT pMasterKey);
		
SECURITY_STATUS 
WINAPI 
freeSessionKey(P_SESSION_KEY_OBJECT pSessionKey);
		
SECURITY_STATUS 
WINAPI 
freeHandshakeHash(P_HANDSHAKE_HASH_OBJECT pHandshakeHash);

/** @function SslFreeBuffer
  * @brief Frees a memory buffer that was allocated by one of the other 
  *        SSL protocol provider functions.
  * 
  * @param pvInput: Pointer to the buffer to free.
  * 
  * @return ERROR_SUCCESS: On success.
  **/
SECURITY_STATUS
WINAPI
SslFreeBuffer(
    __deref PVOID   pvInput)
{
	// All buffers in this protocol provider are allocated with "MALLOC"
	// Thus, they will all be deallocated with "FREE"
	FREE(pvInput);

	return ERROR_SUCCESS;
}


/** @function SslFreeObject
  * @brief Frees a key, hash, or provider object that was created using one of the
  *        other SSL protocol provider functions.
  *
  * @param hObject: The handle to the object to be freed.
  * @param dwFlags: Not used.
  *
  * @return ERROR_SUCCESS: On success.
  **/
SECURITY_STATUS
WINAPI
SslFreeObject(
    __deref NCRYPT_HANDLE hObject,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	// Convert the handle to the provider structure via cast
	P_GENERIC_OBJECT pObj = HANDLE_TO_GENERIC(hObject);

	switch(pObj->dwHandleType) {
		////////////////////
		case TYPE_CUSTOM_PROTOCOL_PROVIDER:
			return freeCustomProvider((P_CUSTOM_PROTOCOL_PROVIDER)pObj);
		break;
		////////////////////
		case TYPE_KEY_OBJECT:
			return freeKey((P_KEY_OBJECT)pObj);
		break;
		////////////////////
		case TYPE_HASH_OBJECT:
			return freeHash((P_HASH_OBJECT)pObj);
		break;
		////////////////////
		case TYPE_MASTERKEY_OBJECT:
			return freeMasterKey((P_MASTERKEY_OBJECT)pObj);
		break;
		////////////////////
		case TYPE_SESSION_KEY_OBJECT:
			return freeSessionKey((P_SESSION_KEY_OBJECT)pObj);
		break;
		////////////////////
		case TYPE_HANDSHAKE_HASH_OBJECT:
			return freeHandshakeHash((P_HANDSHAKE_HASH_OBJECT)pObj);
		break;
		////////////////////
		default:
			return NTE_BAD_TYPE;
		break;
	}
}

SECURITY_STATUS 
WINAPI 
freeCustomProvider(P_CUSTOM_PROTOCOL_PROVIDER pProvider) {
	SECURITY_STATUS Status;

	// Close the algorithm providers
	Status = NCryptFreeObject((NCRYPT_HANDLE)pProvider->ncrypt_prov_handle);
	CHECK_STATUS(Status);
	Status = BCryptCloseAlgorithmProvider(pProvider->md5_alg_handle, NULL);
	CHECK_STATUS(Status);
	Status = BCryptCloseAlgorithmProvider(pProvider->sha1_alg_handle, NULL);
	CHECK_STATUS(Status);
	Status = BCryptCloseAlgorithmProvider(pProvider->md5_hmac_alg_handle, NULL);
	CHECK_STATUS(Status);
	Status = BCryptCloseAlgorithmProvider(pProvider->sha1_hmac_alg_handle, NULL);
	CHECK_STATUS(Status);
	Status = BCryptCloseAlgorithmProvider(pProvider->rc2_alg_handle, NULL);
	CHECK_STATUS(Status);

	SecureZeroMemory(pProvider, pProvider->cbLength);
	FREE(pProvider);
	return ERROR_SUCCESS;
cleanup:
	return Status;
}

SECURITY_STATUS 
WINAPI 
freeKey(P_KEY_OBJECT pKey) {
	SECURITY_STATUS Status;

	Status = NCryptFreeObject((NCRYPT_HANDLE)pKey->ncrypt_key_handle);
	CHECK_STATUS(Status);
	
	SecureZeroMemory(pKey, pKey->cbLength);
	FREE(pKey);
	return ERROR_SUCCESS;
cleanup:
	return Status;
}

SECURITY_STATUS 
WINAPI 
freeHash(P_HASH_OBJECT pHash) {
	SECURITY_STATUS Status;

	Status = NCryptFreeObject((NCRYPT_HANDLE)pHash->ncrypt_hash_handle);
	CHECK_STATUS(Status);

	SecureZeroMemory(pHash, pHash->cbLength);
	FREE(pHash);
	return ERROR_SUCCESS;
cleanup:
	return Status;
}


SECURITY_STATUS 
WINAPI 
freeMasterKey(P_MASTERKEY_OBJECT pMasterKey){
	SecureZeroMemory(pMasterKey, pMasterKey->cbLength);
	FREE(pMasterKey);

	return ERROR_SUCCESS;
}
		
SECURITY_STATUS 
WINAPI 
freeSessionKey(P_SESSION_KEY_OBJECT pSessionKey){
	SECURITY_STATUS Status;

	Status = BCryptDestroyKey(pSessionKey->bcrypt_key_handle);
	CHECK_STATUS(Status);

	FREE(pSessionKey->pbKeyObjectBuffer);

	SecureZeroMemory(pSessionKey, pSessionKey->cbLength);
	FREE(pSessionKey);

	return ERROR_SUCCESS;
cleanup:
	return Status;
}
		
SECURITY_STATUS 
WINAPI 
freeHandshakeHash(P_HANDSHAKE_HASH_OBJECT pHandshakeHash){
	SECURITY_STATUS Status;

	Status = BCryptDestroyHash(pHandshakeHash->hMD5);
	CHECK_STATUS(Status);

	Status = BCryptDestroyHash(pHandshakeHash->hSHA1);
	CHECK_STATUS(Status);

	FREE(pHandshakeHash->pbMD5ObjectBuffer);
	FREE(pHandshakeHash->pbSHA1ObjectBuffer);

	SecureZeroMemory(pHandshakeHash, pHandshakeHash->cbLength);
	FREE(pHandshakeHash);

	return ERROR_SUCCESS;
cleanup:
	return Status;
}


#ifdef __cplusplus
}       // Balance extern "C" above
#endif

