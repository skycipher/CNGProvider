<!--
Copyright (c) Microsoft Corporation.  All rights reserved.
-->
<!--
Use of this source code is subject to the terms of the Microsoft
premium shared source license agreement under which you licensed
this source code. If you did not accept the terms of the license
agreement, you are not authorized to use this source code.
For the terms of the license, please see the license agreement
signed by you and Microsoft.
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
      <provider name="Microsoft-WindowsPhone-DevMgmt-SprintCSP"
          guid="{16D29899-A697-43A5-9043-460DDB4F133A}"
          resourceFileName="dmcsps.dll"
          messageFileName="dmcsps.dll"
          symbol="MICROSOFT_WINDOWSPHONE_DEVMGMT_SPRINTCSP">

        <!--No channel info necessary-->
        <channels />

        <keywords>
            <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
            <keyword name="Error"        mask="0x00000001" />
            <keyword name="Performance"  mask="0x00000002" />            
          
            <!-- Provider-specific keywords -->
            <keyword name="Debug"        mask="0x00000004" />
        </keywords>
        <tasks>
          <task name="CSPSession"        symbol="CSP_SESSION"          value="1"/>
        </tasks>

        
        <!--Event Templates -->
        <templates>
          <template tid="HrTemplate">
            <data name="P1_HResult" inType="win:Int32" outType="win:HResult"/>
            <data name="P2_String" inType="win:AnsiString"/>
            <data name="P3_UInt32" inType="win:UInt32"/>
          </template>
          <template tid="HrDwTemplate">
            <data name="P1_HResult" inType="win:Int32" outType="win:HResult"/>
            <data name="P2_UInt32" inType="win:UInt32"/>
          </template>
        </templates>
        <!--All the Events that can be published by this Publisher -->
        <events>
          <event value="1"
            symbol="ErrorOriginateEvent"
            level="win:Error"
            keywords="Error"
            template="HrTemplate"
            message="$(string.Event.ErrorOriginateMessage)"/>
          
          <event value="2"
            symbol="DoPublishWNFOMADMSettingChangedEvent"
            level="win:Informational"
            keywords="Debug"
            message="$(string.Event.DoPublishWNFOMADMSettingChangedMessage)"/>

          <event value="3"
            symbol="SIMNODELOCKEvent"
            level="win:Informational"
            keywords="Debug"
            template="HrDwTemplate"
            message="$(string.Event.SIMNODELOCKEventMessage)"/>

          <!-- Performance marker events -->
          <event value="1002"
            symbol="PERF_CSPSESSION_BEGIN"
            task="CSPSession"
            opcode="win:Start"
            level="win:Verbose"
            keywords="Performance"/>

          <event value="1003"
            symbol="PERF_CSPSESSION_END"
            task="CSPSession"
            opcode="win:Stop"
            level="win:Verbose"
            keywords="Performance"/>

        </events>
      </provider>
    </events>
  </instrumentation>
  <localization>
    <resources culture="en-US">
      <stringTable>
        <string id="Event.ErrorOriginateMessage"                            value="Error: %1 Location: %2 Line Number: %3"/>
        <string id="Event.DoPublishWNFOMADMSettingChangedMessage"           value="Published WNF for OMADM Setting Changed"/>
        <string id="Event.SIMNODELOCKEventMessage"                          value="SIM NODE LOCK: hr %1 state %2"/>
      </stringTable>
    </resources>
  </localization>
</instrumentationManifest>
