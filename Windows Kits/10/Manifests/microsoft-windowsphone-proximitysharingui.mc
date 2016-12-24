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

      <provider name="Microsoft-WindowsPhone-ProximitySharingUi"
            guid="{295F4CFB-FAD7-4992-94FA-43239B3185D7}"
            symbol="MICROSOFT_WINDOWSPHONE_PROXIMITYSHARINGUI"
            messageFileName="ProximitySharingUI.dll"
            resourceFileName="ProximitySharingUI.dll">

        <channels />

        <keywords>
          <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
          <keyword mask="0x0000000000000001" name="Error" />
          <keyword mask="0x0000000000000002" name="Performance" />
        </keywords>

        <tasks>
          <task value="1" name="SetUpSharingSession" />
          <task value="2" name="SaveContent" />
        </tasks>

        <maps>
          <!-- Generic map to generate text from a bool value -->
          <valueMap name="OnOffState">
            <map value="0" message="$(string.OnOffState.Off)"/>
            <map value="1" message="$(string.OnOffState.On)"/>
          </valueMap>
        </maps>

        <templates>
          <template tid="EnabledState">
            <data name="State" inType="win:UInt8" map="OnOffState"/>
          </template>
        </templates>

        <events>
          <event value="100"
                 symbol="EnableProximity"
                 level="win:Informational"
                 template="EnabledState"
                 message="$(string.Event.EnableProximity)" />

          <!-- Per ETW best practices higher level performance scenarios should use
               higher level tracing, ie. top level scenarios will use level win:Error.
          -->
          <event value="200"
                 symbol="SetUpSharingSession_Start"
                 task="SetUpSharingSession"
                 keywords="Performance"
                 level="win:Error"
                 opcode="win:Start"
                 message="$(string.Event.SetUpSharingSession_Start)" />
          <event value="201"
                 symbol="SetUpSharingSession_Stop"
                 task="SetUpSharingSession"
                 keywords="Performance"
                 level="win:Error"
                 opcode="win:Stop"
                 message="$(string.Event.SetUpSharingSession_Stop)" />
          <event value="202"
                 symbol="SaveContent_Start"
                 task="SaveContent"
                 keywords="Performance"
                 level="win:Error"
                 opcode="win:Start"
                 message="$(string.Event.SaveContent_Start)" />
          <event value="203"
                 symbol="SaveContent_Stop"
                 task="SaveContent"
                 keywords="Performance"
                 level="win:Error"
                 opcode="win:Stop"
                 message="$(string.Event.SaveContent_Stop)" />

        </events>
      </provider>
    </events>
  </instrumentation>

  <localization>
    <resources culture="en-US">
      <stringTable>

        <string id="Event.EnableProximity"                          value="Turning proximity %1" />

        <string id="Event.SetUpSharingSession_Start"                value="BEGIN: SetUpSharingSession" />
        <string id="Event.SetUpSharingSession_Stop"                 value="END: SetUpSharingSession" />
        <string id="Event.SaveContent_Start"                        value="BEGIN: SaveContent" />
        <string id="Event.SaveContent_Stop"                         value="END: SaveContent" />

        <string id="OnOffState.On"                                  value="On"/>
        <string id="OnOffState.Off"                                 value="Off"/>

      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>
