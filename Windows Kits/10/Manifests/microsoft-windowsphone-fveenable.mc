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

      <provider name="Microsoft-WindowsPhone-FveEnable"
          guid="{B8694DDF-972B-4e59-AA97-577F3C8BF442}"
          symbol="MICROSOFT_WINDOWSPHONE_FVEENABLE"
          messageFileName="ETWFveEnableProvider.dll"
          resourceFileName="ETWFveEnableProvider.dll">

        <channels />

        <keywords>
          <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
          <keyword mask="0x0000000000000001" name="Error" message="$(string.Keyword.Error)" />
          <keyword mask="0x0000000000000002" name="Performance" message="$(string.Keyword.Performance)" />
          <keyword mask="0x0000000000000004" name="ExitCode" message="$(string.Keyword.ExitCode)" />
          <keyword mask="0x0000000000000008" name="Information" message="$(string.Keyword.Information)" />
        </keywords>

        <templates>
          <template tid="FveEnableLog">
            <data name="P1_UnicodeString" inType="win:UnicodeString" outType="xs:string"/>
          </template>
        </templates>

        <events>
            <event value="153"
                   template="FveEnableLog"
                   symbol="FveEnableLogInfo"
                   keywords="Information"
                   level="win:Critical"
                   message="$(string.Event.FveEnableLogInfoMessage)" />

        </events>


      </provider>
    </events>
  </instrumentation>


  <localization>
    <resources culture="en-US">
      <stringTable>

        <string id="Keyword.Error"                      value="Error" />
        <string id="Keyword.Performance"                value="Performance" />
        <string id="Keyword.ExitCode"                   value="ExitCode" />
        <string id="Keyword.Information"                value="Information" />

        <string id="Event.FveEnableLogInfoMessage"    value="FveEnableSvc: [%1]"/>

      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>
