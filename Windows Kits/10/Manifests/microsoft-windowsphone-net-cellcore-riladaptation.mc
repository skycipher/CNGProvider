<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<!--
Copyright (c) Microsoft Corporation.  All rights reserved.
-->
<!--
Use of this source code is subject to the terms of the Microsoft shared
source or premium shared source license agreement under which you licensed
this source code. If you did not accept the terms of the license agreement,
you are not authorized to use this source code. For the terms of the license,
please see the license agreement between you and Microsoft or, if applicable,
see the SOURCE.RTF on your install media or the root of your tools installation.
THE SOURCE CODE IS PROVIDED "AS IS", WITH NO WARRANTIES OR INDEMNITIES.
-->
<instrumentationManifest
  xmlns="http://schemas.microsoft.com/win/2004/08/events"
  xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <instrumentation>
    <events>
      <provider name="Microsoft-WindowsPhone-Net-CellCore-RilAdaptation"
          guid="{36B10804-E2CD-4205-BE1E-4E4FC18AF6AD}"
          symbol="MICROSOFT_WINDOWSPHONE_NET_CELLCORE_RILADAPTATION"
          messageFileName="NetCellcoreRilAdaptationProviderResources.dll"
          resourceFileName="NetCellcoreRilAdaptationProviderResources.dll">

        <channels />

        <keywords>
          <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
          <keyword mask="0x0000000000000001" name="Error"           message="$(string.Keyword.Error)" />
          <keyword mask="0x0000000000000002" name="Performance"     message="$(string.Keyword.Performance)" />
          <!-- Other keywords are provider-specific. -->
          <keyword mask="0x0000000000000004" name="Tracing"         message="$(string.Keyword.Tracing)" />
          <keyword mask="0x0000000000000008" name="CommandLogging"  message="$(string.Keyword.CommandLogging)" />
          <keyword mask="0x0000000000000010" name="SCMLogging"      message="$(string.Keyword.SCMLogging)" />
        </keywords>

        <tasks>
          <task value="1" name="RilAdaptationService" />
          <task value="2" name="ModemDriver" />
          <task value="3" name="RilAdaptationInstance" />
          <task value="4" name="Telephony" />
          <task value="5" name="LogControl" />
          <task value="6" name="ModemFilter" />
          <task value="7" name="Registration" />
          <task value="8" name="Sms" />
        </tasks>

        <templates>
          <template tid="tDword">
            <data name="dwCode" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="tUInt">
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="2tDwords">
            <data name="dwCode1" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="3tDwords">
            <data name="dwCode1" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode3" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="4tDwords">
            <data name="dwCode1" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode3" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode4" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="AnsiStringAndtDword">
            <data name="szString" inType="win:AnsiString" />
            <data name="dwCode"  inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="AnsiStringAnd2tDwords">
            <data name="szString" inType="win:AnsiString" />
            <data name="dwCode1"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2"  inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="AnsiStringAnd3tDwords">
            <data name="szString" inType="win:AnsiString" />
            <data name="dwCode1"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode3"  inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="AnsiStringAnd4tDwords">
            <data name="szString" inType="win:AnsiString" />
            <data name="dwCode1"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode3"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode4"  inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="AnsiStringAnd5tDwords">
            <data name="szString" inType="win:AnsiString" />
            <data name="dwCode1"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode3"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode4"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode5"  inType="win:UInt32" outType="win:HexInt32" />            
          </template>
          
          <template tid="tDwordAndAnsiString">
            <data name="dwErrorCode" inType="win:UInt32" outType="win:HexInt32" />
            <data name="szString"    inType="win:AnsiString" />
          </template>

          <template tid="tDwordAndString">
            <data name="dwCode"   inType="win:UInt32" outType="win:HexInt32" />
            <data name="szString" inType="win:UnicodeString" />
          </template>

          <template tid="2tDwordsAndString">
            <data name="dwCode1"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="szString" inType="win:UnicodeString" />
          </template>

          <template tid="tFixedSizeByteArray">
            <data name="buffer" inType="win:UInt8" count="128"/>
          </template>

          <template tid="tVariableSizeByteArray">
            <data name="cbSize" inType="win:UInt32" />
            <data name="buffer" inType="win:UInt8" count="cbSize"/>
          </template>
        </templates>

        <events>
          <!-- Service -->
          <event value="100"
              symbol="RilAdaptationService_Start"
              task="RilAdaptationService"
              keywords="Performance"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.RilAdaptationServiceStart)" />

          <event value="101"
              symbol="RilAdaptationService_Stop"
              task="RilAdaptationService"
              keywords="Performance"
              level="win:Informational"
              opcode="win:Stop"
              message="$(string.Event.RilAdaptationServiceStop)" />

          <event value="102"
              symbol="RilAdaptationService_Critical"
              task="RilAdaptationService"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.RilAdaptationServiceCritical)" />

          <event value="103"
              symbol="RilAdaptationServiceSCMReport"
              task="RilAdaptationService"
              keywords="SCMLogging"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RilAdaptationServiceSCMReport)" />

          <event value="104"
              symbol="RilAdaptationServiceSCMRequest"
              task="RilAdaptationService"
              keywords="SCMLogging"
              level="win:Informational"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.RilAdaptationServiceSCMRequest)" />

          <!-- Modem Driver Instance -->
          <event value="200"
              symbol="ModemDriver_Start"
              task="ModemDriver"
              keywords="Performance"
              level="win:Informational"
              opcode="win:Start"
              template="tDword"
              message="$(string.Event.ModemDriverStart)" />

          <event value="201"
              symbol="ModemDriver_Stop"
              task="ModemDriver"
              keywords="Performance"
              level="win:Informational"
              opcode="win:Stop"
              template="tDword"
              message="$(string.Event.ModemDriverStop)" />

          <event value="202"
              symbol="ModemDriver_PipeBrokenToBelow"
              task="ModemDriver"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              message="$(string.Event.ModemDriverPipeBrokenToBelow)" />

          <event value="203"
              symbol="ModemDriver_PipeBrokenFromBelow"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              message="$(string.Event.ModemDriverPipeBrokenFromBelow)" />

          <event value="204"
              symbol="ModemDriver_StateChange"
              task="ModemDriver"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.ModemDriverStateChange)" />

          <event value="205"
              symbol="ModemDriver_EventFailure"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.ModemDriverEventFailure)" />

          <event value="206"
              symbol="ModemDriver_HandleFailure"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.ModemDriverHandleFailure)" />

          <event value="207"
              symbol="ModemDriver_RILOpenFailure"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              message="$(string.Event.ModemDriverRILOpenFailure)" />

          <event value="208"
              symbol="ModemDriver_RILOpen"
              task="ModemDriver"
              keywords="Tracing"
              level="win:Verbose"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.ModemDriverRILOpen)" />

          <event value="209"
              symbol="ModemDriver_InitNotificationFailure"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              message="$(string.Event.ModemDriverInitNotificationFailure)" />

          <event value="210"
              symbol="ModemDriver_WatchDogFired"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.ModemDriverWatchDogFired)" />

          <event value="211"
              symbol="ModemDriver_Critical"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.ModemDriverCritical)" />

          <event value="212"
              symbol="ModemDriver_IOControlFailure"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.ModemDriverIOControlFailure)" />

          <event value="213"
              symbol="ModemDriver_IOControl"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Verbose"
              opcode="win:Info"
              template="AnsiStringAnd3tDwords"
              message="$(string.Event.ModemDriverIOControl)" />

          <event value="214"
              symbol="ModemDriver_Notification"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Verbose"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.ModemDriverNotification)" />

          <event value="215"
              symbol="ModemDriver_NotificationMemory"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Verbose"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.ModemDriverNotificationMemory)" />

          <event value="216"
              symbol="ModemDriver_CreateCommandDone"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Verbose"
              opcode="win:Info"
              template="AnsiStringAnd4tDwords"
              message="$(string.Event.ModemDriverCreateCommandDone)" />

          <event value="217"
              symbol="ModemDriver_CreateIndicateStatusMsg"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Verbose"
              opcode="win:Info"
              template="AnsiStringAnd3tDwords"
              message="$(string.Event.ModemDriverCreateIndicateStatusMsg)" />

          <event value="218"
              symbol="ModemDriver_AsyncError"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Warning"
              opcode="win:Info"
              template="AnsiStringAnd5tDwords"
              message="$(string.Event.ModemDriverAsyncError)" />

          <event value="219"
              symbol="ModemDriver_ModemPacketFailure"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              message="$(string.Event.ModemDriverPacketFailure)" />

          <event value="220"
              symbol="ModemDriver_MBBMessage"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Informational"
              opcode="win:Info"
              template="AnsiStringAnd2tDwords"
              message="$(string.Event.ModemDriverMBBMessage)" />

          <event value="221"
              symbol="ModemDriver_WnfDMWapPushSvcReady"
              task="ModemDriver"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.ModemDriverWnfDMWapPushSvcReady)" />

          <event value="222"
              symbol="ModemDriver_WnfDMWapPushSvcReadyInvalidParam"
              task="ModemDriver"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              message="$(string.Event.ModemDriverWnfDMWapPushSvcReadyInvalidParam)" />

          <event value="223"
              symbol="ModemDriver_HoldUnsolicited"
              task="ModemDriver"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              template="AnsiStringAndtDword"
              message="$(string.Event.ModemDriverHoldUnsolicited)" />

          <event value="224"
              symbol="ModemDriver_AsyncOK"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.ModemDriverAsyncOK)" />              

          <event value="225"
              symbol="ModemDriver_MBBCmdMessage"
              task="ModemDriver"
              keywords="CommandLogging"
              level="win:Informational"
              opcode="win:Info"
              template="AnsiStringAnd4tDwords"
              message="$(string.Event.ModemDriverMBBCmdMessage)" />              

          <event value="226"
              symbol="ModemDriver_NotMatchedResponse"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.ModemDriverNotMatchedResponse)" />

          <event value="227"
              symbol="ModemDriver_MultipleMatchedResponse"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.ModemDriverMultipleMatchedResponse)" />

          <event value="228"
              symbol="ModemDriver_CreateLoggingObjectsFailed"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              message="$(string.Event.ModemDriverCreateLoggingObjectsFailed)" />

          <event value="229"
              symbol="ModemDriver_OpenLogControlFailed"
              task="ModemDriver"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              message="$(string.Event.ModemDriverOpenLogControlFailed)" />
              
          <event value="230"
              symbol="ModemDriver_LogControlIOControlFailure"
              task="ModemDriver"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.ModemDriverLogControlIOControlFailure)" />

          <!-- General -->
          <event value="300"
              symbol="RilAdaptationService_Registry_Fail"
              task="RilAdaptationService"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDwordAndAnsiString"
              message="$(string.Event.RASRegistryFail)" />

          <event value="301"
              symbol="RilAdaptationService_Registry_Default"
              task="RilAdaptationService"
              keywords="Error"
              level="win:Warning"
              opcode="win:Info"
              template="tDwordAndAnsiString"
              message="$(string.Event.RASRegistryDefault)" />
              
          <!-- RAS Instance -->
          <event value="400"
              symbol="RilAdaptationInstance_Start"
              task="RilAdaptationInstance"
              keywords="Performance"
              level="win:Informational"
              opcode="win:Start"
              template="tDword"
              message="$(string.Event.RASStart)" />

          <event value="401"
              symbol="RilAdaptationInstance_Stop"
              task="RilAdaptationInstance"
              keywords="Performance"
              level="win:Informational"
              opcode="win:Stop"
              template="tDword"
              message="$(string.Event.RASStop)" />

          <event value="402"
              symbol="RASDriverLoad"
              task="RilAdaptationInstance"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordAndString"
              message="$(string.Event.RASDriverLoad)" />

          <event value="403"
              symbol="RASDriverLoadFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="2tDwordsAndString"
              message="$(string.Event.RASDriverLoadFailure)" />

          <event value="404"
              symbol="RASDriverVersion"
              task="RilAdaptationInstance"
              keywords="Tracing"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RASDriverVersion)" />

          <event value="405"
              symbol="RASDriverVersionFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RASDriverVersionFailure)" />

          <event value="406"
              symbol="RASRILInitFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.RASRILInitFailure)" />

          <event value="407"
              symbol="RASRILInit"
              task="RilAdaptationInstance"
              keywords="Tracing"
              level="win:Verbose"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RASRILInit)" />

          <event value="408"
              symbol="RASFailedMuxCreation"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.RASFailedMuxCreation)" />

          <event value="409"
              symbol="RASFailedMuxCreateFile"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.RASFailedMuxCreateFile)" />

          <event value="410"
              symbol="RASEventFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.RASEventFailure)" />

          <event value="411"
              symbol="RASWaitForMuxReady"
              task="RilAdaptationInstance"
              keywords="Tracing Performance"
              level="win:Informational"
              opcode="win:Start"
              template="tUInt"
              message="$(string.Event.RASWaitForMuxReady)" />

          <event value="412"
              symbol="RASMuxReady"
              task="RilAdaptationInstance"
              keywords="Tracing Performance"
              level="win:Informational"
              opcode="win:Stop"
              template="tUInt"
              message="$(string.Event.RASMuxReady)" />

          <event value="413"
              symbol="RASMuxReadyFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tUInt"
              message="$(string.Event.RASMuxReadyFailure)" />

          <event value="414"
              symbol="RASMuxReadyNotification"
              task="RilAdaptationInstance"
              keywords="Tracing"
              level="win:Verbose"
              opcode="win:Info"
              message="$(string.Event.RASMuxReadyNotification)" />

          <event value="415"
              symbol="RASMuxNotReadyNotification"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RASMuxNotReadyNotification)" />

          <event value="416"
              symbol="RASUnknownMuxNotification"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.RASUnknownMuxNotification)" />

          <event value="417"
              symbol="RASMuxRemovalFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tUInt"
              message="$(string.Event.RASMuxRemovalFailure)" />

          <event value="418"
              symbol="RASWaitForMsrilReady"
              task="RilAdaptationInstance"
              keywords="Tracing Performance"
              level="win:Informational"
              opcode="win:Start"
              template="tUInt"
              message="$(string.Event.RASWaitForMsrilReady)" />

          <event value="419"
              symbol="RASMsrilReady"
              task="RilAdaptationInstance"
              keywords="Tracing Performance"
              level="win:Informational"
              opcode="win:Stop"
              template="tUInt"
              message="$(string.Event.RASMsrilReady)" />

          <event value="420"
              symbol="RASMsrilReadyFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tUInt"
              message="$(string.Event.RASMsrilReadyFailure)" />

          <event value="421"
              symbol="RASMsrilReadyNotification"
              task="RilAdaptationInstance"
              keywords="Tracing"
              level="win:Verbose"
              opcode="win:Info"
              message="$(string.Event.RASMsrilReadyNotification)" />

          <event value="422"
              symbol="RASMsrilNotReadyNotification"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RASMsrilNotReadyNotification)" />

          <event value="423"
              symbol="RASMuxCreationFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tUInt"
              message="$(string.Event.RASMuxCreationFailure)" />

          <event value="424"
              symbol="RASInterconnectCreationFailure"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="tUInt"
              message="$(string.Event.RASInterconnectCreationFailure)" />   

          <event value="425"
              symbol="RASWaitForCellMuxStopped"
              task="RilAdaptationInstance"
              keywords="Error"
              level="win:Critical"
              opcode="win:Info"
              template="AnsiStringAndtDword"
              message="$(string.Event.RASWaitForCellMuxStopped)" />           

          <!-- Modem Telephony Logging -->
          <event value="500"
              symbol="Telephony_TriggerLogging"
              task="Telephony"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.TelephonyTriggerLogging)" />              

          <event value="501"
              symbol="Telephony_InvalidCommandForState"
              task="Telephony"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.TelephonyInvalidCommandForState)" />              

          <event value="502"
              symbol="Telephony_InvalidResponseCommandForState"
              task="Telephony"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.TelephonyInvalidResponseCommandForState)" />              

          <event value="503"
              symbol="Telephony_CommandFailedForState"
              task="Telephony"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.TelephonyCommandFailedForState)" />              

          <event value="504"
              symbol="Telephony_InvalidNotificationForState"
              task="Telephony"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.TelephonyInvalidNotificationForState)" />              

          <event value="505"
              symbol="Telephony_CallDropForState"
              task="Telephony"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.TelephonyCallDropForState)" />              

          <!-- Modem Registration Logging -->
          <event value="510"
              symbol="Registration_TriggerLogging"
              task="Registration"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.RegistrationTriggerLogging)" />              

          <event value="511"
              symbol="Registration_InvalidCommandForState"
              task="Registration"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RegistrationInvalidCommandForState)" />              

          <event value="512"
              symbol="Registration_InvalidResponseCommandForState"
              task="Registration"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RegistrationInvalidResponseCommandForState)" />              

          <event value="513"
              symbol="Registration_CommandFailedForState"
              task="Registration"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RegistrationCommandFailedForState)" />              

          <event value="514"
              symbol="Registration_InvalidNotificationForState"
              task="Registration"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RegistrationInvalidNotificationForState)" />              

          <event value="515"
              symbol="Registration_RegistrationDropForState"
              task="Registration"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.RegistrationRegistrationDropForState)" />              

              <!-- LogControl -->
          <event value="520"
              symbol="LogControl_ErrorAccessingFilterRegistry"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.LogControlErrorAccessingFilterRegistry)" />              

          <event value="521"
              symbol="LogControl_OpenQCDiagRouterFailed"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlOpenQCDiagRouterFailed)" />              
              
          <event value="522"
              symbol="LogControl_OpenQCDiagBridgeFailed"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlOpenQCDiagBridgeFailed)" />              

          <event value="523"
              symbol="LogControl_TimerFailed"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlTimerFailed)" />              

          <event value="524"
              symbol="LogControl_RegisterCallbackFailed"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlRegisterCallbackFailed)" />              

          <event value="525"
              symbol="LogControl_UnregisterCallbackFailed"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlUnregisterCallbackFailed)" />              

          <event value="526"
              symbol="LogControl_QCDiagBridgeIOControlFailure"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="4tDwords"
              message="$(string.Event.LogControlQCDiagBridgeIOControlFailure)" />              

          <event value="527"
              symbol="LogControl_QCDiagBridgeIOControlRetry"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="4tDwords"
              message="$(string.Event.LogControlQCDiagBridgeIOControlRetry)" />              

          <event value="528"
              symbol="LogControl_QCDiagBridgeIOControlSuccess"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="4tDwords"
              message="$(string.Event.LogControlQCDiagBridgeIOControlSuccess)" />              

          <event value="529"
              symbol="LogControl_QCDiagRouterIOControlFailure"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlQCDiagRouterIOControlFailure)" />              

          <event value="530"
              symbol="LogControl_QCDiagRouterIOControlRetry"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlQCDiagRouterIOControlRetry)" />              

          <event value="531"
              symbol="LogControl_QCDiagRouterIOControlSuccess"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="2tDwords"
              message="$(string.Event.LogControlQCDiagRouterIOControlSuccess)" />              

          <event value="532"
              symbol="LogControl_ErrorFilterIndexString"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.LogControlErrorFilterIndexString)" />

              <!-- Modem Filter -->
          <event value="540"
              symbol="Filter_CannotOpenFilterFile"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordAndString"
              message="$(string.Event.FilterCannotOpenFilterFile)" />              

          <event value="541"
              symbol="Filter_ErrorReadFilterFile"
              task="ModemFilter"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordAndString"
              message="$(string.Event.FilterErrorReadFilterFile)" />              

          <!-- Modem SMS Logging -->
          <event value="550"
              symbol="Sms_TriggerLogging"
              task="Sms"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="tDword"
              message="$(string.Event.SmsTriggerLogging)" />              

          <event value="551"
              symbol="Sms_InvalidCommandForState"
              task="Sms"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.SmsInvalidCommandForState)" />              

          <event value="552"
              symbol="Sms_InvalidResponseCommandForState"
              task="Sms"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.SmsInvalidResponseCommandForState)" />              

          <event value="553"
              symbol="Sms_CommandFailedForState"
              task="Sms"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.SmsCommandFailedForState)" />              

          <event value="554"
              symbol="Sms_InvalidNotificationForState"
              task="Sms"
              keywords="Error"
              level="win:Informational"
              opcode="win:Info"
              template="3tDwords"
              message="$(string.Event.SmsInvalidNotificationForState)" />              

              </events>

      </provider>
    </events>
  </instrumentation>

  <localization>
    <resources culture="en-US">
      <stringTable>
        <!-- General -->
        <string id="Keyword.Error"                              value="Error" />
        <string id="Keyword.Performance"                        value="Performance" />
        <string id="Keyword.Tracing"                            value="Tracing" />
        <string id="Keyword.CommandLogging"                     value="IHVRIL IOCommand Tracing" />
        <string id="Keyword.SCMLogging"                         value="SCM Command Tracing" />

        <string id="Event.RASRegistryFail"                      value="[RAS]Mandatory registry key [%2] missing from registry. Error code:%1" />
        <string id="Event.RASRegistryDefault"                   value="[RAS]Failed to retrieve key [%2] from registry, Error code:%1. Switching to default value instead" />

        <!-- Service -->
        <string id="Event.RilAdaptationServiceStart"            value="[RAS]RilAdaptation Service Starting" />
        <string id="Event.RilAdaptationServiceStop"             value="[RAS]RilAdaptation Service Stopping" />
        <string id="Event.RilAdaptationServiceCritical"         value="[RAS]RilAdaptation Service Critical Error [%2] on line [%1]" />
        <string id="Event.RilAdaptationServiceSCMReport"        value="[RAS]Report to SCM: State:%1, Controls Accepted:%2, CheckPoint#:%3" />
        <string id="Event.RilAdaptationServiceSCMRequest"       value="[RAS]Request from SCM:%1" />

        <!-- RAS Driver -->
        <string id="Event.RASStart"                             value="[RAS]RilAdaptation Instance %1 is created" />
        <string id="Event.RASStop"                              value="[RAS]RilAdaptation Instance %1 is destructed" />
        <string id="Event.RASDriverLoad"                        value="[RAS]Loading IHVRIL Driver for Instance %1 (%2)" />
        <string id="Event.RASDriverLoadFailure"                 value="[RAS]Failed to load IHVRIL Driver (%3) for Instance %1 with error:%2" />
        <string id="Event.RASDriverVersion"                     value="[RAS]IHVRIL Version Negotiation. Supported Versions(L:%1,H:%2), NegotiatedVersion:%3" />
        <string id="Event.RASDriverVersionFailure"              value="[RAS]IHVRIL Version Negotiation Failure. Supported Versions(L:%1,H:%2), NegotiatedVersion:%3" />
        <string id="Event.RASRILInitFailure"                    value="[RAS]Failed Ril_Init for Instance:%1, RILInitIndex:%2. The IHVRIL driver did not initialize correctly" />
        <string id="Event.RASRILInit"                           value="[RAS]Ril_Init Instance:%1, RILInitIndex:%2 completed in %3 ms" />
        <string id="Event.RASFailedMuxCreation"                 value="[RAS]Failed to create Mux Queue for Instance:%1" />
        <string id="Event.RASFailedMuxCreateFile"               value="[RAS]CreateFile on Mux for Instance:%1 failed" />
        <string id="Event.RASEventFailure"                      value="[RAS]Failed Event Create or Close on line %1 with error %2" />
        <string id="Event.RASWaitForMuxReady"                   value="[RAS]Waiting for Mux Device on Instance %1 to become ready" />
        <string id="Event.RASMuxReady"                          value="[RAS]Mux Device ready in %1 ms" />
        <string id="Event.RASMuxReadyFailure"                   value="[RAS]The Mux Device did not become ready in %1 ms. This indicates a problem with the MUX driver." />
        <string id="Event.RASMuxReadyNotification"              value="[RAS]Received a Mux Device ready notification." />
        <string id="Event.RASMuxRemovalFailure"                 value="[RAS]The Mux Device did not become removed in %1 ms. This indicates a problem with the MUX driver." />        
        <string id="Event.RASMuxNotReadyNotification"           value="[RAS]Received a Mux Device NOT ready notification. This indicates a problem with the MUX driver." />
        <string id="Event.RASUnknownMuxNotification"            value="[RAS]Received an unknown Mux Device notification: %1" />
        <string id="Event.RASWaitForMsrilReady"                 value="[RAS]Waiting for Msril Device on Instance %1 to become ready" />
        <string id="Event.RASMsrilReady"                        value="[RAS]Msril Device ready in %1 ms" />
        <string id="Event.RASMsrilReadyFailure"                 value="[RAS]The Msril Device did not become ready in %1 ms. This indicates a problem with the Msril driver." />
        <string id="Event.RASMsrilReadyNotification"            value="[RAS]Received a Msril Device ready notification." />
        <string id="Event.RASMsrilNotReadyNotification"         value="[RAS]Received a Msril Device NOT ready notification. This indicates a problem with the Msril driver." />
        <string id="Event.RASMuxCreationFailure"                value="[RAS]Failed to create MUX in %1 ms." />
        <string id="Event.RASInterconnectCreationFailure"       value="[RAS]Failed to create Interconnect in %1 ms." />
        <string id="Event.RASWaitForCellMuxStopped"             value="[RAS]WaitForCellMuxStopped: %1 Failed with Error Code %2." />
        
        <!-- Modem Driver -->
        <string id="Event.ModemDriverStart"                     value="[RAS:MD]ModemDriver %1 is created" />
        <string id="Event.ModemDriverStop"                      value="[RAS:MD]ModemDriver %1 is destructed" />
        <string id="Event.ModemDriverPipeBrokenToBelow"         value="[RAS:MD]Issuing a PipeBroken to EMB stack in preparation for Cellcore stack shutdown" />
        <string id="Event.ModemDriverPipeBrokenFromBelow"       value="[RAS:MD]Received a PipeBroken from the EMB stack. This will cause a Cellcore stack shutdown" />
        <string id="Event.ModemDriverStateChange"               value="[RAS:MD]Changing state from %1 --> %2" />
        <string id="Event.ModemDriverEventFailure"              value="[RAS:MD]Failed Event Create or Close on line %1 with error %2" />
        <string id="Event.ModemDriverHandleFailure"             value="[RAS:MD]Failed Handle on line %1 with error %2" />
        <string id="Event.ModemDriverRILOpenFailure"            value="[RAS:MD]Failed Ril_Open. The IHVRIL driver did not initialize correctly" />
        <string id="Event.ModemDriverRILOpen"                   value="[RAS:MD]Ril_Open(%1) completed in %2 ms" />
        <string id="Event.ModemDriverInitNotificationFailure"   value="[RAS:MD]Failed RIL_COMMAND_INITNOTIFICATIONS handshake with IHVRIL" />
        <string id="Event.ModemDriverWatchDogFired"             value="[RAS:MD]The IHVRIL interface WatchDog fired from %1. IHVRIL took too long to process the request" />
        <string id="Event.ModemDriverCritical"                  value="[RAS:MD]ModemDriver Critical Error %2 on line %1" />
        <string id="Event.ModemDriverIOControlFailure"          value="[RAS:MD]Ril_IOControl (%1) failed on IHVRIL. Did we send a malformed or unsupported request?" />
        <string id="Event.ModemDriverIOControl"                 value="[RAS:MD]Ril_IOControl %1(%2) returned %3 bytes in %4 ms" />
        <string id="Event.ModemDriverNotification"              value="[RAS:MD]IHVRIL Notification Event %1" />
        <string id="Event.ModemDriverNotificationMemory"        value="[RAS:MD]IHVRIL Notification requires more memory to be allocated. Have %1, need %2" />
        <string id="Event.ModemDriverCreateCommandDone"         value="[RAS:MD]CreateCommandDone (Async Response) %1(%2) - TransactionID:%3, CommandID:%4, PayloadSize:%5" />
        <string id="Event.ModemDriverCreateIndicateStatusMsg"   value="[RAS:MD]CreateIndicateStatusMsg (Unsolicited Response) %1(%2) - TransactionID:%3, PayloadSize:%4" />
        <string id="Event.ModemDriverAsyncError"                value="[RAS:MD]Async Response Error hResult:%1(%2) - TransactionID:%3, CommandID:%4, dwCode:%5, 3gppCause:%6" />
        <string id="Event.ModemDriverPacketFailure"             value="[RAS:MD]ModemPacket creation failure" />
        <string id="Event.ModemDriverMBBMessage"                value="[RAS:MD]%1(%2) - TransactionID:%3" />
        <string id="Event.ModemDriverWnfDMWapPushSvcReady"      value="[RAS:MD]The DMWapPushSvc ready WNF notification received:%1" />
        <string id="Event.ModemDriverWnfDMWapPushSvcReadyInvalidParam"  value="[RAS:MD]The DMWapPushSvc ready WNF notification received invalid parameter" />
        <string id="Event.ModemDriverHoldUnsolicited"           value="[RAS:MD]Hold Unsolicited %1(%2) due to services are not ready yet" />
        <string id="Event.ModemDriverAsyncOK"                   value="[RAS:MD]Async Response OK - TransactionID:%1, CommandID:%2, PayloadSize:%3" />
        <string id="Event.ModemDriverMBBCmdMessage"             value="[RAS:MD]%1(%2) - TransactionID:%3, CommandID:%4, PayloadSize:%5" />
        <string id="Event.ModemDriverNotMatchedResponse"        value="[RAS:MD]ModemDriver Critical Error: No pending request for the reponse (TransactionID=%1)" />
        <string id="Event.ModemDriverMultipleMatchedResponse"   value="[RAS:MD]ModemDriver Critical Error: Multiple pending requests for the reponse (TransactionID=%1)" />
        <string id="Event.ModemDriverCreateLoggingObjectsFailed"   value="[RAS:MD]ModemDriver Critical Error: Logging Enabled but couldn't create logging objects)" />
        <string id="Event.ModemDriverOpenLogControlFailed"      value="[RAS:MD]ModemDriver: Failed opening LogControl; disable logging; probably running on FakeModem)" />
        <string id="Event.ModemDriverLogControlIOControlFailure"   value="[RAS:MD]LogControl_IOControl: (%1) failed. Did we send a malformed or unsupported request?" />

        <!-- Modem Telephony Logging -->
        <string id="Event.TelephonyTriggerLogging"                   value="[RAS:TelephonyLogging]Logging triggered for call=%1" />
        <string id="Event.TelephonyInvalidCommandForState"           value="[RAS:TelephonyLogging]Invalid command=%1 while in state=%2 for call=%3" />
        <string id="Event.TelephonyInvalidResponseCommandForState"   value="[RAS:TelephonyLogging]Invalid response for command=%1 while in state=%2 for call=%3" />
        <string id="Event.TelephonyCommandFailedForState"            value="[RAS:TelephonyLogging]Command=%1 failed while in state=%2 for call=%3" />
        <string id="Event.TelephonyInvalidNotificationForState"      value="[RAS:TelephonyLogging]Invalid notification=%1 while in state=%2 for call=%3" />
        <string id="Event.TelephonyCallDropForState"                 value="[RAS:TelephonyLogging]CALL DROP - reason=%1 while in state=%2 for call=%3" />

        <!-- Modem Registration Logging -->
        <string id="Event.RegistrationTriggerLogging"                   value="[RAS:RegistrationLogging]Logging triggered for registration=%1" />
        <string id="Event.RegistrationInvalidCommandForState"           value="[RAS:RegistrationLogging]Invalid command=%1 while in state=%2 for registration=%3" />
        <string id="Event.RegistrationInvalidResponseCommandForState"   value="[RAS:RegistrationLogging]Invalid response for command=%1 while in state=%2 for registration=%3" />
        <string id="Event.RegistrationCommandFailedForState"            value="[RAS:RegistrationLogging]Command=%1 failed while in state=%2 for registration=%3" />
        <string id="Event.RegistrationInvalidNotificationForState"      value="[RAS:RegistrationLogging]Invalid notification=%1 while in state=%2 for registration=%3" />
        <string id="Event.RegistrationRegistrationDropForState"         value="[RAS:RegistrationLogging]Registration DROP - reason=%1 while in state=%2 for registration=%3" />

        <!-- Modem Sms Logging -->
        <string id="Event.SmsTriggerLogging"                            value="[RAS:SmsLogging]Logging triggered for sms=%1" />
        <string id="Event.SmsInvalidCommandForState"                    value="[RAS:SmsLogging]Invalid command=%1 while in state=%2 for sms=%3" />
        <string id="Event.SmsInvalidResponseCommandForState"            value="[RAS:SmsLogging]Invalid response for command=%1 while in state=%2 for sms=%3" />
        <string id="Event.SmsCommandFailedForState"                     value="[RAS:SmsLogging]Command=%1 failed while in state=%2 for sms=%3" />
        <string id="Event.SmsInvalidNotificationForState"               value="[RAS:SmsLogging]Invalid notification=%1 while in state=%2 for sms=%3" />

        <!-- LogControl -->
        <string id="Event.LogControlErrorAccessingFilterRegistry"    value="[RAS:LogControl]Cannot open modem filter registry Error=%1" />
        <string id="Event.LogControlOpenQCDiagRouterFailed"          value="[RAS:LogControl]Cannot open QCDiagRouter. Are we on real Qualcomm modem? Error=%2 on line=%1" />
        <string id="Event.LogControlOpenQCDiagBridgeFailed"          value="[RAS:LogControl]Cannot open QCDiagBridge. Are we on real Qualcomm modem? Error=%2 on line=%1" />
        <string id="Event.LogControlTimerFailed"                     value="[RAS:LogControl]Timer error=%2 on line=%1" />
        <string id="Event.LogControlRegisterCallbackFailed"          value="[RAS:LogControl]Register callback procedure error=%2 on line=%1" />
        <string id="Event.LogControlUnregisterCallbackFailed"        value="[RAS:LogControl]Unregister callback procedure error=%2 on line=%1" />
        <string id="Event.LogControlQCDiagBridgeIOControlFailure"    value="[RAS:LogControl]QCDiagBridge_IOControl %1 failed. Error: %2. Command: %3. Second option: %4. Did we send a malformed of unsupported request?" />
        <string id="Event.LogControlQCDiagBridgeIOControlRetry"      value="[RAS:LogControl]QCDiagBridge_IOControl %1 failed. Error: %2. Command: %3. Second option: %4. This time we retry" />
        <string id="Event.LogControlQCDiagBridgeIOControlSuccess"    value="[RAS:LogControl]QCDiagBridge_IOControl %1 succeeded. Error: %2. Command: %3. Second option: %4." />
        <string id="Event.LogControlQCDiagRouterIOControlFailure"    value="[RAS:LogControl]QCDiagRouter_IOControl %1 failed. Error: %2. Did we send a malformed of unsupported request?" />
        <string id="Event.LogControlQCDiagRouterIOControlRetry"      value="[RAS:LogControl]QCDiagRouter_IOControl %1 failed. Error: %2. This time we retry" />
        <string id="Event.LogControlQCDiagRouterIOControlSuccess"    value="[RAS:LogControl]QCDiagRouter_IOControl %1 succeeded. Error: %2." />
        <string id="Event.LogControlErrorFilterIndexString"          value="[RAS:LogControl]Cannot format the filter index string. Error=%1" />

        <!-- Modem Filter -->
        <string id="Event.FilterCannotOpenFilterFile"                value="[RAS:ModemFilter]Cannot open modem filter file=%2, Error=%1" />
        <string id="Event.FilterErrorReadFilterFile"                 value="[RAS:ModemFilter]Cannot read from modem filter file=%2, Error=%1" />
      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>
