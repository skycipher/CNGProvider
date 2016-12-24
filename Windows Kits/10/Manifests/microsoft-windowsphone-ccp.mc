<!--
Copyright (c) Microsoft Corporation.  All rights reserved.
-->

<!-- <?xml version="1.0" encoding="UTF-16"?> -->
<instrumentationManifest
            xmlns="http://schemas.microsoft.com/win/2004/08/events"
            xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events"
            xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <instrumentation>
    <events>
      
      <!-- Here we describe the provider that uses this manifest.
           Each provider will have its own manifest. -->

      <!-- Note: messageFileName and resourceFileName should be set to the name of the
           provider's DLL/EXE. -->
      
      <provider name="Microsoft-WindowsPhone-CCP"
          guid="{1A71A81A-640F-43FB-A478-99476079C688}"
          symbol="MICROSOFT_WINDOWSPHONE_CCP"
          resourceFileName="CcpTrace.dll"
          messageFileName="CcpTrace.dll">

        <!-- NOTE: It is no longer necessary to declare which channels your provider writes to -->
        <channels />

        <!-- Keywords work much like Windows Phone "debug zones."  They are tags that can 
             be assigned to events to break them into classes.  Keyword masks are 64-bit, of
             which you may use the lower 48.  For more information on keyword definitions, see 
             http://msdn.microsoft.com/en-us/library/aa382786(VS.85).aspx -->
        
        <!--Kewords for Microsoft-WindowsPhone-CCP -->
        <keywords>
          <keyword mask="0x0000000000000001"  name="TRACE" />
          <keyword mask="0x0000000000000002"  name="INFORMATION" />
          <keyword mask="0x0000000000000004"  name="WARNING" />
          <keyword mask="0x0000000000000008"  name="ERROR" />
          <keyword mask="0x0000000000000010"  name="CRITICAL" />
          <keyword mask="0x0000000000000020"  name="PERFMARK" />
          <keyword mask="0x0000000000000040"  name="CMDDATA" />
        </keywords>

        <tasks>
          <task name="CCP_TRACE_INFO"         value="100"/>
          <task name="CCP_TRACE_WARN"         value="101"/>
          <task name="CCP_TRACE_ERROR"        value="102"/>
          <task name="CCP_TRACE_HR"           value="200"/>
          <task name="CCP_TRACE_PERFMARK"     value="300"/>
          <task name="CCP_TRACE_CMDDATA"      value="400"/>
        </tasks>
        
        <!--Event Templates -->
        <templates>
          <template tid="String">
            <!--%1--> <data name="Message" inType="win:UnicodeString" />
          </template>

          <template tid="Hr">
            <!--%1--> <data name="HResult" inType="win:UInt32" outType="win:HexInt32" />
          </template>
          
          <template tid="StringHr">
            <!--%1--> <data name="Message" inType="win:UnicodeString"                  />
            <!--%2--> <data name="HResult" inType="win:UInt32"  outType="win:HexInt32" />
          </template>

          <template tid="StringTickCount">
            <!--%1--> <data name="Message"   inType="win:UnicodeString" />
            <!--%2--> <data name="TickCount" inType="win:UInt32" />
          </template>

          <template tid="TaskRequestOutcoming">
            <!--%1--> <data name="RequestId" inType="win:UInt32" />
            <!--%2--> <data name="ProfileId" inType="win:UInt32" />
            <!--%3--> <data name="Timestamp" inType="win:UInt32" />
            <!--%4--> <data name="DataSize"  inType="win:UInt32" />
            <!--%5--> <data name="Data"      inType="win:Binary" length="DataSize" outType="xs:hexBinary"/>
          </template>

          <template tid="UInt32">
            <!--%1--> <data name="UInit32"     inType="win:UInt32" />
          </template>

          <template tid="UInt32_X_2">
            <!--%1--> <data name="UInit32_1"   inType="win:UInt32" />
            <!--%2--> <data name="UInit32_2"   inType="win:UInt32" />
          </template>
          
          <template tid="EhmFailed">
            <!--%1--> <data name="ErrorCode" inType="win:HexInt32" />
            <!--%2--> <data name="FileName" inType="win:AnsiString" />
            <!--%3--> <data name="LineNumber" inType="win:UInt32" />            
            <!--%4--> <data name="Message"  inType="win:AnsiString" />            
          </template>          
          
        </templates>

        <!-- MyProvider Events -->
        <!-- Here we define the events that this provider writes.
             For information on opcodes, see http://msdn.microsoft.com/en-us/library/aa383956(VS.85).aspx. -->
        <events>
          
          <!-- CCP_TRACE_INFO -->
          <event value="100"
             symbol="CCP_TRACE_INFO"
             task="CCP_TRACE_INFO"
             keywords="ERROR"
             template="String"
             level="win:Informational"
             message="$(string.CCP.INFO)" />

          <!-- CCP_TRACE_WARN -->
          <event value="101"
             symbol="CCP_TRACE_WARN"
             task="CCP_TRACE_WARN"
             keywords="ERROR"
             template="String"
             level="win:Warning"
             message="$(string.CCP.WARN)" />

          <!-- CCP_TRACE_ERROR -->
          <event value="102"
             symbol="CCP_TRACE_ERROR"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="StringHr"
             level="win:Error"
             message="$(string.CCP.ERROR)" />
             
          <!-- CCP_TRACE_EHM_FAILED -->
          <event value="150"
             symbol="CCP_TRACE_EHM_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="EhmFailed"
             level="win:Error"
             message="$(string.CCP.EHM.FAILED)" />

          <!-- CCP_TRACE_ORIGINALHR -->
          <event value="200"
             symbol="CCP_TRACE_HR"
             task="CCP_TRACE_HR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.HR)" />

          <!-- CCP_TRACE_PERFMARK -->
          <event value="300"
             symbol="CCP_TRACE_PERFMARK"
             task="CCP_TRACE_PERFMARK"
             keywords="PERFMARK"
             template="StringTickCount"
             level="win:Verbose"
             message="$(string.CCP.PERFMARK)" />

          <!-- CCP_TRACE_CMDDATA -->
          <event value="400"
             symbol="CCP_TRACE_CMDDATA"
             task="CCP_TRACE_CMDDATA"
             keywords="CMDDATA"
             template="TaskRequestOutcoming"
             level="win:Verbose"
             message="$(string.CCP.CMDDATA)" />

          <!-- CcpManager.cpp *************************************************************************** -->
          <event value="1000"
             symbol="CCP_TRACE_REGISTER_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="UInt32_X_2"
             level="win:Informational"
             message="$(string.CCP.REGISTER.INFO)" />

          <event value="1001"
             symbol="CCP_TRACE_REGISTER_LATCHON"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.REGISTER.LATCHON)" />

          <event value="1002"
             symbol="CCP_TRACE_REGISTER_REREG_DISALLOW_MPN"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.REGISTER.REREG_DISALLOW_MPN)" />

          <event value="1003"
             symbol="CCP_TRACE_REGISTER_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.REGISTER.FAILED)" />

          <event value="1004"
             symbol="CCP_TRACE_UNREGISTER_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="UInt32"
             level="win:Informational"
             message="$(string.CCP.UNREGISTER.INFO)" />

          <event value="1005"
             symbol="CCP_TRACE_UNREGISTER_WNF_RESET_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.UNREGISTER.WNF_RESET_FAILED)" />

          <event value="1006"
             symbol="CCP_TRACE_UNREGISTER_UNKNOWN_PROFILE_ID"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.UNREGISTER.UNKNOWN_PROFILE_ID)" />

          <event value="1007"
             symbol="CCP_TRACE_UNREGISTER_DEINIT_MPN"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.UNREGISTER.DEINIT_MPN)" />

          <event value="1008"
             symbol="CCP_TRACE_UNREGISTER_CURRENTLY_LATCH_ON"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.UNREGISTER.CURRENTLY_LATCH_ON)" />

          <event value="1009"
             symbol="CCP_TRACE_UNREGISTER_CURRENTLY_LATCH_OFF"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.UNREGISTER.CURRENTLY_LATCH_OFF)" />

          <event value="1010"
             symbol="CCP_TRACE_UNREGISTER_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.UNREGISTER.SUCCEEDED)" />

          <event value="1011"
             symbol="CCP_TRACE_UNREGISTER_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.UNREGISTER.FAILED)" />

          <event value="1012"
             symbol="CCP_TRACE_TRYGETPUSHDATA_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="UInt32_X_2"
             level="win:Informational"
             message="$(string.CCP.TRYGETPUSHDATA.INFO)" />

          <event value="1013"
             symbol="CCP_TRACE_TRYGETPUSHDATA_RECORD_COUNT"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="UInt32"
             level="win:Informational"
             message="$(string.CCP.TRYGETPUSHDATA.RECORD_COUNT)" />

          <event value="1014"
             symbol="CCP_TRACE_TRYGETPUSHDATA_INSUFFICIENTBUFFER"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="UInt32_X_2"
             level="win:Informational"
             message="$(string.CCP.TRYGETPUSHDATA.INSUFFICIENTBUFFER)" />

          <event value="1015"
             symbol="CCP_TRACE_TRYGETPUSHDATA_SUFFICIENTBUFFER"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.TRYGETPUSHDATA.SUFFICIENTBUFFER)" />

          <event value="1016"
             symbol="CCP_TRACE_TRYGETPUSHDATA_MARK_ALREADY_READ"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.TRYGETPUSHDATA.MARK_ALREADY_READ)" />

          <event value="1017"
             symbol="CCP_TRACE_TRYGETPUSHDATA_WNF_RESET_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.TRYGETPUSHDATA.WNF_RESET_FAILED)" />

          <event value="1018"
             symbol="CCP_TRACE_TRYGETPUSHDATA_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="String"
             level="win:Informational"
             message="$(string.CCP.TRYGETPUSHDATA.SUCCEEDED)" />
          
          <event value="1019"
             symbol="CCP_TRACE_TRYGETPUSHDATA_ERR_NO_MORE_ITEMS"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.TRYGETPUSHDATA.ERR_NO_MORE_ITEMS)" />

          <event value="1020"
             symbol="CCP_TRACE_TRYGETPUSHDATA_ERR_INSUFF_BUFFER"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.TRYGETPUSHDATA.ERR_INSUFF_BUFFER)" />

          <event value="1021"
             symbol="CCP_TRACE_TRYGETPUSHDATA_ERR_OTHERS"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.TRYGETPUSHDATA.ERR_OTHERS)" />

          <event value="1022"
             symbol="CCP_TRACE_RESETWNFSTATENAME_ERR"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.RESETWNFSTATENAME.ERR)" />

          <event value="1023"
             symbol="CCP_TRACE_INITMPNSLISTENER_ERR"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.INITMPNSLISTENER.ERR)" />

          <event value="1024"
             symbol="CCP_TRACE_DEINITMPNSLISTENER_ERR"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.DEINITMPNSLISTENER.ERR)" />

          <event value="1025"
             symbol="CCP_TRACE_INITSMSLISTENER_ERR"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.INITSMSLISTENER.ERR)" />

          <event value="1026"
             symbol="CCP_TRACE_ADDLISTENRECORD_ERR"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.ADDLISTENRECORD.ERR)" />

          <event value="1027"
               symbol="CCP_TRACE_UNREGISTER_DEINIT_WNS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.UNREGISTER.DEINIT_WNS)" />

          <event value="1028"
               symbol="CCP_TRACE_INITWNSLISTENER_ERR"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.INITWNSLISTENER.ERR)" />

          <event value="1029"
               symbol="CCP_TRACE_DEINITWNSLISTENER_ERR"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.DEINITWNSLISTENER.ERR)" />

          <!-- Main.cpp *************************************************************************** -->

          <event value="1050"
             symbol="CCP_TRACE_MAIN_ENSURE_SMS_REGISTERED_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.ENSURE_SMS_REGISTERED.INFO)" />

          <event value="1051"
             symbol="CCP_TRACE_MAIN_REG_SMS_CHANNEL_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.REG_SMS_CHANNEL.SUCCEEDED)" />

          <event value="1052"
             symbol="CCP_TRACE_MAIN_SMS_CHANNEL_ALREADY_REG"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.SMS_CHANNEL_ALREADY_REG)" />         
          
          <event value="1053"
             symbol="CCP_TRACE_MAIN_ENSURE_SMS_REGISTERED_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.MAIN.ENSURE_SMS_REGISTERED.FAILED)" />

          <event value="1054"
             symbol="CCP_TRACE_MAIN_DEINIT_PUSH_NOTIFICATION_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.DEINIT_PUSH_NOTIFICATION.INFO)" />

          <event value="1055"
             symbol="CCP_TRACE_MAIN_HANDLE_PECU_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLE_PECU.INFO)" />

          <event value="1056"
             symbol="CCP_TRACE_MAIN_NO_CLIENT_TO_LATCH"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.NO_CLIENT_TO_LATCH)" />

          <event value="1057"
             symbol="CCP_TRACE_MAIN_HAVE_MPN_CLIENT_NO_LATCH"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HAVE_MPN_CLIENT_NO_LATCH)" />

          <event value="1058"
             symbol="CCP_TRACE_MAIN_PROCESS_LATCH_OFF"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.PROCESS_LATCH_OFF)" />

          <event value="1059"
             symbol="CCP_TRACE_MAIN_NO_NEED_TO_LATCH_OFF"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.NO_NEED_TO_LATCH_OFF)" />

          <event value="1060"
             symbol="CCP_TRACE_MAIN_PROCESS_LATCH_ON"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.PROCESS_LATCH_ON)" />

          <event value="1061"
             symbol="CCP_TRACE_MAIN_NO_NEED_TO_LATCH_ON"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.NO_NEED_TO_LATCH_ON)" />

          <event value="1062"
             symbol="CCP_TRACE_MAIN_HANDLE_PECU_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.MAIN.HANDLE_PECU.FAILED)" />

          <event value="1063"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_SMS"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_SMS)" />

          <event value="1064"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_MPN"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_MPN)" />

          <event value="1065"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_SSU"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_SSU)" />

          <event value="1066"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_PECU"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_PECU)" />

          <event value="1067"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_STOPMPN"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_STOPMPN)" />

          <event value="1068"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_HU"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_HU)" />

          <event value="1069"
             symbol="CCP_TRACE_MAIN_ENABLE_HOURLY_UPDATE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.MAIN.ENABLE_HOURLY_UPDATE.FAILED)" />

          <event value="1070"
             symbol="CCP_TRACE_MAIN_SKIP_HOURLY_UPDATE"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.SKIP_HOURLY_UPDATE)" />

          <event value="1071"
             symbol="CCP_TRACE_MAIN_HOURLY_UPDATE_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HOURLY_UPDATE.SUCCEEDED)" />

          <event value="1072"
             symbol="CCP_TRACE_MAIN_SKIP_LATCH_ON"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.SKIP_LATCH_ON)" />

          <event value="1073"
             symbol="CCP_TRACE_MAIN_SKIP_DEINITIALIZATION"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.SKIP_DEINITIALIZATION)" />

          <event value="1074"
             symbol="CCP_TRACE_MAIN_SET_LATCH_STATE_OFF"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.SET_LATCH_STATE_OFF)" />

          <event value="1075"
             symbol="CCP_TRACE_MAIN_SET_LATCH_STATE_ON"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.SET_LATCH_STATE_ON)" />
            
        <event value="1076"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_WNS"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_WNS)" />
        
        <event value="1077"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_INIT_WNS"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_INIT_WNS)" />
            
        <event value="1078"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_DEINIT_WNS"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_DEINIT_WNS)" />

        <event value="1079"
             symbol="CCP_TRACE_MAIN_HANDLING_CCPEXE_WNS_REFRESH_CHANNEL_URI"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.MAIN.HANDLING_CCPEXE_WNS_REFRESH_CHANNEL_URI)" />

          <!-- CcpBase64Coder.cpp *************************************************************************** -->
          
          <event value="1080"
             symbol="CCP_TRACE_BASE64CODER_ENCODE_CSTRINGW_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.BASE64CODER.ENCODE_CSTRINGW.FAILED)" />

          <event value="1081"
             symbol="CCP_TRACE_BASE64CODER_ENCODE_BSTR_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.BASE64CODER.ENCODE_BSTR.FAILED)" />

          <event value="1082"
             symbol="CCP_TRACE_BASE64CODER_ENCODE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.BASE64CODER.ENCODE.FAILED)" />

          <event value="1083"
             symbol="CCP_TRACE_BASE64CODER_DECODE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.BASE64CODER.DECODE.FAILED)" />

          <!-- CcpCommandTable.cpp *************************************************************************** -->

          <event value="1100"
             symbol="CCP_TRACE_CMDTABLE_REC_INIT_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.REC_INIT.FAILED)" />

          <event value="1101"
             symbol="CCP_TRACE_CMDTABLE_REC_GETDATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.REC_GETDATA.FAILED)" />

          <event value="1102"
             symbol="CCP_TRACE_CMDTABLE_REC_ASSIGN_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.REC_ASSIGN.FAILED)" />

          <event value="1103"
             symbol="CCP_TRACE_CMDTABLE_TABLE_INIT_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.TABLE_INIT.FAILED)" />

          <event value="1104"
             symbol="CCP_TRACE_CMDTABLE_CREATE_UPDATE_REC_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.CREATE_UPDATE_REC.FAILED)" />

          <event value="1105"
             symbol="CCP_TRACE_CMDTABLE_SEEK_REQID_MATCH_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.SEEK_REQID_MATCH.FAILED)" />

          <event value="1106"
             symbol="CCP_TRACE_CMDTABLE_SEEK_OLDEST_TS_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.SEEK_OLDEST_TS.FAILED)" />

          <event value="1107"
             symbol="CCP_TRACE_CMDTABLE_SEEK_PROFILEID_TS_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.SEEK_PROFILEID_TS.FAILED)" />

          <event value="1108"
             symbol="CCP_TRACE_CMDTABLE_READ_BY_PROFILEID_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CMDTABLE.READ_BY_PROFILEID.INFO)" />

          <event value="1109"
             symbol="CCP_TRACE_CMDTABLE_READ_BY_PROFILEID_ERRSEEK"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.READ_BY_PROFILEID.ERRSEEK)" />

          <event value="1110"
             symbol="CCP_TRACE_CMDTABLE_READ_BY_PROFILEID_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.READ_BY_PROFILEID.FAILED)" />
          
          <event value="1111"
             symbol="CCP_TRACE_CMDTABLE_WRITE_REC_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CMDTABLE.WRITE_REC.INFO)" />

          <event value="1112"
             symbol="CCP_TRACE_CMDTABLE_WRITE_REC_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.WRITE_REC.FAILED)" />

          <event value="1113"
             symbol="CCP_TRACE_CMDTABLE_DELETE_PROFILE_REC_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.DELETE_PROFILE_REC.FAILED)" />

          <event value="1114"
             symbol="CCP_TRACE_CMDTABLE_DELETE_OLDEST_REC_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.DELETE_OLDEST_REC.FAILED)" />

          <event value="1115"
             symbol="CCP_TRACE_CMDTABLE_CLEAR_TABLE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.CLEAR_TABLE.FAILED)" />

          <event value="1116"
             symbol="CCP_TRACE_CMDTABLE_REC_COUNT_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.REC_COUNT.FAILED)" />

          <event value="1117"
             symbol="CCP_TRACE_CMDTABLE_UPDATE_PROFILELIST_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.UPDATE_PROFILELIST.FAILED)" />
         
          <event value="1118"
             symbol="CCP_TRACE_CMDTABLE_ENUMERATE_HELPER_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.ENUMERATE_HELPER.FAILED)" />

          <event value="1119"
             symbol="CCP_TRACE_CMDTABLE_DELETE_RECDATAFILES_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.DELETE_RECDATAFILES.FAILED)" />

          <event value="1120"
             symbol="CCP_TRACE_CMDTABLE_DELETE_RECDATAFILE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.DELETE_RECDATAFILE.FAILED)" />

          <event value="1121"
             symbol="CCP_TRACE_CMDTABLE_FIND_AND_DELETE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CMDTABLE.FIND_AND_DELETE.FAILED)" />

          <!-- CcpCore.cpp *************************************************************************** -->
          
          <event value="1150"
             symbol="CCP_TRACE_CORE_RPC_STRING_BINDING_COMPOSE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.RPC_STRING_BINDING_COMPOSE.FAILED)" />

          <event value="1151"
             symbol="CCP_TRACE_CORE_RPC_BINDING_FROM_STR_BINDING_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.RPC_BINDING_FROM_STR_BINDING.FAILED)" />

          <event value="1152"
             symbol="CCP_TRACE_CORE_QUERY_TRANSIENT_OBJ_SEC_DESC_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.QUERY_TRANSIENT_OBJ_SEC_DESC.FAILED)" />

          <event value="1153"
             symbol="CCP_TRACE_CORE_RPC_BINDING_SET_AUTH_INFO_EX_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.RPC_BINDING_SET_AUTH_INFO_EX.FAILED)" />

          <event value="1154"
             symbol="CCP_TRACE_CORE_HANDLE_SMS_COMMAND_DATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.HANDLE_SMS_COMMAND_DATA.FAILED)" />

          <event value="1155"
             symbol="CCP_TRACE_CORE_RPC_EXCEPTION_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.RPC_EXCEPTION.FAILED)" />

          <event value="1156"
             symbol="CCP_TRACE_CORE_HANDLE_SMS_NOTIFICATION_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.HANDLE_SMS_NOTIFICATION.FAILED)" />

          <event value="1157"
             symbol="CCP_TRACE_CORE_REG_NOTIFICATION_CHANNEL_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="String"
             level="win:Informational"
             message="$(string.CCP.CORE.REG_NOTIFICATION_CHANNEL.INFO)" />

          <event value="1158"
             symbol="CCP_TRACE_CORE_REG_NOTIFICATION_CHANNEL_BYTE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.REG_NOTIFICATION_CHANNEL_BYTE.FAILED)" />

          <event value="1159"
             symbol="CCP_TRACE_CORE_MPN_REGSTATE_ALREADY_ON"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.MPN_REGSTATE_ALREADY_ON)" />

          <event value="1160"
             symbol="CCP_TRACE_CORE_SAME_CHANNEL_WAS_REG_BEFORE"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SAME_CHANNEL_WAS_REG_BEFORE)" />
          
          <event value="1161"
             symbol="CCP_TRACE_CORE_REG_NOTIFICATION_SENDHTTPREQ_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="UInt32"
             level="win:Error"
             message="$(string.CCP.CORE.REG_NOTIFICATION_SENDHTTPREQ.FAILED)" />

          <event value="1162"
             symbol="CCP_TRACE_CORE_REG_NOTIFICATION_RESET_URL_TO_EMPTY"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.REG_NOTIFICATION_RESET_URL_TO_EMPTY)" />
          
          <event value="1163"
             symbol="CCP_TRACE_CORE_REG_NOTIFICATION_RESET_REGSTATE_0"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.REG_NOTIFICATION_RESET_REGSTATE_0)" />

          <event value="1164"
             symbol="CCP_TRACE_CORE_REG_NOTIFICATION_RESET_LATCHSTATE_0"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.REG_NOTIFICATION_RESET_LATCHSTATE_0)" />
        
          <event value="1165"
             symbol="CCP_TRACE_CORE_REG_NOTIFICATION_CHANNEL_WCHAR_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.REG_NOTIFICATION_CHANNEL_WCHAR.FAILED)" />

          <event value="1166"
             symbol="CCP_TRACE_CORE_CREATE_REQUEST_BODY_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.CREATE_REQUEST_BODY.FAILED)" />

          <event value="1167"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA.INFO)" />

          <event value="1168"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_DECODE_SMS"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA_DECODE_SMS)" />

          <event value="1169"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_DECODE_MPN"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA_DECODE_MPN)" />

          <event value="1170"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_DECODED_IDS"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA_DECODED_IDS)" />

          <event value="1171"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_UNKNOWN_ID"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             template="UInt32"
             level="win:Informational"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA_UNKNOWN_ID)" />

          <event value="1172"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_DECODED_TS_CMD"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA_DECODED_TS_CMD)" />

          <event value="1173"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_LARGE_SIZE"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA_LARGE_SIZE)" />

          <event value="1174"
             symbol="CCP_TRACE_CORE_HANDLE_COMMAND_DATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.HANDLE_COMMAND_DATA.FAILED)" />

          <event value="1175"
             symbol="CCP_TRACE_CORE_STORE_CMD_TO_TABLE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.STORE_CMD_TO_TABLE.FAILED)" />

          <event value="1176"
             symbol="CCP_TRACE_CORE_STORE_CMD_TO_TABLE_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.STORE_CMD_TO_TABLE.SUCCEEDED)" />

          <event value="1177"
             symbol="CCP_TRACE_CORE_PROCESS_PUSH_CONTENT_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.PROCESS_PUSH_CONTENT.INFO)" />

          <event value="1178"
             symbol="CCP_TRACE_CORE_PROCESS_PUSH_CONTENT_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.PROCESS_PUSH_CONTENT.SUCCEEDED)" />

          <event value="1179"
             symbol="CCP_TRACE_CORE_PROCESS_PUSH_CONTENT_TOOLARGE"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.PROCESS_PUSH_CONTENT.TOOLARGE)" />

          <event value="1180"
             symbol="CCP_TRACE_CORE_PROCESS_PUSH_CONTENT_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.PROCESS_PUSH_CONTENT.FAILED)" />

          <event value="1181"
             symbol="CCP_TRACE_CORE_SENDACK_NOTIFICATION_ACK"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_NOTIFICATION_ACK)" />

          <event value="1182"
             symbol="CCP_TRACE_CORE_SENDACK_DATA_ACK"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_DATA_ACK)" />

          <event value="1183"
             symbol="CCP_TRACE_CORE_SENDACK_NO_PARTNER_APP"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_NO_PARTNER_APP)" />

          <event value="1184"
             symbol="CCP_TRACE_CORE_SENDACK_FAILED_TO_DOWNLOAD_HTTP"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_FAILED_TO_DOWNLOAD_HTTP)" />

          <event value="1185"
             symbol="CCP_TRACE_CORE_SENDACK_FAILED_TO_DOWNLOAD_NETWORK"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_FAILED_TO_DOWNLOAD_NETWORK)" />

          <event value="1186"
             symbol="CCP_TRACE_CORE_SENDACK_FAILED_TO_DOWNLOAD_ROAMING"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_FAILED_TO_DOWNLOAD_ROAMING)" />

          <event value="1187"
             symbol="CCP_TRACE_CORE_SENDACK_OUT_OF_DISK_SPACE"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_OUT_OF_DISK_SPACE)" />

          <event value="1188"
             symbol="CCP_TRACE_CORE_SENDACK_DATA_TOO_LARGE"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_DATA_TOO_LARGE)" />

          <event value="1189"
             symbol="CCP_TRACE_CORE_SENDACK_UNEXPECTED_VALUE"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.SENDACK_UNEXPECTED_VALUE)" />

          <event value="1190"
             symbol="CCP_TRACE_CORE_SENDACK_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.SENDACK.FAILED)" />

          <event value="1191"
             symbol="CCP_TRACE_CORE_NOTIFY_CLIENT_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.NOTIFY_CLIENT.FAILED)" />
          
          <event value="1192"
             symbol="CCP_TRACE_CORE_NOTIFY_CLIENT_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CORE.NOTIFY_CLIENT.SUCCEEDED)" />
          
          <event value="1193"
             symbol="CCP_TRACE_CORE_GET_APPHIVE_HANDLE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CORE.GET_APPHIVE_HANDLE.FAILED)" />
        
        <!-- CcpCrypto.cpp *************************************************************************** -->
        
          <event value="1200"
             symbol="CCP_TRACE_CRYPTO_ENCRYPTDATA_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.ENCRYPTDATA.INFO)" />

          <event value="1201"
             symbol="CCP_TRACE_CRYPTO_ENCRYPTDATA_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.ENCRYPTDATA.SUCCEEDED)" />

          <event value="1202"
             symbol="CCP_TRACE_CRYPTO_ENCRYPTDATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.ENCRYPTDATA.FAILED)" />

          <event value="1203"
             symbol="CCP_TRACE_CRYPTO_DECRYPTDATA_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.DECRYPTDATA.INFO)" />

          <event value="1204"
             symbol="CCP_TRACE_CRYPTO_DECRYPTDATA_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.DECRYPTDATA.SUCCEEDED)" />

          <event value="1205"
             symbol="CCP_TRACE_CRYPTO_DECRYPTDATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.DECRYPTDATA.FAILED)" />

          <event value="1206"
             symbol="CCP_TRACE_CRYPTO_PROTECTDATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.PROTECTDATA.FAILED)" />

          <event value="1207"
             symbol="CCP_TRACE_CRYPTO_UNPROTECTDATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.UNPROTECTDATA.FAILED)" />

          <event value="1208"
             symbol="CCP_TRACE_CRYPTO_COMPUTEHMAC_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.COMPUTEHMAC.INFO)" />

          <event value="1209"
             symbol="CCP_TRACE_CRYPTO_COMPUTEHMAC_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.COMPUTEHMAC.SUCCEEDED)" />

          <event value="1210"
             symbol="CCP_TRACE_CRYPTO_COMPUTEHMAC_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.COMPUTEHMAC.FAILED)" />

          <event value="1211"
             symbol="CCP_TRACE_CRYPTO_GETPROVIDER_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.GETPROVIDER.FAILED)" />

          <event value="1212"
             symbol="CCP_TRACE_CRYPTO_CREATEHASH_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.CREATEHASH.FAILED)" />

          <event value="1213"
             symbol="CCP_TRACE_CRYPTO_HASHDATA_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.HASHDATA.FAILED)" />

         <event value="1215"
             symbol="CCP_TRACE_CRYPTO_DERIVEKEY_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.DERIVEKEY.FAILED)" />

         <event value="1216"
             symbol="CCP_TRACE_CRYPTO_ENCRYPT_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.ENCRYPT.INFO)" />

         <event value="1217"
             symbol="CCP_TRACE_CRYPTO_ENCRYPT_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.ENCRYPT.SUCCEEDED)" />

          <event value="1218"
             symbol="CCP_TRACE_CRYPTO_ENCRYPT_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.ENCRYPT.FAILED)" />

          <event value="1219"
             symbol="CCP_TRACE_CRYPTO_DECRYPT_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.DECRYPT.INFO)" />

          <event value="1220"
             symbol="CCP_TRACE_CRYPTO_DECRYPT_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.CRYPTO.DECRYPT.SUCCEEDED)" />

          <event value="1221"
             symbol="CCP_TRACE_CRYPTO_DECRYPT_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.DECRYPT.FAILED)" />

          <event value="1222"
             symbol="CCP_TRACE_CRYPTO_GETHASHVALUE_FAILED"
             task="CCP_TRACE_ERROR"
             keywords="ERROR"
             template="Hr"
             level="win:Error"
             message="$(string.CCP.CRYPTO.GETHASHVALUE.FAILED)" />

          <!-- CcpListenTable.cpp *************************************************************************** -->
          
          <event value="1250"
               symbol="CCP_TRACE_LISTENTABLE_TABLE_INIT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.TABLE_INIT.FAILED)" />

          <event value="1251"
               symbol="CCP_TRACE_LISTENTABLE_CREATE_UPDATE_RECORD_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.CREATE_UPDATE_RECORD.FAILED)" />

          <event value="1252"
               symbol="CCP_TRACE_LISTENTABLE_READ_REC_BY_PROFILEID_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               template="UInt32"
               level="win:Informational"
               message="$(string.CCP.LISTENTABLE.READ_REC_BY_PROFILEID.INFO)" />
          
          <event value="1253"
               symbol="CCP_TRACE_LISTENTABLE_READ_REC_BY_PROFILEID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.READ_REC_BY_PROFILEID.FAILED)" />

          <event value="1254"
               symbol="CCP_TRACE_LISTENTABLE_WRITE_REC_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.WRITE_REC.FAILED)" />

          <event value="1255"
               symbol="CCP_TRACE_LISTENTABLE_DELETE_REC_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.DELETE_REC.FAILED)" />

          <event value="1256"
               symbol="CCP_TRACE_LISTENTABLE_CLEAR_TABLE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.CLEAR_TABLE.FAILED)" />

          <event value="1257"
               symbol="CCP_TRACE_LISTENTABLE_RECORD_COUNT"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               template="UInt32"
               level="win:Informational"
               message="$(string.CCP.LISTENTABLE.RECORD_COUNT)" />

          <event value="1258"
               symbol="CCP_TRACE_LISTENTABLE_RECORD_COUNT_NO_RECORD"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.LISTENTABLE.RECORD_COUNT_NO_RECORD)" />
          
          <event value="1259"
               symbol="CCP_TRACE_LISTENTABLE_RECORD_COUNT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.RECORD_COUNT.FAILED)" />

          <event value="1260"
               symbol="CCP_TRACE_LISTENTABLE_ALLOWED_MPN_REC_COUNT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.ALLOWED_MPN_REC_COUNT.FAILED)" />

           <event value="1261"
               symbol="CCP_TRACE_LISTENTABLE_ALLOWED_WNS_REC_COUNT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LISTENTABLE.ALLOWED_WNS_REC_COUNT.FAILED)" />

          <!-- CcpMPNSListener.cpp *************************************************************************** -->

          <event value="1300"
               symbol="CCP_TRACE_MPNLISTENER_INIT_STATE_ALREADY_IN_PROGRESS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.INIT_STATE_ALREADY_IN_PROGRESS)" />

          <event value="1301"
               symbol="CCP_TRACE_MPNLISTENER_SET_INIT_STATE_TO_IN_PROGRESS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.SET_INIT_STATE_TO_IN_PROGRESS)" />

          <event value="1302"
               symbol="CCP_TRACE_MPNLISTENER_WAITING_FOR_DEINIT_COMPLETE"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.WAITING_FOR_DEINIT_COMPLETE)" />

          <event value="1303"
               symbol="CCP_TRACE_MPNLISTENER_DEINIT_COMPLETE_TIMEOUT"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.DEINIT_COMPLETE_TIMEOUT)" />
          
          <event value="1304"
               symbol="CCP_TRACE_MPNLISTENER_DEINIT_STILL_IN_PROGRESS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.DEINIT_STILL_IN_PROGRESS)" />

          <event value="1305"
               symbol="CCP_TRACE_MPNLISTENER_RESET_TO_NOT_IN_PROGRESS_FAILED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.RESET_TO_NOT_IN_PROGRESS_FAILED)" />

          <event value="1306"
               symbol="CCP_TRACE_MPNLISTENER_RESET_TO_NOT_IN_PROGRESS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.RESET_TO_NOT_IN_PROGRESS)" />

          <event value="1307"
               symbol="CCP_TRACE_MPNLISTENER_ABORT_IS_SET_START_DEINIT"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.ABORT_IS_SET_START_DEINIT)" />

          <event value="1308"
               symbol="CCP_TRACE_MPNLISTENER_DEINIT_DONE_SUCESSFULLY"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.DEINIT_DONE_SUCESSFULLY)" />

          <event value="1309"
               symbol="CCP_TRACE_MPNLISTENER_INIT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.INIT.FAILED)" />
          
          <event value="1310"
               symbol="CCP_TRACE_MPNLISTENER_DEINIT_ALREADY_IN_PROGRESS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.DEINIT_ALREADY_IN_PROGRESS)" />

          <event value="1311"
               symbol="CCP_TRACE_MPNLISTENER_SET_DEINIT_STATE_TO_IN_PROGRESS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.SET_DEINIT_STATE_TO_IN_PROGRESS)" />

          <event value="1312"
               symbol="CCP_TRACE_MPNLISTENER_RESET_ABORT_EVENT"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.RESET_ABORT_EVENT)" />

          <event value="1313"
               symbol="CCP_TRACE_MPNLISTENER_DEINIT_SUCCEEDED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.DEINIT_SUCCEEDED)" />

          <event value="1314"
               symbol="CCP_TRACE_MPNLISTENER_RESET_DEINIT_STATE"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.RESET_DEINIT_STATE)" />
          
          <event value="1315"
               symbol="CCP_TRACE_MPNLISTENER_DEINIT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.DEINIT.FAILED)" />

          <event value="1316"
               symbol="CCP_TRACE_MPNLISTENER_CREATE_ENDPOINT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.CREATE_ENDPOINT.FAILED)" />
          
          <event value="1317"
               symbol="CCP_TRACE_MPNLISTENER_CONNECT_ENDPOINT_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.CONNECT_ENDPOINT.INFO)" />

          <event value="1318"
               symbol="CCP_TRACE_MPNLISTENER_CONNECT_ENDPOINT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.CONNECT_ENDPOINT.FAILED)" />

          <event value="1319"
               symbol="CCP_TRACE_MPNLISTENER_CLOSE_ENDPOINT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.CLOSE_ENDPOINT.FAILED)" />

          <event value="1320"
               symbol="CCP_TRACE_MPNLISTENER_EVENT_DISCONNECTED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.EVENT_DISCONNECTED)" />

          <event value="1321"
               symbol="CCP_TRACE_MPNLISTENER_EVENT_DESCRIPTOR_READY"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.EVENT_DESCRIPTOR_READY)" />

          <event value="1322"
               symbol="CCP_TRACE_MPNLISTENER_EVENT_MESSAGE_WAITING"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.EVENT_MESSAGE_WAITING)" />

          <event value="1323"
               symbol="CCP_TRACE_MPNLISTENER_EVENT_ERROR"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.EVENT_ERROR)" />

          <event value="1324"
               symbol="CCP_TRACE_MPNLISTENER_HANDLE_PUSH_NOTIFICATION_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.HANDLE_PUSH_NOTIFICATION.FAILED)" />

          <event value="1325"
               symbol="CCP_TRACE_MPNLISTENER_WAITFOREVENT_ABORTED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.WAITFOREVENT_ABORTED)" />

          <event value="1326"
               symbol="CCP_TRACE_MPNLISTENER_WAITFOREVENT_TIMEOUT"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.WAITFOREVENT_TIMEOUT)" />

          <event value="1327"
               symbol="CCP_TRACE_MPNLISTENER_WAITFOREVENT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.WAITFOREVENT.FAILED)" />
          
          <event value="1328"
               symbol="CCP_TRACE_MPNLISTENER_DO_REGISTER_CHANNEL_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.DO_REGISTER_CHANNEL.INFO)" />

          <event value="1329"
               symbol="CCP_TRACE_MPNLISTENER_DO_REGISTER_CHANNEL_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.DO_REGISTER_CHANNEL.FAILED)" />
          
          <event value="1330"
               symbol="CCP_TRACE_MPNLISTENER_SET_LATCH_STATE_OFF"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.SET_LATCH_STATE_OFF)" />

          <event value="1331"
               symbol="CCP_TRACE_MPNLISTENER_SET_LATCH_STATE_ON"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.SET_LATCH_STATE_ON)" />

          <event value="1332"
               symbol="CCP_TRACE_MPNLISTENER_UPDATE_LATCH_STATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.UPDATE_LATCH_STATE.FAILED)" />
          
          <event value="1333"
               symbol="CCP_TRACE_MPNLISTENER_HANDLE_PUSH_MESSAGE_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.HANDLE_PUSH_MESSAGE.INFO)" />

          <event value="1334"
               symbol="CCP_TRACE_MPNLISTENER_VALID_NOTIFICATION_RECEIVED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.MPNLISTENER.VALID_NOTIFICATION_RECEIVED)" />

          <event value="1335"
               symbol="CCP_TRACE_MPNLISTENER_HANDLE_PUSH_MESSAGE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.HANDLE_PUSH_MESSAGE.FAILED)" />

          <event value="1336"
               symbol="CCP_TRACE_MPNLISTENER_GET_ACTIVEENDPOINTCOUNT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.MPNLISTENER.GET_ACTIVEENDPOINTCOUNT.FAILED)" />

          <!-- CcpSharedSecret.cpp *************************************************************************** -->

          <event value="1350"
               symbol="CCP_TRACE_SHAREDSECRET_CURRENT_ID_MISSING_OR_INVALID"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.CURRENT_ID_MISSING_OR_INVALID)" />

          <event value="1351"
               symbol="CCP_TRACE_SHAREDSECRET_UPDATING_ID_MISSING_OR_INVALID"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.UPDATING_ID_MISSING_OR_INVALID)" />

          <event value="1352"
               symbol="CCP_TRACE_SHAREDSECRET_INVALID_SHAREDSECRET"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.INVALID_SHAREDSECRET)" />

          <event value="1353"
               symbol="CCP_TRACE_SHAREDSECRET_EXPIRATION_DATE_MISSING"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.EXPIRATION_DATE_MISSING)" />

          <event value="1354"
               symbol="CCP_TRACE_SHAREDSECRET_SHAREDDSERET_EXPIRED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.SHAREDDSERET_EXPIRED)" />

          <event value="1355"
               symbol="CCP_TRACE_SHAREDSECRET_SHAREDDSERET_UPDATED_SUCCEEDED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.SHAREDDSERET_UPDATED.SUCCEEDED)" />

          <event value="1356"
               symbol="CCP_TRACE_SHAREDSECRET_SHAREDDSERET_CREATED_SUCCEEDED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.SHAREDDSERET_CREATED.SUCCEEDED)" />

          <event value="1357"
               symbol="CCP_TRACE_SHAREDSECRET_EXTENDED_EXPIRATION_DATE_SUCCEEDED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.EXTENDED_EXPIRATION_DATE.SUCCEEDED)" />

          <event value="1358"
               symbol="CCP_TRACE_SHAREDSECRET_ENSURE_SHARESECRET_SETTING_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRET.ENSURE_SHARESECRET_SETTING.FAILED)" />

          <event value="1359"
               symbol="CCP_TRACE_SHAREDSECRET_GET_SHAREDSECRET_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRET.GET_SHAREDSECRET.FAILED)" />

          <event value="1360"
               symbol="CCP_TRACE_SHAREDSECRET_GET_UNPROTECTED_SECRET_LEN_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRET.GET_UNPROTECTED_SECRET_LEN.FAILED)" />

          <event value="1361"
               symbol="CCP_TRACE_SHAREDSECRET_CHECK_IF_SECRET_IS_VALID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRET.CHECK_IF_SECRET_IS_VALID.FAILED)" />

          <event value="1362"
               symbol="CCP_TRACE_SHAREDSECRET_RENEW_SECRET_EXPIRATION_DATE"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               template="String"
               level="win:Informational"
               message="$(string.CCP.SHAREDSECRET.RENEW_SECRET_EXPIRATION_DATE)" />

          <event value="1363"
               symbol="CCP_TRACE_SHAREDSECRET_RENEW_SECRET_EXPIRATION_DATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRET.RENEW_SECRET_EXPIRATION_DATE.FAILED)" />

          <event value="1364"
               symbol="CCP_TRACE_SHAREDSECRET_SET_UPDATING_TO_CURRENT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRET.SET_UPDATING_TO_CURRENT.FAILED)" />

          <event value="1365"
               symbol="CCP_TRACE_SHAREDSECRET_UPDATE_SHAREDSECRET_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRET.UPDATE_SHAREDSECRET.FAILED)" />

          <!-- TaskRequestParserImpl.cpp *************************************************************************** -->
          
          <event value="1400"
               symbol="CCP_TRACE_TASKREQUESTPARSER_CREATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTPARSER.CREATE.FAILED)" />

          <event value="1401"
               symbol="CCP_TRACE_TASKREQUESTPARSER_PARSEREQUEST_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.TASKREQUESTPARSER.PARSEREQUEST.INFO)" />
          
          <event value="1402"
               symbol="CCP_TRACE_TASKREQUESTPARSER_PARSEREQUEST_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTPARSER.PARSEREQUEST.FAILED)" />

          <event value="1403"
               symbol="CCP_TRACE_TASKREQUESTPARSER_DECRYPTCOMMAND_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.TASKREQUESTPARSER.DECRYPTCOMMAND.INFO)" />

          <event value="1404"
               symbol="CCP_TRACE_TASKREQUESTPARSER_RECEIVED_ID_IS_UPDATING_SEC_ID"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.TASKREQUESTPARSER.RECEIVED_ID_IS_UPDATING_SEC_ID)" />

          <event value="1405"
               symbol="CCP_TRACE_TASKREQUESTPARSER_UPDATED_CURRENT_SEC_ID"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.TASKREQUESTPARSER.UPDATED_CURRENT_SEC_ID)" />

          <event value="1406"
               symbol="CCP_TRACE_TASKREQUESTPARSER_RECEIVED_ID_IS_CURRENT_SEC_ID"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.TASKREQUESTPARSER.RECEIVED_ID_IS_CURRENT_SEC_ID)" />

          <event value="1407"
               symbol="CCP_TRACE_TASKREQUESTPARSER_DECRYPT_SUCCEEDED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.TASKREQUESTPARSER.DECRYPT.SUCCEEDED)" />
          
          <event value="1408"
               symbol="CCP_TRACE_TASKREQUESTPARSER_DECRYPTCOMMAND_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTPARSER.DECRYPTCOMMAND.FAILED)" />

          <event value="1409"
               symbol="CCP_TRACE_TASKREQUESTPARSER_COPYBYTES_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTPARSER.COPYBYTES.FAILED)" />

          <event value="1410"
               symbol="CCP_TRACE_TASKREQUESTPARSER_CHECK_DATA_INTEGRITY_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTPARSER.CHECK_DATA_INTEGRITY.FAILED)" />

          <!-- ccpHttpRequest.cpp *************************************************************************** -->

          <event value="1450"
               symbol="CCP_TRACE_HTTPREQUEST_URL_FROM_EPD_IS_NULL"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.URL_FROM_EPD_IS_NULL)" />

          <event value="1451"
               symbol="CCP_TRACE_HTTPREQUEST_URL_FROM_EPD"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               template="String"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.URL_FROM_EPD)" />

          <event value="1452"
               symbol="CCP_TRACE_HTTPREQUEST_HTTP_CONNECT"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.HTTP_CONNECT)" />

          <event value="1453"
               symbol="CCP_TRACE_HTTPREQUEST_SENDING_REQUEST"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.SENDING_REQUEST)" />

          <event value="1454"
               symbol="CCP_TRACE_HTTPREQUEST_RECEIVING_RESPONSE"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.RECEIVING_RESPONSE)" />

          <event value="1455"
               symbol="CCP_TRACE_HTTPREQUEST_QUERY_RESPONSE"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.QUERY_RESPONSE)" />

          <event value="1456"
               symbol="CCP_TRACE_HTTPREQUEST_HTTPSTATUS"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               template="UInt32"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.HTTPSTATUS)" />

          <event value="1457"
               symbol="CCP_TRACE_HTTPREQUEST_GETTING_CONTENTSIZE"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.GETTING_CONTENTSIZE)" />

          <event value="1458"
               symbol="CCP_TRACE_HTTPREQUEST_GETTING_DATA"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HTTPREQUEST.GETTING_DATA)" />

          <event value="1459"
               symbol="CCP_TRACE_HTTPREQUEST_SEND_REQUEST_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HTTPREQUEST.SEND_REQUEST.FAILED)" />

          <event value="1460"
               symbol="CCP_TRACE_HTTPREQUEST_GET_HTTP_DATA_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HTTPREQUEST.GET_HTTP_DATA.FAILED)" />

          <event value="1461"
               symbol="CCP_TRACE_HTTPREQUEST_SET_DEFAULT_TIMEOUT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HTTPREQUEST.SET_DEFAULT_TIMEOUT.FAILED)" />

          <event value="1462"
               symbol="CCP_TRACE_HTTPREQUEST_GET_CONTENT_SIZE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HTTPREQUEST.GET_CONTENT_SIZE.FAILED)" />

          <event value="1463"
               symbol="CCP_TRACE_HTTPREQUEST_READ_DATA_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HTTPREQUEST.READ_DATA.FAILED)" />

          <event value="1464"
               symbol="CCP_TRACE_HTTPREQUEST_READ_DATA_GREATER_THAN_1K_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HTTPREQUEST.READ_DATA_GREATER_THAN_1K.FAILED)" />

          <!-- ccpHardwareCert.cpp *************************************************************************** --> 

          <event value="1490"
               symbol="CCP_TRACE_HARDWARECERT_CERTOPENSTORE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HARDWARECERT.CERTOPENSTORE.FAILED)" />
          
          <event value="1491"
               symbol="CCP_TRACE_HARDWARECERT_FOUNDCERT"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.HARDWARECERT.FOUNDCERT)" />

          <event value="1492"
               symbol="CCP_TRACE_HARDWARECERT_CERTFINDCERTIFICATEINSTORE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.HARDWARECERT.CERTFINDCERTIFICATEINSTORE.FAILED)" />

          <!-- ccpHardwareCert.cpp *************************************************************************** -->

          <event value="1500"
               symbol="CCP_TRACE_SETTINGS_GETPUSHCOOKIE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETPUSHCOOKIE.FAILED)" />

          <event value="1501"
               symbol="CCP_TRACE_SETTINGS_SETPUSHCOOKIE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETPUSHCOOKIE.FAILED)" />

          <event value="1502"
               symbol="CCP_TRACE_SETTINGS_GETNOTIFICATIONURI_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETNOTIFICATIONURI.FAILED)" />

          <event value="1503"
               symbol="CCP_TRACE_SETTINGS_SETNOTIFICATIONURI_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETNOTIFICATIONURI.FAILED)" />

          <event value="1504"
               symbol="CCP_TRACE_SETTINGS_GETPENDINGMPNURI_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETPENDINGMPNURI.FAILED)" />

          <event value="1505"
               symbol="CCP_TRACE_SETTINGS_SETPENDINGMPNURI_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETPENDINGMPNURI.FAILED)" />

          <event value="1506"
               symbol="CCP_TRACE_SETTINGS_GETSHAREDSECRETUPDATEFREQ_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETSHAREDSECRETUPDATEFREQ.FAILED)" />

          <event value="1507"
               symbol="CCP_TRACE_SETTINGS_SETSHAREDSECRETUPDATEFREQ_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETSHAREDSECRETUPDATEFREQ.FAILED)" />

          <event value="1508"
               symbol="CCP_TRACE_SETTINGS_GETCURRENTSECRETID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETCURRENTSECRETID.FAILED)" />

          <event value="1509"
               symbol="CCP_TRACE_SETTINGS_SETCURRENTSECRETID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETCURRENTSECRETID.FAILED)" />

          <event value="1510"
               symbol="CCP_TRACE_SETTINGS_GETUPDATINGSECRETID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETUPDATINGSECRETID.FAILED)" />

          <event value="1511"
               symbol="CCP_TRACE_SETTINGS_SETUPDATINGSECRETID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETUPDATINGSECRETID.FAILED)" />
          
          <event value="1512"
               symbol="CCP_TRACE_SETTINGS_GETSHAREDSECRETEXPIRATIIONDATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETSHAREDSECRETEXPIRATIIONDATE.FAILED)" />

          <event value="1513"
               symbol="CCP_TRACE_SETTINGS_SETSHAREDSECRETEXPIRATIIONDATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETSHAREDSECRETEXPIRATIIONDATE.FAILED)" />

          <event value="1514"
               symbol="CCP_TRACE_SETTINGS_GETMPNLATCHINGSTATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETMPNLATCHINGSTATE.FAILED)" />

          <event value="1515"
               symbol="CCP_TRACE_SETTINGS_SETMPNLATCHINGSTATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETMPNLATCHINGSTATE.FAILED)" />
          
          <event value="1516"
               symbol="CCP_TRACE_SETTINGS_GETENDPOINTSERVICENAME_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETENDPOINTSERVICENAME.FAILED)" />

          <event value="1517"
               symbol="CCP_TRACE_SETTINGS_SETENDPOINTSERVICENAME_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETENDPOINTSERVICENAME.FAILED)" />

          <event value="1518"
               symbol="CCP_TRACE_SETTINGS_GETCCPMONIKER_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETCCPMONIKER.FAILED)" />

          <event value="1519"
               symbol="CCP_TRACE_SETTINGS_SETCCPMONIKER_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETCCPMONIKER.FAILED)" />

          <event value="1520"
               symbol="CCP_TRACE_SETTINGS_GETMPNREGISTRATIONSTATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETMPNREGISTRATIONSTATE.FAILED)" />

          <event value="1521"
               symbol="CCP_TRACE_SETTINGS_SETMPNREGISTRATIONSTATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETMPNREGISTRATIONSTATE.FAILED)" />

          <event value="1522"
               symbol="CCP_TRACE_SETTINGS_GETSMSREGISTRATIONSTATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETSMSREGISTRATIONSTATE.FAILED)" />

          <event value="1523"
               symbol="CCP_TRACE_SETTINGS_SETSMSREGISTRATIONSTATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETSMSREGISTRATIONSTATE.FAILED)" />

          <event value="1524"
               symbol="CCP_TRACE_SETTINGS_GETMAXCOMMANDINTABLE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETMAXCOMMANDINTABLE.FAILED)" />

          <event value="1525"
               symbol="CCP_TRACE_SETTINGS_SETMAXCOMMANDINTABLE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETMAXCOMMANDINTABLE.FAILED)" />

          <event value="1526"
               symbol="CCP_TRACE_SETTINGS_GETISMPNINITINPROGRESS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETISMPNINITINPROGRESS.FAILED)" />

          <event value="1527"
               symbol="CCP_TRACE_SETTINGS_SETISMPNINITINPROGRESS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETISMPNINITINPROGRESS.FAILED)" />

          <event value="1528"
               symbol="CCP_TRACE_SETTINGS_GETISMPNDEINITINPROGRESS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETISMPNDEINITINPROGRESS.FAILED)" />

          <event value="1530"
               symbol="CCP_TRACE_SETTINGS_SETISMPNDEINITINPROGRESS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETISMPNDEINITINPROGRESS.FAILED)" />

          <event value="1531"
               symbol="CCP_TRACE_SETTINGS_GETISPECUINPROGRESS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETISPECUINPROGRESS.FAILED)" />

          <event value="1532"
               symbol="CCP_TRACE_SETTINGS_SETISPECUINPROGRESS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETISPECUINPROGRESS.FAILED)" />

          <event value="1533"
               symbol="CCP_TRACE_SETTINGS_GETREENABLINGPECUPENDINGHOURS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETREENABLINGPECUPENDINGHOURS.FAILED)" />

          <event value="1534"
               symbol="CCP_TRACE_SETTINGS_SETREENABLINGPECUPENDINGHOURS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.SETREENABLINGPECUPENDINGHOURS.FAILED)" />

          <event value="1535"
               symbol="CCP_TRACE_SETTINGS_GETCCPSERVICETARGET_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETSERVICETARGET.FAILED)" />

          <event value="1536"
               symbol="CCP_TRACE_SETTINGS_GETCCPSERVICEPOLICY_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETSERVICEPOLICY.FAILED)" />

          <event value="1537"
              symbol="CCP_TRACE_SETTINGS_GETISWNSENABLED_FAILED"
              task="CCP_TRACE_ERROR"
              keywords="ERROR"
              template="Hr"
              level="win:Error"
              message="$(string.CCP.SETTINGS.GETISWNSENABLED.FAILED)" />

          <event value="1538"
               symbol="CCP_TRACE_SETTINGS_GETCCPPFN_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETCCPPFN.FAILED)" />

          <event value="1539"
               symbol="CCP_TRACE_SETTINGS_GETCCPAPPID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETCCPAPPID.FAILED)" />

          <event value="1540"
               symbol="CCP_TRACE_SETTINGS_GETCCPEKU_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SETTINGS.GETCCPEKU.FAILED)" />

          <!-- TaskRequestImpl.cpp *************************************************************************** -->

          <event value="1550"
               symbol="CCP_TRACE_TASKREQUESTIMPL_SETCOMMANDDATA_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTIMPL.SETCOMMANDDATA.FAILED)" />

          <event value="1551"
               symbol="CCP_TRACE_TASKREQUESTIMPL_GETPROFILEID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTIMPL.GETPROFILEID.FAILED)" />

          <event value="1552"
               symbol="CCP_TRACE_TASKREQUESTIMPL_GETREQUESTID_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTIMPL.GETREQUESTID.FAILED)" />

          <event value="1553"
               symbol="CCP_TRACE_TASKREQUESTIMPL_GETTIMESTAMP_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTIMPL.GETTIMESTAMP.FAILED)" />

          <event value="1554"
               symbol="CCP_TRACE_TASKREQUESTIMPL_GETCOMMANDDATA_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKREQUESTIMPL.GETCOMMANDDATA.FAILED)" />
          
          <!-- SharedSecretStoreImpl.cpp *************************************************************************** -->

          <event value="1570"
               symbol="CCP_TRACE_SHAREDSECRETSTOREIMPL_CREATE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRETSTOREIMPL.CREATE.FAILED)" />

          <event value="1571"
               symbol="CCP_TRACE_SHAREDSECRETSTOREIMPL_VAULTCLOSEVAULT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRETSTOREIMPL.VAULTCLOSEVAULT.FAILED)" />

          <event value="1572"
               symbol="CCP_TRACE_SHAREDSECRETSTOREIMPL_INITIALIZE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRETSTOREIMPL.INITIALIZE.FAILED)" />

          <event value="1573"
               symbol="CCP_TRACE_SHAREDSECRETSTOREIMPL_GETSHAREDSECRET_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRETSTOREIMPL.GETSHAREDSECRET.FAILED)" />

          <event value="1574"
               symbol="CCP_TRACE_SHAREDSECRETSTOREIMPL_SETSHAREDSECRET_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.SHAREDSECRETSTOREIMPL.SETSHAREDSECRET.FAILED)" />
          
          <!-- ccpTaskSchedule.cpp *************************************************************************** -->

          <event value="1590"
               symbol="CCP_TRACE_TASKSCHEDULE_ENABLESCHEDULE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKSCHEDULE.ENABLESCHEDULE.FAILED)" />

          <event value="1591"
               symbol="CCP_TRACE_TASKSCHEDULE_GETTASKSCHEDULEFLAGS_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.TASKSCHEDULE.GETTASKSCHEDULEFLAGS.FAILED)" />

          <!-- ccpPushResilence.cpp *************************************************************************** -->
          
          <event value="1600"
               symbol="CCP_TRACE_PUSHRESILENCE_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.PUSHRESILENCE.FAILED)" />
          
          <!-- ccpLiveID.cpp *************************************************************************** -->          
          <event value="1701"
               symbol="CCP_TRACE_LIVEID_TOKEN_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.LIVEID.TOKEN.FAILED)" />
        
          <!-- ccpWNSListener.cpp *************************************************************************** -->          
          <event value="1800"
               symbol="CCP_TRACE_WNSLISTENER_INIT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.WNSLISTENER.INIT.FAILED)" />

          <event value="1801"
               symbol="CCP_TRACE_WNSLISTENER_DEINIT_SUCCEEDED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.WNSLISTENER.DEINIT_SUCCEEDED)" />
          
          <event value="1802"
               symbol="CCP_TRACE_WNSLISTENER_DEINIT_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.WNSLISTENER.DEINIT.FAILED)" />
          
          <event value="1803"
               symbol="CCP_TRACE_WNSLISTENER_UNREGISTER_APPLICATION_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.WNSLISTENER.UNREGISTER_APPLICATION.INFO)" />
          
        <event value="1804"
               symbol="CCP_TRACE_WNSLISTENER_APPLICATION_NOT_REGISTERED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.WNSLISTENER.APPLICATION_NOT_REGISTERED)" />
			   
        <event value="1805"
               symbol="CCP_TRACE_WNSLISTENER_UNREGISTER_APPLICATION_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.WNSLISTENER.UNREGISTER_APPLICATION.FAILED)" />
                    
         <event value="1806"
               symbol="CCP_TRACE_WNSLISTENER_REGISTER_APPLICATION_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.WNSLISTENER.REGISTER_APPLICATION.INFO)" />
			   
         <event value="1807"
               symbol="CCP_TRACE_WNSLISTENER_APPLICATION_ALREADY_REGISTERED"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.WNSLISTENER.APPLICATION_ALREADY_REGISTERED)" />

         <event value="1808"
               symbol="CCP_TRACE_WNSLISTENER_REGISTER_APPLICATION_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.WNSLISTENER.REGISTER_APPLICATION.FAILED)" />
			   
         <event value="1809"
               symbol="CCP_TRACE_WNSLISTENER_REGISTER_CHANNEL_INFO"
               task="CCP_TRACE_INFO"
               keywords="TRACE"
               level="win:Informational"
               message="$(string.CCP.WNSLISTENER.REGISTER_CHANNEL.INFO)" />
			   
         <event value="1810"
               symbol="CCP_TRACE_WNSLISTENER_REGISTER_CHANNEL_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.WNSLISTENER.REGISTER_CHANNEL.FAILED)" />
			   
         <event value="1811"
               symbol="CCP_TRACE_WNSLISTENER_HANDLE_PUSH_NOTIFICATION_FAILED"
               task="CCP_TRACE_ERROR"
               keywords="ERROR"
               template="Hr"
               level="win:Error"
               message="$(string.CCP.WNSLISTENER.HANDLE_PUSH_NOTIFICATION.FAILED)" />          

          <event value="1812"
             symbol="CCP_TRACE_WNSLISTENER_HANDLEPUSHNOTIFICATION_INFO"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.WNSLISTENER.HANDLEPUSHNOTIFICATION.INFO)" />
          
          <event value="1813"
             symbol="CCP_TRACE_WNSLISTENER_HANDLEPUSHNOTIFICATION_SUCCEEDED"
             task="CCP_TRACE_INFO"
             keywords="TRACE"
             level="win:Informational"
             message="$(string.CCP.WNSLISTENER.HANDLEPUSHNOTIFICATION.SUCCEEDED)" />
        
        </events>

      </provider>
    </events>
  </instrumentation>


  <!-- Localizable strings for the MyProvider Events -->
  <localization>
    <resources culture="en-US">
      <stringTable>
        <!-- CcpManager.cpp -->
        <string id="CCP.REGISTER.INFO"                      value="INFO:  CcpManager::Register() Starts. The passed in profile id=[%1], IsMPNAllowed=[%2].%n" />
        <string id="CCP.REGISTER.LATCHON"                   value="INFO:  CcpManager::Register() Handles latch on to use MPN.%n" />
        <string id="CCP.REGISTER.REREG_DISALLOW_MPN"        value="INFO:  CcpManager::Register() Client was already registered to allow MPN but re-register to disallow MPN.%n" />
        <string id="CCP.REGISTER.FAILED"                    value="ERROR: CcpManager::Register() failed. HR=[%1].%n" />
        <string id="CCP.UNREGISTER.DEINIT_WNS"              value="INFO:  CcpManager::Unregister() Invoke deinitializing WNSListener because this is the last ccp client using WNS.%n" />
        <string id="CCP.UNREGISTER.INFO"                    value="INFO:  CcpManager::Unregister() Starts. The passed in profile id=[%1]." />
        <string id="CCP.UNREGISTER.WNF_RESET_FAILED"        value="ERROR: CcpManager::Unregister() Failed to reset client's WNF statename trigger value back to 0. HR=[%1].%n" />
        <string id="CCP.UNREGISTER.UNKNOWN_PROFILE_ID"      value="INFO:  CcpManager::Unregister() The passed in profile id was not expected because it was not registered.%n" />
        <string id="CCP.UNREGISTER.DEINIT_MPN"              value="INFO:  CcpManager::Unregister() Invoke deinitializing MPNSListener because this is the last ccp client using MPN.%n" />
        <string id="CCP.UNREGISTER.CURRENTLY_LATCH_ON"      value="INFO:  CcpManager::Unregister() Current latching state is ON.%n" />
        <string id="CCP.UNREGISTER.CURRENTLY_LATCH_OFF"     value="INFO:  CcpManager::Unregister() Current latching state is OFF.%n" />
        <string id="CCP.UNREGISTER.SUCCEEDED"               value="INFO:  CcpManager::Unregister() Succeeded.%n" />
        <string id="CCP.UNREGISTER.FAILED"                  value="ERROR: CcpManager::Unregister() failed. HR=[%1].%n" />
        <string id="CCP.TRYGETPUSHDATA.INFO"                value="INFO:  CcpManager::TryGetPushedData() Starts. Profile ID=[%1], InputBufferSize=[%2].%n" />
        <string id="CCP.TRYGETPUSHDATA.RECORD_COUNT"        value="INFO:  CcpManager::TryGetPushedData() Current record count=[%1].%n" />
        <string id="CCP.TRYGETPUSHDATA.INSUFFICIENTBUFFER"  value="INFO:  CcpManager::TryGetPushedData() The passed in buffer size=[%1] bytes which is insufficient. It requires=[%2] bytes.%n" />
        <string id="CCP.TRYGETPUSHDATA.SUFFICIENTBUFFER"    value="INFO:  CcpManager::TryGetPushedData() Passed in buffer size is large enough.%n" />
        <string id="CCP.TRYGETPUSHDATA.MARK_ALREADY_READ"   value="INFO:  CcpManager::TryGetPushedData() Marked the data as 'already read'.%n" />
        <string id="CCP.TRYGETPUSHDATA.WNF_RESET_FAILED"    value="ERROR: CcpManager::TryGetPushedData() Failed to reset client's WNF statename trigger value back to 0. HR=[%1].%n" />
        <string id="CCP.TRYGETPUSHDATA.SUCCEEDED"           value="INFO:  CcpManager::TryGetPushedData() Succeeded. The data is:[%1]%n" />
        <string id="CCP.TRYGETPUSHDATA.ERR_NO_MORE_ITEMS"   value="ERROR: CcpManager::TryGetPushedData() failed. ERROR_NO_MORE_ITEMS. HR=[%1].%n" />
        <string id="CCP.TRYGETPUSHDATA.ERR_INSUFF_BUFFER"   value="ERROR: CcpManager::TryGetPushedData() failed. ERROR_INSUFFICIENT_BUFFER. HR=[%1].%n" />
        <string id="CCP.TRYGETPUSHDATA.ERR_OTHERS"          value="ERROR: CcpManager::TryGetPushedData() failed. HR=[%1].%n" />
        <string id="CCP.RESETWNFSTATENAME.ERR"              value="ERROR: CcpManager::ResetClientWNFStateNameTrigger() failed. HR=[%1].%n" />
        <string id="CCP.INITMPNSLISTENER.ERR"               value="ERROR: CcpManager::InitMPNSListener() failed. HR=[%1].%n" />
        <string id="CCP.DEINITMPNSLISTENER.ERR"             value="ERROR: CcpManager::DeinitMPNSListener() failed. HR=[%1].%n" />
        <string id="CCP.INITWNSLISTENER.ERR"               value="ERROR: CcpManager::InitWNSListener() failed. HR=[%1].%n" />
        <string id="CCP.DEINITWNSLISTENER.ERR"             value="ERROR: CcpManager::DeinitWNSListener() failed. HR=[%1].%n" />
        <string id="CCP.INITSMSLISTENER.ERR"                value="ERROR: CcpManager::InitSMSListener() failed. HR=[%1].%n" />
        <string id="CCP.ADDLISTENRECORD.ERR"                value="ERROR: CcpManager::AddListenRecord() failed. HR=[%1].%n" />
        
        <!-- Main.cpp -->
        <string id="CCP.MAIN.ENSURE_SMS_REGISTERED.INFO"    value="INFO:  EnsureSMSIsRegistered() Starts.%n" />
        <string id="CCP.MAIN.REG_SMS_CHANNEL.SUCCEEDED"     value="INFO:  SMS channel is registered successfully.%n" />
        <string id="CCP.MAIN.SMS_CHANNEL_ALREADY_REG"       value="INFO:  SMS channel was already registered.%n" />
        <string id="CCP.MAIN.ENSURE_SMS_REGISTERED.FAILED"  value="ERROR: EnsureSMSIsRegistered() failed. HR=[%1].%n" />
        <string id="CCP.MAIN.DEINIT_PUSH_NOTIFICATION.INFO" value="INFO:  Handle deinitializing Push notifications.%n" />
        <string id="CCP.MAIN.HANDLE_PECU.INFO"              value="INFO:  HandlePushEndpointCountUpdate() Starts.%n" />
        <string id="CCP.MAIN.NO_CLIENT_TO_LATCH"            value="INFO:  Currently the CCP registered client count is 0. No latch on/off needed.%n" />
        <string id="CCP.MAIN.HAVE_MPN_CLIENT_NO_LATCH"      value="INFO:  Currently at least one CCP client registered to allow MPN. No latch on/off needed.%n" />
        <string id="CCP.MAIN.PROCESS_LATCH_OFF"             value="INFO:  Currently the latching state is ON. Active endpoint count == 1. CCP MPN client count is 0. Latching off.%n" />
        <string id="CCP.MAIN.NO_NEED_TO_LATCH_OFF"          value="INFO:  Currently the latching state is ON. Active endpoint count != 1. No latch on/off needed.%n" />
        <string id="CCP.MAIN.PROCESS_LATCH_ON"              value="INFO:  Currently the latching state is OFF. Active endpoint count > 0. CCP MPN client count is 0. Latching on.%n" />
        <string id="CCP.MAIN.NO_NEED_TO_LATCH_ON"           value="INFO:  Currently the latching state is OFF. Active endpoint count == 0. No latch on/off needed.%n" />
        <string id="CCP.MAIN.HANDLE_PECU.FAILED"            value="ERROR: HandlePushEndpointCountUpdate() failed. HR=[%1].%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_SMS"           value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -SMS -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_WNS"           value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -WNS -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_INIT_WNS"      value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -INITWNS -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_DEINIT_WNS"    value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -DEINITWSN -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_WNS_REFRESH_CHANNEL_URI"   value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -RefreshChannel -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_MPN"           value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -MPN -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_SSU"           value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -SSU -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_PECU"          value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -PECU -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_STOPMPN"       value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -STOPMPN -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.HANDLING_CCPEXE_HU"            value="INFO:  -=-=-=-=-=-=-=- Handling CCP.EXE -HU -=-=-=-=-=-=-=-%n" />
        <string id="CCP.MAIN.ENABLE_HOURLY_UPDATE.FAILED"   value="ERROR: EnableHourlyUpdateSchedule() failed. HR=[%1].%n" />
        <string id="CCP.MAIN.SKIP_HOURLY_UPDATE"            value="INFO:  Skipping this immediate hourly update.%n" />
        <string id="CCP.MAIN.HOURLY_UPDATE.SUCCEEDED"       value="INFO:  Hourly update succeeded.%n" />
        <string id="CCP.MAIN.SKIP_LATCH_ON"                 value="INFO:  Skipping this latch on case.%n" />
        <string id="CCP.MAIN.SKIP_DEINITIALIZATION"         value="INFO:  Skipping this deinitialization because at least one client registerd for MPN.%n" />
        <string id="CCP.MAIN.SET_LATCH_STATE_OFF"           value="INFO:  Latching state is set to OFF.%n" />
        <string id="CCP.MAIN.SET_LATCH_STATE_ON"            value="INFO:  Latching state is set to ON.%n" />

        <!-- CcpBase64Coder.cpp -->
        <string id="CCP.BASE64CODER.ENCODE_CSTRINGW.FAILED" value="ERROR: CcpBase64Coder::Encode() from BYTE* to CStringW failed. HR=[%1].%n" />
        <string id="CCP.BASE64CODER.ENCODE_BSTR.FAILED"     value="ERROR: CcpBase64Coder::Encode() from BYTE* to BSTR failed. HR=[%1].%n" />
        <string id="CCP.BASE64CODER.ENCODE.FAILED"          value="ERROR: CcpBase64Coder::_Encode() failed. HR=[%1].%n" />
        <string id="CCP.BASE64CODER.DECODE.FAILED"          value="ERROR: CcpBase64Coder::Decode() failed. HR=[%1].%n" />

        <!-- CcpCommandTable.cpp -->
        <string id="CCP.CMDTABLE.REC_INIT.FAILED"           value="ERROR: CommandStatusRecord::Initialize() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.REC_GETDATA.FAILED"        value="ERROR: CommandStatusRecord::GetData() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.REC_ASSIGN.FAILED"         value="ERROR: CommandStatusRecord::Assign() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.TABLE_INIT.FAILED"         value="ERROR: CommandStatusTable::Initialize() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.CREATE_UPDATE_REC.FAILED"  value="ERROR: CommandStatusTable::CreateUpdateRecord() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.SEEK_REQID_MATCH.FAILED"   value="ERROR: CommandStatusTable::SeekReqIdMatch() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.SEEK_OLDEST_TS.FAILED"     value="ERROR: CommandStatusTable::SeekOldestTimestamp() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.SEEK_PROFILEID_TS.FAILED"  value="ERROR: CommandStatusTable::SeekProfileIdWithOldestTimestamp() failed HR=[%1].%n" />
        <string id="CCP.CMDTABLE.READ_BY_PROFILEID.INFO"    value="INFO:  CommandStatusTable::ReadCommandStatusRecordByProfileId() Starts.%n" />
        <string id="CCP.CMDTABLE.READ_BY_PROFILEID.ERRSEEK" value="ERROR: CommandStatusTable::ReadCommandStatusRecordByProfileId() ERROR_SEEK. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.READ_BY_PROFILEID.FAILED"  value="ERROR: CommandStatusTable::ReadCommandStatusRecordByProfileId() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.WRITE_REC.INFO"            value="INFO:  CommandStatusTable::WriteCommandStatusRecord() Starts.%n" />
        <string id="CCP.CMDTABLE.WRITE_REC.FAILED"          value="ERROR: CommandStatusTable::WriteCommandStatusRecord() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.DELETE_PROFILE_REC.FAILED" value="ERROR: CommandStatusTable::DeleteProfileRecords() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.DELETE_OLDEST_REC.FAILED"  value="ERROR: CommandStatusTable::DeleteCommandStatusOldestRecord() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.CLEAR_TABLE.FAILED"        value="ERROR: CommandStatusTable::ClearTable() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.REC_COUNT.FAILED"          value="ERROR: CommandStatusTable::RecordCount() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.UPDATE_PROFILELIST.FAILED" value="ERROR: CommandStatusTable::UpdateExistingProfileIdList() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.ENUMERATE_HELPER.FAILED"   value="ERROR: CommandStatusTable::EnumerateHelper() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.DELETE_RECDATAFILES.FAILED" value="ERROR: CommandStatusTable::DeleteRecordDataFiles() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.DELETE_RECDATAFILE.FAILED" value="ERROR: CommandStatusTable::DeleteRecordDataFile() failed. HR=[%1].%n" />
        <string id="CCP.CMDTABLE.FIND_AND_DELETE.FAILED"    value="ERROR: CommandStatusTable::FindAndDelete() failed. HR=[%1].%n" />

        <!-- CcpCore.cpp -->
        <string id="CCP.CORE.RPC_STRING_BINDING_COMPOSE.FAILED"     value="ERROR: CcpCore::HandleSmsNotification() RpcStringBindingCompose() failed. HR=[%1].%n" />
        <string id="CCP.CORE.RPC_BINDING_FROM_STR_BINDING.FAILED"   value="ERROR: CcpCore::HandleSmsNotification() RpcBindingFromStringBinding() failed. HR=[%1].%n" />
        <string id="CCP.CORE.QUERY_TRANSIENT_OBJ_SEC_DESC.FAILED"   value="ERROR: CcpCore::HandleSmsNotification() QueryTransientObjectSecurityDescriptor failed. HR=[%1].%n" />
        <string id="CCP.CORE.RPC_BINDING_SET_AUTH_INFO_EX.FAILED"   value="ERROR: CcpCore::HandleSmsNotification() RpcBindingSetAuthInfoEx() failed. HR=[%1].%n" />
        <string id="CCP.CORE.HANDLE_SMS_COMMAND_DATA.FAILED"        value="ERROR: CcpCore::HandleSmsNotification() HandleCommandData() failed. HR=[%1].%n" />
        <string id="CCP.CORE.RPC_EXCEPTION.FAILED"                  value="ERROR: CcpCore::HandleSmsNotification() failed in RpcException. HR=[%1].%n" />
        <string id="CCP.CORE.HANDLE_SMS_NOTIFICATION.FAILED"        value="ERROR: CcpCore::HandleSmsNotification() failed. HR=[%1].%n" />
        <string id="CCP.CORE.REG_NOTIFICATION_CHANNEL.INFO"         value="INFO:  CcpCore::RegisterNotificationChannel() Received URL from PushSvc:[%1].%n" />   
        <string id="CCP.CORE.REG_NOTIFICATION_CHANNEL_BYTE.FAILED"  value="ERROR: CcpCore::RegisterNotificationChannel() with EndpointUrl in BYTE array failed. HR=[%1].%n" />
        <string id="CCP.CORE.MPN_REGSTATE_ALREADY_ON"               value="INFO:  CcpCore::RegisterNotificationChannel() MPN registeration state is already ON.%n" />
        <string id="CCP.CORE.SAME_CHANNEL_WAS_REG_BEFORE"           value="INFO:  CcpCore::RegisterNotificationChannel() The same channel URL was registered before.%n" />
        <string id="CCP.CORE.REG_NOTIFICATION_SENDHTTPREQ.FAILED"   value="ERROR: CcpCore::RegisterNotificationChannel() httpRequest.SendHttpPostRequest() failed. HttpStatus=[%1].%n" />
        <string id="CCP.CORE.REG_NOTIFICATION_RESET_URL_TO_EMPTY"   value="INFO:  CcpCore::RegisterNotificationChannel() MPNSNotificationUri has been reset to an empty string.%n" />
        <string id="CCP.CORE.REG_NOTIFICATION_RESET_REGSTATE_0"     value="INFO:  CcpCore::RegisterNotificationChannel() MPNRegistrationState has been reset to 0.%n" />
        <string id="CCP.CORE.REG_NOTIFICATION_RESET_LATCHSTATE_0"   value="INFO:  CcpCore::RegisterNotificationChannel() MPNLatchingState has been reset to 0.%n" />
        <string id="CCP.CORE.REG_NOTIFICATION_CHANNEL_WCHAR.FAILED" value="ERROR: CcpCore::RegisterNotificationChannel() with EndpointUrl in WCHAR string failed. HR=[%1].%n" />
        <string id="CCP.CORE.CREATE_REQUEST_BODY.FAILED"            value="ERROR: CcpCore::CreateRegisterNotificationChannelRequestBody() failed. HR=[%1].%n" />       
        <string id="CCP.CORE.HANDLE_COMMAND_DATA.INFO"              value="INFO:  CcpCore::HandleCommandData() Starts.%n" />
        <string id="CCP.CORE.HANDLE_COMMAND_DATA_DECODE_SMS"        value="INFO:  CcpCore::HandleCommandData() Decoding SMS message.%n" />
        <string id="CCP.CORE.HANDLE_COMMAND_DATA_DECODE_MPN"        value="INFO:  CcpCore::HandleCommandData() Decoding MPN message.%n" />
        <string id="CCP.CORE.HANDLE_COMMAND_DATA_DECODED_IDS"       value="INFO:  CcpCore::HandleCommandData() Decoded ProfileId and ReqId.%n" />
        <string id="CCP.CORE.HANDLE_COMMAND_DATA_UNKNOWN_ID"        value="INFO:  CcpCore::HandleCommandData() No partner is using this ProfileId=[%1].%n" />
        <string id="CCP.CORE.HANDLE_COMMAND_DATA_DECODED_TS_CMD"    value="INFO:  CcpCore::HandleCommandData() Decoded timestamp and command data.%n" />
        <string id="CCP.CORE.HANDLE_COMMAND_DATA_LARGE_SIZE"        value="INFO:  CcpCore::HandleCommandData() The command data is large size.%n" />
        <string id="CCP.CORE.HANDLE_COMMAND_DATA.FAILED"            value="ERROR: CCPCore::HandleCommandData() failed. HR=[%1].%n" />
        <string id="CCP.CORE.STORE_CMD_TO_TABLE.FAILED"             value="ERROR: CcpCore::StoreCommandIntoTable() failed. HR=[%1].%n" />
        <string id="CCP.CORE.STORE_CMD_TO_TABLE.SUCCEEDED"          value="INFO:  CcpCore::StoreCommandIntoTable() The command data is stored.%n" />
        <string id="CCP.CORE.PROCESS_PUSH_CONTENT.INFO"             value="INFO:  CcpCore::ProcessPushContent() Starts.%n" />
        <string id="CCP.CORE.PROCESS_PUSH_CONTENT.SUCCEEDED"        value="INFO:  CcpCore::ProcessPushContent() Retrieved large size command data successfully.%n" />
        <string id="CCP.CORE.PROCESS_PUSH_CONTENT.TOOLARGE"         value="INFO:  CcpCore::ProcessPushContent() Data size is invalid (> 1k).%n" />
        <string id="CCP.CORE.PROCESS_PUSH_CONTENT.FAILED"           value="ERROR: CCPCore::ProcessPushContent() failed. HR=[%1].%n" />
        <string id="CCP.CORE.SENDACK_NOTIFICATION_ACK"              value="INFO:  CcpCore::SendAckRequestStatus() sent out Notification Ack.%n" />
        <string id="CCP.CORE.SENDACK_DATA_ACK"                      value="INFO:  CcpCore::SendAckRequestStatus() sent out Data Ack.%n" />
        <string id="CCP.CORE.SENDACK_NO_PARTNER_APP"                value="INFO:  CcpCore::SendAckRequestStatus() sent out No Partner App.%n" />
        <string id="CCP.CORE.SENDACK_FAILED_TO_DOWNLOAD_HTTP"       value="INFO:  CcpCore::SendAckRequestStatus() sent out Failed To Download : Http.%n" />
        <string id="CCP.CORE.SENDACK_FAILED_TO_DOWNLOAD_NETWORK"    value="INFO:  CcpCore::SendAckRequestStatus() sent out Failed To Download : Network Connectivity.%n" />
        <string id="CCP.CORE.SENDACK_FAILED_TO_DOWNLOAD_ROAMING"    value="INFO:  CcpCore::SendAckRequestStatus() sent out Failed To Download : Roaming.%n" />
        <string id="CCP.CORE.SENDACK_OUT_OF_DISK_SPACE"             value="INFO:  CcpCore::SendAckRequestStatus() sent out Out Of Disk Space.%n" />
        <string id="CCP.CORE.SENDACK_DATA_TOO_LARGE"                value="INFO:  CcpCore::SendAckRequestStatus() sent out Data Too Large.%n" />
        <string id="CCP.CORE.SENDACK_UNEXPECTED_VALUE"              value="INFO:  CcpCore::SendAckRequestStatus() sent out unexpcted value.%n" />
        <string id="CCP.CORE.SENDACK.FAILED"                        value="ERROR: CcpCore::SendAckRequestStatus() failed. HR=[%1].%n" />
        <string id="CCP.CORE.NOTIFY_CLIENT.FAILED"                  value="ERROR: CcpCore::NotifyClient() failed. HR=[%1].%n" />
        <string id="CCP.CORE.NOTIFY_CLIENT.SUCCEEDED"               value="INFO:  CcpCore::NotifyClient() Notified client.%n" />
        <string id="CCP.CORE.GET_APPHIVE_HANDLE.FAILED"             value="ERROR: CcpCore::GetCCPAppHiveHandle() failed. HR=[%1].%n" />

        <!-- CcpCrypto.cpp -->
        <string id="CCP.CRYPTO.ENCRYPTDATA.INFO"                    value="INFO:  CcpCrypto::EncryptData() Starts.%n" />
        <string id="CCP.CRYPTO.ENCRYPTDATA.SUCCEEDED"               value="INFO:  CcpCrypto::EncryptData() Succeeded.%n" />
        <string id="CCP.CRYPTO.ENCRYPTDATA.FAILED"                  value="ERROR: CcpCrypto::EncryptData() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.DECRYPTDATA.INFO"                    value="INFO:  CcpCrypto::DecryptData() Starts.%n" />
        <string id="CCP.CRYPTO.DECRYPTDATA.SUCCEEDED"               value="INFO:  CcpCrypto::DecryptData() Succeeded.%n" />
        <string id="CCP.CRYPTO.DECRYPTDATA.FAILED"                  value="ERROR: CcpCrypto::DecryptData() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.PROTECTDATA.FAILED"                  value="ERROR: CcpCrypto::ProtectData() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.UNPROTECTDATA.FAILED"                value="ERROR: CcpCrypto::UnprotectData() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.COMPUTEHMAC.INFO"                    value="INFO:  CcpCrypto::ComputeHMAC() Starts.%n" />
        <string id="CCP.CRYPTO.COMPUTEHMAC.SUCCEEDED"               value="INFO:  CcpCrypto::ComputeHMAC() Succeeded.%n" />
        <string id="CCP.CRYPTO.COMPUTEHMAC.FAILED"                  value="ERROR: CcpCrypto::ComputeHMAC() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.GETPROVIDER.FAILED"                  value="ERROR: CcpCrypto::GetProvider() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.CREATEHASH.FAILED"                   value="ERROR: CcpCrypto::CreateHash() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.HASHDATA.FAILED"                     value="ERROR: CcpCrypto::HashData() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.DERIVEKEY.FAILED"                    value="ERROR: CcpCrypto::DeriveKey() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.ENCRYPT.INFO"                        value="INFO:  CcpCrypto::Encrypt() Starts.%n" />
        <string id="CCP.CRYPTO.ENCRYPT.SUCCEEDED"                   value="INFO:  CcpCrypto::Encrypt() Succeeded.%n" />
        <string id="CCP.CRYPTO.ENCRYPT.FAILED"                      value="ERROR: CcpCrypto::Encrypt() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.DECRYPT.INFO"                        value="INFO:  CcpCrypto::Decrypt() Starts.%n" />
        <string id="CCP.CRYPTO.DECRYPT.SUCCEEDED"                   value="INFO:  CcpCrypto::Decrypt() Succeeded.%n" />
        <string id="CCP.CRYPTO.DECRYPT.FAILED"                      value="ERROR: CcpCrypto::Decrypt() failed. HR=[%1].%n" />
        <string id="CCP.CRYPTO.GETHASHVALUE.FAILED"                 value="ERROR: CcpCrypto::GetHashValue() failed. HR=[%1].%n" />
        
        <!-- CcpListenTable.cpp -->
        <string id="CCP.LISTENTABLE.TABLE_INIT.FAILED"              value="ERROR: ListenTable::Initialize() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.CREATE_UPDATE_RECORD.FAILED"    value="ERROR: ListenTable::CreateUpdateRecord() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.READ_REC_BY_PROFILEID.INFO"     value="INFO:  ListenTable::ReadListenRecordByProfileId() Starts. ProfileId=[%1].%n" />
        <string id="CCP.LISTENTABLE.READ_REC_BY_PROFILEID.FAILED"   value="ERROR: ListenTable::ReadListenRecordByProfileId() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.WRITE_REC.FAILED"               value="ERROR: ListenTable::WriteListenRecord() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.DELETE_REC.FAILED"              value="ERROR: ListenTable::DeleteListenRecord() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.CLEAR_TABLE.FAILED"             value="ERROR: ListenTable::ClearTable() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.RECORD_COUNT"                   value="INFO:  ListenTable::RecordCount() Profile id retreived from regkey is invalid. Skip counting. ProfileId=[%1].%n" />
        <string id="CCP.LISTENTABLE.RECORD_COUNT_NO_RECORD"         value="INFO:  ListenTable::RecordCount() No record found. Setting the count to 0.%n" />
        <string id="CCP.LISTENTABLE.RECORD_COUNT.FAILED"            value="ERROR: ListenTable::RecordCount() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.ALLOWED_MPN_REC_COUNT.FAILED"   value="ERROR: ListenTable::MPNAllowedRecordCount() failed. HR=[%1].%n" />
        <string id="CCP.LISTENTABLE.ALLOWED_WNS_REC_COUNT.FAILED"   value="ERROR: ListenTable::WNSAllowedRecordCount() failed. HR=[%1].%n" />


          <!-- CcpWNSListener.cpp -->
        <string id="CCP.WNSLISTENER.INIT.FAILED"                      value="ERROR: CcpWNSListener::Init() failed. HR=[%1].%n" />
        <string id="CCP.WNSLISTENER.REGISTER_APPLICATION.INFO"        value="INFO:  CcpWNSListener::RegisterApplication() Register To WNS Push Notification Service.%n" />
        <string id="CCP.WNSLISTENER.APPLICATION_ALREADY_REGISTERED"   value="INFO:  CcpWNSListener::RegisterApplication() Application is already registered.%n" />
        <string id="CCP.WNSLISTENER.REGISTER_APPLICATION.FAILED"      value="ERROR: CcpWNSListener::RegisterApplication() failed. HR=[%1].%n" />
        <string id="CCP.WNSLISTENER.REGISTER_CHANNEL.INFO"            value="INFO:  CcpWNSListener::RegisterChannel() Starts.%n" />
        <string id="CCP.WNSLISTENER.REGISTER_CHANNEL.FAILED"          value="ERROR: CcpWNSListener::RegisterChannel() failed. HR=[%1].%n" />
        <string id="CCP.WNSLISTENER.DEINIT_SUCCEEDED"                 value="INFO:  CcpWNSListener::DeInit() Succeeded.%n" />
        <string id="CCP.WNSLISTENER.DEINIT.FAILED"                    value="ERROR: CcpWNSListener::DeInit() failed. HR=[%1].%n" />
        <string id="CCP.WNSLISTENER.UNREGISTER_APPLICATION.INFO"      value="INFO:  CcpWNSListener::UnregisterApplication() Unregister To WNS Push Notification Service.%n" />
        <string id="CCP.WNSLISTENER.APPLICATION_NOT_REGISTERED"       value="INFO:  CcpWNSListener::UnregisterApplication() No-OP because application was not registered.%n" />
        <string id="CCP.WNSLISTENER.UNREGISTER_APPLICATION.FAILED"    value="ERROR: CcpWNSListener::UnRegisterApplication() failed. HR=[%1].%n" />
        <string id="CCP.WNSLISTENER.HANDLEPUSHNOTIFICATION.INFO"      value="INFO:  CcpWNSListener::HandlePushNotification Starts.%n" />
        <string id="CCP.WNSLISTENER.HANDLEPUSHNOTIFICATION.SUCCEEDED" value="INFO:  CcpWNSListener::HandlePushNotification Succeeded.%n" />
        <string id="CCP.WNSLISTENER.HANDLE_PUSH_NOTIFICATION.FAILED"  value="ERROR: CcpMPNSListener::HandlePushNotification() failed. HR=[%1].%n" />
        
        <!-- CcpMPNSListener.cpp -->
        <string id="CCP.MPNLISTENER.INIT_STATE_ALREADY_IN_PROGRESS"  value="INFO:  CcpMPNSListener::Init() MPN init state is already in progress.%n" />
        <string id="CCP.MPNLISTENER.SET_INIT_STATE_TO_IN_PROGRESS"   value="INFO:  CcpMPNSListener::Init() Sets MPN init state to in progress.%n" />
        <string id="CCP.MPNLISTENER.WAITING_FOR_DEINIT_COMPLETE"     value="INFO:  CcpMPNSListener::Init() Waiting for Deinit() to complete before continue...%n" />
        <string id="CCP.MPNLISTENER.DEINIT_COMPLETE_TIMEOUT"         value="ERROR: CcpMPNSListener::Init() Timeout while waiting for Deinit() to complete. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.DEINIT_STILL_IN_PROGRESS"        value="INFO:  CcpMPNSListener::Init() Failed. Deinit state is still in progress.%n" />
        <string id="CCP.MPNLISTENER.RESET_TO_NOT_IN_PROGRESS_FAILED" value="INFO:  CcpMPNSListener::Init() Failed to reset state to NOT in progress.%n" />
        <string id="CCP.MPNLISTENER.RESET_TO_NOT_IN_PROGRESS"        value="INFO:  CcpMPNSListener::Init() Sets MPN init state to NOT in progress.%n" />
        <string id="CCP.MPNLISTENER.ABORT_IS_SET_START_DEINIT"       value="INFO:  CcpMPNSListener::Init() Abort was set. Start to Deinit()...%n" />
        <string id="CCP.MPNLISTENER.DEINIT_DONE_SUCESSFULLY"         value="INFO:  CcpMPNSListener::Init() Deinit successfully done.%n" />
        <string id="CCP.MPNLISTENER.INIT.FAILED"                     value="ERROR: CcpMPNSListener::Init() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.DEINIT_ALREADY_IN_PROGRESS"      value="INFO:  CcpMPNSListener::DeInit() Deinit already in progress.%n" />
        <string id="CCP.MPNLISTENER.SET_DEINIT_STATE_TO_IN_PROGRESS" value="INFO:  CcpMPNSListener::DeInit() Setting deinit state to in progress.%n" />
        <string id="CCP.MPNLISTENER.RESET_ABORT_EVENT"               value="INFO:  CcpMPNSListener::DeInit() Resetting the Abort event.%n" />
        <string id="CCP.MPNLISTENER.DEINIT_SUCCEEDED"                value="INFO:  CcpMPNSListener::DeInit() Succeeded.%n" />
        <string id="CCP.MPNLISTENER.RESET_DEINIT_STATE"              value="INFO:  CcpMPNSListener::DeInit() Sets MPN Deinit state to NOT in progress.%n" />
        <string id="CCP.MPNLISTENER.DEINIT.FAILED"                   value="ERROR: CcpMPNSListener::DeInit() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.CREATE_ENDPOINT.FAILED"          value="ERROR: CcpMPNSListener::CreateEndpoint() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.CONNECT_ENDPOINT.INFO"           value="INFO:  CcpMPNSListener::ConnectEndpoint() Connecting To Push Notification Service.%n" />
        <string id="CCP.MPNLISTENER.CONNECT_ENDPOINT.FAILED"         value="ERROR: CcpMPNSListener::ConnectEndpoint() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.CLOSE_ENDPOINT.FAILED"           value="ERROR: CcpMPNSListener::CloseEndpoint() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.EVENT_DISCONNECTED"              value="INFO:  CcpMPNSListener::HandlePushNotification() Notification Service Disconnected. Reconnecting...%n" />
        <string id="CCP.MPNLISTENER.EVENT_DESCRIPTOR_READY"          value="INFO:  CcpMPNSListener::HandlePushNotification() Notification URI Ready.%n" />
        <string id="CCP.MPNLISTENER.EVENT_MESSAGE_WAITING"           value="INFO:  CcpMPNSListener::HandlePushNotification() Push Message Waiting to be Handled.%n" />
        <string id="CCP.MPNLISTENER.EVENT_ERROR"                     value="ERROR: CcpMPNSListener::HandlePushNotification() Push Notification Error. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.HANDLE_PUSH_NOTIFICATION.FAILED" value="ERROR: CcpMPNSListener::HandlePushNotification() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.WAITFOREVENT_ABORTED"            value="INFO:  CcpMPNSListener::WaitForPushEvent() was aborted.%n" />
        <string id="CCP.MPNLISTENER.WAITFOREVENT_TIMEOUT"            value="INFO:  CcpMPNSListener::WaitForPushEvent() Timeout.%n" />
        <string id="CCP.MPNLISTENER.WAITFOREVENT.FAILED"             value="ERROR: CcpMPNSListener::WaitForPushEvent() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.DO_REGISTER_CHANNEL.INFO"        value="INFO:  CcpMPNSListener::DoRegisterChannel() Starts.%n" />
        <string id="CCP.MPNLISTENER.DO_REGISTER_CHANNEL.FAILED"      value="ERROR: CcpMPNSListener::DoRegisterChannel() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.SET_LATCH_STATE_OFF"             value="INFO:  CcpMPNSListener::UpdateLatchingState() Latching state is set to OFF.%n" />
        <string id="CCP.MPNLISTENER.SET_LATCH_STATE_ON"              value="INFO:  CcpMPNSListener::CcpMPNSListener::UpdateLatchingState() Latching state is set to ON.%n" />
        <string id="CCP.MPNLISTENER.UPDATE_LATCH_STATE.FAILED"       value="ERROR: CcpMPNSListener::UpdateLatchingState() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.HANDLE_PUSH_MESSAGE.INFO"        value="INFO:  CcpMPNSListener::HandlePushMessage() Handling Push Message Notification.%n" />
        <string id="CCP.MPNLISTENER.VALID_NOTIFICATION_RECEIVED"     value="INFO:  CcpMPNSListener::HandlePushMessage() Valid MPNS notification received.%n" />
        <string id="CCP.MPNLISTENER.HANDLE_PUSH_MESSAGE.FAILED"      value="ERROR: CcpMPNSListener::HandlePushMessage() failed. HR=[%1].%n" />
        <string id="CCP.MPNLISTENER.GET_ACTIVEENDPOINTCOUNT.FAILED"  value="ERROR: CcpMPNSListener::GetPushActiveEndpointCount() failed. HR=[%1].%n" />

        <!-- CcpSharedSecret.cpp -->
        <string id="CCP.SHAREDSECRET.CURRENT_ID_MISSING_OR_INVALID"      value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Initialization needed because current id is missing or invalid.%n" />
        <string id="CCP.SHAREDSECRET.UPDATING_ID_MISSING_OR_INVALID"     value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Initialization needed because updating id is missing or invalid.%n" />
        <string id="CCP.SHAREDSECRET.INVALID_SHAREDSECRET"               value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Initialization needed because either the current or updating shared secret is invalid.%n" />
        <string id="CCP.SHAREDSECRET.EXPIRATION_DATE_MISSING"            value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Initialization needed because the expiration date is missing.%n" />
        <string id="CCP.SHAREDSECRET.SHAREDDSERET_EXPIRED"               value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Shared secret is expired. Update is needed.%n" />
        <string id="CCP.SHAREDSECRET.SHAREDDSERET_UPDATED.SUCCEEDED"     value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Shared secret is updated successfully.%n" />
        <string id="CCP.SHAREDSECRET.SHAREDDSERET_CREATED.SUCCEEDED"     value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Shared secret is created successfully.%n" />
        <string id="CCP.SHAREDSECRET.EXTENDED_EXPIRATION_DATE.SUCCEEDED" value="INFO:  CcpSharedSecret::EnsureShareSecretSettings() Shared secret expiration date is set successfully.%n" />
        <string id="CCP.SHAREDSECRET.ENSURE_SHARESECRET_SETTING.FAILED"  value="ERROR: CcpSharedSecret::EnsureShareSecretSettings() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRET.GET_SHAREDSECRET.FAILED"            value="ERROR: CcpSharedSecret::GetSharedSecret() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRET.GET_UNPROTECTED_SECRET_LEN.FAILED"  value="ERROR: CcpSharedSecret::GetUnprotectedSharedSecretLength() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRET.CHECK_IF_SECRET_IS_VALID.FAILED"    value="ERROR: CcpSharedSecret::CheckIfSharedSecretIsValid() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRET.RENEW_SECRET_EXPIRATION_DATE"       value="INFO:  CcpSharedSecret::RenewSharedSecretExpirationDate() Expiration date is set into regkey. SYSTEMTIME=[%1].%n" />
        <string id="CCP.SHAREDSECRET.RENEW_SECRET_EXPIRATION_DATE.FAILED" value="ERROR: CcpSharedSecret::RenewSharedSecretExpirationDate() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRET.SET_UPDATING_TO_CURRENT.FAILED"     value="ERROR: CcpSharedSecret::SetUpdatingSecretToCurrentSecret() failed. HR=[%1]%n" />
        <string id="CCP.SHAREDSECRET.UPDATE_SHAREDSECRET.FAILED"         value="ERROR: CcpSharedSecret::UpdateSharedSecret() failed. HR=[%1].%n" />

        <!-- TaskRequestParserImpl.cpp -->
        <string id="CCP.TASKREQUESTPARSER.CREATE.FAILED"                  value="ERROR: TaskRequestParserImpl::Create() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTPARSER.PARSEREQUEST.INFO"              value="INFO:  TaskRequestParserImpl::ParseRequest() Starts.%n" />
        <string id="CCP.TASKREQUESTPARSER.PARSEREQUEST.FAILED"            value="ERROR: TaskRequestParserImpl::ParseRequest() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTPARSER.DECRYPTCOMMAND.INFO"            value="INFO:  TaskRequestParserImpl::DecryptCommand() Starts.%n" />
        <string id="CCP.TASKREQUESTPARSER.RECEIVED_ID_IS_UPDATING_SEC_ID" value="INFO:  TaskRequestParserImpl::DecryptCommand() Received command's secret id equals to the updating secret id.%n" />
        <string id="CCP.TASKREQUESTPARSER.UPDATED_CURRENT_SEC_ID"         value="INFO:  TaskRequestParserImpl::DecryptCommand() Successfully updated the current sharedsecret id/data to be the same as updating id/data.%n" />
        <string id="CCP.TASKREQUESTPARSER.RECEIVED_ID_IS_CURRENT_SEC_ID"  value="INFO:  TaskRequestParserImpl::DecryptCommand() Received command's secret id equals to the current secret id.%n" />
        <string id="CCP.TASKREQUESTPARSER.DECRYPT.SUCCEEDED"              value="INFO:  TaskRequestParserImpl::DecryptCommand() Data successfully decrypted.%n" />
        <string id="CCP.TASKREQUESTPARSER.DECRYPTCOMMAND.FAILED"          value="ERROR: TaskRequestParserImpl::DecryptCommand() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTPARSER.COPYBYTES.FAILED"               value="ERROR: TaskRequestParserImpl::CopyBytes() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTPARSER.CHECK_DATA_INTEGRITY.FAILED"    value="ERROR: TaskRequestParserImpl::CheckDataIntegrity() failed. HR=[%1].%n" />

        <!-- ccpHttpRequest.cpp -->
        <string id="CCP.HTTPREQUEST.URL_FROM_EPD_IS_NULL"              value="INFO:  CcpHttpRequest::SendHttpPostRequest() The URL received from EPD is NULL.%n" />
        <string id="CCP.HTTPREQUEST.URL_FROM_EPD"                      value="INFO:  CcpHttpRequest::SendHttpPostRequest() The URL from EPD is [%1].%n" />
        <string id="CCP.HTTPREQUEST.HTTP_CONNECT"                      value="INFO:  CcpHttpRequest::SendHttpPostRequest() HTTP Connect....%n" />
        <string id="CCP.HTTPREQUEST.SENDING_REQUEST"                   value="INFO:  CcpHttpRequest::SendHttpPostRequest() Sending Http request...%n" />
        <string id="CCP.HTTPREQUEST.RECEIVING_RESPONSE"                value="INFO:  CcpHttpRequest::SendHttpPostRequest() Receiving response...%n" />
        <string id="CCP.HTTPREQUEST.QUERY_RESPONSE"                    value="INFO:  CcpHttpRequest::SendHttpPostRequest() Querying response header...%n" />
        <string id="CCP.HTTPREQUEST.HTTPSTATUS"                        value="INFO:  CcpHttpRequest::SendHttpPostRequest() HTTP Status=[%1].%n" />
        <string id="CCP.HTTPREQUEST.GETTING_CONTENTSIZE"               value="INFO:  CcpHttpRequest::SendHttpPostRequest() Getting content size....%n" />
        <string id="CCP.HTTPREQUEST.GETTING_DATA"                      value="INFO:  CcpHttpRequest::SendHttpPostRequest() Content size > 0. Getting the data...%n" />
        <string id="CCP.HTTPREQUEST.SEND_REQUEST.FAILED"               value="ERROR: CcpHttpRequest::SendHttpPostRequest() failed. HR=[%1].%n" />
        <string id="CCP.HTTPREQUEST.GET_HTTP_DATA.FAILED"              value="ERROR: CcpHttpRequest::GetHttpData() failed. HR=[%1].%n" />
        <string id="CCP.HTTPREQUEST.SET_DEFAULT_TIMEOUT.FAILED"        value="ERROR: CcpHttpRequest::SetDefaultTimeoutOptions() failed. HR=[%1].%n" />
        <string id="CCP.HTTPREQUEST.GET_CONTENT_SIZE.FAILED"           value="ERROR: CcpHttpRequest::GetContentSize() failed. HR=[%1].%n" />
        <string id="CCP.HTTPREQUEST.READ_DATA.FAILED"                  value="ERROR: CcpHttpRequest::ReadData() failed. HR=[%1].%n" />
        <string id="CCP.HTTPREQUEST.READ_DATA_GREATER_THAN_1K.FAILED"  value="ERROR: CcpHttpRequest::ReadDataGreaterThan1KB() failed. HR=[%1].%n" />

        <!-- ccpHardwareCert.cpp -->
        <string id="CCP.HARDWARECERT.CERTOPENSTORE.FAILED"              value="ERROR: CcpHardwareCert::CertOpenStore failed. HR=[%1].%n" />
        <string id="CCP.HARDWARECERT.FOUNDCERT"                         value="INFO:  CcpHardwareCert::Found device cert.%n" />
        <string id="CCP.HARDWARECERT.CERTFINDCERTIFICATEINSTORE.FAILED" value="ERROR: CcpHardwareCert::CertFindCertificateInStore failed. HR=[%1].%n" />

        <!-- ccpLiveID.cpp -->
        <string id="CCP.LIVEID.TOKEN.FAILED"                            value="ERROR: CCPLiveId::GetDefaultLiveIDToken() failed. HR=[%1].%n" />
 
        <!-- ccpSettings.cpp -->
        <string id="CCP.SETTINGS.GETPUSHCOOKIE.FAILED"                  value="ERROR: Settings::GetPushCookie() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETPUSHCOOKIE.FAILED"                  value="ERROR: Settings::SetPushCookie() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETNOTIFICATIONURI.FAILED"             value="ERROR: Settings::GetMPNSNotificationUri() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETNOTIFICATIONURI.FAILED"             value="ERROR: Settings::SetMPNSNotificationUri() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETPENDINGMPNURI.FAILED"               value="ERROR: Settings::GetPendingMPNUri() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETPENDINGMPNURI.FAILED"               value="ERROR: Settings::SetPendingMPNUri() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETSHAREDSECRETUPDATEFREQ.FAILED"      value="ERROR: Settings::GetSharedSecretUpdateFrequencyInMinute() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETSHAREDSECRETUPDATEFREQ.FAILED"      value="ERROR: Settings::SetSharedSecretUpdateFrequencyInMinute() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETCURRENTSECRETID.FAILED"             value="ERROR: Settings::GetSecretCurrentId() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETCURRENTSECRETID.FAILED"             value="ERROR: Settings::SetSecretCurrentId() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETUPDATINGSECRETID.FAILED"            value="ERROR: Settings::GetSecretUpdatingId() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETUPDATINGSECRETID.FAILED"            value="ERROR: Settings::SetSecretUpdatingId() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETSHAREDSECRETEXPIRATIIONDATE.FAILED" value="ERROR: Settings::GetSharedSecretExpirationDate() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETSHAREDSECRETEXPIRATIIONDATE.FAILED" value="ERROR: Settings::SetSharedSecretExpirationDate() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETMPNLATCHINGSTATE.FAILED"            value="ERROR: Settings::GetMPNLatchingState() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETMPNLATCHINGSTATE.FAILED"            value="ERROR: Settings::SetMPNLatchingState() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETENDPOINTSERVICENAME.FAILED"         value="ERROR: Settings::GetEndpointServiceName() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETENDPOINTSERVICENAME.FAILED"         value="ERROR: Settings::SetEndpointServiceName() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETCCPMONIKER.FAILED"                  value="ERROR: Settings::GetCcpMoniker() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETCCPMONIKER.FAILED"                  value="ERROR: Settings::SetCcpMoniker() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETMPNREGISTRATIONSTATE.FAILED"        value="ERROR: Settings::GetMPNRegistrationState() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETMPNREGISTRATIONSTATE.FAILED"        value="ERROR: Settings::SetMPNRegistrationState() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETSMSREGISTRATIONSTATE.FAILED"        value="ERROR: Settings::GetSMSRegistrationState() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETSMSREGISTRATIONSTATE.FAILED"        value="ERROR: Settings::SetSMSRegistrationState() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETMAXCOMMANDINTABLE.FAILED"           value="ERROR: Settings::GetMaxNumOfCommandsInTable() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETMAXCOMMANDINTABLE.FAILED"           value="ERROR: Settings::SetMaxNumOfCommandsInTable() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETISMPNINITINPROGRESS.FAILED"         value="ERROR: Settings::GetIsMPNInitInProgress() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETISMPNINITINPROGRESS.FAILED"         value="ERROR: Settings::SetIsMPNInitInProgress() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETISMPNDEINITINPROGRESS.FAILED"       value="ERROR: Settings::GetIsMPNDeinitInProgress() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETISMPNDEINITINPROGRESS.FAILED"       value="ERROR: Settings::SetIsMPNDeinitInProgress() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETISPECUINPROGRESS.FAILED"            value="ERROR: Settings::GetIsPECUInProgress() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETISPECUINPROGRESS.FAILED"            value="ERROR: Settings::SetIsPECUInProgress() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETREENABLINGPECUPENDINGHOURS.FAILED"  value="ERROR: Settings::GetReenablingPECUSchedulePendingHours() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.SETREENABLINGPECUPENDINGHOURS.FAILED"  value="ERROR: Settings::SetReenablingPECUSchedulePendingHours() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETISWNSENABLED.FAILED"                value="ERROR: Settings::GetIsWNSEnabled() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETSERVICETARGET.FAILED"               value="ERROR: Settings::GetServiceTarget() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETSERVICEPOLICY.FAILED"               value="ERROR: Settings::GetServicePolicy() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETCCPPFN.FAILED"                      value="ERROR: Settings::GetCcpPfn() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETCCPAPPID.FAILED"                    value="ERROR: Settings::GetCcpAppId() failed. HR=[%1].%n" />
        <string id="CCP.SETTINGS.GETCCPEKU.FAILED"                      value="ERROR: Settings::GetCcpEku() failed. HR=[%1].%n" />

        <!-- TaskRequestImpl.cpp -->
        <string id="CCP.TASKREQUESTIMPL.SETCOMMANDDATA.FAILED"          value="ERROR: TaskRequestImpl::SetCommandData() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTIMPL.GETPROFILEID.FAILED"            value="ERROR: TaskRequestImpl::GetProfileId() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTIMPL.GETREQUESTID.FAILED"            value="ERROR: TaskRequestImpl::GetRequestId() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTIMPL.GETTIMESTAMP.FAILED"            value="ERROR: TaskRequestImpl::GetTimestamp() failed. HR=[%1].%n" />
        <string id="CCP.TASKREQUESTIMPL.GETCOMMANDDATA.FAILED"          value="ERROR: TaskRequestImpl::GetCommandData() failed. HR=[%1].%n" />
        
        <!-- SharedSecretStoreImpl.cpp -->
        <string id="CCP.SHAREDSECRETSTOREIMPL.CREATE.FAILED"            value="ERROR: SharedSecretStoreImpl::Create() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRETSTOREIMPL.VAULTCLOSEVAULT.FAILED"   value="ERROR: SharedSecretStoreImpl::VaultCloseVault() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRETSTOREIMPL.INITIALIZE.FAILED"        value="ERROR: SharedSecretStoreImpl::Initialize() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRETSTOREIMPL.GETSHAREDSECRET.FAILED"   value="ERROR: SharedSecretStoreImpl::GetSharedSecret() failed. HR=[%1].%n" />
        <string id="CCP.SHAREDSECRETSTOREIMPL.SETSHAREDSECRET.FAILED"   value="ERROR: SharedSecretStoreImpl::SetSharedSecret() failed. HR=[%1].%n" />
        
        <!-- ccpTaskSchedule.cpp -->
        <string id="CCP.TASKSCHEDULE.ENABLESCHEDULE.FAILED"              value="ERROR: CcpTaskSchedule::EnableSchedule() failed. HR=[%1].%n" />
        <string id="CCP.TASKSCHEDULE.GETTASKSCHEDULEFLAGS.FAILED"        value="ERROR: CcpTaskSchedule::GetTaskScheduleFlags() failed. HR=[%1].%n" />

        <!-- ccpPushResilence.cpp -->
        <string id="CCP.PUSHRESILENCE.FAILED"                            value="ERROR: CcpPushResilience: Push Error. HR=[%1].%n" />
        
        
        <string id="CCP.INFO"         value="INFO: %1" />
        <string id="CCP.WARN"         value="WARNING: %1" />
        <string id="CCP.ERROR"        value="ERROR: %1, hr=%2" />
        <string id="CCP.HR"           value="ERROR: hr=%1" />
        <string id="CCP.PERFMARK"     value="PERFMARK: %1, TickCount=%2" />
        <string id="CCP.CMDDATA"      value="CMDDATA: RequestId=[%1], ProfileId=[%2], Timestamp=[%3], DataSize=[%4], Data=[%5]" />

        <string id="CCP.EHM.FAILED"   value="ErrorCode=[%1], FileName=[%2], LineNumber=[%3], Message=[%4]%n" />

      </stringTable>
    </resources>
  </localization>
  
</instrumentationManifest>

