'******************************************************************************
'Microsoft Confidential. © 2002-2003 Microsoft Corporation. All rights reserved.
'
' This file may contain preliminary information or inaccuracies, 
' and may not correctly represent any associated Microsoft 
' Product as commercially released. All Materials are provided entirely 
' “AS IS.” To the extent permitted by law, MICROSOFT MAKES NO 
' WARRANTY OF ANY KIND, DISCLAIMS ALL EXPRESS, IMPLIED AND STATUTORY 
' WARRANTIES, AND ASSUMES NO LIABILITY TO YOU FOR ANY DAMAGES OF 
' ANY TYPE IN CONNECTION WITH THESE MATERIALS OR ANY INTELLECTUAL PROPERTY IN THEM. 
'******************************************************************************

Option Explicit

Wscript.Echo "" 
Wscript.Echo "REGISTER_APP.VBS version 1.6 for Windows Server 2008"
Wscript.Echo "Copyright (C) Microsoft Corporation 2002-2003. All rights reserved."
Wscript.Echo "" 


'******************************************************************************
' Parse command line arguments
'******************************************************************************
Dim Args
Set Args = Wscript.Arguments
If Args.Count < 1 Then 
	PrintsUsage
End If

Dim ProviderName, ProviderDLL, ProviderDescription
If Args.Item(0) = "-register" Then 
	If Args.Count <> 4 Then PrintsUsage

	ProviderName = Args.Item(1)
	ProviderDLL = Args.Item(2)
	ProviderDescription = Args.Item(3)

	UninstallProvider
	InstallProvider
	Wscript.Quit 0
End If 

If Args.Item(0) = "-unregister" Then 
	If Not Args.Count = 2 Then PrintsUsage
	ProviderName = Args.Item(1)
	UninstallProvider
	Wscript.Quit 0
End If

' Wrong options?
PrintsUsage

Wscript.Quit 0

'******************************************************************************
' Prints the usage
'******************************************************************************
Sub PrintsUsage

	Wscript.Echo "Usage:" 
	Wscript.Echo "" 
	Wscript.Echo " 1) Registering a VSS/VDS Provider as a COM+ application:" 
	Wscript.Echo "      CScript.exe " & Wscript.ScriptName & " -register <Provider_Name> <Provider.DLL>  <Provider_Description>" 
	Wscript.Echo "" 
	Wscript.Echo " 2) Unregistering a COM+ application associated with a VSS/VDS provider:" 
	Wscript.Echo "      CScript.exe " & Wscript.ScriptName & " -unregister <Provider_Name>" 
	Wscript.Echo "" 
	Wscript.Quit 1

End Sub


'******************************************************************************
' Installs the Provider
'******************************************************************************
Sub InstallProvider
	On Error Resume Next

	Wscript.Echo "Creating a new COM+ application:" 

	Wscript.Echo "- Creating the catalog object "
	Dim cat
	Set cat = CreateObject("COMAdmin.COMAdminCatalog") 	
	CheckError 101

	wscript.echo "- Get the Applications collection"
	Dim collApps
	Set collApps = cat.GetCollection("Applications")
	CheckCollectionError 102, cat

	Wscript.Echo "- Populate..." 
	collApps.Populate 
	CheckCollectionError 103, collApps

	Wscript.Echo "- Add new application object" 
	Dim app
	Set app = collApps.Add 
	CheckCollectionError 104, collApps

	Wscript.Echo "- Set app name = " & ProviderName & " "
	app.Value("Name") = ProviderName
	CheckObjectError 105, collApps, app

	Wscript.Echo "- Set app description = " & ProviderDescription & " "
	app.Value("Description") = ProviderDescription 
	CheckObjectError 106, collApps, app

	' Only roles added below are allowed to call in.
	Wscript.Echo "- Set app access check = true "
	app.Value("ApplicationAccessChecksEnabled") = 1   
	CheckObjectError 107, collApps, app

	' Encrypting communication
	Wscript.Echo "- Set encrypted COM communication = true "
	app.Value("Authentication") = 6	                  
	CheckObjectError 108, collApps, app

	' Secure references
	Wscript.Echo "- Set secure references = true "
	app.Value("AuthenticationCapability") = 2         
	CheckObjectError 109, collApps, app

	' Do not allow impersonation
	Wscript.Echo "- Set impersonation = false "
	app.Value("ImpersonationLevel") = 2               
	CheckObjectError 110, collApps, app

	Wscript.Echo "- Save changes..."
	collApps.SaveChanges
	CheckCollectionError 111, collApps

	wscript.echo "- Create Windows service running as Local System"
	cat.CreateServiceForApplication ProviderName, ProviderName , "SERVICE_AUTO_START", "SERVICE_ERROR_NORMAL", "", ".\localsystem", "", 0
	CheckCollectionError 112, cat

	wscript.echo "- Add the DLL component"
	cat.InstallComponent ProviderName, ProviderDLL , "", ""
        CheckCollectionError 113, cat

	'
	' Add the new role for the Local SYSTEM account
	'

	wscript.echo "Secure the COM+ application:"
	wscript.echo "- Get roles collection"
	Dim collRoles
	Set collRoles = collApps.GetCollection("Roles", app.Key)
	CheckCollectionError 120, cat

	wscript.echo "- Populate..."
	collRoles.Populate
	CheckCollectionError 121, collRoles

	wscript.echo "- Add new role"
	Dim role
	Set role = collRoles.Add
	CheckCollectionError 122, collRoles

	wscript.echo "- Set name = Administrators "
	role.Value("Name") = "Administrators"
	CheckObjectError 123, collRoles, role

	wscript.echo "- Set description = Administrators group "
	role.Value("Description") = "Administrators group"
	CheckObjectError 124, collRoles, role

	wscript.echo "- Save changes ..."
	collRoles.SaveChanges
	CheckCollectionError 125, collRoles
	
	'
	' Add users into role
	'

	wscript.echo "Granting user permissions:"
	Dim collUsersInRole
	Set collUsersInRole = collRoles.GetCollection("UsersInRole", role.Key)
	CheckCollectionError 130, collRoles

	wscript.echo "- Populate..."
	collUsersInRole.Populate
	CheckCollectionError 131, collUsersInRole

	wscript.echo "- Add new user"
	Dim user
	Set user = collUsersInRole.Add
	CheckCollectionError 132, collUsersInRole

	wscript.echo "- Searching for the Administrators account using WMI..."

	' Get the Administrators account domain and name
	Dim strQuery
	strQuery = "select * from Win32_Account where SID='S-1-5-32-544' and localAccount=TRUE"
	Dim objSet
	set objSet = GetObject("winmgmts:").ExecQuery(strQuery)
	CheckError 133

	Dim obj, Account
	for each obj in objSet
	    set Account = obj
		exit for
	next

	wscript.echo "- Set user name = .\" & Account.Name & " "
	user.Value("User") = ".\" & Account.Name
	CheckObjectError 140, collUsersInRole, user

	wscript.echo "- Add new user"
	Set user = collUsersInRole.Add
	CheckCollectionError 141, collUsersInRole

	wscript.echo "- Set user name = Local SYSTEM "
	user.Value("User") = "NT AUTHORITY\SYSTEM"
	CheckObjectError 142, collUsersInRole, user

	wscript.echo "- Save changes..."
	collUsersInRole.SaveChanges
	CheckCollectionError 143, collUsersInRole
	
	Set app      = Nothing
	Set cat      = Nothing
	Set role     = Nothing
	Set user     = Nothing

	Set collApps = Nothing
	Set collRoles = Nothing
	Set collUsersInRole	= Nothing

	set objSet   = Nothing
	set obj      = Nothing

	Wscript.Echo "Done." 

	On Error GoTo 0
End Sub


'******************************************************************************
' Uninstalls the Provider
'******************************************************************************
Sub UninstallProvider
	On Error Resume Next

	Wscript.Echo "Unregistering the existing application..." 

	wscript.echo "- Create the catalog object"
	Dim cat
	Set cat = CreateObject("COMAdmin.COMAdminCatalog")
	CheckError 201
	
	wscript.echo "- Get the Applications collection"
	Dim collApps
	Set collApps = cat.GetCollection("Applications")
	CheckCollectionError 202, cat

	wscript.echo "- Populate..."
	collApps.Populate
	CheckCollectionError 203, collApps
	
	wscript.echo "- Search for " & ProviderName & " application..."
	Dim numApps
	numApps = collApps.Count
	Dim i
	For i = numApps - 1 To 0 Step -1
	    If collApps.Item(i).Value("Name") = ProviderName Then
	        collApps.Remove(i)
		CheckCollectionError 204, collApps
                WScript.echo "- Application " & ProviderName & " removed!"
	    End If
	Next
	
	wscript.echo "- Saving changes..."
	collApps.SaveChanges
	CheckCollectionError 205, collApps

	Set collApps = Nothing
	Set cat      = Nothing

	Wscript.Echo "Done." 

	On Error GoTo 0
End Sub



'******************************************************************************
' Sub CheckError
'******************************************************************************
Sub CheckError(exitCode)
    If Err = 0 Then Exit Sub
    DumpVBScriptError exitCode

    Wscript.Quit exitCode
End Sub


'******************************************************************************
' Sub CheckCollectionError
'******************************************************************************
Sub CheckCollectionError(exitCode, coll)
    If Err = 0 Then Exit Sub
    DumpVBScriptError exitCode

    DumpComPlusError(coll.GetCollection("ErrorInfo"))

    Wscript.Quit exitCode
End Sub


'******************************************************************************
' Sub CheckObjectError
'******************************************************************************
Sub CheckObjectError(exitCode, coll, object)
    If Err = 0 Then Exit Sub
    DumpVBScriptError exitCode

    ' DumpComPlusError(coll.GetCollection("ErrorInfo", object.Key))
    DumpComPlusError(coll.GetCollection("ErrorInfo"))

    Wscript.Quit exitCode
End Sub



'******************************************************************************
' Sub DumpVBScriptError
'******************************************************************************
Sub DumpVBScriptError(exitCode)
    WScript.Echo vbNewLine & "ERROR:"
    WScript.Echo "- Error code: " & Err & " [0x" & Hex(Err) & "]"
    WScript.Echo "- Exit code: " & exitCode
    WScript.Echo "- Description: " & Err.Description
    WScript.Echo "- Source: " & Err.Source
    WScript.Echo "- Help file: " & Err.Helpfile
    WScript.Echo "- Help context: " & Err.HelpContext
End Sub


'******************************************************************************
' Sub DumpComPlusError
'******************************************************************************
Sub DumpComPlusError(errors)
    errors.Populate
    WScript.Echo "- COM+ Errors detected: (" & errors.Count & ")"

    Dim error
    Dim I
    For I = 0 to errors.Count - 1
	Set error = errors.Item(I)
        WScript.Echo "   * (COM+ ERROR " & I & ") on " & error.Value("Name")
        WScript.Echo "       ErrorCode: " & error.Value("ErrorCode") & " [0x" & Hex(error.Value("ErrorCode")) & "]"
        WScript.Echo "       MajorRef: " & error.Value("MajorRef")
        WScript.Echo "       MinorRef: " & error.Value("MinorRef")
    Next
End Sub


'' SIG '' Begin signature block
'' SIG '' MIIiEAYJKoZIhvcNAQcCoIIiATCCIf0CAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' t2OGjVuwrDi7m9eD1oGHZt1e8mT97G6PYHdAzoXpmRWg
'' SIG '' gguOMIIFFjCCA/6gAwIBAgITMwAAAPcoVO77wpgbcQAA
'' SIG '' AAAA9zANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBT
'' SIG '' aWduaW5nIFBDQSAyMDEwMB4XDTE2MDEwNjE4MzkwNloX
'' SIG '' DTE3MDQwNjE4MzkwNlowgY4xCzAJBgNVBAYTAlVTMRMw
'' SIG '' EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
'' SIG '' b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
'' SIG '' b24xDTALBgNVBAsTBE1PUFIxKTAnBgNVBAMTIE1pY3Jv
'' SIG '' c29mdCBXaW5kb3dzIEtpdHMgUHVibGlzaGVyMIIBIjAN
'' SIG '' BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1AR+wqsz
'' SIG '' sFtMP/Mn7AFMDR1G2z7cWWXUbjRczUoYMeWxTDop+uXI
'' SIG '' uOvcoPiSLx/qXiOWH0Q8U9yZRI70qYn/GVF40VDNQRos
'' SIG '' vGV2YGfxlSc+wxfcw/a1/12vPAxNmEY7iw97vndAAbdR
'' SIG '' 5gG2xaymQ/Z6j/ECwnqo64zGE2UbElMug87UaVX7eqGV
'' SIG '' CvUxSjiIh/Wh33tbMbiSiiTbHledTbGz4iCPAZebX+MI
'' SIG '' VfzhD0OehtEnAl1bQQg7QkTxTWkEddrXe88uX2XfSUqO
'' SIG '' oky4CmXfJtrdIIVq13G66Q9iNzQIsB2lQD5YLTfv042e
'' SIG '' KJMtl2gi6wPAj6RcI2km5njJzwIDAQABo4IBejCCAXYw
'' SIG '' HwYDVR0lBBgwFgYIKwYBBQUHAwMGCisGAQQBgjcKAxQw
'' SIG '' HQYDVR0OBBYEFDswaL2qHyB7Nk2nsBv8OB+Iszl0MFEG
'' SIG '' A1UdEQRKMEikRjBEMQ0wCwYDVQQLEwRNT1BSMTMwMQYD
'' SIG '' VQQFEyozMTYxOCtiMTI0NTdhMC05Yjg0LTQyYjAtOThm
'' SIG '' Ny01ZDAxZjc3Y2RiZjQwHwYDVR0jBBgwFoAU5vxfe7si
'' SIG '' AFjkck619CF0IzLm76wwVgYDVR0fBE8wTTBLoEmgR4ZF
'' SIG '' aHR0cDovL2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwv
'' SIG '' cHJvZHVjdHMvTWljQ29kU2lnUENBXzIwMTAtMDctMDYu
'' SIG '' Y3JsMFoGCCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+
'' SIG '' aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0
'' SIG '' cy9NaWNDb2RTaWdQQ0FfMjAxMC0wNy0wNi5jcnQwDAYD
'' SIG '' VR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAQEAYsg4
'' SIG '' oPGeCB3DRQJkIlwuhOIuRsI0e8xltqpKOBg7LZf8+KL+
'' SIG '' MLwZyQhBzs8jDrxYtwaUK31fQTCOygjLuBAqqQY5Sqj6
'' SIG '' U06wdn/y0mrdwJhyESzKPV+bUfF9jN4cdNJhDnZFoyNE
'' SIG '' F5uDt7heE7dvxu+vur/hGMD72nP129pjG7jNITTcpHug
'' SIG '' RuYXMnYPvtbuenatkljU7BxiRZbrHS5cwnd9BHI4B2p2
'' SIG '' VM4vgJ3dNF5o9Isu2RkpaZB2gK6jtkwBm0vmxlTkl5Du
'' SIG '' 4vyCV7zDswoByRolkmZq6LCRVDLYAVIwsh1Sic5vtNAD
'' SIG '' GrhunjO75FtIzx3FXfnrt5QgiCAimzCCBnAwggRYoAMC
'' SIG '' AQICCmEMUkwAAAAAAAMwDQYJKoZIhvcNAQELBQAwgYgx
'' SIG '' CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
'' SIG '' MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jv
'' SIG '' c29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
'' SIG '' MDEwMB4XDTEwMDcwNjIwNDAxN1oXDTI1MDcwNjIwNTAx
'' SIG '' N1owfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
'' SIG '' bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
'' SIG '' FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMf
'' SIG '' TWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMDCC
'' SIG '' ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOkO
'' SIG '' ZFB5Z7XE4/0JAEyelKz3VmjqRNjPxVhPqaV2fG1FutM5
'' SIG '' krSkHvn5ZYLkF9KP/UScCOhlk84sVYS/fQjjLiuoQSsY
'' SIG '' t6JLbklMaxUH3tHSwokecZTNtX9LtK8I2MyI1msXlDqT
'' SIG '' ziY/7Ob+NJhX1R1dSfayKi7VhbtZP/iQtCuDdMorsztG
'' SIG '' 4/BGScEXZlTJHL0dxFViV3L4Z7klIDTeXaallV6rKIDN
'' SIG '' 1bKe5QO1Y9OyFMjByIomCll/B+z/Du2AEjVMEqa+Ulv1
'' SIG '' ptrgiwtId9aFR9UQucboqu6Lai0FXGDGtCpbnCMcX0Xj
'' SIG '' GhQebzfLGTOAaolNo2pmY3iT1TDPlR8CAwEAAaOCAeMw
'' SIG '' ggHfMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTm
'' SIG '' /F97uyIAWORyTrX0IXQjMubvrDAZBgkrBgEEAYI3FAIE
'' SIG '' DB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0T
'' SIG '' AQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo
'' SIG '' 0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRw
'' SIG '' Oi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9k
'' SIG '' dWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmww
'' SIG '' WgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRw
'' SIG '' Oi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01p
'' SIG '' Y1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBnQYDVR0g
'' SIG '' BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUH
'' SIG '' AgEWMWh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9QS0kv
'' SIG '' ZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYBBQUHAgIw
'' SIG '' NB4yIB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBT
'' SIG '' AHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQEL
'' SIG '' BQADggIBABp071dPKXvEFoV4uFDTIvwJnayCl/g0/yos
'' SIG '' l5US5eS/z7+TyOM0qduBuNweAL7SNW+v5X95lXflAtTx
'' SIG '' 69jNTh4bYaLCWiMa8IyoYlFFZwjjPzwek/gwhRfIOUCm
'' SIG '' 1w6zISnlpaFpjCKTzHSY56FHQ/JTrMAPMGl//tIlIG1v
'' SIG '' YdPfB9XZcgAsaYZ2PVHbpjlIyTdhbQfdUxnLp9Zhwr/i
'' SIG '' g6sP4GubldZ9KFGwiUpRpJpsyLcfShoOaanX3MF+0Ulw
'' SIG '' qratu3JHYxf6ptaipobsqBBEm2O2smmJBsdGhnoYP+jF
'' SIG '' HSHVe/kCIy3FQcu/HUzIFu+xnH/8IktJim4V46Z/dlvR
'' SIG '' U3mRhZ3V0ts9czXzPK5UslJHasCqE5XSjhHamWdeMoz7
'' SIG '' N4XR3HWFnIfGWleFwr/dDY+Mmy3rtO7PJ9O1Xmn6pBYE
'' SIG '' AackZ3PPTU+23gVWl3r36VJN9HcFT4XG2Avxju1CCdEN
'' SIG '' duMjVngiJja+yrGMbqod5IXaRzNij6TJkTNfcR5Ar5hl
'' SIG '' ySLoQiElihwtYNk3iUGJKhYP12E8lGhgUu/WR5mggEDu
'' SIG '' FYF3PpzgUxgaUB04lZseZjMTJzkXeIc2zk7DX7L1PUdT
'' SIG '' tuDl2wthPSrXkizON1o+QEIxpB8QCMJWnL8kXVECnWp5
'' SIG '' 0hfT2sGUjgd7JXFEqwZq5tTG3yOalnXFMYIV2jCCFdYC
'' SIG '' AQEwgZUwfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
'' SIG '' c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
'' SIG '' BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UE
'' SIG '' AxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAx
'' SIG '' MAITMwAAAPcoVO77wpgbcQAAAAAA9zANBglghkgBZQME
'' SIG '' AgEFAKCBxjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
'' SIG '' BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAv
'' SIG '' BgkqhkiG9w0BCQQxIgQgorqISAsetE22SO7QBE0kVhcp
'' SIG '' YE9Wme7Kh+uQRwMUI5IwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQAmxtDuCiZf
'' SIG '' xJO4UuOzTfOvztQdLrXc+vD+3C/1wBfH0pYJ/pnsPnP7
'' SIG '' DR0YPAJ6muFaHuThU4bDy9jl/iBkq1lcHtQWJ3TWwUZw
'' SIG '' uFuHjcJiRdB7AQ9UvL4ePh5z2Qs2O+BKc53Mc1pxf0Ma
'' SIG '' kkR70i6ozVOw51K++jCiJNz2Yh++8+KNZ2B8JZ05IzgZ
'' SIG '' VNgUlxqU/3sBWLcwunWygU7MOGF3sEiFMKWOCyXWdw+q
'' SIG '' EBQxGYz++4jTnPn9fdBTwjynTZeRPk6kWfNhHdvJF+HW
'' SIG '' nfbEiFe5X9APXNI1HiWKtwHUAVf7lOadle1SfIvilmhr
'' SIG '' ceyc9Yn6r8g4Dg4f9lWPdne7oYITTDCCE0gGCisGAQQB
'' SIG '' gjcDAwExghM4MIITNAYJKoZIhvcNAQcCoIITJTCCEyEC
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCAT0GCyqGSIb3DQEJ
'' SIG '' EAEEoIIBLASCASgwggEkAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIDvjLLDDkDjPyf31gPQH9yDS
'' SIG '' Cr25yOZs0WMtWQ3ez9eYAgZXj52K3PEYEzIwMTYwNzI4
'' SIG '' MTQwMDI4Ljg5NVowBwIBAYACAfSggbmkgbYwgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo5OEZELUM2MUUt
'' SIG '' RTY0MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
'' SIG '' bXAgU2VydmljZaCCDs8wggZxMIIEWaADAgECAgphCYEq
'' SIG '' AAAAAAACMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQG
'' SIG '' EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
'' SIG '' BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
'' SIG '' cnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9v
'' SIG '' dCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0x
'' SIG '' MDA3MDEyMTM2NTVaFw0yNTA3MDEyMTQ2NTVaMHwxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
'' SIG '' dCBUaW1lLVN0YW1wIFBDQSAyMDEwMIIBIjANBgkqhkiG
'' SIG '' 9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqR0NvHcRijog7PwT
'' SIG '' l/X6f2mUa3RUENWlCgCChfvtfGhLLF/Fw+Vhwna3PmYr
'' SIG '' W/AVUycEMR9BGxqVHc4JE458YTBZsTBED/FgiIRUQwzX
'' SIG '' Tbg4CLNC3ZOs1nMwVyaCo0UN0Or1R4HNvyRgMlhgRvJY
'' SIG '' R4YyhB50YWeRX4FUsc+TTJLBxKZd0WETbijGGvmGgLvf
'' SIG '' YfxGwScdJGcSchohiq9LZIlQYrFd/XcfPfBXday9ikJN
'' SIG '' QFHRD5wGPmd/9WbAA5ZEfu/QS/1u5ZrKsajyeioKMfDa
'' SIG '' TgaRtogINeh4HLDpmc085y9Euqf03GS9pAHBIAmTeM38
'' SIG '' vMDJRF1eFpwBBU8iTQIDAQABo4IB5jCCAeIwEAYJKwYB
'' SIG '' BAGCNxUBBAMCAQAwHQYDVR0OBBYEFNVjOlyKMZDzQ3t8
'' SIG '' RhvFM2hahW1VMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIA
'' SIG '' QwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/
'' SIG '' MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjE
'' SIG '' MFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWlj
'' SIG '' cm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jv
'' SIG '' b0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcB
'' SIG '' AQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWlj
'' SIG '' cm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0
'' SIG '' XzIwMTAtMDYtMjMuY3J0MIGgBgNVHSABAf8EgZUwgZIw
'' SIG '' gY8GCSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0
'' SIG '' cDovL3d3dy5taWNyb3NvZnQuY29tL1BLSS9kb2NzL0NQ
'' SIG '' Uy9kZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0HjIgHQBM
'' SIG '' AGUAZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQA
'' SIG '' ZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEA
'' SIG '' B+aIUQ3ixuCYP4FxAz2do6Ehb7Prpsz1Mb7PBeKp/vpX
'' SIG '' bRkws8LFZslq3/Xn8Hi9x6ieJeP5vO1rVFcIK1GCRBL7
'' SIG '' uVOMzPRgEop2zEBAQZvcXBf/XPleFzWYJFZLdO9CEMiv
'' SIG '' v3/Gf/I3fVo/HPKZeUqRUgCvOA8X9S95gWXZqbVr5MfO
'' SIG '' 9sp6AG9LMEQkIjzP7QOllo9ZKby2/QThcJ8ySif9Va8v
'' SIG '' /rbljjO7Yl+a21dA6fHOmWaQjP9qYn/dxUoLkSbiOewZ
'' SIG '' SnFjnXshbcOco6I8+n99lmqQeKZt0uGc+R38ONiU9Mal
'' SIG '' CpaGpL2eGq4EQoO4tYCbIjggtSXlZOz39L9+Y1klD3ou
'' SIG '' OVd2onGqBooPiRa6YacRy5rYDkeagMXQzafQ732D8OE7
'' SIG '' cQnfXXSYIghh2rBQHm+98eEA3+cxB6STOvdlR3jo+KhI
'' SIG '' q/fecn5ha293qYHLpwmsObvsxsvYgrRyzR30uIUBHoD7
'' SIG '' G4kqVDmyW9rIDVWZeodzOwjmmC3qjeAzLhIp9cAvVCch
'' SIG '' 98isTtoouLGp25ayp0Kiyc8ZQU3ghvkqmqMRZjDTu3Qy
'' SIG '' S99je/WZii8bxyGvWbWu3EQ8l1Bx16HSxVXjad5XwdHe
'' SIG '' MMD9zOZN+w2/XU/pnR4ZOC+8z1gFLu8NoFA12u8JJxzV
'' SIG '' s341Hgi62jbb01+P3nSISRIwggTaMIIDwqADAgECAhMz
'' SIG '' AAAAhd/WWAkULse7AAAAAACFMA0GCSqGSIb3DQEBCwUA
'' SIG '' MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
'' SIG '' dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
'' SIG '' aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
'' SIG '' Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE2
'' SIG '' MDMzMDE5MjQyNFoXDTE3MDYzMDE5MjQyNFowgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo5OEZELUM2MUUt
'' SIG '' RTY0MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
'' SIG '' bXAgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEP
'' SIG '' ADCCAQoCggEBAM8H5bDdFazEemUu5+n3vBnfjn7cTYAE
'' SIG '' Ndl70mtbAz3LgpHQtnlGrjpPIaTCSgvbZLu6elBl3wwH
'' SIG '' ISWqwtxixfKPZp4hBIJ3x5cjZTUfFh5k82e+gSKaF8gB
'' SIG '' EIfGp5gHpe3BZAxUjAGDP4xCJo+gjSV59nggNfcnIL8I
'' SIG '' Qc13J9mQVuxe6dolbM71PReZ7SxbVCi86F19LleYbndB
'' SIG '' AKV7e6z4LtBmHKgLlifDF4gBvo3ZD6NXJs+U3L0wJuPY
'' SIG '' 00SjST5cS3YdDKCVhQT9PDBxrow/PfPXB7s4Xt1Ztid2
'' SIG '' jGACxPgCys2KzuXIvlNFNQ2xJMru8/+iLOAH2L3IQTJC
'' SIG '' Of8CAwEAAaOCARswggEXMB0GA1UdDgQWBBTKTrXYUzgE
'' SIG '' jV9mR5SNEOB4L5MWZzAfBgNVHSMEGDAWgBTVYzpcijGQ
'' SIG '' 80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBHhkVo
'' SIG '' dHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9w
'' SIG '' cm9kdWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5j
'' SIG '' cmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5o
'' SIG '' dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRz
'' SIG '' L01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNV
'' SIG '' HRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
'' SIG '' CSqGSIb3DQEBCwUAA4IBAQAByqeyOf5A3zXRHpF2CCFy
'' SIG '' 5LA8PvkrnmiFt0JwYhNoLJXYrYRGMhj2/kPtkL2d2Abm
'' SIG '' 8WgI5ywgt5zbe3SyiEQvl6Ob3UHF2E3HLTLLEwNQWIK0
'' SIG '' +RyYb8Cpk19PwY43Exd0teMplz7AvAxCYJaJFg+HMdNV
'' SIG '' fjyO03Ol9wBkP7Va6aXNnqZ68EUS375581TjODfxjBE1
'' SIG '' 8AX2Vcxl/tr0dYCp5PRDkhdk/KMuFRm6GqwixniY8BcE
'' SIG '' px+5SGoA7csAGIjzhTIONAIb9XgqNrRRYi8fk1+hkAYB
'' SIG '' 9f5SrfBwNRWUazLSkesHfQtwwq8S4mCr49Ok4IiDvVED
'' SIG '' 3P0pc3Ua+bFRoYIDeDCCAmACAQEwgeOhgbmkgbYwgbMx
'' SIG '' CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
'' SIG '' MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIx
'' SIG '' JzAlBgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo5OEZELUM2
'' SIG '' MUUtRTY0MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
'' SIG '' U3RhbXAgU2VydmljZaIlCgEBMAkGBSsOAwIaBQADFQBe
'' SIG '' RM6hMlI6sfiKgOB35nTJs7q6XqCBwjCBv6SBvDCBuTEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEn
'' SIG '' MCUGA1UECxMebkNpcGhlciBOVFMgRVNOOjU3RjYtQzFF
'' SIG '' MC01NTRDMSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBT
'' SIG '' b3VyY2UgTWFzdGVyIENsb2NrMA0GCSqGSIb3DQEBBQUA
'' SIG '' AgUA20QPDDAiGA8yMDE2MDcyODA0NTY0NFoYDzIwMTYw
'' SIG '' NzI5MDQ1NjQ0WjB2MDwGCisGAQQBhFkKBAExLjAsMAoC
'' SIG '' BQDbRA8MAgEAMAkCAQACATwCAf8wBwIBAAICGgswCgIF
'' SIG '' ANtFYIwCAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYB
'' SIG '' BAGEWQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAwehIDAN
'' SIG '' BgkqhkiG9w0BAQUFAAOCAQEAmSCXwF6CYECAKpuewBfW
'' SIG '' x8VTTbylZxfdrbbKauQt7JjGRm74yeNhFldEUEiRhtbQ
'' SIG '' Gq7z/0MGP2XitjU5E96h9sOQPftKqjCIrdqt9em/3gjh
'' SIG '' nUt8WV+BJ+V61Y4HKc7Yd2pp7UoTKI5C2T7njFdeFd37
'' SIG '' mP3v6JSri1G+VUIR2l9RsOjs5K74Bof8Jd+p0rXRLFtk
'' SIG '' k851Pzi8oaZTy43UQS2eKoSWUQKthvUqNkoNE3viIUhb
'' SIG '' bqNXmO297NO2n53aciFo7AYO0CciakyCUqEeqkNfiZQA
'' SIG '' 5d/QpQ1VvT10Agkmqp/h+EVcipgG7m7E2aZIN6dS8Dx8
'' SIG '' Zdm0tUkJQu6rWzGCAvUwggLxAgEBMIGTMHwxCzAJBgNV
'' SIG '' BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
'' SIG '' VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
'' SIG '' Q29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
'' SIG '' aW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAAhd/WWAkULse7
'' SIG '' AAAAAACFMA0GCWCGSAFlAwQCAQUAoIIBMjAaBgkqhkiG
'' SIG '' 9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkE
'' SIG '' MSIEIL4tiwlaXkoxH5s78tM5a8kJHHBGL/tpHXnIQ7Zp
'' SIG '' 5CTnMIHiBgsqhkiG9w0BCRACDDGB0jCBzzCBzDCBsQQU
'' SIG '' XkTOoTJSOrH4ioDgd+Z0ybO6ul4wgZgwgYCkfjB8MQsw
'' SIG '' CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
'' SIG '' MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
'' SIG '' b2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3Nv
'' SIG '' ZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAIXf1lgJ
'' SIG '' FC7HuwAAAAAAhTAWBBQrURkbL6IjtNnLxNUHnJi7XIIx
'' SIG '' FTANBgkqhkiG9w0BAQsFAASCAQBu7Q/T+K6LklPCsUVo
'' SIG '' am2WKApzWYpG80A6wDgL+XE0IN63/8qgOeh6ec1jNxv3
'' SIG '' tevJP4xKZ0HcpYXO6/P5aT3CXAVe/Qfxj/llSq5bNQUm
'' SIG '' xAQ3amNOk+WTzt+vDObmyVgxdIvvBvndBCMlOYVc4eVW
'' SIG '' HsYIwgoMENnCPVDF8WFhO04l4xC52S5vJi9DOhEByqBB
'' SIG '' WwtJLMyePk5Zvs/An7xCdYwXy8L1RQTM5UAvlEfAIi9a
'' SIG '' QMlg6GGhkC/HzIdcTy7bPG88HQWGhHOPRsH6obT3a1j8
'' SIG '' yxMagm4JFyAZfOFDRFfkjUlH88Etx1PAZhA3yCyyBsWX
'' SIG '' gxKVnJ8FPSBwLNU7
'' SIG '' End signature block
