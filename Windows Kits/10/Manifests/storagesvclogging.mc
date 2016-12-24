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
      <provider name="Microsoft-WindowsPhone-StorageSvc"
          guid="{3B6EAB83-3683-4A4E-8382-58A748E0F56D}"
          symbol="MICROSOFT_WINDOWSPHONE_STORAGESVC"
          messageFileName="StorageSvc.dll"
          resourceFileName="StorageSvc.dll">

        <channels />

        <keywords>
          <!-- Keywords 1 and 2 are defined by WinPhone best practices. -->
          <keyword mask="0x0000000000000001" name="Error" message="$(string.Keyword.Error)" />
          <keyword mask="0x0000000000000002" name="Performance" message="$(string.Keyword.Performance)" />
          <!-- Other keywords are provider-specific. -->
          <keyword mask="0x0000000000000004" name="Volume" message="$(string.Keyword.Volume)" />
          <keyword mask="0x0000000000000008" name="Watchdog" message="$(string.Keyword.Watchdog)" />
        </keywords>


        <tasks>
          <task value="1" name="Init" />
          <task value="2" name="CardDetect" />
          <task value="3" name="TempCleanup" />
          <task value="4" name="ScanVolume" />
        </tasks>

        <templates>
          <template tid="FunctionFailure">
            <data name="ErrorCode" inType="win:Int32" outType="win:HResult" />
          </template>

          <template tid="FunctionTypeFailure">
            <data name="Type" inType="win:Int32" />
            <data name="ErrorCode" inType="win:Int32" outType="win:HResult" />
          </template>

          <template tid="FunctionFailureString">
            <data name="String" inType="win:UnicodeString" />
            <data name="ErrorCode" inType="win:Int32" outType="win:HResult" />
          </template>

          <template tid="Dword">
            <data name="Value" inType="win:UInt32" />
          </template>

          <template tid="Cleanup">
            <data name="Value" inType="win:Boolean" />
            <data name="FreeBytes" inType="win:UInt64" />
          </template>

          <template tid="Media">
            <data name="Node" inType="win:UInt32" />
            <data name="Store" inType="win:UInt32" />
            <data name="StoreIndex" inType="win:UInt32" />
            <data name="Size" inType="win:UInt64" />
            <data name="ItemCount" inType="win:UInt64" />
            <data name="ErrorCode" inType="win:Int32" outType="win:HResult" />
          </template>

          <template tid="String">
            <data name="String" inType="win:UnicodeString" />
          </template>

          <template tid="StringTime">
            <data name="String" inType="win:UnicodeString" />
            <data name="Value" inType="win:Int32" />
          </template>
        </templates>

        <events>

          <!-- Error events. -->
          <event value="100" symbol="InitFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.InitFailure)" />
          <event value="101" symbol="VolumeOnlineFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.VolumeOnlineFailure)" />
          <event value="102" symbol="MountVolumeFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.MountVolumeFailure)" />
          <event value="103" symbol="DismountVolumeRequestFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.DismountVolumeRequestFailure)" />
          <event value="104" symbol="VolumeOfflineFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.VolumeOfflineFailure)" />
          <event value="105" symbol="DismountVolumeFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.DismountVolumeFailure)" />
          <event value="106" symbol="FormatVolumeRequestFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.FormatVolumeRequestFailure)" />
          <event value="107" symbol="FormatVolumeFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.FormatVolumeFailure)" />
          <event value="108" symbol="GetSlotCountFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.GetSlotCountFailure)" />
          <event value="109" symbol="CompleteInitFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.CompleteInitFailure)" />
          <event value="110" symbol="CleanupTempDirectoryFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.CleanupTempDirectoryFailure)" />
          <event value="111" symbol="CreateDirectoryFailure" keywords="Error" level="win:Error" template="FunctionFailureString" message="$(string.Event.CreateDirectoryFailure)" />
          <event value="112" symbol="SetFileAttributesFailure" keywords="Error" level="win:Error" template="FunctionFailureString" message="$(string.Event.SetFileAttributesFailure)" />
          <event value="113" symbol="SetStorageRegSettingFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.SetStorageRegSettingFailure)" />
          <event value="114" symbol="DetermineNewCardFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.DetermineNewCardFailure)" />
          <event value="115" symbol="DeterminePresenceFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.DeterminePresenceFailure)" />
          <event value="116" symbol="MoveFileFailure" keywords="Error" level="win:Error" template="FunctionFailureString" message="$(string.Event.MoveFileFailure)" />
          <event value="117" symbol="ProcessNewStorageCardFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.ProcessNewStorageCardFailure)" />
          <event value="118" symbol="ProvisionStorageCardFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.ProvisionStorageCardFailure)" />
          <event value="119" symbol="SecureStorageCardFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.SecureStorageCardFailure)" />
          <event value="120" symbol="SetStorageCardDisabledFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.SetStorageCardDisabledFailure)" />
          <event value="121" symbol="SetStorageCardMetadataFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.SetStorageCardMetadataFailure)" />
          <event value="122" symbol="SetWriteAccessFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.SetWriteAccessFailure)" />
          <event value="123" symbol="ServiceShutdownFailure" keywords="Error" level="win:Error" template="FunctionFailureString" message="$(string.Event.ServiceShutdownFailure)" />
          <event value="124" symbol="SetStoragePowerTimeoutFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.SetStoragePowerTimeoutFailure)" />
          <event value="125" symbol="FileChangeCallbackFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.FileChangeCallbackFailure)" />
          <event value="126" symbol="ScanVolumeRequestFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.ScanVolumeRequestFailure)" />
          <event value="127" symbol="ScanVolumeFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.ScanVolumeFailure)" />
          <event value="128" symbol="IsRemovableFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.IsRemovableFailure)" />
          <event value="129" symbol="FindNextStorageTypeExPicturesZuneSizeFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.FindNextStorageTypeExPicturesZuneSizeFailure)" />
          <event value="130" symbol="FindNextStorageTypeExPicturesDeltaSizeFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.FindNextStorageTypeExPicturesDeltaSizeFailure)" />
          <event value="131" symbol="RegisterHostControllerFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.RegisterHostControllerFailure)" />
          <event value="132" symbol="RegisterVolumeFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.RegisterVolumeFailure)" />
          <event value="133" symbol="ProcessHostControllerFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.ProcessHostControllerFailure)" />
          <event value="134" symbol="CheckCrashDumpFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.CheckCrashDumpFailure)" />
          <event value="135" symbol="StorageCleanupFailed" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.StorageCleanupFailed)" />
          <event value="136" symbol="CalculateStorageTypeFailure" keywords="Error" level="win:Error" template="FunctionTypeFailure" message="$(string.Event.CalculateStorageTypeFailure)" />
          <event value="137" symbol="DownloadsCleanupFailed" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.DownloadsCleanupFailed)" />
          <event value="138" symbol="StorageSenseInitializationFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.StorageSenseInitializationFailure)" />
          <event value="139" symbol="StorageSenseUpdateFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.StorageSenseUpdateFailure)" />
          <event value="140" symbol="StorageSenseTerminationFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.StorageSenseTerminationFailure)" />
          <event value="141" symbol="BlinkCleanupFailed" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.BlinkCleanupFailed)" />
          <event value="142" symbol="StorageSenseWnfHandlingFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.StorageSenseWnfHandlingFailure)" />
          <event value="143" symbol="DetermineFormatStateFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.DetermineFormatStateFailure)" />
          <event value="144" symbol="OpenVolumeHandleFailure" keywords="Error" level="win:Error" template="FunctionFailure" message="$(string.Event.OpenVolumeHandleFailure)" />
          
          <!-- Informational events. -->
          <event value="201" symbol="StorageCardMount" keywords="Volume" level="win:Informational" template="Dword" message="$(string.Event.StorageCardMount)" />
          <event value="202" symbol="StorageCardDismount" keywords="Volume" level="win:Informational" template="Dword" message="$(string.Event.StorageCardDismount)" />
          <event value="203" symbol="FinalizeVolumeComplete" keywords="Volume" level="win:Informational" template="Dword" message="$(string.Event.FinalizeVolumeComplete)" />
          <event value="204" symbol="CleanupAgentSvcWatchdogEnforced" keywords="Watchdog" level="win:Informational" template="StringTime" message="$(string.Event.CleanupAgentSvcWatchdogEnforced)" />
          <event value="205" symbol="ProcessHostController" keywords="Volume" level="win:Informational" template="Dword" message="$(string.Event.ProcessHostController)" />
          <event value="206" symbol="StorageCardSlot" keywords="Volume" level="win:Informational" template="Dword" message="$(string.Event.StorageCardSlot)" />
          <event value="207" symbol="StorageUsageApps" keywords="Volume" level="win:Verbose" template="String" message="$(string.Event.StorageUsageApps)" />
          <event value="208" symbol="StorageCleanupInvoked" keywords="Volume" level="win:Verbose" template="Cleanup" message="$(string.Event.StorageCleanupInvoked)" />
          <event value="209" symbol="FileSystemDetected" keywords="Volume" level="win:Informational" template="String" message="$(string.Event.FileSystemDetected)" />
          <event value="210" symbol="WaitMountVolume" keywords="Volume" level="win:Informational" template="Dword" message="$(string.Event.WaitMountVolume)" />
          <event value="211" symbol="StorageUsageMedia" keywords="Volume" level="win:Verbose" template="Media" message="$(string.Event.StorageUsageMedia)" />
          <event value="212" symbol="StorageUsagePicturesDelta" keywords="Volume" level="win:Verbose" template="Media" message="$(string.Event.StorageUsagePicturesDelta)" />
          <event value="213" symbol="StorageUsagePicturesBursts" keywords="Volume" level="win:Verbose" template="Media" message="$(string.Event.StorageUsagePicturesBursts)" />
          <event value="214" symbol="WaitTimeVolumePath" keywords="Volume" level="win:Informational" template="Dword" message="$(string.Event.WaitTimeVolumePath)" />

          <!-- Performance events. -->
          <event value="301" symbol="InitStart" task="Init" keywords="Performance" level="win:Verbose" opcode="win:Start" message="$(string.Event.InitStart)" />          
          <event value="302" symbol="InitStop" task="Init" keywords="Performance" level="win:Verbose" opcode="win:Stop" message="$(string.Event.InitStop)" />
          <event value="303" symbol="CardDetectStart" task="CardDetect" keywords="Performance" level="win:Verbose" opcode="win:Start" message="$(string.Event.CardDetectStart)" />
          <event value="304" symbol="CardDetectStop" task="CardDetect" keywords="Performance" level="win:Verbose" opcode="win:Stop" message="$(string.Event.CardDetectStop)" />
          <event value="305" symbol="TempCleanupStart" task="TempCleanup" keywords="Performance" level="win:Verbose" opcode="win:Start" message="$(string.Event.TempCleanupStart)" />
          <event value="306" symbol="TempCleanupStop" task="TempCleanup" keywords="Performance" level="win:Verbose" opcode="win:Stop" message="$(string.Event.TempCleanupStop)" />
          <event value="307" symbol="ServiceShutdownStart" task="TempCleanup" keywords="Performance" level="win:Verbose" opcode="win:Start" template="String" message="$(string.Event.ServiceShutdownStart)" />
          <event value="308" symbol="ServiceShutdownStop" task="TempCleanup" keywords="Performance" level="win:Verbose" opcode="win:Stop" template="String" message="$(string.Event.ServiceShutdownStop)" />
          <event value="309" symbol="ScanVolumeStart" task="ScanVolume" keywords="Performance" level="win:Informational" template="Dword" opcode="win:Start" message="$(string.Event.ScanVolumeStart)" />          
          <event value="310" symbol="ScanVolumeStop" task="ScanVolume" keywords="Performance" level="win:Informational" template="Dword" opcode="win:Stop" message="$(string.Event.ScanVolumeStop)" />

        </events>

      </provider>
    </events>
  </instrumentation>


  <localization>
    <resources culture="en-US">
      <stringTable>

        <string id="Keyword.Error"                        value="Error" />
        <string id="Keyword.Performance"                  value="Performance" />
        <string id="Keyword.Volume"                       value="Volume" />
        <string id="Keyword.Watchdog"                     value="Watchdog" />
        
        <string id="Event.InitFailure"                    value="InitFailure. Error = %1." />
        <string id="Event.VolumeOnlineFailure"            value="VolumeOnlineFailure. Error = %1." />
        <string id="Event.MountVolumeFailure"             value="MountVolumeFailure. Error = %1." />
        <string id="Event.DismountVolumeRequestFailure"   value="DismountVolumeRequestFailure. Error = %1." />
        <string id="Event.VolumeOfflineFailure"           value="VolumeOfflineFailure. Error = %1." />
        <string id="Event.DismountVolumeFailure"          value="DismountVolumeFailure. Error = %1." />
        <string id="Event.FormatVolumeRequestFailure"     value="FormatVolumeRequestFailure. Error = %1." />
        <string id="Event.FormatVolumeFailure"            value="FormatVolumeFailure. Error = %1." />
        <string id="Event.GetSlotCountFailure"            value="GetSlotCountFailure. Error = %1." />
        <string id="Event.CompleteInitFailure"            value="CompleteInitFailure. Error = %1." />
        <string id="Event.CleanupTempDirectoryFailure"    value="CleanupTempDirectoryFailure. Error = %1." />
        <string id="Event.CreateDirectoryFailure"         value="CreateDirectory failed on %1. Error = %2." />
        <string id="Event.SetFileAttributesFailure"       value="SetFileAttributes failed on %1. Error = %2." />
        <string id="Event.SetStorageRegSettingFailure"    value="SetStorageRegSettingFailure. Error = %1." />
        <string id="Event.DetermineNewCardFailure"        value="DetermineNewCardFailure. Error = %1." />
        <string id="Event.DeterminePresenceFailure"       value="DeterminePresenceFailure. Error = %1." />
        <string id="Event.MoveFileFailure"                value="MoveFile failed on %1. Error = %2." />
        <string id="Event.ProcessNewStorageCardFailure"   value="ProcessNewStorageCardFailure. Error = %1." />
        <string id="Event.ProvisionStorageCardFailure"    value="ProvisionStorageCardFailure. Error = %1." />
        <string id="Event.SecureStorageCardFailure"       value="SecureStorageCardFailure. Error = %1." />
        <string id="Event.SetStorageCardDisabledFailure"  value="SetStorageCardDisabledFailure. Error = %1." />
        <string id="Event.SetStorageCardMetadataFailure"  value="SetStorageCardMetadataFailure. Error = %1." />
        <string id="Event.SetWriteAccessFailure"          value="SetWriteAccessFailure. Error = %1." />
        <string id="Event.ServiceShutdownFailure"         value="ServiceShutdownFailure. Service = %1 Error = %2." />
        <string id="Event.SetStoragePowerTimeoutFailure"  value="SetStoragePowerTimeoutFailure. Error = %1." />
        <string id="Event.FindNextStorageTypeExPicturesZuneSizeFailure"  value="FindNextStorageTypeEx for DATA_TYPE_PICTURES failed GetTotalSizeOfZune with hr = %1." />
        <string id="Event.FindNextStorageTypeExPicturesDeltaSizeFailure" value="FindNextStorageTypeEx for DATA_TYPE_PICTURES failed GetDeltaSizePicturesFolder with hr = %1." />
        <string id="Event.FileChangeCallbackFailure"      value="FileChangeCallbackFailure. Error = %1." />
        <string id="Event.ScanVolumeRequestFailure"       value="ScanVolumeRequestFailure. Error = %1." />
        <string id="Event.ScanVolumeFailure"              value="ScanVolumeFailure. Error = %1." />
        <string id="Event.IsRemovableFailure"             value="IsRemovableFailure. Error = %1." />
        <string id="Event.RegisterHostControllerFailure"  value="RegisterHostControllerFailure. Error = %1." />
        <string id="Event.RegisterVolumeFailure"          value="RegisterVolumeFailure. Error = %1." />
        <string id="Event.ProcessHostControllerFailure"   value="ProcessHostControllerFailure. Error = %1." />
        <string id="Event.CheckCrashDumpFailure"          value="CheckCrashDumpFailure. Error = %1." />
        <string id="Event.StorageCleanupFailed"           value="StorageCleanupFailed. Error = %1." />
        <string id="Event.CalculateStorageTypeFailure"    value="CalculateStorageTypeFailure. Type = %1 Error = %2." />
        <string id="Event.DownloadsCleanupFailed"         value="DownloadsCleanupFailed. Error = %1." />
        <string id="Event.StorageSenseInitializationFailure"  value="StorageSenseInitializationFailure. Error = %1." />
        <string id="Event.StorageSenseUpdateFailure"      value="StorageSenseCleanupFailure. Error = %1." />
        <string id="Event.StorageSenseTerminationFailure" value="StorageSenseTerminationFailure. Error = %1." />
        <string id="Event.BlinkCleanupFailed"             value="BlinkCleanupFailed. Error = %1." />
        <string id="Event.StorageSenseWnfHandlingFailure" value="StorageSenseWnfHandlingFailure. Error = %1." />
        <string id="Event.DetermineFormatStateFailure"    value="DetermineFormatStateFailure. Error = %1." />
        <string id="Event.OpenVolumeHandleFailure"        value="OpenVolumeHandleFailure. Error = %1." />

        <string id="Event.StorageCardMount"                value="Storage card mounted. Volume status = %1." />
        <string id="Event.StorageCardDismount"             value="Storage card dismounted. Dismount reason = %1." />
        <string id="Event.FinalizeVolumeComplete"          value="FinalizeVolume complete. Error = %1." />
        <string id="Event.CleanupAgentSvcWatchdogEnforced" value="Enforced storage service watchdog timeout on cleanup agent. Terminated agent. Agent = %1 Timeout = %2." />
        <string id="Event.ProcessHostController"           value="ProcessHostControllerChange. CurrentSlotCount = %1." />
        <string id="Event.StorageCardSlot"                 value="InitStorageCardSlot. NewSlotCount = %1." />
        <string id="Event.StorageUsageApps"                value="StorageUsageApps. Processing App: %1." />
        <string id="Event.StorageCleanupInvoked"           value="StorageCleanupInvoked. Cleanup initiated by RPC trigger = %1. FreeBytes = %2" />
        <string id="Event.FileSystemDetected"              value="File system detected = %1." />
        <string id="Event.WaitMountVolume"                 value="WaitMountVolume. WaitResult = %1." />
        <string id="Event.StorageUsageMedia"               value="StorageUsageMedia. Calculation for node = %1. Store = %2, StoreIndex = %3, Size = %4, ItemCount = %5, Error = %6" />
        <string id="Event.StorageUsagePicturesDelta"       value="StorageUsagePicturesDelta. Calculation for node = %1. Store = %2, StoreIndex = %3, Size = %4, ItemCount = %5, Error = %6" />
        <string id="Event.StorageUsagePicturesBursts"      value="StorageUsagePicturesBursts. Calculation for node = %1. Store = %2, StoreIndex = %3, Size = %4, ItemCount = %5, Error = %6" />
        <string id="Event.WaitTimeVolumePath"              value="WaitTimeVolumePath. Time in milliseconds = %1." />
        
        <string id="Event.InitStart"                      value="Counter InitStart" />
        <string id="Event.InitStop"                       value="Counter InitStop" />
        <string id="Event.CardDetectStart"                value="Counter CardDetectStart" />
        <string id="Event.CardDetectStop"                 value="Counter CardDetectStop" />
        <string id="Event.TempCleanupStart"               value="Counter TempCleanupStart" />
        <string id="Event.TempCleanupStop"                value="Counter TempCleanupStop" />
        <string id="Event.ServiceShutdownStart"           value="Counter ServiceShutdownStart %1" />
        <string id="Event.ServiceShutdownStop"            value="Counter ServiceShutdownStop %1" />
        <string id="Event.ScanVolumeStart"                value="Counter ScanVolumeStart. FixErrors = %1" />
        <string id="Event.ScanVolumeStop"                 value="Counter ScanVolumeStop. Result = %1" />

      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>
