<?xml version="1.0" encoding="UTF-16"?>
<instrumentationManifest xsi:schemaLocation="http://schemas.microsoft.com/win/2004/08/events eventman.xsd" xmlns="http://schemas.microsoft.com/win/2004/08/events" xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:trace="http://schemas.microsoft.com/win/2004/08/events/trace">
	<instrumentation>
		<events>
			<provider name="Microsoft-WindowsPhone-ImgUpdLogger" guid="{C5F76A67-74E9-4AAF-8291-BC39D906A784}" symbol="IMGUPDLOGGER_PROVIDER_GUID" resourceFileName="ImgUpdEtwLogger.dll" messageFileName="ImgUpdEtwLogger.dll" message="$(string.Provider.Name)">
				<tasks>          
					<task name="TOTAL_STAGING_TIME" value="1"/>
					<task name="TOTAL_COMMIT_TIME" value="2"/>
					<task name="REGISTRY_SETUP_TIME" value="3"/>
					<task name="PARTITION_COMMIT_TIME" value="4"/>
					<task name="ACL_APPLICATION_TIME" value="5"/>
					<task name="STAGED_DIR_SIZE" value="6"/>
				</tasks>
				<events>
					<event symbol="Info_IUValidator_BeginValidation" value="0" version="0" level="win:Informational" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.0.message)">
					</event>
					<event symbol="Info_IUValidator_RuleDescription" value="1" version="0" level="win:Informational" template="StringString" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1.message)">
					</event>
					<event symbol="Error_IUValidator_NotInitialized" value="3" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.3.message)">
					</event>
					<event symbol="Error_IUValidator_GetFilesFailed" value="5" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5.message)">
					</event>
					<event symbol="Debug_IUValidator_PartitionCount" value="6" version="0" level="win:Verbose" template="StringUInt64" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.6.message)">
					</event>
					<event symbol="Error_IUValidator_FileCollision" value="7" version="0" level="win:Error" template="StringStringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.7.message)">
					</event>
					<event symbol="Error_IUValidator_InvalidFileAction" value="8" version="0" level="win:Error" template="StringStringStringInt32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.8.message)">
					</event>
					<event symbol="Error_IUValidator_OpenVolumeFailed" value="9" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.9.message)">
					</event>
					<event symbol="Error_IUValidator_InvalidBinaryPkg" value="10" version="0" level="win:Error" template="3String4Int32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.10.message)">
					</event>
					<event symbol="Error_IUValidator_InvalidUpdateOSPkg" value="11" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.11.message)">
					</event>
					<event symbol="Info_IUValidator_DumpPkgOrder" value="12" version="1" level="win:Informational" template="String" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.12.message)">
					</event>
					<event symbol="Error_PKRForBinaryPartition" value="13" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.13.message)">
					</event>
					<event symbol="Error_IUValidator_PKRHigherVersionInstalled" value="14" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.14.message)">
					</event>
					<event symbol="Error_IUValidator_PkgAlreadyInstalled" value="15" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.15.message)">
					</event>
					<event symbol="Error_IUValidator_CanonicalHigherVersionInstalled" value="16" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.16.message)">
					</event>
					<event symbol="Error_IUValidator_BasePkgNotInstalled" value="17" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.17.message)">
					</event>
					<event symbol="Error_IUValidator_SrcVersionMismatch" value="18" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.18.message)">
					</event>
					<event symbol="Error_IUValidator_PkgAlreadyInstalled2" value="19" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.19.message)">
					</event>
					<event symbol="Error_IUValidator_DiffHigherVersionInstalled" value="20" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.20.message)">
					</event>
					<event symbol="Error_IUValidator_InvalidPkgType" value="21" version="0" level="win:Error" template="StringStringInt32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.21.message)">
					</event>
					<event symbol="Error_IUValidator_DupPkg" value="22" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.22.message)">
					</event>
					<event symbol="Error_IUValidator_MultiplePaths" value="23" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.23.message)">
					</event>
					<event symbol="Error_IUValidator_NoPath" value="24" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.24.message)">
					</event>
					<event symbol="Error_IUValidator_PossibleMultiplePath" value="25" version="0" level="win:Error" template="5StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.25.message)">
					</event>
					<event symbol="Error_IUValidator_SrcVersionMismatch2" value="26" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.26.message)">
					</event>
					<event symbol="Error_IUValidator_SrcTgtVersionMismatch" value="27" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.27.message)">
					</event>
					<event symbol="Error_IUValidator_NoPathToTgtVersion" value="28" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.28.message)">
					</event>
					<event symbol="Error_IUValidator_OpenKeyFailed" value="29" version="0" level="win:Error" template="StringStringError" keywords="warning " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.29.message)">
					</event>
					<event symbol="Warning_IUValidator_EnumKeyFailed" value="30" version="0" level="win:Warning" template="StringStringError" keywords="warning " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.30.message)">
					</event>
					<event symbol="Error_IUValidator_TargetNotApplicable" value="31" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.31.message)">
					</event>
					<event symbol="Error_IUValidator_EngineNotInitialized" value="32" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.32.message)">
					</event>
					<event symbol="Debug_IUValidator_RuleExecTime" value="33" version="0" level="win:Verbose" template="UInt32UInt32" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.33.message)">
					</event>
					<event symbol="Info_IUValidator_EndValidation" value="34" version="0" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.34.message)">
					</event>
					<event symbol="Error_IUValidator_AuthFailed" value="36" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.36.message)">
					</event>
					<event symbol="Error_IUValidator_LowDiskSpace" value="37" version="0" level="win:Error" template="StringStringInt64Int64Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.37.message)">
					</event>
					<event symbol="Error_IUValidator_UnexpectedFileAction" value="38" version="0" level="win:Error" template="StringInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.38.message)">
					</event>
					<event symbol="Debug_IUValidator_CommitSize" value="39" version="0" level="win:Verbose" template="StringStringInt64" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.39.message)">
					</event>
					<event symbol="Error_IUValidator_PkgTargetsWrongCpu" value="40" version="0" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.40.message)">
					</event>
					<event symbol="Info_IUCore_ExtractingPkg" value="500" version="0" level="win:Informational" template="String" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.500.message)">
					</event>
					<event symbol="Error_IUCore_NullPartition" value="501" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.501.message)">
					</event>
					<event symbol="Error_IUCore_InvalidPkgType" value="503" version="0" level="win:Error" template="StringStringInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.503.message)">
					</event>
					<event symbol="Error_IUCore_PopulateFileInfoFailed" value="504" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.504.message)">
					</event>
					<event symbol="Debug_IUCore_BaseDsmNotFound" value="505" version="0" level="win:Verbose" template="StringStringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.505.message)">
					</event>
					<event symbol="Error_IUCore_PopulateFileInfoDeletesFailed" value="506" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.506.message)">
					</event>
					<event symbol="Error_IUCore_UnexpectedFileType" value="508" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.508.message)">
					</event>
					<event symbol="Error_IUCore_FileEntryNotFound" value="509" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.509.message)">
					</event>
					<event symbol="Error_IUCore_InvalidDiffType" value="510" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.510.message)">
					</event>
					<event symbol="Error_ApiFailure" value="5000" version="0" level="win:Error" template="APIFailure" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5000.message)">
					</event>
					<event symbol="Error_NullValue" value="5001" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5001.message)">
					</event>
					<event symbol="Error_ApiFailureString" value="5002" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5002.message)">
					</event>
					<event symbol="Error_ApiFailureInt32" value="5003" version="0" level="win:Error" template="StringStringStringInt32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5003.message)">
					</event>
					<event symbol="Error_InvalidDataString" value="5004" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5004.message)">
					</event>
					<event symbol="Error_ApiFailureStringString" value="5005" version="0" level="win:Error" template="5StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5005.message)">
					</event>
					<event symbol="Info_APIEntry" value="5006" version="0" level="win:Informational" template="APIEntry" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5006.message)">
					</event>
					<event symbol="Info_APIExit" value="5007" version="0" level="win:Informational" template="APIExit" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.5007.message)">
					</event>
					<event symbol="Info_LogInfo" value="5008" version="0" level="win:Informational" template="String" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.12.message)">
					</event>
					<event symbol="Error_IUCore_PartSizeCalcFailed" value="511" version="0" level="win:Error" template="StringStringUInt64Int32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.511.message)">
					</event>
					<event symbol="Error_IUCore_FreeSpaceCalcFailed" value="512" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.512.message)">
					</event>
					<event symbol="Error_IUCore_StagingFileNotFound" value="513" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.513.message)">
					</event>
					<event symbol="Error_IUCore_InvalidHiveIndex" value="514" version="0" level="win:Error" template="StringInt32Int32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.514.message)">
					</event>
					<event symbol="Error_IUCore_ApplyDeltaFailed" value="516" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.516.message)">
					</event>
					<event symbol="Event_Error_InvalidFileInfoAction" value="518" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.518.message)">
					</event>
					<event symbol="Info_IUCore_CommitPartition" value="519" version="0" level="win:Informational" template="String" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.519.message)">
					</event>
					<event symbol="Debug_IUCore_CommitFile" value="520" version="0" level="win:Verbose" template="String" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.520.message)">
					</event>
					<event symbol="Info_IUCore_CommitPartitionEnd" value="521" version="0" level="win:Informational" template="String" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.521.message)">
					</event>
					<event symbol="Info_IUCore_CommitHive" value="522" version="0" level="win:Informational" template="String" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.522.message)">
					</event>
					<event symbol="Error_IUCore_CommitHiveFailed" value="523" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.523.message)">
					</event>
					<event symbol="Debug_IUCore_SkipProvision" value="524" version="0" level="win:Verbose" template="StringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.524.message)">
					</event>
					<event symbol="Debug_IUCore_SkipAclCommit" value="525" version="0" level="win:Verbose" template="String" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.525.message)">
					</event>
					<event symbol="Debug_IUCore_UserHiveNotFound" value="526" version="0" level="win:Verbose" template="StringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.526.message)">
					</event>
					<event symbol="Error_IUCore_HiveMoveFailed" value="527" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.527.message)">
					</event>
					<event symbol="Error_IUCore_CannotGetUserProfileKeys" value="528" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.528.message)">
					</event>
					<event symbol="Error_IUCore_DSMCopyFailed" value="529" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.529.message)">
					</event>
					<event symbol="Info_IUCore_Flush" value="530" version="0" template="String" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.530.message)">
					</event>
					<event symbol="Error_IUCore_NullStorageHandle" value="531" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.531.message)">
					</event>
					<event symbol="Warning_IUCore_DecryptModuleDeinitFailed" value="532" version="0" level="win:Warning" template="StringError" keywords="warning " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.532.message)">
					</event>
					<event symbol="Error_IUCore_StoreNotInitialized" value="533" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.533.message)">
					</event>
					<event symbol="Warning_IUCore_WimFlushFailed" value="536" version="0" level="win:Warning" template="StringStringError" keywords="warning " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.536.message)">
					</event>
					<event symbol="Error_IUCore_WimCommitFailed" value="537" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.537.message)">
					</event>
					<event symbol="Debug_IUCore_WimCopy" value="538" version="0" level="win:Verbose" template="StringStringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.538.message)">
					</event>
					<event symbol="Error_IUCore_WimCopyFailed" value="539" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.539.message)">
					</event>
					<event symbol="Info_IUCore_Perf" value="540" version="0" level="win:Informational" template="Int32Int32" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.540.message)">
					</event>
					<event symbol="Error_IUCore_WimMountFailed" value="541" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.541.message)">
					</event>
					<event symbol="Error_IUCore_RenameFileFailed" value="543" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.543.message)">
					</event>
					<event symbol="Error_IUCore_ZeroSectorSize" value="544" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.544.message)">
					</event>
					<event symbol="Error_IUCore_StagingFileOpenFailed" value="545" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.545.message)">
					</event>
					<event symbol="Error_IUCore_BufAllocFailed" value="546" version="0" level="win:Error" template="StringInt32StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.546.message)">
					</event>
					<event symbol="Error_ReadBinaryPartitionFailed" value="547" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.547.message)">
					</event>
					<event symbol="Error_IUCore_BinaryDecryptFailed" value="548" version="0" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.548.message)">
					</event>
					<event symbol="Error_IUCore_InvalidBufSize" value="549" version="0" level="win:Error" template="StringInt32Int32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.549.message)">
					</event>
					<event symbol="Error_IUCore_PartitionFileTooLarge" value="550" version="0" level="win:Error" template="StringInt32UInt64String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.550.message)">
					</event>
					<event symbol="Error_IUCore_PartitionWriteFailed" value="551" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.551.message)">
					</event>
					<event symbol="Warning_IUCore_UnrecognizedXmlElement" value="552" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.552.message)">
					</event>
					<event symbol="Error_IUCore_UpdateInputReadFailed" value="553" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.553.message)">
					</event>
					<event symbol="Error_IUCore_ErrorSettingUpdateState" value="554" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.554.message)">
					</event>
					<event symbol="Warning_IUCore_InvalidNode" value="555" version="0" level="win:Warning" template="StringStringStringString" keywords="warning " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.555.message)">
					</event>
					<event symbol="Error_IUCore_OutputXmlReadFailed" value="556" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.556.message)">
					</event>
					<event symbol="Error_IUCore_InvalidUpdateState" value="558" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.558.message)">
					</event>
					<event symbol="Error_IUCore_HistoryXmlReadFailed" value="559" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.559.message)">
					</event>
					<event symbol="Error_IUCore_PkgFileNotFound" value="560" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.560.message)">
					</event>
					<event symbol="Error_IUCore_InvalidFileAction" value="561" version="0" level="win:Error" template="StringStringStringInt32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.561.message)">
					</event>
					<event symbol="Error_IUCore_InvalidCpu" value="562" version="0" level="win:Error" template="StringInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.562.message)">
					</event>
					<event symbol="Error_IUCore_FileOrderCalcFailed" value="563" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.563.message)">
					</event>
					<event symbol="Debug_IUCore_Stomp" value="564" version="0" level="win:Verbose" template="StringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.564.message)">
					</event>
					<event symbol="Error_IUCore_BinaryDecryptQueryFeaturesFailed" value="565" version="0" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.565.message)">
					</event>
					<event symbol="Warning_PkgCommon_InvalidNode" value="800" version="0" level="win:Warning" template="StringStringString" keywords="warning " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.800.message)">
					</event>
					<event symbol="Error_PkgCommon_DDSMReadFailed" value="801" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.801.message)">
					</event>
					<event symbol="Error_PkgCommon_PkgValidateFailed" value="802" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.802.message)">
					</event>
					<event symbol="Error_PkgCommon_StrToBinFailed" value="803" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.803.message)">
					</event>
					<event symbol="Error_PkgCommon_MultipleTgtDDSMEntry" value="804" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.804.message)">
					</event>
					<event symbol="Error_PkgCommon_DsmDupEntry" value="805" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.805.message)">
					</event>
					<event symbol="Error_PkgCommon_EmptyDDSM" value="806" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.806.message)">
					</event>
					<event symbol="Error_PkgCommon_InvalidSrcVersion" value="807" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.807.message)">
					</event>
					<event symbol="Error_PkgCommon_SrcVersionNotSet" value="808" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.808.message)">
					</event>
					<event symbol="Error_PkgCommon_SrcDsmHashNotSet" value="809" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.809.message)">
					</event>
					<event symbol="Error_PkgCommon_InvalidFileCount" value="810" version="0" level="win:Error" template="StringStringInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.810.message)">
					</event>
					<event symbol="Error_PkgCommon_TgtDsmNotFound" value="811" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.811.message)">
					</event>
					<event symbol="Error_PkgCommon_DsmReadFailed" value="812" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.812.message)">
					</event>
					<event symbol="Error_PkgCommon_ExtractDsmFailed" value="814" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.814.message)">
					</event>
					<event symbol="Error_PkgCommon_DsmNotFound" value="815" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.815.message)">
					</event>
					<event symbol="Error_PkgCommon_PkgInvalid" value="816" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.816.message)">
					</event>
					<event symbol="Error_PkgCommon_CabExtractFailed" value="817" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.817.message)">
					</event>
					<event symbol="Error_PkgCommon_InvalidPkgType" value="818" version="0" level="win:Error" template="StringStringInt32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.818.message)">
					</event>
					<event symbol="Error_PkgCommon_RenameFailed" value="819" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.819.message)">
					</event>
					<event symbol="Error_PkgCommon_FileExtractFailed" value="820" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.820.message)">
					</event>
					<event symbol="Error_PkgCommon_NullDDSM" value="821" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.821.message)">
					</event>
					<event symbol="Error_PkgCommon_InconsistentPkgNames" value="822" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.822.message)">
					</event>
					<event symbol="Error_PkgCommon_InvalidDiffPkg" value="823" version="0" level="win:Error" template="StringStringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.823.message)">
					</event>
					<event symbol="Error_PkgCommon_VerifyHashFailed" value="824" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.824.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidRegFilePath" value="1000" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1000.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidOutputPath" value="1001" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1001.message)">
					</event>
					<event symbol="Error_RegistryApi_EmptyRegRga" value="1002" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1002.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidHiveNumber" value="1003" version="0" level="win:Error" template="StringUInt32UInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1003.message)">
					</event>
					<event symbol="Warning_RegistryApi_FailToCloseHive" value="1005" version="0" level="win:Warning" template="StringError" keywords="warning " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1005.message)">
					</event>
					<event symbol="Debug_RegistryApi_ProcessRegFile" value="1006" version="0" level="win:Verbose" template="StringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1006.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidRegEncoding" value="1007" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1007.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidUnicodeFile" value="1008" version="0" level="win:Error" template="StringUInt32String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1008.message)">
					</event>
					<event symbol="Error_RegistryApi_UnexpectedEof" value="1009" version="0" level="win:Error" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1009.message)">
					</event>
					<event symbol="Error_RegistryApi_KeyDeletionNotAllowed" value="1010" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1010.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidCharsAfterBckt" value="1011" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1011.message)">
					</event>
					<event symbol="Error_RegistryApi_HeaderTooLong" value="1012" version="0" level="win:Error" template="UInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1012.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidHeader" value="1013" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1013.message)">
					</event>
					<event symbol="Error_RegistryApi_BadHive" value="1014" version="0" level="win:Error" template="StringUInt32UInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1014.message)">
					</event>
					<event symbol="Error_RegistryApi_KeysList" value="1015" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1015.message)">
					</event>
					<event symbol="Error_RegistryApi_KeyName" value="1016" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1016.message)">
					</event>
					<event symbol="Error_RegistryApi_ParsingError" value="1017" version="0" level="win:Error" template="StringUInt32UInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1017.message)">
					</event>
					<event symbol="Error_RegistryApi_MissingSubkey" value="1018" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1018.message)">
					</event>
					<event symbol="Error_RegistryApi_UnknownOp" value="1019" version="0" level="win:Error" template="StringUInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1019.message)">
					</event>
					<event symbol="Error_RegistryApi_CantCreateKey" value="1020" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1020.message)">
					</event>
					<event symbol="Error_RegistryApi_CantFindKey" value="1021" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1021.message)">
					</event>
					<event symbol="Debug_RegistryApi_DeleteKeyFailed" value="1022" version="0" level="win:Verbose" template="StringStringError" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1022.message)">
					</event>
					<event symbol="Error_RegistryApi_ExpectedEof" value="1023" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1023.message)">
					</event>
					<event symbol="Error_RegistryApi_UnexpectedEofAfterSlash" value="1024" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1024.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidEscapeSeq" value="1025" version="0" level="win:Error" template="UInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1025.message)">
					</event>
					<event symbol="Error_RegistryApi_UnexpectedNewLine" value="1026" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1026.message)">
					</event>
					<event symbol="Error_RegistryApi_ExpectedDword" value="1027" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1027.message)">
					</event>
					<event symbol="Error_RegistryApi_ExpectedDwordValue" value="1028" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1028.message)">
					</event>
					<event symbol="Error_RegistryApi_ExpectedEof2" value="1029" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1029.message)">
					</event>
					<event symbol="Error_RegistryApi_UnexpectedPrefix" value="1030" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1030.message)">
					</event>
					<event symbol="Error_RegistryApi_NotSupportedInNT" value="1031" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1031.message)">
					</event>
					<event symbol="Error_RegistryApi_ExpectedHexValue" value="1032" version="0" level="win:Error" template="StringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1032.message)">
					</event>
					<event symbol="Error_RegistryApi_ExpectedHexValue2" value="1033" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1033.message)">
					</event>
					<event symbol="Error_RegistryApi_ExpectedHexSeq" value="1034" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1034.message)">
					</event>
					<event symbol="Error_RegistryApi_FailedOp" value="1035" version="0" level="win:Error" template="StringStringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1035.message)">
					</event>
					<event symbol="Error_RegistryApi_ShadowingNotAllowed" value="1036" version="0" level="win:Error" template="StringStringStringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1036.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidValueName" value="1037" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1037.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidDefaultValueName" value="1038" version="0" level="win:Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1038.message)">
					</event>
					<event symbol="Error_RegistryApi_UnexpectedChar" value="1039" version="0" level="win:Error" template="UInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1039.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidArgs" value="1040" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1040.message)">
					</event>
					<event symbol="Error_RegistryApi_HiveLoadFailed" value="1041" version="0" level="win:Error" template="StringStringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1041.message)">
					</event>
					<event symbol="Error_RegistryApi_OnlyMultiSzSupported" value="1042" version="0" level="win:Error" template="StringStringUInt32" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1042.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidMultiSZ" value="1043" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1043.message)">
					</event>
					<event symbol="Error_RegistryApi_InvalidMultiSZ2" value="1044" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1044.message)">
					</event>
					<event symbol="Error_UpdateDll_UpdateMainNotInitialized" value="1200" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1200.message)">
					</event>
					<event symbol="Error_UpdateDll_PrepareUpdateNotCalled" value="1201" version="0" level="win:Error" template="String" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1201.message)">
					</event>
					<event symbol="Error_IUCore_LastUpdateError" value="1202" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1202.message)">
					</event>
					<event symbol="Error_IUCore_LastUpdateUnexpectedState" value="1203" version="0" level="win:Error" template="StringInt32Error" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1203.message)">
					</event>
					<event symbol="Info_UpdateDll_OutputFileWritten" value="1204" version="0" level="win:Informational" template="StringString" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1204.message)">
					</event>
					<event symbol="Info_UpdateDll_StagedDirSize" value="1205" version="0" level="win:Informational" template="StringUInt64" keywords="info " task="STAGED_DIR_SIZE" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1205.message)">
					</event>
					<event symbol="Info_UpdateDll_PrepareRegStart" value="1206" version="0" level="win:Informational" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1206.message)">
					</event>
					<event symbol="Info_UpdateDll_PrepareRegEnd" value="1207" version="0" level="win:Informational" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1207.message)">
					</event>
					<event symbol="Debug_IUCore_ImportDeltas" value="1208" version="0" level="win:Verbose" template="String" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1208.message)">
					</event>
					<event symbol="Debug_UpdateDll_ExportDeltas" value="1209" version="0" level="win:Verbose" template="StringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1209.message)">
					</event>
					<event symbol="Error_UpdateDll_DriverDBUpdatedFlagSetFailed" value="1210" version="0" level="win:Error" template="StringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1210.message)">
					</event>
					<event symbol="Debug_UpdateDll_OutputFileContent" value="1212" version="0" level="win:Verbose" template="String" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1212.message)">
					</event>
					<event symbol="Debug_UpdateDll_TempDirFound" value="1213" version="0" level="win:Verbose" template="StringString" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1213.message)">
					</event>
					<event symbol="Debug_UpdateDll_TempDirList" value="1215" version="0" template="String" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1215.message)">
					</event>
					<event symbol="Debug_UpdateDll_StringOutput" value="1216" version="0" level="win:Verbose" template="String" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1216.message)">
					</event>
					<event symbol="Debug_UpdateDll_TempFileList" value="1217" version="0" level="win:Verbose" template="String" keywords="debug " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1217.message)">
					</event>
					<event symbol="Error_UpdateDll_PkgNotFound" value="1218" version="0" level="win:Error" template="StringStringError" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1218.message)">
					</event>
					<event symbol="Info_UpdateDll_PkgCount" value="1219" version="0" level="win:Informational" template="StringUInt64UInt64" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1219.message)">
					</event>
					<event symbol="Info_Update_TotalStagingTime" value="1220" version="0" level="win:Informational" template="Int32Int32" keywords="info " task="TOTAL_STAGING_TIME" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1220.message)">
					</event>
					<event symbol="Info_UpdateDll_TotalCommitTime" value="1222" version="0" level="win:Informational" template="Int32Int32" keywords="info " task="TOTAL_COMMIT_TIME" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1222.message)">
					</event>
					<event symbol="Info_UpdateDll_RegistrySetupTime" value="1223" version="0" level="win:Informational" template="Int32Int32" keywords="info " task="REGISTRY_SETUP_TIME" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1223.message)">
					</event>
					<event symbol="Info_UpdateDll_PartitionCommitTime" value="1224" version="0" level="win:Informational" template="Int32Int32" keywords="info " task="PARTITION_COMMIT_TIME" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1224.message)">
					</event>
					<event symbol="Info_UpdateDll_ValidationTime" value="1225" version="0" level="win:Informational" template="Int32Int32" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1225.message)">
					</event>
					<event symbol="Info_UpdateDll_UpdateOSTime" value="1226" version="0" level="win:Informational" template="Int32Int32" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1226.message)">
					</event>
					<event symbol="Info_UpdateDll_AclApplicationTime" value="1227" version="0" level="win:Informational" template="Int32Int32" keywords="info " task="ACL_APPLICATION_TIME" message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1227.message)">
					</event>
					<event symbol="Info_UpdateDll_Perf" value="1228" version="0" level="win:Informational" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1228.message)">
					</event>
					<event symbol="Info_UpdateDll_StagingEstimate" value="1229" version="0" level="win:Informational" template="StringUInt64UInt64" keywords="info " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.1229.message)">
					</event>
					<event symbol="Error_PkgCommon_DuplicateFile" value="825" version="0" level="win:Error" template="StringStringString" keywords="error " message="$(string.Microsoft-WindowsPhone-ImgUpdLogger.event.825.message)">
					</event>
				</events>
				<levels>
				</levels>
				<keywords>
					<keyword name="warning" mask="0x1000">
					</keyword>
					<keyword name="debug" mask="0x100">
					</keyword>
					<keyword name="error" mask="0x10">
					</keyword>
					<keyword name="info" mask="0x10000">
					</keyword>
				</keywords>
				<templates>
					<template tid="APIEntry">
						<data name="ModuleName" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="FunctionName" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="APIExit">
						<data name="ModuleName" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="FunctionName" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ExitCode" inType="win:Int32" outType="win:HResult">
						</data>
					</template>
					<template tid="APIFailure">
						<data name="ModuleName" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="FunctionName" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="APIName" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="ApiFailureString">
						<data name="ModuleName" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Function" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Api" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Parameter" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="String">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="UInt32">
						<data name="UInt" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="StringString">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="StringStringString">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="StringStringStringString">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String4" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="StringStringStringStringString">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String4" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String5" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="StringInt32">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
					</template>
					<template tid="StringUInt32">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="UInt" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="StringInt32Int32">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int1" inType="win:Int32" outType="xs:int">
						</data>
						<data name="Int2" inType="win:Int32" outType="xs:int">
						</data>
					</template>
					<template tid="StringUInt32UInt32">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="UInt1" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="UInt2" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="StringUInt32String">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="UInt" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="StringInt32UInt64String">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
						<data name="ULong" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="StringStringInt32">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
					</template>
					<template tid="StringStringUInt32">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int1" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="StringUInt64">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Long" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
					</template>
					<template tid="StringStringInt64">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Long" inType="win:Int64" outType="xs:long">
						</data>
					</template>
					<template tid="StringUInt64UInt64">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Long1" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
						<data name="Long2" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
					</template>
					<template tid="StringStringUInt64UInt64">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Long1" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
						<data name="Long2" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
					</template>
					<template tid="StringStringInt64Int64Error">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Long1" inType="win:Int64" outType="xs:long">
						</data>
						<data name="Long2" inType="win:Int64" outType="xs:long">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringError">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringStringError">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringStringStringError">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringStringStringStringError">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String4" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="5StringError">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String4" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String5" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringInt32Error">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringInt32StringError">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringStringInt32Error">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringStringStringInt32">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
					</template>
					<template tid="StringStringStringInt32Error">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="StringStringUInt64Int32Error">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="ULong" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
						<data name="Int" inType="win:Int32" outType="xs:int">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="3String4Int32Error">
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String3" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="Int1" inType="win:Int32" outType="xs:int">
						</data>
						<data name="Int2" inType="win:Int32" outType="xs:int">
						</data>
						<data name="Int3" inType="win:Int32" outType="xs:int">
						</data>
						<data name="Int4" inType="win:Int32" outType="xs:int">
						</data>
						<data name="ErrorCode" inType="win:UInt32" outType="win:ErrorCode">
						</data>
					</template>
					<template tid="UInt32UInt32">
						<data name="uint1" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="uint2" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="Int32Int32">
						<data name="Int1" inType="win:Int32" outType="xs:int">
						</data>
						<data name="Int2" inType="win:Int32" outType="xs:int">
						</data>
					</template>
				</templates>
			</provider>
		</events>
	</instrumentation>
	<localization>
		<resources culture="en-US">
			<stringTable>
				<string id="level.Warning" value="Warning">
				</string>
				<string id="level.Verbose" value="Verbose">
				</string>
				<string id="level.Informational" value="Information">
				</string>
				<string id="level.Error" value="Error">
				</string>
				<string id="Task.TraceMessage" value="Trace">
				</string>
				<string id="Provider.Name" value="Microsoft-WindowsPhone-ImgUpdLogger">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.9.message" value="IUValidator!%1: Failed to open volume for partition '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.825.message" value="PKGCommon!%1: Diff package '%2' has multiple file entries with same device path '%3'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.824.message" value="PKGCommon!%1: Failed at call VerifyHash for '%2' and DDSM's SourceHash. error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.823.message" value="PKGCommon!%1: Diff Package '%2', DSM version('%3') is different DDSM TargetVersion('%4')">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.822.message" value="PKGCommon!%1: DSM '%2' and DDSM '%3' has different package name">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.821.message" value="PKGCommon!%1: DDSM is not initialized in GetDiffFileEntry for package '%2'. Maybe it is a canonical package.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.820.message" value="PKGCommon!%1: Can't extract file '%2' from package '%3'. error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.819.message" value="PKGCommon!%1: Failed to rename file '%2' to '%3' in package '%4'. error is %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.818.message" value="PkgCommon!%1: Package %2 has an unexpected package type %3, error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.817.message" value="PKGCommon!%1: Failed call to Cab_Extract while extracting package '%2' for partition '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.816.message" value="PKGCommon!%1: Method called when Package is invalid, error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.815.message" value="PKGCommon!%1: No DSM file found in PackageFile '%2', package may be corrupted">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.814.message" value="PKGCommon!%1: Failed to extract DSM for package '%2' DSM file '%3' extract to '%4', error is %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.812.message" value="PKGCommon!%1: Error reading DSM '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.811.message" value="PKGCommon!%1: Package '%2' doesn't have target DSM in DDSM">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.810.message" value="PKGCommon!%1: Package '%2' File must have more files. file count is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.809.message" value="PKGCommon!%1: Package '%2' DDSM SourceDSMHash is not set">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.808.message" value="PKGCommon!%1: Package '%2' DDSM Source version is not set.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.807.message" value="PKGCommon!%1: Package '%2' DDSM Source version is greater than or equal to Target.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.806.message" value="PKGCommon!%1: DDSM Name is empty">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.805.message" value="PKGCommon!%1: Package '%2' has the same entry for '%3'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.804.message" value="PKGCommon!%1: Package '%2' has multiple TargetDsm entry in DDSM">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.803.message" value="PKGCommon!%1: Failed call to StringToBinaryArray while setting Source DSM Hash in package '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.802.message" value="PKGCommon!%1: Package '%2' fails at Validate, error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.801.message" value="PKGCommon!%1: Error reading DDSM, error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.800.message" value="PKGCommon!%1: Unrecognized Node '%2' and Value '%3' encountered.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.8.message" value="UpdateValidator!%1: Package (%2), device path (%3), unexpected file action type %4, error is %5.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.7.message" value="UpdateValidator!%1: File collision detected, File '%2' found in packages '%3' and '%4'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.6001.message" value="%1: DLL_THREAD_ATTACHED called">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.6000.message" value="%1: DLL_PROCESS_ATTACH called">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.6.message" value="UpdateValidator!%1: Partition count: %2.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.565.message" value="IUCore!%1: Failed to query feature set from '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.564.message" value="IUCore!%1: Stomping previous actions on file (%2) due to delete action">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.563.message" value="IUCore!%1: Failed to calculate file order, error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.562.message" value="IUCore!%1: Unknown CPU type (%2) encountered">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.561.message" value="IUCore!%1: Package (%2), device path (%3), unexpected file action type %4, error is %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.560.message" value="IUCore!%1: Failed to find file '%2' in package '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.559.message" value="IUCore!%1: Error reading Update History file '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.558.message" value="IUCore!%1: Error setting UpdateOutput::UpdateStates with unparsable value '%2'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.557.message" value="IUCore!%1: The DSM for package '%2' has not been populated, error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.556.message" value="IUCore!%1: Error reading Output XML '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.555.message" value="IUCore!%1: Unrecognized Node '%2' and Value '%3' encountered while parsing Output XML file '%4'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.554.message" value="IUCore!%1: Error setting UpdateOutput::UpdateStates with value '%2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.553.message" value="IUCore!%1: Error reading update input XML, error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.552.message" value="IUCore!%1: Unrecognized Node '%2' and Value '%3' encountered.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.551.message" value="IUCore!%1: Failed call to write out new binary partition to paritition '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.550.message" value="IUCore!%1: Partition payload of size '%2' won't fit in partition of size '%3' for partition '%4'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.549.message" value="IUCore!%1: Decryption must happen in-place, buffer size returned was '%2' when it should be no greater than '%3'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.548.message" value="IUCore!%1: Failed to decrypt binary partition from file '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.547.message" value="IUCore!%1: Failed to read binary partition from '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.546.message" value="IUCore!%1: Failed allocate buffer size %2 for binary partition '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.545.message" value="IUCore!%1: Failed to open staging file for binary partition '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.544.message" value="IUCore!%1: No sector size is set and we cannot update a binary partition without it">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.543.message" value="IUCore!%1: Failed call to rename critical file from '%2' to '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.542.message" value="IUCore!%1: Failed to ReplaceFileContent with source = '%2' and dest = '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.541.message" value="IUCore!%1: Failed to mount UpdateOS WIM at '%2' to '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.540.message" value="IUCore: Performance Measures: WIM management time: seconds = %1(tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.539.message" value="IUCore!%1: Failed to directly copy the new UpdateOS from '%2' to '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.538.message" value="IUCore!%1: Disk full, trying a straight copy of the UpdateOS from '%2' to '%3'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.537.message" value="IUCore!%1: Failed to commit the new UpdateOS from '%2' to '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.536.message" value="IUCore!%1: Could not flush WIM at '%2', error is %3. Skipping.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.534.message" value="IUCore!%1: Could not open WIM at '%2' for flushing, error is %3. Skipping.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.533.message" value="IUCore!%1: IUStore has not been initialized">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.532.message" value="IUCore!%1: Failed to deinitialize the binary partition decryption module, error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.531.message" value="IUCore!%1: NULL Service Handle after calling CreateImageStorageService in PhoneStorage, error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.530.message" value="IUCore: Flushed partition '%1'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.529.message" value="IUCore!%1: Failed to copy all DSMs from '%2' to '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.528.message" value="IUCore!%1: Failed to get user profile subkeys from hive at '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.527.message" value="IUCore!%1: Failed to move the provisioned user hive from '%2' to its staging location at '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.526.message" value="IUCore!%1: No user hive found for partition '%2', skipping.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.525.message" value="IUCore!%1: No provisioning context set which indicates no work to perform. Skipping.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.524.message" value="IUCore!%1: No provisioning needed for partition '%2'. Skipping.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.523.message" value="IUCore!%1: Failed commit hive from '%2' to '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.522.message" value="IUCore: Committing registry hive '%1'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.521.message" value="IUCore: Done committing partition '%1'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.520.message" value="IUCore: Committing file '%1'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.519.message" value="IUCore: Committing partition '%1'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.518.message" value="IUCore!%1: Unexpected file info action for file '%2'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.516.message" value="IUCore!%1: Failed to apply patch '%2' with destination '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.514.message" value="IUCore!%1: Hive index value is %2 but cannot be greater than %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.513.message" value="IUCore!%1: Attempted to add file at '%2', but it doesn't exist.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.512.message" value="IUCore!%1 : Failed to query available free space on partition '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.511.message" value="IUCore!%1: Failed to calculate partition byte size for partition %2, with sector count %3 and sector size %4, error is %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.510.message" value="IUCore!%1: Bad diff type for file '%2' in package '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.509.message" value="IUCore!%1: Failed to find DSM entry for file '%2' in package '%3'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.508.message" value="IUCore!%1: Unexpected FileType found in binary partition for file '%2' in package '%3'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.507.message" value="IUCore!%1: Failed to set file paths for file at devicepath '%2' in package '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.506.message" value="IUCore!%1: Failed to populate file info deletes for package '%2'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.505.message" value="UpdateValidator!%1: DSM for package '%2' not found in default DSM file store '%3', package is not installed.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.504.message" value="IUCore!%1: Failed to populate file info for file at devicepath '%2' in package '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.503.message" value="IUCore!%1: Package %2 has an invalid package type %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.501.message" value="IUCore!%1: The file list cannot be prepared without first being assigned to partition.  Partition is NULL for Package '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5007.message" value="%1: Exiting API %2 with return code %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5006.message" value="%1: Entering API %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5005.message" value="%1%!%2: %3, params '%4', '%5' failed with error %6.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5004.message" value="%1%!%2:  '%3' is invalid.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5003.message" value="%1%!%2: %3, param '%4' failed with error %5.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5002.message" value="%1%!%2: %3, param '%4' failed with error %5.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5001.message" value="%1%!%2: %3 is NULL.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5000.message" value="%1%!%2: %3 failed with error %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.500.message" value="IUCore: Extracting Package '%1'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.5.message" value="UpdateValidator!%1: Failed to get all files from '%2' using pattern '%3', error is %4.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.40.message" value="IUValidator!%1: Package '%2' targets CPU type '%3', but the device's CPU type is '%4', error is %5.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.4.message" value="UpdateValidator: %1%2:\n%3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.39.message" value="UpdateValidator!%1: Commit size for partition '%2' = %3 bytes">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.38.message" value="UpdateValidator!%1 failed, unexpected file action '%2'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.37.message" value="UpdateValidator!%1 failed, Insufficient space in partition '%2', available '%3', required '%4', error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.36.message" value="UpdateValidator!%1: Failed to authenticate staged file(s) against catalog '%2', error = %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.34.message" value="UpdateValidator: Validation rules execution complete.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.33.message" value="UpdateValidator: Rule execution time = %1 seconds (%2 ticks)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.32.message" value="UpdateValidator!%1: RulesEngine not initialized">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.31.message" value="UpdateValidator!%1: Package %2 has target group information that does not match device group membership, error = %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.30.message" value="UpdateValidator!%1: Failed to enumerate key %2, error = %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.3.message" value="UpdateValidator!%1: Validator not initialized.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.29.message" value="UpdateValidator!%1: Failed to open key '%2', error = %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.28.message" value="UpdateValidator!%1: Path calculation failed for package (%2), final target version (%3) not reached, error = %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.27.message" value="UpdateValidator!%1: Package (%2), source version of diff package (%3) does not equal target version of previous hop (%4), error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.26.message" value="UpdateValidator!%1: Diff package (%2) target source version (%3), but the previous hop has version (%4), error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.25.message" value="UpdateValidator!%1: Possible multiple paths found, Diff package (%2) source version (%3) can't be less than previous hop (%4) version (%5) , error = %6">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.24.message" value="UpdateValidator!%1: Invalid multi-hop, removal package (%2) followed by diff (%3), error = %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.23.message" value="UpdateValidator!%1: Package (%2) and (%3) have the same version (%4), multiple update paths found, error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.22.message" value="UpdateValidator!%1: Found duplicate packages with name (%2) at (%3) and (%4) in update set, error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.21.message" value="UpdateValidator!%1: Package %2, unexpected package type %3, error = %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.20.message" value="UpdateValidator!%1: Package (%2) target version (%3), but that is &lt; than the installed version (%4), only higher versions are allowed, error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.2.message" value="%1: Partition '%2' Good package count: %3, Bad package count: %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.19.message" value="UpdateValidator!%1: Diff package (%2) targets version (%3), but that version is already installed, error = %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.18.message" value="UpdateValidator!%1: Diff package (%2) targets source version (%3), but the last known version (either installed or in the pending update chain) is (%4), error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.17.message" value="UpdateValidator!%1: Diff package (%2) is trying to update a package that is not installed or is pending removal. A canonical is required to install the package before updating it. For pending removal, the canonical's version must be greater than the removal, error = %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.16.message" value="UpdateValidator!%1: Package %2, target version (%3) less than installed version (%4), only higher versions are allowed, error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.15.message" value="UpdateValidator!%1: Package (%2) is trying to install version (%3), but that version is already installed, error = %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.14.message" value="UpdateValidator!%1: Removal package (%2) cannot be installed because its version (%3) is less than version of installed package (%4), error = %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.13.message" value="UpdateValidator!%1: Removal not allowed for binary partition, Package %2, Target Partition %3, error = %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1228.message" value="UpdateDLL: Performance Measures:">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1229.message" value="Staging is%1 expected to fit: estimated to take %2 bytes, %3 are free.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1227.message" value="ACL application time: seconds = %1 (tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1226.message" value="Update OS time: seconds = %1 (tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1225.message" value="Validation time: seconds = %1 (tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1224.message" value="Quick Commit time: seconds = %1 (tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1223.message" value="Registry setup time: seconds = %1 (tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1222.message" value="Total commit time: seconds = %1 (tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1220.message" value="Total staging time: seconds = %1 (tickcount=%2)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1219.message" value="UpdateDLL!%1: Total packages = %2, Total Update Size = %3 bytes">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1218.message" value="UpdateDLL!%1: Unable to find package '%2' specified in the update input file, error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1217.message" value="UpdateDLL!%1: Found the following temporary directory files:">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1216.message" value="%1">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1215.message" value="UpdateDLL!%1: Found the following temporary directory directories:">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1213.message" value="UpdateDLL!%1: Found temporary directory from a previous update '%2'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1212.message" value="Update Output file content: 
%1">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1211.message" value="UpdateDLL!%1: Found an update output file from a previous update '%2'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1210.message" value="UpdateDLL!%1: Failed to mark driver database as updated, error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1209.message" value="UpdateDLL: Exporting registry deltas from unmodified hive files at '%1' and live hives at '%2'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1208.message" value="IUCore: Importing registry deltas into hives at '%1'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1207.message" value="UpdateDLL: Done preparing registries.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1206.message" value="UpdateDLL: Preparing registries for each partition.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1205.message" value="UpdateDLL!%1: Total size of staged files = %2 bytes">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1204.message" value="UpdateDLL!%1: Output file '%2' written.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1203.message" value="IUCore!%1: The last update's output indicates an unexpected update state '%2'. The update cannot continue.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1202.message" value="IUCore!%1: The last update's output indicates it ended with error %2. The update cannot continue. Start the update again from the beginning.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1201.message" value="UpdateDLL!%1: ExecuteUpdate was called before completion of PrepareUpdate">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1200.message" value="UpdateDLL!%1: UpdateMain not initialized">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.12.message" value="%1">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.11.message" value="UpdateValidator!%1: Non-Microsoft packages cannot be targeted to UpdateOS partition, package = %2, owner = %3, error is %4.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1044.message" value="RegistryAPI!%1: Malformed multistring encountered.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1043.message" value="RegistryAPI!%1: Malformed multistring encountered. The multistring must end with a double null.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1042.message" value="RegistryAPI!%1: Only multistrings (hex(7)) are supported, key '%2' is type %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1041.message" value="RegistryAPI!%1: Couldn't load hive '%2' at path '%3', error is %4">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1040.message" value="RegistryAPI!%1: Bad arguments passed to function">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1039.message" value="found an unexpected character '%1. Make sure valuenames have double quotes around them (ex. \&quot;foo\&quot;).">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1038.message" value="found a default value name without a registry key.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1037.message" value="found a value name without a registry key.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1036.message" value="RegistryAPI!%1: Collision detected between '%2' and '%3' for key: '%4' value: '%5'. Shadowing is not allowed.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1035.message" value="RegistryAPI!%1: Failed to %2 registry key '%3\\%4', error is %5">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1034.message" value="expected :&lt;hex sequence&gt;&lt;end of line&gt;.
Ex. :13,37&lt;end of line&gt; or :de,ad,co,\\&lt;newline&gt;de&lt;end of line&gt;.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1033.message" value="expected '%1(hex type):&lt;hex value&gt;'.
Hex types are always in hex with no '0x' prefix. Make sure to convert decimal values.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1032.message" value="expected '%1:&lt;hex value&gt;' or '%2(hex type):&lt;hex value&gt;'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1031.message" value="%1 is not supported in NT.
%1 values must be converted to hex(7) with double null termination. For example:
\&quot;Foo\&quot;=multi_sz:\&quot;01\&quot;,\&quot;23\&quot;
becomes \&quot;Foo\&quot;=hex(7):30,00,31,00,00,00,32,00,33,00,00,00,00,00">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1030.message" value="unexpected prefix encountered for value name.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1029.message" value="expected -&lt;end of line&gt;. Ex. \&quot;Foo\&quot;=-&lt;end of line&gt;.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1028.message" value="expected '%1&lt;dword value&gt;'. Ex \&quot;Foo\&quot;=%2 5eaf00d.
Note: '%3' is always in hex with no '0x' prefix. Make sure to convert decimal values.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1027.message" value="expected '%1'. Ex \&quot;Foo\&quot;=%2F005ba11.
Note: '%3' is always in hex with no '0x' prefix. Make sure to convert decimal values.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1026.message" value="unexpected newline encountered when parsing string.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1025.message" value="invalid escape sequence '\\%1'. Backslashes (\\) and double quotes (\&quot;) must be escaped, ex. \&quot;Foo\&quot;=\&quot;C:\\\\Windows\&quot;">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1024.message" value="unexpected end of file after escape character '\\'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1023.message" value="Expected \\&lt;end of line&gt;. For example, \&quot;Foo\&quot;=hex:05,EA,F0,\\\n0D">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1022.message" value="RegistryAPI!%1: Couldn't delete subkey '%2', error is %3">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1021.message" value="RegistryAPI!%1: Couldn't find subkey '%2' in map">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1020.message" value="RegistryAPI!%1: Can't recreate the root key.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1019.message" value="RegistryAPI!%1: Encountered unknown registry operation: %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1018.message" value="Expected subkey after \\">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1017.message" value="RegistryAPI!%1: Parsing error near line %2 (char. offset %2).">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1016.message" value="%1">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1015.message" value="Keys must be under one of the following:">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1014.message" value="Unexpected hive or key found in '%1' near line %2 (char. offset %2).">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1013.message" value="Reg key header cannot end with '\\'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1012.message" value="Reg key header is too long. The limit is %u characters.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1011.message" value="Unexpected character(s) found after closing bracket ']' (see previous line)">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1010.message" value="Key deletion is not supported key headers. Only invdividual value deletions are supported.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1009.message" value="&quot;Unexpected end of line while parsing key header.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1008.message" value="RegistryAPI!%1: Unexpected (odd) size of file (%2 bytes) for unicode file '%3'.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1007.message" value="RegistryAPI!%1: '%2' is not a UTF-16 reg file. Only UTF-16 is supported.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1006.message" value="RegistryAPI!%1: Processing registry file '%2'">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1005.message" value="RegistryAPI!%1: Failed to close old hive, we may be leaking it. Error is %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1003.message" value="RegistryAPI!%1: Trying to save more than the known amount of hives (known: %2, param: %3).">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1002.message" value="RegistryAPI!%1: empty list of registry/regappend file paths passed into BuildHives">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1001.message" value="RegistryAPI!%1: output path must be set">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1000.message" value="RegistryAPI!%1: reg files path must be set">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.10.message" value="UpdateValidator!%1: Binary Partition '%2' -&gt; package '%3' is invalid - Manifest File Count: Expected '1', Actual '%4', Catalog File Count: Expected '1', Actual '%5, Binary File Count: Expected '1', Actual '%6', Other File Count: Expected '0', Actual '%7', error is %8.">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.1.message" value="%1: %2">
				</string>
				<string id="Microsoft-WindowsPhone-ImgUpdLogger.event.0.message" value="Beginning validation rules execution">
				</string>
				<string id="Keyword.MyKey" value="MyKey">
				</string>
				<string id="Keyword.Debug" value="Debug">
				</string>
			</stringTable>
		</resources>
	</localization>
</instrumentationManifest>
