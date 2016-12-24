<?xml version='1.0' encoding='utf-8' standalone='yes'?>

<?Copyright (c) Microsoft Corporation. All rights reserved.?>
<instrumentationManifest
    xmlns="http://schemas.microsoft.com/win/2004/08/events"
    xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    >
  <instrumentation>
    <events>
      <provider
          guid="{3a560832-fabf-41fd-9c00-598939c72f27}"
          messageFileName="telmanifest.dll"
          resourceFileName="telmanifest.dll"
          name="Microsoft-WindowsPhone-Telemetry"
          symbol="WP_PROVIDER_TELEMETRY"
          >
        <keywords>
          <keyword
              mask="0x00100"
              message="$(string.errors.KeywordMessage)"
              name="errors"
              symbol="WP_TELEMETRY_KEYWORD_ERRORS"
              />
          <keyword
              mask="0x00200"
              message="$(string.cabinet.KeywordMessage)"
              name="cabinet"
              symbol="WP_TELEMETRY_KEYWORD_CABINET"
              />
          <keyword
              mask="0x00400"
              message="$(string.uploader.KeywordMessage)"
              name="uploader"
              symbol="WP_TELEMETRY_KEYWORD_UPLOADER"
              />
          <keyword
              mask="0x00800"
              message="$(string.ocaprocess.KeywordMessage)"
              name="ocaprocess"
              symbol="WP_TELEMETRY_KEYWORD_OCAPROCESS"
              />
          <keyword
              mask="0x01000"
              message="$(string.reportmanager.KeywordMessage)"
              name="reportmanager"
              symbol="WP_TELEMETRY_KEYWORD_REPORTMANAGER"
              />
          <keyword
              mask="0x02000"
              message="$(string.errorhandlingext.KeywordMessage)"
              name="errorhandlingext"
              symbol="WP_TELEMETRY_KEYWORD_ERRORHANDLINGEXT"
              />
          <keyword
              mask="0x04000"
              message="$(string.protocol.KeywordMessage)"
              name="protocol"
              symbol="WP_TELEMETRY_KEYWORD_PROTOCOL"
              />
          <keyword
              mask="0x08000"
              message="$(string.protocol.KeywordMessage)"
              name="sqm"
              symbol="WP_TELEMETRY_KEYWORD_SQM"
              />
          <keyword
              mask="0x10000"
              message="$(string.crashdata.KeywordMessage)"
              name="crashdata"
              symbol="WP_TELEMETRY_KEYWORD_CRASHDATA"
              />
          <keyword
              mask="0x20000"
              message="$(string.telsvc.KeywordMessage)"
              name="telsvc"
              symbol="WP_TELEMETRY_KEYWORD_TELSVC"
              />
          <keyword
              mask="0x40000"
              message="$(string.teltrace.KeywordMessage)"
              name="trace"
              symbol="WP_TELEMETRY_KEYWORD_TRACE"
              />
          <keyword
              mask="0x80000"
              message="$(string.teltrace.KeywordMessage)"
              name="isv"
              symbol="WP_TELEMETRY_KEYWORD_ISV"
              />
          <keyword
              mask="0x100000"
              message="$(string.telsvc.KeywordMessage)"
              name="config"
              symbol="WP_TELEMETRY_KEYWORD_CONFIGURE"
              />
          <keyword
              mask="0x200000"
              message="$(string.watsonbucket.KeywordMessage)"
              name="watsonbucket"
              symbol="WP_TELEMETRY_KEYWORD_WATSONBUCKET"
              />
        </keywords>
        <channels/>
        <tasks>
          <task name="Error" value="1" />
          <task name="Warning" value="2" />
          <task name="Trace" value="3" />

          <task name="TelSvcShutdown" value="10" />
          
          <task name="RefreshEnabled" value="20" />

          <task name="OcaWorkHandlerDoWork" value="30" />
          <task name="OcaWorkHandlerLoadDumpInformation" value="31" />
          <task name="OcaWorkHandlerProcessDump" value="32" />

          <task name="SqmConsolidator" value="40" />

          <task name="ReportManagerReportPublish" value="50" />
          <task name="ReportManagerReportRepublish" value="51" />
          <task name="ReportManagerReportDelete" value="52" />
          <task name="ReportManagerStorageQuotaManagement" value="53" />
          <task name="ReportManagerReadMetadata" value="54" />
          <task name="ReportManagerReportDeletionReason" value="55" />
          <task name="ReportManagerStorageQuotaDeletion" value="56" />
          <task name="ReportManagerStorageQuotaDeletionCommit" value="57" />
          <task name="ReportManagerLostReport" value="58" />
          <task name="ReportManagerLinkOrRename" value="59" />

          <task name="UploaderManager" value="60" />
          <task name="UploaderNetwork" value="61" />
          <task name="UploaderServer" value="62" />
          <task name="UploaderPrepareUploadRequest" value="63" />
          <task name="UploaderCabReceipt" value="64" />
          <task name="UploaderReportUpload" value="65" />
          <task name="UploaderReportCab" value="66" />
          <task name="UploaderReportCabArchived" value="67" />
          
          <task name="ReportThrottled" value="70" />
          <task name="NewThrottleRule" value="71" />
          
          <task name="UserDumpCollection" value="80" />
          <task name="ReportException" value="81" />
          <task name="SingleDumpCollection" value="82" />
          <task name="EtwLogsCollection" value="83" />

          <task name="CabStreamAdd" value="90" />
          <task name="CabFCI" value="91" />

          <task name="IsvDumpCollection" value="100" />
        </tasks>
        <opcodes>
          <opcode name="Error"  value="11"/>
          <opcode name="Abort"  value="12"/>
          <opcode name="Originate"  value="13"/>
          <opcode name="NotFound"  value="14"/>
          <opcode name="State"  value="15"/>
          <opcode name="Publish"  value="16"/>

          <opcode name="OcaDeviceKeyMissing"  value="100"/>
          <opcode name="OcaDeviceValueMissing"  value="101"/>
          <opcode name="OcaDumpFileMissing"  value="102"/>
          <opcode name="OcaDumpCorrupt"  value="103"/>
        </opcodes>
        <!-- Event Templates -->
        <templates>
          <!-- General event templates -->
          <template tid="tError">
            <data inType="win:Int32" outType="win:HResult" name="Error" />
          </template>
          <template tid="tOriginateError">
            <data inType="win:Int32" outType="win:HResult" name="Error" />
            <data inType="win:AnsiString" name="Source" /> <!-- Keep small! -->
          </template>
          <template tid="tErrorState">
            <data inType="win:Int32" outType="win:HResult" name="Error" />
            <data inType="win:Int32" name="SourceLine" />
          </template>
          <template tid="tPointer">
            <data inType="win:Pointer" name="Address" />
          </template>
          <template tid="tGuid">
            <data inType="win:GUID" name="Guid" />
          </template>
          <template tid="tString">
            <data inType="win:UnicodeString" name="String" />
          </template>
          <template tid="tStringPointer">
            <data inType="win:UnicodeString" name="Name" />
            <data inType="win:Pointer" name="Address" />
          </template>
          <template tid="tDword">
            <data inType="win:UInt32" name="Number" />
          </template>
          <template tid="tRefreshEnabledStart">
            <data inType="win:Int32" name="Flags" />
            <data inType="win:Boolean" name="UpdateDetected" />
            <data inType="win:Int32" name="LastKnownEnableState" />
            <data inType="win:Int32" name="OldCeipEnableValue" />
            <data inType="win:Int32" name="NewCeipEnableState" />
            <data inType="win:Int32" outType="win:HResult" name="PermissionHr" />
          </template>
          <template tid="tReportOperation">
            <data inType="win:GUID" name="ReportGuid" />
            <data inType="win:UInt32" name="ReportType" />
            <data inType="win:UnicodeString" name="EventType" />
            <data inType="win:UnicodeString" name="ReportDescriptor" />
          </template>
          <template tid="tReportDeleteReason">
            <data inType="win:GUID" name="ReportGuid" />
            <data inType="win:UnicodeString" name="Reason" />
          </template>
          <!-- If you change this template, please modify tellogutil.h to match. -->
          <template tid="tReportOperationResult">
            <data inType="win:GUID" name="ReportGuid" />
            <data inType="win:UInt32" name="ReportType" />
            <data inType="win:UnicodeString" name="EventType" />
            <data inType="win:UnicodeString" name="ReportDescriptor" />
            <data inType="win:Int32" outType="win:HResult" name="Error" />
          </template>
          <!-- /General event templates -->
          <!-- Cabinet specific event templates -->
          <template tid="tCabFCIOpen">
            <data inType="win:AnsiString" name="Name" />
            <data inType="win:AnsiString" name="Cabinet" />
            <data inType="win:Pointer" name="Address" />
          </template>
          <template tid="tExtractCab">
            <data inType="win:AnsiString" name="CabPath" />
            <data inType="win:AnsiString" name="CabName" />
          </template>
          <template tid="tCabPreAllocateStats">
            <data inType="win:UInt64" name="PreAllocateSizeBytes" />
            <data inType="win:UInt64" name="UncompressedSizeBytes" />
            <data inType="win:UInt64" name="FreeDiskSpaceBytes" />
          </template>
          <!-- /Cabinet specific event templates -->
          <!-- ReportManager specific event templates -->
          <template tid="tReportLinkOrManagerRename">
            <data inType="win:UnicodeString" name="OldFileName" />
            <data inType="win:UnicodeString" name="NewFileName" />
          </template>
          <template tid="tStorageQuotaDeletion">
            <data inType="win:GUID" name="ReportGuid" />
            <data inType="win:UInt64" name="ReportSize" />
            <data inType="win:UInt64" name="ReportStoreSizeBeforeDelete" />
            <data inType="win:UInt64" name="CurrentQuota" />
          </template>
          <template tid="tReportLost">
            <data inType="win:Int32" outType="win:HResult" name="ErrorFromReport" />
            <data inType="win:UnicodeString" name="GuessedImageName" />
            <data inType="win:GUID" name="TransactionGuid" />
            <data inType="win:GUID" name="ReportGuid" />
            <data inType="win:Int32" name="ExceptionCode" />
            <data inType="win:Int32" name="CrashingProcessId" />
            <data inType="win:Int32" name="CrashingThreadId" />
            <data inType="win:Int32" name="DumpFilenameSuffix" />
            <data inType="win:Int32" name="DumpType" />
            <data inType="win:Int32" name="ExceptionIsValid" />
            <data inType="win:Int32" name="ContextIsValid" />
            <data inType="win:Int32" name="AddToExistingReport" />
            <data inType="win:Int32" name="AddHangDetails" />
            <data inType="win:Int32" name="Fatal" />
            <data inType="win:Int32" name="InhibitEtwLogCollection" />
          </template>
          <!-- /ReportManager specific event templates -->
          <!-- Sqm specific event templates -->
          <template tid="tSqmConsolidatorReportPublish">
            <data inType="win:GUID" name="SessionGuid" />
            <data inType="win:GUID" name="ReportGuid" />
          </template>
          <template tid="tSqmConsolidatorCrowdSourcePublish">
            <data inType="win:GUID" name="ProviderGuid" />
            <data inType="win:Int32" outType="win:HResult" name="Error" />
          </template>
          <!-- /Sqm specific event templates -->
          <!-- ErrorHandlingExt specific event templates -->
          <template tid="tErrorHandlingExtBasepTemplate">
            <data inType="win:UInt32" name="PID" />
            <data inType="win:UnicodeString" name="Command-line" />
            <data inType="win:UInt64" name="ExceptionAddress" />
            <data inType="win:UInt32" name="ExceptionCode" />
          </template>
          <template tid="tErrorHandlingExtTelReportExceptionTemplate">
            <data inType="win:UInt32" name="PID" />
            <data inType="win:UInt32" name="TID" />
            <data inType="win:UInt32" name="ExceptionCode" />
            <data inType="win:UInt64" name="ExceptionAddress" />
            <data inType="win:UnicodeString" name="ProcessImageName" />
            <data inType="win:UnicodeString" name="Command-line" />
          </template>
          <template tid="tLiveDumpEventTemplate">
            <data inType="win:UnicodeString" name="EventType" />
            <data inType="win:UInt32" name="ThrottleState" />
            <data inType="win:UInt32" name="ErrorState" />
          </template>
          <template tid="tKernelBugCheckParametersTemplate">
            <data inType="win:UInt32" name="DumpType" />
            <data inType="win:UInt32" name="BugCheckCode" />
            <data inType="win:UInt32" name="Param1" />
            <data inType="win:UInt32" name="Param2" />
            <data inType="win:UInt32" name="Param3" />
            <data inType="win:UInt32" name="Param4" />
            <data inType="win:Boolean" name="LiveDump" />
            <data inType="win:UnicodeString" name="ReportGuid" />
          </template>
          <template tid="tErrorHandlingExtReturn">
            <data inType="win:UInt32" name="ActionTaken" />
          </template>
          <template tid="tUserDumpCollectionStart">
            <data inType="win:UInt32" name="PID" />
            <data inType="win:Boolean" name="IsvDump" />
          </template>
          <template tid="tUserDumpCollectionStop">
            <data inType="win:UInt32" name="PID" />
            <data inType="win:Int32" outType="win:HResult" name="Error" />
          </template>
          <template tid="tSingleDumpCollectionStart">
            <data inType="win:UInt32" name="PID" />
            <data inType="win:UInt32" name="DumpType" />
            <data inType="win:UnicodeString" name="DumpName" />
          </template>
          <template tid="tSingleDumpCollectionStop">
            <data inType="win:UInt32" name="PID" />
            <data inType="win:Int32" outType="win:HResult" name="Error" />
            <data inType="win:Int32" outType="win:HResult" name="RealError" />
            <data inType="win:Int32" outType="win:HResult" name="DumpeeExitCode" />
          </template>
          <template tid="tEtwLogsCollectionStart">
            <data inType="win:UInt32" name="PID" />
          </template>
          <template tid="tEtwLogsCollectionStop">
            <data inType="win:UInt32" name="PID" />
            <data inType="win:Int32" outType="win:HResult" name="Error" />
          </template>
          
          <!-- /ErrorHandlingExt specific event templates -->
          <!-- Uploader specific event templates -->
          <template tid="tUploaderCommand">
            <data inType="win:GUID" name="ReportGuid" />
            <data inType="win:UnicodeString" name="Command" />
          </template>
          <template tid="tUploaderCabReceipt">
            <data inType="win:GUID" name="ReportGuid" />
            <data inType="win:UnicodeString" name="CabId" />
          </template>
          <template tid="tPrepareUploadRequestStart">
            <data inType="win:UInt8" name="ReportType" />
          </template>
          <template tid="tPrepareUploadRequestStop">
            <data inType="win:UnicodeString" name="phTest" />
            <data inType="win:Int32" outType="win:HResult" name="HRESULT" />
          </template>
          <!-- /Uploader specific event templates -->
          <!-- Protocol specific event templates -->
          <template tid="tThrottleNamespace">
            <data inType="win:UnicodeString" name="Service" />
            <data inType="win:UnicodeString" name="Partner" />
            <data inType="win:UnicodeString" name="Group" />
            <data inType="win:UnicodeString" name="Application" />
            <data inType="win:UnicodeString" name="Arguments" />
          </template>
          <template tid="tThrottleNamespaceTime">
            <data inType="win:UnicodeString" name="Service" />
            <data inType="win:UnicodeString" name="Partner" />
            <data inType="win:UnicodeString" name="Group" />
            <data inType="win:UnicodeString" name="Application" />
            <data inType="win:UnicodeString" name="Arguments" />
            <data inType="win:UInt32" name="Period" />
          </template>
          <template tid="tUploadServerRequest">
            <data inType="win:AnsiString" name="Xml" />
          </template>
          <template tid="tUploadServerReply">
            <data inType="win:UInt32" name="HttpStatus" />
            <data inType="win:AnsiString" name="Xml" />
          </template>
          <template tid="tTelTraceMessage">
            <data inType="win:AnsiString" name="Message" />
          </template>
          <template tid="tTelIsvDumpPublish">
            <data inType="win:Int32" outType="win:HResult" name="Error" />
            <data inType="win:UnicodeString" name="PublishedFile" />
          </template>
          <!-- /Protocol specific event templates -->
        </templates>

        <!-- Telemetry Events -->
        <events>
          <!-- Generic events. -->
          <event
              keywords="errors"
              level="win:Error"
              task="Error"
              symbol="TelemetryError"
              template="tError"
              value="100"
              message="$(string.Telemetry.Error)"
              />
          <event
              keywords="errors"
              level="win:Warning"
              task="Warning"
              symbol="TelemetryWarning"
              template="tError"
              value="101"
              message="$(string.Telemetry.Warning)"
              />
          <event
              keywords="errors"
              level="win:Error"
              task="Error"
              opcode="Originate"
              symbol="TelemetryOriginateError"
              template="tOriginateError"
              value="102"
              message="$(string.Telemetry.Error)"
              />
          <event
              keywords="errors"
              level="win:Warning"
              task="Warning"
              opcode="Originate"
              symbol="TelemetryOriginateWarning"
              template="tOriginateError"
              value="103"
              message="$(string.Telemetry.Warning)"
              />
          <event
              keywords="errors"
              level="win:Warning"
              task="Error"
              opcode="win:Extension"
              symbol="TelemetryBountyError"
              template="tError"
              value="104"
              />
          <event
              keywords="trace"
              level="win:Verbose"
              task="Trace"
              opcode="win:Info"
              symbol="TelemetryTrace"
              template="tTelTraceMessage"
              value="105"
              />
          <event
              keywords="errors"
              level="win:Error"
              task="Error"
              opcode="win:Receive"
              symbol="TelemetryRemoteError"
              template="tError"
              value="106"
              message="$(string.Telemetry.RemoteError)"
              />
          <event
              keywords="errors"
              level="win:Error"
              task="Error"
              opcode="State"
              symbol="TelemetryErrorState"
              template="tErrorState"
              value="107"
              />
          <event
              keywords="telsvc"
              level="win:Informational"
              task="TelSvcShutdown"
              opcode="win:Start"
              symbol="TelSvcIdleShutdownBegin"
              value="110"
              message="$(string.Telemetry.TelSvcIdleShutdownBegin)"
              />
          <event
              keywords="telsvc"
              level="win:Informational"
              task="TelSvcShutdown"
              opcode="Abort"
              symbol="TelSvcIdleShutdownAbort"
              value="111"
              message="$(string.Telemetry.TelSvcIdleShutdownAbort)"
              />
          <event
              keywords="telsvc"
              level="win:Informational"
              task="TelSvcShutdown"
              opcode="win:Stop"
              symbol="TelSvcIdleShutdownCommit"
              value="112"
              message="$(string.Telemetry.TelSvcIdleShutdownCommit)"
              />
          <event
              keywords="config"
              level="win:Informational"
              task="RefreshEnabled"
              opcode="win:Start"
              symbol="TelemetryRefreshEnabledStart"
              template="tRefreshEnabledStart"
              value="150"
              />
          <event
              keywords="config"
              level="win:Informational"
              task="RefreshEnabled"
              opcode="win:Start"
              symbol="TelemetryRefreshEnabledStop"
              template="tError"
              value="151"
              />
          <!-- /Generic events. -->
          <!-- Cabinet Specific events. -->
          <event
              keywords="cabinet"
              level="win:Informational"
              task="CabStreamAdd"
              opcode="win:Info"
              message="$(string.Telemetry.CabStreamAdd)"
              symbol="TelemetryCabStreamAdd"
              template="tStringPointer"
              value="200"
              />
          <event
              keywords="cabinet"
              level="win:Informational"
              task="CabFCI"
              opcode="win:Start"
              message="$(string.Telemetry.CabFCIOpen)"
              symbol="TelemetryCabFCIOpen"
              template="tCabFCIOpen"
              value="201"
              />
          <event
              keywords="cabinet"
              level="win:Informational"
              task="CabFCI"
              opcode="win:Stop"
              message="$(string.Telemetry.CabFCIClose)"
              symbol="TelemetryCabFCIClose"
              template="tPointer"
              value="202"
              />
          <event
              keywords="cabinet"
              level="win:Informational"
              message="$(string.Telemetry.CabPreAllocateStats)"
              symbol="TelemetryCabPreAllocateStats"
              template="tCabPreAllocateStats"
              task="UploaderReportCab"
              opcode="win:Info"
              value="207"
              />
          <!-- /Cabinet Specific events. -->
          <!-- Uploader Specific events. -->
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderManager"
              opcode="win:Start"
              message="$(string.Telemetry.UploaderManagerStart)"
              symbol="TelemetryUploaderManagerStart"
              value="300"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderManager"
              opcode="win:Stop"
              message="$(string.Telemetry.UploaderManagerStop)"
              symbol="TelemetryUploaderManagerStop"
              template="tError"
              value="301"
              />
          <event
              keywords="uploader crashdata"
              level="win:Informational"
              task="UploaderReportUpload"
              opcode="win:Start"
              message="$(string.Telemetry.UploaderReportUploadStart)"
              symbol="TelemetryUploaderReportUploadStart"
              template="tReportOperation"
              value="305"
              />
          <event
              keywords="uploader crashdata"
              level="win:Informational"
              task="UploaderReportUpload"
              opcode="win:Stop"
              message="$(string.Telemetry.UploaderReportUploadStop)"
              symbol="TelemetryUploaderReportUploadStop"
              template="tReportOperationResult"
              value="306"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderReportCab"
              opcode="win:Start"
              message="$(string.Telemetry.UploaderReportCabStart)"
              symbol="TelemetryUploaderReportCabStart"
              template="tReportOperation"
              value="309"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderReportCab"
              opcode="win:Stop"
              message="$(string.Telemetry.UploaderReportCabStop)"
              symbol="TelemetryUploaderReportCabStop"
              template="tReportOperationResult"
              value="310"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderNetwork"
              opcode="win:Start"
              message="$(string.Telemetry.UploaderNetworkStart)"
              symbol="TelemetryUploaderNetworkStart"
              value="311"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderNetwork"
              opcode="win:Stop"
              message="$(string.Telemetry.UploaderNetworkStop)"
              symbol="TelemetryUploaderNetworkStop"
              value="312"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderReportCabArchived"
              opcode="win:Info"
              message="$(string.Telemetry.UploaderCabArchived)"
              symbol="TelemetryUploaderCabArchived"
              template="tReportOperation"
              value="313"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderServer"
              opcode="win:Send"
              symbol="TelemetryUploaderServerRequest"
              template="tUploadServerRequest"
              value="316"
              message="$(string.Telemetry.UploaderServerRequest)"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderServer"
              opcode="win:Receive"
              symbol="TelemetryUploaderServerReply"
              template="tUploadServerReply"
              value="317"
              message="$(string.Telemetry.UploaderServerReply)"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderServer"
              opcode="win:Send"
              message="$(string.Telemetry.UploaderSendingRequest)"
              symbol="TelemetryUploaderSendingRequest"
              template="tUploaderCommand"
              value="318"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderServer"
              opcode="win:Receive"
              message="$(string.Telemetry.UploaderReceivingResponse)"
              symbol="TelemetryUploaderReceivingResponse"
              template="tUploaderCommand"
              value="319"
              />
          <event
              keywords="uploader crashdata"
              level="win:Informational"
              task="UploaderCabReceipt"
              opcode="win:Info"
              message="$(string.Telemetry.UploaderCabReceipt)"
              symbol="TelemetryUploaderCabReceipt"
              template="tUploaderCabReceipt"
              value="320"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderPrepareUploadRequest"
              opcode="win:Start"
              symbol="TelemetryPrepareUploadRequestStart"
              template="tPrepareUploadRequestStart"
              value="321"
              />
          <event
              keywords="uploader"
              level="win:Informational"
              task="UploaderPrepareUploadRequest"
              opcode="win:Stop"
              symbol="TelemetryPrepareUploadRequestStop"
              template="tPrepareUploadRequestStop"
              value="322"
              />
          <!-- /Uploader Specific events. -->
          <!-- OcaProcess Specific events. -->
          <event
              keywords="ocaprocess errors"
              level="win:Error"
              task="Error"
              opcode="OcaDeviceKeyMissing"
              symbol="TelemetryOcaDeviceKeyMissing"
              value="400"
              />
          <event
              keywords="ocaprocess errors"
              level="win:Error"
              task="Error"
              opcode="OcaDeviceValueMissing"
              symbol="TelemetryOcaDeviceValueMissing"
              template="tString"
              value="401"
              />
          <event
              keywords="ocaprocess errors"
              level="win:Error"
              task="Error"
              opcode="OcaDumpFileMissing"
              symbol="TelemetryOcaDumpFileMissing"
              template="tError"
              value="402"
              />
          <event
              keywords="ocaprocess errors"
              level="win:Error"
              task="Error"
              opcode="OcaDumpCorrupt"
              symbol="TelemetryOcaDumpCorrupt"
              template="tError"
              value="403"
              />
          <event
              keywords="ocaprocess"
              level="win:Informational"
              task="OcaWorkHandlerDoWork"
              opcode="win:Start"
              message="$(string.Telemetry.OcaWorkHandlerDoWorkStart)"
              symbol="TelemetryOcaWorkHandlerDoWorkStart"
              value="404"
              />
          <event
              keywords="ocaprocess"
              level="win:Informational"
              task="OcaWorkHandlerDoWork"
              opcode="win:Stop"
              message="$(string.Telemetry.OcaWorkHandlerDoWorkStop)"
              symbol="TelemetryOcaWorkHandlerDoWorkStop"
              template="tError"
              value="405"
              />
          <event
              keywords="ocaprocess"
              level="win:Informational"
              task="OcaWorkHandlerLoadDumpInformation"
              opcode="win:Start"
              message="$(string.Telemetry.OcaWorkHandlerLoadDumpInformationStart)"
              symbol="TelemetryOcaWorkHandlerLoadDumpInformationStart"
              value="406"
              />
          <event
              keywords="ocaprocess"
              level="win:Informational"
              task="OcaWorkHandlerLoadDumpInformation"
              opcode="win:Stop"
              message="$(string.Telemetry.OcaWorkHandlerLoadDumpInformationStop)"
              symbol="TelemetryOcaWorkHandlerLoadDumpInformationStop"
              template="tError"
              value="407"
              />
          <event
              keywords="ocaprocess"
              level="win:Informational"
              task="OcaWorkHandlerProcessDump"
              opcode="win:Start"
              message="$(string.Telemetry.OcaWorkHandlerProcessDumpStart)"
              symbol="TelemetryOcaWorkHandlerProcessDumpStart"
              value="408"
              />
          <event
              keywords="ocaprocess"
              level="win:Informational"
              task="OcaWorkHandlerProcessDump"
              opcode="win:Stop"
              message="$(string.Telemetry.OcaWorkHandlerProcessDumpStop)"
              symbol="TelemetryOcaWorkHandlerProcessDumpStop"
              template="tError"
              value="409"
              />
          <!-- /OcaProcess Specific events. -->
          <!-- ReportManager Specific events. -->
          <event
              keywords="reportmanager crashdata"
              level="win:Informational"
              task="ReportManagerReportPublish"
              opcode="win:Info"
              message="$(string.Telemetry.ReportManagerReportPublish)"
              symbol="TelemetryReportManagerReportPublish"
              template="tReportOperation"
              value="501"
              />
          <event
              keywords="reportmanager crashdata"
              level="win:Informational"
              task="ReportManagerReportDelete"
              opcode="win:Info"
              message="$(string.Telemetry.ReportManagerReportDelete)"
              symbol="TelemetryReportManagerReportDelete"
              template="tReportOperation"
              value="502"
              />
          <event
              keywords="reportmanager"
              level="win:Informational"
              task="ReportManagerReportDeletionReason"
              opcode="win:Info"
              symbol="TelemetryReportManagerReportDeletionReason"
              template="tReportDeleteReason"
              value="503"
              />
          <event
              keywords="reportmanager"
              level="win:Warning"
              task="ReportManagerStorageQuotaDeletion"
              opcode="win:Info"
              symbol="TelemetryReportManagerStorageQuotaDeletion"
              template="tStorageQuotaDeletion"
              value="504"
              />
          <event
              keywords="reportmanager"
              level="win:Warning"
              task="ReportManagerStorageQuotaDeletionCommit"
              opcode="win:Info"
              symbol="TelemetryReportManagerStorageQuotaDeletionCommit"
              template="tStorageQuotaDeletion"
              value="505"
              />
          <event
              keywords="reportmanager errors"
              level="win:Error"
              task="ReportManagerLinkOrRename"
              opcode="Error"
              symbol="TelemetryReportManagerLinkOrRenameError"
              template="tReportLinkOrManagerRename"
              value="506"
              />
          <event
              keywords="reportmanager"
              level="win:Informational"
              task="ReportManagerReportRepublish"
              opcode="win:Info"
              message="$(string.Telemetry.ReportManagerReportRePublish)"
              symbol="TelemetryReportManagerReportRePublish"
              template="tReportOperation"
              value="510"
              />
          <event
              keywords="reportmanager"
              level="win:Informational"
              task="ReportManagerReportRepublish"
              opcode="Abort"
              message="$(string.Telemetry.ReportManagerMalfunctionReportPublish)"
              symbol="TelemetryReportManagerMalfunctionReportPublish"
              template="tReportOperation"
              value="511"
              />
          <event
              keywords="reportmanager errors"
              level="win:Warning"
              task="ReportManagerReadMetadata"
              opcode="NotFound"
              symbol="TelemetryReportManagerMetadataNameNotFound"
              template="tString"
              value="512"
              />
          <event
              keywords="reportmanager errors crashdata"
              level="win:Warning"
              task="ReportManagerLostReport"
              opcode="NotFound"
              message="$(string.Telemetry.ReportManagerLostReport)"
              symbol="TelemetryReportManagerLostReport"
              template="tReportLost"
              value="513"
              />
          <!-- /ReportManager Specific events. -->
          <!-- Dump-collection-specific specific events. -->
          <event
              keywords="errorhandlingext"
              level="win:Informational"
              message="$(string.Telemetry.ErrorHandlingExtBasepReportFault)"
              symbol="TelemetryErrorHandlingExtBasepReportFault"
              template="tErrorHandlingExtBasepTemplate"
              value="601"
              />
          <event
              keywords="errorhandlingext"
              level="win:Error"
              message="$(string.Telemetry.ErrorHandlingExtServicesExe)"
              symbol="TelemetryErrorHandlingExtServicesExe"
              template="tDword"
              value="602"
              />
          <event
              keywords="errorhandlingext"
              level="win:Informational"
              task="UserDumpCollection"
              opcode="win:Start"
              symbol="TelemetryUserDumpCollectionStart"
              value="603"
              template="tUserDumpCollectionStart"
              />
          <event
              keywords="errorhandlingext"
              level="win:Informational"
              task="UserDumpCollection"
              opcode="win:Stop"
              symbol="TelemetryUserDumpCollectionStop"
              value="604"
              template="tUserDumpCollectionStop"
              />
          <event
              keywords="errorhandlingext"
              level="win:Warning"
              task="ReportException"
              opcode="win:Info"
              message="$(string.Telemetry.ErrorHandlingExtTelReportException)"
              symbol="TelemetryErrorHandlingExtTelReportException"
              template="tErrorHandlingExtTelReportExceptionTemplate"
              value="605"
              />
          <event
              keywords="errorhandlingext"
              level="win:Informational"
              message="$(string.Telemetry.ErrorHandlingExtReturn)"
              symbol="TelemetryErrorHandlingExtReturn"
              template="tErrorHandlingExtReturn"
              value="606"
              />
          <event
              keywords="errorhandlingext"
              level="win:Informational"
              task="SingleDumpCollection"
              opcode="win:Start"
              symbol="TelemetrySingleDumpCollectionStart"
              value="607"
              template="tSingleDumpCollectionStart"
              />
          <event
              keywords="errorhandlingext"
              level="win:Informational"
              task="SingleDumpCollection"
              opcode="win:Stop"
              symbol="TelemetrySingleDumpCollectionStop"
              value="608"
              template="tSingleDumpCollectionStop"
              />
	  <event
              keywords="errorhandlingext"
              level="win:Informational"
              task="EtwLogsCollection"
              opcode="win:Start"
              symbol="TelemetryEtwLogsCollectionStart"
              value="609"
              template="tEtwLogsCollectionStart"
              />
          <event
              keywords="errorhandlingext"
              level="win:Informational"
              task="EtwLogsCollection"
              opcode="win:Stop"
              symbol="TelemetryEtwLogsCollectionStop"
              value="610"
              template="tEtwLogsCollectionStop"
              />
          <event
              keywords="errorhandlingext watsonbucket"
              level="win:Informational"
              message="$(string.Telemetry.LogWatsonBucketParameters)"
              symbol="TelemetryLogWatsonBucketParameters"
              template="tString"
              value="611"
              />
          <event
              keywords="errorhandlingext watsonbucket"
              level="win:Informational"
              message="$(string.Telemetry.LiveDumpEventParameters)"
              symbol="TelemetryLogLiveDumpEventParameters"
              template="tLiveDumpEventTemplate"
              value="612"
              />
          <event
              keywords="errorhandlingext watsonbucket"
              level="win:Informational"
              message="$(string.Telemetry.KernelBugCheckParameters)"
              symbol="TelemetryLogKernelBugCheckParameters"
              template="tKernelBugCheckParametersTemplate"
              value="613"
              />
          <!-- /ErrorHandlingExt Specific events. -->
          <!-- Protocol Specific events. -->
          <event
              keywords="protocol"
              level="win:Informational"
              message="$(string.Telemetry.ProtocolThrottled)"
              task="ReportThrottled"
              opcode="win:Info"
              symbol="TelemetryProtocolThrottled"
              template="tThrottleNamespace"
              value="701"
              />
          <event
              keywords="protocol"
              level="win:Informational"
              task="NewThrottleRule"
              opcode="win:Info"
              message="$(string.Telemetry.ProtocolNewThrottleRule)"
              symbol="TelemetryProtocolNewThrottleRule"
              template="tThrottleNamespaceTime"
              value="702"
              />
          <!-- /Protocol Specific events. -->
          <!-- SQM Specific events. -->
          <event
              keywords="sqm"
              level="win:Informational"
              task="SqmConsolidator"
              opcode="win:Start"
              message="$(string.Telemetry.SqmConsolidatorStart)"
              symbol="TelemetrySqmConsolidatorStart"
              value="801"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              task="SqmConsolidator"
              opcode="win:Stop"
              message="$(string.Telemetry.SqmConsolidatorStop)"
              symbol="TelemetrySqmConsolidatorStop"
              template="tError"
              value="802"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              message="$(string.Telemetry.SqmConsolidatorPersistSession)"
              symbol="TelemetrySqmConsolidatorPersistSession"
              template="tGuid"
              value="803"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              message="$(string.Telemetry.SqmConsolidatorRecycleSession)"
              symbol="TelemetrySqmConsolidatorRecycleSession"
              template="tGuid"
              value="804"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              message="$(string.Telemetry.SqmConsolidatorSessionTimeout)"
              symbol="TelemetrySqmConsolidatorSessionTimeout"
              template="tGuid"
              value="806"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              message="$(string.Telemetry.SqmConsolidatorSessionFull)"
              symbol="TelemetrySqmConsolidatorSessionFull"
              template="tGuid"
              value="807"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              message="$(string.Telemetry.SqmConsolidatorReportPublish)"
              symbol="TelemetrySqmConsolidatorReportPublish"
              template="tSqmConsolidatorReportPublish"
              value="808"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              message="$(string.Telemetry.SqmConsolidatorCrowdSourcePublish)"
              symbol="TelemetrySqmConsolidatorCrowdSourcePublish"
              template="tSqmConsolidatorCrowdSourcePublish"
              value="809"
              />
          <event
              keywords="sqm"
              level="win:Informational"
              message="$(string.Telemetry.SqmDataWarning)"
              symbol="TelemetrySqmDataWarning"
              template="tError"
              value="810"
              />
          <event
              keywords="isv"
              level="win:Informational"
              task="IsvDumpCollection"
              opcode="Publish"
              symbol="TelemetryIsvDumpPublish"
              template="tTelIsvDumpPublish"
              value="900"
              />
          <!-- /SQM Specific events. -->
        </events>
      </provider>
    </events>
  </instrumentation>
  <!-- Localizable strings for the Telemetry Events -->
  <localization>
    <resources culture="en-US">
      <stringTable>
        <!-- Keywords -->
        <string
            id="errors.KeywordMessage"
            value="Errors"
            />
        <string
            id="cabinet.KeywordMessage"
            value="Cabinet"
            />
        <string
            id="uploader.KeywordMessage"
            value="Uploader"
            />
        <string
            id="ocaprocess.KeywordMessage"
            value="OcaProcess"
            />
        <string
            id="reportmanager.KeywordMessage"
            value="ReportManager"
            />
        <string
            id="errorhandlingext.KeywordMessage"
            value="ErrorHandlingExt"
            />
        <string
            id="protocol.KeywordMessage"
            value="Protocol"
            />
        <string
            id="sqm.KeywordMessage"
            value="SQM"
            />
        <string
            id="crashdata.KeywordMessage"
            value="CRASHDATA"
            />
        <string
            id="scheduler.KeywordMessage"
            value="Scheduler"
            />
        <string
            id="telsvc.KeywordMessage"
            value="telsvc"
            />
        <string
            id="teltrace.KeywordMessage"
            value="trace"
            />
        <string
            id="watsonbucket.KeywordMessage"
            value="watsonbucket"
            />
        <!-- /Keywords -->
        <string
            id="Telemetry.Error"
            value="Error HR: %1"
            />
        <string
            id="Telemetry.Warning"
            value="Warning HR: %1"
            />
        <string
            id="Telemetry.ErrorMessage"
            value="Error HR: %1 from %2"
            />
        <string
            id="Telemetry.WarningMessage"
            value="Warning HR: %1 from %2"
            />
        <string
            id="Telemetry.RemoteError"
            value="Warning HR: %1 received over ALPC"
            />
        <string
            id="Telemetry.TelSvcIdleShutdownBegin"
            value="Beginning telsvc idle shutdown"
            />
        <string
            id="Telemetry.TelSvcIdleShutdownAbort"
            value="Aborting telsvc idle shutdown"
            />
        <string
            id="Telemetry.TelSvcIdleShutdownCommit"
            value="Committing to telsvc idle shutdown"
            />
        <!-- Cabinet Specific events. -->
        <string
            id="Telemetry.CabStreamAdd"
            value="Added stream: name = %1, stream = %2"
            />
        <string
            id="Telemetry.CabFCIOpen"
            value="FCIOpen: Opening %1, cab name = %2, stream = %3"
            />
        <string
            id="Telemetry.CabFCIClose"
            value="FCIClose: stream @%1"
            />
        <string
            id="Telemetry.CabAbort"
            value="Aboring cab decompression, cancel requested"
            />
        <string
            id="Telemetry.CabExtractingFile"
            value="Extracting file: %1"
            />
        <string
            id="Telemetry.CabExtract"
            value="Start extracting: %1\\%2"
            />
        <string
            id="Telemetry.CabPreAllocateStats"
            value="Cab preallocating: %1 bytes; Cab uncompressed size: %2 bytes; Free Disk Space: %3 bytes"
            />
        <!-- /Cabinet Specific events. -->
        <!-- Uploader Specific events. -->
        <string
            id="Telemetry.UploaderManagerStart"
            value="Uploader manager started"
            />
        <string
            id="Telemetry.UploaderManagerStop"
            value="Uploader manager stop (hresult: %1)"
            />
        <string
            id="Telemetry.UploaderReportUploadStart"
            value="Uploader report upload start: %1 type: %2"
            />
        <string
            id="Telemetry.UploaderReportUploadStop"
            value="Uploader report upload stop: %1 hr: %2"
            />
        <string
            id="Telemetry.UploaderReportCabStart"
            value="Uploader report cab start: %1"
            />
        <string
            id="Telemetry.UploaderReportCabStop"
            value="Uploader report cab stop: %1 hr: %2"
            />
        <string
            id="Telemetry.UploaderSendingRequest"
            value="Uploader sending request (report %1): %2"
            />
        <string
            id="Telemetry.UploaderReceivingResponse"
            value="Uploader receiving response (report %1): %2"
            />
        <string
            id="Telemetry.UploaderReportUploadFail"
            value="Uploader report upload failed: %1"
            />
        <string
            id="Telemetry.UploaderNetworkStart"
            value="Uploader network started"
            />
        <string
            id="Telemetry.UploaderNetworkStop"
            value="Uploader network stop"
            />
        <string
            id="Telemetry.UploaderCabArchived"
            value="Uploader Cab (type: %1) archived: %2"
            />
        <string
            id="Telemetry.UploaderCabReceipt"
            value="Uploader cab received (report %1): %2"
            />
        <string
            id="Telemetry.UploaderServerRequest"
            value="Sending XML to server: %1"
            />
        <string
            id="Telemetry.UploaderServerReply"
            value="Received XML from server. Status code: %1 XML: %2"
            />
        <!-- /Uploader Specific events. -->
        <!-- OcaWorkHandler Specific events. -->
        <string
            id="Telemetry.OcaWorkHandlerDoWorkStart"
            value="Oca WorkHandler DoWork start"
            />
        <string
            id="Telemetry.OcaWorkHandlerDoWorkStop"
            value="Oca WorkHandler DoWork stop: %1"
            />
        <string
            id="Telemetry.OcaWorkHandlerLoadDumpInformationStart"
            value="Oca WorkHandler LoadDumpInformation start"
            />
        <string
            id="Telemetry.OcaWorkHandlerLoadDumpInformationStop"
            value="Oca WorkHandler LoadDumpInformation stop: %1"
            />
        <string
            id="Telemetry.OcaWorkHandlerProcessDumpStart"
            value="Oca WorkHandler ProcessDump start"
            />
        <string
            id="Telemetry.OcaWorkHandlerProcessDumpStop"
            value="Oca WorkHandler ProcessDump stop: %1"
            />
        <!-- /OcaWorkHandler Specific events. -->
        <!-- ReportManager Specific events. -->
        <string
            id="Telemetry.ReportManagerReportPublish"
            value="Report manager published report: %1 %3"
            />
        <string
            id="Telemetry.ReportManagerReportDelete"
            value="Report manager deleted report: %1 %3"
            />
        <string
            id="Telemetry.ReportManagerReportStateChange"
            value="Report manager changed report state: %1 (from %2 to %3)"
            />
        <string
            id="Telemetry.ReportManagerReportAddMeta"
            value="Report manager added report meta: %1 (key: %3, value: %4)"
            />
        <string
            id="Telemetry.ReportManagerReportAddFile"
            value="Report manager added report file (report:%1 rtype:%2 src:%3 dst:%4)"
            />
        <string
            id="Telemetry.ReportManagerStorageQuotaManagementStart"
            value="Report Manager storage quota management start"
            />
        <string
            id="Telemetry.ReportManagerStorageQuotaManagementStop"
            value="Report Manager storage quota management stop: %1"
            />
        <string
            id="Telemetry.ReportManagerReportDeletedToCreateSpace"
            value="Report Deleted - New Report Size: %1, Deleted Report Guid: %2, Report Size: %3, Quota Size: %4, Used Space: %5"
            />
        <string
            id="Telemetry.ReportManagerReportRePublish"
            value="Report manager republished report: %1 %3"
            />
        <string
            id="Telemetry.ReportManagerMalfunctionReportPublish"
            value="Report manager republished report: %1 %3"
            />
        <string
            id="Telemetry.ReportManagerLostReport"
            value="Report manager lost report with error: %1 Transaction GUID: %2 Report GUID: %3 Exception Code: %4 CrasshingProcessId: %5 CrashingThreadId: %6 DumpFilenameSuffix: %7 DumpType: %8 ExceptionIsValid: %9 ContextIsValid: %10 AddToExistingReport: %11 AddHangDetails: %12 Fatal: %13 InhibitEtwLogCollection: %14"
            />
        <!-- /ReportManager Specific events. -->
        <!-- ErrorHandlingExt Specific events. -->
        <string
            id="Telemetry.ErrorHandlingExtBasepReportFault"
            value="ErrorHandlingExt::BasepReportFault pid %1 (command line: %2)"
            />
        <string
            id="Telemetry.ErrorHandlingExtTelReportException"
            value="ErrorHandlingExt::TelReportException pid %1 tid %2 exceptionCode %3  exceptionAddress %4 (processImageName: %5 command line: %6)"
            />
        <string
            id="Telemetry.ErrorHandlingExtServicesExe"
            value="Generic report in services.exe FAILED: %1"
            />
        <string
            id="Telemetry.ErrorHandlingExtReturn"
            value="BasepReportFault action: %1"
            />
        <string
            id="Telemetry.LogWatsonBucketParameters"
            value="Watson Bucket Parameters: %1"
            />
        <string
            id="Telemetry.LiveDumpEventParameters"
            value="WerLiveKernelCreateReport: LiveDump EventType: %1 Throttle State: %2 Return Status: %3"
            />
        <string
            id="Telemetry.KernelBugCheckParameters"
            value="Kernel BugCheck Parameters: DumpType=%1 BugCheckCode=%2 Param1=%3 Param2=%4 Param3=%5 Param4=%6 LiveDump=%7 ReportGuid: %8"
            />
        <!-- /ErrorHandlingExt Specific events. -->
        <!-- Protocol Specific events. -->
        <string
            id="Telemetry.ProtocolThrottled"
            value="Report throttled (%1; %2; %3; %4; %5)"
            />
        <string
            id="Telemetry.ProtocolNewThrottleRule"
            value="New throttling rule (%1; %2; %3; %4; %5; %6)"
            />
        <!-- /Protocol Specific events. -->
        <!-- SQM Specific events. -->
        <string
            id="Telemetry.SqmConsolidatorStart"
            value="SQM Consolidator Started"
            />
        <string
            id="Telemetry.SqmConsolidatorStop"
            value="SQM Consolidator Stopped (hresult: %1)"
            />
        <string
            id="Telemetry.SqmConsolidatorPersistSession"
            value="SQM Consolidator persisted session: %1"
            />
        <string
            id="Telemetry.SqmConsolidatorRecycleSession"
            value="SQM Consolidator recycled session: %1"
            />
        <string
            id="Telemetry.SqmConsolidatorSessionTimeout"
            value="SQM Consolidator session timed out: %1"
            />
        <string
            id="Telemetry.SqmConsolidatorSessionFull"
            value="SQM Consolidator session full: %1"
            />
        <string
            id="Telemetry.SqmConsolidatorReportPublish"
            value="SQM Consolidator published session %1 as report %2"
            />
        <string
            id="Telemetry.SqmConsolidatorCrowdSourcePublish"
            value="SQM Consolidator published crowd source data (guid: %1, hr: %2)"
            />
        <string
            id="Telemetry.SqmDataWarning"
            value="SQM Consolidator encountered incorrect ETW data (hr: %1)"
            />
        <!-- /SQM Specific events. -->
      </stringTable>
    </resources>
  </localization>
</instrumentationManifest>
