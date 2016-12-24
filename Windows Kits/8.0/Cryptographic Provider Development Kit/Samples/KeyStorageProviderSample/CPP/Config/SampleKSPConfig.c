// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved.

/*++
Abstract:
    This sample illustrates how to config the Sample CNG RSA key
    storage provider.

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
--*/


///////////////////////////////////////////////////////////////////////////////
//
// Headers...
//
///////////////////////////////////////////////////////////////////////////////
#include <windows.h>
#include <wincrypt.h>
#include <stdlib.h>
#include <stdio.h>
#include <bcrypt.h>
#include <ncrypt.h>
#include "..\inc\SampleKSP.h"
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
// File name of sample key storage provider's binary. *NO* path.
//
#define SAMPLEKSP_BINARY       L"SampleKSP.dll"

//
// An array of algorithm names, all belonging to the
// same algorithm class...
//
PWSTR AlgorithmNames[1] = {
    NCRYPT_KEY_STORAGE_ALGORITHM
};

//
// Definition of ONE class of algorithms supported
// by the provider...
//
CRYPT_INTERFACE_REG AlgorithmClass = {
    NCRYPT_KEY_STORAGE_INTERFACE,       // ncrypt key storage interface
    CRYPT_LOCAL,                        // Scope: local system only
    1,                                  // One algorithm in the class
    AlgorithmNames                      // The name(s) of the algorithm(s) in the class
};

//
// An array of ALL the algorithm classes supported
// by the provider...
//
PCRYPT_INTERFACE_REG AlgorithmClasses[1] = {
    &AlgorithmClass
};

//
// Definition of the provider's user-mode binary...
//
CRYPT_IMAGE_REG SampleKspImage = {
    SAMPLEKSP_BINARY,                   // File name of the sample KSP binary
    1,                                  // Number of algorithm classes the binary supports
    AlgorithmClasses                    // List of all algorithm classes available
};

//
// Definition of the overall provider...
//
CRYPT_PROVIDER_REG SampleKSPProvider = {
    0,
    NULL,
    &SampleKspImage,  // Image that provides user-mode support
    NULL              // Image that provides kernel-mode support (*MUST* be NULL)
};
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
// Main entry point...
//
///////////////////////////////////////////////////////////////////////////////
int __cdecl
wmain(
    __in int argc,
    __in_ecount(argc) PWSTR *argv)
{
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
            wprintf(L"Unrecognized command \"%s\"\n", argv[1]);
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
DisplayUsage()
{
    wprintf(L"Usage: SampleKSPconfig -enum | -register | -unregister\n");
    exit(1);
}
///////////////////////////////////////////////////////////////////////////////

void
EnumProviders()
{
    NTSTATUS ntStatus = STATUS_SUCCESS;

    DWORD cbBuffer = 0;
    PCRYPT_PROVIDERS pBuffer = NULL;
    DWORD i = 0;

    ntStatus = BCryptEnumRegisteredProviders(&cbBuffer, &pBuffer);

    if (NT_SUCCESS(ntStatus))
    {
        if (pBuffer == NULL)
        {
            wprintf(L"BCryptEnumRegisteredProviders returned a NULL ptr\n");
        }
        else
        {
            for (i = 0; i < pBuffer->cProviders; i++)
            {
                wprintf(L"%s\n", pBuffer->rgpszProviders[i]);
            }
        }
    }
    else
    {
        wprintf(L"BCryptEnumRegisteredProviders failed with error code 0x%08x\n", ntStatus);
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

    //
    // Make CNG aware that our provider
    // exists...
    //
    ntStatus = BCryptRegisterProvider(
                    SAMPLEKSP_PROVIDER_NAME,
                    0,                          // Flags: fail if provider is already registered
                    &SampleKSPProvider
                    );
    if (!NT_SUCCESS(ntStatus))
    {
        wprintf(L"BCryptRegisterProvider failed with error code 0x%08x\n", ntStatus);
    }

    //
    // Add the algorithm name to the priority list of the
    // symmetric cipher algorithm class. (This makes it
    // visible to BCryptResolveProviders.)
    //
    ntStatus = BCryptAddContextFunction(
                    CRYPT_LOCAL,                    // Scope: local machine only
                    NULL,                           // Application context: default
                    NCRYPT_KEY_STORAGE_INTERFACE,   // Algorithm class
                    NCRYPT_KEY_STORAGE_ALGORITHM,   // Algorithm name
                    CRYPT_PRIORITY_BOTTOM           // Lowest priority
                    );
    if ( !NT_SUCCESS(ntStatus))
    {
        wprintf(L"BCryptAddContextFunction failed with error code 0x%08x\n", ntStatus);
    }

    //
    // Identify our new provider as someone who exposes
    // an implementation of the new algorithm.
    //
    ntStatus = BCryptAddContextFunctionProvider(
                    CRYPT_LOCAL,                    // Scope: local machine only
                    NULL,                           // Application context: default
                    NCRYPT_KEY_STORAGE_INTERFACE,   // Algorithm class
                    NCRYPT_KEY_STORAGE_ALGORITHM,   // Algorithm name
                    SAMPLEKSP_PROVIDER_NAME,        // Provider name
                    CRYPT_PRIORITY_BOTTOM           // Lowest priority
                    );
    if ( !NT_SUCCESS(ntStatus))
    {
        wprintf(L"BCryptAddContextFunctionProvider failed with error code 0x%08x\n", ntStatus);
    }
}
///////////////////////////////////////////////////////////////////////////////

void
UnRegisterProvider()
{
    NTSTATUS ntStatus = STATUS_SUCCESS;

    //
    // Tell CNG that this provider no longer supports
    // this algorithm.
    //
    ntStatus = BCryptRemoveContextFunctionProvider(
                    CRYPT_LOCAL,                    // Scope: local machine only
                    NULL,                           // Application context: default
                    NCRYPT_KEY_STORAGE_INTERFACE,   // Algorithm class
                    NCRYPT_KEY_STORAGE_ALGORITHM,   // Algorithm name
                    SAMPLEKSP_PROVIDER_NAME         // Provider
                    );
    if (!NT_SUCCESS(ntStatus))
    {
        wprintf(L"BCryptRemoveContextFunctionProvider failed with error code 0x%08x\n", ntStatus);
    }


    //
    // Tell CNG to forget about our provider component.
    //
    ntStatus = BCryptUnregisterProvider(SAMPLEKSP_PROVIDER_NAME);
    if (!NT_SUCCESS(ntStatus))
    {
        wprintf(L"BCryptUnregisterProvider failed with error code 0x%08x\n", ntStatus);
    }
}
///////////////////////////////////////////////////////////////////////////////





