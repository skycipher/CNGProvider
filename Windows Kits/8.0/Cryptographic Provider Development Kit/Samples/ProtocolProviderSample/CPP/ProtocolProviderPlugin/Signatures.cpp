/** @file Signatures.cpp
  * @brief Contains the implementation of the functions SslVerifySignature and SslSignHash
**/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"


/** @function SslVerifySignature
  * @brief Verifies a signature with the passed hash and public key.
  * 
  * @param hSslProvider: The protocol provider handle.
  * @param hPublicKey: The public key used in the verification process.
  * @param pbHashValue: A pointer to the hash used in the verification process.
  * @param cbHashValue: The size in bytes of the hash value
  * @param pbSignature: The signature to verify.
  * @param cbSignature: The size in bytes of the signature.
  * @param dwFlags: Not used.
  **/
SECURITY_STATUS
WINAPI
SslVerifySignature(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hPublicKey,
    __in_bcount(cbHashValue) PBYTE pbHashValue,
    __in    DWORD   cbHashValue,
    __in_bcount(cbSignature) PBYTE pbSignature,
    __in    DWORD   cbSignature,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	NTSTATUS Status;
    BCRYPT_PKCS1_PADDING_INFO PKCS1PaddingInfo= {0};
    DWORD dwPaddingFlags = NCRYPT_PAD_PKCS1_FLAG;

    // Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

	Status = validateKeyHandle(hPublicKey);
	CHECK_STATUS(Status);


	CHECK_POINTER(pbHashValue);
	CHECK_POINTER(pbSignature);

	// Verify Signature
	P_KEY_OBJECT pPublicKey = HANDLE_TO_KEY(hPublicKey);
    Status = NCryptVerifySignature(
					pPublicKey->ncrypt_key_handle,
                    &PKCS1PaddingInfo,
                    pbHashValue,
                    cbHashValue,
                    pbSignature,
                    cbSignature,
					dwPaddingFlags);
	CHECK_STATUS(Status);


	return ERROR_SUCCESS;
cleanup:
    return Status;
}


/** @function SslSignHash
  * @brief Signs the passed in hash with the private key specified by the passed
  *		   in key handle.
  * 
  * @param hSslProvider: The protocol provider handle.
  * @param hPrivateKey: The private key used to sign the hash.
  * @param pbHashValue: A pointer to the hash to be signed.
  * @param cbHashValue: The size in bytes of the hash value
  * @param pbSignature: Where the signed hash will be written to
  * @param cbSignature: The size in bytes of the signed hash.
  * @param pcbResult: The size in bytes of the data written to pbSignature
  * @param dwFlags: Not used.
  **/
SECURITY_STATUS
WINAPI
SslSignHash(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __in    NCRYPT_KEY_HANDLE hPrivateKey,
    __in_bcount(cbHashValue) PBYTE pbHashValue,
    __in    DWORD   cbHashValue,
    __out_bcount_part_opt(cbSignature, *pcbResult) PBYTE pbSignature,
    __in    DWORD   cbSignature,
    __out   DWORD * pcbResult,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	NTSTATUS Status;
    BCRYPT_PKCS1_PADDING_INFO PKCS1PaddingInfo= {0};
    DWORD dwPaddingFlags = NCRYPT_PAD_PKCS1_FLAG;

    // Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

	Status = validateKeyHandle(hPrivateKey);
	CHECK_STATUS(Status);

	CHECK_POINTER(pbHashValue);
	CHECK_POINTER(pbSignature);
	CHECK_POINTER(pcbResult);


	// Sign the hash
	P_KEY_OBJECT pPrivateKey = HANDLE_TO_KEY(hPrivateKey);
    Status = NCryptSignHash(
					pPrivateKey->ncrypt_key_handle,
                    &PKCS1PaddingInfo,
                    pbHashValue,
                    cbHashValue,
                    pbSignature,
                    cbSignature,
                    pcbResult,
                    dwPaddingFlags);
	CHECK_STATUS(Status);


	return ERROR_SUCCESS;
cleanup:
    return Status;
}