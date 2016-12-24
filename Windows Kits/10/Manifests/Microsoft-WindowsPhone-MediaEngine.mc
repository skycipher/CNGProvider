<?xml version="1.0" encoding="UTF-16"?>
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
<instrumentationManifest xmlns="http://schemas.microsoft.com/win/2004/08/events" xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events" xmlns:xs="http://www.w3.org/2001/XMLSchema">
    
  <instrumentation>
    <events>
      <provider name="Microsoft-WindowsPhone-MediaEngine" guid="{DEB4B02B-5245-4A5C-93DD-98316D670EBB}" symbol="MICROSOFT_WINDOWSPHONE_MEDIAENGINE" resourceFileName="MFMediaEngine.dll" messageFileName="MFMediaEngine.dll">
        <channels>
</channels>
        <!-- Keywords for Microsoft-WindowsPhone-MediaEngine -->
        <keywords xmlns:etw="http://schemas.microsoft.com/win/2004/08/events">
<keyword mask="0x0000000000100000" name="warning" />
<keyword mask="0x0000000000200000" name="debug" />
<keyword mask="0x0000000000400000" name="error" />
<keyword mask="0x0000000000000001" name="Debug">
</keyword>
<keyword mask="0x0000000000000002" name="Performance">
</keyword>
</keywords>
        <!--Event, tasks and templates populated from ETWCommon.xsl-->
        <tasks xmlns:etw="http://schemas.microsoft.com/win/2004/08/events">
<task message="$(string.Task.TraceMessage)" name="tracemessage" value="10000" />
<task name="MFMediaEngine_TransferVideoFrameStart" value="1">
</task>
<task name="MFMediaEngine_TransferVideoFrameStop" value="2">
</task>
</tasks>
        <templates xmlns:etw="http://schemas.microsoft.com/win/2004/08/events">
<template tid="tTraceMessage">
<data inType="win:Pointer" name="Message" />
</template>
</templates>
        <events xmlns:etw="http://schemas.microsoft.com/win/2004/08/events">
<event symbol="_ETWMESSAGE" keywords="debug" level="win:Informational" task="tracemessage" template="tTraceMessage" value="10000" />
<event symbol="_ETWERROR" keywords="error" level="win:Error" task="tracemessage" template="tTraceMessage" value="10001" />
<event symbol="_ETWWARNING" keywords="warning" level="win:Warning" task="tracemessage" template="tTraceMessage" value="10002" />
<event symbol="_ETWVERBOSE" keywords="debug" level="win:Verbose" task="tracemessage" template="tTraceMessage" value="10003" />
<event message="$(string.MFMediaEngine.TransferVideoFrameStart.EventMessage)" level="win:Informational" opcode="win:Info" keywords="Performance" symbol="MFMediaEngine_TransferVideoFrameStart" task="MFMediaEngine_TransferVideoFrameStart" value="100" version="0">
</event>
<event message="$(string.MFMediaEngine.TransferVideoFrameStop.EventMessage)" level="win:Informational" opcode="win:Info" keywords="Performance" symbol="MFMediaEngine_TransferVideoFrameStop" task="MFMediaEngine_TransferVideoFrameStop" value="101" version="0">
</event>
</events>
      </provider>
    </events>
  </instrumentation>
    <localization>
        <resources culture="en-US">
            <stringTable xmlns:etw="http://schemas.microsoft.com/win/2004/08/events">
<string id="Task.TraceMessage" value="Trace" />
<string id="EventProviderName" value="Microsoft-WindowsPhone-MediaEngine">
</string>
<string id="MFMediaEngine.TransferVideoFrameStart.EventMessage" value="Transfer video frame starts">
</string>
<string id="MFMediaEngine.TransferVideoFrameStop.EventMessage" value="Transfer video frame stops">
</string>
</stringTable>
        </resources>
    </localization>
</instrumentationManifest>
