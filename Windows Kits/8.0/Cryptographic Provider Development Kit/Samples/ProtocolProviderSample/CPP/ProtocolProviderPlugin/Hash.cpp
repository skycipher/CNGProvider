/** @file Hash.cpp
  * @brief Contains the implementations of the hash related functions
 **/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"
#include "Masterkey.h"


P_HANDSHAKE_HASH_OBJECT
WINAPI
newHandshakeHash(DWORD dwMD5BufferLength, DWORD dwSHA1BufferLength);

SECURITY_STATUS
WINAPI
validateHandshakeHash(NCRYPT_HASH_HANDLE hHandshakeHash);

/** @function SslCreateHandshakeHash
  * @brief Creates a compound hash object used to hash handshake messages.
  *		   This is the first of 3 functions used to generate a handshake hash.
  *		   You first obtain an NCRYPT_HASH_HANDLE via SslCreateHandshakeHash.
  *		   Next you pass the data to hash into SslHashHandshake via the NCRYPT_HASH_HANDLE.
  *		   Finally you recieve the hash digest from SslComputeFinishedHash via the NCRYPT_HASH_HANDLE.
  *
  * @param hSslProvider: The handle to the protocol provider.
  * @param phHandshakeHash: The handle to the handshake hash will be returned in this parameter.
  * @param dwProtocol: The protocol being used. This implementation only uses TLS.
  * @param dwCipherSuite: The specific cipher suite being used. This implementation only uses TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5
  * @param dwFlags: Not used.
  **/
SECURITY_STATUS
WINAPI
SslCreateHandshakeHash(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __out   NCRYPT_HASH_HANDLE *phHandshakeHash,
    __in    DWORD   dwProtocol,
    __in    DWORD   dwCipherSuite,
    __in    DWORD   dwFlags)
{
	SECURITY_STATUS Status;
	P_HANDSHAKE_HASH_OBJECT pHash = NULL;

	// Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);
	CHECK_POINTER(phHandshakeHash);
	if(dwProtocol != TLS1_PROTOCOL_VERSION) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}
	if(dwCipherSuite != BASE_CIPHER_SUITE_CODE) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status); 
	}
	if(dwFlags) {
		Status = NTE_BAD_FLAGS;
		CHECK_STATUS(Status);
	}

	// Get Custom protocol provider structure
	P_CUSTOM_PROTOCOL_PROVIDER pProv = HANDLE_TO_PROVIDER(hSslProvider);

	// Allocate new hash objects
	pHash = newHandshakeHash(pProv->md5_obj_length, pProv->sha1_obj_length);
	CHECK_POINTER(pHash);


	// Create a MD5 and SHA1 hash object
	Status = BCryptCreateHash(
					pProv->md5_alg_handle,
					&pHash->hMD5,
					pHash->pbMD5ObjectBuffer,
					pHash->cbMD5ObjectBuffer,
					NULL,
					0,
					0);
	CHECK_STATUS(Status);
	
	Status = BCryptCreateHash(
					pProv->sha1_alg_handle,
					&pHash->hSHA1,
					pHash->pbSHA1ObjectBuffer,
					pHash->cbSHA1ObjectBuffer,
					NULL,
					0,
					0);
	CHECK_STATUS(Status);

	*phHandshakeHash = (NCRYPT_HASH_HANDLE)pHash;

	return ERROR_SUCCESS;
cleanup:

	if(pHash) { 
		SslFreeObject((NCRYPT_HANDLE)pHash, 0); 
	}

	return Status;
}


/** @function SslHashHandshake
  * @brief Adds a handshake message to the cumulative handshake hash object. 
  *		   This handshake hash is used when generating or processing Finished and
  *		   CertificateVerify messages.
  *
  * @param hSslProvider: The handle to the ssl protocol provider.
  * @param hHandshakeHash: The handle to the created handshake hash object.
  * @param pbInput: The buffer in which is stored the data to be hashed.
  * @param cbInput: The count of bytes for the pbInput buffer.
  * @param dwFlags: Not Used.
  *
  **/
SECURITY_STATUS
WINAPI
SslHashHandshake(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __inout NCRYPT_HASH_HANDLE hHandshakeHash,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);
	SECURITY_STATUS Status;

	// Validate Parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);
	Status = validateHandshakeHash(hHandshakeHash);
	CHECK_STATUS(Status);
	CHECK_POINTER(pbInput);

	// Get the hash object
	P_HANDSHAKE_HASH_OBJECT pHandshakeHash = HANDLE_TO_HANDSHAKE_HASH(hHandshakeHash);

	// It is legal to hash 0 bytes
	if(!cbInput) return ERROR_SUCCESS;

	// Hash the data
	Status = BCryptHashData(
				pHandshakeHash->hMD5,
				pbInput,
				cbInput,
				0);
	CHECK_STATUS(Status);

	Status = BCryptHashData(
				pHandshakeHash->hSHA1,
				pbInput,
				cbInput,
				0);
	CHECK_STATUS(Status);

	return ERROR_SUCCESS;
cleanup:
	return Status;
}



/** @function SslComputeFinishedHash
  * @brief Computes the hashes that are sent in the Finished handshake message
  *
  * @param hSslProvider: The handle to the ssl provider used in the PRF
  * @param hMasterKey: The handle to the key used in the hash
  * @param hHandshakeHash: The handle to the hash of the handshake messages
  * @param pbOutput: The buffer to write the hash to
  * @param cbOutput: The size in bytes of pbOutput
  * @param dwFlags: NCRYPT_SSL_CLIENT_FLAG or NCRYPT_SSL_SERVER_FLAG
  **/
SECURITY_STATUS
WINAPI
SslComputeFinishedHash(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hMasterKey,
    __in    NCRYPT_HASH_HANDLE hHandshakeHash,
    __out_bcount_full(cbOutput) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __in    DWORD   dwFlags)
{
	SECURITY_STATUS Status;

	BCRYPT_HASH_HANDLE hLocalSHA1 = NULL;
    BCRYPT_HASH_HANDLE hLocalMD5 = NULL;
	PBYTE pbLocalSHA1, pbLocalMD5, pbHashBuffer;
	pbLocalSHA1 = pbLocalMD5 = pbHashBuffer = NULL;
	DWORD cbLocalSHA1, cbLocalMD5, cbHashBuffer;
	BYTE pbFinishedHashes[MD5_LENGTH + SHA1_LENGTH];
	PSTR pszLabel;
	DWORD cbLabel;

	// Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

	Status = validateMasterKey(hMasterKey);
	CHECK_STATUS(Status);

	Status = validateHandshakeHash(hHandshakeHash);
	CHECK_STATUS(Status);

	CHECK_POINTER(pbOutput);
	if(!(dwFlags & NCRYPT_SSL_CLIENT_FLAG || dwFlags & NCRYPT_SSL_SERVER_FLAG)) {
		Status = NTE_BAD_FLAGS;
		CHECK_STATUS(Status);
	}

	// Get hash handshake structure pointer
	P_HANDSHAKE_HASH_OBJECT pHandshakeHash = HANDLE_TO_HANDSHAKE_HASH(hHandshakeHash);
	P_MASTERKEY_OBJECT pMasterKey = HANDLE_TO_MASTERKEY(hMasterKey);


	// Create duplicates of the handshake hash so you can use it later
	////
	cbHashBuffer = pHandshakeHash->cbMD5ObjectBuffer + pHandshakeHash->cbSHA1ObjectBuffer;
	pbHashBuffer = (PBYTE)MALLOC(cbHashBuffer);
	CHECK_POINTER(pbHashBuffer);

	pbLocalMD5 = pbHashBuffer;
	cbLocalMD5 =  pHandshakeHash->cbMD5ObjectBuffer;
	pbLocalSHA1 = pbLocalMD5 + cbLocalMD5;
	cbLocalSHA1 = pHandshakeHash->cbSHA1ObjectBuffer;

	Status = BCryptDuplicateHash(
						pHandshakeHash->hMD5,
                        &hLocalMD5,
                        pbLocalMD5,
                        cbLocalMD5,
                        0);
	CHECK_STATUS(Status);

	Status = BCryptDuplicateHash(
						pHandshakeHash->hSHA1,
                        &hLocalSHA1,
                        pbLocalSHA1,
                        cbLocalSHA1,
                        0);
	CHECK_STATUS(Status);

	
	// Finalize the local hashes by putting the 2 into 1 buffer. Put MD5 before SHA1 in the buffer
	////
	Status = BCryptFinishHash(
						hLocalMD5,
						pbFinishedHashes,
						MD5_LENGTH,
						0);
	CHECK_STATUS(Status);

	Status = BCryptFinishHash(
						hLocalSHA1,
						pbFinishedHashes + MD5_LENGTH,
						SHA1_LENGTH,
						0);
	CHECK_STATUS(Status);

	// Call the PRF to compute the final hash
	////
	if(dwFlags & NCRYPT_SSL_CLIENT_FLAG) {
		pszLabel = CLIENT_FINISHED_LABEL;
		cbLabel  = CLIENT_FINISHED_LABEL_SIZE;
	} else {
		pszLabel = SERVER_FINISHED_LABEL;
		cbLabel  = SERVER_FINISHED_LABEL_SIZE;
	}

	Status = PRF(
				hSslProvider,
				pMasterKey->pbMasterKey,
				SSL3_MASTERKEY_LENGTH,
				pbFinishedHashes,
				MD5_LENGTH + SHA1_LENGTH,
				(PBYTE)pszLabel,
				cbLabel,
				pbOutput,
				cbOutput);
	CHECK_STATUS(Status);

	Status = ERROR_SUCCESS;
cleanup:
	if(hLocalMD5) { BCryptDestroyHash(hLocalMD5); }
	if(hLocalSHA1) { BCryptDestroyHash(hLocalSHA1); }
	if(pbHashBuffer) { FREE(pbHashBuffer); }

	return Status;
}


/** @function SslComputeClientAuthHash
  * @brief Computes the hashes that are sent in the CertificateVerify handshake
  *        message during client authentication.
  *
  * @param hSslProvider: Handle to the protocol provider instance being used.
  * @param hMasterKey: Handle to the master key object
  * @param hHandshakeHash: Handle to the hash of the handshake thus far
  * @param pszAlgId: Indicates the type of key being used in client authentication
  * @param pbOutput: Pointer to a buffer in which to write the hash.
  * @param cbOutput: The byte count of the buffer pointed to by pbOutput.
  * @param pcbResult: Where to write the number of bytes actually written into pbOutput by SslComputeClientAuthHash
  * @param dwFlags: Not used.
  */ 
SECURITY_STATUS
WINAPI
SslComputeClientAuthHash(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hMasterKey,
    __in    NCRYPT_HASH_HANDLE hHandshakeHash,
    __in    LPCWSTR pszAlgId,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	SECURITY_STATUS Status;
	DWORD			cbMD5, cbSHA1;
	PBYTE			pbMD5, pbSHA1;
	BCRYPT_HASH_HANDLE hLocalMD5 = NULL, hLocalSHA1 = NULL;
	DWORD	cbObjectBuffer = 0;
	PBYTE	pbObjectBuffer = NULL;

	// Validate parameters
	////
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

	Status = validateMasterKey(hMasterKey);
	CHECK_STATUS(Status);

	Status = validateHandshakeHash(hHandshakeHash);
	CHECK_STATUS(Status);

	if(!pszAlgId || wcscmp(pszAlgId, NCRYPT_RSA_ALGORITHM) != 0) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}

	CHECK_POINTER(pcbResult);
	*pcbResult = MD5_LENGTH + SHA1_LENGTH;	


	// If pbOutput is NULL, we are done
	if(!pbOutput) {
		return ERROR_SUCCESS;
	}

	if(cbOutput < (MD5_LENGTH + SHA1_LENGTH)) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}
	
	// Get Structure Pointers From Handles
	P_HANDSHAKE_HASH_OBJECT	pHandshakeHash = HANDLE_TO_HANDSHAKE_HASH(hHandshakeHash);
	
	// Set up buffers for BCrypt operations
	pbMD5 = pbOutput;
	cbMD5 = MD5_LENGTH;

	pbSHA1 = pbMD5 + cbMD5;
	cbSHA1 = SHA1_LENGTH;

	cbObjectBuffer = pHandshakeHash->cbMD5ObjectBuffer + pHandshakeHash->cbSHA1ObjectBuffer;
	pbObjectBuffer = (PBYTE)MALLOC(cbObjectBuffer);
	CHECK_POINTER(pbObjectBuffer);

	PBYTE pbLocalMD5  = pbObjectBuffer;
	DWORD cbLocalMD5  = pHandshakeHash->cbMD5ObjectBuffer;

	PBYTE pbLocalSHA1 = pbLocalMD5 + cbLocalMD5;
	DWORD cbLocalSHA1 = pHandshakeHash->cbSHA1ObjectBuffer;
	

	// Compute the client authentication hash for MD5 and SHA1
	////
	Status = BCryptDuplicateHash(
					pHandshakeHash->hMD5,
					&hLocalMD5,
					pbLocalMD5,
					cbLocalMD5,
					0);
	CHECK_STATUS(Status);
	Status = BCryptDuplicateHash(
					pHandshakeHash->hSHA1,
					&hLocalSHA1,
					pbLocalSHA1,
					cbLocalSHA1,
					0);
	CHECK_STATUS(Status);
					

	Status = BCryptFinishHash(
						hLocalMD5,
						pbMD5,
						cbMD5,
						0);
	CHECK_STATUS(Status);
	
	Status = BCryptFinishHash(
						hLocalSHA1,
						pbSHA1,
						cbSHA1,
						0);
	CHECK_STATUS(Status);

	Status = ERROR_SUCCESS;
cleanup:
	
	if(hLocalMD5) { BCryptDestroyHash(hLocalMD5); }
	if(hLocalSHA1) { BCryptDestroyHash(hLocalSHA1); }
	if(pbObjectBuffer) { FREE(pbObjectBuffer); }

	return Status;
}


//////////////////////////////
////// Helper Functions //////
//////////////////////////////

P_HANDSHAKE_HASH_OBJECT
WINAPI
newHandshakeHash(DWORD dwMD5BufferLength, DWORD dwSHA1BufferLength) {
	P_HANDSHAKE_HASH_OBJECT pHandshakeHashObj = (P_HANDSHAKE_HASH_OBJECT)MALLOC(sizeof(HANDSHAKE_HASH_OBJECT));
	if(pHandshakeHashObj == NULL) return NULL;

	pHandshakeHashObj->cbLength = sizeof(HANDSHAKE_HASH_OBJECT);
	pHandshakeHashObj->dwHandleType = TYPE_HANDSHAKE_HASH_OBJECT;

	pHandshakeHashObj->cbMD5ObjectBuffer = dwMD5BufferLength;
	pHandshakeHashObj->pbMD5ObjectBuffer = (PBYTE)MALLOC(dwMD5BufferLength);
	if(!pHandshakeHashObj->pbMD5ObjectBuffer) 
	{
		FREE(pHandshakeHashObj);
		return NULL;
	}

	pHandshakeHashObj->cbSHA1ObjectBuffer = dwSHA1BufferLength;
	pHandshakeHashObj->pbSHA1ObjectBuffer = (PBYTE)MALLOC(dwSHA1BufferLength);
	if(!pHandshakeHashObj->pbSHA1ObjectBuffer) 
	{
		FREE(pHandshakeHashObj->pbMD5ObjectBuffer);
		FREE(pHandshakeHashObj);
		return NULL;
	}

	return pHandshakeHashObj;
}

SECURITY_STATUS
WINAPI
validateHandshakeHash(NCRYPT_HASH_HANDLE hHandshakeHash) {
	P_HANDSHAKE_HASH_OBJECT pHash = HANDLE_TO_HANDSHAKE_HASH(hHandshakeHash);
	
	if(!pHash) return NTE_INVALID_HANDLE;
	if(pHash->cbLength != sizeof(HANDSHAKE_HASH_OBJECT)) return NTE_INVALID_HANDLE;
	if(pHash->dwHandleType != TYPE_HANDSHAKE_HASH_OBJECT) return NTE_INVALID_HANDLE;

	if(!pHash->hMD5)  return	NTE_INVALID_HANDLE;
	if(!pHash->hSHA1) return	NTE_INVALID_HANDLE;
	if(!pHash->pbSHA1ObjectBuffer) return	NTE_INVALID_HANDLE;
	if(!pHash->pbMD5ObjectBuffer)  return	NTE_INVALID_HANDLE;

	return ERROR_SUCCESS;
}