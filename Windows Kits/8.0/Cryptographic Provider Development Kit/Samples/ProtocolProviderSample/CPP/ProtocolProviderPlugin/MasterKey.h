/** @file MasterKey.h
  * @brief Contains constant definitions and helper function prototypes for MasterKey.cpp
  * 
**/

#ifndef _MASTER_KEY_H
#define _MASTER_KEY_H

// Constant Definitions
#define MASTER_KEY_LABEL							"master secret"
#define MASTER_KEY_LABEL_SIZE						13
#define SESSION_KEY_LABEL							"key expansion"
#define SESSION_KEY_LABEL_SIZE						13
#define INITIALIZATION_VECTOR_PROPERTY				L"IV"


// Helper function definitions. (See implementations for descriptions)

SECURITY_STATUS
WINAPI
PRF(
	__in	NCRYPT_PROV_HANDLE hSslProvider,
	__in	PBYTE pbPreMasterKey,
	__in	DWORD cbPreMasterKey,
	__in	PBYTE pbSeed,
	__in	DWORD cbSeed,
	__in	PBYTE pbLabel,
	__in	DWORD cbLabel,
	__out_bcount(cbMasterKey)   PBYTE pbMasterKey,
	__in	DWORD cbMasterKey
	);

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
			__in	DWORD						cbOutput);

P_MASTERKEY_OBJECT
WINAPI
newMasterKeyObject(DWORD dwClientServerFlag);

SECURITY_STATUS
WINAPI
getParameters(
	  __in  PNCryptBufferDesc	pParameterList, 
	  __out PVOID*				pbClientRandom, 
	  __out DWORD*				cbClientRandom, 
	  __out PVOID*				pbServerRandom, 
	  __out DWORD*				cbServerRandom,
	  __out DWORD*				dwHighestVersion);

SECURITY_STATUS
WINAPI
validateCommonArguments(   
	   NCRYPT_PROV_HANDLE hProvider,
       NCRYPT_KEY_HANDLE hKey,
       DWORD   dwProtocol,
	   DWORD   dwCipherSuite,
       NCryptBufferDesc *pParameterList,
	   DWORD   dwFlags );


SECURITY_STATUS
WINAPI
validateMasterKey(NCRYPT_KEY_HANDLE hMasterKey);

P_SESSION_KEY_OBJECT
WINAPI
newSessionKey(DWORD keyObjectSize);

SECURITY_STATUS
WINAPI
validateSessionKey(NCRYPT_KEY_HANDLE hSessionKey);


#endif

