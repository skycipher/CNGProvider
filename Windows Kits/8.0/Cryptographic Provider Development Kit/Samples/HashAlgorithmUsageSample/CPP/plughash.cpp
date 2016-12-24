// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

/*****************************************************************************

Title: Using new hash algorithms to create self-signed certificate

This example shows how to use new hash algorithms to create a self-signed 
certificate.

Pre-requisites:
1. Create a DLL for the new hash provider and register it.
   For this step, please refer to the hash provider sample
   Copy the hash provider DLL to %windir%\System32\
2. Register the object identifiers for the new hash algorithms
   For this step, please refer to the register OID sample
   As an alternative, run the registerOID.reg file included in this sample
   This file is the resultant registry entries created by the register OID
   sample.
   
This sample code shows to encode the hash algorithm as part of the 
parameters passed to the signing algorithm using the CryptEncodeObject API.
It also illustrates how to create a ECC key using the NCrypt API

*****************************************************************************/
#define UNICODE 1

//Following functions will use their UNICODE equivalents
//CertStrToName : CertStrToNameW

// Indicate the name of the test hash algorithm
#define TEST_HASH_ALGORITHM_NAME   L"MD0HASH"

#include <stdio.h>
#include <windows.h>
#include <Wincrypt.h>
#include <ncrypt.h>
#include <bcrypt.h>

void MyHandleError(
    __in char *s);

NCRYPT_KEY_HANDLE MyCreateKey(
							  __in LPWSTR         wszContainerName,							                  
							  __in LPCWSTR        pwszAlgid,
							  __in LPCWSTR        pwszProvName
						  );

void __cdecl main(void)
{
//---------------------------------------------------------
// Declare and initialize variables.

	CERT_NAME_BLOB				SubjectName              = { 0 };
	NCRYPT_KEY_HANDLE			hNCryptKey				 = NULL;
	CRYPT_KEY_PROV_INFO			KeyProvInfo				 = { 0 };
	PCCRYPT_OID_INFO			pHashOIDInfo			 = NULL;
	CRYPT_ALGORITHM_IDENTIFIER	hashAlgorithm			 = { 0 };
	CRYPT_ALGORITHM_IDENTIFIER	signatureAlgorithm		 = { 0 };
	PCCERT_CONTEXT			    pcCertContext			 = NULL;
	BYTE*						pbEncodedParam			 = NULL;
	DWORD						cbEncodedParam			 = 0;
	HCERTSTORE					hStore					 = NULL;
    	
    if (!CertStrToName(
        CRYPT_ASN_ENCODING,        // Use X509_ASN_ENCODING
        L"CN=TEST_HASH_CERT",      // String to be encoded
        0,                         // Type of the string
        NULL,                      // Reserved for future use
        NULL,                      // Pointer to a buffer that receives the
                                   //  encoded structure; NULL to obtain the
                                   //  required size of the buffer
                                   //  for memory allocation purposes
        &SubjectName.cbData,       // Size, in bytes, required for the buffer
        NULL) )                    // Additional error information about 
                                   //  an invalid input string
    {
        MyHandleError("CertStrToName failed");
		goto done;
    }

    SubjectName.pbData = (PBYTE)LocalAlloc(LPTR, SubjectName.cbData);
	if (NULL == SubjectName.pbData) { 
        MyHandleError("SubjectName out of memory");
		goto done;
    }
    
    if (!CertStrToName(
            CRYPT_ASN_ENCODING,    // Use X509_ASN_ENCODING    
            L"CN=TEST_HASH_CERT",  // String to be encoded
            0,                     // Type of the string
            NULL,                  // Reserved for future use
            SubjectName.pbData,    // Pointer to a buffer that receives the
                                   //  encoded structure
            &SubjectName.cbData,   // Size, in bytes, required for the buffer
            NULL) )                // Additional error information about 
                                   //  an invalid input string
    {
        MyHandleError( "CertStrToName failed");
		goto done;
    }

 	hNCryptKey = MyCreateKey(
				  L"TestOIDInstECCKey",
                  BCRYPT_ECDSA_P256_ALGORITHM,
                  NULL);					//pwszProvName

	if(NULL == hNCryptKey)
	{
		MyHandleError("Key Generation failed");
		goto done;
	}
	else
	{
		printf_s("Successfully generated key.\n");
	}	
	
	memset( &KeyProvInfo, 0, sizeof( CRYPT_KEY_PROV_INFO ));

    KeyProvInfo.dwProvType        = 0;
    KeyProvInfo.dwKeySpec         = 0;
	KeyProvInfo.pwszProvName	  = MS_KEY_STORAGE_PROVIDER;
	KeyProvInfo.pwszContainerName = L"TestOIDInstECCKey";

	pHashOIDInfo = CryptFindOIDInfo(
		CRYPT_OID_INFO_NAME_KEY,      // The key type points to algorithm name 
		TEST_HASH_ALGORITHM_NAME,          // Algorithm Name
		CRYPT_HASH_ALG_OID_GROUP_ID   // Search group of hash algorithms according
                                      // to the dwKeyType
	);
	
	//pHashOIDInfo is a pointer to a constant structure and should not be freed.

	if(NULL == pHashOIDInfo)
	{
		MyHandleError( "Could not find OID Info");
		goto done;
	}
	else
	{
		printf_s("Found the new hash algorithm\n");
	}

	memset( &hashAlgorithm, 0, sizeof( CRYPT_ALGORITHM_IDENTIFIER ));
	hashAlgorithm.pszObjId = (LPSTR) pHashOIDInfo->pszOID;
	hashAlgorithm.Parameters.cbData = 0;

	memset( &signatureAlgorithm, 0, sizeof( CRYPT_ALGORITHM_IDENTIFIER ));
	signatureAlgorithm.pszObjId = szOID_ECDSA_SPECIFIED;
	
	if (!CryptEncodeObjectEx(
			X509_ASN_ENCODING,			// Use X509 ASN Encoding
			szOID_ECDSA_SPECIFIED,	
			&hashAlgorithm,				// Structure to be encoded
			CRYPT_ENCODE_ALLOC_FLAG,	// The called encoding function
										// allocates memory for encoded bytes
			0,							// Use LocalFree to free the
										// memory for the encoded bytes
			&pbEncodedParam,			// Buffer to receive encoded structure
			&cbEncodedParam				// Size, in bytes, of the buffer 
			))
	{
		MyHandleError( "CryptEncodeObjectEx failed");
		goto done;
	}
	else
	{
		signatureAlgorithm.Parameters.cbData = cbEncodedParam;
		signatureAlgorithm.Parameters.pbData = pbEncodedParam; 		
		printf_s("Included the new hash algorithm in the parameters\n");
	}

    // Here the hash algorithm is encoded in the parameters of the
	//	signature algorithm. Another way to do this is to use a combined OID
	//  of the hash algorithm and the public key algorithm. 
	// If the OID for the signature algorithm is a combined OID,
	// then there is no need pass the encoded algorithm in its parameters. 
	// In that case, the signature algorithm would look like
	//			signatureAlgorithm.pszObjId = combined_OID;
	//			signatureAlgorithm.Parameters.cbData = 0; //No Parameters
    
	pcCertContext = CertCreateSelfSignCertificate(
                    NULL,				  // Use information from pKeyProvInfo
										  //  parameter to acquire the handle
										  //  to cryptographic provider
                    &SubjectName,		  // Pointer to a BLOB containing the
										  //  distinguished name (DN) for 
										  //  the certificate subject
                    0,					  // No flags: use default behavior
                    &KeyProvInfo,		  // Key provider information 
                    &signatureAlgorithm,  // Use default signature algorithm
                    NULL,				  // Start time : Use the system 
										  //  current time by default
                    NULL,				  // End time : Use start time plus
										  //  one year by default
                    NULL				  // Array of extensions
                    );
    if (NULL == pcCertContext) { 
        MyHandleError( "CertCreateSelfSignCertificate failed");
		goto done;
    }
	else {	
		printf_s("Successfully Created Certificate.\n");
	}

    hStore = CertOpenStore(
                   CERT_STORE_PROV_SYSTEM,         // the store provider type
                   0,                              // encoding type not needed
                   NULL,                           // use default HCRYPTPROV
                   CERT_SYSTEM_STORE_CURRENT_USER, // set the store location  
                                                   //  in a registry location
                   L"TrustedPeople");              // the store name 
    if (NULL == hStore) {
        MyHandleError( "CertOpenStore failed");
		goto done;
    }

    if (!CertAddCertificateContextToStore(
            hStore,                    // Handle of the certificate store
            pcCertContext,             // Pointer to CERT_CONTEXT structure
                                       //  to be added to the store
            CERT_STORE_ADD_NEW,        // Fail if matching certificate or link 
                                       //  to a matching certificate exists.
            NULL)                      // Calling application does not require
                                       //  a copy of the added certificate
			)
    {
        MyHandleError( "CertAddCertificateContextToStore failed");
		goto done;
    }
	else	
	{
		printf_s("Added certificate to Trusted People Store.\n");
	}
	
	//---------------------------------------------------------
	// Cleanup
done:
    if (NULL != hStore) { 
        CertCloseStore( hStore, 0 );
    }
    if (NULL != SubjectName.pbData) { 
        LocalFree(SubjectName.pbData);
    } 
	if (NULL != signatureAlgorithm.Parameters.pbData) { 
        LocalFree(signatureAlgorithm.Parameters.pbData);
    }    
	if (NULL != pcCertContext) {
        CertFreeCertificateContext(pcCertContext);
    }
	if (NULL !=  hNCryptKey) {
		NCryptFreeObject(hNCryptKey);
	}
	printf_s("End of Program.\n");
	
} // end main

// Function to create an ECC key
// This function uses the NCrypt API to open the storage provider
//  and create the key
// It handles the errors which this API might throw
NCRYPT_KEY_HANDLE MyCreateKey(
                              __in LPWSTR         wszContainerName,                                                
                              __in LPCWSTR        pwszAlgid,
                              __in LPCWSTR        pwszProvName                             
                            )
{
      NCRYPT_PROV_HANDLE hProvider = NULL;
      NCRYPT_KEY_HANDLE hKey = NULL;
      SECURITY_STATUS Status;

      char szErr[100];

      Status = NCryptOpenStorageProvider(
            &hProvider,
            NULL != pwszProvName ? pwszProvName : MS_KEY_STORAGE_PROVIDER,
            0           // dwFlags
            );
      if (0 != Status) {
            sprintf_s(szErr, 100, "NCryptOpenStorageProvider failed"
				" 0x%x (%d) \n", Status, Status);
            goto ErrorReturn;
      }

      Status = NCryptOpenKey(
            hProvider,
            &hKey,
            wszContainerName,
            0,					// dwLegacyKeySpec
            0					// dwFlags
            );
      if (0 == Status) {
            Status = NCryptDeleteKey(
                  hKey,
                  0                   // dwFlags
                  );
            hKey = NULL;
            if (0 != Status) {
                  sprintf_s(szErr, 100, "NCryptDeleteKey failed"
					  " 0x%x (%d) \n", Status, Status);
                  goto ErrorReturn;
            }
      } 

      Status = NCryptCreatePersistedKey(
            hProvider,
            &hKey,
            pwszAlgid,
            wszContainerName,
            0,						// dwLegacyKeySpec
            0						// dwFlags
            );
      if (0 != Status) {
            sprintf_s(szErr, 100, "NCryptCreatePersistedKey failed"
				" 0x%x (%d) \n", Status, Status);
            goto ErrorReturn;
      }

      Status = NCryptFinalizeKey(
            hKey,
            0                   // dwFlags
            );

      if (0 != Status) {
            sprintf_s(szErr, 100, "NCryptFinalizeKey failed"
				" 0x%x (%d) \n", Status, Status);
            goto ErrorReturn;
      }

CommonReturn:
      if (NULL != hProvider) {
            Status = NCryptFreeObject(hProvider);
            if (0 != Status){
                  sprintf_s(szErr, 100, "NCryptFreeObject(hProvider) failed"
					  " 0x%x (%d) \n", Status, Status);
            }
      }

      return hKey;

ErrorReturn:
      if (NULL != hKey) {
            Status = NCryptFreeObject(hKey);
            if (0 != Status){
                  sprintf_s(szErr, 100, "NCryptFreeObject(hKey) failed"
					  " 0x%x (%d) \n", Status, Status);
            }
            hKey = NULL;
      }
      printf_s("MyCreateKey: %s", szErr ) ;
      goto CommonReturn;
}

//-------------------------------------------------------------------
//  This example uses the function MyHandleError, a simple error
//  reporting function, to print an error message corresponding 
//  to the error that occured. 
//  For most applications, replace this function with one 
//  that does more extensive error reporting.

void MyHandleError(
    __in char *s)
{
    DWORD dwErr = GetLastError();
    LPVOID lpMsgBuf;
    printf_s("An error occurred in running the program. \n");
    printf_s("%s\n",s);
    printf_s("Error number %x : ", dwErr);
    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | 
        FORMAT_MESSAGE_FROM_SYSTEM,
        NULL,                                       // Location of message
                                                    //  definition ignored
        dwErr,                                      // Message identifier for
                                                    //  the requested message    
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),  // Language identifier for
                                                    //  the requested message
        (LPTSTR) &lpMsgBuf,                         // Buffer that receives
                                                    //  the formatted message
        0,                                          // Size of output buffer
                                                    //  not needed as allocate
                                                    //  buffer flag is set
        NULL );                                     // Array of insert values
    printf_s( "%S\n",lpMsgBuf);
    printf_s( "Program terminating. \n");
    LocalFree(lpMsgBuf);

} // end MyHandleError
