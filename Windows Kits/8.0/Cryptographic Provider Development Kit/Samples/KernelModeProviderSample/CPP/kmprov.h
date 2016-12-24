/*++

Copyright (c) 2006-2007  Microsoft Corporation All Rights Reserved

THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
PURPOSE.


Module Name:

    kmprov.h

Abstract:
  
    This header contains any well-known names needed by the driver,
    its kernel-mode client, and and its user-mode installer.

Author:

Environment:

    Shared between kernel and user modes.

Notes:

Revision History:

--*/



#pragma once

#ifdef __cplusplus
extern "C" {
#endif


#include <ntddk.h>
#include <string.h>
#include <bcrypt.h>
#include <bcrypt_provider.h>

#ifdef __cplusplus
}
#endif

#define KMPROV_PROVIDER_NAME    (L"KM Prov CNG Plug-in Provider")