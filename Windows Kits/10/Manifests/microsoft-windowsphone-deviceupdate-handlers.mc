<?xml version="1.0" encoding="UTF-16"?>
<instrumentationManifest xsi:schemaLocation="http://schemas.microsoft.com/win/2004/08/events eventman.xsd" xmlns="http://schemas.microsoft.com/win/2004/08/events" xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:trace="http://schemas.microsoft.com/win/2004/08/events/trace">
	<instrumentation>
		<events>
			<provider name="Microsoft-WindowsPhone-DeviceUpdate-Handlers" guid="{E0940E5B-8532-4F77-BF17-F68390BA70B7}" symbol="MICROSOFT_WINDOWSPHONE_DeviceUpdate_Handlers" resourceFileName="DuStateHandlers.dll" messageFileName="DuStateHandlers.dll">
				<events>
					<event symbol="DeviceUpdateHandlers_UpdateStateCount" value="1" version="0" level="win:Informational" template="tDWORD-UpdateState" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.1.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DetectionError" value="100" version="0" level="win:Error" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.100.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_LoadEvaluatorFailed" value="101" version="0" level="win:Error" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.101.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_CategoryToScan" value="102" version="0" level="win:Verbose" template="tSz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.102.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_CategoryToScanError" value="103" version="0" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.103.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstalledNonLeafUpdates" value="104" version="0" level="win:Verbose" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.104.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_OtherCachedUpdates" value="105" version="0" level="win:Verbose" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.105.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_GetSyncUpdates" value="106" version="0" level="win:Informational" template="tDWORD-DWORD-DWORD-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.106.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_OutofScopeUpdate" value="107" version="0" level="win:Verbose" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.107.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_NewUpdate" value="108" version="0" level="win:Verbose" template="tDWORD-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.108.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ExpiredUpdate" value="109" version="0" level="win:Verbose" template="tDWORD-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.109.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_OldUpdate" value="110" version="0" level="win:Warning" template="tDWORD-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.110.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ChangeUpdateNotFound" value="111" version="0" level="win:Warning" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.111.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_SaveSyncUpdatesFailed" value="112" version="0" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.112.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ParseExtendedFailed" value="113" version="0" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.113.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ScanFailed" value="114" version="0" level="win:Error" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.114.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadUpdateCompleted" value="200" version="0" level="win:Informational" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.200.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_UpdateAlreadyStaged" value="201" version="0" level="win:Informational" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.201.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_UpdateAlreadyDownloaded" value="202" version="0" level="win:Verbose" template="tSz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.202.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReCreateDownloadRequest" value="203" version="0" level="win:Informational" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.203.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadFileInvalid" value="204" version="0" level="win:Warning" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.204.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadRequest" value="205" version="0" level="win:Verbose" template="tSz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.205.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_BTSCallback" value="206" version="0" level="win:Verbose" template="tSz-DWORD-DWORD-DWORD-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.206.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_BTSCallbackFailed" value="207" version="0" level="win:Error" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.207.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_BTSCallbackWrongRequest" value="208" version="0" level="win:Error" template="tSz-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.208.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_NoUpdatesToDownload" value="209" version="0" level="win:Informational" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.209.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_GetOTAThresholdFailed" value="210" version="0" level="win:Warning" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.210.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_CancelDownloadRequestFailed" value="211" version="0" level="win:Error" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.211.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadOverWifiOnly" value="212" version="0" level="win:Informational" template="tDWORD-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.212.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadProgress" value="213" version="0" level="win:Verbose" template="tDWORD-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.213.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadOutofSpace" value="214" version="0" level="win:Warning" template="t-UL-UL-UL-UL" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.214.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadOffTrack" value="215" version="0" level="win:Informational" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.215.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_OTAThreshold" value="216" version="0" level="win:Informational" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.216.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DownloadOneUpdateCompleted" value="217" version="0" level="win:Informational" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.217.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_UpdateDownloadResult" value="218" version="0" level="win:Warning" template="tHRESULT-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.218.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_UpdatePayloadSize" value="219" version="0" level="win:Informational" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.219.message)">
					</event>					
					<event symbol="DeviceUpdateHandlers_NoUpdatesToStage" value="300" version="0" level="win:Warning" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.300.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_NoUpdatesToCommit" value="301" version="0" level="win:Warning" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.301.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_IUAPI" value="302" version="0" level="win:Informational" template="tIUAPI" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.302.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_IUAPIFailed" value="303" version="0" level="win:Error" template="tIUAPI-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.303.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_LowBattery" value="304" version="0" level="win:Warning" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.304.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_StagingProgress" value="305" version="0" level="win:Verbose" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.305.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_StagingDuration" value="306" version="0" level="win:Informational" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.306.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationError" value="307" version="0" level="win:Error" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.307.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationMoReportServerId" value="308" version="0" level="win:Informational" template="tSz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.308.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationSetRegNodeValue" value="309" version="0" level="win:Informational" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.309.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationGetCspNodeValue" value="310" version="0" level="win:Informational" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.310.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationOmaDmInitiateSessionWarning" value="311" version="0" level="win:Warning" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.311.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationMoReportNoServerId" value="312" version="0" level="win:Warning" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.312.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationMoReportStatusWarning" value="313" version="0" level="win:Warning" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.313.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_InstallationOmaDmSessionInitiateSucceeded" value="314" version="0" level="win:Informational" template="tDWORD-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.314.message)">
					</event>
					<event symbol="MuWebService_SendRequest_RetryError" value="500" version="0" level="win:Warning" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.500.message)">
					</event>
					<event symbol="MuWebService_WinHttpReceiveResponseFail" value="501" version="0" level="win:Informational" template="tHRESULT-Sz-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.501.message)">
					</event>
					<event symbol="MuWebService_WinHttpSendRequestFail" value="502" version="0" level="win:Informational" template="tHRESULT-Sz-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.502.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_CookieReset" value="503" version="0" level="win:Warning" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.503.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ServerProtocolMismatch" value="504" version="0" template="tSz-Sz" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.504.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_NoUpdateDownloadInformation" value="600" version="0" level="win:Warning" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.600.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_AcceptanceRate" value="601" version="0" level="win:Informational" template="tSz-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.601.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_UpdateThrottle" value="602" version="0" level="win:Informational" template="tThrottle-DWORD-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.602.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_MaxAcceptRate" value="603" version="0" level="win:Informational" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.603.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReportingSampling" value="700" version="0" level="win:Informational" template="tDWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.700.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReportDetectionEvent" value="701" version="0" level="win:Informational" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.701.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_UploadReportingDisabled" value="702" version="0" level="win:Informational" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.702.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReportDownloadEvent" value="703" version="0" level="win:Informational" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.703.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReportUserPostponeEvent" value="704" version="0" level="win:Informational" template="tDWORD-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.704.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReportInstallationEvent" value="705" version="0" level="win:Informational" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.705.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_DoUploadReportingEvents" value="706" version="0" level="win:Informational" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.706.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_CreatePersistXmlStoreFailure" value="707" version="0" level="win:Informational" template="tSz-HRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.707.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_IsInInstallSampling" value="708" version="0" level="win:Informational" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.708.message)">
					</event>
					<event symbol="DevceUpdateHandlers_IsInDetectionSampling" value="709" version="0" level="win:Informational" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.709.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_TimeRangeCalculationFailed" value="710" version="0" level="win:Warning" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.710.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReportCommitEvent" value="711" version="0" level="win:Informational" template="tHRESULT" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.711.message)">
					</event>
					<event symbol="DeviceUpdateHandlers_ReportInstallEvent" value="712" version="0" level="win:Informational" template="tDWORD-DWORD" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.712.message)">
					</event>
				</events>
				<levels>
				</levels>
				<keywords>
					<keyword name="Error" mask="0x1" message="$(string.Keyword.Error)">
					</keyword>
					<keyword name="Performance" mask="0x2" message="$(string.Keyword.Performance)">
					</keyword>
				</keywords>
				<maps>
					<valueMap name="mThrottle">
						<map value="0" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mThrottle.0.message)">
						</map>
						<map value="1" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mThrottle.1.message)">
						</map>
						<map value="2" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mThrottle.2.message)">
						</map>
					</valueMap>
					<valueMap name="mIUAPI">
						<map value="0" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.0.message)">
						</map>
						<map value="1" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.1.message)">
						</map>
						<map value="2" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.2.message)">
						</map>
						<map value="3" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.3.message)">
						</map>
						<map value="4" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.4.message)">
						</map>
					</valueMap>
					<valueMap name="mDuaUpdateState">
						<map value="0" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.0.message)">
						</map>
						<map value="1" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.1.message)">
						</map>
						<map value="2" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.2.message)">
						</map>
						<map value="3" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.3.message)">
						</map>
						<map value="4" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.4.message)">
						</map>
						<map value="5" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.5.message)">
						</map>
						<map value="6" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.6.message)">
						</map>
						<map value="7" message="$(string.Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.7.message)">
						</map>
					</valueMap>
				</maps>
				<templates>
					<template tid="tHRESULT">
						<data name="HRESULT" inType="win:UInt32" outType="win:HexInt32">
						</data>
					</template>
					<template tid="tSz">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="tDWORD">
						<data name="DWORD" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="tDWORD-DWORD">
						<data name="DWORD1" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD2" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="tDWORD-DWORD-DWORD-DWORD">
						<data name="DWORD1" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD2" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD3" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD4" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="tDWORD-Sz">
						<data name="DWORD" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="tDWORD-UpdateState">
						<data name="DWORD" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="UpdateState" inType="win:UInt32" map="mDuaUpdateState">
						</data>
					</template>
					<template tid="tIUAPI">
						<data name="IUAPI" inType="win:UInt32" map="mIUAPI">
						</data>
					</template>
					<template tid="tIUAPI-HRESULT">
						<data name="IUAPI" inType="win:UInt32" map="mIUAPI">
						</data>
						<data name="HRESULT" inType="win:UInt32" outType="win:HexInt32">
						</data>
					</template>
					<template tid="tSz-DWORD-DWORD-DWORD-DWORD">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="DWORD" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD2" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD3" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD4" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="tHRESULT-Sz-Sz">
						<data name="HRESULT" inType="win:UInt32" outType="win:HexInt32">
						</data>
						<data name="String1" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="tSz-Sz">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="String2" inType="win:UnicodeString" outType="xs:string">
						</data>
					</template>
					<template tid="tDWORD-DWORD-DWORD">
						<data name="DWORD" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD2" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD3" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="t-UL-UL-UL-UL">
						<data name="UL1" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
						<data name="UL2" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
						<data name="UL3" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
						<data name="UL4" inType="win:UInt64" outType="xs:unsignedLong">
						</data>
					</template>
					<template tid="tSz-DWORD">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="DWORD" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="tThrottle-DWORD-DWORD">
						<data name="Throttle" inType="win:UInt32" map="mThrottle">
						</data>
						<data name="DWORD" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
						<data name="DWORD2" inType="win:UInt32" outType="xs:unsignedInt">
						</data>
					</template>
					<template tid="tSz-HRESULT">
						<data name="String" inType="win:UnicodeString" outType="xs:string">
						</data>
						<data name="HRESULT" inType="win:UInt32" outType="win:HexInt32">
						</data>
					</template>
					<template tid="tDWORD-DWORD-DWORD-DWORD-DWORD">
						<data name="DWORD1" inType="win:UInt32" outType="win:HexInt32">
						</data>
						<data name="DWORD2" inType="win:UInt32" outType="win:HexInt32">
						</data>
						<data name="DWORD3" inType="win:UInt32" outType="win:HexInt32">
						</data>
						<data name="DWORD4" inType="win:UInt32" outType="win:HexInt32">
						</data>
						<data name="DWORD5" inType="win:UInt32" outType="win:HexInt32">
						</data>
					</template>
					<template tid="tHRESULT-HRESULT">
						<data name="HRESULT1" inType="win:UInt32" outType="win:HexInt32">
						</data>
						<data name="HRESULT2" inType="win:UInt32" outType="win:HexInt32">
						</data>
					</template>
				</templates>
			</provider>
		</events>
	</instrumentation>
	<localization>
		<resources culture="en-US">
			<stringTable>
				<string id="task.None" value="None">
				</string>
				<string id="opcode.Info" value="Info">
				</string>
				<string id="level.Warning" value="Warning">
				</string>
				<string id="level.Verbose" value="Verbose">
				</string>
				<string id="level.Informational" value="Information">
				</string>
				<string id="level.Error" value="Error">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mThrottle.2.message" value="allowed">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mThrottle.1.message" value="throttled">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mThrottle.0.message" value="Unknown">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.4.message" value="CleanAllUpdateFiles">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.3.message" value="GetUpdateResults">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.2.message" value="CommitUpdate">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.1.message" value="StageUpdate">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mIUAPI.0.message" value="Unknown API">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.7.message" value="DuaUpdateState_CommitSucceeded">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.6.message" value="DuaUpdateState_CommitFailed">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.5.message" value="DuaUpdateState_CommitAttempted">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.4.message" value="DuaUpdateState_ReadyToCommit">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.3.message" value="DuaUpdateState_ReadyToStage">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.2.message" value="DuaUpdateState_Downloading">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.1.message" value="DuaUpdateState_ReadyToDownload">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.map.mDuaUpdateState.0.message" value="DuaUpdateState_None">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.712.message" value="[Device Update Handlers] ReportInstallEvent: install ID: (%1),  HRESULT = (%2)">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.711.message" value="[Device Update Handlers] ReportCommitEvent: HRESULT = (%1)">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.710.message" value="[Device Update Handlers]: Failed to calculate proper time range.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.709.message" value="[Device Update Handlers]: Not in Detection Sampling (may skip reporting).">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.708.message" value="[Device Update Handlers]: Not in Install Sampling (reporting skipped).">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.707.message" value="[Device Update Handlers] CreatePersistXmlStore failed: path: &quot;%1&quot;, HRESULT: (%2).">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.706.message" value="[Device Update Handlers] DoUploadReportingEvents: HRESULT = (%1)">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.705.message" value="[Device Update Handlers] ReportInstallationEvent: HRESULT = (%1)">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.704.message" value="[Device Update Handlers] ReportUserPostponeEvent: postpone ID: (%1),  HRESULT = (%2)">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.703.message" value="[Device Update Handlers] ReportDownloadEvent: HRESULT = (%1)">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.702.message" value="[Device Update Handlers] UploadReportingEvents disabled.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.701.message" value="[Device Update Handlers] ReportDetectionEvent: HRESULT = (%1)">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.700.message" value="[Device Update Handlers] Reporting sampling value = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.603.message" value="[Device Update Handlers] Setting acceptance rate to max. Throttling won't be in effect.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.602.message" value="[Device Update Handlers] Update %1 with sequence number = %2 and acceptance rate = %3.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.601.message" value="[Device Update Handlers] Update %1 with lowest acceptance rate %2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.600.message" value="[Device Update Handlers] GetUpdateDownloadInformation did not return any information from the server.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.504.message" value="[Device Update Handlers] Server has different protocol version (%1) than default (%2).">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.503.message" value="[Device Update Handlers] Cookie was reset.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.502.message" value="[Device Update Handlers] WinHttpSendResponse failed with HRESULT = %1 for POST request to url %2 and SOAPAction %3.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.501.message" value="[Device Update Handlers] WinHttpReceiveResponse failed with HRESULT = %1 for POST request to url %2 and SOAPAction %3.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.500.message" value="[Device Update Handlers] SendRequest retry failed with HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.314.message" value="[Installation Handler] OmaDmInitiateSession succeeded. Retry time passed %1 ms, OmaDm initiation ID: %2">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.313.message" value="[Installation Handler] Warning on failed MO report Status code %1">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.312.message" value="[Installation Handler] MO report is enabled but cannot get ServerId. HRESULT = %1">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.311.message" value="[Installation Handler] OmaDmInitiateSession failed. ServerId: %1, HRESULT = %2">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.310.message" value="[Installation Handler] Get CSP node failed for CSP URI: %1, HRESULT = %2">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.309.message" value="[Installation Handler] Set reg value failed for CSP URI: %1, HRESULT = %2">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.308.message" value="[Installation Handler] Mo Report Server Id: %1">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.307.message" value="[Installation Handler] Error! HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.306.message" value="[Installation Handler] IU staging took %1 seconds.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.305.message" value="[Installation Handler] Staging progress = %1 percent.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.304.message" value="[Installation Handler] Installation interrupted due to low battery.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.303.message" value="[Installation Handler] %1 failed with HRESULT = %2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.302.message" value="[Installation Handler] Calling %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.301.message" value="[Installation Handler] No updates to commit.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.300.message" value="[Installation Handler] No updates to stage.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.219.message" value="[Download Handler] Update Payload is %1 bytes.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.218.message" value="[Download Handler] UpdateDownloadResult, hrOverallResult succeeded but either hr=%1 or hrUpdate=%2">
				</string>				
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.217.message" value="[Download Handler] UpdateDownloadManager, update %1 completed download, hr=%2">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.216.message" value="[Download Handler] Download MO OTA threshold is %1 bytes.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.215.message" value="[Download Handler] Download connection is set to OffTrack.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.214.message" value="[Download Handler] Need more free space for download. Current free space on the device is %1, required space is %2. Currently already downloaded %3 out of %4. ">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.213.message" value="[Download Handler] Download progress: State = %1, Percent = %2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.212.message" value="[Download Handler] Update file size (%1) &gt; MO OTA threshold (%2). Download over Wifi only.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.211.message" value="[Download Handler] Canceling BTS request %1 failed with HRESULT = %2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.210.message" value="[Download Handler] Getting MO OTA threshold failed with HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.209.message" value="[Download Handler] No updates to download.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.208.message" value="[Download Handler] BTS callback with requestID %1, does not match update request ID %2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.207.message" value="[Download Handler] BTS callback failed with HRESULT = %1. ">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.206.message" value="[Download Handler] BTS callback for %1, request state is %2, uploading %3, size is %4/%5.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.205.message" value="[Download Handler] Build download request ID %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.204.message" value="[Download Handler] Update %1 hash could not be validated, HRESULT = %2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.203.message" value="[Download Handler] Recreating download request %1 since the previous BTS request completed with HRESULT = %2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.202.message" value="[Download Handler] Update request %1 has already been completed.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.201.message" value="[Download Handler] Updates already staged, set next state to PreInstall.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.200.message" value="[Download Handler] Download updates completed with HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.114.message" value="[Detection Handler] Scan failed with HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.113.message" value="[Detection Handler] Parsing extended metadata for update %1 failed.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.112.message" value="[Detection Handler] SaveSyncUpdates failed with HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.111.message" value="[Detection Handler] Changed update %d not found.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.110.message" value="[Detection Handler] Old revision update %1:%2 is ignored.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.109.message" value="[Detection Handler] Expired update %1:%2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.108.message" value="[Detection Handler] New update: %1:%2.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.107.message" value="[Detection Handler] Out of Scope update %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.106.message" value="[Detection Handler] GetSyncUpdates round %1: %2 new updates, %3 out of scope updates, %4 changed updates.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.105.message" value="[Detection Handler] SyncUpdates param OtherCachedUpdateIDs: %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.104.message" value="[Detection Handler] SyncUpdates param InstalledNonLeafUpdateIDs: %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.103.message" value="[Detection Handler] GetCategoryToScan failed with HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.102.message" value="[Detection Handler] Category to scan: %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.101.message" value="[Detection Handler] Evaluator failed to load.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.100.message" value="[Detection Handler]  Error! HRESULT = %1.">
				</string>
				<string id="Microsoft-WindowsPhone-DeviceUpdate-Handlers.event.1.message" value="[DU Handlers] %1 updates found with update state %2">
				</string>
				<string id="Keyword.Performance" value="Performance">
				</string>
				<string id="Keyword.Error" value="Error">
				</string>
			</stringTable>
		</resources>
	</localization>
</instrumentationManifest>
