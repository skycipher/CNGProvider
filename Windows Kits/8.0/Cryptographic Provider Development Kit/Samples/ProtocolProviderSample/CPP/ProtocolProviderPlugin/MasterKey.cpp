/** @file MasterKey.cpp
  * @brief Contains the implementation of the functions 
  *		   SslGenerateMasterKey, SslImportMasterKey, and SslGenerateSessionKeys.
  *		   Also implements the PRF for TLS 1.0
**/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"
#include "MasterKey.h"


/** @function SslGenerateMasterKey
  * @brief Computes the SSL master secret. 
  *		   For RSA key exchange, the client-side of schannel will call SslGenerateMasterKey
  *		   and the server-side will call SslImportMasterKey. 
  *		   This implementation does not support DH.
  *
  * @param hSslProvider: The handle to an instance of the protocol provider.
  * @param hPrivateKey: The handle to the private key used in the exchange. NOTE: not used in this implementation.
  * @param hPublicKey: The handle to the public key used in the exchange.
  * @param phMasterKey: Where to write the master key to.
  * @param dwProtocol: The protocol to use. Should be TLS1_PROTOCOL_VERSION in this implementation.
  * @param dwCipherSuite: The cipher suite being used for this SSL exchange.
  * @param pParameterList: Contains the server and client randoms as well as other values
  * @param pbOutput: Where to write the pre-master secret encrypted with the server's public key
  * @param cbOutput: The size in bytes of the buffer pointed to by pbOutput.
  * @param pcbResult: Where to write the byte count of the result.
  * @param dwFlags: Should be NCRYPT_SSL_CLIENT_FLAG in this implementation. Indicates the client is calling the function.
  */
SECURITY_STATUS
WINAPI
SslGenerateMasterKey(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in_opt NCRYPT_KEY_HANDLE hPrivateKey,
    __in    NCRYPT_KEY_HANDLE hPublicKey,
    __out   NCRYPT_KEY_HANDLE *phMasterKey,
    __in    DWORD   dwProtocol,
    __in    DWORD   dwCipherSuite,
    __in    PNCryptBufferDesc pParameterList,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags){

	SECURITY_STATUS Status;
	P_KEY_OBJECT pPublicKey;
	KEY_OBJECT publicKey;
	P_MASTERKEY_OBJECT pMasterKey = NULL;
	PBYTE pbRandom = NULL;
	DWORD cbRandom;
	BCRYPT_ALG_HANDLE	hAlg = NULL;

	// This is to handle the case where Schannel calls SslGenerateMasterKey with no private key
	if(!hPrivateKey) {
		publicKey.cbLength = sizeof(KEY_OBJECT);
		publicKey.dwHandleType = TYPE_KEY_OBJECT;
		publicKey.ncrypt_key_handle = hPublicKey;
		hPublicKey = (NCRYPT_KEY_HANDLE)(&publicKey);
	}

	// Validate parameters
	Status = validateCommonArguments(hSslProvider, hPublicKey, dwProtocol, dwCipherSuite, pParameterList, dwFlags);
	CHECK_STATUS(Status);

	CHECK_POINTER(phMasterKey);
	CHECK_POINTER(pcbResult);
	if(dwFlags & NCRYPT_SSL_SERVER_FLAG) {
		Status = NTE_NOT_SUPPORTED;
		CHECK_STATUS(Status);
	}
	CHECK_POINTER(pbOutput); 

	// Get Structure pointers from handles
	pPublicKey = HANDLE_TO_KEY(hPublicKey);


	// Get the client and server random and the highest version value from the parameter list
	PVOID pbClientRandom, pbServerRandom;
	DWORD cbClientRandom, cbServerRandom, dwHighestVersion;
	Status = getParameters(pParameterList, 
						   &pbClientRandom,
						   &cbClientRandom, 
						   &pbServerRandom, 
						   &cbServerRandom, 
						   &dwHighestVersion);
	CHECK_STATUS(Status);
	
	// Combine server and client randoms into one buffer
	cbRandom = cbClientRandom + cbServerRandom;
	pbRandom = (BYTE *)MALLOC(cbRandom);
	CHECK_POINTER(pbRandom);

	memcpy(pbRandom, pbClientRandom, cbClientRandom);
	memcpy(pbRandom + cbClientRandom, pbServerRandom, cbServerRandom);
	

	// Generate the pre-master secret for the client
	BYTE  randomPreMasterSecret[SSL3_MASTERKEY_LENGTH];

	// The first two bytes will store the highest version # to protect against version fallback attacks
	randomPreMasterSecret[0] = (BYTE)(dwHighestVersion >> 8);
	randomPreMasterSecret[1] = (BYTE)dwHighestVersion;

	Status = BCryptOpenAlgorithmProvider(&hAlg, BCRYPT_RNG_ALGORITHM, NULL, 0);
	CHECK_STATUS(Status);

	// The rest is random data
	Status = BCryptGenRandom(
                        hAlg, 
                        randomPreMasterSecret+2,
                        sizeof(randomPreMasterSecret)-2,
                        0);
	CHECK_STATUS(Status);

	// Encrypt the newly generated random pre-master secret with the server's public key
	Status = NCryptEncrypt(
                        pPublicKey->ncrypt_key_handle,
                        randomPreMasterSecret,
                        sizeof(randomPreMasterSecret),
                        NULL,
                        pbOutput,
                        cbOutput,
                        pcbResult,
                        BCRYPT_PAD_PKCS1); 
	CHECK_STATUS(Status);

	// Create a new master key object
	pMasterKey = newMasterKeyObject(MASTERKEY_CLIENT_FLAG);
	if(!pMasterKey) {
		Status = NTE_NO_MEMORY;
		CHECK_STATUS(Status);
	}

	// Generate the master key
	Status = PRF(
				hSslProvider,
				randomPreMasterSecret,
				sizeof(randomPreMasterSecret),
				pbRandom,
				cbRandom,
				(BYTE *)MASTER_KEY_LABEL,
				MASTER_KEY_LABEL_SIZE,
				pMasterKey->pbMasterKey,
				SSL3_MASTERKEY_LENGTH);
	CHECK_STATUS(Status);

	// Return a handle to the master key
	*phMasterKey = KEY_TO_HANDLE(pMasterKey);

	pMasterKey = NULL;
	Status = ERROR_SUCCESS;

cleanup:
	if(hAlg) {BCryptCloseAlgorithmProvider(hAlg, 0); }
	if(pMasterKey) { SslFreeObject((NCRYPT_HANDLE)pMasterKey, 0); }
	if(pbRandom) { FREE(pbRandom); }

	return Status;

}



/** @function SslImportMasterKey
  * @brief	This function is used when performing a server-side SSL key exchange 
  *			operation. This function decrypts the pre-master secret, computes the 
  *			SSL master secret, and returns a handle to this object to the caller. 
  *			This master key can then be used to derive the SSL session keys, and 
  *			finish the SSL handshake.
  *
  *			This function is only called when an RSA key exchange algorithm is being used.
  *
  *	@param	hSslProvider: The handle to the protocol provider being used.
  * @param	hPrivateKey: The handle to the private key with which to decrypt the pre-master secret.
  * @param	phMasterKey: A pointer to a key handle corresponding to the master key will be returned here.
  * @param	dwProtocol: The double word code corresponding to the protocol being used. 
  * @param	dwCipherSuite: The double word code corresponding to the cipher suite being used.
  * @param	pParameterList: Is a list of buffers which among other data will always contain the client and server randoms.
  * @param	pbEncryptedKey: The pre-master secret which is encrypted with the server's public key.
  * @param	cbEncryptedKey: The size in bytes of the buffer pointed to by pbEncryptedKey.
  * @param	dwFlags: Should be NCRYPT_SSL_SERVER_FLAG in this implementation. Indicates the server is calling the function.
  **/
SECURITY_STATUS
WINAPI
SslImportMasterKey(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hPrivateKey,
    __out   NCRYPT_KEY_HANDLE *phMasterKey,
    __in    DWORD   dwProtocol,
    __in    DWORD   dwCipherSuite,
    __in    NCryptBufferDesc *pParameterList,
    __in_bcount(cbEncryptedKey) PBYTE pbEncryptedKey,
    __in    DWORD   cbEncryptedKey,
    __in    DWORD   dwFlags)
{
	SECURITY_STATUS Status;
	BYTE rgbMasterKey[SSL3_MASTERKEY_LENGTH];
	DWORD cbResult;
	P_MASTERKEY_OBJECT pMasterKey = NULL;
	PBYTE	 pbRandom = NULL;
	DWORD	 cbRandom = 0;


	P_KEY_OBJECT pPrivateKey;

	// Validate arguments
	Status = validateCommonArguments(hSslProvider, hPrivateKey, dwProtocol, dwCipherSuite, pParameterList, dwFlags);
	CHECK_STATUS(Status);
	CHECK_POINTER(phMasterKey);
	CHECK_POINTER(pbEncryptedKey);
	if(dwFlags & NCRYPT_SSL_CLIENT_FLAG) {
		Status = NTE_NOT_SUPPORTED;
		CHECK_STATUS(Status);
	}

	pPrivateKey = HANDLE_TO_KEY(hPrivateKey);


	// Get the client and server random and the highest version value from the parameter list
	PVOID pbClientRandom, pbServerRandom;
	DWORD cbClientRandom, cbServerRandom, dwHighestVersion;
	Status = getParameters(pParameterList, 
						   &pbClientRandom,
						   &cbClientRandom, 
						   &pbServerRandom, 
						   &cbServerRandom, 
						   &dwHighestVersion);
	CHECK_STATUS(Status);

	// Combine server and client randoms into one buffer
	cbRandom = cbClientRandom + cbServerRandom;
	pbRandom = (BYTE *)MALLOC(cbRandom);
	CHECK_POINTER(pbRandom);

	memcpy(pbRandom, pbClientRandom, cbClientRandom);
	memcpy(pbRandom + cbClientRandom, pbServerRandom, cbServerRandom);


	// Decrypt the pre-master secret
	Status = NCryptDecrypt(
					pPrivateKey->ncrypt_key_handle,
                    pbEncryptedKey,
                    cbEncryptedKey,
                    NULL,
                    rgbMasterKey,
                    sizeof(rgbMasterKey),
                    &cbResult,
                    BCRYPT_PAD_PKCS1);
	CHECK_STATUS(Status);


	// Retrieve the client's highest version
	DWORD dwClientHighestVersion = (((DWORD)rgbMasterKey[0]) << 8) | ((DWORD)rgbMasterKey[1]);

	// Check for version fall-back attack
	if(dwClientHighestVersion != dwHighestVersion) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}


	// Create a new master key object
	pMasterKey = newMasterKeyObject(MASTERKEY_SERVER_FLAG);
	if(!pMasterKey) {
		Status = NTE_NO_MEMORY;
		CHECK_STATUS(Status);
	}


	// Generate the master key
	Status = PRF(
				hSslProvider,
				rgbMasterKey,
				sizeof(rgbMasterKey),
				pbRandom,
				cbRandom,
				(BYTE *)MASTER_KEY_LABEL,
				MASTER_KEY_LABEL_SIZE,
				pMasterKey->pbMasterKey,
				SSL3_MASTERKEY_LENGTH);
	CHECK_STATUS(Status);


	// Return a handle to the master key
	*phMasterKey = KEY_TO_HANDLE(pMasterKey);

	pMasterKey = NULL;
	Status = ERROR_SUCCESS;

cleanup:
	if(pMasterKey) { SslFreeObject((NCRYPT_HANDLE)pMasterKey, 0); }
	if(pbRandom) { FREE(pbRandom); }
	return Status;
}


 
/** @function SslGenerateSessionKeys
  * @brief Generates a set of session keys, based on a supplied master secret and
  *		   one or more additional parameters.
  *
  * @param hSslProvider: Handle to the protocol provider.
  * @param hMasterKey: Handle to the master key used to create the session keys.
  * @param phReadKey: Where to write the newly generated read key handle.
  * @param phWriteKey: Where to write the newly generated write key handle.
  * @param pParameterList: Contains the server and client random numbers.
  * @param dwFlags: Not Used.
  **/
SECURITY_STATUS
WINAPI
SslGenerateSessionKeys(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hMasterKey,
    __out   NCRYPT_KEY_HANDLE *phReadKey,
    __out   NCRYPT_KEY_HANDLE *phWriteKey,
    __in    PNCryptBufferDesc pParameterList,
    __in    DWORD   dwFlags)
{
	SECURITY_STATUS Status;
	P_SESSION_KEY_OBJECT pReadKey = NULL, pWriteKey = NULL;
	PBYTE	pbRandom = NULL, pbKeyBlock = NULL;
	DWORD	cbRandom = 0, cbKeyBlock = 0;
	PBYTE	pbWriteMac = NULL, pbReadMac = NULL;
	PBYTE   pbWriteKey = NULL, pbReadKey = NULL;
	PBYTE   pbWriteIV = NULL, pbReadIV = NULL;
	DWORD	cbReadKeyObjectBuffer = 0, cbWriteKeyObjectBuffer = 0;
	PBYTE	pbReadKeyObjectBuffer = NULL, pbWriteKeyObjectBuffer = NULL;
	
	UNREFERENCED_PARAMETER(dwFlags);

	// Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

	Status = validateMasterKey(hMasterKey);
	CHECK_STATUS(Status);

	if(!phReadKey || !phWriteKey) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}


	//	Allocate memory for new session keys
	pReadKey = newSessionKey(0);
	CHECK_POINTER(pReadKey);
	pWriteKey = newSessionKey(0);
	CHECK_POINTER(pWriteKey);


	// Get objects from from handles
	P_CUSTOM_PROTOCOL_PROVIDER pProv = HANDLE_TO_PROVIDER(hSslProvider);
	P_MASTERKEY_OBJECT pMasterKey = HANDLE_TO_MASTERKEY(hMasterKey);
	
	
	// Parse out the server and client randoms
	PBYTE pbClientRandom, pbServerRandom;
	DWORD cbClientRandom, cbServerRandom, dwIgnore;
	Status = getParameters(pParameterList, (PVOID*)&pbClientRandom, &cbClientRandom, (PVOID*)&pbServerRandom, &cbServerRandom, &dwIgnore);
	CHECK_STATUS(Status);


	// Put the client and server randoms in one buffer for the PRF
	cbRandom = cbClientRandom + cbServerRandom;
	pbRandom = (PBYTE)MALLOC(cbRandom);
	CHECK_POINTER(pbRandom);

	memcpy(pbRandom, pbServerRandom, cbServerRandom);
	memcpy(pbRandom + cbServerRandom, pbClientRandom, cbClientRandom);

	
	// Allocate memory for the key block containing read and write versions of the following: [encryption keys, MAC values, IV values]
	cbKeyBlock = CIPHER_SUITE_KEY_LENGTH * 2	+	// KEY
	  		     MD5_LENGTH * 2				+	// MAC
				 BLOCK_LENGTH * 2;				// IV
	pbKeyBlock = (PBYTE)MALLOC(cbKeyBlock);
	CHECK_POINTER(pbKeyBlock);


	// Use the PRF to generate the session keys
	Status = PRF(
				hSslProvider,
				pMasterKey->pbMasterKey, SSL3_MASTERKEY_LENGTH, 
				pbRandom, cbRandom, 
				(PBYTE)SESSION_KEY_LABEL, SESSION_KEY_LABEL_SIZE, 
				pbKeyBlock, cbKeyBlock);
	CHECK_STATUS(Status);


	// Partition the key block 
	PBYTE pbClientWriteMac = pbKeyBlock; 
	PBYTE pbServerWriteMac = pbClientWriteMac + MD5_LENGTH;
	PBYTE pbClientWriteKey = pbServerWriteMac + MD5_LENGTH;
	PBYTE pbServerWriteKey = pbClientWriteKey + CIPHER_SUITE_KEY_LENGTH;
	PBYTE pbClientWriteIV  = pbServerWriteKey + CIPHER_SUITE_KEY_LENGTH;
	PBYTE pbServerWriteIV  = pbClientWriteIV  + BLOCK_LENGTH;


	// Depending on if it is the client or server, mark the appropriate read/write value
	switch(pMasterKey->dwClientOrServer) {
		case MASTERKEY_SERVER_FLAG:
			pbWriteMac = pbServerWriteMac;
			pbReadMac  = pbClientWriteMac;
			pbWriteKey = pbServerWriteKey;
			pbReadKey  = pbClientWriteKey;
			pbWriteIV  = pbServerWriteIV;
			pbReadIV   = pbClientWriteIV;
			break;
		case MASTERKEY_CLIENT_FLAG:
			pbWriteMac = pbClientWriteMac;
			pbReadMac  = pbServerWriteMac;
			pbWriteKey = pbClientWriteKey;
			pbReadKey  = pbServerWriteKey;
			pbWriteIV  = pbClientWriteIV;
			pbReadIV   = pbServerWriteIV;
			break;
		default:
			Status = NTE_FAIL;
			CHECK_STATUS(Status);
			break;
	}


	// Allocate room for the key objects
	cbReadKeyObjectBuffer = pProv->rc2_obj_length;
	pbReadKeyObjectBuffer = (PBYTE)MALLOC(cbReadKeyObjectBuffer); 
	CHECK_POINTER(pbReadKeyObjectBuffer);
	
	cbWriteKeyObjectBuffer = pProv->rc2_obj_length;
	pbWriteKeyObjectBuffer = (PBYTE)MALLOC(cbWriteKeyObjectBuffer); 
	CHECK_POINTER(pbWriteKeyObjectBuffer);


	// Generate read and write key objects
	Status = BCryptGenerateSymmetricKey(
							pProv->rc2_alg_handle,
							&pReadKey->bcrypt_key_handle,
							pbReadKeyObjectBuffer,
							cbReadKeyObjectBuffer,
							pbReadKey,
							CIPHER_SUITE_KEY_LENGTH,
							0);
	CHECK_STATUS(Status);			

	Status = BCryptGenerateSymmetricKey(
							pProv->rc2_alg_handle,
							&pWriteKey->bcrypt_key_handle,
							pbWriteKeyObjectBuffer,
							cbWriteKeyObjectBuffer,
							pbWriteKey,
							CIPHER_SUITE_KEY_LENGTH,
							0);
	CHECK_STATUS(Status);

	
	Status = BCryptSetProperty(
						pReadKey->bcrypt_key_handle,
                        INITIALIZATION_VECTOR_PROPERTY,
                        pbReadIV,
                        BLOCK_LENGTH,
                        0);
	CHECK_STATUS(Status);

	Status = BCryptSetProperty(
						pWriteKey->bcrypt_key_handle,
                        INITIALIZATION_VECTOR_PROPERTY,
                        pbWriteIV,
                        BLOCK_LENGTH,
                        0);
	CHECK_STATUS(Status);

	// set the key object buffers
	pReadKey->pbKeyObjectBuffer = pbReadKeyObjectBuffer;
	pWriteKey->pbKeyObjectBuffer = pbWriteKeyObjectBuffer;

	// Set the macs
	memcpy(pReadKey->pbMac, pbReadMac, MD5_LENGTH);
	memcpy(pWriteKey->pbMac, pbWriteMac, MD5_LENGTH);

	// Write to passed in handles
	*phReadKey = (NCRYPT_KEY_HANDLE)pReadKey;
	*phWriteKey = (NCRYPT_KEY_HANDLE)pWriteKey;

	
	pbReadKeyObjectBuffer = NULL;
	pbWriteKeyObjectBuffer = NULL;
	pReadKey = NULL;
    pWriteKey = NULL;	

	Status = ERROR_SUCCESS;

cleanup:
	if(pbRandom) { FREE(pbRandom); }
	if(pbKeyBlock) { FREE(pbKeyBlock); }
	if(pReadKey) { SslFreeObject((NCRYPT_HANDLE)pReadKey, 0); }
	if(pWriteKey) { SslFreeObject((NCRYPT_HANDLE)pWriteKey, 0); }
	if(pbWriteKeyObjectBuffer) { FREE(pbWriteKeyObjectBuffer); }
	if(pbReadKeyObjectBuffer) { FREE(pbReadKeyObjectBuffer); }

	return Status;
}




////////////////////////////////////////////////////////
/////////////////  Helper Functions ////////////////////
////////////////////////////////////////////////////////

/** @helper_function PRF (Pseudo-Random Function)
  * @brief Derives the master key from the pre-master key, the seed and the label.
  *		   This is done via hashing a SHA1 and a MD5 hash from the above mentioned inputs.
  *
  *		   The hashing process consists of multiple parts: 
  *		   CreateHash -> HashData (x times) -> FinishHash
  *
  *		   CreateHash requires a buffer to be provided whose size is determined via a call to BCryptGetProperty
  *		   HashData will be called 3 times for each of the 2 hashes: 
  *		   Once for the pre-master key, once for the seed, and once for the label.
  *
  *		   Once the hashes are finalized, the master key is derived via an XOR of the two hashes.
  *
  * @param hSslProvider: The protocol provider handle needed to access the hashing algorithm handles.
  * @param pbPreMasterKey: A pointer to a buffer containing the pre-master key.
  * @param cbPreMasterKey: The byte size of the pre-master key buffer.
  * @param pbRandom: A pointer to a buffer containing the client and server randoms.
  * @param cbRandom: The byte size of the Seed buffer.
  * @param pbLabel: A "string" cast to a byte array whose inclusion in the hash enables the use of 
  *				    this hash for multiple tasks which will vary only by label name.
  * @param cbLabel: The byte size of the label.
  * @param pbOutput: A pointer to a buffer in which will be written the key material (master key, key block, etc).
  * @param cbOutput: The size of the passed pbOutput buffer.
  *
  * @return ERROR_SUCCESS on success. CHECK_STATUS(return_value) will fail if not.
  **/
SECURITY_STATUS
WINAPI
PRF(
	__in	NCRYPT_PROV_HANDLE hSslProvider,
	__in	PBYTE pbPreMasterKey,
	__in	DWORD cbPreMasterKey,
	__in	PBYTE pbRandom,
	__in	DWORD cbRandom,
	__in	PBYTE pbLabel,
	__in	DWORD cbLabel,
	__out_bcount(cbOutput)   PBYTE pbOutput,
	__in	DWORD cbOutput
	) {
		SECURITY_STATUS Status;
		DWORD i;
		DWORD cbSeed = 0;
		PBYTE pbSeed = NULL;
		DWORD cbHash_MD5 = 0, cbHash_SHA1 = 0;
		PBYTE pbHash_MD5 = NULL, pbHash_SHA1 = NULL;

		// Validate Parameters
		P_CUSTOM_PROTOCOL_PROVIDER pProv = HANDLE_TO_PROVIDER(hSslProvider);
		CHECK_POINTER(pbPreMasterKey);
		CHECK_POINTER(pbRandom);
		CHECK_POINTER(pbLabel);
		CHECK_POINTER(pbOutput);
		

		// Used when splitting the key into 2 halves
		DWORD cbOdd = cbPreMasterKey % 2;
		DWORD cbHalf= cbPreMasterKey / 2;

		// Prepend the label to the random to form the seed
		cbSeed = cbLabel + cbRandom;
		pbSeed = (PBYTE)MALLOC(cbSeed);
		CHECK_POINTER(pbSeed);
		memcpy(pbSeed, pbLabel, cbLabel);
		memcpy(pbSeed + cbLabel, pbRandom, cbRandom);



		// Allocate digest buffers for the hashes
		cbHash_MD5 = cbOutput + MD5_LENGTH;
		cbHash_SHA1 = cbOutput + SHA1_LENGTH;
		pbHash_MD5 = (PBYTE)MALLOC(cbOutput + MD5_LENGTH); 
		CHECK_POINTER(pbHash_MD5);
		pbHash_SHA1 = (PBYTE)MALLOC(cbOutput + SHA1_LENGTH);
		CHECK_POINTER(pbHash_SHA1);

		
		// Figure out how many times to iterate the hashes to produce cbOutput bytes of data
		DWORD iMD5, rMD5;
		DWORD iSHA1, rSHA1;
		rMD5 = cbOutput % MD5_LENGTH;
		iMD5 = (!rMD5) ? cbOutput / MD5_LENGTH : (cbOutput / MD5_LENGTH) + 1;
		rSHA1 = cbOutput % SHA1_LENGTH;
		iSHA1 = (!rSHA1) ? cbOutput / SHA1_LENGTH : (cbOutput / SHA1_LENGTH) + 1;


		// Get the cbOutput bytes of HMAC_MD5 hash
		Status = getIteratedHash(
			pProv, 
			MD5_LENGTH,
			iMD5,
			pbPreMasterKey, 
			cbHalf + cbOdd,
			pbSeed,
			cbSeed,
			pbHash_MD5,
			cbHash_MD5);
		CHECK_STATUS(Status);


		// Get the cbOutput bytes of HMAC_SHA1 hash
		Status = getIteratedHash(
			pProv, 
			SHA1_LENGTH,
			iSHA1,
			pbPreMasterKey + cbHalf, 
			cbHalf + cbOdd,
			pbSeed,
			cbSeed,
			pbHash_SHA1,
			cbHash_SHA1);
		CHECK_STATUS(Status);


		// XOR the two hashes together
		for(i = 0; i < cbOutput; ++i) {
			pbOutput[i] = pbHash_SHA1[i] ^ pbHash_MD5[i];	
		}

		
		Status = ERROR_SUCCESS;
cleanup:
		if(pbHash_SHA1) { FREE(pbHash_SHA1); }
		if(pbHash_MD5) { FREE(pbHash_MD5); }
		if(pbSeed) { FREE(pbSeed); }

		return Status;
}


/** @helper_function getIteratedHash
  * @brief Iterates the HMAC hash as defined by RFC 2246 in section 5 for a variable 
  *        number of iterations to produce an cbOutput bytes of hash data.
  * 
  * @param pProv: Provider which is used to get hash algorithm handles and sizes.
  * @param dwHashLength: Either MD5_LENGTH or SHA1_LENGTH. This is the length of the hash digest.
  * @param dwIterations: How many times to iterate the hash to get the correct number of bytes.
  * @param pbSecret: The key for HMAC.
  * @param cbSecret: The size of the buffer pointed to by pbSecret.
  * @param pbSeed: The seed used within the HMAC hash. 
  * @param cbSeed: The size of the buffer pointed to by pbSeed.
  * @param pbOutput: Where to write the hash values.
  * @param cbOutput: The size of the buffer pointed to by pbOutput.
  **/
SECURITY_STATUS
WINAPI
getIteratedHash(
			__in	P_CUSTOM_PROTOCOL_PROVIDER	pProv, 
			__in	DWORD						dwHashLength,
			__in	DWORD						dwIterations,
			__in_bcount(cbSecret) PBYTE			pbSecret, 
			__in	DWORD						cbSecret,
			__in_bcount(cbSeed) PBYTE			pbSeed,
			__in	DWORD						cbSeed,
			__out_bcount(cbOutput) PBYTE		pbOutput,
			__in	DWORD						cbOutput){
	SECURITY_STATUS Status;
	BCRYPT_HASH_HANDLE hHash = NULL;
	PBYTE pbHashObjectBuffer = NULL;
	DWORD i;


	// Check buffer size
	if(cbOutput < (dwHashLength * dwIterations)) {
		Status = NTE_BUFFER_TOO_SMALL;
		CHECK_STATUS(Status);
	}

	// Allocate memory for hash buffers
	DWORD cbHashObjectBuffer;
	BCRYPT_ALG_HANDLE hAlg = NULL;
	if(dwHashLength == MD5_LENGTH) {
		cbHashObjectBuffer = pProv->md5_hmac_obj_length;
		hAlg = pProv->md5_hmac_alg_handle;
	} else {
		cbHashObjectBuffer = pProv->sha1_hmac_obj_length;
		hAlg = pProv->sha1_hmac_alg_handle;
	}

	pbHashObjectBuffer = (PBYTE)MALLOC(cbHashObjectBuffer);
	CHECK_POINTER(pbHashObjectBuffer);

	BYTE pbHash[SHA1_LENGTH]; // Store on stack (SHA1_LENGTH is the max)
	DWORD cbHash = dwHashLength;


	// Hash and iterate as shown in RFC 2246 Section 5
	for(i = 0; i < dwIterations; ++i) {

		////////////////////////
		// Compute the A(i) hash
		////////////////////////
		Status = BCryptCreateHash(
					hAlg,
					&hHash,
					pbHashObjectBuffer,
					cbHashObjectBuffer,
					pbSecret,
					cbSecret,
					0);
		CHECK_STATUS(Status);

		
		if(!i) {
			// On first iteration hash the seed
			Status = BCryptHashData(
					hHash,
					pbSeed,
					cbSeed,
					0);
		} else {
			// On other iterations hash the previous hash
			Status = BCryptHashData(
					hHash,
					pbHash,
					cbHash,
					0);
		}
		CHECK_STATUS(Status);


		Status = BCryptFinishHash(
				hHash,
				pbHash,
				cbHash,
				0);
		CHECK_STATUS(Status);


		///////////////////////
		// Hash:   A(i) || SEED
		///////////////////////
		Status = BCryptCreateHash(
					hAlg,
					&hHash,
					pbHashObjectBuffer,
					cbHashObjectBuffer,
					pbSecret,
					cbSecret,
					0);
		CHECK_STATUS(Status);
		
		Status = BCryptHashData(
					hHash,
					pbHash,
					cbHash,
					0);
		CHECK_STATUS(Status);

		Status = BCryptHashData(
					hHash,
					pbSeed,
					cbSeed,
					0);
		CHECK_STATUS(Status);


		Status = BCryptFinishHash(
				hHash,
				pbOutput + (i * cbHash),
				cbHash,
				0);
		CHECK_STATUS(Status);

	}

	Status = ERROR_SUCCESS;
cleanup:
	if(hHash) { BCryptDestroyHash(hHash); }
	if(pbHashObjectBuffer) { FREE(pbHashObjectBuffer); }
	return Status;
}



/** @helper_function validateCommonArguments
  * @brief Since SslGenerateMasterKey and SslImportMasterKey have so many similar parameters,
  *		   this function validates all of their common parameters.
  **/
SECURITY_STATUS
WINAPI
validateCommonArguments(   
	   NCRYPT_PROV_HANDLE hProvider,
       NCRYPT_KEY_HANDLE hKey,
       DWORD   dwProtocol,
	   DWORD   dwCipherSuite,
       NCryptBufferDesc *pParameterList,
	   DWORD   dwFlags ) {
	SECURITY_STATUS Status;

	
	Status = validateProviderHandle(hProvider);
	CHECK_STATUS(Status);
	

	Status = validateKeyHandle(hKey);
	CHECK_STATUS(Status);
	

	CHECK_POINTER(pParameterList);
	

	if(dwProtocol != TLS1_PROTOCOL_VERSION) {
		return NTE_NOT_SUPPORTED;
	}
	
	
	if(dwCipherSuite != BASE_CIPHER_SUITE_CODE){
		return NTE_NOT_SUPPORTED;
	}
	

	if(!(dwFlags & NCRYPT_SSL_CLIENT_FLAG || dwFlags & NCRYPT_SSL_SERVER_FLAG)) {
		return NTE_BAD_FLAGS;
	}
	
	return ERROR_SUCCESS;
cleanup:
	return Status;
}

/** @helper_function getParameters
  * @brief Parses the buffers from pParameterList to obtain the server and client random values. 
  *		   Also obtains the highest version dw to prevent version fallback attacks.
  *
  * @param pParameterList: Contains many buffers but always contains the client and server randoms
  * @param pbClientRandom: pointer to client random is returned here.
  * @param cbClientRandom: size of client random is returned here.
  * @param pbServerRandom: pointer to server random is returned here.
  * @param cbServerRandom: size of server random is returned here.
  *
  * @return ERROR_SUCCESS on success
  * @return NTE_INVALID_PARAMETER if pParameterList has corrupt buffers
  **/ 
SECURITY_STATUS
WINAPI
getParameters(
	  __in  PNCryptBufferDesc	pParameterList, 
	  __out PVOID*				ppbClientRandom, 
	  __out DWORD*				pcbClientRandom, 
	  __out PVOID*				ppbServerRandom, 
	  __out DWORD*				pcbServerRandom,
	  __out DWORD*				pdwHighestVersion) {
	DWORD i;
	NCryptBuffer *pParameter;

	for(i = 0; i < pParameterList->cBuffers; ++i) {
		pParameter = pParameterList->pBuffers + i;

		if(pParameter->pvBuffer == NULL || pParameter->cbBuffer == 0) {
			return NTE_INVALID_PARAMETER;
		}

		switch(pParameter->BufferType) {
			case NCRYPTBUFFER_SSL_CLIENT_RANDOM:
				*ppbClientRandom = pParameter->pvBuffer;
				*pcbClientRandom = pParameter->cbBuffer;
            break;

			case NCRYPTBUFFER_SSL_SERVER_RANDOM:
				*ppbServerRandom = pParameter->pvBuffer;
				*pcbServerRandom = pParameter->cbBuffer;
            break;

			case NCRYPTBUFFER_SSL_HIGHEST_VERSION:
				if(pParameter->cbBuffer == sizeof(DWORD))
					*pdwHighestVersion = *(DWORD *)pParameter->pvBuffer;
				else 
					return NTE_INVALID_PARAMETER;
            break;
		}
	}

	return ERROR_SUCCESS;
}


/** @helper_function newMasterKeyObject
  * @brief Allocates memory and initializes a new MASTERKEY_OBJECT structure.
  *
  * @return Pointer to the structure on success
  * @return NULL if no more memory
  **/
P_MASTERKEY_OBJECT
WINAPI
newMasterKeyObject(DWORD dwClientServerFlag){
	
	if(dwClientServerFlag != MASTERKEY_SERVER_FLAG && dwClientServerFlag != MASTERKEY_CLIENT_FLAG) return NULL;
	
	P_MASTERKEY_OBJECT pMasterKeyObj = (P_MASTERKEY_OBJECT)MALLOC(sizeof(MASTERKEY_OBJECT));
	if(pMasterKeyObj == NULL) return NULL;
	

	pMasterKeyObj->cbLength = sizeof(MASTERKEY_OBJECT);
	pMasterKeyObj->dwHandleType = TYPE_MASTERKEY_OBJECT;
	pMasterKeyObj->dwClientOrServer = dwClientServerFlag;

	return pMasterKeyObj;
}

/** @helper_function validdateMasterKey
  * @brief Takes a handle to a master key and validates that it is in fact a handle to a valid master key structure
  *
  * @param hMasterKey: The handle to the master key to validate
  *
  * @return ERROR_SUCCESS if it is valid. NTE_INVALID_HANDLE otherwise.
  **/
SECURITY_STATUS
WINAPI
validateMasterKey(NCRYPT_KEY_HANDLE hMasterKey){
	P_MASTERKEY_OBJECT pMasterKey = HANDLE_TO_MASTERKEY(hMasterKey);

	if(!pMasterKey) return NTE_INVALID_HANDLE;
	if(pMasterKey->cbLength != sizeof(MASTERKEY_OBJECT)) return NTE_INVALID_HANDLE;
	if(pMasterKey->dwHandleType != TYPE_MASTERKEY_OBJECT) return NTE_INVALID_HANDLE;
	if(!pMasterKey->pbMasterKey) return NTE_INVALID_HANDLE;
	
	if(pMasterKey->dwClientOrServer != MASTERKEY_SERVER_FLAG && pMasterKey->dwClientOrServer != MASTERKEY_CLIENT_FLAG) return NTE_INVALID_HANDLE;


	return ERROR_SUCCESS;
}


P_SESSION_KEY_OBJECT
WINAPI
newSessionKey(DWORD keyObjectSize) {
	P_SESSION_KEY_OBJECT pSessionKeyObj = (P_SESSION_KEY_OBJECT)MALLOC(sizeof(SESSION_KEY_OBJECT));
	if(pSessionKeyObj == NULL) return NULL;

	pSessionKeyObj->cbLength = sizeof(SESSION_KEY_OBJECT);
	pSessionKeyObj->dwHandleType = TYPE_SESSION_KEY_OBJECT;
	
	if(keyObjectSize) {
		pSessionKeyObj->pbKeyObjectBuffer = (PBYTE)MALLOC(keyObjectSize);
		if(pSessionKeyObj->pbKeyObjectBuffer == NULL)
		{
			FREE(pSessionKeyObj);
			return NULL;
		}
	}
	
	return pSessionKeyObj;
}

SECURITY_STATUS
WINAPI
validateSessionKey(NCRYPT_KEY_HANDLE hSessionKey) {
	P_SESSION_KEY_OBJECT pSKey = HANDLE_TO_SESSION_KEY(hSessionKey);
	
	if(!pSKey) return NTE_INVALID_HANDLE;
	if(pSKey->cbLength != sizeof(SESSION_KEY_OBJECT)) return NTE_INVALID_HANDLE;
	if(pSKey->dwHandleType != TYPE_SESSION_KEY_OBJECT) return NTE_INVALID_HANDLE;
	if(!pSKey->bcrypt_key_handle) return NTE_INVALID_HANDLE;
	if(!pSKey->pbMac) return NTE_INVALID_HANDLE;

	return ERROR_SUCCESS;
}
