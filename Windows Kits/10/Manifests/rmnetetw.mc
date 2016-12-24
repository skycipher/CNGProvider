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
<instrumentationManifest xsi:schemaLocation="http://schemas.microsoft.com/win/2004/08/events eventman.xsd" 
                         xmlns="http://schemas.microsoft.com/win/2004/08/events" 
                         xmlns:win="http://manifests.microsoft.com/win/2004/08/windows/events" 
                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                         xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                         xmlns:trace="http://schemas.microsoft.com/win/2004/08/events/trace">
  <instrumentation>
    <events>
      <provider name="Microsoft-WindowsPhone-RmNetProvider" 
                guid="{A66DFF35-F896-4C0C-8DE1-436466367F11}" 
                symbol="MICROSOFT_WINDOWSPHONE_RMNET_PROVIDER" 
                resourceFileName="RmNet.dll" 
                messageFileName="RmNet.dll">
        <events>
          <event value="1"
                 symbol="RMNET_RESOURCE_MANAGER_INIT"  
                 version="0" 
                 level="win:Informational" 
                 keywords="Verbose" 
                 message="$(string.RmNetResourceManagerInit)" />

          <event value="2"
                 symbol="RMNET_RSRC_MGR_INIT_FAILED_NO_CALLBACK"
                 version="0"
                 level="win:Informational"
                 keywords="Verbose"
                 message="$(string.RmNetRsrcMgrInitFailedNoCallBack)" />

          <event value="3"
                 symbol="RMNET_RESOURCE_MANAGER_DEINIT"
                 version="0"
                 level="win:Informational"
                 keywords="Verbose"
                 message="$(string.RmNetResourceManagerDeInit)" />

          <event value="4"
                 symbol="RMNET_USAGEINFO_ACCOUNT_ADDED"
                 version="0"
                 level="win:Informational"
                 keywords="Verbose"
                 template="UsageInfoAccountAddRemove"
                 message="$(string.RmNetUsageInfoAccountAdded)" />

          <event value="5"
                 symbol="RMNET_USAGEINFO_ACCOUNT_REMOVED"
                 version="0"
                 level="win:Informational"
                 keywords="Verbose"
                 template="UsageInfoAccountAddRemove"
                 message="$(string.RmNetUsageInfoAccountRemoved)" />
                 
          <event value="6"
                 symbol="RMNET_POLICY_ENTRY"
                 version="0"
                 level="win:Informational"
                 keywords="Verbose"
                 template="Template_PolicyEntry"
                 message="$(string.RmNetPolicyEntry)" />
                 
          <event value="7"
                 symbol="RMNET_POLICY_REQUEST_ACCOUNT"
                 version="0"
                 level="win:Informational"
                 keywords="Verbose"
                 template="Template_PolicyEntry"
                 message="$(string.RmNetConflictRequestingAccount)" />
          
          <event value="8"
                 symbol="RMNET_POLICY_REQUEST_CHECK"
                 version="0"
                 level="win:Informational"
                 keywords="Verbose"
                 template="Template_ConflictPolicyRequestCheck"
                 message="$(string.RmNetConflictPolicyRequestCheck)" />

          <event value="9"
                 symbol="RMNET_PRINT_RESOURCEID"
                 version="0"
                 level="win:Verbose"
                 keywords="Verbose"
                 template="Template_PrintResourceId"
                 message="$(string.RmNetPrintResourceId)" />
                 
          <event value="10"
                 symbol="RMNET_PRINT_USAGE_INFO_ACCOUNT"
                 version="0"
                 level="win:Verbose"
                 keywords="Verbose"
                 template="UsageInfoAccountAddRemove"
                 message="$(string.RmNetUsageInfoAccount)" />    
                 
        </events>
        
        <levels />
        
        <keywords>
          <keyword mask="0x0000000000000001" name="Error"       message="$(string.Keyword.Error)" />
          <keyword mask="0x0000000000000002" name="Performance" message="$(string.Keyword.Performance)" />
          <keyword mask="0x0000000000000004" name="Verbose"       message="$(string.Keyword.Verbose)" />
        </keywords>

        <!--Event Templates -->
        <templates>

          <template tid="UsageInfoAccountAddRemove">
            <data name="NAME" inType="win:UnicodeString" />
            <data name="PRIORITY" inType="win:UInt32" />
            <UserData>
              <RmNetLogEvent xmlns="RmNetLogNs">
                <NAME> %1 </NAME>
                <PRIORITY> %2 </PRIORITY>
              </RmNetLogEvent>
            </UserData>
          </template>
          
          <template tid="Template_PolicyEntry">
            <data name="Account" inType="win:UnicodeString" />
            <data name="IsBackground" inType="win:Boolean" />
            <data name="Order" inType="win:HexInt32" />
          </template>
          
          <template tid="Template_ConflictPolicyRequestCheck">
            <data name="Account" inType="win:UnicodeString" />
            <data name="IsBackground" inType="win:Boolean" />
            <data name="Order" inType="win:HexInt32" />
            <data name="Result" inType="win:Boolean" />
          </template>
          
          <template tid="Template_PrintResourceId">
            <data name="ResourceIdString" inType="win:UnicodeString" />
            <data name="ResourceHandle" inType="win:HexInt32" />
          </template>
          
        </templates>

        </provider>
    </events>
  </instrumentation>
  <localization>
    <resources culture="en-US">
      <stringTable>
        <string id="RmNetResourceManagerInit" 
                value="RMNET: ResourceManager Initialized."/>

        <string id="RmNetRsrcMgrInitFailedNoCallBack"
                value="RMNET: ResourceManager initialized failed, no callback."/>

        <string id="RmNetResourceManagerDeInit"
                value="RMNET: ResourceManager De-initialized."/>

        <string id="RmNetUsageInfoAccountAdded"
                value="RMNET: Account Name=[%1], Priority=[%2] added to resource usage list"/>

        <string id="RmNetUsageInfoAccountRemoved"
                value="RMNET: Account Name=[%1], Priority=[%2] removed from resource usage list.."/>

        <string id="RmNetPolicyEntry"
                value="RMNET: Policy Account Name [%1], Background? [%2], Order [%3]"/>
        
        <string id="RmNetConflictRequestingAccount"
                value="Requesting account: [%1 : Background?(%2)] order [%3]"/>
        
        <string id="RmNetConflictPolicyRequestCheck"
                value="Requesting account is compared to account [%1 : Background?(%2)] order [%3] - Request win? [%4]"/>

        <string id="RmNetPrintResourceId"
                value="Accounts using ResourceID [%1] handle [%2]:"/>
                
        <string id="RmNetUsageInfoAccount"
                value="Account [%1] Priority [%2]"/>
                
        <string id="Keyword.Error"              value="Error" />
        <string id="Keyword.Performance"        value="Performance" />
        <string id="Keyword.Verbose"            value="Verbose" />

      </stringTable>
    </resources>
  </localization>
</instrumentationManifest>


