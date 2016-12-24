#include <ntddk.h>
#include "kdcom.h"
#include "HardwareLayer.h"

#pragma warning(disable: 4127)

const static ULONG DEFAULT_ADDRESS_SIZE_PL011 = 256;
const static ULONG TIMEOUT_COUNT = 1024 * 200;

#define RXD     0x00
#define TXD     0x40
#define UCR1    0x80
#define UCR2    0x84
#define UCR3    0x88
#define UCR4    0x8c
#define UFCR    0x90
#define USR1    0x94
#define USR2    0x98
#define UESC    0x9c
#define UTIM    0xa0
#define UBIR    0xa4
#define UBMR    0xa8
#define UBRC    0xac
#define ONEMS   0xb0
#define UTS     0xb4

#define UART_EN (1 << 0)
#define SRST    (1 << 0)
#define RXEN    (1 << 0)
#define TXEN    (1 << 0)
#define RFDIV   (1 << 7)
#define TXFULL  (1 << 4)
#define RXFULL  (1 << 3)
#define RXEMPTY (1 << 5)
#define TXEMPTY (1 << 6)


BOOLEAN
MX6InitializePort (
    _In_opt_ _Null_terminated_ PCHAR LoadOptions,
    _In_ PDEBUG_PORT DebugPort
    )
{
    // We assume port has been initialized by UEFI.
    UNREFERENCED_PARAMETER(LoadOptions);
    UNREFERENCED_PARAMETER(DebugPort);

    return TRUE;
}


VOID
MX6SetBaud (
    _In_ PCPPORT  PortPtr,
    _In_ const ULONG Rate
    )
{
    // For now we only support a fixed baud rate of 115200, 1 stop, no parity.
    UNREFERENCED_PARAMETER(PortPtr);
    UNREFERENCED_PARAMETER(Rate);

    return;
}


VOID
MX6PutByte (
    _In_ PCPPORT  PortPtr,
    _In_ const UCHAR Byte,
    _In_ const BOOLEAN* IsCompDbgPortsPresentPtr
    )
{
    UNREFERENCED_PARAMETER(IsCompDbgPortsPresentPtr);

    // Wait until TX is not full
    while ((READ_REGISTER_ULONG((PULONG)(PortPtr->Address + UTS)) & TXFULL) != 0);

    WRITE_REGISTER_UCHAR(PortPtr->Address + TXD, Byte);

    return;
}


USHORT
MX6GetByte (
    _In_ PCPPORT  PortPtr,
    _Out_ PUCHAR BytePtr,
    _Inout_ BOOLEAN *CompDbgPortsPresent
    )

{
    UNREFERENCED_PARAMETER(CompDbgPortsPresent);

    if (BytePtr != NULL)
    {
        *BytePtr = 0xFF;
    }

    if (PortPtr->Address == NULL)
    {
        return CP_GET_NODATA;
    }
    
    if ((READ_REGISTER_ULONG((PULONG)(PortPtr->Address + UTS)) & RXEMPTY) != 0)
    {
        return CP_GET_NODATA;
    }

    *BytePtr = READ_REGISTER_UCHAR((PUCHAR) (PortPtr->Address + RXD));

    return CP_GET_SUCCESS;
}


KD_HARDWARE_LAYER_DRIVER MX6HardwareLayerDriver = {

    MX6InitializePort,
    MX6PutByte,
    MX6GetByte,
    0, // no transformation while reading or writing to register
};

