// provider.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "..\inc\rndprov.h"


#ifdef _MANAGED
#pragma managed(push, off)
#endif


///////////////////////////////////////////////////////////////////////////////
//
// Local definitions...
//
///////////////////////////////////////////////////////////////////////////////
//
// These NTSTATUS items are not currently defined in BCRYPT.H. Unitl this is
// corrected, the easiest way to make them available is to cut and paste them 
// from NTSTATUS.H...
//
#ifndef NTSTATUS
typedef LONG NTSTATUS, *PNSTATUS;
#endif

#ifndef NT_SUCCESS
#define NT_SUCCESS(status) (status >= 0)
#endif

#ifndef STATUS_SUCCESS
#define STATUS_SUCCESS                   ((NTSTATUS)0x00000000L)
#define STATUS_NOT_SUPPORTED             ((NTSTATUS)0xC00000BBL)
#define STATUS_UNSUCCESSFUL              ((NTSTATUS)0xC0000001L)
#define STATUS_HMAC_NOT_SUPPORTED        ((NTSTATUS)0xC000A001L)
#define STATUS_BUFFER_TOO_SMALL          ((NTSTATUS)0xC0000023L)
#define STATUS_NOT_IMPLEMENTED           ((NTSTATUS)0xC0000002L)
#endif



//#define STRICT
#include <windows.h>
#include <bcrypt.h>
#include <bcrypt_provider.h>
#include <setupapi.h>
#include <tchar.h>

#include <stdio.h>




#define WERNG_IMAGE_NAME L"NetRandom.dll"

PWSTR WERngAlgorithmNames[1] = {
	BCRYPT_RNG_ALGORITHM
};

CRYPT_INTERFACE_REG WERngInterface = {
	BCRYPT_RNG_INTERFACE, CRYPT_LOCAL, 1, WERngAlgorithmNames
};

PCRYPT_INTERFACE_REG WERngInterfaces[1] = {
	&WERngInterface
};

CRYPT_IMAGE_REG WERngImage = {
	WERNG_IMAGE_NAME, 1, WERngInterfaces
};

CRYPT_PROVIDER_REG WERngProvider = {
	0, NULL, &WERngImage, NULL
};

typedef ULONG(WINAPI* RtlNtStatusToDosErrorFunc)(IN NTSTATUS status);

static DWORD ToDosError(NTSTATUS status)
{
	DWORD error = NO_ERROR;
	HMODULE ntdll;
	RtlNtStatusToDosErrorFunc RtlNtStatusToDosError;

	ntdll = LoadLibrary(L"Ntdll.dll");
	if (ntdll != NULL)
	{
		RtlNtStatusToDosError = (RtlNtStatusToDosErrorFunc)
			GetProcAddress(ntdll, "RtlNtStatusToDosError");

		if (RtlNtStatusToDosError != NULL)
		{
			error = RtlNtStatusToDosError(status);
		}
		else
		{
			error = GetLastError();
			SetupWriteTextLogError(SetupGetThreadLogToken(),
				TXTLOG_INSTALLER,
				TXTLOG_ERROR,
				error,
				"RtlNtStatusToDosError function not found.");
		}
	}
	else
	{
		error = GetLastError();
		SetupWriteTextLogError(SetupGetThreadLogToken(),
			TXTLOG_INSTALLER,
			TXTLOG_ERROR,
			error,
			"Failed to load ntdll.dll.");
	}

	return error;
}

NTSTATUS WINAPI RegisterProvider(BOOLEAN KernelMode)
{
	NTSTATUS status;

	UNREFERENCED_PARAMETER(KernelMode);

	status = BCryptRegisterProvider(WERNG_PROVIDER_NAME, CRYPT_OVERWRITE,
		&WERngProvider);

	if (!NT_SUCCESS(status))
	{
		SetupWriteTextLogError(SetupGetThreadLogToken(),
			TXTLOG_INSTALLER,
			TXTLOG_ERROR,
			ToDosError(status),
			"Failed to register as a CNG provider.");
		return status;
	}

	status = BCryptAddContextFunctionProvider(CRYPT_LOCAL, NULL,
		BCRYPT_RNG_INTERFACE, BCRYPT_RNG_ALGORITHM, WERNG_PROVIDER_NAME,
		CRYPT_PRIORITY_BOTTOM);

	if (!NT_SUCCESS(status))
	{
		SetupWriteTextLogError(SetupGetThreadLogToken(),
			TXTLOG_INSTALLER,
			TXTLOG_ERROR,
			ToDosError(status),
			"Failed to add cryptographic function.");
	}

	return status;
}

NTSTATUS WINAPI UnregisterProvider()
{
	NTSTATUS status;

	status = BCryptRemoveContextFunctionProvider(CRYPT_LOCAL, NULL,
		BCRYPT_RNG_INTERFACE, BCRYPT_RNG_ALGORITHM, WERNG_PROVIDER_NAME);

	if (!NT_SUCCESS(status))
	{
		SetupWriteTextLogError(SetupGetThreadLogToken(),
			TXTLOG_INSTALLER,
			TXTLOG_WARNING,
			ToDosError(status),
			"Failed to remove cryptographic function.");
	}

	status = BCryptUnregisterProvider(WERNG_PROVIDER_NAME);
	if (!NT_SUCCESS(status))
	{
		SetupWriteTextLogError(SetupGetThreadLogToken(),
			TXTLOG_INSTALLER,
			TXTLOG_WARNING,
			ToDosError(status),
			"Failed to unregister as a CNG provider.");
	}

	return STATUS_SUCCESS;
}

DWORD CALLBACK WERngCoInstaller(IN DI_FUNCTION InstallFunction,
	IN HDEVINFO DeviceInfoSet,
	IN PSP_DEVINFO_DATA DeviceInfoData OPTIONAL,
	IN OUT PCOINSTALLER_CONTEXT_DATA Context)
{
	NTSTATUS status;
	DWORD error = NO_ERROR;

	UNREFERENCED_PARAMETER(DeviceInfoSet);
	UNREFERENCED_PARAMETER(DeviceInfoData);
	UNREFERENCED_PARAMETER(Context);

	switch (InstallFunction)
	{
	case DIF_INSTALLDEVICE:
		status = RegisterProvider(FALSE);
		if (!NT_SUCCESS(status))
		{
			error = ToDosError(status);
		}
		break;

	case DIF_REMOVE:
		status = UnregisterProvider();
		if (!NT_SUCCESS(status))
		{
			error = ToDosError(status);
		}
		break;

	default:
		break;
	}

	return error;
}

#ifdef _MANAGED
#pragma managed(pop)
#endif

