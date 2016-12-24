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
      <provider name="Microsoft-WindowsPhone-RspCellular"
          guid="{7af3c030-a51d-4578-a09f-0aace0d46476}"
          symbol="WINDOWSPHONE_EVENTLOG_RSPCELLULAR_PUBLISHER"
          resourceFileName="RspCellular.dll"
          messageFileName="RspCellular.dll">

        <channels />

        <keywords>
          <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
          <keyword mask="0x0000000000000001" name="Error"       message="$(string.Keyword.Error)" />
          <keyword mask="0x0000000000000002" name="Performance" message="$(string.Keyword.Performance)" />
          <!-- Other keywords are provider-specific. -->
          <keyword mask="0x0000000000000004" name="Info"        message="$(string.Keyword.Info)" />
          <keyword mask="0x0000000000000008" name="Verbose"        message="$(string.Keyword.Verbose)" />
        </keywords>
        
        <tasks>
          <task value="1" name="Initialization" />
          <task value="2" name="Resource" />
          <task value="3" name="StateNotif" />
        </tasks>
        
        <!--Event Templates-->
        <templates>

          <template tid="tDwordHex">
            <data name="dwCode" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="tDwordDec">
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="t2DwordDec">
            <data name="dwCode1" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="t3DwordDec">
            <data name="dwCode1" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode2" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode3" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="t2DwordsHex">
            <data name="dwCode1" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="tHexAndDec">
            <data name="dwCode1" inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="tDecAndHex">
            <data name="dwCode1" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="t2DecAndHex">
            <data name="dwCode1" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode2" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode" inType="win:UInt32" outType="win:HexInt32" />
          </template>

          <template tid="tAnsiString">
            <data name="szString"    inType="win:AnsiString" />
          </template>

          <template tid="tDwordAndAnsiString">
            <data name="dwErrorCode" inType="win:UInt32" outType="win:HexInt32" />
            <data name="szString"    inType="win:AnsiString" />
          </template>

          <template tid="tDwordAndString">
            <data name="dwCode"   inType="win:UInt32" outType="win:HexInt32" />
            <data name="szString" inType="win:UnicodeString" />
          </template>

          <template tid="tGuid">
            <data name="InterfaceGuid" inType="win:GUID" outType="xs:GUID"  />
          </template>

          <template tid="tGuidAndDecimal">
            <data name="InterfaceGuid" inType="win:GUID" outType="xs:GUID"  />
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="tUnicodeStringAndDecimal">
            <data name="szString"    inType="win:UnicodeString" />
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="tUnicodeStringAnd3Decimals">
            <data name="szString"    inType="win:UnicodeString" />
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode3" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode4" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

          <template tid="tUnicodeStringAndHex">
            <data name="szString"    inType="win:UnicodeString" />
            <data name="dwCode" inType="win:UInt32" outType="xs:HexInt32" />
          </template>
          
          <template tid="tUnicodeString">
            <data name="szString"    inType="win:UnicodeString" />
          </template>

           <template tid="tGuidAndHex">
            <data name="InterfaceGuid" inType="win:GUID" outType="xs:GUID"  />
            <data name="dwCode" inType="win:UInt32" outType="xs:HexInt32" />
          </template>
          
           <template tid="tUnicodeStringAnd2Dec">
            <data name="szString"    inType="win:UnicodeString" />
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="dwCode2" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

           <template tid="tGuidAndHexAndDecimal">
            <data name="InterfaceGuid" inType="win:GUID" outType="xs:GUID"  />
            <data name="dwCode" inType="win:UInt32" outType="xs:HexInt32" />
            <data name="dwCode2" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

           <template tid="tUnicodeStringAndHexAndDecimal">
            <data name="szString" inType="win:UnicodeString" />
            <data name="dwCode" inType="win:UInt32" outType="xs:HexInt32" />
            <data name="dwCode2" inType="win:UInt32" outType="xs:unsignedInt" />
          </template>

           <template tid="tGuidAndAnsiString">
            <data name="InterfaceGuid" inType="win:GUID" outType="xs:GUID"  />
            <data name="szString"    inType="win:AnsiString" />
          </template>

           <template tid="tGuidAndUnicodeString">
            <data name="InterfaceGuid" inType="win:GUID" outType="xs:GUID"  />
            <data name="szString"    inType="win:UnicodeString" />
          </template>

           <template tid="tDecimalGuidAndUnicodeString">
            <data name="dwCode" inType="win:UInt32" outType="xs:unsignedInt" />
            <data name="InterfaceGuid" inType="win:GUID" outType="xs:GUID"  />
            <data name="szString"    inType="win:UnicodeString" />
          </template>

          <template tid="tUnicodeStringAndUnicodeStringAndBoolean">
            <data name="szString"    inType="win:UnicodeString" />
            <data name="szString2"    inType="win:UnicodeString" />
            <data name="fBoolean"    inType="win:Boolean" />
          </template>

         <template tid="t2DwordsAndString">
            <data name="dwCode1"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="dwCode2"  inType="win:UInt32" outType="win:HexInt32" />
            <data name="szString" inType="win:UnicodeString" />
          </template>

          <template tid="tFixedSizeByteArray">
            <data name="buffer" inType="win:UInt8" count="128"/>
          </template>

          <template tid="tVariableSizeByteArray">
            <data name="cbSize" inType="win:UInt32" />
            <data name="buffer" inType="win:UInt8" count="cbSize"/>
          </template>

        </templates>

        <!--All the Events that can be published by this Publisher -->
        <events>

          <event value="100"
              symbol="_RspCellLoaded"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.RspCellLoaded)" />

          <event value="101"
              symbol="_RspCellUnloaded"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Stop"
              message="$(string.Event.RspCellUnloaded)" />

          <event value="102"
              symbol="_RspCellLoadError"
              task="Initialization"
              keywords="Error"
              level="win:Critical"
              opcode="win:Start"
              template="tDwordDec"
              message="$(string.Event.RspCellLoadErr)" />

          <event value="103"
              symbol="_RspCellInitialized"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.RspCellInitialized)" />
              
          <event value="104"
              symbol="_RspCellInitError"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="tAnsiString"
              message="$(string.Event.RspCellInitErr)" />

          <event value="105"
              symbol="_RspCellDeinitialized"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Stop"
              message="$(string.Event.RspCellDeinitialized)" />

          <event value="106"
              symbol="_RspCellAquireFailedInvalidParam"
              task="Resource"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellAquireFailedInvalidParam)" />

          <event value="107"
              symbol="_RspCellAquisitionFailed"
              task="Resource"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              template="tUnicodeStringAndDecimal"
              message="$(string.Event.RspCellAquisitionFailed)" />

          <event value="108"
              symbol="_RspCellAquisition"
              task="Resource"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAndHex"
              message="$(string.Event.RspCellAquisition)" />
              
          <event value="109"
              symbol="_RspCellReleaseFailed"
              task="Resource"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              template="tHexAndDec"
              message="$(string.Event.RspCellReleaseFailed)" />

          <event value="110"
              symbol="_RspCellReleased"
              task="Resource"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordHex"
              message="$(string.Event.RspCellReleased)" />
              
           <event value="111"
              symbol="_RspCellGetInfoFailedInvalidParam"
              task="Resource"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellGetInfoFailedInvalidParam)" />

          <event value="112"
              symbol="_RspCellGetInfoFailed"
              task="Resource"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              template="tGuidAndDecimal"
              message="$(string.Event.RspCellGetInfoFailed)" />

          <event value="113"
              symbol="_RspCellGetInfo"
              task="Resource"
              keywords="Info"
              level="win:Verbose"
              opcode="win:Info"
              template="tGuid"
              message="$(string.Event.RspCellGetInfo)" />

          <event value="114"
              symbol="_RspCellInitResourceFailed"
              task="Resource"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              template="tGuidAndAnsiString"
              message="$(string.Event.RspCellInitResourceFailed)" />
              
           <event value="115"
              symbol="_RspCellNdiswwanNotifyInvalidParam"
              task="StateNotif"
              keywords="Error"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellNdiswwanNotifyInvalidParam)" />

          <event value="116"
              symbol="_RspCellNdiswwanNotify"
              task="StateNotif"
              keywords="Info"
              level="win:Verbose"
              opcode="win:Info"
              template="tDwordDec"
              message="$(string.Event.RspCellNdiswwanNotify)" />

          <event value="117"
              symbol="_RspCellRegStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DecAndHex"
              message="$(string.Event.RspCellRegStateHandler)" />

          <event value="118"
              symbol="_RspCellRegStateHandlerErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellRegStateHandlerErr)" />

          <event value="119"
              symbol="_RspCellPacketServiceStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DecAndHex"
              message="$(string.Event.RspCellPacketServiceStateHandler)" />

          <event value="120"
              symbol="_RspCellPacketServiceStateHandlerErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              template="tAnsiString"
              message="$(string.Event.RspCellPacketServiceStateHandlerErr)" />

          <event value="121"
              symbol="_RspCellSuspendStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DwordDec"
              message="$(string.Event.RspCellSuspendStateHandler)" />

          <event value="122"
              symbol="_RspCellSuspendStateHandlerErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellSuspendStateHandlerErr)" />

          <event value="123"
              symbol="_RspCellInitializeMaxCtxtCnt"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tDecimalGuidAndUnicodeString"
              message="$(string.Event.RspCellInitializeMaxCtxtCnt)" />

          <event value="124"
              symbol="_RspCellInitializeMaxCtxtCntErr"
              task="Initialization"
              keywords="Info"
              level="win:Error"
              opcode="win:Start"
              template="tGuid"
              message="$(string.Event.RspCellInitializeMaxCtxtCntErr)" />

          <event value="125"
              symbol="_RspCellInitializeMaxCtxtCntOEMConfigNotFound"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tDwordDec"
              message="$(string.Event.RspCellInitializeMaxCtxtCntOEMConfigNotFound)" />

          <event value="126"
              symbol="_RspCellInitializeMaxCtxtCntOEMConfigZero"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tDwordDec"
              message="$(string.Event.RspCellInitializeMaxCtxtCntOEMConfigZero)" />

          <event value="127"
              symbol="_RspCellInitializeMaxCtxtCntOEMConfigInvalidCdma"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tDwordDec"
              message="$(string.Event.RspCellInitializeMaxCtxtCntOEMConfigInvalidCdma)" />

          <event value="128"
              symbol="_RspCellInitializeMaxCtxtCntSet"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tDwordDec"
              message="$(string.Event.RspCellInitializeMaxCtxtCntSet)" />

          <event value="129"
              symbol="_RspCellAcquireFailNoMore"
              task="Resource"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAnd2Dec"
              message="$(string.Event.RspCellAcquireFailNoMore)" />

          <event value="130"
              symbol="_RspCellAcquireErr"
              task="Resource"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              template="tUnicodeString"
              message="$(string.Event.RspCellAcquireErr)" />

           <event value="131"
              symbol="_RspCellAcquireFailUnavaile"
              task="Resource"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              template="tUnicodeString"
              message="$(string.Event.RspCellAcquireFailUnavaile)" />

          <event value="132"
              symbol="_RspCellAcquired"
              task="Resource"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAnd2Dec"
              message="$(string.Event.RspCellAcquired)" />

          <event value="133"
              symbol="_RspCellResourceReleaseErr"
              task="Resource"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              template="tUnicodeString"
              message="$(string.Event.RspCellResourceReleaseErr)" />

          <event value="134"
              symbol="_RspCellResourceReleased"
              task="Resource"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAnd2Dec"
              message="$(string.Event.RspCellResourceReleased)" />

          <event value="135"
              symbol="_RspCellNotifyRMSuspension"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAndHexAndDecimal"
              message="$(string.Event.RspCellNotifyRMSuspension)" />

          <event value="136"
              symbol="_RspCellNotifyRMAvailability"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAndDecimal"
              message="$(string.Event.RspCellNotifyRMAvailability)" />

          <event value="137"
              symbol="_RspCellNotifyRMRoaming"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAndDecimal"
              message="$(string.Event.RspCellNotifyRMRoaming)" />

          <event value="138"
              symbol="_RspCellNotifyRMNetworkType"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tUnicodeStringAndUnicodeStringAndBoolean"
              message="$(string.Event.RspCellNotifyRMNetworkType)" />

             <event value="139"
              symbol="_RspCellInvalidParamGetNetworkTypeValue"
              task="Resource"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              template="t2DwordsHex"
              message="$(string.Event.RspCellInvalidParamGetNetworkTypeValue)" />

            <event value="140"
              symbol="_RspCellInvalidCellDataClassComb"
              task="Resource"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              template="tDecAndHex"
              message="$(string.Event.RspCellInvalidCellDataClassComb)" />

            <event value="141"
              symbol="_RspCellLoadInfo"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tDwordDec"
              message="$(string.Event.RspCellLoadInfo)" />

          <event value="142"
              symbol="_RspCellReadyStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DwordDec"
              message="$(string.Event.RspCellReadyStateHandler)" />

          <event value="143"
              symbol="_RspCellReadyStateHandlerErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellReadyStateHandlerErr)" />

          <event value="144"
              symbol="_RspCellMaxContextsStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DwordDec"
              message="$(string.Event.RspCellMaxContextsStateHandler)" />

          <event value="145"
              symbol="_RspCellMaxContextsStateHandlerErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellMaxContextsStateHandlerErr)" />

          <event value="146"
              symbol="_RspCellMaxContextsStateHandlerCalledMoreThanOnce"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              template="tDwordDec"
              message="$(string.Event.RspCellMaxContextsStateHandlerCalledMoreThanOnce)" />

          <event value="147"
              symbol="_RspCellLegacyDriverStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DwordDec"
              message="$(string.Event.RspCellLegacyDriverStateHandler)" />

          <event value="148"
              symbol="_RspCellVoiceCallStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DwordDec"
              message="$(string.Event.RspCellVoiceCallStateHandler)" />

          <event value="149"
              symbol="_RspCellRegStateHandlerOOMErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellRegStateHandlerOOMErr)" />

          <event value="150"
              symbol="_RspCellPacketServiceHandlerOOMErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellPacketServiceHandlerOOMErr)" />

          <event value="151"
              symbol="_RspCellSuspendStateHandlerOOMErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellSuspendStateHandlerOOMErr)" />

          <event value="152"
              symbol="_RspCellReadyStateHandlerOOMErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellReadyStateHandlerOOMErr)" />

          <event value="153"
              symbol="_RspCellMaxContextsStateHandlerOOMErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellMaxContextsStateHandlerOOMErr)" />

          <event value="154"
              symbol="_RspCellResourceSuspendHandlerOOMErr"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellResourceSuspendHandlerOOMErr)" />

          <event value="155"
              symbol="_RspCellBspVersionStateHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DwordDec"
              message="$(string.Event.RspCellBspVersionStateHandler)" />

          <event value="156"
              symbol="_RspCellBspVersionStateQuery"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordDec"
              message="$(string.Event.RspCellBspVersionStateQuery)" />

          <event value="157"
              symbol="_RspCellBspVerUpdateError"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="tAnsiString"
              message="$(string.Event.RspCellBspVerUpdateErr)" />

          <event value="159"
              symbol="_RegisterForHomeMCCMNCErr"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="tHexAndDec"
              message="$(string.Event.RegisterForHomeMCCMNCErr)" />

          <event value="160"
              symbol="_ResourceOEMConfiguredCtxtCnt"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tUnicodeStringAndDecimal"
              message="$(string.Event.ResourceOEMConfiguredCtxtCnt)" />

          <event value="161"
              symbol="_ResourceSupportedByModem"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tUnicodeStringAndDecimal"
              message="$(string.Event.ResourceSupportedByModem)" />

          <event value="162"
              symbol="_ResourcePdpContexts"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="tUnicodeStringAnd3Decimals"
              message="$(string.Event.ResourcePdpContexts)" />

          <event value="163"
              symbol="_RegisterForIMSIErr"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="tHexAndDec"
              message="$(string.Event.RegisterForIMSIErr)" />

          <event value="164"
              symbol="_IMSISizeErr"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="t2DwordDec"
              message="$(string.Event.IMSISizeErr)" />

          <event value="165"
              symbol="_RspCellAllocateFilterErr"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              message="$(string.Event.RspCellAllocateFilterErr)" />

          <event value="166"
              symbol="_StatusRoamingWithFilter"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="t3DwordDec"
              message="$(string.Event.StatusRoamingWithFilter)" />

          <event value="167"
              symbol="_3GPPRoamFilterRoamingNotEnabled"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.3GPPRoamFilterRoamingNotEnabled)" />

          <event value="168"
              symbol="_3GPPRoamFilterSIMPlmnNotExist"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.3GPPRoamFilterSIMPlmnNotExist)" />

          <event value="169"
              symbol="_3GPPRoamFilterNotEnabledSIM"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.3GPPRoamFilterNotEnabledSIM)" />

          <event value="170"
              symbol="_3GPPRoamFilterInExceptionList"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.3GPPRoamFilterInExceptionList)" />

          <event value="171"
              symbol="_3GPPRoamFilterInHomePLMN"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.3GPPRoamFilterInHomePLMN)" />

          <event value="172"
              symbol="_3GPPRoamFilterInHomePLMNMaskOffMNCbit"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              message="$(string.Event.3GPPRoamFilterInHomePLMNMaskOffMNCbit)" />

          <event value="173"
              symbol="_3GPPRoamFilterHomeMCCMNC"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Start"
              template="t3DwordDec"
              message="$(string.Event.3GPPRoamFilterHomeMCCMNC)" />

          <event value="174"
              symbol="_RspCellModemCapHandler"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t2DwordDec"
              message="$(string.Event.RspCellModemCapHandler)" />

          <event value="175"
              symbol="_RspCellUpdateAllContextCountByOEMInvalidpResource"
              task="StateNotif"
              keywords="Info"
              level="win:Error"
              opcode="win:Info"
              message="$(string.Event.RspCellUpdateAllContextCountByOEMInvalidpResource)" />

          <event value="176"
              symbol="_RspCellUpdateAllContextCountNewIMSI"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordAndString"
              message="$(string.Event.RspCellUpdateAllContextCountNewIMSI)" />

          <event value="177"
              symbol="_RspCellUpdateAllContextCountDeleteRoamFilter"
              task="StateNotif"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordDec"
              message="$(string.Event.RspCellUpdateAllContextCountDeleteRoamFilter)" />

          <event value="178"
              symbol="_MVSizeErr"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="t2DwordDec"
              message="$(string.Event.MVSizeErr)" />

          <event value="179"
              symbol="_MvWnfSessionInfo"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="t3DwordDec"
              message="$(string.Event.MvWnfSessionInfo)" />

          <event value="180"
              symbol="_CellLegacySettingsMigrationWnfError"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="t2DwordDec"
              message="$(string.Event.CellLegacySettingsMigrationWnfError)" />

          <event value="181"
              symbol="_MigratorState"
              task="Initialization"
              keywords="Info"
              level="win:Informational"
              opcode="win:Info"
              template="tDwordDec"
              message="$(string.Event.MigratorState)" />

          <event value="182"
              symbol="_RegisterForMVSessionsErr"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="tDwordHex"
              message="$(string.Event.RegisterForMVSessionsErr)" />

          <event value="183"
              symbol="_RegisterForLegacySettingsMigrationErr"
              task="Initialization"
              keywords="Error"
              level="win:Error"
              opcode="win:Start"
              template="tDwordHex"
              message="$(string.Event.RegisterForLegacySettingsMigrationErr)" />


        </events>
      </provider>
    </events>
  </instrumentation>

  <localization>
    <resources culture="en-US">
      <stringTable>
        <string id="Keyword.Error"          value="Error" />
        <string id="Keyword.Performance"    value="Performance" />
        <string id="Keyword.Info"           value="Information" />
        <string id="Keyword.Verbose"        value="Verbose" />

        <string id="Event.RspCellLoaded"                                        value="[RspCellular]Loaded" />
        <string id="Event.RspCellUnloaded"                                    value="[RspCellular]Unloaded" />
        <string id="Event.RspCellLoadErr"                                    value="[RspCellular]Load failed (cause=%1)" />
        <string id="Event.RspCellInitErr"                                    value="[RspCellular]Initialization error, happening at or related to: (%1)" />
        <string id="Event.RspCellDeinitialized"                                    value="[RspCellular]Deinitialize" />
        <string id="Event.RspCellInitialized"                                       value="[RspCellular]Initialized" />
        <string id="Event.RspCellAquireFailedInvalidParam"              value="[RspCellular] RSP Aquire failed due to invalid parameter(s)" />
        <string id="Event.RspCellAquisitionFailed"                                    value="[RspCellular]Resource %1: RSP Aquire  failed with Result %2" />
        <string id="Event.RspCellAquisition"                                    value="[RspCellular]Resource %1: RSP Aquired (Handle %2)" />
        <string id="Event.RspCellReleaseFailed"                                    value="[RspCellular]Handle %1: RSP Release failure (%2)" />
        <string id="Event.RspCellReleased"                                    value="[RspCellular]Handle %1: RSP Releaseed" />
        <string id="Event.RspCellGetInfoFailedInvalidParam"             value="[RspCellular]GetInfo failed due to invalid parameter(s)" />
        <string id="Event.RspCellGetInfoFailed"                                    value="[RspCellular]Resource %1: GetInfo  failed with Result %2" />
        <string id="Event.RspCellGetInfo"                                    value="[RspCellular]Resource %1: GetInfo" />
        <string id="Event.RspCellInitResourceFailed"                            value="[RspCellular]Resource %1: init failed around %2" />
        <string id="Event.RspCellNdiswwanNotifyInvalidParam"        value="[RspCellular]NdiswwanNotify failed due to invalid parameter(s)" />
        <string id="Event.RspCellNdiswwanNotify"                                value="[RspCellular]NdiswwanNotify: Type %1" />
        <string id="Event.RspCellRegStateHandler"                                value="[RspCellular]Reg State Handler: Executor %1: current Reg state %2; current cell class %3" />
        <string id="Event.RspCellRegStateHandlerErr"                                value="[RspCellular]Reg State Handler: Error with invalid resource" />
        <string id="Event.RspCellUpdateAllContextCountByOEMInvalidpResource"        value="[RspCellular]UpdateAllContextCountByOEM: Error with invalid resource" />
        <string id="Event.RspCellUpdateAllContextCountNewIMSI"                      value="[RspCellular]UpdateAllContextCountByOEM: executor (%1), new IMSI %2" />
        <string id="Event.RspCellUpdateAllContextCountDeleteRoamFilter"             value="[RspCellular]UpdateAllContextCountByOEM: executor (%1), 3gppRoamingFilter exist, deleting" />
        <string id="Event.RspCellPacketServiceStateHandler"                                value="[RspCellular]Packet Service State Handler: Executor %1: current packet service state %2; current data class %3" />
        <string id="Event.RspCellPacketServiceStateHandlerErr"                                value="[RspCellular]Packet Service State Handler: Error around %1" />
        <string id="Event.RspCellSuspendStateHandler"                                value="[RspCellular]Suspend State Handler: Executor %1: current Suspend state %2" />
        <string id="Event.RspCellSuspendStateHandlerErr"                                value="[RspCellular]Suspend State Handler: Error with invalid resource" />
        <string id="Event.RspCellInitializeMaxCtxtCnt"                                value="[RspCellular]Initiazing max count of concurrent contexts: Executor %1 Resource %2 (%3) " />
        <string id="Event.ResourceOEMConfiguredCtxtCnt"                           value="[RspCellular]Update max count of concurrent contexts resource (%1) Configured by OEM %2 " />
        <string id="Event.ResourceSupportedByModem"                               value="[RspCellular]Update max count of concurrent contexts resource (%1) Supported By Modem %2 " />
        <string id="Event.ResourcePdpContexts"                                    value="[RspCellular]Update max count of concurrent contexts resource (%1) OEM configured %2, SupportedByModem %3, PdpContext %4" />
        <string id="Event.RspCellInitializeMaxCtxtCntErr"                                value="[RspCellular]Initiazing max count of concurrent contexts: Resource %1: unknown resource ID. 3GPP assumed" />
        <string id="Event.RspCellInitializeMaxCtxtCntOEMConfigNotFound"              value="[RspCellular]Initiazing max count of concurrent contexts: OEM config not found. Using default (%1)" />
        <string id="Event.RspCellInitializeMaxCtxtCntOEMConfigZero"                    value="[RspCellular]Initiazing max count of concurrent contexts: OEM config is 0. Using default (%1)" />
        <string id="Event.RspCellInitializeMaxCtxtCntOEMConfigInvalidCdma"         value="[RspCellular]Initiazing max count of concurrent contexts: OEM config for CDMA invalid (%1). Using default" />
        <string id="Event.RspCellInitializeMaxCtxtCntSet"                                value="[RspCellular]Initiazing max count of concurrent contexts: Set to OEMConfigured %1" />
        <string id="Event.RspCellAcquireFailNoMore"                                value="[RspCellular]Resource (%1) acquisition: no more resource (%2 acquired out of max %3)" />
        <string id="Event.RspCellAcquireErr"                                value="[RspCellular]Resource %1 acquisition: unexpected error" />
        <string id="Event.RspCellAcquireFailUnavaile"                                value="[RspCellular]Resource (%1) acquisition: the resource is unavailable" />
        <string id="Event.RspCellAcquired"                                value="[RspCellular]Resource (%1) acquired (%2 acquired out of max %3)" />                  
        <string id="Event.RspCellResourceReleaseErr"                                value="[RspCellular]Resource (%1) release: unexpected error" />                  
        <string id="Event.RspCellResourceReleased"                                value="[RspCellular]Resource (%1) released (%2 still acquired out of max %3)" />                  
        <string id="Event.RspCellNotifyRMSuspension"                                value="[RspCellular]Resource (%1) Handle(%2) RM notification: suspension state (%3)" />                  
        <string id="Event.RspCellNotifyRMAvailability"                                value="[RspCellular]Resource (%1) RM notification: availability state (%2)" />                  
        <string id="Event.RspCellNotifyRMRoaming"                                value="[RspCellular]Resource (%1) RM notification: roaming state (%2)" />                  
        <string id="Event.RspCellNotifyRMNetworkType"                                value="[RspCellular]Resource (%1) RM notification: network type (%2), voice call conflict(%3)" />                  
        <string id="Event.RspCellInvalidParamGetNetworkTypeValue"       value="[RspCellular]Invalid Pointers in GetNetworkTypeValue : pNetworkType (%1) pfVoiceCallConflict (%2)" />             
        <string id="Event.RspCellInvalidCellDataClassComb"       value="[RspCellular]Invalid Cell/DataClass Comb : cell class (%1) data class (%2)" />             
        <string id="Event.RspCellLoadInfo"                                    value="[RspCellular]Load failed Info (cause=%1)" />
        <string id="Event.RspCellReadyStateHandler"                                value="[RspCellular]Ready State Handler: Executor %1: current ready state %2" />
        <string id="Event.RspCellReadyStateHandlerErr"                                value="[RspCellular]Ready State Handler: Error with invalid resource" />
        <string id="Event.RspCellMaxContextsStateHandler"                                value="[RspCellular]MaxContexts State Handler: Executor %1: current MaxContexts state %2" />
        <string id="Event.RspCellMaxContextsStateHandlerErr"                                value="[RspCellular]MaxContexts State Handler: Error with invalid resource" />
        <string id="Event.RspCellVoiceCallStateHandler"                                value="[RspCellular]VoiceCall State Handler: Executor %1: voice call state %2" />
        <string id="Event.RspCellBspVersionStateHandler"                                value="[RspCellular]BspVersion State Handler: previous DriverVer %1 Updated Driver version %2" />
        <string id="Event.RspCellModemCapHandler"                                       value="[RspCellular]ModemCap Handler: previous Capknown %1 Updated ModemCap known %2" />
        <string id="Event.RspCellBspVersionStateQuery"                                value="[RspCellular]BspVersion State Query: DriverVersion %1" />
        <string id="Event.RspCellMaxContextsStateHandlerCalledMoreThanOnce"                                value="[RspCellular]MaxContexts State Handler: Called %1 times, more than once" />
        <string id="Event.RspCellLegacyDriverStateHandler"                                value="[RspCellular]Legacy Driver State Handler: Executor %1: current Legacy Driver state %2" />
        <string id="Event.RspCellRegStateHandlerOOMErr"                                value="[RspCellular]Reg State Handler: Out Of Memory" />
        <string id="Event.RspCellPacketServiceHandlerOOMErr"                                value="[RspCellular]Packet Service Handler: Out Of Memory" />
        <string id="Event.RspCellSuspendStateHandlerOOMErr"                                value="[RspCellular]Suspend State Handler: Out Of Memory" />
        <string id="Event.RspCellReadyStateHandlerOOMErr"                                value="[RspCellular]Ready State Handler: Out Of Memory" />
        <string id="Event.RspCellMaxContextsStateHandlerOOMErr"                                value="[RspCellular]Max Contexts State Handler: Out Of Memory" />
        <string id="Event.RspCellResourceSuspendHandlerOOMErr"                                value="[RspCellular]Resource Suspend Handler: Out Of Memory" />
        <string id="Event.RspCellBspVerUpdateErr"                                    value="[RspCellular]BSP Version Update error, happening at or related to: (%1)" />
        <string id="Event.RegisterForHomeMCCMNCErr"                                  value="[RspCellular]RegisterForHomeMCCMNC Error (%1) Executor Id %2 " />
        <string id="Event.RegisterForIMSIErr"                                  value="[RspCellular]RegisterForIMSI Error (%1) Executor Id %2 " />
        <string id="Event.IMSISizeErr"                                  value="[RspCellular]IMSI Size Error actual %1, Exepected %2 " />
        <string id="Event.RspCellAllocateFilterErr"                         value="[RspCellular]Failed to allocate memory for Roaming Filter" />
        <string id="Event.StatusRoamingWithFilter"                         value="[RspCellular]3GPPRoamFilter StatusRoamingWithFilter MCC %1 MNC %2, roamingStatus %3" />
        <string id="Event.3GPPRoamFilterRoamingNotEnabled"                 value="[RspCellular]3GPPRoamFilter roaming filter is not enabled" />
        <string id="Event.3GPPRoamFilterSIMPlmnNotExist"                   value="[RspCellular]3GPPRoamFilter SIM PLMN doesn't exist" />
        <string id="Event.3GPPRoamFilterNotEnabledSIM"                     value="[RspCellular]3GPPRoamFilter SIM PLMN is not enabled" />
        <string id="Event.3GPPRoamFilterInExceptionList"                   value="[RspCellular]3GPPRoamFilter MCC/MNC is in exception list" />
        <string id="Event.3GPPRoamFilterInHomePLMN"                        value="[RspCellular]3GPPRoamFilter MCC/MNC is in home plmn list" />
        <string id="Event.3GPPRoamFilterInHomePLMNMaskOffMNCbit"           value="[RspCellular]3GPPRoamFilter MCC/MNC is in exception list with Off MNC bit" />
        <string id="Event.3GPPRoamFilterHomeMCCMNC"                        value="[RspCellular]3GPPRoamFilter StatusRoamingWithFilter Home MCC %1 MNC %2, Execid %3" />
        <string id="Event.MVSizeErr"                                       value="[RspCellular]MVSizeErr Size Error actual %1, Exepected %2" />
        <string id="Event.MvWnfSessionInfo"                                value="[RspCellular]MVWNFSessionInfo item %1, slot %2, MVState %3" />
        <string id="Event.CellLegacySettingsMigrationWnfError"             value="[RspCellular]CellLegacySettingsMigration Size Error actual %1, Exepected %2" />
        <string id="Event.MigratorState"                                   value="[RspCellular]CellLegacySettingsMigration State %1" />
        <string id="Event.RegisterForMVSessionsErr"                        value="[RspCellular]RegisterForMultiVariantStage failed: %1" />
        <string id="Event.RegisterForLegacySettingsMigrationErr"           value="[RspCellular]RegisterForCellLegacySettingsMigration failed: %1" />
      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>


