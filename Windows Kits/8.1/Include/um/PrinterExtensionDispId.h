//  Microsoft Windows
//  Copyright (c) Microsoft Corporation. All rights reserved.

#ifdef _MSC_VER

#pragma once

#endif // _MSC_VER

#include <winapifamily.h>

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)


#define DISPID_PRINTSCHEMA_ELEMENT                      10000

#define DISPID_PRINTSCHEMA_ELEMENT_XMLNODE                      (DISPID_PRINTSCHEMA_ELEMENT + 1)
#define DISPID_PRINTSCHEMA_ELEMENT_NAME                         (DISPID_PRINTSCHEMA_ELEMENT + 2)
#define DISPID_PRINTSCHEMA_ELEMENT_NAMESPACEURI                 (DISPID_PRINTSCHEMA_ELEMENT + 3)


#define DISPID_PRINTSCHEMA_DISPLAYABLEELEMENT           10100

#define DISPID_PRINTSCHEMA_DISPLAYABLEELEMENT_DISPLAYNAME       (DISPID_PRINTSCHEMA_DISPLAYABLEELEMENT + 1)


#define DISPID_PRINTSCHEMA_OPTION                       10200

#define DISPID_PRINTSCHEMA_OPTION_SELECTED                      (DISPID_PRINTSCHEMA_OPTION + 1)
#define DISPID_PRINTSCHEMA_OPTION_CONSTRAINED                   (DISPID_PRINTSCHEMA_OPTION + 2)
#define DISPID_PRINTSCHEMA_OPTION_GETPROPERTYVALUE              (DISPID_PRINTSCHEMA_OPTION + 3)


#define DISPID_PRINTSCHEMA_PAGEMEDIASIZEOPTION          10300

#define DISPID_PRINTSCHEMA_PAGEMEDIASIZEOPTION_WIDTH            (DISPID_PRINTSCHEMA_PAGEMEDIASIZEOPTION + 1)
#define DISPID_PRINTSCHEMA_PAGEMEDIASIZEOPTION_HEIGHT           (DISPID_PRINTSCHEMA_PAGEMEDIASIZEOPTION + 2)


#define DISPID_PRINTSCHEMA_NUPOPTION                    10400

#define DISPID_PRINTSCHEMA_NUPOPTION_PAGESPERSHEET              (DISPID_PRINTSCHEMA_NUPOPTION + 1)


#define DISPID_PRINTSCHEMA_OPTIONCOLLECTION             10500

#define DISPID_PRINTSCHEMA_OPTIONCOLLECTION_COUNT               (DISPID_PRINTSCHEMA_OPTIONCOLLECTION + 1)
#define DISPID_PRINTSCHEMA_OPTIONCOLLECTION_GETAT               (DISPID_PRINTSCHEMA_OPTIONCOLLECTION + 2)


#define DISPID_PRINTSCHEMA_FEATURE                      10600

#define DISPID_PRINTSCHEMA_FEATURE_SELECTEDOPTION               (DISPID_PRINTSCHEMA_FEATURE + 1)
#define DISPID_PRINTSCHEMA_FEATURE_SELECTIONTYPE                (DISPID_PRINTSCHEMA_FEATURE + 2)
#define DISPID_PRINTSCHEMA_FEATURE_GETOPTION                    (DISPID_PRINTSCHEMA_FEATURE + 3)
#define DISPID_PRINTSCHEMA_FEATURE_DISPLAYUI                    (DISPID_PRINTSCHEMA_FEATURE + 4)


#define DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE            10700

#define DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE_IMAGEABLE_WIDTH    (DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE + 1)
#define DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE_IMAGEABLE_HEIGHT   (DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE + 2)
#define DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE_ORIGIN_WIDTH       (DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE + 3)
#define DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE_ORIGIN_HEIGHT      (DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE + 4)
#define DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE_EXTENT_WIDTH       (DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE + 5)
#define DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE_EXTENT_HEIGHT      (DISPID_PRINTSCHEMA_PAGEIMAGEABLESIZE + 6)


#define DISPID_PRINTSCHEMA_CAPABILITIES                 10800

#define DISPID_PRINTSCHEMA_CAPABILITIES_GETFEATURE_KEYNAME      (DISPID_PRINTSCHEMA_CAPABILITIES + 1)
#define DISPID_PRINTSCHEMA_CAPABILITIES_GETFEATURE              (DISPID_PRINTSCHEMA_CAPABILITIES + 2)
#define DISPID_PRINTSCHEMA_CAPABILITIES_PAGEIMAGEABLESIZE       (DISPID_PRINTSCHEMA_CAPABILITIES + 3)
#define DISPID_PRINTSCHEMA_CAPABILITIES_JOBCOPIESMINVALUE       (DISPID_PRINTSCHEMA_CAPABILITIES + 4)
#define DISPID_PRINTSCHEMA_CAPABILITIES_JOBCOPIESMAXVALUE       (DISPID_PRINTSCHEMA_CAPABILITIES + 5)
#define DISPID_PRINTSCHEMA_CAPABILITIES_GETSELECTEDOPTION       (DISPID_PRINTSCHEMA_CAPABILITIES + 6)
#define DISPID_PRINTSCHEMA_CAPABILITIES_GETOPTIONS              (DISPID_PRINTSCHEMA_CAPABILITIES + 7)
#define DISPID_PRINTSCHEMA_CAPABILITIES_GETPARAMETERDEFINITION  (DISPID_PRINTSCHEMA_CAPABILITIES + 8)


#define DISPID_PRINTSCHEMA_ASYNCOPERATION               10900

#define DISPID_PRINTSCHEMA_ASYNCOPERATION_START                 (DISPID_PRINTSCHEMA_ASYNCOPERATION + 1)
#define DISPID_PRINTSCHEMA_ASYNCOPERATION_CANCEL                (DISPID_PRINTSCHEMA_ASYNCOPERATION + 2)


#define DISPID_PRINTSCHEMA_TICKET                       11000

#define DISPID_PRINTSCHEMA_TICKET_GETFEATURE_KEYNAME            (DISPID_PRINTSCHEMA_TICKET + 1)
#define DISPID_PRINTSCHEMA_TICKET_GETFEATURE                    (DISPID_PRINTSCHEMA_TICKET + 2)
#define DISPID_PRINTSCHEMA_TICKET_VALIDATEASYNC                 (DISPID_PRINTSCHEMA_TICKET + 3)
#define DISPID_PRINTSCHEMA_TICKET_COMMITASYNC                   (DISPID_PRINTSCHEMA_TICKET + 4)
#define DISPID_PRINTSCHEMA_TICKET_NOTIFYXMLCHANGED              (DISPID_PRINTSCHEMA_TICKET + 5)
#define DISPID_PRINTSCHEMA_TICKET_GETCAPABILITIES               (DISPID_PRINTSCHEMA_TICKET + 6)
#define DISPID_PRINTSCHEMA_TICKET_JOBCOPIESALLDOCUMENTS         (DISPID_PRINTSCHEMA_TICKET + 7)
#define DISPID_PRINTSCHEMA_TICKET_GETPARAMETERINITIALIZER       (DISPID_PRINTSCHEMA_TICKET + 8)

#define DISPID_PRINTSCHEMA_ASYNCOPERATIONEVENT          11100

#define DISPID_PRINTSCHEMA_ASYNCOPERATIONEVENT_COMPLETED        (DISPID_PRINTSCHEMA_ASYNCOPERATIONEVENT + 1)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define DISPID_PRINTERSCRIPTABLESEQUENTIALSTREAM        11200

#define DISPID_PRINTERSCRIPTABLESEQUENTIALSTREAM_READ           (DISPID_PRINTERSCRIPTABLESEQUENTIALSTREAM + 1)
#define DISPID_PRINTERSCRIPTABLESEQUENTIALSTREAM_WRITE          (DISPID_PRINTERSCRIPTABLESEQUENTIALSTREAM + 2)


#define DISPID_PRINTERSCRIPTABLESTREAM                  11300

#define DISPID_PRINTERSCRIPTABLESTREAM_COMMIT                   (DISPID_PRINTERSCRIPTABLESTREAM + 1)
#define DISPID_PRINTERSCRIPTABLESTREAM_SEEK                     (DISPID_PRINTERSCRIPTABLESTREAM + 2)
#define DISPID_PRINTERSCRIPTABLESTREAM_SETSIZE                  (DISPID_PRINTERSCRIPTABLESTREAM + 3)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#define DISPID_PRINTERPROPERTYBAG                       11400

#define DISPID_PRINTERPROPERTYBAG_GETBOOL                       (DISPID_PRINTERPROPERTYBAG + 1)
#define DISPID_PRINTERPROPERTYBAG_SETBOOL                       (DISPID_PRINTERPROPERTYBAG + 2)
#define DISPID_PRINTERPROPERTYBAG_GETINT32                      (DISPID_PRINTERPROPERTYBAG + 3)
#define DISPID_PRINTERPROPERTYBAG_SETINT32                      (DISPID_PRINTERPROPERTYBAG + 4)
#define DISPID_PRINTERPROPERTYBAG_GETSTRING                     (DISPID_PRINTERPROPERTYBAG + 5)
#define DISPID_PRINTERPROPERTYBAG_SETSTRING                     (DISPID_PRINTERPROPERTYBAG + 6)
#define DISPID_PRINTERPROPERTYBAG_GETBYTES                      (DISPID_PRINTERPROPERTYBAG + 7)
#define DISPID_PRINTERPROPERTYBAG_SETBYTES                      (DISPID_PRINTERPROPERTYBAG + 8)
#define DISPID_PRINTERPROPERTYBAG_GETREADSTREAM                 (DISPID_PRINTERPROPERTYBAG + 9)
#define DISPID_PRINTERPROPERTYBAG_GETWRITESTREAM                (DISPID_PRINTERPROPERTYBAG + 10)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG            11500

#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_GETBOOL              (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 1)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_SETBOOL              (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 2)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_GETINT32             (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 3)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_SETINT32             (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 4)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_GETSTRING            (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 5)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_SETSTRING            (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 6)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_GETBYTES             (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 7)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_SETBYTES             (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 8)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_GETREADSTREAM        (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 9)
#define DISPID_PRINTERSCRIPTABLEPROPERTYBAG_GETWRITESTREAM       (DISPID_PRINTERSCRIPTABLEPROPERTYBAG + 10)


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#define DISPID_PRINTERQUEUE                             11600

#define DISPID_PRINTERQUEUE_HANDLE                              (DISPID_PRINTERQUEUE + 1)
#define DISPID_PRINTERQUEUE_NAME                                (DISPID_PRINTERQUEUE + 2)
#define DISPID_PRINTERQUEUE_SENDBIDIQUERY                       (DISPID_PRINTERQUEUE + 3)
#define DISPID_PRINTERQUEUE_GETPROPERTIES                       (DISPID_PRINTERQUEUE + 4)
#define DISPID_PRINTERQUEUE_SENDBIDISETREQUESTASYNC             (DISPID_PRINTERQUEUE + 5)
#define DISPID_PRINTERQUEUE_GETPRINTERQUEUEVIEW                 (DISPID_PRINTERQUEUE + 6)


#define DISPID_PRINTERQUEUEEVENT                        11700

#define DISPID_PRINTERQUEUEEVENT_ONBIDIRESPONSERECEIVED         (DISPID_PRINTERQUEUEEVENT + 1)


#define DISPID_PRINTEREXTENSION_CONTEXT                 11800

#define DISPID_PRINTEREXTENSION_CONTEXT_PRINTERQUEUE            (DISPID_PRINTEREXTENSION_CONTEXT + 1)
#define DISPID_PRINTEREXTENSION_CONTEXT_PRINTSCHEMATICKET       (DISPID_PRINTEREXTENSION_CONTEXT + 2)
#define DISPID_PRINTEREXTENSION_CONTEXT_DRIVERPROPERTIES        (DISPID_PRINTEREXTENSION_CONTEXT + 3)
#define DISPID_PRINTEREXTENSION_CONTEXT_USERPROPERTIES          (DISPID_PRINTEREXTENSION_CONTEXT + 4)


#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */

#pragma region Desktop Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP)

#define DISPID_PRINTEREXTENSION_REQUEST                 11900

#define DISPID_PRINTEREXTENSION_REQUEST_CANCEL                  (DISPID_PRINTEREXTENSION_REQUEST + 1)
#define DISPID_PRINTEREXTENSION_REQUEST_COMPLETE                (DISPID_PRINTEREXTENSION_REQUEST + 2)


#define DISPID_PRINTEREXTENSION_EVENTARGS               12000

#define DISPID_PRINTEREXTENSION_EVENTARGS_BIDINOTIFICATION      (DISPID_PRINTEREXTENSION_EVENTARGS + 1)
#define DISPID_PRINTEREXTENSION_EVENTARGS_REASONID              (DISPID_PRINTEREXTENSION_EVENTARGS + 2)
#define DISPID_PRINTEREXTENSION_EVENTARGS_REQUEST               (DISPID_PRINTEREXTENSION_EVENTARGS + 3)
#define DISPID_PRINTEREXTENSION_EVENTARGS_SOURCEAPPLICATION     (DISPID_PRINTEREXTENSION_EVENTARGS + 4)
#define DISPID_PRINTEREXTENSION_EVENTARGS_DETAILEDREASONID      (DISPID_PRINTEREXTENSION_EVENTARGS + 5)
#define DISPID_PRINTEREXTENSION_EVENTARGS_WINDOWMODAL           (DISPID_PRINTEREXTENSION_EVENTARGS + 6)
#define DISPID_PRINTEREXTENSION_EVENTARGS_WINDOWPARENT          (DISPID_PRINTEREXTENSION_EVENTARGS + 7)


#define DISPID_PRINTEREXTENSION_CONTEXTCOLLECTION       12100

#define DISPID_PRINTEREXTENSION_CONTEXTCOLLECTION_COUNT         (DISPID_PRINTEREXTENSION_CONTEXTCOLLECTION + 1)
#define DISPID_PRINTEREXTENSION_CONTEXTCOLLECTION_GETAT         (DISPID_PRINTEREXTENSION_CONTEXTCOLLECTION + 2)


#define DISPID_PRINTEREXTENSION_EVENT                   12200

#define DISPID_PRINTEREXTENSION_EVENT_ONDRIVEREVENT             (DISPID_PRINTEREXTENSION_EVENT + 1)
#define DISPID_PRINTEREXTENSION_EVENT_ONPRINTERQUEUESENUMERATED (DISPID_PRINTEREXTENSION_EVENT + 2)

#define DISPID_PRINTERSCRIPTCONTEXT                     12300

#define DISPID_PRINTERSCRIPTCONTEXT_DRIVERPROPERTIES            (DISPID_PRINTERSCRIPTCONTEXT + 1)
#define DISPID_PRINTERSCRIPTCONTEXT_QUEUEPROPERTIES             (DISPID_PRINTERSCRIPTCONTEXT + 2)
#define DISPID_PRINTERSCRIPTCONTEXT_USERPROPERTIES              (DISPID_PRINTERSCRIPTCONTEXT + 3)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */
#pragma endregion /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP) */

#if (NTDDI_VERSION >= NTDDI_WINBLUE)

#pragma region Application Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP)

#define DISPID_PRINTSCHEMA_PARAMETERINITIALIZER                 12400
#define DISPID_PRINTSCHEMA_PARAMETERINITIALIZER_VALUE           (DISPID_PRINTSCHEMA_PARAMETERINITIALIZER + 1)

#define DISPID_PRINTSCHEMA_PARAMETERDEFINITION                  12500
#define DISPID_PRINTSCHEMA_PARAMETERDEFINITION_USERINPUTREQUIRED    (DISPID_PRINTSCHEMA_PARAMETERDEFINITION + 1)
#define DISPID_PRINTSCHEMA_PARAMETERDEFINITION_UNITTYPE             (DISPID_PRINTSCHEMA_PARAMETERDEFINITION + 2)
#define DISPID_PRINTSCHEMA_PARAMETERDEFINITION_DATATYPE             (DISPID_PRINTSCHEMA_PARAMETERDEFINITION + 3)
#define DISPID_PRINTSCHEMA_PARAMETERDEFINITION_RANGEMIN             (DISPID_PRINTSCHEMA_PARAMETERDEFINITION + 4)
#define DISPID_PRINTSCHEMA_PARAMETERDEFINITION_RANGEMAX             (DISPID_PRINTSCHEMA_PARAMETERDEFINITION + 5)

#define DISPID_PRINTJOBCOLLECTION                               12600
#define DISPID_PRINTJOBCOLLECTION_COUNT                             (DISPID_PRINTJOBCOLLECTION + 1)
#define DISPID_PRINTJOBCOLLECTION_GETAT                             (DISPID_PRINTJOBCOLLECTION + 2)

#define DISPID_PRINTERQUEUEVIEW                                 12700
#define DISPID_PRINTERQUEUEVIEW_SETVIEWRANGE                        (DISPID_PRINTERQUEUEVIEW + 1)

#define DISPID_PRINTERQUEUEVIEW_EVENT                           12800
#define DISPID_PRINTERQUEUEVIEW_EVENT_ONCHANGED                     (DISPID_PRINTERQUEUEVIEW_EVENT + 1)

#endif /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */
#pragma endregion /* WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_APP) */

#endif // (NTDDI_VERSION >= NTDDI_WINBLUE)
