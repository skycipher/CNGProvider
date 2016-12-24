// CNGProvider.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#define WIN32_NO_STATUS
#include <windows.h>
#undef WIN32_NO_STATUS
#include "CNGProvider.h"

#include <winternl.h>
#define STATUS_SUCCESS 0
#define STATUS_NOT_IMPLEMENTED 0xC0000002

#include <winerror.h>
#include <stdio.h>
#include <bcrypt.h>
#include ".\..\Include\bcrypt_provider.h"
#include <sal.h>


// This is an example of an exported variable
CNGPROVIDER_API int nCNGProvider = 0;
CNGPROVIDER_API NTSTATUS WINAPI GetInterface(
	_In_   LPCWSTR pszProviderName,
	_Out_  BCRYPT_RNG_FUNCTION_TABLE **ppFunctionTable,
	_In_   ULONG dwFlags
);

/* visual aid for dev
typedef struct _BCRYPT_RNG_FUNCTION_TABLE {
	BCRYPT_INTERFACE_VERSION       Version;
	BCryptOpenAlgorithmProviderFn  OpenAlgorithmProvider;
	BCryptGetPropertyFn            GetProperty;
	BCryptSetPropertyFn            SetProperty;
	BCryptCloseAlgorithmProviderFn CloseAlgorithmProvider;
	BCryptGenRandomFn              GenRandom;
} BCRYPT_RNG_FUNCTION_TABLE;
*/
BCRYPT_RNG_FUNCTION_TABLE RngFunctionTable;

typedef NTSTATUS(WINAPI *BCryptOpenAlgorithmProviderFn)(
	_Out_  BCRYPT_ALG_HANDLE *phAlgorithm,
	_In_   LPCWSTR pszAlgId,
	_In_   ULONG dwFlags
	);

typedef NTSTATUS(WINAPI *BCryptGetPropertyFn)(
	_In_   BCRYPT_HANDLE hObject,
	_In_   LPCWSTR pszProperty,
	_Out_  PUCHAR pbOutput,
	_In_   ULONG cbOutput,
	_Out_  ULONG *pcbResult,
	_In_   ULONG dwFlags
	);

typedef NTSTATUS(WINAPI *BCryptSetPropertyFn)(
	_Inout_  BCRYPT_HANDLE hObject,
	_In_     LPCWSTR pszProperty,
	_In_     PUCHAR pbInput,
	_In_     ULONG cbInput,
	_In_     ULONG dwFlags
	);

typedef NTSTATUS(WINAPI *BCryptGenRandomFn)(
	_Inout_  BCRYPT_ALG_HANDLE hAlgorithm,
	_Inout_  PUCHAR pbBuffer,
	_In_     ULONG cbBuffer,
	_In_     ULONG dwFlags
	);


typedef NTSTATUS(WINAPI *BCryptCloseAlgorithmProviderFn)(
	_Inout_  BCRYPT_ALG_HANDLE hAlgorithm,
	_In_     ULONG dwFlags
	);



// This is an example of an exported function.
CNGPROVIDER_API int fnCNGProvider(void)
{
	return 42;
}

// This is the constructor of a class that has been exported.
// see CNGProvider.h for the class definition
CCNGProvider::CCNGProvider()
{
	
	return;
}

NTSTATUS(WINAPI OpenProvider)(
	_Out_  BCRYPT_ALG_HANDLE *phAlgorithm,
	_In_   LPCWSTR pszAlgId,
	_In_   ULONG dwFlags
	) 
{
	return STATUS_NOT_IMPLEMENTED;
}

_Must_inspect_result_ NTSTATUS (WINAPI  CloseProvider)(
	_Inout_ BCRYPT_ALG_HANDLE   hAlgorithm,
	_In_    ULONG   dwFlags)
{
	return STATUS_NOT_IMPLEMENTED;
}
NTSTATUS(WINAPI GetProperty)(
	_In_   BCRYPT_HANDLE hObject,
	_In_   LPCWSTR pszProperty,
	_Out_  PUCHAR pbOutput,
	_In_   ULONG cbOutput,
	_Out_  ULONG *pcbResult,
	_In_   ULONG dwFlags
	)
{
	return STATUS_NOT_IMPLEMENTED;
}
NTSTATUS(WINAPI SetProperty)(
	_Inout_  BCRYPT_HANDLE hObject,
	_In_     LPCWSTR pszProperty,
	_In_     PUCHAR pbInput,
	_In_     ULONG cbInput,
	_In_     ULONG dwFlags
	)
{
	return STATUS_NOT_IMPLEMENTED;
}
NTSTATUS(WINAPI GetRandom)(
	_Inout_  BCRYPT_ALG_HANDLE hAlgorithm,
	_Inout_  PUCHAR pbBuffer,
	_In_     ULONG cbBuffer,
	_In_     ULONG dwFlags
	)
{
	return STATUS_NOT_IMPLEMENTED;
}



CNGPROVIDER_API NTSTATUS WINAPI GetInterface(LPCWSTR pszProviderName, BCRYPT_RNG_FUNCTION_TABLE ** ppFunctionTable, ULONG dwFlags)
{
	//	Let's intialize the function table 
	RngFunctionTable.OpenAlgorithmProvider = OpenProvider;	
	RngFunctionTable.GetProperty = GetProperty;
	RngFunctionTable.SetProperty = SetProperty;
	RngFunctionTable.GenRandom = GetRandom;
	RngFunctionTable.CloseAlgorithmProvider = CloseProvider;

	RngFunctionTable.Version = BCRYPT_RNG_INTERFACE_VERSION_1;
	return NTSTATUS();
}

