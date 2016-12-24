<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<!--
Copyright (c) Microsoft Corporation.  All rights reserved.

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
            <provider
              name="Microsoft-WindowsPhone-Imaging-VideoStabilizerMFT"
              guid="{A5023F55-399C-48E5-9FC8-E715ABF52311}"
              symbol="Microsoft_WindowsPhone_Imaging_VideoStabilizerMFT"
              resourceFileName="VideoStabilizerMFT.dll"
              messageFileName="VideoStabilizerMFT.dll">

                <!-- Channels -->
                <channels/>

                <!-- Keywords -->
                <keywords>
                    <keyword mask="0x0000000000000001" name="Error" />
                    <keyword mask="0x0000000000000002" name="Performance" />
                    <keyword mask="0x0000000000000004" name="Debug" />
                </keywords>

                <!-- Tasks -->
                <tasks>
                    <task
                        name="VideoStabilizerMFT_OnProcessOutputTask"
                        value="101"
                        symbol="VideoStabilizerMFT_OnProcessOutputTask"
                        message="$(string.VideoStabilizerMFT.OnProcessOutput.Task)"/>
                    <task
                        name="VideoStabilizerMFT_D3D11WarpTask"
                        value="102"
                        symbol="VideoStabilizerMFT_D3D11WarpTask"
                        message="$(string.VideoStabilizerMFT.D3D11Warp.Task)"/>
                    <task
                        name="VideoStabilizerMFT_SoftwareWarpYTask"
                        value="103"
                        symbol="VideoStabilizerMFT_SoftwareWarpYTask"
                        message="$(string.VideoStabilizerMFT.SoftwareWarpY.Task)"/>
                    <task
                        name="VideoStabilizerMFT_SoftwareWarpUVTask"
                        value="104"
                        symbol="VideoStabilizerMFT_SoftwareWarpUVTask"
                        message="$(string.VideoStabilizerMFT.SoftwareWarpUV.Task)"/>
                    <task
                        name="VideoStabilizerMFT_AddFrameTask"
                        value="105"
                        symbol="VideoStabilizerMFT_AddFrameTask"
                        message="$(string.VideoStabilizerMFT.AddFrameTask.Task)"/>
                    <task
                        name="VideoStabilizerMFT_FinalConstruct"
                        value="106"
                        symbol="VideoStabilizerMFT_FinalConstruct"
                        message="$(string.VideoStabilizerMFT.FinalConstruct.Task)"/>
                    <task
                        name="VideoStabilizerMFT_ProcessInput"
                        value="107"
                        symbol="VideoStabilizerMFT_ProcessInput"
                        message="$(string.VideoStabilizerMFT.ProcessInput.Task)"/>
                    <task
                        name="VideoStabilizerMFT_ProcessOutput"
                        value="108"
                        symbol="VideoStabilizerMFT_ProcessOutput"
                        message="$(string.VideoStabilizerMFT.ProcessOutput.Task)"/>
                    <task
                        name="VideoStabilizerMFT_ProcessEvent"
                        value="109"
                        symbol="VideoStabilizerMFT_ProcessEvent"
                        message="$(string.VideoStabilizerMFT.ProcessEvent.Task)"/>
                    <task
                        name="VideoStabilizerMFT_ProcessMessage"
                        value="110"
                        symbol="VideoStabilizerMFT_ProcessMessage"
                        message="$(string.VideoStabilizerMFT.ProcessMessage.Task)"/>
                    <task
                        name="VideoStabilizerMFT_SetInputType"
                        value="111"
                        symbol="VideoStabilizerMFT_SetInputType"
                        message="$(string.VideoStabilizerMFT.SetInputType.Task)"/>
                    <task
                        name="VideoStabilizerMFT_SetOutputType"
                        value="112"
                        symbol="VideoStabilizerMFT_SetOutputType"
                        message="$(string.VideoStabilizerMFT.SetOutputType.Task)"/>
                </tasks>

                <!-- Templates -->
                <templates>
                    <template tid="tidMFTMessage">
                        <data inType="win:UInt32" name="eMessage" />
                    </template>
                </templates>

                <!-- Events -->
                <events>
                    <!-- OnProcessOutput -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.OnProcessOutput.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_OnProcessOutput"
                        task="VideoStabilizerMFT_OnProcessOutputTask"
                        value="201"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.OnProcessOutput.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_OnProcessOutput"
                        task="VideoStabilizerMFT_OnProcessOutputTask"
                        value="202"/>

                    <!-- D3D11Warp -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.D3D11Warp.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_D3D11Warp"
                        task="VideoStabilizerMFT_D3D11WarpTask"
                        value="203"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.D3D11Warp.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_D3D11Warp"
                        task="VideoStabilizerMFT_D3D11WarpTask"
                        value="204"/>

                    <!-- SoftwareWarpY -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SoftwareWarpY.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_SoftwareWarpY"
                        task="VideoStabilizerMFT_SoftwareWarpYTask"
                        value="205"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SoftwareWarpY.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_SoftwareWarpY"
                        task="VideoStabilizerMFT_SoftwareWarpYTask"
                        value="206"/>

                    <!-- SoftwareWarpUV -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SoftwareWarpUV.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_SoftwareWarpUV"
                        task="VideoStabilizerMFT_SoftwareWarpUVTask"
                        value="207"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SoftwareWarpUV.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_SoftwareWarpUV"
                        task="VideoStabilizerMFT_SoftwareWarpUVTask"
                        value="208"/>

                    <!-- AddFrameTask -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.AddFrameTask.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_AddFrameTask"
                        task="VideoStabilizerMFT_AddFrameTask"
                        value="209"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.AddFrameTask.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_AddFrameTask"
                        task="VideoStabilizerMFT_AddFrameTask"
                        value="210"/>
                    
                    <!-- FinalConstruct -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.FinalConstruct.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_FinalConstruct"
                        task="VideoStabilizerMFT_FinalConstruct"
                        value="211"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.FinalConstruct.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_FinalConstruct"
                        task="VideoStabilizerMFT_FinalConstruct"
                        value="212"/>
                    
                    <!-- ProcessInput -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessInput.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_ProcessInput"
                        task="VideoStabilizerMFT_ProcessInput"
                        value="213"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessInput.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_ProcessInput"
                        task="VideoStabilizerMFT_ProcessInput"
                        value="214"/>

                    <!-- ProcessOutput -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessOutput.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_ProcessOutput"
                        task="VideoStabilizerMFT_ProcessOutput"
                        value="215"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessOutput.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_ProcessOutput"
                        task="VideoStabilizerMFT_ProcessOutput"
                        value="216"/>

                    <!-- ProcessEvent -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessEvent.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_ProcessEvent"
                        task="VideoStabilizerMFT_ProcessEvent"
                        value="217"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessEvent.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_ProcessEvent"
                        task="VideoStabilizerMFT_ProcessEvent"
                        value="218"/>

                    <!-- ProcessMessage -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessMessage.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_ProcessMessage"
                        task="VideoStabilizerMFT_ProcessMessage"
                        template="tidMFTMessage"
                        value="219"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.ProcessMessage.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_ProcessMessage"
                        task="VideoStabilizerMFT_ProcessMessage"
                        value="220"/>

                    <!-- SetInputType -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SetInputType.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_SetInputType"
                        task="VideoStabilizerMFT_SetInputType"
                        value="221"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SetInputType.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_SetInputType"
                        task="VideoStabilizerMFT_SetInputType"
                        value="222"/>

                    <!-- SetOutputType -->
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SetOutputType.EventBegin)"
                        opcode="win:Start"
                        symbol="Begin_SetOutputType"
                        task="VideoStabilizerMFT_SetOutputType"
                        value="223"/>
                    <event
                        keywords="Performance"
                        level="win:Informational"
                        message="$(string.VideoStabilizerMFT.SetOutputType.EventEnd)"
                        opcode="win:Stop"
                        symbol="End_SetOutputType"
                        task="VideoStabilizerMFT_SetOutputType"
                        value="224"/>
                    
                </events>                
            </provider>
        </events>
    </instrumentation>

    <localization>
        <resources culture="en-US">
            <stringTable>
                
                <!-- OnProcessOutput -->
                <string
                  id="VideoStabilizerMFT.OnProcessOutput.Task"
                  value="VideoStabilizerMFT.OnProcessOutput.Task"/>
                <string
                  id="VideoStabilizerMFT.OnProcessOutput.EventBegin"
                  value="VideoStabilizerMFT.OnProcessOutput.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.OnProcessOutput.EventEnd"
                  value="VideoStabilizerMFT.OnProcessOutput.EventEnd"/>

                <!-- D3D11Warp -->
                <string
                  id="VideoStabilizerMFT.D3D11Warp.Task"
                  value="VideoStabilizerMFT.D3D11Warp.Task"/>
                <string
                  id="VideoStabilizerMFT.D3D11Warp.EventBegin"
                  value="VideoStabilizerMFT.D3D11Warp.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.D3D11Warp.EventEnd"
                  value="VideoStabilizerMFT.D3D11Warp.EventEnd"/>

                <!-- SoftwareWarpY -->
                <string
                  id="VideoStabilizerMFT.SoftwareWarpY.Task"
                  value="VideoStabilizerMFT.SoftwareWarpY.Task"/>
                <string
                  id="VideoStabilizerMFT.SoftwareWarpY.EventBegin"
                  value="VideoStabilizerMFT.SoftwareWarpY.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.SoftwareWarpY.EventEnd"
                  value="VideoStabilizerMFT.SoftwareWarpY.EventEnd"/>

                <!-- SoftwareWarpUV -->
                <string
                  id="VideoStabilizerMFT.SoftwareWarpUV.Task"
                  value="VideoStabilizerMFT.SoftwareWarpUV.Task"/>
                <string
                  id="VideoStabilizerMFT.SoftwareWarpUV.EventBegin"
                  value="VideoStabilizerMFT.SoftwareWarpUV.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.SoftwareWarpUV.EventEnd"
                  value="VideoStabilizerMFT.SoftwareWarpUV.EventEnd"/>

                <!-- AddFrameTask -->
                <string
                  id="VideoStabilizerMFT.AddFrameTask.Task"
                  value="VideoStabilizerMFT.AddFrameTask.Task"/>
                <string
                  id="VideoStabilizerMFT.AddFrameTask.EventBegin"
                  value="VideoStabilizerMFT.AddFrameTask.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.AddFrameTask.EventEnd"
                  value="VideoStabilizerMFT.AddFrameTask.EventEnd"/>
                
                <!-- FinalConstruct -->
                <string
                  id="VideoStabilizerMFT.FinalConstruct.Task"
                  value="VideoStabilizerMFT.FinalConstruct.Task"/>
                <string
                  id="VideoStabilizerMFT.FinalConstruct.EventBegin"
                  value="VideoStabilizerMFT.FinalConstruct.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.FinalConstruct.EventEnd"
                  value="VideoStabilizerMFT.FinalConstruct.EventEnd"/>
                
                <!-- ProcessInput -->
                <string
                  id="VideoStabilizerMFT.ProcessInput.Task"
                  value="VideoStabilizerMFT.ProcessInput.Task"/>
                <string
                  id="VideoStabilizerMFT.ProcessInput.EventBegin"
                  value="VideoStabilizerMFT.ProcessInput.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.ProcessInput.EventEnd"
                  value="VideoStabilizerMFT.ProcessInput.EventEnd"/>
                
                <!-- ProcessOutput -->
                <string
                  id="VideoStabilizerMFT.ProcessOutput.Task"
                  value="VideoStabilizerMFT.ProcessOutput.Task"/>
                <string
                  id="VideoStabilizerMFT.ProcessOutput.EventBegin"
                  value="VideoStabilizerMFT.ProcessOutput.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.ProcessOutput.EventEnd"
                  value="VideoStabilizerMFT.ProcessOutput.EventEnd"/>
                
                <!-- ProcessEvent -->
                <string
                  id="VideoStabilizerMFT.ProcessEvent.Task"
                  value="VideoStabilizerMFT.ProcessEvent.Task"/>
                <string
                  id="VideoStabilizerMFT.ProcessEvent.EventBegin"
                  value="VideoStabilizerMFT.ProcessEvent.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.ProcessEvent.EventEnd"
                  value="VideoStabilizerMFT.ProcessEvent.EventEnd"/>

                <!-- ProcessMessage -->
                <string
                  id="VideoStabilizerMFT.ProcessMessage.Task"
                  value="VideoStabilizerMFT.ProcessMessage.Task"/>
                <string
                  id="VideoStabilizerMFT.ProcessMessage.EventBegin"
                  value="VideoStabilizerMFT.ProcessMessage.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.ProcessMessage.EventEnd"
                  value="VideoStabilizerMFT.ProcessMessage.EventEnd"/>

                <!-- SetInputType -->
                <string
                  id="VideoStabilizerMFT.SetInputType.Task"
                  value="VideoStabilizerMFT.SetInputType.Task"/>
                <string
                  id="VideoStabilizerMFT.SetInputType.EventBegin"
                  value="VideoStabilizerMFT.SetInputType.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.SetInputType.EventEnd"
                  value="VideoStabilizerMFT.SetInputType.EventEnd"/>
                
                <!-- SetOutputType -->
                <string
                  id="VideoStabilizerMFT.SetOutputType.Task"
                  value="VideoStabilizerMFT.SetOutputType.Task"/>
                <string
                  id="VideoStabilizerMFT.SetOutputType.EventBegin"
                  value="VideoStabilizerMFT.SetOutputType.EventBegin"/>
                <string
                  id="VideoStabilizerMFT.SetOutputType.EventEnd"
                  value="VideoStabilizerMFT.SetOutputType.EventEnd"/>

            </stringTable>
        </resources>
    </localization>
</instrumentationManifest>