/** @file Packets.cpp
  * @brief Contains the implementation of the functions SslEncryptPacket and SslDecryptPacket
**/

#include "stdafx.h"
#include "ProtocolProviderPlugin.h"
#include "MasterKey.h"



ULONGLONG
WINAPI
littleToBigEndian(ULONGLONG Source);


SECURITY_STATUS
WINAPI
computeMAC(
	__in	NCRYPT_PROV_HANDLE			hSslProvider,
	__in	NCRYPT_KEY_HANDLE			hKey,
	__in_bcount(cbMacBuffer1)	PBYTE	pbMacBuffer1, 
	__in	DWORD						cbMacBuffer1, 
	__in_bcount(cbMacBuffer2)	PBYTE	pbMacBuffer2, 
	__in	DWORD						cbMacBuffer2, 
	__out_bcount(cbMacOutput)	PBYTE	pbMacOutput, 
    __in	DWORD						cbMacOutput);



/** @function SslEncryptPacket
  * @brief Encrypts a single SSL packet using the provided key. 
  *		   This function complies to the packet format for TLS as defined
  *		   in RFC 2246. 
  *
  * @param hSslProvider: Handle to the protocol provider being used.
  * @param hKey: Handle to the session write key used to encrypt the application data.
  * @param pbInput: A pointer to the buffer containing the application data to be ecrypted in this packet.
  * @param cbInput: The size in bytes of the buffer pointed to by pbInput.
  * @param pbOutput: A pointer to the buffer where SslEncryptPacket will write the encrypted packet.
  * @param cbOutput: The size in bytes of the buffer pointed to by pbOutput.
  * @param pcbResult: SslEncryptPacket will write exactly how many bytes were actually written to pbOutput here.
  * @param SequenceNumber: The sequence number that should correspond to this packet. (Incorporated into a MAC such that an attacker cannot perform an Out-Of-Order attack.)
  * @param dwContentType: The type of packet that this will be. This will be the first byte in the header. (as defined by the TLS RFC #2246)
  * @param dwFlags: No flags currently defined.
  *
  * @return ERROR_SUCCESS on success.
  **/
SECURITY_STATUS
WINAPI
SslEncryptPacket(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __inout NCRYPT_KEY_HANDLE hKey,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    ULONGLONG SequenceNumber,
    __in    DWORD   dwContentType, 
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);

	SECURITY_STATUS Status;

	// Validate Parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

    Status = validateSessionKey(hKey);
	CHECK_STATUS(Status);

	CHECK_POINTER(pbInput);
	CHECK_POINTER(pbOutput);
	CHECK_POINTER(pcbResult);

	if(cbInput == 0 || cbInput > MAX_PACKET_SIZE)
    {
        Status = NTE_INVALID_PARAMETER;
        CHECK_STATUS(Status);
    }


	/**
     *	TLS Packet Format:
	 *	{
	 *		header (5 bytes)			[un-encrypted]
	 *		input data (cbInput bytes)	[encrypted]
	 *		hash (16 bytes)				[encrypted]
	 *		padding (0 - 15 bytes)		[encrypted]
	 *	}
	 **/
	DWORD cbHeader, cbMAC, cbPadding, cbPayload;
	
	cbHeader = SSL3_RECORD_HEADER_LENGTH;
	cbMAC = MAC_LENGTH;

	// Set cbPadding to whatever value makes (cbInput + cbMAC + cbPadding) divisible by BLOCK_LENGTH
	cbPadding = BLOCK_LENGTH - ((cbInput + cbMAC) % BLOCK_LENGTH);
	cbPayload = cbInput + cbMAC + cbPadding;

	// Make sure the given output buffer can hold the whole message
	if(cbOutput < (cbPayload + cbHeader)) {
		Status = NTE_BUFFER_TOO_SMALL;
		CHECK_STATUS(Status);
	}

	/**		Header: 
	  *		{
	  *			Byte 1: Content Type
	  *			Byte 2: Protocol Version Number (most significant byte)
	  *			Byte 3: Protocol Version Number (least significant byte)
	  *			Byte 4: Size of Packet (most significant byte)
	  *			Byte 5: Size of Packet (least significant byte)
	  *		}
	  **/
    pbOutput[0] = (BYTE)dwContentType;
    pbOutput[1] = (BYTE)(TLS1_PROTOCOL_VERSION >> 8);
    pbOutput[2] = (BYTE)(TLS1_PROTOCOL_VERSION & 0xff);
    pbOutput[3] = (BYTE)(cbPayload >> 8);
    pbOutput[4] = (BYTE)(cbPayload & 0xff);

	
	// Figure out if the output buffer is different from the input buffer
	// If they are the same, then can do encryption in place
	if(pbInput != pbOutput + cbHeader) {

		// Make sure the buffers don't overlap
		if((pbOutput >= pbInput  && pbOutput < pbInput  + cbInput) ||
           (pbInput  >= pbOutput && pbInput  < pbOutput + cbOutput)){
				Status = NTE_BUFFERS_OVERLAP;
				CHECK_STATUS(Status);
        }

		// Copy the input into the output buffer
		memcpy(pbOutput + cbHeader, pbInput, cbInput);
	}


	/* Compute the MAC for the data:
	 *	{
	 *		Sequence Number (ULONGLONG), 
	 *		Content Type (1 BYTE), 
	 *		Version Number (2 BYTES), 
	 *		Payload (2 BYTES), 
	 *		Input Data (cbInput BYTES)
	 *	}
	 *
	 * Break the above into 2 seperate buffers for efficiency.
	 **/
	
	// Buffer 1: Input Data (all the data already in the buffer)
	//
	PBYTE pbMacBuffer1 = pbInput;
	DWORD cbMacBuffer1 = cbInput;
	
	
	// Buffer 2: Everything Else
	//
	BYTE macBuffer2[MAC_BUFFER_2_SIZE];
	PBYTE pbMacBuffer2 = macBuffer2;
	DWORD cbMacBuffer2 = MAC_BUFFER_2_SIZE;

	// Fill in the 2nd mac buffer
	*(ULONGLONG*)pbMacBuffer2 = littleToBigEndian(SequenceNumber);
	memcpy((BYTE*)pbMacBuffer2 + sizeof(ULONGLONG), pbOutput, cbHeader);


	// Compute the MAC over the 2 input buffers:
	Status = computeMAC(hSslProvider,
						hKey,
						pbMacBuffer1, 
						cbMacBuffer1, 
						pbMacBuffer2, 
						cbMacBuffer2, 
						pbOutput+cbHeader+cbInput, 
						cbMAC);
	CHECK_STATUS(Status);

	// Set the padding
	memset(pbOutput+cbHeader+cbInput+cbMAC,
		   cbPadding-1,
		   cbPadding);
	
	// Encrypt the packet
	DWORD cbResult;
	P_SESSION_KEY_OBJECT pKey = HANDLE_TO_SESSION_KEY(hKey);
	Status = BCryptEncrypt(
					pKey->bcrypt_key_handle,
                    pbOutput + cbHeader,
                    cbPayload,
                    NULL,
                    NULL,
                    0,
                    pbOutput + cbHeader,
                    cbPayload,
                    &cbResult,
					0);
	if(cbResult != cbPayload) Status = NTE_FAIL;
	CHECK_STATUS(Status); 

	*pcbResult = cbHeader + cbPayload;

	return ERROR_SUCCESS;
cleanup:
	return Status;
}



/** @function SslDecryptPacket
  * @brief Decrypts a single SSL packet using the provided key.
  *
  * @param hSslProvider: The handle to the protocol provider being used.
  * @param hKey: The handle to the key used to decrypt the packet.
  * @param pbInput: The buffer containing the packet to be decrypted.
  * @param cbInput: The size in bytes of the buffer pointed to by pbInput
  * @param pbOutput: Where to write the decrypted packet.
  * @param cbOutput: The size of the buffer pointed to by pbOutput.
  * @param pcbResult: The number of bytes written into pbOutput.
  * @param SequenceNumber: The sequence number that should correspond to this packet. 
  * @param dwFlags: Not used.
  *
  */
SECURITY_STATUS
WINAPI
SslDecryptPacket(
    __in    NCRYPT_PROV_HANDLE hSslProvider,
    __inout NCRYPT_KEY_HANDLE hKey,
    __in_bcount(cbInput) PBYTE pbInput,
    __in    DWORD   cbInput,
    __out_bcount_part_opt(cbOutput, *pcbResult) PBYTE pbOutput,
    __in    DWORD   cbOutput,
    __out   DWORD * pcbResult,
    __in    ULONGLONG SequenceNumber,
    __in    DWORD   dwFlags)
{
	UNREFERENCED_PARAMETER(dwFlags);
	SECURITY_STATUS Status;

	// Validate parameters
	Status = validateProviderHandle(hSslProvider);
	CHECK_STATUS(Status);

	Status = validateSessionKey(hKey);
	CHECK_STATUS(Status);
	CHECK_POINTER(pbInput);
	if(cbInput <= 0) {
		Status = NTE_INVALID_PARAMETER;
		CHECK_STATUS(Status);
	}
	CHECK_POINTER(pbOutput);
	CHECK_POINTER(pcbResult);


	/**
     *	TLS Packet Format:
	 *	{
	 *		header (5 bytes)			[un-encrypted]
	 *		input data (cbInput bytes)	[encrypted]
	 *		hash (16 or 20 bytes)		[encrypted]
	 *		padding (0 - 15 bytes)		[encrypted]
	 *	}
	 **/ 
	
	// Validate and process header
	/**		Header: 
	  *		{
	  *			Byte 1: Content Type
	  *			Byte 2: Protocol Version Number (most significant byte)
	  *			Byte 3: Protocol Version Number (least significant byte)
	  *			Byte 4: Size of Packet (most significant byte)
	  *			Byte 5: Size of Packet (least significant byte)
	  *		}
	  **/
	DWORD cbHeader = SSL3_RECORD_HEADER_LENGTH;
	if(cbHeader > cbInput) {
		Status = NTE_BAD_DATA;
		CHECK_STATUS(Status);
	}

	DWORD dwContentType, dwVersion, cbPayload;
	dwContentType = pbInput[0];
	dwVersion = (pbInput[1] << 8) | pbInput[2];
	cbPayload = (pbInput[3] << 8) | pbInput[4];


	if(dwVersion != TLS1_PROTOCOL_VERSION) {
		Status = NTE_BAD_DATA;
		CHECK_STATUS(Status);
	}

	if(cbPayload + cbHeader != cbInput || cbPayload % BLOCK_LENGTH) {
		Status = NTE_BAD_DATA;
		CHECK_STATUS(Status);
	}

	// Figure out if the output buffer is different from the input buffer
	// If they are properly aligned, then can do decryption in place
	if(pbInput + cbHeader != pbOutput) {

		// Make sure the buffers don't overlap
		if((pbOutput >= pbInput  && pbOutput < pbInput  + cbInput) ||
           (pbInput  >= pbOutput && pbInput  < pbOutput + cbOutput)){
				Status = NTE_BUFFERS_OVERLAP;
				CHECK_STATUS(Status);
        }

		if(cbPayload > cbOutput) {
			Status = NTE_BUFFER_TOO_SMALL;
			CHECK_STATUS(Status);
		}

		// Copy the input into the output buffer so we can just decrypt in place
		memcpy(pbOutput, pbInput + cbHeader, cbPayload);
	}


	// Decrypt packet
	P_SESSION_KEY_OBJECT pKey = HANDLE_TO_SESSION_KEY(hKey);
	Status = BCryptDecrypt(
						pKey->bcrypt_key_handle,
                        pbOutput,
                        cbPayload,
                        NULL,
                        NULL,       // IV
                        0,          // IV length
                        pbOutput,
                        cbOutput,
                        &cbPayload,
                        0);
	CHECK_STATUS(Status);

	
	// Strip the padding
	DWORD cbPadding = pbOutput[cbPayload-1] + 1;
	cbPayload -= cbPadding;


	// Strip the MAC
	if(cbPayload < MAC_LENGTH) {
		Status = NTE_DECRYPTION_FAILURE;
		CHECK_STATUS(Status);
	}
	cbPayload -= MAC_LENGTH;
	PBYTE pbMac1 = pbOutput + cbPayload;


	// Compute the new mac for a mac comparison
	
	// Buffer 1: plain text data
	PBYTE pbMacBuffer1 = pbOutput;
	DWORD cbMacBuffer1 = cbPayload;

	// Buffer 2: Sequence number, header
	BYTE bMacBuffer2[MAC_BUFFER_2_SIZE];
	PBYTE pbMacBuffer2 = bMacBuffer2;
	DWORD cbMacBuffer2 = MAC_BUFFER_2_SIZE;

	*(ULONGLONG*)pbMacBuffer2 = littleToBigEndian(SequenceNumber);
	memcpy((BYTE*)pbMacBuffer2 + sizeof(ULONGLONG), pbInput, cbHeader);

	BYTE pbMac2[MAC_LENGTH];
	Status = computeMAC(
					hSslProvider,
					hKey,
					pbMacBuffer1, 
					cbMacBuffer1, 
					pbMacBuffer2, 
					cbMacBuffer2, 
					pbMac2, 
					MAC_LENGTH);
	CHECK_STATUS(Status);

	// Make sure the MACs are the same
	if(memcmp(pbMac1, pbMac2, MAC_LENGTH)) {
		Status = NTE_DECRYPTION_FAILURE;
        CHECK_STATUS(Status);
	}

	*pcbResult = cbPayload;

	return ERROR_SUCCESS;
cleanup:
	return Status;
}


////////////////////////////////////////
//////// Helper Functions /////////////
//////////////////////////////////////

ULONGLONG
WINAPI
littleToBigEndian(ULONGLONG Source) {
	ULONGLONG swapped;

    swapped = ((Source)                      << (8 * 7)) |
              ((Source & 0x000000000000FF00) << (8 * 5)) |
              ((Source & 0x0000000000FF0000) << (8 * 3)) |
              ((Source & 0x00000000FF000000) << (8 * 1)) |
              ((Source & 0x000000FF00000000) >> (8 * 1)) |
              ((Source & 0x0000FF0000000000) >> (8 * 3)) |
              ((Source & 0x00FF000000000000) >> (8 * 5)) |
              ((Source)                      >> (8 * 7));

    return swapped;
}

SECURITY_STATUS
WINAPI
computeMAC(
	__in	NCRYPT_PROV_HANDLE			hSslProvider,
	__in	NCRYPT_KEY_HANDLE			hKey,
	__in_bcount(cbMacBuffer1)	PBYTE	pbMacBuffer1, 
	__in	DWORD						cbMacBuffer1, 
	__in_bcount(cbMacBuffer2)	PBYTE	pbMacBuffer2, 
	__in	DWORD						cbMacBuffer2, 
	__out_bcount(cbMacOutput)	PBYTE	pbMacOutput, 
    __in	DWORD						cbMacOutput)
{
	SECURITY_STATUS Status = ERROR_SUCCESS;
	BCRYPT_HASH_HANDLE hHMAC = NULL;
	
	
	P_CUSTOM_PROTOCOL_PROVIDER pProv = HANDLE_TO_PROVIDER(hSslProvider);
	P_SESSION_KEY_OBJECT pKey = HANDLE_TO_SESSION_KEY(hKey);


	// Allocate enough memory for the HMAC hash object
	PBYTE pbMacObject = (PBYTE)MALLOC(pProv->md5_hmac_obj_length);
	CHECK_POINTER(pbMacObject);


	// Create the hash
    Status = BCryptCreateHash(
						pProv->md5_hmac_alg_handle,
                        &hHMAC,
                        pbMacObject,
						pProv->md5_hmac_obj_length,
                        pKey->pbMac, 
                        MD5_LENGTH, 
                        0);
	CHECK_STATUS(Status);

	// Hash the 2 buffers. (in reverse order)
	Status = BCryptHashData(hHMAC, pbMacBuffer2, cbMacBuffer2, 0);
	CHECK_STATUS(Status);

	Status = BCryptHashData(hHMAC, pbMacBuffer1, cbMacBuffer1, 0);
	CHECK_STATUS(Status);


	// Write the hash to the output buffers
	Status = BCryptFinishHash(
                        hHMAC, 
                        pbMacOutput,
                        cbMacOutput,
                        0);
	CHECK_STATUS(Status);

	Status = ERROR_SUCCESS;
cleanup:
	if(hHMAC) {
		BCryptDestroyHash(hHMAC);
	}
	if(pbMacObject) { FREE(pbMacObject); }

	return Status;
}