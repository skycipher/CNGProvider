// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

/****************************************************************

Title: Registering new hash algorithms 

This example shows how to install OIDs for new hash algorithms.

This is one of the steps of extending CAPI2 to support new hash algorithms.

To plug in a new hash algorithm, the users need to do the following:

1. Create a DLL for the new hash provider and register it. 
   For this step, please refer to the hash provider sample.
2. Register the object identifiers for the new hash algorithms
   This is shown in this sample.
3. Use the new hash algorithm for a crypto functionality such as
   signing a certificate.
   For this step, please refer to the Plugging new hash algorithms sample.

This example illustrates how to create registry entries for the new OIDs
The entry points to the DllRegisterServer and DllUnregisterServer APIs 
are exported in the registerOID.def file.

When built, this sample will create registerOID.dll

Run "regsvr32.exe registerOID.dll" to register this dll. This will
install the OIDs for the new algorithms, so that CAPI2 will recognize 
these OIDs if they are encountered in a certificate.

The resultant registry entries are included in this sample in the file
registerOID.reg

****************************************************************/

// Need the following to enable the pwszCNGAlgid and pwszCNGExtraAlgid 
// members in CRYPT_OID_INFO data structure
#define CRYPT_OID_INFO_HAS_EXTRA_FIELDS 1

#include <windows.h>
#include <wincrypt.h>

// Indicate the hash algorithm OID
// Note that this is a test OID for the purposes of this sample only
#define szOID_MD0				"1.3.6.1.4.1.311.10.15.1.2"

// Indicate the test hash algorithm
#define TEST_HASH_ALGORITHM     L"MD0"

// Indicate the combined OID for hash and public key 
// Note that this is a test OID for the purposes of this sample only
#define szOID_MD0ECC            "1.3.6.1.4.1.311.10.15.1.4"


BOOL
WINAPI
DllMain(
        __in HMODULE hModule,
        __in ULONG  ulReason,
        __in_opt LPVOID lpReserved)
{
    return true;

    UNREFERENCED_PARAMETER(hModule);
    UNREFERENCED_PARAMETER(ulReason);
    UNREFERENCED_PARAMETER(lpReserved);

}

// Helper function for converting a CAPI2 LastError to a HRESULT.
static
HRESULT
HError()
{
    DWORD dw = GetLastError();

    HRESULT hr;
    if ( dw <= 0xFFFF )
        hr = HRESULT_FROM_WIN32 ( dw );
    else
        hr = dw;

    if ( ! FAILED ( hr ) )
    {
        // Call failed without correct error condition set.
        hr = E_UNEXPECTED;
    }
    return hr;
}

// DllRegisterServer API instructs an in-process server to create its
//  registry entries for all classes supported in the server module
// We use it here to register the MD0 and the MD0ECC algorithms
// This entry-point is exported in the module definition file registerOID.def
//  for use by regsvr32.exe
STDAPI DllRegisterServer(void)
{                
        // Register the MD0 Hash Algorithm
        CRYPT_OID_INFO MD0HashOIDInfo;
        memset(&MD0HashOIDInfo, 0, sizeof(MD0HashOIDInfo));

        MD0HashOIDInfo.cbSize = sizeof(MD0HashOIDInfo);
        MD0HashOIDInfo.pszOID = szOID_MD0; //New OID for the Hash Alg.
        MD0HashOIDInfo.pwszName = L"MD0HASH";
		MD0HashOIDInfo.dwGroupId = CRYPT_HASH_ALG_OID_GROUP_ID;
        MD0HashOIDInfo.Algid = CALG_OID_INFO_CNG_ONLY;
        MD0HashOIDInfo.pwszCNGAlgid = TEST_HASH_ALGORITHM;

		//  Register OID information. The OID information specified in the
		//  CRYPT_OID_INFO structure is persisted to the registry.
        if (!CryptRegisterOIDInfo(
                &MD0HashOIDInfo,
                0                       // dwFlags
                ))
            return HError();

		// In the registry this information will appear as follows:
		// [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography\OID\
		//  EncodingType 0\CryptDllFindOIDInfo\1.3.6.1.4.1.311.10.15.1.1!1]
		// "Name"="MD0HASH"
		// "Algid"=dword:ffffffff
		// "CNGAlgid"="MD0"

        // Register the MD0ECC Signature Algorithm
        CRYPT_OID_INFO MD0HashECCOIDInfo;
        const DWORD aiECCPubKey = CALG_OID_INFO_PARAMETERS;
       
        memset(&MD0HashECCOIDInfo, 0, sizeof(MD0HashECCOIDInfo));

        MD0HashECCOIDInfo.cbSize = sizeof(MD0HashECCOIDInfo);
        MD0HashECCOIDInfo.pszOID = szOID_MD0ECC;
        MD0HashECCOIDInfo.pwszName = L"MD0ECC";
        MD0HashECCOIDInfo.dwGroupId = CRYPT_SIGN_ALG_OID_GROUP_ID;

        // Hash Algid
        MD0HashECCOIDInfo.Algid = CALG_OID_INFO_CNG_ONLY;
        MD0HashECCOIDInfo.pwszCNGAlgid = TEST_HASH_ALGORITHM;

        // Public Key Algid
        MD0HashECCOIDInfo.ExtraInfo.cbData = sizeof(aiECCPubKey);
        MD0HashECCOIDInfo.ExtraInfo.pbData = (BYTE *) &aiECCPubKey;
        MD0HashECCOIDInfo.pwszCNGExtraAlgid = 
			CRYPT_OID_INFO_ECC_PARAMETERS_ALGORITHM;

        if (!CryptRegisterOIDInfo(
                &MD0HashECCOIDInfo,
                CRYPT_INSTALL_OID_INFO_BEFORE_FLAG	// Install registered OID
													// information before 
													// crypt32.dll OID entries
                ))
            return HError();

        return S_OK;
}

// DllUnregisterServer API instructs an in-process server to remove only 
//  those entries created through DllRegisterServer
// We use it to unregister the OIDs
// To unregister run "regsvr32.exe /u registerOID.dll"

STDAPI DllUnregisterServer(void)
{                       
        // Unregister the MD0 Hash Algorithm   
        CRYPT_OID_INFO MD0HashOIDInfo;
        memset(&MD0HashOIDInfo, 0, sizeof(MD0HashOIDInfo));

        MD0HashOIDInfo.cbSize = sizeof(MD0HashOIDInfo);
        MD0HashOIDInfo.pszOID = szOID_MD0;
        MD0HashOIDInfo.dwGroupId = CRYPT_HASH_ALG_OID_GROUP_ID;

        if (!CryptUnregisterOIDInfo(
                &MD0HashOIDInfo
                )) {
            if (ERROR_FILE_NOT_FOUND != GetLastError())
                return HError();
        }
        
                
        // Unregister the MD0ECC Algorithm
        CRYPT_OID_INFO MD0HashECCOIDInfo;
        memset(&MD0HashECCOIDInfo, 0, sizeof(MD0HashECCOIDInfo));
        MD0HashECCOIDInfo.cbSize = sizeof(MD0HashECCOIDInfo);
        MD0HashECCOIDInfo.pszOID = szOID_MD0ECC;
        MD0HashECCOIDInfo.dwGroupId = CRYPT_SIGN_ALG_OID_GROUP_ID;

        if (!CryptUnregisterOIDInfo(
                &MD0HashECCOIDInfo
                )) {
            if (ERROR_FILE_NOT_FOUND != GetLastError())
                return HError();
        }
        return S_OK;
}
