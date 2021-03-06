<?xml version="1.0" encoding="UTF-16"?>
<instrumentationManifest xsi:schemaLocation="http://schemas.microsoft.com/win/2004/08/events eventman.xsd" xmlns="http://schemas.microsoft.com/win/2004/08/events" xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:trace="http://schemas.microsoft.com/win/2004/08/events/trace">
    <instrumentation>
        <events>
        <provider name="Microsoft-WindowsPhone-DevPlatDXPerfAppProvider" guid="{9E348C48-9179-4851-BD91-8CA7CBF64547}" symbol="MICROSOFT_WINDOWSPHONE_DEVPLATDXPERFAPPPROVIDER" resourceFileName="$(string.Provider.Name)" messageFileName="$(string.Provider.Name)">
        <events>
            <event symbol="DXPApp_Scenario_Start" value="1" version="0" level="win:Informational" task="Scenario" opcode="win:Start" template="SimpleEvent" message="$(string.Event.Scenario.Start)"/>
            <event symbol="DXPApp_Scenario_Stop" value="2" version="0" level="win:Informational" task="Scenario" opcode="win:Stop" template="SimpleEvent" message="$(string.Event.Scenario.Stop)"/>
        </events>
        <levels/>
        <tasks>
            <task name="Scenario" value="1" eventGUID="{00000000-0000-0000-0000-000000000000}"/>
        </tasks>
        <opcodes/>
        <templates>
            <template tid="SimpleEvent"/>
            <template tid="SingleInt">
                <data name="CountValue" inType="win:UInt64"/>
            </template> 
        </templates>
    </provider>
    </events>
    </instrumentation>
    <localization>
    <resources culture="en-US">
        <stringTable>
        <string id="opcode.Stop" value="Stop"/>
        <string id="opcode.Start" value="Start"/>
        <string id="level.Informational" value="Information"/>
        <string id="Provider.Name" value="Microsoft-WindowsPhone-DevPlatDXPerfAppProvider.dll"/>
        <string id="Event.Scenario.Stop" value="DPNativeApp/Scenario/Stop"/>
        <string id="Event.Scenario.Start" value="DPNativeApp/Scenario/Start"/>
        </stringTable>
    </resources>
    </localization>
</instrumentationManifest>
