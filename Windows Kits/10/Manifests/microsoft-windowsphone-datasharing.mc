<?xml version='1.0' encoding='utf-8' standalone='yes'?>
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
<instrumentationManifest
  xmlns="http://schemas.microsoft.com/win/2004/08/events"
  xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <instrumentation>
    <events>
      <provider name="Microsoft-WindowsPhone-DataSharing"
                guid="{68E8B204-3604-46df-A258-6DB3B5F5E003}"
                symbol="MICROSOFT_WINDOWSPHONE_DATASHARING"
                resourceFileName="DSSvc.dll"
                messageFileName="DSSvc.dll">
        <keywords>
          <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
          <keyword mask="0x1"
                   name="Error"
                   message="$(string.Keyword.Error)" />
          <keyword mask="0x2"
                   name="Performance"
                   message="$(string.Keyword.Performance)" />
          <keyword mask="0x100000"
                   name="Warning"
                   message="$(string.Keyword.Warning)" />
          <keyword mask="0x200000"
                   name="Notification"
                   message="$(string.Keyword.Notification)" />
          <keyword mask="0x400000"
                   name="Information"
                   message="$(string.Keyword.Information)" />
          <keyword mask="0x800000"
                   name="Critical"
                   message="$(string.Keyword.Critical)" />
        </keywords>
        <templates>
          <template tid="StringLogTemplate">
            <data name="LoggingString"
                  inType="win:UnicodeString" />
          </template>
          <template tid="StringLogTemplateA">
            <data name="LoggingString"
                  inType="win:AnsiString" />
          </template>
          <template tid="LocationErrorMessageLogTemplate">
            <data name="Function"
                  inType="win:UnicodeString" />
            <data name="Line"
                  inType="win:UInt32" />
            <data name="ThreadID"
                  inType="win:UInt32" />
            <data name="ErrorMessage"
                  inType="win:UnicodeString" />
          </template>
          <template tid="LocationErrorMessageLogTemplateA">
            <data name="Function"
                  inType="win:UnicodeString" />
            <data name="Line"
                  inType="win:UInt32" />
            <data name="ThreadID"
                  inType="win:UInt32" />
            <data name="ErrorMessage"
                  inType="win:AnsiString" />
          </template>
        </templates>
        <events>
          <event symbol="DSCriticalEvent"
                 value="1000"
                 level="win:Critical"
                 template="StringLogTemplate"
                 keywords="Critical "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSCriticalEventLocationErrorMessage"
                 value="1002"
                 level="win:Critical"
                 template="LocationErrorMessageLogTemplate"
                 keywords="Critical "
                 message="$(string.DSLogProvider.LocationErrorMessageLogMessage)" />

          <event symbol="DSErrorEvent"
                 value="2000"
                 level="win:Error"
                 template="StringLogTemplate"
                 keywords="Error "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSErrorEventLocationErrorMessage"
                 value="2002"
                 level="win:Error"
                 template="LocationErrorMessageLogTemplate"
                 keywords="Error "
                 message="$(string.DSLogProvider.LocationErrorMessageLogMessage)" />

          <event symbol="DSWarningEvent"
                 value="3000"
                 level="win:Warning"
                 template="StringLogTemplate"
                 keywords="Warning "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSWarningEventLocationErrorMessage"
                 value="3002"
                 level="win:Warning"
                 template="LocationErrorMessageLogTemplate"
                 keywords="Warning "
                 message="$(string.DSLogProvider.LocationErrorMessageLogMessage)" />

          <event symbol="DSInformationEvent"
                 value="4000"
                 level="win:Informational"
                 template="StringLogTemplate"
                 keywords="Information "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSInformationEventLocationErrorMessage"
                 value="4002"
                 level="win:Informational"
                 template="LocationErrorMessageLogTemplate"
                 keywords="Information "
                 message="$(string.DSLogProvider.LocationErrorMessageLogMessage)" />

          <event symbol="DSVerboseEvent"
                 value="5000"
                 level="win:Verbose"
                 template="StringLogTemplate"
                 keywords="Information "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSVerboseEventLocationErrorMessage"
                 value="5002"
                 level="win:Verbose"
                 template="LocationErrorMessageLogTemplate"
                 keywords="Information "
                 message="$(string.DSLogProvider.LocationErrorMessageLogMessage)" />

          <event symbol="DSNotificationEvent"
                 value="6000"
                 level="win:Informational"
                 template="StringLogTemplate"
                 keywords="Notification "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSNotificationEventLocationErrorMessage"
                 value="6002"
                 level="win:Informational"
                 template="LocationErrorMessageLogTemplate"
                 keywords="Notification "
                 message="$(string.DSLogProvider.LocationErrorMessageLogMessage)" />

          <!-- Perf related events -->
          <event symbol="DSServiceApiStartedEvent"
                 value="7001"
                 level="win:Verbose"
                 template="StringLogTemplate"
                 keywords="Performance "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSServiceApiCompletedEvent"
                 value="7002"
                 level="win:Verbose"
                 template="StringLogTemplate"
                 keywords="Performance "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSClientApiStartedEvent"
                 value="7011"
                 level="win:Verbose"
                 template="StringLogTemplate"
                 keywords="Performance "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
          <event symbol="DSClientApiCompletedEvent"
                 value="7012"
                 level="win:Verbose"
                 template="StringLogTemplate"
                 keywords="Performance "
                 message="$(string.DSLogProvider.GenericLogMessage)" />
        </events>
      </provider>
    </events>
  </instrumentation>
  <localization>
    <resources culture="en-US">
      <stringTable>
        <string id="Keyword.Error"
                value="Error" />
        <string id="Keyword.Performance"
                value="Performance" />
        <string id="Keyword.Warning"
                value="Warning" />
        <string id="Keyword.Notification"
                value="Notification" />
        <string id="Keyword.Information"
                value="Information" />
        <string id="Keyword.Critical"
                value="Critical" />

        <string id="Task.None"
                value="None" />

        <string id="DSLogProvider.GenericLogMessage"
                value="DS: [%1]%n" />
        <string id="DSLogProvider.LocationErrorMessageLogMessage"
                value="DS: [%1 (%2): {%3} %4]%n" />
      </stringTable>
    </resources>
  </localization>
</instrumentationManifest>
