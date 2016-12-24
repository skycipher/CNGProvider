/*++

Abstract:

    This sample illustrates how to use the CNG Crypto Config APIs to
    install and remove a user-mode provider DLL.

    NOTES:

        Before running this program, copy the provider DLL to the
        proper directory:

            %systemroot%\system32   -   if this is a native provider 
                                        (i.e., 32-bit DLL on a 32-bit
                                        platform, or a 64-bit DLL on
                                        a 64-bit platform).

            %systemroot%\sysWOW64   -   if this is a 32-bit provider
                                        running in compatibility mode
                                        (servicing 32-bit clients) on 
                                        a 64-bit platform.

        To use the -register and -unregister features of this
        program, you must be running as an administrator.


    THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
    ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
    THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
    PARTICULAR PURPOSE.

    Copyright (c) 2005-2007 by Microsoft Corporation. All rights reserved.

--*/



///////////////////////////////////////////////////////////////////////////////
//
// Headers...
//
///////////////////////////////////////////////////////////////////////////////
#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <io.h>
#include <bcrypt.h>
#include <bcrypt_provider.h>
#include <ncrypt.h>

#define SCHANNEL_PROVIDER_NAME               L"Protocol Provider Plugin"
#define CIPHERSUITE_NAME                     L"TLS_RSA_WITH_RC2_CBC_40_MD5"

#define DBG_CONFIG

#define CONTEXT L"SSL"


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


///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of local routines...
//
///////////////////////////////////////////////////////////////////////////////
static void 
DisplayUsage(
	void
	);

static void 
EnumProviders(
	void
	);

static void 
RegisterProvider(
    void
    );

static void 
UnRegisterProvider(
	void
	);



///////////////////////////////////////////////////////////////////////////////
//
// The following section defines the characteristics of the
// provider being registered...
//
///////////////////////////////////////////////////////////////////////////////
//
// File name of provider's user-mode binary. *NO* path.
//
#define PROVIDER_USER_MODE_BINARY       L"ProtocolProviderPlugin.dll"

//
// An array of algorithm names, all belonging to the
// same algorithm class...
//
PWSTR AlgorithmNames[1] = {
    CIPHERSUITE_NAME
};

//
// Definition of ONE class of algorithms supported
// by the provider...
//
CRYPT_INTERFACE_REG AlgorithmClass = {
    NCRYPT_SCHANNEL_INTERFACE,            // Symmetric encryption algorithm class
    CRYPT_LOCAL,                        // Scope: local system only
    1,                                  // One algorithm in the class
    AlgorithmNames                      // The name(s) of the algorithm(s) in the class
};

//
// An array of ALL the algorithm classes supported
// by the provider...
//
PCRYPT_INTERFACE_REG AllUserModeAlgorithmClasses[1] = {
    &AlgorithmClass
};

//
// Definition of the provider's user-mode binary...
//
CRYPT_IMAGE_REG UserModeProviderImage = {
    PROVIDER_USER_MODE_BINARY,          // File name of the user-mode binary (*NO* path)
    1,                                  // Number of algorithm classes the binary supports
    AllUserModeAlgorithmClasses         // List of all user-mode algorithm classes available
                                        //	from this provider
};

//
// Definition of the overall provider...
//
CRYPT_PROVIDER_REG CustomSChannelProvider = {
    0, 
    NULL, 
    &UserModeProviderImage,             // Image that provides user-mode support
    NULL                                // Image that provides kernel-mode support (*MUST* be NULL)
};
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
// Main entry point...
//
///////////////////////////////////////////////////////////////////////////////
extern "C" int __cdecl 
wmain(
	int argc,
	PWSTR *argv
	)
{
	wprintf_s(L"Starting RegisterProvider.exe...\n");
    if ( argc > 1 )
    {
        if ((_wcsicmp(argv[1], L"-register") == 0))
        {
            RegisterProvider();
        }
        else if ((_wcsicmp(argv[1], L"-unregister")  == 0))
        {
            UnRegisterProvider();
        }
        else if ((_wcsicmp(argv[1], L"-enum")  == 0))
        {
            EnumProviders();
        }
        else
		{
            wprintf_s(L"Unrecognized command \"%s\"\n", argv[1]);
			DisplayUsage();
		}
    }
    else
	{
        DisplayUsage();
	}

    return 1;
}
///////////////////////////////////////////////////////////////////////////////

void 
DisplayUsage(
	void
	)
{
	wprintf_s(L"Usage: RegisterProvider -enum | -register | -unregister\n");
	exit(1);
}
///////////////////////////////////////////////////////////////////////////////

void 
EnumProviders(
	void
	)
{
    NTSTATUS ntStatus = STATUS_SUCCESS;

    DWORD cbBuffer = 0;
    PCRYPT_PROVIDERS pBuffer = NULL;

    ntStatus = BCryptEnumRegisteredProviders(&cbBuffer, &pBuffer);

    if (NT_SUCCESS(ntStatus))
    {
        if (pBuffer == NULL)
        {
            wprintf_s(L"BCryptEnumRegisteredProviders returned a NULL ptr\n");
        }
        else
        {
            for ( DWORD i = 0; i < pBuffer->cProviders; i++)
            {
                wprintf_s(L"%s\n", pBuffer->rgpszProviders[i]);
            }
        }
    }
    else
    {
        wprintf_s(L"BCryptEnumRegisteredProviders failed with error code 0x%08x\n", ntStatus);
    }

    if (pBuffer != NULL)
    {
        BCryptFreeBuffer(pBuffer);
    }
}
///////////////////////////////////////////////////////////////////////////////

void 
RegisterProvider(
    void
    )
{
    NTSTATUS ntStatus = STATUS_SUCCESS;
	#ifdef DBG_CONFIG
		wprintf_s(L"Registering Provider.....\n");
	#endif
    //
    // Make CNG aware that our provider
    // exists...
    //
    ntStatus = BCryptRegisterProvider(
                    SCHANNEL_PROVIDER_NAME, 
                    0,                          // Flags: fail if provider is already registered
                    &CustomSChannelProvider
                    );
    if (!NT_SUCCESS(ntStatus))
    {
        wprintf_s(L"BCryptRegisterProvider failed with error code 0x%08x\n", ntStatus);
    }

    //
    // Add the algorithm name to the priority list of the
    // symmetric cipher algorithm class. (This makes it
    // visible to BCryptResolveProviders.)
    //
    ntStatus = BCryptAddContextFunction(
                    CRYPT_LOCAL,                // Scope: local machine only
                    CONTEXT,                       // Application context: default
                    NCRYPT_SCHANNEL_INTERFACE,    // Algorithm class
                    CIPHERSUITE_NAME,          // Algorithm name
                    CRYPT_PRIORITY_TOP			// Highest priority
                    );
    if ( !NT_SUCCESS(ntStatus))
    {
        wprintf_s(L"BCryptAddContextFunction failed with error code 0x%08x\n", ntStatus);
    }

    //
    // Identify our new provider as someone who exposes
    // an implementation of the new algorithm.
    //
    ntStatus = BCryptAddContextFunctionProvider(
                    CRYPT_LOCAL,                // Scope: local machine only
                    CONTEXT,                       // Application context: default
                    NCRYPT_SCHANNEL_INTERFACE,    // Algorithm class
                    CIPHERSUITE_NAME,          // Algorithm name
                    SCHANNEL_PROVIDER_NAME,  // Provider name
                    CRYPT_PRIORITY_TOP       // Highest priority
                    );
    if ( !NT_SUCCESS(ntStatus))
    {
        wprintf_s(L"BCryptAddContextFunctionProvider failed with error code 0x%08x\n", ntStatus);
    }

	#ifdef DBG_CONFIG
		wprintf_s(L"Done!\n");
	#endif
}
///////////////////////////////////////////////////////////////////////////////

void 
UnRegisterProvider(
	void
	)
{
    NTSTATUS ntStatus = STATUS_SUCCESS;
	#ifdef DBG_CONFIG
		wprintf_s(L"Unregistering Provider.....");
	#endif

    //
    // Tell CNG that this provider no longer supports
    // this algorithm.
    //
    ntStatus = BCryptRemoveContextFunctionProvider(
                    CRYPT_LOCAL,                // Scope: local machine only
                    CONTEXT,                       // Application context: default
                    NCRYPT_SCHANNEL_INTERFACE,    // Algorithm class
                    CIPHERSUITE_NAME,          // Algorithm name
                    SCHANNEL_PROVIDER_NAME   // Provider
                    );
    if (!NT_SUCCESS(ntStatus))
    {
        wprintf_s(L"BCryptRemoveContextFunctionProvider failed with error code 0x%08x\n", ntStatus);
    }

    //
    // Remove the algorithm name from the priority list
    // for the algorithm class. WE ONLY NEED TO DO THIS
    // BECAUSE THE ALGORITHM NAME ('XOR') IS UNIQUE TO 
    // THIS SAMPLE. We WOULD NOT do this to one of the
    // well-known algorithm names (e.g., 'AES').
    //
    ntStatus = BCryptRemoveContextFunction(
                    CRYPT_LOCAL,                // Scope: local machine only
                    CONTEXT,                       // Application context: default
                    NCRYPT_SCHANNEL_INTERFACE,    // Algorithm class
                    CIPHERSUITE_NAME           // Algorithm name
                    );
    if (!NT_SUCCESS(ntStatus))
    {
        wprintf_s(L"BCryptRemoveContextFunction failed with error code 0x%08x\n", ntStatus);
    }

    //
    // Tell CNG to forget about our provider component.
    //
	ntStatus = BCryptUnregisterProvider(SCHANNEL_PROVIDER_NAME);
    if (!NT_SUCCESS(ntStatus))
    {
        wprintf_s(L"BCryptUnregisterProvider failed with error code 0x%08x\n", ntStatus);
    }

	#ifdef DBG_CONFIG
		wprintf_s(L"Done!\n");
	#endif
}
///////////////////////////////////////////////////////////////////////////////




