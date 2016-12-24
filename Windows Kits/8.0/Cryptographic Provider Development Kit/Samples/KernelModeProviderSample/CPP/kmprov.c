/*++

Copyright (c) 2006-2007  Microsoft Corporation All Rights Reserved

THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
PURPOSE.


Module Name:

    kmprov.cpp

Abstract:

    This sample illustrates the general structure of a kernel-mode
    CNG plug-in provider.  

Author:

Environment:

    Kernel mode only.

Notes:


Revision History:

--*/


///////////////////////////////////////////////////////////////////////////////
//
// Headers...
//
///////////////////////////////////////////////////////////////////////////////

#include "kmprov.h"


///////////////////////////////////////////////////////////////////////////////
//
// Misc. local definitions...
//
///////////////////////////////////////////////////////////////////////////////

//
// Maximum length (chars) of an NT device-name string
//
#define MAX_DEVNAME_CHARS   ((USHORT)64)

//
// Debug print macro
//

#if DBG
#define KMPROV_KDPRINT(_x_) \
                DbgPrint("KMPROV.SYS: ");\
                DbgPrint _x_;
#else
#define KMPROV_KDPRINT(_x_)
#endif 


///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of driver routines...
//
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
DriverEntry(
    IN OUT PDRIVER_OBJECT DriverObject,
    IN PUNICODE_STRING RegistryPath
    );

VOID
KmProvUnloadDriver(
    IN PDRIVER_OBJECT DriverObject
    );

NTSTATUS
KmProvCreateClose(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
KmProvDeviceControl(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );

NTSTATUS
KmProvHandleGenRandomRequest(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    );


NTSTATUS
KmProvpGenerateDeviceName(
    IN OUT PUNICODE_STRING DeviceName,
    IN PUNICODE_STRING RegistryPath
    );

///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of algorithm-lookup functions...
//
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpLookupCipherAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    );

NTSTATUS
KmProvpLookupHashAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    );

NTSTATUS
KmProvpLookupAsymmetricAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    );

NTSTATUS
KmProvpLookupSecretAgreementAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    );

NTSTATUS
KmProvpLookupSignatureAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    );

NTSTATUS
KmProvpLookupRngAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    );

NTSTATUS
KmProvpLookupKeyDerivationAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    );
///////////////////////////////////////////////////////////////////////////////
//
// Forward declarations of provider stub functions...
//
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvOpenAlgorithmProvider(
    __out   BCRYPT_ALG_HANDLE   *phAlgorithm,
    __in    LPCWSTR pszAlgId,
    __in    ULONG   dwFlags
    );

NTSTATUS
KmProvGetProperty(
    __in                                        BCRYPT_HANDLE   hObject,
    __in                                        LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    );

NTSTATUS
KmProvSetProperty(
    __inout                 BCRYPT_HANDLE   hObject,
    __in                    LPCWSTR pszProperty,
    __in_bcount(cbInput)    PUCHAR   pbInput,
    __in                    ULONG   cbInput,
    __in                    ULONG   dwFlags
    );

NTSTATUS
KmProvCloseAlgorithmProvider(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __in    ULONG   dwFlags
    );

NTSTATUS
KmProvGenerateSymmetricKey(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_KEY_HANDLE   *phKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in_bcount(cbSecret)           PUCHAR   pbSecret,
    __in                            ULONG   cbSecret,
    __in                            ULONG   dwFlags
    );

NTSTATUS
KmProvEncrypt(
    __inout                                     BCRYPT_KEY_HANDLE   hKey,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __in_opt                                    VOID    *pPaddingInfo,
    __inout_bcount_opt(cbIV)                    PUCHAR   pbIV,
    __in                                        ULONG   cbIV,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    );

NTSTATUS
KmProvDecrypt(
    __inout                                     BCRYPT_KEY_HANDLE   hKey,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __in_opt                                    VOID    *pPaddingInfo,
    __inout_bcount_opt(cbIV)                    PUCHAR   pbIV,
    __in                                        ULONG   cbIV,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    );

NTSTATUS
KmProvExportKey(
    __in                                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                                    BCRYPT_KEY_HANDLE   hExportKey,
    __in                                        LPCWSTR pszBlobType,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    );

NTSTATUS
KmProvImportKey(
    __in                            BCRYPT_ALG_HANDLE hAlgorithm,
    __in_opt                        BCRYPT_KEY_HANDLE hImportKey,
    __in                            LPCWSTR pszBlobType,
    __out                           BCRYPT_KEY_HANDLE *phKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in_bcount(cbInput)            PUCHAR   pbInput,
    __in                            ULONG   cbInput,
    __in                            ULONG   dwFlags
    );

NTSTATUS
KmProvDuplicateKey(
    __in                            BCRYPT_KEY_HANDLE   hKey,
    __out                           BCRYPT_KEY_HANDLE   *phNewKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in                            ULONG   dwFlags
    );


NTSTATUS
KmProvDestroyKey(
    __inout BCRYPT_KEY_HANDLE hKey
    );

NTSTATUS
KmProvCreateHash(
    __inout                          BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_HASH_HANDLE  *phHash,
    __out_bcount_full(cbHashObject) PUCHAR   pbHashObject,
    __in                            ULONG   cbHashObject,
    __in_bcount_opt(cbSecret)       PUCHAR   pbSecret,   // optional
    __in                            ULONG   cbSecret,   // optional
    __in                            ULONG   dwFlags
    );

NTSTATUS
KmProvHashData(
    __inout                 BCRYPT_HASH_HANDLE hHash,
    __in_bcount(cbInput)    PUCHAR   pbInput,
    __in                    ULONG   cbInput,
    __in                    ULONG   dwFlags
    );

NTSTATUS
KmProvFinishHash(
    __inout                     BCRYPT_HASH_HANDLE  hHash,
    __out_bcount_full(cbOutput) PUCHAR   pbOutput,
    __in                        ULONG   cbOutput,
    __in                        ULONG   dwFlags
    );

NTSTATUS
KmProvDuplicateHash(
    __in                            BCRYPT_HASH_HANDLE hHash,
    __out                           BCRYPT_HASH_HANDLE * phNewHash,
    __out_bcount_full(cbHashObject) PUCHAR pbHashObject,
    __in                            ULONG   cbHashObject,
    __in                            ULONG   dwFlags
    );

NTSTATUS
KmProvDestroyHash(
    __inout BCRYPT_HASH_HANDLE  hHash
    );

NTSTATUS
KmProvGenerateKeyPair(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __out   BCRYPT_KEY_HANDLE   *phKey,
    __in    ULONG   dwLength,
    __in    ULONG   dwFlags
    );

NTSTATUS
KmProvFinalizeKeyPair(
    __inout BCRYPT_KEY_HANDLE   hKey,
    __in    ULONG   dwFlags
    );

NTSTATUS
KmProvImportKeyPair(
    __in                            BCRYPT_ALG_HANDLE hAlgorithm,
    __in_opt                        BCRYPT_KEY_HANDLE hImportKey,
    __in                            LPCWSTR pszBlobType,
    __out                           BCRYPT_KEY_HANDLE *phKey,
    __in_bcount(cbInput)            PUCHAR   pbInput,
    __in                            ULONG   cbInput,
    __in                            ULONG   dwFlags
    );

NTSTATUS
KmProvSignHash(
    __in                                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                                    VOID    *pPaddingInfo,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    );

NTSTATUS
KmProvVerifySignature(
    __in                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                    VOID    *pPaddingInfo,
    __in_bcount(cbHash)         PUCHAR   pbHash,
    __in                        ULONG   cbHash,
    __in_bcount(cbSignature)    PUCHAR   pbSignature,
    __in                        ULONG   cbSignature,
    __in                        ULONG   dwFlags
    );

NTSTATUS
KmProvSecretAgreement(
    __in    BCRYPT_KEY_HANDLE       hPrivKey,
    __in    BCRYPT_KEY_HANDLE       hPubKey,
    __out   BCRYPT_SECRET_HANDLE    *phAgreedSecret,
    __in    ULONG                   dwFlags
    );

NTSTATUS
KmProvDeriveKey(
    __in        BCRYPT_SECRET_HANDLE hSharedSecret,
    __in        LPCWSTR              pwszKDF,
    __in_opt    BCryptBufferDesc     *pParameterList,
    __out_bcount_part_opt(cbDerivedKey, *pcbResult) PUCHAR pbDerivedKey,
    __in        ULONG                cbDerivedKey,
    __out       ULONG                *pcbResult,
    __in        ULONG                dwFlags
    );

NTSTATUS
KmProvDestroySecret(
    __inout BCRYPT_SECRET_HANDLE hSecret
    );

NTSTATUS
KmProvGenRandom(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __inout_bcount_full(cbBuffer)   PUCHAR   pbBuffer,
    __in                            ULONG   cbBuffer,
    __in                            ULONG   dwFlags
    );

NTSTATUS
KmProvKeyDerivation(
    __in        BCRYPT_KEY_HANDLE    hKey,
    __in_opt    BCryptBufferDesc     *pParameterList,
    __out_bcount_part(cbDerivedKey, *pcbResult) PUCHAR pbDerivedKey,
    __in        ULONG                cbDerivedKey,
    __out       ULONG                *pcbResult,
    __in        ULONG                dwFlags
    );
///////////////////////////////////////////////////////////////////////////////
//
// Declare driver routines' memory-management attributes...
//
///////////////////////////////////////////////////////////////////////////////

#ifdef ALLOC_PRAGMA
#pragma alloc_text( INIT, DriverEntry )

#pragma alloc_text( PAGE, KmProvUnloadDriver)
#pragma alloc_text( PAGE, KmProvCreateClose)
#pragma alloc_text( PAGE, KmProvDeviceControl)
#pragma alloc_text( PAGE, KmProvpGenerateDeviceName)

#pragma alloc_text( PAGE, KmProvpLookupCipherAlgorithm)
#pragma alloc_text( PAGE, KmProvpLookupHashAlgorithm)
#pragma alloc_text( PAGE, KmProvpLookupAsymmetricAlgorithm)
#pragma alloc_text( PAGE, KmProvpLookupSecretAgreementAlgorithm)
#pragma alloc_text( PAGE, KmProvpLookupSignatureAlgorithm)
#pragma alloc_text( PAGE, KmProvpLookupRngAlgorithm)
#pragma alloc_text( PAGE, KmProvpLookupKeyDerivationAlgorithm)

#pragma alloc_text( PAGE, KmProvOpenAlgorithmProvider)
#pragma alloc_text( PAGE, KmProvGetProperty)
#pragma alloc_text( PAGE, KmProvSetProperty)
#pragma alloc_text( PAGE, KmProvCloseAlgorithmProvider)
#pragma alloc_text( PAGE, KmProvGenerateSymmetricKey)
#pragma alloc_text( PAGE, KmProvEncrypt)
#pragma alloc_text( PAGE, KmProvDecrypt)
#pragma alloc_text( PAGE, KmProvExportKey)
#pragma alloc_text( PAGE, KmProvImportKey)
#pragma alloc_text( PAGE, KmProvDuplicateKey)
#pragma alloc_text( PAGE, KmProvDestroyKey)
#pragma alloc_text( PAGE, KmProvCreateHash)
#pragma alloc_text( PAGE, KmProvHashData)
#pragma alloc_text( PAGE, KmProvFinishHash)
#pragma alloc_text( PAGE, KmProvDuplicateHash)
#pragma alloc_text( PAGE, KmProvDestroyHash)
#pragma alloc_text( PAGE, KmProvGenerateKeyPair)
#pragma alloc_text( PAGE, KmProvFinalizeKeyPair)
#pragma alloc_text( PAGE, KmProvImportKeyPair)
#pragma alloc_text( PAGE, KmProvSignHash)
#pragma alloc_text( PAGE, KmProvVerifySignature)
#pragma alloc_text( PAGE, KmProvSecretAgreement)
#pragma alloc_text( PAGE, KmProvDeriveKey)
#pragma alloc_text( PAGE, KmProvDestroySecret)
#pragma alloc_text( PAGE, KmProvGenRandom)
#pragma alloc_text( PAGE, KmProvKeyDerivation)

#endif // ALLOC_PRAGMA

///////////////////////////////////////////////////////////////////////////////
//
// Dispatch tables for the algorithm classes supported by this provider...
//
///////////////////////////////////////////////////////////////////////////////

BCRYPT_CIPHER_FUNCTION_TABLE KmProvCipherFunctionTable =
{
    BCRYPT_CIPHER_INTERFACE_VERSION_1,
    KmProvOpenAlgorithmProvider,
    KmProvGetProperty,
    KmProvSetProperty,
    KmProvCloseAlgorithmProvider,
    KmProvGenerateSymmetricKey,
    KmProvEncrypt,
    KmProvDecrypt,
    KmProvImportKey,
    KmProvExportKey,
    KmProvDuplicateKey,
    KmProvDestroyKey,
};

BCRYPT_HASH_FUNCTION_TABLE KmProvHashFunctionTable =
{
    BCRYPT_HASH_INTERFACE_VERSION_1,
    KmProvOpenAlgorithmProvider,
    KmProvGetProperty,
    KmProvSetProperty,
    KmProvCloseAlgorithmProvider,
    KmProvCreateHash,
    KmProvHashData,
    KmProvFinishHash,
    KmProvDuplicateHash,
    KmProvDestroyHash,
};

BCRYPT_ASYMMETRIC_ENCRYPTION_FUNCTION_TABLE KmProvEncryptFunctionTable =
{
    BCRYPT_ASYMMETRIC_ENCRYPTION_INTERFACE_VERSION_1,
    KmProvOpenAlgorithmProvider,
    KmProvGetProperty,
    KmProvSetProperty,
    KmProvCloseAlgorithmProvider,
    KmProvGenerateKeyPair,
    KmProvFinalizeKeyPair,
    KmProvEncrypt,
    KmProvDecrypt,
    KmProvImportKeyPair,
    KmProvExportKey,
    KmProvDestroyKey,
    KmProvSignHash,
    KmProvVerifySignature,
};

BCRYPT_SECRET_AGREEMENT_FUNCTION_TABLE KmProvSecretAgreementTable =
{
    BCRYPT_SECRET_AGREEMENT_INTERFACE_VERSION_1,
    KmProvOpenAlgorithmProvider,
    KmProvGetProperty,
    KmProvSetProperty,
    KmProvCloseAlgorithmProvider,
    KmProvSecretAgreement,
    KmProvDeriveKey,
    KmProvDestroySecret,
    KmProvGenerateKeyPair,
    KmProvFinalizeKeyPair,
    KmProvImportKeyPair,
    KmProvExportKey,
    KmProvDestroyKey
};

BCRYPT_SIGNATURE_FUNCTION_TABLE KmProvSignFunctionTable =
{
    BCRYPT_SIGNATURE_INTERFACE_VERSION_1,
    KmProvOpenAlgorithmProvider,
    KmProvGetProperty,
    KmProvSetProperty,
    KmProvCloseAlgorithmProvider,
    KmProvGenerateKeyPair,
    KmProvFinalizeKeyPair,
    KmProvSignHash,
    KmProvVerifySignature,
    KmProvImportKeyPair,
    KmProvExportKey,
    KmProvDestroyKey
};

BCRYPT_RNG_FUNCTION_TABLE KmProvRngFunctionTable =
{
    BCRYPT_RNG_INTERFACE_VERSION_1,
    KmProvOpenAlgorithmProvider,
    KmProvGetProperty,
    KmProvSetProperty,
    KmProvCloseAlgorithmProvider,
    KmProvGenRandom
};

BCRYPT_KEY_DERIVATION_FUNCTION_TABLE KmProvKeyDerivationFunctionTable =
{
    BCRYPT_KEY_DERIVATION_INTERFACE_VERSION_1,
    KmProvOpenAlgorithmProvider,
    KmProvGetProperty,
    KmProvSetProperty,
    KmProvCloseAlgorithmProvider,
    KmProvGenerateSymmetricKey,
    KmProvDestroyKey,
    KmProvKeyDerivation,
    KmProvExportKey,
    KmProvImportKey,
    KmProvDuplicateKey
};



///////////////////////////////////////////////////////////////////////////////
//
// Main entry point...
//
///////////////////////////////////////////////////////////////////////////////
NTSTATUS
DriverEntry(
    IN OUT PDRIVER_OBJECT DriverObject,
    IN PUNICODE_STRING RegistryPath
    )
/*++

Routine Description:
    This routine is called by the I/O Manager to initialize the driver.

    It fills in the dispatch entry points, creates the Device object, 
    and completes the initialization.

Arguments:

    DriverObject - a pointer to the object that represents this
    driver.

    RegistryPath - a pointer to our Services key in the registry.

Return Value:

    STATUS_SUCCESS if initialized; an error otherwise.

--*/

{
    NTSTATUS ntStatus = STATUS_SUCCESS;

    WCHAR deviceNameBuffer[MAX_DEVNAME_CHARS];
    UNICODE_STRING ntDeviceName = {0, MAX_DEVNAME_CHARS*sizeof(WCHAR), deviceNameBuffer};

    PDEVICE_OBJECT deviceObject = NULL;

    //
    // Initialize the Driver object with this driver's entry points.
    //

    DriverObject->MajorFunction[IRP_MJ_CREATE]                  = KmProvCreateClose;
    DriverObject->MajorFunction[IRP_MJ_CLOSE]                   = KmProvCreateClose;
    DriverObject->MajorFunction[IRP_MJ_INTERNAL_DEVICE_CONTROL] = KmProvDeviceControl;

    DriverObject->DriverUnload = KmProvUnloadDriver;

    ntStatus = KmProvpGenerateDeviceName( &ntDeviceName, RegistryPath );
    if (!NT_SUCCESS(ntStatus))
    {
        goto CLEANUP_AND_RETURN;
    }
    
    ntStatus = IoCreateDevice(
                    DriverObject,               // Our Driver object
                    0,                          // No device extension
                    &ntDeviceName,              // Device name "\Device\KmProv"
                    FILE_DEVICE_UNKNOWN,        // Device type
                    FILE_DEVICE_SECURE_OPEN,    // Device characteristics
                    FALSE,                      // Not an exclusive device
                    &deviceObject );            // Returned ptr to Device object

    if (!NT_SUCCESS( ntStatus ))
    {
        KMPROV_KDPRINT(("Couldn't create the Device object\n"));
    } 

CLEANUP_AND_RETURN:

    return ntStatus;
}
///////////////////////////////////////////////////////////////////////////////


VOID
KmProvUnloadDriver(
    IN PDRIVER_OBJECT DriverObject
    )
/*++

Routine Description:

    This routine is called by the I/O Manager to unload the driver.

    Any resources previously allocated must be freed.

Arguments:

    DriverObject - a pointer to the object that represents our driver.

Return Value:

    None
--*/

{
    PDEVICE_OBJECT deviceObject = DriverObject->DeviceObject;

    if ( deviceObject != NULL )
    {
        IoDeleteDevice( deviceObject );
    }
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvCreateClose(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    )
/*++

Routine Description:

    This routine is called by the I/O Manager when the KMPROV device
    is opened or closed.

    No action is performed other than completing the request successfully.

Arguments:

    DeviceObject - a pointer to the object that represents the device
    being opened or closed.

    Irp - a pointer to the I/O Request Packet for this request.

Return Value:

    STATUS_SUCCESS always.

--*/
{
    UNREFERENCED_PARAMETER(DeviceObject);

    Irp->IoStatus.Status = STATUS_SUCCESS;
    Irp->IoStatus.Information = 0;
    
    IoCompleteRequest( Irp, IO_NO_INCREMENT );
    
    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvDeviceControl(
    IN PDEVICE_OBJECT DeviceObject,
    IN PIRP Irp
    )
/*++

Routine Description:

    In response to a kernel-mode BCryptOpenAlgorithProvider call for this
    provider, the CNG loader sends us an INTERNAL_DEVICE_CONTROL request. 
    This IOCTL is the kernel-mode equivalent of all the 'Get<blah>Interface' 
    calls exposed by a user-mode CNG plug-in provider.
    
    If the operation succeeds, the IOCTL output parameter block will contain
    a pointer to one of the interface dispatch tables defined above (e.g.,
    KmProvCipherFunctionTable, KmProvHashFunctionTable, etc.).

Arguments:

    DeviceObject - a pointer to the target Devoce object for
    the operation.

    Irp - a pointer to the I/O Request Packet for this request.

Return Value:

    NT status code

--*/
{
    NTSTATUS ntStatus = STATUS_SUCCESS;
    PIO_STACK_LOCATION irpStack;

    PCRYPT_PROV_IOCTL_INPUT_PARAMS ioctlInput = NULL;
    SIZE_T ioctlInputLength = 0;

    PCRYPT_PROV_IOCTL_OUTPUT_PARAMS ioctlOutput = NULL;
    SIZE_T ioctlOutputLength = 0;

    ULONG algIndex = 0;

    UNREFERENCED_PARAMETER(DeviceObject);

    Irp->IoStatus.Information = 0;
    irpStack = IoGetCurrentIrpStackLocation( Irp );

    //
    // Sanity-check the IOCTL parameter blocks
    //
    ioctlInput = irpStack->Parameters.DeviceIoControl.Type3InputBuffer;
    ioctlInputLength = irpStack->Parameters.DeviceIoControl.InputBufferLength;

    ioctlOutput = Irp->UserBuffer;
    ioctlOutputLength = irpStack->Parameters.DeviceIoControl.OutputBufferLength;

    if (ioctlInput == NULL ||
        ioctlInputLength < sizeof(CRYPT_PROV_IOCTL_INPUT_PARAMS) ||
        ioctlOutput == NULL ||
        ioctlOutputLength < sizeof(CRYPT_PROV_IOCTL_OUTPUT_PARAMS))
    {
        ntStatus = STATUS_INVALID_PARAMETER;
        goto CLEANUP_AND_RETURN;
    }

    //
    // Possible additional sanity check:
    //
    //  Verify that the provider name passed in the IOCTL input
    //  block is, in fact, the name of this provider. (MSFT providers
    //  don't currently perform this check.)
    //

    //
    // Determine which I/O control code was specified.
    //

    switch ( irpStack->Parameters.DeviceIoControl.IoControlCode )
    {
    case IOCTL_CRYPT_PROV_GET_CIPHER_INTERFACE:

        ntStatus = KmProvpLookupCipherAlgorithm( &ioctlInput->ProviderName, &algIndex );
        if (NT_SUCCESS(ntStatus))
        {
            ioctlOutput->pDispatchTable = (PVOID)&KmProvCipherFunctionTable;
        }
        break;

    case IOCTL_CRYPT_PROV_GET_HASH_INTERFACE:

        ntStatus = KmProvpLookupHashAlgorithm( &ioctlInput->ProviderName, &algIndex );
        if (NT_SUCCESS(ntStatus))
        {
            ioctlOutput->pDispatchTable = (PVOID)&KmProvHashFunctionTable;
        }
        break;

    case IOCTL_CRYPT_PROV_GET_ASYMMETRIC_ENCRYPTION_INTERFACE:

        ntStatus = KmProvpLookupAsymmetricAlgorithm( &ioctlInput->ProviderName, &algIndex );
        if (NT_SUCCESS(ntStatus))
        {
            ioctlOutput->pDispatchTable = (PVOID)&KmProvEncryptFunctionTable;
        }
        break;

    case IOCTL_CRYPT_PROV_GET_SECRET_AGREEMENT_INTERFACE:

        ntStatus = KmProvpLookupSecretAgreementAlgorithm( &ioctlInput->ProviderName, &algIndex );
        if (NT_SUCCESS(ntStatus))
        {
            ioctlOutput->pDispatchTable = (PVOID)&KmProvSecretAgreementTable;
        }
        break;

    case IOCTL_CRYPT_PROV_GET_SIGNATURE_INTERFACE:

        ntStatus = KmProvpLookupSignatureAlgorithm( &ioctlInput->ProviderName, &algIndex );
        if (NT_SUCCESS(ntStatus))
        {
            ioctlOutput->pDispatchTable = (PVOID)&KmProvSignFunctionTable;
        }
        break;

    case IOCTL_CRYPT_PROV_GET_RNG_INTERFACE:

        ntStatus = KmProvpLookupRngAlgorithm( &ioctlInput->ProviderName, &algIndex );
        if (NT_SUCCESS(ntStatus))
        {
            ioctlOutput->pDispatchTable = (PVOID)&KmProvRngFunctionTable;
        }
        break;

    case IOCTL_CRYPT_PROV_GET_SCHANNEL_INTERFACE:

        ntStatus = STATUS_NOT_SUPPORTED;
        break;

    case IOCTL_CRYPT_PROV_GET_KEY_DERIVATION_INTERFACE:
        ntStatus = KmProvpLookupKeyDerivationAlgorithm( &ioctlInput->ProviderName, &algIndex );
        if (NT_SUCCESS(ntStatus))
        {
            ioctlOutput->pDispatchTable = (PVOID)&KmProvKeyDerivationFunctionTable;
        }
        break;
    default:

        //
        // The specified I/O control code is unrecognized by this driver.
        //

        KMPROV_KDPRINT(("ERROR: unrecognized IOCTL %x\n",
            irpStack->Parameters.DeviceIoControl.IoControlCode));

        ntStatus = STATUS_INVALID_DEVICE_REQUEST;
        break;
    }

CLEANUP_AND_RETURN:

    //
    // We're all done with this request. Put some status information 
    // into the IRP and give ownership of it back to the I/O Manager.
    //

    Irp->IoStatus.Status = ntStatus;
    IoCompleteRequest( Irp, IO_NO_INCREMENT );

    return ntStatus;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpGenerateDeviceName(
    IN OUT PUNICODE_STRING DeviceName,
    IN PUNICODE_STRING RegistryPath
    )
{
    // The registry path string pointed to by RegistryPath is of the form:
    //          \Registry\Machine\System\CurrentControlSet\Services\DriverName
    //
    // we want to fabricate an NT device name that looks like: \Device\DriverName
    //

    NTSTATUS ntStatus = STATUS_SUCCESS;

    USHORT regPathChars = 0;
    UNICODE_STRING serviceName = {0, 0, NULL};
    USHORT serviceNameChars = 0;

    USHORT i = 0;

    //
    // Check for zero-length Reg path -- error.
    //

    if (!ARGUMENT_PRESENT(RegistryPath) ||
        RegistryPath->Length == 0)
    {
        ntStatus = STATUS_INVALID_PARAMETER;
        goto CLEANUP_AND_RETURN;
    }
    regPathChars = RegistryPath->Length / sizeof(WCHAR);

    //
    // Scan backwards, looking for the final backslash.
    //

    for (i = regPathChars - 1; i >= 0; --i)
    {
        if (RegistryPath->Buffer[i] != L'\\')
        {
            ++serviceNameChars;
        }
        else
        {
            break; // we hit a backslash - quit
        }
    }
    
    //
    // if serviceNameChars == 0, the string ended in a '\'  -- error
    //

    if (serviceNameChars == 0)
    {
        ntStatus = STATUS_INVALID_PARAMETER;
        goto CLEANUP_AND_RETURN;
    }

    serviceName.Length = serviceNameChars * sizeof(WCHAR);
    serviceName.MaximumLength = serviceNameChars * sizeof(WCHAR);
    serviceName.Buffer = &RegistryPath->Buffer[regPathChars - serviceNameChars];

    ntStatus = RtlAppendUnicodeToString( DeviceName, L"\\Device\\" );
    ntStatus = RtlAppendUnicodeStringToString( DeviceName, &serviceName );

CLEANUP_AND_RETURN:
    return ntStatus;
}
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
// Dummy algorithm-lookup functions for every algorithm class...
//
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpLookupCipherAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    )
{
    UNREFERENCED_PARAMETER(AlgorithmName);
    UNREFERENCED_PARAMETER(AlgorithmIndex);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpLookupHashAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    )
{
    UNREFERENCED_PARAMETER(AlgorithmName);
    UNREFERENCED_PARAMETER(AlgorithmIndex);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpLookupAsymmetricAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    )
{
    UNREFERENCED_PARAMETER(AlgorithmName);
    UNREFERENCED_PARAMETER(AlgorithmIndex);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpLookupSecretAgreementAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    )
{
    UNREFERENCED_PARAMETER(AlgorithmName);
    UNREFERENCED_PARAMETER(AlgorithmIndex);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpLookupSignatureAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    )
{
    UNREFERENCED_PARAMETER(AlgorithmName);
    UNREFERENCED_PARAMETER(AlgorithmIndex);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvpLookupRngAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    )
{
    UNREFERENCED_PARAMETER(AlgorithmName);
    UNREFERENCED_PARAMETER(AlgorithmIndex);

    return STATUS_SUCCESS;
}

NTSTATUS
KmProvpLookupKeyDerivationAlgorithm(
    IN PUNICODE_STRING AlgorithmName,
    OUT PULONG AlgorithmIndex
    )
{
    UNREFERENCED_PARAMETER(AlgorithmName);
    UNREFERENCED_PARAMETER(AlgorithmIndex);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
//
// Dummy provider implementation functions for every algorithm class...
//
///////////////////////////////////////////////////////////////////////////////

//
// Common to all interface classes...
//

NTSTATUS
KmProvOpenAlgorithmProvider(
    __out   BCRYPT_ALG_HANDLE   *phAlgorithm,
    __in    LPCWSTR pszAlgId,
    __in    ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(phAlgorithm);
    UNREFERENCED_PARAMETER(pszAlgId);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvGetProperty(
    __in                                        BCRYPT_HANDLE   hObject,
    __in                                        LPCWSTR pszProperty,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hObject);
    UNREFERENCED_PARAMETER(pbOutput);
    UNREFERENCED_PARAMETER(cbOutput);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);


    // If this is a property tested by the router, return SUCCESS
    // Otherwise fail.

    // *** Banks on the KM third party provider tests not exercising these
    // properties ***

    if ((!wcscmp(pszProperty, BCRYPT_HASH_BLOCK_LENGTH)) || (!wcscmp(pszProperty, BCRYPT_PADDING_SCHEMES)))
    {
         return STATUS_SUCCESS;
    }

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvSetProperty(
    __inout                 BCRYPT_HANDLE   hObject,
    __in                    LPCWSTR pszProperty,
    __in_bcount(cbInput)    PUCHAR   pbInput,
    __in                    ULONG   cbInput,
    __in                    ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hObject);
    UNREFERENCED_PARAMETER(pszProperty);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvCloseAlgorithmProvider(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __in    ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_SUCCESS;
}
///////////////////////////////////////////////////////////////////////////////

//
// Items unique to the CIPHER interface class...
//

NTSTATUS
KmProvGenerateSymmetricKey(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_KEY_HANDLE   *phKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in_bcount(cbSecret)           PUCHAR   pbSecret,
    __in                            ULONG   cbSecret,
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(phKey);
    UNREFERENCED_PARAMETER(pbKeyObject);
    UNREFERENCED_PARAMETER(cbKeyObject);
    UNREFERENCED_PARAMETER(pbSecret);
    UNREFERENCED_PARAMETER(cbSecret);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvEncrypt(
    __inout                                     BCRYPT_KEY_HANDLE   hKey,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __in_opt                                    VOID    *pPaddingInfo,
    __inout_bcount_opt(cbIV)                    PUCHAR   pbIV,
    __in                                        ULONG   cbIV,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(pPaddingInfo);
    UNREFERENCED_PARAMETER(pbIV);
    UNREFERENCED_PARAMETER(cbIV);
    UNREFERENCED_PARAMETER(pbOutput);
    UNREFERENCED_PARAMETER(cbOutput);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvDecrypt(
    __inout                                     BCRYPT_KEY_HANDLE   hKey,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __in_opt                                    VOID    *pPaddingInfo,
    __inout_bcount_opt(cbIV)                    PUCHAR   pbIV,
    __in                                        ULONG   cbIV,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(pPaddingInfo);
    UNREFERENCED_PARAMETER(pbIV);
    UNREFERENCED_PARAMETER(cbIV);
    UNREFERENCED_PARAMETER(pbOutput);
    UNREFERENCED_PARAMETER(cbOutput);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvExportKey(
    __in                                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                                    BCRYPT_KEY_HANDLE   hExportKey,
    __in                                        LPCWSTR pszBlobType,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(hExportKey);
    UNREFERENCED_PARAMETER(pszBlobType);
    UNREFERENCED_PARAMETER(pbOutput);
    UNREFERENCED_PARAMETER(cbOutput);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvImportKey(
    __in                            BCRYPT_ALG_HANDLE hAlgorithm,
    __in_opt                        BCRYPT_KEY_HANDLE hImportKey,
    __in                            LPCWSTR pszBlobType,
    __out                           BCRYPT_KEY_HANDLE *phKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in_bcount(cbInput)            PUCHAR   pbInput,
    __in                            ULONG   cbInput,
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(hImportKey);
    UNREFERENCED_PARAMETER(pszBlobType);
    UNREFERENCED_PARAMETER(phKey);
    UNREFERENCED_PARAMETER(pbKeyObject);
    UNREFERENCED_PARAMETER(cbKeyObject);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvDuplicateKey(
    __in                            BCRYPT_KEY_HANDLE   hKey,
    __out                           BCRYPT_KEY_HANDLE   *phNewKey,
    __out_bcount_full(cbKeyObject)  PUCHAR   pbKeyObject,
    __in                            ULONG   cbKeyObject,
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(phNewKey);
    UNREFERENCED_PARAMETER(pbKeyObject);
    UNREFERENCED_PARAMETER(cbKeyObject);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


NTSTATUS
KmProvDestroyKey(
    __inout BCRYPT_KEY_HANDLE hKey
    )
{
    UNREFERENCED_PARAMETER(hKey);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

//
// Items unique to the HASH interface class...
//

NTSTATUS
KmProvCreateHash(
    __inout                          BCRYPT_ALG_HANDLE   hAlgorithm,
    __out                           BCRYPT_HASH_HANDLE  *phHash,
    __out_bcount_full(cbHashObject) PUCHAR   pbHashObject,
    __in                            ULONG   cbHashObject,
    __in_bcount_opt(cbSecret)       PUCHAR   pbSecret,   // optional
    __in                            ULONG   cbSecret,   // optional
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(phHash);
    UNREFERENCED_PARAMETER(pbHashObject);
    UNREFERENCED_PARAMETER(cbHashObject);
    UNREFERENCED_PARAMETER(pbSecret);
    UNREFERENCED_PARAMETER(cbSecret);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvHashData(
    __inout                 BCRYPT_HASH_HANDLE hHash,
    __in_bcount(cbInput)    PUCHAR   pbInput,
    __in                    ULONG   cbInput,
    __in                    ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hHash);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvFinishHash(
    __inout                     BCRYPT_HASH_HANDLE  hHash,
    __out_bcount_full(cbOutput) PUCHAR   pbOutput,
    __in                        ULONG   cbOutput,
    __in                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hHash);
    UNREFERENCED_PARAMETER(pbOutput);
    UNREFERENCED_PARAMETER(cbOutput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvDuplicateHash(
    __in                            BCRYPT_HASH_HANDLE hHash,
    __out                           BCRYPT_HASH_HANDLE * phNewHash,
    __out_bcount_full(cbHashObject) PUCHAR pbHashObject,
    __in                            ULONG   cbHashObject,
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hHash);
    UNREFERENCED_PARAMETER(phNewHash);
    UNREFERENCED_PARAMETER(pbHashObject);
    UNREFERENCED_PARAMETER(cbHashObject);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvDestroyHash(
    __inout BCRYPT_HASH_HANDLE  hHash
    )
{
    UNREFERENCED_PARAMETER(hHash);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

//
// Items unique to the ASYMMETRIC_ENCRYPTION interface class...
//

NTSTATUS
KmProvGenerateKeyPair(
    __inout BCRYPT_ALG_HANDLE   hAlgorithm,
    __out   BCRYPT_KEY_HANDLE   *phKey,
    __in    ULONG   dwLength,
    __in    ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(phKey);
    UNREFERENCED_PARAMETER(dwLength);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvFinalizeKeyPair(
    __inout BCRYPT_KEY_HANDLE   hKey,
    __in    ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvImportKeyPair(
    __in                            BCRYPT_ALG_HANDLE hAlgorithm,
    __in_opt                        BCRYPT_KEY_HANDLE hImportKey,
    __in                            LPCWSTR pszBlobType,
    __out                           BCRYPT_KEY_HANDLE *phKey,
    __in_bcount(cbInput)            PUCHAR   pbInput,
    __in                            ULONG   cbInput,
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(hImportKey);
    UNREFERENCED_PARAMETER(pszBlobType);
    UNREFERENCED_PARAMETER(phKey);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvSignHash(
    __in                                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                                    VOID    *pPaddingInfo,
    __in_bcount(cbInput)                        PUCHAR   pbInput,
    __in                                        ULONG   cbInput,
    __out_bcount_part_opt(cbOutput, *pcbResult) PUCHAR   pbOutput,
    __in                                        ULONG   cbOutput,
    __out                                       ULONG   *pcbResult,
    __in                                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(pPaddingInfo);
    UNREFERENCED_PARAMETER(pbInput);
    UNREFERENCED_PARAMETER(cbInput);
    UNREFERENCED_PARAMETER(pbOutput);
    UNREFERENCED_PARAMETER(cbOutput);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvVerifySignature(
    __in                        BCRYPT_KEY_HANDLE   hKey,
    __in_opt                    VOID    *pPaddingInfo,
    __in_bcount(cbHash)         PUCHAR   pbHash,
    __in                        ULONG   cbHash,
    __in_bcount(cbSignature)    PUCHAR   pbSignature,
    __in                        ULONG   cbSignature,
    __in                        ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(pPaddingInfo);
    UNREFERENCED_PARAMETER(pbHash);
    UNREFERENCED_PARAMETER(cbHash);
    UNREFERENCED_PARAMETER(pbSignature);
    UNREFERENCED_PARAMETER(cbSignature);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////


//
// Items unique to the SECRET_AGREEMENT interface class...
//

NTSTATUS
KmProvSecretAgreement(
    __in    BCRYPT_KEY_HANDLE       hPrivKey,
    __in    BCRYPT_KEY_HANDLE       hPubKey,
    __out   BCRYPT_SECRET_HANDLE    *phAgreedSecret,
    __in    ULONG                   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hPrivKey);
    UNREFERENCED_PARAMETER(hPubKey);
    UNREFERENCED_PARAMETER(phAgreedSecret);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvDeriveKey(
    __in        BCRYPT_SECRET_HANDLE hSharedSecret,
    __in        LPCWSTR              pwszKDF,
    __in_opt    BCryptBufferDesc     *pParameterList,
    __out_bcount_part_opt(cbDerivedKey, *pcbResult) PUCHAR pbDerivedKey,
    __in        ULONG                cbDerivedKey,
    __out       ULONG                *pcbResult,
    __in        ULONG                dwFlags
    )
{
    UNREFERENCED_PARAMETER(hSharedSecret);
    UNREFERENCED_PARAMETER(pwszKDF);
    UNREFERENCED_PARAMETER(pParameterList);
    UNREFERENCED_PARAMETER(pbDerivedKey);
    UNREFERENCED_PARAMETER(cbDerivedKey);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

NTSTATUS
KmProvDestroySecret(
    __inout BCRYPT_SECRET_HANDLE hSecret
    )
{
    UNREFERENCED_PARAMETER(hSecret);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

//
// Items unique to the RNG interface class...
//

NTSTATUS
KmProvGenRandom(
    __inout                         BCRYPT_ALG_HANDLE   hAlgorithm,
    __inout_bcount_full(cbBuffer)   PUCHAR   pbBuffer,
    __in                            ULONG   cbBuffer,
    __in                            ULONG   dwFlags
    )
{
    UNREFERENCED_PARAMETER(hAlgorithm);
    UNREFERENCED_PARAMETER(pbBuffer);
    UNREFERENCED_PARAMETER(cbBuffer);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}

NTSTATUS
KmProvKeyDerivation(
    __in        BCRYPT_KEY_HANDLE    hKey,
    __in_opt    BCryptBufferDesc     *pParameterList,
    __out_bcount_part(cbDerivedKey, *pcbResult) PUCHAR pbDerivedKey,
    __in        ULONG                cbDerivedKey,
    __out       ULONG                *pcbResult,
    __in        ULONG                dwFlags
    )
{
    UNREFERENCED_PARAMETER(hKey);
    UNREFERENCED_PARAMETER(pbDerivedKey);
    UNREFERENCED_PARAMETER(cbDerivedKey);
    UNREFERENCED_PARAMETER(pParameterList);
    UNREFERENCED_PARAMETER(pcbResult);
    UNREFERENCED_PARAMETER(dwFlags);

    return STATUS_INVALID_PARAMETER;
}
///////////////////////////////////////////////////////////////////////////////

