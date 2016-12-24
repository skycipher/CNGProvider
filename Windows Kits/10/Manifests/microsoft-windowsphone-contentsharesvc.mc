<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<!--
Copyright (c) Microsoft Corporation.  All rights reserved.
-->
<instrumentationManifest
  xmlns="http://schemas.microsoft.com/win/2004/08/events"
  xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <instrumentation>
    <events>

      <provider name="Microsoft-WindowsPhone-ContentShareSvc"
                guid="{8046D656-73F2-4332-ADC1-90B4142BDBEE}"
                symbol="MICROSOFT_WINDOWSPHONE_CONTENTSHAREVC"
                messageFileName="ContentSharingService.dll"
                resourceFileName="ContentSharingService.dll">

        <channels />

        <keywords>
          <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
          <keyword mask="0x0000000000000001" name="Error" />
          <keyword mask="0x0000000000000002" name="Performance" />

          <keyword mask="0x0000000000000010" name="ProximityEventHandler" />
          <keyword mask="0x0000000000000020" name="SharingOverSessions" />
          <keyword mask="0x0000000000000040" name="SharingOverNfc" />
          <keyword mask="0x0000000000000080" name="SharingOverOpp" />
          <keyword mask="0x0000000000000100" name="PeripheralPairing" />
        </keywords>

        <tasks>
          <task value="1" name="PlayArrivalSound" />
          <task value="2" name="StopArrivalSound" />
          <task value="3" name="UserAuthPrompt" />
          <task value="4" name="MarketplaceLookup" />
          <task value="5" name="GetBluetoothRadioEnabled" />
          <task value="6" name="GetPairedDeviceInfo" />
          <task value="7" name="PackOpcFile" />
          <task value="8" name="UnpackOpcFile" />
        </tasks>

        <maps>
          <!-- Must match TransmissionState enum in ProximityUxHost.h -->
          <valueMap name="SessionStateType">
            <map value="0" message="$(string.SessionState.TS_WaitingForTap)"/>
            <map value="1" message="$(string.SessionState.TS_WaitingForConsent)"/>
            <map value="2" message="$(string.SessionState.TS_ReceiveConnecting)"/>
            <map value="3" message="$(string.SessionState.TS_Sending)"/>
            <map value="4" message="$(string.SessionState.TS_Receiving)"/>
            <map value="5" message="$(string.SessionState.TS_ReceiveUnpacking)"/>
            <map value="6" message="$(string.SessionState.TS_Complete)"/>
            <map value="7" message="$(string.SessionState.TS_Canceled)"/>
            <map value="8" message="$(string.SessionState.TS_Error)"/>
          </valueMap>

          <!-- Must match BLUETOOTH_DEVICE_STATE enum in BtConnectionManager.idl -->
          <valueMap name="BtDeviceState">
            <map value="0" message="$(string.BluetoothDeviceState.BDS_NOT_VISIBLE)"/>
            <map value="1" message="$(string.BluetoothDeviceState.BDS_VISIBLE)"/>
            <map value="2" message="$(string.BluetoothDeviceState.BDS_PAIRED)"/>
            <map value="3" message="$(string.BluetoothDeviceState.BDS_PAIRING)"/>
            <map value="4" message="$(string.BluetoothDeviceState.BDS_CONNECTING)"/>
            <map value="5" message="$(string.BluetoothDeviceState.BDS_CONNECTED)"/>
            <map value="6" message="$(string.BluetoothDeviceState.BDS_DISCONNECTING)"/>
            <map value="7" message="$(string.BluetoothDeviceState.BDS_UNPAIRING)"/>
          </valueMap>

          <!-- Generic map to generate text from a bool value -->
          <valueMap name="OnOffState">
            <map value="0" message="$(string.OnOffState.Off)"/>
            <map value="1" message="$(string.OnOffState.On)"/>
          </valueMap>
        </maps>

        <templates>
          <template tid="Boolean">
            <data name="BoolVal" inType="win:Boolean" />
          </template>
          <template tid="UInt">
            <data name="UIntVal" inType="win:UInt32" />
          </template>
          <template tid="String">
            <data name="psz" inType="win:UnicodeString" />
          </template>
          <template tid="DoubleString">
            <data name="psz1" inType="win:UnicodeString" />
            <data name="psz2" inType="win:UnicodeString" />
          </template>
          <template tid="MimeDataInfo">
            <data name="ContentType" inType="win:UnicodeString" />
            <data name="ContentSize" inType="win:UInt32" />
          </template>
          <template tid="SessionState">
            <data name="State" inType="win:UInt32" map="SessionStateType"/>
          </template>
          <template tid="SessionFailureInfo">
            <data name="HRESULT" inType="win:UInt32" outType="win:HexInt32" />
            <data name="FailureCode" inType="win:UInt32" />
          </template>
          <template tid="BluetoothOobInfo">
            <data name="BthAddr" inType="win:HexInt64" />
            <data name="DeviceName" inType="win:UnicodeString" />
          </template>
          <template tid="BluetoothDeviceState">
            <data name="State" inType="win:UInt32" map="BtDeviceState"/>
          </template>
          <template tid="EnabledState">
            <data name="State" inType="win:UInt8" map="OnOffState"/>
          </template>
        </templates>

        <events>
          <event value="10"
                 symbol="ServiceStartup"
                 keywords=""
                 level="win:Informational"
                 message="$(string.Event.ServiceStartup)" />
          <event value="11"
                 symbol="ServiceShutdown"
                 keywords=""
                 level="win:Informational"
                 message="$(string.Event.ServiceShutdown)" />

          <event value="100"
                 symbol="DeviceArrived"
                 keywords="ProximityEventHandler"
                 level="win:Verbose"
                 message="$(string.Event.DeviceArrived)" />
          <event value="101"
                 symbol="DeviceDeparted"
                 keywords="ProximityEventHandler"
                 level="win:Verbose"
                 message="$(string.Event.DeviceDeparted)" />
          <event value="102"
                 symbol="AppLaunchRequest"
                 keywords="ProximityEventHandler"
                 level="win:Informational"
                 template="DoubleString"
                 message="$(string.Event.AppLaunchRequest)" />
          <event value="103"
                 symbol="ContentSharingSessionRequest"
                 keywords="ProximityEventHandler SharingOverSessions"
                 level="win:Informational"
                 message="$(string.Event.ContentSharingSessionRequest)" />
          <event value="104"
                 symbol="UrlReceived"
                 keywords="ProximityEventHandler SharingOverNfc"
                 level="win:Informational"
                 template="String"
                 message="$(string.Event.UrlReceived)" />
          <event value="105"
                 symbol="MimeDataReceived"
                 keywords="ProximityEventHandler SharingOverNfc"
                 level="win:Informational"
                 template="MimeDataInfo"
                 message="$(string.Event.MimeDataReceived)" />
          <event value="106"
                 symbol="PeripheralPairingRequest"
                 keywords="ProximityEventHandler PeripheralPairing SharingOverNfc"
                 level="win:Informational"
                 template="BluetoothOobInfo"
                 message="$(string.Event.PeripheralPairingRequest)" />

          <event value="111"
                 symbol="SharingSessionCancelled"
                 keywords="SharingOverSessions"
                 level="win:Informational"
                 message="$(string.Event.SharingSessionCancelled)" />
          <event value="112"
                 symbol="SharingSessionStateChanged"
                 keywords="SharingOverSessions SharingOverNfc"
                 level="win:Informational"
                 template="SessionState"
                 message="$(string.Event.SharingSessionStateChanged)" />
          <event value="113"
                 symbol="SharingSessionFailure"
                 keywords="SharingOverSessions SharingOverNfc"
                 level="win:Error"
                 template="SessionFailureInfo"
                 message="$(string.Event.SharingSessionFailure)" />

          <event value="120"
                 symbol="OobPairingRadioStatus"
                 keywords="PeripheralPairing"
                 level="win:Informational"
                 template="EnabledState"
                 message="$(string.Event.BtRadioStatus)" />
          <event value="121"
                 symbol="OobPairingDeviceInfo"
                 keywords="PeripheralPairing"
                 level="win:Informational"
                 template="BluetoothDeviceState"
                 message="$(string.Event.BtDeviceState)" />
          <event value="122"
                 symbol="OobPairingAuthenticationCallback"
                 keywords="PeripheralPairing"
                 level="win:Informational"
                 template="String"
                 message="$(string.Event.BtAuthenticationCallback)" />
          <event value="123"
                 symbol="OobPairingPairAttempt"
                 keywords="PeripheralPairing"
                 level="win:Informational"
                 template="Boolean"
                 message="$(string.Event.PeripheralPairingAttempt)" />
          <event value="124"
                 symbol="OobPairingConnectionAttempt"
                 keywords="PeripheralPairing"
                 level="win:Informational"
                 template="EnabledState"
                 message="$(string.Event.PeripheralConnectionAttempt)" />
          <event value="125"
                 symbol="OobPairingFailure"
                 keywords="PeripheralPairing"
                 level="win:Error"
                 template="UInt"
                 message="$(string.Event.PeripheralPairingFailure)" />
          <event value="126"
                 symbol="OobCommandCompleted"
                 keywords="PeripheralPairing"
                 level="win:Informational"
                 template="UInt"
                 message="$(string.Event.BtCommandCompleted)" />

          <event value="130"
                 symbol="BrokeredSessionAvailable"
                 keywords="SharingOverSessions"
                 level="win:Informational"
                 message="$(string.Event.SessionAvailable)" />
          <event value="131"
                 symbol="BrokeredSessionConnected"
                 keywords="SharingOverSessions"
                 level="win:Informational"
                 message="$(string.Event.SessionConnected)" />
          <event value="132"
                 symbol="BrokeredSessionTerminated"
                 keywords="SharingOverSessions"
                 level="win:Informational"
                 message="$(string.Event.SessionTerminated)" />
          <event value="133"
                 symbol="BrokeredSessionFactoryStarted"
                 keywords="SharingOverSessions"
                 level="win:Informational"
                 message="$(string.Event.SessionFactoryStarted)" />
          <event value="134"
                 symbol="BrokeredSessionFactoryStopped"
                 keywords="SharingOverSessions"
                 level="win:Informational"
                 message="$(string.Event.SessionFactoryStopped)" />

          <event value="140"
                 symbol="FileAddedToPackage"
                 keywords="SharingOverSessions SharingOverOpp"
                 level="win:Informational"
                 template="DoubleString"
                 message="$(string.Event.FileAddedToPackage)" />
          <event value="141"
                 symbol="UriAddedToPackage"
                 keywords="SharingOverSessions SharingOverNfc"
                 level="win:Informational"
                 template="String"
                 message="$(string.Event.UriAddedToPackage)" />

          <!-- PERF EVENTS -->
          <!-- Per ETW best practices higher level performance scenarios should use
              higher level tracing, ie. top level scenarios will use level win:Error.
          -->
          <event value="200"
                 symbol="PlayArrivalSound_Start"
                 task="PlayArrivalSound"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.PlayArrivalSound_Start)" />
          <event value="201"
                 symbol="PlayArrivalSound_Stop"
                 task="PlayArrivalSound"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.PlayArrivalSound_Stop)" />
          <event value="202"
                 symbol="StopArrivalSound_Start"
                 task="StopArrivalSound"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.StopArrivalSound_Start)" />
          <event value="203"
                 symbol="StopArrivalSound_Stop"
                 task="StopArrivalSound"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.StopArrivalSound_Stop)" />
          <event value="204"
                 symbol="UserAuthPrompt_Start"
                 task="UserAuthPrompt"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.UserAuthPrompt_Start)" />
          <event value="205"
                 symbol="UserAuthPrompt_Stop"
                 task="UserAuthPrompt"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.UserAuthPrompt_Stop)" />
          <event value="206"
                 symbol="MarketplaceLookup_Start"
                 task="MarketplaceLookup"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.MarketplaceLookup_Start)" />
          <event value="207"
                 symbol="MarketplaceLookup_Stop"
                 task="MarketplaceLookup"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.MarketplaceLookup_Stop)" />
          <event value="208"
                 symbol="GetBluetoothRadioEnabled_Start"
                 task="GetBluetoothRadioEnabled"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.GetBluetoothRadioEnabled_Start)" />
          <event value="209"
                 symbol="GetBluetoothRadioEnabled_Stop"
                 task="GetBluetoothRadioEnabled"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.GetBluetoothRadioEnabled_Stop)" />
          <event value="210"
                 symbol="GetPairedDeviceInfo_Start"
                 task="GetPairedDeviceInfo"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.GetPairedDeviceInfo_Start)" />
          <event value="211"
                 symbol="GetPairedDeviceInfo_Stop"
                 task="GetPairedDeviceInfo"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.GetPairedDeviceInfo_Stop)" />
          <event value="212"
                 symbol="PackOpcFile_Start"
                 task="PackOpcFile"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.PackOpcFile_Start)" />
          <event value="213"
                 symbol="PackOpcFile_Stop"
                 task="PackOpcFile"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.PackOpcFile_Stop)" />
          <event value="214"
                 symbol="UnpackOpcFile_Start"
                 task="UnpackOpcFile"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Start"
                 message="$(string.Event.UnpackOpcFile_Start)" />
          <event value="215"
                 symbol="UnpackOpcFile_Stop"
                 task="UnpackOpcFile"
                 keywords="Performance"
                 level="win:Informational"
                 opcode="win:Stop"
                 message="$(string.Event.UnpackOpcFile_Stop)" />

        </events>
      </provider>
    </events>
  </instrumentation>

  <localization>
    <resources culture="en-US">
      <stringTable>
        <!-- Generic service related messages -->
        <string id="Event.ServiceStartup"                       value="Content sharing service starting" />
        <string id="Event.ServiceShutdown"                      value="Content sharing service stopping" />

        <!-- ProximityEventHandler event strings -->
        <string id="Event.DeviceArrived"                        value="Proximity device entered range" />
        <string id="Event.DeviceDeparted"                       value="Proximity device left range" />
        <string id="Event.AppLaunchRequest"                     value="Received app launch request for PRODUCTID %1 with arguments=%2" />
        <string id="Event.ContentSharingSessionRequest"         value="Received a request to establish a content sharing session" />
        <string id="Event.UrlReceived"                          value="Received a Url: %1" />
        <string id="Event.MimeDataReceived"                     value="Received %2 bytes of data.  Content type: %1" />
        <string id="Event.PeripheralPairingRequest"             value="Received a peripheral pairing request from %2 (BTH_ADDR: %1)" />

        <!-- SharingSession event strings -->
        <string id="Event.SharingSessionCancelled"              value="Sharing session cancelled by client" />
        <string id="Event.SharingSessionStateChanged"           value="Sharing session state: %1" />
        <string id="Event.SharingSessionFailure"                value="Sharing session failure: %1 (%2)" />

        <string id="Event.BtRadioStatus"                        value="Bluetooth radio status: %1" />
        <string id="Event.BtDeviceState"                        value="Bluetooth device state: %1" />
        <string id="Event.BtAuthenticationCallback"             value="Device requires authentation of type: %1" />
        <string id="Event.PeripheralPairingAttempt"             value="Attempting to pair with device.  Oob data present? %1" />
        <string id="Event.PeripheralConnectionAttempt"          value="Attempting to set device connection state to %1 " />
        <string id="Event.PeripheralPairingFailure"             value="Failed to pair.  Reason: %1" />
        <string id="Event.BtCommandCompleted"                   value="Command completed.  Result: %1" />

        <!-- Brokered session event strings -->
        <string id="Event.SessionAvailable"                     value="BrokeredSession available" />
        <string id="Event.SessionConnected"                     value="BrokeredSession connected" />
        <string id="Event.SessionTerminated"                    value="BrokeredSession terminated" />
        <string id="Event.SessionFactoryStarted"                value="BrokeredSessionFactory started" />
        <string id="Event.SessionFactoryStopped"                value="BrokeredSessionFactory stopped" />

        <!-- Packaging event strings -->
        <string id="Event.FileAddedToPackage"                   value="%1 added to package with content type %2" />
        <string id="Event.UriAddedToPackage"                    value="Package created with uri %1" />

        <!-- Perf event strings -->
        <string id="Event.PlayArrivalSound_Start"               value="BEGIN: PlayArrivalSound" />
        <string id="Event.PlayArrivalSound_Stop"                value="END: PlayArrivalSound" />
        <string id="Event.StopArrivalSound_Start"               value="BEGIN: StopArrivalSound" />
        <string id="Event.StopArrivalSound_Stop"                value="END: StopArrivalSound" />
        <string id="Event.UserAuthPrompt_Start"                 value="BEGIN: UserAuthPrompt" />
        <string id="Event.UserAuthPrompt_Stop"                  value="END: UserAuthPrompt" />
        <string id="Event.MarketplaceLookup_Start"              value="BEGIN: MarketplaceLookup" />
        <string id="Event.MarketplaceLookup_Stop"               value="END: MarketplaceLookup" />
        <string id="Event.GetBluetoothRadioEnabled_Start"       value="BEGIN: GetBluetoothRadioEnabled" />
        <string id="Event.GetBluetoothRadioEnabled_Stop"        value="END: GetBluetoothRadioEnabled" />
        <string id="Event.GetPairedDeviceInfo_Start"            value="BEGIN: GetPairedDeviceInfo" />
        <string id="Event.GetPairedDeviceInfo_Stop"             value="END: GetPairedDeviceInfo" />
        <string id="Event.PackOpcFile_Start"                    value="BEGIN: PackOpcFile" />
        <string id="Event.PackOpcFile_Stop"                     value="END: PackOpcFile" />
        <string id="Event.UnpackOpcFile_Start"                  value="BEGIN: UnpackOpcFile" />
        <string id="Event.UnpackOpcFile_Stop"                   value="END: UnpackOpcFile" />


        <string id="SessionState.TS_WaitingForTap"              value="TS_WaitingForTap"/>
        <string id="SessionState.TS_WaitingForConsent"          value="TS_WaitingForConsent"/>
        <string id="SessionState.TS_ReceiveConnecting"          value="TS_ReceiveConnecting"/>
        <string id="SessionState.TS_Sending"                    value="TS_Sending"/>
        <string id="SessionState.TS_Receiving"                  value="TS_Receiving"/>
        <string id="SessionState.TS_ReceiveUnpacking"           value="TS_ReceiveUnpacking"/>
        <string id="SessionState.TS_Complete"                   value="TS_Complete"/>
        <string id="SessionState.TS_Canceled"                   value="TS_Canceled"/>
        <string id="SessionState.TS_Error"                      value="TS_Error"/>

        <string id="OnOffState.On"                              value="On"/>
        <string id="OnOffState.Off"                             value="Off"/>

        <string id="BluetoothDeviceState.BDS_NOT_VISIBLE"       value="BDS_NOT_VISIBLE"/>
        <string id="BluetoothDeviceState.BDS_VISIBLE"           value="BDS_VISIBLE"/>
        <string id="BluetoothDeviceState.BDS_PAIRED"            value="BDS_PAIRED"/>
        <string id="BluetoothDeviceState.BDS_PAIRING"           value="BDS_PAIRING"/>
        <string id="BluetoothDeviceState.BDS_CONNECTING"        value="BDS_CONNECTING"/>
        <string id="BluetoothDeviceState.BDS_CONNECTED"         value="BDS_CONNECTED"/>
        <string id="BluetoothDeviceState.BDS_DISCONNECTING"     value="BDS_DISCONNECTING"/>
        <string id="BluetoothDeviceState.BDS_UNPAIRING"         value="BDS_UNPAIRING"/>

      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>
