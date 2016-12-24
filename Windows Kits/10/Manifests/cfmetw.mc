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
<!-- <?xml version="1.0" encoding="UTF-16"?> -->
<instrumentationManifest
    xmlns="http://schemas.microsoft.com/win/2004/08/events"
    xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
    
  <instrumentation>
    <events>
      <!--Publisher Info -->
      <provider name="Microsoft-WindowsMobile-CFMPublisher"
          guid="{9136A930-DF2F-4a98-814D-87A41C5FFF87}"
          symbol="WM_CFM_PUBLISHER"
          resourceFileName="CfmSvc.dll"
          messageFileName="CfmSvc.dll">

        <!--Channel to which this Publisher can publish -->

        <channels>
          <!--Import the System channel-->
          <importChannel chid="SystemChannel" name="System"/>

          <channel chid="CFMChannel"
              name="Microsoft-WindowsMobile-CFMPublisher-Channel"
              type="Operational"
              symbol="WM_CFM_PUBLISHER_CHANNEL"
              enabled="true"
              value="100"/>
        </channels>

        <!--Value Maps-->
        <maps>
          <valueMap name="FaultIdMap">
            <map value="100" message="$(string.FaultId.DNSTimeout)"/>
            <map value="200" message="$(string.FaultId.TCPTxTimeout)"/>
            <map value="210" message="$(string.FaultId.TCPSynTimeout)"/>
            <map value="65535" message="$(string.FaultId.APICall)"/>
          </valueMap>
          <valueMap name="StateMap">
            <map value="0" message="$(string.State.IDLE)"/>
            <map value="10" message="$(string.State.HANDLE)"/>
            <map value="20" message="$(string.State.DIAGNOSE)"/>
            <map value="30" message="$(string.State.REPAIR)"/>
            <map value="40" message="$(string.State.VERIFY)"/>
            <map value="50" message="$(string.State.SUSPEND)"/>
          </valueMap>
          <valueMap name="MediumMap">
            <map value="1" message="$(string.Medium.CELL)"/>
            <map value="2" message="$(string.Medium.WIFI)"/>
          </valueMap>
        </maps>

        <!--Event Templates-->
        <templates>
          <template tid="_Template_FAULTID">
            <data name="FaultId" inType="win:UInt16" map="FaultIdMap" />
          </template>
          <template tid="_Template_DNSTIMEOUT">
            <data name="IFIndex" inType="win:UInt32" />
          </template>
          <template tid="_Template_TCPTIMEOUT">
            <data name="IFIndex" inType="win:UInt32" />
            <data name="Retransmits" inType="win:UInt32" />
          </template>
          <template tid="_Template_REPAIR_RESULT">
            <data name="RepairMethodId" inType="win:UInt32" />
            <data name="CFMResult" inType="win:UInt32" />
          </template>
          <template tid="_Template_STRING">
            <data name="Prop_String" inType="win:UnicodeString" />
          </template>
          <template tid="_Template_STATE_CHANGE">
            <data name="Medium" inType="win:UInt32" map="MediumMap" />
            <data name="CurState" inType="win:UInt32" map="StateMap" />
            <data name="NewState" inType="win:UInt32" map="StateMap" />
          </template>
          <template tid="_Template_MEDIUM">
            <data name="Medium" inType="win:UInt32" map="MediumMap" />
          </template>
          <template tid="_Template_SUSPEND_DURATION">
            <data name="Medium" inType="win:UInt32" map="MediumMap" />
            <data name="Duration" inType="win:UInt32" />
          </template>
          <template tid="_Template_SIGNAL_STRENGTH">
            <data name="SignalStrength" inType="win:UInt32" />
          </template>
        </templates>

        <!--All the Events that can be published by this Publisher -->
        <events>
          <event value="101"
              level="win:Error"
              template="_Template_STRING"
              channel="CFMChannel"
              symbol="CFM_ERRORMSG"
              message="$(string.Message)" />
          <event value="200"
              level="win:Warning"
              template="_Template_STRING"
              channel="CFMChannel"
              symbol="CFM_TRACEMSG" 
              message="$(string.Message)" />
          <event value="300"
              level="win:Critical"
              template="_Template_STRING"
              channel="CFMChannel"
              symbol="CFM_CRITICALMSG"
              message="$(string.Message)" />
          <event value="0x8000"
              level="win:Critical"
              template="_Template_REPAIR_RESULT"
              channel="SystemChannel"
              symbol="CFM_REPAIR_RESULT"
              message="$(string.RepairResult)" />
          <event value="0xA000"
              level="win:Warning"
              template="_Template_FAULTID"
              channel="CFMChannel"
              symbol="CFM_GENERIC_FAULT"
              message="$(string.GenericFault)" />
          <event value="0xA001"
              level="win:Error"
              template="_Template_FAULTID"
              channel="CFMChannel"
              symbol="CFM_ILLFORMAT_FAULT"
              message="$(string.IllFormatFault)" />
          <event value="0xA002"
              level="win:Error"
              template="_Template_FAULTID"
              channel="CFMChannel"
              symbol="CFM_UNKNOWN_FAULT"
              message="$(string.UnknownFault)" />
          <event value="0xA010"
              level="win:Warning"
              template="_Template_DNSTIMEOUT"
              channel="CFMChannel"
              symbol="CFM_DNSTIMEOUT" 
              message="$(string.DnsTimeout)" />
          <event value="0xA011"
              level="win:Warning"
              template="_Template_TCPTIMEOUT"
              channel="CFMChannel"
              symbol="CFM_TCPTXTIMEOUT" 
              message="$(string.TcpTxTimeout)" />
          <event value="0xA012"
              level="win:Warning"
              template="_Template_TCPTIMEOUT"
              channel="CFMChannel"
              symbol="CFM_TCPSYNTIMEOUT" 
              message="$(string.TcpSynTimeout)" />
          <event value="0xA020"
              level="win:Informational"
              channel="CFMChannel"
              symbol="CFM_UNSUPPORTED_INTERFACE"
              message="$(string.UnsupportedInterface)" />
          <event value="0xA021"
              level="win:Error"
              channel="CFMChannel"
              symbol="CFM_ERROR_INTERFACE"
              message="$(string.ErrorInterface)" />
          <event value="0xA030"
              level="win:Warning"
              template="_Template_MEDIUM"
              channel="CFMChannel"
              symbol="CFM_MEDIUM_DISABLED"
              message="$(string.MediumDisabled)" />
          <event value="0xA031"
              level="win:Warning"
              template="_Template_MEDIUM"
              channel="CFMChannel"
              symbol="CFM_MEDIUM_SUSPENDED"
              message="$(string.MediumSuspended)" />
          <event value="0xA032"
              level="win:Warning"
              template="_Template_MEDIUM"
              channel="CFMChannel"
              symbol="CFM_MEDIUM_SKIP"
              message="$(string.MediumSkip)" />
          <event value="0xA033"
              level="win:Informational"
              template="_Template_MEDIUM"
              channel="CFMChannel"
              symbol="CFM_MEDIUM_ENQUE"
              message="$(string.MediumEnque)" />
          <event value="0xA040"
              level="win:Informational"
              template="_Template_MEDIUM"
              channel="CFMChannel"
              symbol="CFM_MEDIUM_NO_REPAIRER"
              message="$(string.MediumNoRepairer)" />
          <event value="0xA041"
              level="win:Critical"
              template="_Template_SUSPEND_DURATION"
              channel="CFMChannel"
              symbol="CFM_MEDIUM_SUSPEND_DURATION"
              message="$(string.MediumSuspendDuration)" />
          <event value="0xA050"
              level="win:Critical"
              template="_Template_STATE_CHANGE"
              channel="CFMChannel"
              symbol="CFM_STATE_CHANGE"
              message="$(string.StateChange)" />
          <event value="0xA060"
              level="win:Warning"
              template="_Template_SIGNAL_STRENGTH"
              channel="CFMChannel"
              symbol="CFM_CELL_SIGNALSTRENGTH"
              message="$(string.CellSignalStrength)" />
        </events>

      </provider>
    </events>
  </instrumentation>

  <localization>
    <resources culture="en-US">
      <stringTable>
        <string id="Message" value="CFM: %1" />
        <string id="FaultId.DNSTimeout" value="DNS Timeout" />
        <string id="FaultId.TCPTxTimeout" value="TCP Tx Timeout" />
        <string id="FaultId.TCPSynTimeout" value = "TCP SYN Timeout" />
        <string id="FaultId.APICall" value="API Call" />
        <string id="RepairResult" value="CFM: tried repair method (%1), result = (%2)" />
        <string id="GenericFault" value="CFM: received fault (%1)" />
        <string id="IllFormatFault" value="CFM: received ill-formated fault (%1), skip" />
        <string id="UnknownFault" value="CFM: received unknown fault (%1), skip" />
        <string id="DnsTimeout" value="CFM: received DNS Timeout (IFIndex = %1)" />
        <string id="TcpTxTimeout" value="CFM: received TCP TX Timeout (IFIndex = %1, Retransmits = %2)" />
        <string id="TcpSynTimeout" value="CFM: received TCP SYN Timeout (IFIndex = %1, Retransmits = %2)" />
        <string id="UnsupportedInterface" value="CFM: unsupported interface, skip" />
        <string id="ErrorInterface" value="CFM: cannot find medium type for the interface, skip" />
        <string id="State.IDLE" value="IDLE" />
        <string id="State.HANDLE" value="HANDLING" />
        <string id="State.DIAGNOSE" value="DIAGNOSING" />
        <string id="State.REPAIR" value="REPAIRING" />
        <string id="State.VERIFY" value="VERIFYING" />
        <string id="State.SUSPEND" value="SUSPENDING" />
        <string id="StateChange" value="CFM: %1 State Machine: %2 -> %3" />
        <string id="Medium.CELL" value="CELL" />
        <string id="Medium.WIFI" value="WIFI" />
        <string id="MediumDisabled" value="CFM: %1 medium is disabled: Ignore" />
        <string id="MediumSuspended" value="CFM: %1 medium is in SUSPENDING state: Ignore" />
        <string id="MediumSkip" value="CFM: %1 medium is in active state: Skip" />
        <string id="MediumEnque" value="CFM: %1 medium is in active state: Enque" />
        <string id="MediumNoRepairer" value="CFM: %1 medium has no repairer" />
        <string id="MediumSuspendDuration" value="CFM: %1 medium will suspend for %2 seconds" />
        <string id="CellSignalStrength" value="CFM: Cell signal strength = [%1]" />
      </stringTable>
    </resources>
  </localization>
  
</instrumentationManifest>
