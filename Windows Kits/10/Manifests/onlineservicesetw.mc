<?xml version='1.0' encoding='utf-8' standalone='yes'?>
<!--
Copyright (c) Microsoft Corporation.  All rights reserved.
-->
<instrumentationManifest
  xmlns="http://schemas.microsoft.com/win/2004/08/events"
  xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <instrumentation>
    <events>

      <provider name="Microsoft-WindowsMobile-OnlineServices"
          guid="{E975DF42-10A9-4573-9C01-5291C2F0A660}"
          symbol="MICROSOFT_WINDOWSMOBILE_ONLINESERVICES"
          messageFileName="OnlineServices.dll"
          resourceFileName="OnlineServices.dll">

        <!-- Keywords -->
        <keywords>
          <keyword mask="0x0000000000000001" name="Debug" />
          <keyword mask="0x0000000000000002" name="Performance" />
          <keyword mask="0x0000000000000004" name="WebService" />
          <keyword mask="0x0000000000000020" name="DataProvider" />
        </keywords>

        <!-- Global opcodes -->
        <opcodes>
          <opcode name="Error"                  value="50" />
          <opcode name="Initialize"             value="51" />
          <opcode name="Uninitialize"           value="52" />
          <opcode name="Callback"               value="53" />
        </opcodes>

        <!-- Tasks are used with opcodes win:Start and win:Stop to link start and stop events from
             the same task together. -->
        <tasks>

          <!-- Data Provider -->
          <task name="DATA_QUERY"                                   value="120">
            <opcodes>
              <opcode name="SetProperty"        value="100" />
              <opcode name="SetEnabled"         value="101" />
              <opcode name="SetStatus"          value="102" />
              <opcode name="SetResult"          value="103" />
              <opcode name="BeginExecute"       value="104" />
            </opcodes>
          </task>
          <task name="DATA_QUERY_EXECUTE"                           value="121" />
          <task name="DATA_QUERY_BEGINEXECUTE"                      value="122" />
          <task name="DATA_QUERY_PROCESSRESULT"                     value="123" />

          <!-- Transport -->
          <task name="OSS_API"                                value="140">
            <opcodes>
              <opcode name="OpenProvider"       value="100" />
              <opcode name="CloseProvider"      value="101" />
              <opcode name="SendQuery"          value="102" />
              <opcode name="CloseQuery"         value="103" />
              <opcode name="QueueDownload"      value="104" />
              <opcode name="GetHeader"          value="105" />
              <opcode name="CloseDownload"      value="106" />
            </opcodes>
          </task>
          <task name="OSS_CALLBACK"                           value="141" />
          <task name="OSS_STREAM_READ"                        value="142" />

          <!-- Downloader -->
          <task name="CACHE_DOWNLOADER"                             value="145">
            <opcodes>
              <opcode name="CacheHit"           value="100" />
              <opcode name="CacheMiss"          value="101" />
              <opcode name="CacheFile"          value="102" />
              <opcode name="Canceled"           value="103" />
              <opcode name="Expired"            value="104" />
            </opcodes>
          </task>

          <!-- UIXSchemaState -->
          <task name="UIX_SCHEMA_STATE"                             value="150">
            <opcodes>
              <opcode name="Lock"               value="100" />
              <opcode name="Unlock"             value="101" />
              <opcode name="IsUnloaded"         value="102" />
              <opcode name="SetUnloaded"        value="103" />
            </opcodes>
          </task>

        </tasks>

        <!-- Enumeration strings -->
        <maps>
          <valueMap name="DataProviderQueryStatus">
            <map value="0"    message="$(string.Enums.DataProviderQueryStatus_Idle)" />
            <map value="1"    message="$(string.Enums.DataProviderQueryStatus_RequestingData)" />
            <map value="2"    message="$(string.Enums.DataProviderQueryStatus_ProcessingData)" />
            <map value="3"    message="$(string.Enums.DataProviderQueryStatus_Complete)" />
            <map value="4"    message="$(string.Enums.DataProviderQueryStatus_Error)" />
          </valueMap>
        </maps>

        <!-- Event Templates -->
        <templates>

          <!-- Generic -->
          <template tid="String">
            <data name="Message"          inType="win:UnicodeString" />
          </template>
          <template tid="HResult">
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="HResultAndErrorCode">
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
            <data name="ErrorCode"        inType="win:UInt32" />
          </template>
          <template tid="TaggedHResult">
            <data name="Tag"              inType="win:UnicodeString" />
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="TaggedError">
            <data name="Tag"              inType="win:UnicodeString" />
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
            <data name="ErrorCode"        inType="win:UInt32" />
          </template>
          <template tid="Boolean">
            <data name="Value"            inType="win:Boolean" />
          </template>
          <template tid="Pointer">
            <data name="Value"            inType="win:Pointer" />
          </template>

          <!-- OSS API -->
          <template tid="TransportCloseHandle">
            <data name="Handle"           inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="TransportCallback">
            <data name="Handle"           inType="win:UInt32"   outType="win:HexInt32" />
            <data name="Context"          inType="win:UInt64"   outType="win:HexInt64" />
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
            <data name="ErrorCode"        inType="win:UInt32" />
            <data name="HTTPStatusCode"   inType="win:UInt32" />
          </template>
          <template tid="TransportOpenProvider">
            <data name="ProviderID"       inType="win:UInt32" />
            <data name="TagName"          inType="win:UnicodeString" />
            <data name="Handle"           inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="TransportQuery">
            <data name="ProviderHandle"   inType="win:UInt32"   outType="win:HexInt32" />
            <data name="QueryType"        inType="win:UInt32" />
            <data name="ParameterCount"   inType="win:UInt32" />
            <data name="Context"          inType="win:UInt64"   outType="win:HexInt64" />
            <data name="Handle"           inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="TransportDownload">
            <data name="Url"              inType="win:UnicodeString" />
            <data name="Header"           inType="win:UnicodeString" />
            <data name="Context"          inType="win:UInt64"   outType="win:HexInt64" />
            <data name="Flags"            inType="win:UInt32"   outType="win:HexInt32" />
            <data name="Handle"           inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="TransportGetHeader">
            <data name="DownloadHandle"   inType="win:UInt32"   outType="win:HexInt32" />
            <data name="HeaderType"       inType="win:UInt32" />
            <data name="Header"           inType="win:AnsiString" />
          </template>

          <!-- Data provider -->
          <template tid="DataQueryError">
            <data name="This"             inType="win:Pointer"/>
            <data name="Tag"              inType="win:UnicodeString" />
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
          </template>
          <template tid="DataQueryInitialize">
            <data name="This"             inType="win:Pointer"/>
          </template>                
          <template tid="DataQuerySetProperty">
            <data name="This"             inType="win:Pointer"/>
            <data name="Key"              inType="win:UnicodeString" />
          </template>
          <template tid="DataQuerySetEnabled">
            <data name="This"             inType="win:Pointer"/>
            <data name="Enabled"          inType="win:Boolean" />
          </template>    
          <template tid="DataQuerySetStatus">
            <data name="This"             inType="win:Pointer"/>
            <data name="Status"           inType="win:UInt32"   map="DataProviderQueryStatus"/>
          </template>
          <template tid="DataQuerySetResult">
            <data name="This"             inType="win:Pointer"/>
            <data name="Value"            inType="win:Pointer"/>
          </template>
          <template tid="DataQueryBeginExecute">
            <data name="This"             inType="win:Pointer"/>
          </template>
          <template tid="DataQueryCallback">
            <data name="This"             inType="win:Pointer"/>
            <data name="HResult"          inType="win:UInt32"   outType="win:HexInt32" />
          </template>

          <!-- Downloader -->
          <template tid="DownloaderCacheFile">
            <data name="Filename"         inType="win:UnicodeString" />
            <data name="ExpiryTime"       inType="win:FILETIME" />
          </template>

        </templates>

        <events>

          <!-- Performance markers -->
          <event value="163"    symbol="OSS_STREAM_READ_START"            task="OSS_STREAM_READ"
              keywords="Performance" level="win:Verbose"       opcode="win:Start"       message="$(string.OnlineServices.TransportStreamReadStart)" />
          <event value="164"    symbol="OSS_STREAM_READ_STOP"             task="OSS_STREAM_READ"
              keywords="Performance" level="win:Verbose"       opcode="win:Stop"        message="$(string.OnlineServices.TransportStreamReadStop)" />
          <event value="165"    symbol="OSS_CALLBACK_START"               task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Start"       message="$(string.OnlineServices.TransportCallbackStart)" />
          <event value="166"    symbol="OSS_CALLBACK_STOP"                task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Stop"        message="$(string.OnlineServices.TransportCallbackStop)" />
          <event value="167"    symbol="DATA_QUERY_EXECUTE_START"               task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Start"       message="$(string.OnlineServices.DataQueryExecuteStart)" />
          <event value="168"    symbol="DATA_QUERY_EXECUTE_STOP"                task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Stop"        message="$(string.OnlineServices.DataQueryExecuteStop)" />
          <event value="169"    symbol="DATA_QUERY_BEGINEXECUTE_START"          task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Start"       message="$(string.OnlineServices.DataQueryBeginExecuteStart)" />
          <event value="170"    symbol="DATA_QUERY_BEGINEXECUTE_STOP"           task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Stop"        message="$(string.OnlineServices.DataQueryBeginExecuteStop)" />
          <event value="171"    symbol="DATA_QUERY_PROCESSRESULT_START"         task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Start"       message="$(string.OnlineServices.DataQueryProcessResultStart)" />
          <event value="172"    symbol="DATA_QUERY_PROCESSRESULT_STOP"          task="OSS_CALLBACK"
              keywords="Performance" level="win:Verbose"       opcode="win:Stop"        message="$(string.OnlineServices.DataQueryProcessResultStop)" />

          <!-- Transport events -->
          <event value="240"    symbol="OSS_API_ERROR"
              task="OSS_API"              opcode="Error"
              template="TaggedError"            message="$(string.OnlineServices.TransportApiError)"
              level="win:Error"           keywords="Debug WebService"/>
          <event value="241"    symbol="OSS_API_CALLBACK"
              task="OSS_API"              opcode="Callback"
              template="TransportCallback"      message="$(string.OnlineServices.TransportApiCallback)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="242"    symbol="OSS_API_INITIALIZE"
              task="OSS_API"              opcode="Initialize"
              template="HResult"                message="$(string.OnlineServices.TransportApiInitialize)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="243"    symbol="OSS_API_UNINITIALIZE"
              task="OSS_API"              opcode="Uninitialize"
              template="HResult"                message="$(string.OnlineServices.TransportApiUninitialize)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="244"    symbol="OSS_API_OPENPROVIDER"
              task="OSS_API"              opcode="OpenProvider"
              template="TransportOpenProvider"  message="$(string.OnlineServices.TransportApiOpenProvider)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="245"    symbol="OSS_API_CLOSEPROVIDER"
              task="OSS_API"              opcode="CloseProvider"
              template="TransportCloseHandle"   message="$(string.OnlineServices.TransportApiCloseProvider)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="246"    symbol="OSS_API_SENDQUERY"
              task="OSS_API"              opcode="SendQuery"
              template="TransportQuery"         message="$(string.OnlineServices.TransportApiSendQuery)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="247"    symbol="OSS_API_CLOSEQUERY"
              task="OSS_API"              opcode="CloseQuery"
              template="TransportCloseHandle"   message="$(string.OnlineServices.TransportApiCloseQuery)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="248"    symbol="OSS_API_QUEUEDOWNLOAD"
              task="OSS_API"              opcode="QueueDownload"
              template="TransportDownload"      message="$(string.OnlineServices.TransportApiQueueDownload)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="249"    symbol="OSS_API_GETHEADER"
              task="OSS_API"              opcode="GetHeader"
              template="TransportGetHeader"     message="$(string.OnlineServices.TransportApiGetHeader)"
              level="win:Informational"   keywords="Debug WebService"/>
          <event value="250"    symbol="OSS_API_CLOSEDOWNLOAD"
              task="OSS_API"              opcode="CloseDownload"
              template="TransportCloseHandle"   message="$(string.OnlineServices.TransportApiCloseDownload)"
              level="win:Informational"   keywords="Debug WebService"/>

          <!-- Data query events -->
          <event value="270"    symbol="DATA_QUERY_ERROR"
              task="DATA_QUERY"                 opcode="Error"
              template="DataQueryError"         message="$(string.OnlineServices.DataQueryError)"
              level="win:Error"           keywords="Debug DataProvider"/>
          <event value="271"    symbol="DATA_QUERY_INITIALIZE"
              task="DATA_QUERY"                 opcode="Initialize"
              template="DataQueryInitialize"    message="$(string.OnlineServices.DataQueryInitialize)"
              level="win:Informational"   keywords="Debug DataProvider"/>
          <event value="272"    symbol="DATA_QUERY_SETPROPERTY"
              task="DATA_QUERY"                 opcode="SetProperty"
              template="DataQuerySetProperty"   message="$(string.OnlineServices.DataQuerySetProperty)"
              level="win:Verbose"   keywords="Debug DataProvider"/>
          <event value="273"    symbol="DATA_QUERY_SETENABLED"
              task="DATA_QUERY"                 opcode="SetEnabled"
              template="DataQuerySetEnabled"    message="$(string.OnlineServices.DataQuerySetEnabled)"
              level="win:Informational"   keywords="Debug DataProvider"/>
          <event value="274"      symbol="DATA_QUERY_SETSTATUS"
              task="DATA_QUERY"                 opcode="SetStatus"
              template="DataQuerySetStatus"     message="$(string.OnlineServices.DataQuerySetStatus)"
              level="win:Informational"   keywords="Debug DataProvider"/>
          <event value="275"    symbol="DATA_QUERY_SETRESULT"
              task="DATA_QUERY"                 opcode="SetResult"
              template="DataQuerySetResult"     message="$(string.OnlineServices.DataQuerySetResult)"
              level="win:Informational"   keywords="Debug DataProvider"/>            
          <event value="276"    symbol="DATA_QUERY_BEGINEXECUTE"
              task="DATA_QUERY"                 opcode="BeginExecute"
              template="DataQueryBeginExecute"  message="$(string.OnlineServices.DataQueryBeginExecute)"
              level="win:Informational"   keywords="Debug DataProvider"/>            
          <event value="277"    symbol="DATA_QUERY_CALLBACK"
              task="DATA_QUERY"                 opcode="win:Receive"
              template="DataQueryCallback"      message="$(string.OnlineServices.DataQueryGetCallback)"
              level="win:Informational"   keywords="Debug DataProvider"/>  

          <!-- Downloader events -->
          <event value="280"    symbol="CACHE_DOWNLOADER_ERROR"
              task="CACHE_DOWNLOADER"           opcode="Error"
              template="TaggedError"            message="$(string.OnlineServices.CacheDownloaderError)"
              level="win:Informational"   keywords="Debug"/>  
          <event value="281"    symbol="CACHE_DOWNLOADER_START"
              task="CACHE_DOWNLOADER"           opcode="win:Start"
              template="String"                 message="$(string.OnlineServices.CacheDownloaderStart)"
              level="win:Informational"   keywords="Debug"/>  
          <event value="282"    symbol="CACHE_DOWNLOADER_CACHEHIT"
              task="CACHE_DOWNLOADER"           opcode="CacheHit"
              template="String"                 message="$(string.OnlineServices.CacheDownloaderHit)"
              level="win:Informational"   keywords="Debug"/>  
          <event value="283"    symbol="CACHE_DOWNLOADER_CACHEMISS"
              task="CACHE_DOWNLOADER"           opcode="CacheMiss"
              message="$(string.OnlineServices.CacheDownloaderMiss)"
              level="win:Informational"   keywords="Debug"/>  
          <event value="284"    symbol="CACHE_DOWNLOADER_CACHEFILE"
              task="CACHE_DOWNLOADER"           opcode="CacheFile"
              template="DownloaderCacheFile"    message="$(string.OnlineServices.CacheDownloaderCacheFile)"
              level="win:Informational"   keywords="Debug"/>  
          <event value="285"    symbol="CACHE_DOWNLOADER_STOP"
              task="CACHE_DOWNLOADER"           opcode="win:Stop"
              template="String"                 message="$(string.OnlineServices.CacheDownloaderStop)"
              level="win:Informational"   keywords="Debug"/>  
          <event value="286"    symbol="CACHE_DOWNLOADER_CANCELED"
              task="CACHE_DOWNLOADER"           opcode="Canceled"
              message="$(string.OnlineServices.CacheDownloaderCanceled)"
              level="win:Informational"   keywords="Debug"/>
          <event value="287"    symbol="CACHE_DOWNLOADER_EXPIRED"
              task="CACHE_DOWNLOADER"           opcode="Expired"
              template="DownloaderCacheFile"    message="$(string.OnlineServices.CacheDownloaderExpired)"
              level="win:Informational"   keywords="Debug"/>

          <!-- UIXSchemaState events -->
          <event value="300"    symbol="UIX_SCHEMA_STATE_LOCK"
              task="UIX_SCHEMA_STATE"           opcode="Lock"
              message="$(string.OnlineServices.UIXSchemaStateLock)"
              level="win:Verbose"   keywords="Debug"/>  
          <event value="301"    symbol="UIX_SCHEMA_STATE_UNLOCK"
              task="UIX_SCHEMA_STATE"           opcode="Unlock"
              message="$(string.OnlineServices.UIXSchemaStateUnlock)"
              level="win:Verbose"   keywords="Debug"/>  
          <event value="302"    symbol="UIX_SCHEMA_STATE_ISUNLOADED"
              task="UIX_SCHEMA_STATE"           opcode="IsUnloaded"
              template="Boolean"                message="$(string.OnlineServices.UIXSchemaStateIsUnloaded)"
              level="win:Verbose"   keywords="Debug"/>  
          <event value="303"    symbol="UIX_SCHEMA_STATE_SETUNLOADED"
              task="UIX_SCHEMA_STATE"           opcode="SetUnloaded"
              message="$(string.OnlineServices.UIXSchemaStateSetUnloaded)"
              level="win:Verbose"   keywords="Debug"/>  

        </events>
        
      </provider>
    </events>
  </instrumentation>

    <!-- Localizable strings for the events -->
  <localization>
    <resources culture="en-US">
      <stringTable>

        <!-- These definitions describe how to print each event in a user-friendly way.  -->

        <!-- Transport strings -->
        <string id="OnlineServices.TransportApiError"                   value="[OnlineServices] Transport Error hr=%1 error=%2" />
        <string id="OnlineServices.TransportApiCallback"                value="[OnlineServices] Transport Callback h=%1 ctx=%2 hr=%3 error=%4 httpStatus=%5" />
        <string id="OnlineServices.TransportApiInitialize"              value="[OnlineServices] Transport Initialize hr=%1" />
        <string id="OnlineServices.TransportApiUninitialize"            value="[OnlineServices] Transport Uninitialize hr=%1" />
        <string id="OnlineServices.TransportApiOpenProvider"            value="[OnlineServices] Transport OpenProvider id=%1 tag=%2 h=%3" />
        <string id="OnlineServices.TransportApiCloseProvider"           value="[OnlineServices] Transport CloseProvider h=%1" />
        <string id="OnlineServices.TransportApiSendQuery"               value="[OnlineServices] Transport SendQuery hprov=%1 query=%2 count=%3 ctx=%4 h=%5" />
        <string id="OnlineServices.TransportApiCloseQuery"              value="[OnlineServices] Transport CloseQuery h=%1" />
        <string id="OnlineServices.TransportApiQueueDownload"           value="[OnlineServices] Transport QueueDownload url=%1 header=%2 flags=%4 ctx=%3 h=%5" />
        <string id="OnlineServices.TransportApiGetHeader"               value="[OnlineServices] Transport GetHeader" />
        <string id="OnlineServices.TransportApiCloseDownload"           value="[OnlineServices] Transport CloseDownload h=%1" />
        <string id="OnlineServices.TransportCallbackStart"              value="[OnlineServices] Transport Callback Start" />
        <string id="OnlineServices.TransportCallbackStop"               value="[OnlineServices] Transport Callback Stop" />
        <string id="OnlineServices.TransportStreamReadStart"            value="[OnlineServices] ReadStreamOnInet Read Start" />
        <string id="OnlineServices.TransportStreamReadStop"             value="[OnlineServices] ReadStreamOnInet Read Stop" />

        <!-- Data provider strings -->
        <string id="OnlineServices.DataQueryError"                      value="[OnlineServices] DataQuery Error this=%1 tag=%2 hr=%3" />
        <string id="OnlineServices.DataQueryInitialize"                 value="[OnlineServices] DataQuery Initialize this=%1" />
        <string id="OnlineServices.DataQuerySetProperty"                value="[OnlineServices] DataQuery SetProperty this=%1, property='%2'" />
        <string id="OnlineServices.DataQuerySetEnabled"                 value="[OnlineServices] DataQuery SetEnabled this=%1 enabled=%2" />
        <string id="OnlineServices.DataQuerySetStatus"                  value="[OnlineServices] DataQuery SetStatus this=%1 status=%2" />
        <string id="OnlineServices.DataQuerySetResult"                  value="[OnlineServices] DataQuery SetResult this=%1 value=%2" />
        <string id="OnlineServices.DataQueryBeginExecute"               value="[OnlineServices] DataQuery Begin Execute this=%1" />
        <string id="OnlineServices.DataQueryGetCallback"                value="[OnlineServices] DataQuery Callback this=%1 hr=%2" />
        <string id="OnlineServices.DataQueryExecuteStart"               value="[OnlineServices] DataQuery Execute Start" />
        <string id="OnlineServices.DataQueryExecuteStop"                value="[OnlineServices] DataQuery Execute Stop" />
        <string id="OnlineServices.DataQueryBeginExecuteStart"          value="[OnlineServices] DataQuery BeginExecute Start" />
        <string id="OnlineServices.DataQueryBeginExecuteStop"           value="[OnlineServices] DataQuery BeginExecute Stop" />
        <string id="OnlineServices.DataQueryProcessResultStart"         value="[OnlineServices] DataQuery ProcessResult Start" />
        <string id="OnlineServices.DataQueryProcessResultStop"          value="[OnlineServices] DataQuery ProcessResult Stop" />

        <!-- Downloader strings -->
        <string id="OnlineServices.CacheDownloaderError"                value="[OnlineServices] CacheDownloader Error %1 %2" />
        <string id="OnlineServices.CacheDownloaderStart"                value="[OnlineServices] CacheDownloader Start %1" />
        <string id="OnlineServices.CacheDownloaderHit"                  value="[OnlineServices] CacheDownloader Cache Hit %1" />
        <string id="OnlineServices.CacheDownloaderMiss"                 value="[OnlineServices] CacheDownloader Cache Miss" />
        <string id="OnlineServices.CacheDownloaderCacheFile"            value="[OnlineServices] CacheDownloader Cache %1 %2" />
        <string id="OnlineServices.CacheDownloaderStop"                 value="[OnlineServices] CacheDownloader Stop" />
        <string id="OnlineServices.CacheDownloaderCanceled"             value="[OnlineServices] CacheDownloader Canceled" />
        <string id="OnlineServices.CacheDownloaderExpired"              value="[OnlineServices] CacheDownloader Expired %1 %2" />

        <!-- UIXSchemaState strings -->
        <string id="OnlineServices.UIXSchemaStateLock"                  value="[OnlineServices] UIXSchemaState Lock" />
        <string id="OnlineServices.UIXSchemaStateUnlock"                value="[OnlineServices] UIXSchemaState Unlock" />
        <string id="OnlineServices.UIXSchemaStateIsUnloaded"            value="[OnlineServices] UIXSchemaState IsUnloaded %1" />
        <string id="OnlineServices.UIXSchemaStateSetUnloaded"           value="[OnlineServices] UIXSchemaState SetUnloaded" />

        <!-- Enum strings -->
        <string id="Enums.DataProviderQueryStatus_Idle"                 value="Idle" />
        <string id="Enums.DataProviderQueryStatus_RequestingData"       value="RequestingData" />
        <string id="Enums.DataProviderQueryStatus_ProcessingData"       value="ProcessingData" />
        <string id="Enums.DataProviderQueryStatus_Complete"             value="Complete" />
        <string id="Enums.DataProviderQueryStatus_Error"                value="Error" />
 
      </stringTable>
    </resources>
  </localization>

</instrumentationManifest>
