
/*
******************************************************************
                  ***  This is autogenerated file ***
******************************************************************
*/

#ifndef _MODELS_H
#define _MODELS_H


typedef
NTSTATUS
EVT_WDF_CHILD_LIST_CREATE_DEVICE(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER IdentificationDescription,
    PWDFDEVICE_INIT ChildInit
    );

typedef EVT_WDF_CHILD_LIST_CREATE_DEVICE *PFN_WDF_CHILD_LIST_CREATE_DEVICE;

typedef
VOID
EVT_WDF_CHILD_LIST_SCAN_FOR_CHILDREN(
    WDFCHILDLIST ChildList
    );

typedef EVT_WDF_CHILD_LIST_SCAN_FOR_CHILDREN *PFN_WDF_CHILD_LIST_SCAN_FOR_CHILDREN;

typedef
VOID
EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_COPY(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER SourceIdentificationDescription,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER DestinationIdentificationDescription
    );

typedef EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_COPY *PFN_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_COPY;

typedef
NTSTATUS
EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_DUPLICATE(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER SourceIdentificationDescription,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER DestinationIdentificationDescription
    );

typedef EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_DUPLICATE *PFN_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_DUPLICATE;

typedef
BOOLEAN
EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_COMPARE(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER FirstIdentificationDescription,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER SecondIdentificationDescription
    );

typedef EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_COMPARE *PFN_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_COMPARE;

typedef
VOID
EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_CLEANUP(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_IDENTIFICATION_DESCRIPTION_HEADER IdentificationDescription
    );

typedef EVT_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_CLEANUP *PFN_WDF_CHILD_LIST_IDENTIFICATION_DESCRIPTION_CLEANUP;

typedef
VOID
EVT_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_COPY(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_ADDRESS_DESCRIPTION_HEADER SourceAddressDescription,
    PWDF_CHILD_ADDRESS_DESCRIPTION_HEADER DestinationAddressDescription
    );

typedef EVT_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_COPY *PFN_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_COPY;

typedef
NTSTATUS
EVT_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_DUPLICATE(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_ADDRESS_DESCRIPTION_HEADER SourceAddressDescription,
    PWDF_CHILD_ADDRESS_DESCRIPTION_HEADER DestinationAddressDescription
    );

typedef EVT_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_DUPLICATE *PFN_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_DUPLICATE;

typedef
VOID
EVT_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_CLEANUP(
    WDFCHILDLIST ChildList,
    PWDF_CHILD_ADDRESS_DESCRIPTION_HEADER AddressDescription
    );

typedef EVT_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_CLEANUP *PFN_WDF_CHILD_LIST_ADDRESS_DESCRIPTION_CLEANUP;

typedef
BOOLEAN
EVT_WDF_CHILD_LIST_DEVICE_REENUMERATED(
    WDFCHILDLIST ChildList,
    WDFDEVICE OldDevice,
    PWDF_CHILD_ADDRESS_DESCRIPTION_HEADER OldAddressDescription,
    PWDF_CHILD_ADDRESS_DESCRIPTION_HEADER NewAddressDescription
    );

typedef EVT_WDF_CHILD_LIST_DEVICE_REENUMERATED *PFN_WDF_CHILD_LIST_DEVICE_REENUMERATED;

typedef
VOID
EVT_WDF_DEVICE_SHUTDOWN_NOTIFICATION(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_SHUTDOWN_NOTIFICATION *PFN_WDF_DEVICE_SHUTDOWN_NOTIFICATION;

typedef
NTSTATUS
EVT_WDFCXDEVICE_WDM_IRP_PREPROCESS(
    WDFDEVICE Device,
    PIRP Irp,
    WDFCONTEXT DispatchContext
    );

typedef EVT_WDFCXDEVICE_WDM_IRP_PREPROCESS *PFN_WDFCXDEVICE_WDM_IRP_PREPROCESS;

typedef
BOOLEAN
EVT_WDFCX_DEVICE_FILE_CREATE(
    WDFDEVICE Device,
    WDFREQUEST Request,
    WDFFILEOBJECT FileObject
    );

typedef EVT_WDFCX_DEVICE_FILE_CREATE *PFN_WDFCX_DEVICE_FILE_CREATE;

typedef
VOID
EVT_WDF_DEVICE_FILE_CREATE(
    WDFDEVICE Device,
    WDFREQUEST Request,
    WDFFILEOBJECT FileObject
    );

typedef EVT_WDF_DEVICE_FILE_CREATE *PFN_WDF_DEVICE_FILE_CREATE;

typedef
VOID
EVT_WDF_FILE_CLOSE(
    WDFFILEOBJECT FileObject
    );

typedef EVT_WDF_FILE_CLOSE *PFN_WDF_FILE_CLOSE;

typedef
VOID
EVT_WDF_FILE_CLEANUP(
    WDFFILEOBJECT FileObject
    );

typedef EVT_WDF_FILE_CLEANUP *PFN_WDF_FILE_CLEANUP;

typedef
VOID
EVT_WDF_DEVICE_PNP_STATE_CHANGE_NOTIFICATION(
    WDFDEVICE Device,
    PCWDF_DEVICE_PNP_NOTIFICATION_DATA NotificationData
    );

typedef EVT_WDF_DEVICE_PNP_STATE_CHANGE_NOTIFICATION *PFN_WDF_DEVICE_PNP_STATE_CHANGE_NOTIFICATION;

typedef
VOID
EVT_WDF_DEVICE_POWER_STATE_CHANGE_NOTIFICATION(
    WDFDEVICE Device,
    PCWDF_DEVICE_POWER_NOTIFICATION_DATA NotificationData
    );

typedef EVT_WDF_DEVICE_POWER_STATE_CHANGE_NOTIFICATION *PFN_WDF_DEVICE_POWER_STATE_CHANGE_NOTIFICATION;

typedef
VOID
EVT_WDF_DEVICE_POWER_POLICY_STATE_CHANGE_NOTIFICATION(
    WDFDEVICE Device,
    PCWDF_DEVICE_POWER_POLICY_NOTIFICATION_DATA NotificationData
    );

typedef EVT_WDF_DEVICE_POWER_POLICY_STATE_CHANGE_NOTIFICATION *PFN_WDF_DEVICE_POWER_POLICY_STATE_CHANGE_NOTIFICATION;

typedef
NTSTATUS
EVT_WDF_DEVICE_D0_ENTRY(
    WDFDEVICE Device,
    WDF_POWER_DEVICE_STATE PreviousState
    );

typedef EVT_WDF_DEVICE_D0_ENTRY *PFN_WDF_DEVICE_D0_ENTRY;

typedef
NTSTATUS
EVT_WDF_DEVICE_D0_ENTRY_POST_INTERRUPTS_ENABLED(
    WDFDEVICE Device,
    WDF_POWER_DEVICE_STATE PreviousState
    );

typedef EVT_WDF_DEVICE_D0_ENTRY_POST_INTERRUPTS_ENABLED *PFN_WDF_DEVICE_D0_ENTRY_POST_INTERRUPTS_ENABLED;

typedef
NTSTATUS
EVT_WDF_DEVICE_D0_EXIT(
    WDFDEVICE Device,
    WDF_POWER_DEVICE_STATE TargetState
    );

typedef EVT_WDF_DEVICE_D0_EXIT *PFN_WDF_DEVICE_D0_EXIT;

typedef
NTSTATUS
EVT_WDF_DEVICE_D0_EXIT_PRE_INTERRUPTS_DISABLED(
    WDFDEVICE Device,
    WDF_POWER_DEVICE_STATE TargetState
    );

typedef EVT_WDF_DEVICE_D0_EXIT_PRE_INTERRUPTS_DISABLED *PFN_WDF_DEVICE_D0_EXIT_PRE_INTERRUPTS_DISABLED;

typedef
NTSTATUS
EVT_WDF_DEVICE_PREPARE_HARDWARE(
    WDFDEVICE Device,
    WDFCMRESLIST ResourcesRaw,
    WDFCMRESLIST ResourcesTranslated
    );

typedef EVT_WDF_DEVICE_PREPARE_HARDWARE *PFN_WDF_DEVICE_PREPARE_HARDWARE;

typedef
NTSTATUS
EVT_WDF_DEVICE_RELEASE_HARDWARE(
    WDFDEVICE Device,
    WDFCMRESLIST ResourcesTranslated
    );

typedef EVT_WDF_DEVICE_RELEASE_HARDWARE *PFN_WDF_DEVICE_RELEASE_HARDWARE;

typedef
VOID
EVT_WDF_DEVICE_SELF_MANAGED_IO_CLEANUP(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_SELF_MANAGED_IO_CLEANUP *PFN_WDF_DEVICE_SELF_MANAGED_IO_CLEANUP;

typedef
VOID
EVT_WDF_DEVICE_SELF_MANAGED_IO_FLUSH(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_SELF_MANAGED_IO_FLUSH *PFN_WDF_DEVICE_SELF_MANAGED_IO_FLUSH;

typedef
NTSTATUS
EVT_WDF_DEVICE_SELF_MANAGED_IO_INIT(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_SELF_MANAGED_IO_INIT *PFN_WDF_DEVICE_SELF_MANAGED_IO_INIT;

typedef
NTSTATUS
EVT_WDF_DEVICE_SELF_MANAGED_IO_SUSPEND(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_SELF_MANAGED_IO_SUSPEND *PFN_WDF_DEVICE_SELF_MANAGED_IO_SUSPEND;

typedef
NTSTATUS
EVT_WDF_DEVICE_SELF_MANAGED_IO_RESTART(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_SELF_MANAGED_IO_RESTART *PFN_WDF_DEVICE_SELF_MANAGED_IO_RESTART;

typedef
NTSTATUS
EVT_WDF_DEVICE_QUERY_STOP(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_QUERY_STOP *PFN_WDF_DEVICE_QUERY_STOP;

typedef
NTSTATUS
EVT_WDF_DEVICE_QUERY_REMOVE(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_QUERY_REMOVE *PFN_WDF_DEVICE_QUERY_REMOVE;

typedef
VOID
EVT_WDF_DEVICE_SURPRISE_REMOVAL(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_SURPRISE_REMOVAL *PFN_WDF_DEVICE_SURPRISE_REMOVAL;

typedef
VOID
EVT_WDF_DEVICE_USAGE_NOTIFICATION(
    WDFDEVICE Device,
    WDF_SPECIAL_FILE_TYPE NotificationType,
    BOOLEAN IsInNotificationPath
    );

typedef EVT_WDF_DEVICE_USAGE_NOTIFICATION *PFN_WDF_DEVICE_USAGE_NOTIFICATION;

typedef
NTSTATUS
EVT_WDF_DEVICE_USAGE_NOTIFICATION_EX(
    WDFDEVICE Device,
    WDF_SPECIAL_FILE_TYPE NotificationType,
    BOOLEAN IsInNotificationPath
    );

typedef EVT_WDF_DEVICE_USAGE_NOTIFICATION_EX *PFN_WDF_DEVICE_USAGE_NOTIFICATION_EX;

typedef
VOID
EVT_WDF_DEVICE_RELATIONS_QUERY(
    WDFDEVICE Device,
    DEVICE_RELATION_TYPE RelationType
    );

typedef EVT_WDF_DEVICE_RELATIONS_QUERY *PFN_WDF_DEVICE_RELATIONS_QUERY;

typedef
NTSTATUS
EVT_WDF_DEVICE_ARM_WAKE_FROM_S0(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_ARM_WAKE_FROM_S0 *PFN_WDF_DEVICE_ARM_WAKE_FROM_S0;

typedef
NTSTATUS
EVT_WDF_DEVICE_ARM_WAKE_FROM_SX(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_ARM_WAKE_FROM_SX *PFN_WDF_DEVICE_ARM_WAKE_FROM_SX;

typedef
NTSTATUS
EVT_WDF_DEVICE_ARM_WAKE_FROM_SX_WITH_REASON(
    WDFDEVICE Device,
    BOOLEAN DeviceWakeEnabled,
    BOOLEAN ChildrenArmedForWake
    );

typedef EVT_WDF_DEVICE_ARM_WAKE_FROM_SX_WITH_REASON *PFN_WDF_DEVICE_ARM_WAKE_FROM_SX_WITH_REASON;

typedef
VOID
EVT_WDF_DEVICE_DISARM_WAKE_FROM_S0(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_DISARM_WAKE_FROM_S0 *PFN_WDF_DEVICE_DISARM_WAKE_FROM_S0;

typedef
VOID
EVT_WDF_DEVICE_DISARM_WAKE_FROM_SX(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_DISARM_WAKE_FROM_SX *PFN_WDF_DEVICE_DISARM_WAKE_FROM_SX;

typedef
VOID
EVT_WDF_DEVICE_WAKE_FROM_S0_TRIGGERED(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_WAKE_FROM_S0_TRIGGERED *PFN_WDF_DEVICE_WAKE_FROM_S0_TRIGGERED;

typedef
VOID
EVT_WDF_DEVICE_WAKE_FROM_SX_TRIGGERED(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_WAKE_FROM_SX_TRIGGERED *PFN_WDF_DEVICE_WAKE_FROM_SX_TRIGGERED;

typedef
NTSTATUS
EVT_WDFDEVICE_WDM_IRP_PREPROCESS(
    WDFDEVICE Device,
    PIRP Irp
    );

typedef EVT_WDFDEVICE_WDM_IRP_PREPROCESS *PFN_WDFDEVICE_WDM_IRP_PREPROCESS;

typedef
NTSTATUS
EVT_WDFDEVICE_WDM_IRP_DISPATCH(
    WDFDEVICE Device,
    UCHAR MajorFunction,
    UCHAR MinorFunction,
    ULONG Code,
    WDFCONTEXT DriverContext,
    PIRP Irp,
    WDFCONTEXT DispatchContext
    );

typedef EVT_WDFDEVICE_WDM_IRP_DISPATCH *PFN_WDFDEVICE_WDM_IRP_DISPATCH;

typedef
VOID
EVT_WDF_IO_IN_CALLER_CONTEXT(
    WDFDEVICE Device,
    WDFREQUEST Request
    );

typedef EVT_WDF_IO_IN_CALLER_CONTEXT *PFN_WDF_IO_IN_CALLER_CONTEXT;

#if (NTDDI_VERSION >= NTDDI_WIN8)

typedef
NTSTATUS
EVT_WDFDEVICE_WDM_POST_PO_FX_REGISTER_DEVICE(
    WDFDEVICE Device,
    POHANDLE PoHandle
    );

typedef EVT_WDFDEVICE_WDM_POST_PO_FX_REGISTER_DEVICE *PFN_WDFDEVICE_WDM_POST_PO_FX_REGISTER_DEVICE;
#endif

#if (NTDDI_VERSION >= NTDDI_WIN8)

typedef
VOID
EVT_WDFDEVICE_WDM_PRE_PO_FX_UNREGISTER_DEVICE(
    WDFDEVICE Device,
    POHANDLE PoHandle
    );

typedef EVT_WDFDEVICE_WDM_PRE_PO_FX_UNREGISTER_DEVICE *PFN_WDFDEVICE_WDM_PRE_PO_FX_UNREGISTER_DEVICE;
#endif

typedef
NTSTATUS
EVT_WDF_DMA_ENABLER_FILL(
    WDFDMAENABLER DmaEnabler
    );

typedef EVT_WDF_DMA_ENABLER_FILL *PFN_WDF_DMA_ENABLER_FILL;

typedef
NTSTATUS
EVT_WDF_DMA_ENABLER_FLUSH(
    WDFDMAENABLER DmaEnabler
    );

typedef EVT_WDF_DMA_ENABLER_FLUSH *PFN_WDF_DMA_ENABLER_FLUSH;

typedef
NTSTATUS
EVT_WDF_DMA_ENABLER_ENABLE(
    WDFDMAENABLER DmaEnabler
    );

typedef EVT_WDF_DMA_ENABLER_ENABLE *PFN_WDF_DMA_ENABLER_ENABLE;

typedef
NTSTATUS
EVT_WDF_DMA_ENABLER_DISABLE(
    WDFDMAENABLER DmaEnabler
    );

typedef EVT_WDF_DMA_ENABLER_DISABLE *PFN_WDF_DMA_ENABLER_DISABLE;

typedef
NTSTATUS
EVT_WDF_DMA_ENABLER_SELFMANAGED_IO_START(
    WDFDMAENABLER DmaEnabler
    );

typedef EVT_WDF_DMA_ENABLER_SELFMANAGED_IO_START *PFN_WDF_DMA_ENABLER_SELFMANAGED_IO_START;

typedef
NTSTATUS
EVT_WDF_DMA_ENABLER_SELFMANAGED_IO_STOP(
    WDFDMAENABLER DmaEnabler
    );

typedef EVT_WDF_DMA_ENABLER_SELFMANAGED_IO_STOP *PFN_WDF_DMA_ENABLER_SELFMANAGED_IO_STOP;

typedef
BOOLEAN
EVT_WDF_PROGRAM_DMA(
    WDFDMATRANSACTION Transaction,
    WDFDEVICE Device,
    WDFCONTEXT Context,
    WDF_DMA_DIRECTION Direction,
    PSCATTER_GATHER_LIST SgList
    );

typedef EVT_WDF_PROGRAM_DMA *PFN_WDF_PROGRAM_DMA;

typedef
BOOLEAN
EVT_WDF_DMA_TRANSACTION_CONFIGURE_DMA_CHANNEL(
    WDFDMATRANSACTION DmaTransaction,
    WDFDEVICE Device,
    PVOID Context,
    PMDL Mdl,
    size_t Offset,
    size_t Length
    );

typedef EVT_WDF_DMA_TRANSACTION_CONFIGURE_DMA_CHANNEL *PFN_WDF_DMA_TRANSACTION_CONFIGURE_DMA_CHANNEL;

#if (NTDDI_VERSION >= NTDDI_WIN8)

typedef
VOID
EVT_WDF_DMA_TRANSACTION_DMA_TRANSFER_COMPLETE(
    WDFDMATRANSACTION Transaction,
    WDFDEVICE Device,
    WDFCONTEXT Context,
    WDF_DMA_DIRECTION Direction,
    DMA_COMPLETION_STATUS Status
    );

typedef EVT_WDF_DMA_TRANSACTION_DMA_TRANSFER_COMPLETE *PFN_WDF_DMA_TRANSACTION_DMA_TRANSFER_COMPLETE;
#endif

typedef
VOID
EVT_WDF_RESERVE_DMA(
    WDFDMATRANSACTION DmaTransaction,
    PVOID Context
    );

typedef EVT_WDF_RESERVE_DMA *PFN_WDF_RESERVE_DMA;

typedef
VOID
EVT_WDF_DPC(
    WDFDPC Dpc
    );

typedef EVT_WDF_DPC *PFN_WDF_DPC;

typedef
NTSTATUS
EVT_WDF_DRIVER_DEVICE_ADD(
    WDFDRIVER Driver,
    PWDFDEVICE_INIT DeviceInit
    );

typedef EVT_WDF_DRIVER_DEVICE_ADD *PFN_WDF_DRIVER_DEVICE_ADD;

typedef
VOID
EVT_WDF_DRIVER_UNLOAD(
    WDFDRIVER Driver
    );

typedef EVT_WDF_DRIVER_UNLOAD *PFN_WDF_DRIVER_UNLOAD;

typedef
NTSTATUS
EVT_WDF_TRACE_CALLBACK(
    UCHAR minorFunction,
    PVOID dataPath,
    ULONG bufferLength,
    PVOID buffer,
    PVOID context,
    PULONG size
    );

typedef EVT_WDF_TRACE_CALLBACK *PFN_WDF_TRACE_CALLBACK;

typedef
NTSTATUS
EVT_WDF_DEVICE_FILTER_RESOURCE_REQUIREMENTS(
    WDFDEVICE Device,
    WDFIORESREQLIST IoResourceRequirementsList
    );

typedef EVT_WDF_DEVICE_FILTER_RESOURCE_REQUIREMENTS *PFN_WDF_DEVICE_FILTER_RESOURCE_REQUIREMENTS;

typedef
NTSTATUS
EVT_WDF_DEVICE_REMOVE_ADDED_RESOURCES(
    WDFDEVICE Device,
    WDFCMRESLIST ResourcesRaw,
    WDFCMRESLIST ResourcesTranslated
    );

typedef EVT_WDF_DEVICE_REMOVE_ADDED_RESOURCES *PFN_WDF_DEVICE_REMOVE_ADDED_RESOURCES;

typedef
BOOLEAN
EVT_WDF_INTERRUPT_ISR(
    WDFINTERRUPT Interrupt,
    ULONG MessageID
    );

typedef EVT_WDF_INTERRUPT_ISR *PFN_WDF_INTERRUPT_ISR;

typedef
BOOLEAN
EVT_WDF_INTERRUPT_SYNCHRONIZE(
    WDFINTERRUPT Interrupt,
    WDFCONTEXT Context
    );

typedef EVT_WDF_INTERRUPT_SYNCHRONIZE *PFN_WDF_INTERRUPT_SYNCHRONIZE;

typedef
VOID
EVT_WDF_INTERRUPT_DPC(
    WDFINTERRUPT Interrupt,
    WDFOBJECT AssociatedObject
    );

typedef EVT_WDF_INTERRUPT_DPC *PFN_WDF_INTERRUPT_DPC;

typedef
VOID
EVT_WDF_INTERRUPT_WORKITEM(
    WDFINTERRUPT Interrupt,
    WDFOBJECT AssociatedObject
    );

typedef EVT_WDF_INTERRUPT_WORKITEM *PFN_WDF_INTERRUPT_WORKITEM;

typedef
NTSTATUS
EVT_WDF_INTERRUPT_ENABLE(
    WDFINTERRUPT Interrupt,
    WDFDEVICE AssociatedDevice
    );

typedef EVT_WDF_INTERRUPT_ENABLE *PFN_WDF_INTERRUPT_ENABLE;

typedef
NTSTATUS
EVT_WDF_INTERRUPT_DISABLE(
    WDFINTERRUPT Interrupt,
    WDFDEVICE AssociatedDevice
    );

typedef EVT_WDF_INTERRUPT_DISABLE *PFN_WDF_INTERRUPT_DISABLE;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_DEFAULT(
    WDFQUEUE Queue,
    WDFREQUEST Request
    );

typedef EVT_WDF_IO_QUEUE_IO_DEFAULT *PFN_WDF_IO_QUEUE_IO_DEFAULT;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_STOP(
    WDFQUEUE Queue,
    WDFREQUEST Request,
    ULONG ActionFlags
    );

typedef EVT_WDF_IO_QUEUE_IO_STOP *PFN_WDF_IO_QUEUE_IO_STOP;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_RESUME(
    WDFQUEUE Queue,
    WDFREQUEST Request
    );

typedef EVT_WDF_IO_QUEUE_IO_RESUME *PFN_WDF_IO_QUEUE_IO_RESUME;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_READ(
    WDFQUEUE Queue,
    WDFREQUEST Request,
    size_t Length
    );

typedef EVT_WDF_IO_QUEUE_IO_READ *PFN_WDF_IO_QUEUE_IO_READ;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_WRITE(
    WDFQUEUE Queue,
    WDFREQUEST Request,
    size_t Length
    );

typedef EVT_WDF_IO_QUEUE_IO_WRITE *PFN_WDF_IO_QUEUE_IO_WRITE;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_DEVICE_CONTROL(
    WDFQUEUE Queue,
    WDFREQUEST Request,
    size_t OutputBufferLength,
    size_t InputBufferLength,
    ULONG IoControlCode
    );

typedef EVT_WDF_IO_QUEUE_IO_DEVICE_CONTROL *PFN_WDF_IO_QUEUE_IO_DEVICE_CONTROL;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_INTERNAL_DEVICE_CONTROL(
    WDFQUEUE Queue,
    WDFREQUEST Request,
    size_t OutputBufferLength,
    size_t InputBufferLength,
    ULONG IoControlCode
    );

typedef EVT_WDF_IO_QUEUE_IO_INTERNAL_DEVICE_CONTROL *PFN_WDF_IO_QUEUE_IO_INTERNAL_DEVICE_CONTROL;

typedef
VOID
EVT_WDF_IO_QUEUE_IO_CANCELED_ON_QUEUE(
    WDFQUEUE Queue,
    WDFREQUEST Request
    );

typedef EVT_WDF_IO_QUEUE_IO_CANCELED_ON_QUEUE *PFN_WDF_IO_QUEUE_IO_CANCELED_ON_QUEUE;

typedef
VOID
EVT_WDF_IO_QUEUE_STATE(
    WDFQUEUE Queue,
    WDFCONTEXT Context
    );

typedef EVT_WDF_IO_QUEUE_STATE *PFN_WDF_IO_QUEUE_STATE;

typedef
NTSTATUS
EVT_WDF_IO_ALLOCATE_RESOURCES_FOR_RESERVED_REQUEST(
    WDFQUEUE Queue,
    WDFREQUEST Request
    );

typedef EVT_WDF_IO_ALLOCATE_RESOURCES_FOR_RESERVED_REQUEST *PFN_WDF_IO_ALLOCATE_RESOURCES_FOR_RESERVED_REQUEST;

typedef
NTSTATUS
EVT_WDF_IO_ALLOCATE_REQUEST_RESOURCES(
    WDFQUEUE Queue,
    WDFREQUEST Request
    );

typedef EVT_WDF_IO_ALLOCATE_REQUEST_RESOURCES *PFN_WDF_IO_ALLOCATE_REQUEST_RESOURCES;

#if (KMDF_VERSION_MINOR > 7)

typedef
WDF_IO_FORWARD_PROGRESS_ACTION
EVT_WDF_IO_WDM_IRP_FOR_FORWARD_PROGRESS(
    WDFQUEUE Queue,
    PIRP Irp
    );

typedef EVT_WDF_IO_WDM_IRP_FOR_FORWARD_PROGRESS *PFN_WDF_IO_WDM_IRP_FOR_FORWARD_PROGRESS;
#endif

typedef
NTSTATUS
EVT_WDF_IO_TARGET_QUERY_REMOVE(
    WDFIOTARGET IoTarget
    );

typedef EVT_WDF_IO_TARGET_QUERY_REMOVE *PFN_WDF_IO_TARGET_QUERY_REMOVE;

typedef
VOID
EVT_WDF_IO_TARGET_REMOVE_CANCELED(
    WDFIOTARGET IoTarget
    );

typedef EVT_WDF_IO_TARGET_REMOVE_CANCELED *PFN_WDF_IO_TARGET_REMOVE_CANCELED;

typedef
VOID
EVT_WDF_IO_TARGET_REMOVE_COMPLETE(
    WDFIOTARGET IoTarget
    );

typedef EVT_WDF_IO_TARGET_REMOVE_COMPLETE *PFN_WDF_IO_TARGET_REMOVE_COMPLETE;

typedef
VOID
EVT_WDF_OBJECT_CONTEXT_CLEANUP(
    WDFOBJECT Object
    );

typedef EVT_WDF_OBJECT_CONTEXT_CLEANUP *PFN_WDF_OBJECT_CONTEXT_CLEANUP;

typedef
VOID
EVT_WDF_OBJECT_CONTEXT_DESTROY(
    WDFOBJECT Object
    );

typedef EVT_WDF_OBJECT_CONTEXT_DESTROY *PFN_WDF_OBJECT_CONTEXT_DESTROY;

typedef
NTSTATUS
EVT_WDF_DEVICE_RESOURCES_QUERY(
    WDFDEVICE Device,
    WDFCMRESLIST Resources
    );

typedef EVT_WDF_DEVICE_RESOURCES_QUERY *PFN_WDF_DEVICE_RESOURCES_QUERY;

typedef
NTSTATUS
EVT_WDF_DEVICE_RESOURCE_REQUIREMENTS_QUERY(
    WDFDEVICE Device,
    WDFIORESREQLIST IoResourceRequirementsList
    );

typedef EVT_WDF_DEVICE_RESOURCE_REQUIREMENTS_QUERY *PFN_WDF_DEVICE_RESOURCE_REQUIREMENTS_QUERY;

typedef
NTSTATUS
EVT_WDF_DEVICE_EJECT(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_EJECT *PFN_WDF_DEVICE_EJECT;

typedef
NTSTATUS
EVT_WDF_DEVICE_SET_LOCK(
    WDFDEVICE Device,
    BOOLEAN IsLocked
    );

typedef EVT_WDF_DEVICE_SET_LOCK *PFN_WDF_DEVICE_SET_LOCK;

typedef
NTSTATUS
EVT_WDF_DEVICE_ENABLE_WAKE_AT_BUS(
    WDFDEVICE Device,
    SYSTEM_POWER_STATE PowerState
    );

typedef EVT_WDF_DEVICE_ENABLE_WAKE_AT_BUS *PFN_WDF_DEVICE_ENABLE_WAKE_AT_BUS;

typedef
VOID
EVT_WDF_DEVICE_DISABLE_WAKE_AT_BUS(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_DISABLE_WAKE_AT_BUS *PFN_WDF_DEVICE_DISABLE_WAKE_AT_BUS;

typedef
VOID
EVT_WDF_DEVICE_REPORTED_MISSING(
    WDFDEVICE Device
    );

typedef EVT_WDF_DEVICE_REPORTED_MISSING *PFN_WDF_DEVICE_REPORTED_MISSING;

typedef
NTSTATUS
EVT_WDF_DEVICE_PROCESS_QUERY_INTERFACE_REQUEST(
    WDFDEVICE Device,
    LPGUID InterfaceType,
    PINTERFACE ExposedInterface,
    PVOID ExposedInterfaceSpecificData
    );

typedef EVT_WDF_DEVICE_PROCESS_QUERY_INTERFACE_REQUEST *PFN_WDF_DEVICE_PROCESS_QUERY_INTERFACE_REQUEST;

typedef
VOID
EVT_WDF_REQUEST_CANCEL(
    WDFREQUEST Request
    );

typedef EVT_WDF_REQUEST_CANCEL *PFN_WDF_REQUEST_CANCEL;

typedef
VOID
EVT_WDF_REQUEST_COMPLETION_ROUTINE(
    WDFREQUEST Request,
    WDFIOTARGET Target,
    PWDF_REQUEST_COMPLETION_PARAMS Params,
    WDFCONTEXT Context
    );

typedef EVT_WDF_REQUEST_COMPLETION_ROUTINE *PFN_WDF_REQUEST_COMPLETION_ROUTINE;

typedef
VOID
EVT_WDF_TIMER(
    WDFTIMER Timer
    );

typedef EVT_WDF_TIMER *PFN_WDF_TIMER;

typedef
VOID
EVT_WDF_USB_READER_COMPLETION_ROUTINE(
    WDFUSBPIPE Pipe,
    WDFMEMORY Buffer,
    size_t NumBytesTransferred,
    WDFCONTEXT Context
    );

typedef EVT_WDF_USB_READER_COMPLETION_ROUTINE *PFN_WDF_USB_READER_COMPLETION_ROUTINE;

#if defined (SDV_Include_USB_WDF)

typedef
BOOLEAN
EVT_WDF_USB_READERS_FAILED(
    WDFUSBPIPE Pipe,
    NTSTATUS Status,
    USBD_STATUS UsbdStatus
    );

typedef EVT_WDF_USB_READERS_FAILED *PFN_WDF_USB_READERS_FAILED;
#endif

typedef
NTSTATUS
EVT_WDF_WMI_INSTANCE_QUERY_INSTANCE(
    WDFWMIINSTANCE WmiInstance,
    ULONG OutBufferSize,
    PVOID OutBuffer,
    PULONG BufferUsed
    );

typedef EVT_WDF_WMI_INSTANCE_QUERY_INSTANCE *PFN_WDF_WMI_INSTANCE_QUERY_INSTANCE;

typedef
NTSTATUS
EVT_WDF_WMI_INSTANCE_SET_INSTANCE(
    WDFWMIINSTANCE WmiInstance,
    ULONG InBufferSize,
    PVOID InBuffer
    );

typedef EVT_WDF_WMI_INSTANCE_SET_INSTANCE *PFN_WDF_WMI_INSTANCE_SET_INSTANCE;

typedef
NTSTATUS
EVT_WDF_WMI_INSTANCE_SET_ITEM(
    WDFWMIINSTANCE WmiInstance,
    ULONG DataItemId,
    ULONG InBufferSize,
    PVOID InBuffer
    );

typedef EVT_WDF_WMI_INSTANCE_SET_ITEM *PFN_WDF_WMI_INSTANCE_SET_ITEM;

typedef
NTSTATUS
EVT_WDF_WMI_INSTANCE_EXECUTE_METHOD(
    WDFWMIINSTANCE WmiInstance,
    ULONG MethodId,
    ULONG InBufferSize,
    ULONG OutBufferSize,
    PVOID Buffer,
    PULONG BufferUsed
    );

typedef EVT_WDF_WMI_INSTANCE_EXECUTE_METHOD *PFN_WDF_WMI_INSTANCE_EXECUTE_METHOD;

typedef
NTSTATUS
EVT_WDF_WMI_PROVIDER_FUNCTION_CONTROL(
    WDFWMIPROVIDER WmiProvider,
    WDF_WMI_PROVIDER_CONTROL Control,
    BOOLEAN Enable
    );

typedef EVT_WDF_WMI_PROVIDER_FUNCTION_CONTROL *PFN_WDF_WMI_PROVIDER_FUNCTION_CONTROL;

typedef
VOID
EVT_WDF_WORKITEM(
    WDFWORKITEM WorkItem
    );

typedef EVT_WDF_WORKITEM *PFN_WDF_WORKITEM;
typedef EVT_WDF_OBJECT_CONTEXT_CLEANUP EVT_WDF_DEVICE_CONTEXT_CLEANUP;
typedef EVT_WDF_OBJECT_CONTEXT_DESTROY EVT_WDF_DEVICE_CONTEXT_DESTROY;
typedef EVT_WDF_OBJECT_CONTEXT_CLEANUP EVT_WDF_IO_QUEUE_CONTEXT_CLEANUP_CALLBACK;
typedef EVT_WDF_OBJECT_CONTEXT_DESTROY EVT_WDF_IO_QUEUE_CONTEXT_DESTROY_CALLBACK;
typedef EVT_WDF_OBJECT_CONTEXT_CLEANUP EVT_WDF_FILE_CONTEXT_CLEANUP_CALLBACK;
typedef EVT_WDF_OBJECT_CONTEXT_DESTROY EVT_WDF_FILE_CONTEXT_DESTROY_CALLBACK;

#endif  //_MODELS_H
