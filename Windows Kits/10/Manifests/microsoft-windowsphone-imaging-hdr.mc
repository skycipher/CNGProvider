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
      <provider
          name="Microsoft-WindowsPhone-Imaging-HDR"
          guid="{712341E6-32ED-45E8-AFE5-3E97B51CC2F1}"
          symbol="Microsoft_WindowsPhone_Imaging_HDR"
          resourceFileName="HDRAlgorithm.dll"
          messageFileName="HDRAlgorithm.dll">

        <channels />

        <keywords>
            <keyword mask="0x0000000000000001" name="Error" />
            <keyword mask="0x0000000000000002" name="Performance" />
            <!-- Other keywords are provider-specific. -->
            <keyword mask="0x0000000000000004" name="Debug" />
        </keywords>

        <tasks>
            <task
                name="RunHdrTask"
                value="101"
                symbol="RunHdrTask"
                message="$(string.RunHdrTask.TaskMessage)"
                />
            <task
                name="RunFlashNoFlashTask"
                value="102"
                symbol="RunFlashNoFlashTask"
                message="$(string.RunFlashNoFlashTask.TaskMessage)"
                />
            <task
                name="BlendBGRA8BuffersTask"
                value="103"
                symbol="BlendBGRA8BuffersTask"
                message="$(string.BlendBGRA8BuffersTask.TaskMessage)"
                />
            <task
                name="AlignImagesTask"
                value="104"
                symbol="AlignImagesTask"
                message="$(string.AlignImagesTask.TaskMessage)"
                />

            <task
                name="CreateRgbScalingCoefficientsHdrTask"
                value="105"
                symbol="CreateRgbScalingCoefficientsHdrTask"
                message="$(string.CreateRgbScalingCoefficientsHdrTask.TaskMessage)"
                />
            <task
                name="CreateRgbScalingCoefficientsFlashNoFlashTask"
                value="106"
                symbol="CreateRgbScalingCoefficientsFlashNoFlashTask"
                message="$(string.CreateRgbScalingCoefficientsFlashNoFlashTask.TaskMessage)"
                />
            <task
                name="FillMaskAndScaleImagesHdrTask"
                value="107"
                symbol="FillMaskAndScaleImagesHdrTask"
                message="$(string.FillMaskAndScaleImagesHdrTask.TaskMessage)"
                />
            <task
                name="GenerateStatisticsTask"
                value="108"
                symbol="GenerateStatisticsTask"
                message="$(string.GenerateStatisticsTask.TaskMessage)"
                />
            <task
                name="FillMaskAndScaleImagesFlashNoFlashTask"
                value="109"
                symbol="FillMaskAndScaleImagesFlashNoFlashTask"
                message="$(string.FillMaskAndScaleImagesFlashNoFlashTask.TaskMessage)"
                />
            <task
                name="LaplacianBlendTask"
                value="110"
                symbol="LaplacianBlendTask"
                message="$(string.LaplacianBlendTask.TaskMessage)"
                />
        </tasks>

        <templates>
            <template tid="String">
                <data inType="win:UnicodeString" name="pszString"/>
            </template>
            <template tid="StringString">
                <data inType="win:UnicodeString" name="pszString1"/>
                <data inType="win:UnicodeString" name="pszString2"/>
            </template>
            <template tid="Size">
                <data inType="win:UInt32" name="uWidth"/>
                <data inType="win:UInt32" name="uHeight"/>
            </template>
            <template tid="CountSize">
                <data inType="win:UInt32" name="uCount"/>
                <data inType="win:UInt32" name="uWidth"/>
                <data inType="win:UInt32" name="uHeight"/>
            </template>
        </templates>

        <events>
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_RunHdrTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_RunHdrTask"
              task="RunHdrTask"
              template="Size"
              value="200"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_RunHdrTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_RunHdrTask"
              task="RunHdrTask"
              value="201"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_RunFlashNoFlashTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_RunFlashNoFlashTask"
              task="RunFlashNoFlashTask"
              template="Size"
              value="202"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_RunFlashNoFlashTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_RunFlashNoFlashTask"
              task="RunFlashNoFlashTask"
              value="203"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_BlendBGRA8BuffersTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_BlendBGRA8BuffersTask"
              template="Size"
              task="BlendBGRA8BuffersTask"
              value="204"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_BlendBGRA8BuffersTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_BlendBGRA8BuffersTask"
              task="BlendBGRA8BuffersTask"
              value="205"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_AlignImagesTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_AlignImagesTask"
              task="AlignImagesTask"
              template="CountSize"
              value="206"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_AlignImagesTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_AlignImagesTask"
              task="AlignImagesTask"
              value="207"
              />


          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_CreateRgbScalingCoefficientsHdrTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_CreateRgbScalingCoefficientsHdrTask"
              task="CreateRgbScalingCoefficientsHdrTask"
              value="208"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_CreateRgbScalingCoefficientsHdrTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_CreateRgbScalingCoefficientsHdrTask"
              task="CreateRgbScalingCoefficientsHdrTask"
              value="209"
              />

          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_CreateRgbScalingCoefficientsFlashNoFlashTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_CreateRgbScalingCoefficientsFlashNoFlashTask"
              task="CreateRgbScalingCoefficientsFlashNoFlashTask"
              value="210"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_CreateRgbScalingCoefficientsFlashNoFlashTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_CreateRgbScalingCoefficientsFlashNoFlashTask"
              task="CreateRgbScalingCoefficientsFlashNoFlashTask"
              value="211"
              />

          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_FillMaskAndScaleImagesHdrTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_FillMaskAndScaleImagesHdrTask"
              task="FillMaskAndScaleImagesHdrTask"
              template="String"
              value="212"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_FillMaskAndScaleImagesHdrTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_FillMaskAndScaleImagesHdrTask"
              task="FillMaskAndScaleImagesHdrTask"
              value="213"
              />

          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_GenerateStatisticsTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_GenerateStatisticsTask"
              task="GenerateStatisticsTask"
              value="214"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_GenerateStatisticsTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_GenerateStatisticsTask"
              task="GenerateStatisticsTask"
              value="215"
              />

          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_FillMaskAndScaleImagesFlashNoFlashTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_FillMaskAndScaleImagesFlashNoFlashTask"
              task="FillMaskAndScaleImagesFlashNoFlashTask"
              template="StringString"
              value="216"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_FillMaskAndScaleImagesFlashNoFlashTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_FillMaskAndScaleImagesFlashNoFlashTask"
              task="FillMaskAndScaleImagesFlashNoFlashTask"
              value="217"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.Begin_LaplacianBlendTask.EventMessage)"
              opcode="win:Start"
              symbol="Begin_LaplacianBlendTask"
              task="LaplacianBlendTask"
              template="String"
              value="218"
              />
          <event
              keywords="Performance"
              level="win:Informational"
              message="$(string.End_LaplacianBlendTask.EventMessage)"
              opcode="win:Stop"
              symbol="End_LaplacianBlendTask"
              task="LaplacianBlendTask"
              value="219"
              />
        </events>
      </provider>
    </events>
  </instrumentation>
  <localization>
    <resources culture="en-US">
      <stringTable>
        <!-- Keywords -->
        <string
            id="Keyword.Error"
            value="Error"
            />
        <string
            id="Keyword.Performance"
            value="Performance"
            />
        <string
            id="Keyword.Debug"
            value="Debug"
            />
        <!-- Task Messages -->
        <string
            id="RunHdrTask.TaskMessage"
            value="RunHdr Method"
            />
        <string
            id="RunFlashNoFlashTask.TaskMessage"
            value="RunFlashNoFlash Method"
            />
        <string
            id="BlendBGRA8BuffersTask.TaskMessage"
            value="BlendBGRA8Buffers Method"
            />
        <string
            id="AlignImagesTask.TaskMessage"
            value="AlignImages Method"
            />
        <string
            id="CreateRgbScalingCoefficientsHdrTask.TaskMessage"
            value="CreateRgbScalingCoefficientsHdr Method"
            />
        <string
            id="CreateRgbScalingCoefficientsFlashNoFlashTask.TaskMessage"
            value="CreateRgbScalingCoefficientsFlashNoFlash Method"
            />
        <string
            id="FillMaskAndScaleImagesHdrTask.TaskMessage"
            value="FillMaskAndScaleImagesHdr Method"
            />
        <string
            id="GenerateStatisticsTask.TaskMessage"
            value="GenerateStatistics Method"
            />
        <string
            id="FillMaskAndScaleImagesFlashNoFlashTask.TaskMessage"
            value="FillMaskAndScaleImagesFlashNoFlash Method"
            />

        <string
            id="LaplacianBlendTask.TaskMessage"
            value="LaplacianBlend Method"
            />

        <!-- Event Messages -->
        <string
            id="Begin_RunHdrTask.EventMessage"
            value="Begin RunHdrTask Perf Marker"
            />
        <string
            id="End_RunHdrTask.EventMessage"
            value="End RunHdrTask Perf Marker"
            />
        <string
            id="Begin_RunFlashNoFlashTask.EventMessage"
            value="Begin RunFlashNoFlashTask Perf Marker"
            />
        <string
            id="End_RunFlashNoFlashTask.EventMessage"
            value="End RunFlashNoFlashTask Perf Marker"
            />
        <string
            id="Begin_BlendBGRA8BuffersTask.EventMessage"
            value="Begin BlendBGRA8BuffersTask Perf Marker"
            />
        <string
            id="End_BlendBGRA8BuffersTask.EventMessage"
            value="End BlendBGRA8BuffersTask Perf Marker"
            />
        <string
            id="Begin_AlignImagesTask.EventMessage"
            value="Begin AlignImagesTask Perf Marker"
            />
        <string
            id="End_AlignImagesTask.EventMessage"
            value="End AlignImagesTask Perf Marker"
            />
        <string
            id="Begin_CreateRgbScalingCoefficientsHdrTask.EventMessage"
            value="Begin CreateRgbScalingCoefficientsHdrTask Perf Marker"
            />
        <string
            id="End_CreateRgbScalingCoefficientsHdrTask.EventMessage"
            value="End CreateRgbScalingCoefficientsHdrTask Perf Marker"
            />
        <string
            id="Begin_CreateRgbScalingCoefficientsFlashNoFlashTask.EventMessage"
            value="Begin CreateRgbScalingCoefficientsFlashNoFlashTask Perf Marker"
            />
        <string
            id="End_CreateRgbScalingCoefficientsFlashNoFlashTask.EventMessage"
            value="End CreateRgbScalingCoefficientsFlashNoFlashTask Perf Marker"
            />
        <string
            id="Begin_FillMaskAndScaleImagesHdrTask.EventMessage"
            value="Begin FillMaskAndScaleImagesHdrTask Perf Marker"
            />
        <string
            id="End_FillMaskAndScaleImagesHdrTask.EventMessage"
            value="End FillMaskAndScaleImagesHdrTask Perf Marker"
            />
        <string
            id="Begin_GenerateStatisticsTask.EventMessage"
            value="Begin GenerateStatisticsTask Perf Marker"
            />
        <string
            id="End_GenerateStatisticsTask.EventMessage"
            value="End GenerateStatisticsTask Perf Marker"
            />
        <string
            id="Begin_FillMaskAndScaleImagesFlashNoFlashTask.EventMessage"
            value="Begin FillMaskAndScaleImagesFlashNoFlashTask Perf Marker"
            />
        <string
            id="End_FillMaskAndScaleImagesFlashNoFlashTask.EventMessage"
            value="End FillMaskAndScaleImagesFlashNoFlashTask Perf Marker"
            />
        <string
            id="Begin_LaplacianBlendTask.EventMessage"
            value="Begin LaplacianBlendTask Perf Marker"
            />
        <string
            id="End_LaplacianBlendTask.EventMessage"
            value="End LaplacianBlendTask Perf Marker"
            />
      </stringTable>
    </resources>
  </localization>
</instrumentationManifest>
