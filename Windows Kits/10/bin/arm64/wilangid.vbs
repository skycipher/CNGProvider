' Windows Installer utility to report the language and codepage for a package
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the access of language and codepage values                 
'
Option Explicit

Const msiOpenDatabaseModeReadOnly     = 0
Const msiOpenDatabaseModeTransact     = 1
Const ForReading = 1
Const ForWriting = 2
Const TristateFalse = 0

Const msiViewModifyInsert         = 1
Const msiViewModifyUpdate         = 2
Const msiViewModifyAssign         = 3
Const msiViewModifyReplace        = 4
Const msiViewModifyDelete         = 6

Dim argCount:argCount = Wscript.Arguments.Count
If argCount > 0 Then If InStr(1, Wscript.Arguments(0), "?", vbTextCompare) > 0 Then argCount = 0
If (argCount = 0) Then
	message = "Windows Installer utility to manage language and codepage values for a package." &_
		vbNewLine & "The package language is a summary information property that designates the" &_
		vbNewLine & " primary language and any language transforms that are available, comma delim." &_
		vbNewLine & "The ProductLanguage in the database Property table is the language that is" &_
		vbNewLine & " registered for the product and determines the language used to load resources." &_
		vbNewLine & "The codepage is the ANSI codepage of the database strings, 0 if all ASCII data," &_
		vbNewLine & " and must represent the text data to avoid loss when persisting the database." &_
		vbNewLine & "The 1st argument is the path to MSI database (installer package)" &_
		vbNewLine & "To update a value, the 2nd argument contains the keyword and the 3rd the value:" &_
		vbNewLine & "   Package  {base LangId optionally followed by list of language transforms}" &_
		vbNewLine & "   Product  {LangId of the product (could be updated by language transforms)}" &_
		vbNewLine & "   Codepage {ANSI codepage of text data (use with caution when text exists!)}" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Echo message
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError


' Open database
Dim databasePath:databasePath = Wscript.Arguments(0)
Dim openMode : If argCount >= 3 Then openMode = msiOpenDatabaseModeTransact Else openMode = msiOpenDatabaseModeReadOnly
Dim database : Set database = installer.OpenDatabase(databasePath, openMode) : CheckError

' Update value if supplied
If argCount >= 3 Then
	Dim value:value = Wscript.Arguments(2)
	Select Case UCase(Wscript.Arguments(1))
		Case "PACKAGE"  : SetPackageLanguage database, value
		Case "PRODUCT"  : SetProductLanguage database, value
		Case "CODEPAGE" : SetDatabaseCodepage database, value
		Case Else       : Fail "Invalid value keyword"
	End Select
	CheckError
End If

' Extract language info and compose report message
Dim message:message = "Package language = "         & PackageLanguage(database) &_
					", ProductLanguage = " & ProductLanguage(database) &_
					", Database codepage = "        & DatabaseCodepage(database)
database.Commit : CheckError  ' no effect if opened ReadOnly
Set database = nothing
Wscript.Echo message
Wscript.Quit 0

' Get language list from summary information
Function PackageLanguage(database)
	On Error Resume Next
	Dim sumInfo  : Set sumInfo = database.SummaryInformation(0) : CheckError
	Dim template : template = sumInfo.Property(7) : CheckError
	Dim iDelim:iDelim = InStr(1, template, ";", vbTextCompare)
	If iDelim = 0 Then template = "Not specified!"
	PackageLanguage = Right(template, Len(template) - iDelim)
	If Len(PackageLanguage) = 0 Then PackageLanguage = "0"
End Function

' Get ProductLanguge property from Property table
Function ProductLanguage(database)
	On Error Resume Next
	Dim view : Set view = database.OpenView("SELECT `Value` FROM `Property` WHERE `Property` = 'ProductLanguage'")
	view.Execute : CheckError
	Dim record : Set record = view.Fetch : CheckError
	If record Is Nothing Then ProductLanguage = "Not specified!" Else ProductLanguage = record.IntegerData(1)
End Function

' Get ANSI codepage of database text data
Function DatabaseCodepage(database)
	On Error Resume Next
	Dim WshShell : Set WshShell = Wscript.CreateObject("Wscript.Shell") : CheckError
	Dim tempPath:tempPath = WshShell.ExpandEnvironmentStrings("%TEMP%") : CheckError
	database.Export "_ForceCodepage", tempPath, "codepage.idt" : CheckError
	Dim fileSys : Set fileSys = CreateObject("Scripting.FileSystemObject") : CheckError
	Dim file : Set file = fileSys.OpenTextFile(tempPath & "\codepage.idt", ForReading, False, TristateFalse) : CheckError
	file.ReadLine ' skip column name record
	file.ReadLine ' skip column defn record
	DatabaseCodepage = file.ReadLine
	file.Close
	Dim iDelim:iDelim = InStr(1, DatabaseCodepage, vbTab, vbTextCompare)
	If iDelim = 0 Then Fail "Failure in codepage export file"
	DatabaseCodepage = Left(DatabaseCodepage, iDelim - 1)
	fileSys.DeleteFile(tempPath & "\codepage.idt")
End Function

' Set ProductLanguge property in Property table
Sub SetProductLanguage(database, language)
	On Error Resume Next
	If Not IsNumeric(language) Then Fail "ProductLanguage must be numeric"
	Dim view : Set view = database.OpenView("SELECT `Property`,`Value` FROM `Property`")
	view.Execute : CheckError
	Dim record : Set record = installer.CreateRecord(2)
	record.StringData(1) = "ProductLanguage"
	record.StringData(2) = CStr(language)
	view.Modify msiViewModifyAssign, record : CheckError
End Sub

' Set ANSI codepage of database text data
Sub SetDatabaseCodepage(database, codepage)
	On Error Resume Next
	If Not IsNumeric(codepage) Then Fail "Codepage must be numeric"
	Dim WshShell : Set WshShell = Wscript.CreateObject("Wscript.Shell") : CheckError
	Dim tempPath:tempPath = WshShell.ExpandEnvironmentStrings("%TEMP%") : CheckError
	Dim fileSys : Set fileSys = CreateObject("Scripting.FileSystemObject") : CheckError
	Dim file : Set file = fileSys.OpenTextFile(tempPath & "\codepage.idt", ForWriting, True, TristateFalse) : CheckError
	file.WriteLine ' dummy column name record
	file.WriteLine ' dummy column defn record
	file.WriteLine codepage & vbTab & "_ForceCodepage"
	file.Close : CheckError
	database.Import tempPath, "codepage.idt" : CheckError
	fileSys.DeleteFile(tempPath & "\codepage.idt")
End Sub     

' Set language list in summary information
Sub SetPackageLanguage(database, language)
	On Error Resume Next
	Dim sumInfo  : Set sumInfo = database.SummaryInformation(1) : CheckError
	Dim template : template = sumInfo.Property(7) : CheckError
	Dim iDelim:iDelim = InStr(1, template, ";", vbTextCompare)
	Dim platform : If iDelim = 0 Then platform = ";" Else platform = Left(template, iDelim)
	sumInfo.Property(7) = platform & language
	sumInfo.Persist : CheckError
End Sub

Sub CheckError
	Dim message, errRec
	If Err = 0 Then Exit Sub
	message = Err.Source & " " & Hex(Err) & ": " & Err.Description
	If Not installer Is Nothing Then
		Set errRec = installer.LastErrorRecord
		If Not errRec Is Nothing Then message = message & vbNewLine & errRec.FormatText
	End If
	Fail message
End Sub

Sub Fail(message)
	Wscript.Echo message
	Wscript.Quit 2
End Sub

'' SIG '' Begin signature block
'' SIG '' MIIiEQYJKoZIhvcNAQcCoIIiAjCCIf4CAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' P5ZR+tRLXw+tvFB7cXDc0jFoO6HhZPDQciZh+dfNY5qg
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
'' SIG '' 0hfT2sGUjgd7JXFEqwZq5tTG3yOalnXFMYIV2zCCFdcC
'' SIG '' AQEwgZUwfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
'' SIG '' c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
'' SIG '' BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UE
'' SIG '' AxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAx
'' SIG '' MAITMwAAAPcoVO77wpgbcQAAAAAA9zANBglghkgBZQME
'' SIG '' AgEFAKCBxjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
'' SIG '' BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAv
'' SIG '' BgkqhkiG9w0BCQQxIgQgAJ8cRSOltvo4yxAzz3Dva5kV
'' SIG '' 2Rg0xRqh52euzNRpebMwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQCiPTSYHwia
'' SIG '' 8s9m6zaxBO74Ba1E2ipAc55oXYOl/eIr1rfien+rsqID
'' SIG '' w1HfAo/CS19zLSExOEzM6YDFB0qzhzoPLUs2UwSb0b4F
'' SIG '' Hft33MPy8fIaxZ5sH+YRhBnAweDaKCNn6XgTsK68bT04
'' SIG '' NucNOh1FzI07P6y+HZu3eNFiE8QUeEvPuVjr3AXCvUuL
'' SIG '' y4w8DPTjXi5bDZu8OTDer/ItxKOtd/pX+4FZXKfID01F
'' SIG '' d5okWh9MhJGaREUR+BOB9vfgpjiGvpJiuoePOzZLVgUt
'' SIG '' J2zuSCorffdvbkSaqOpsvGIU77OQ1la2PkBE5insJitS
'' SIG '' 91c1UKDLgi02muIzH4I9UMkuoYITTTCCE0kGCisGAQQB
'' SIG '' gjcDAwExghM5MIITNQYJKoZIhvcNAQcCoIITJjCCEyIC
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCAT0GCyqGSIb3DQEJ
'' SIG '' EAEEoIIBLASCASgwggEkAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIH7FwVNcRm1MJWFDvd17GpaG
'' SIG '' w2XXJi9YssNEvNBggLWgAgZXj6hkzisYEzIwMTYwNzI4
'' SIG '' MTQwMDMyLjA5OVowBwIBAYACAfSggbmkgbYwgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjozMUM1LTMwQkEt
'' SIG '' N0M5MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
'' SIG '' bXAgU2VydmljZaCCDtAwggZxMIIEWaADAgECAgphCYEq
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
'' SIG '' AAAAmbqvi+MEOGuIAAAAAACZMA0GCSqGSIb3DQEBCwUA
'' SIG '' MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
'' SIG '' dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
'' SIG '' aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
'' SIG '' Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE2
'' SIG '' MDQyNzE3MDYxOVoXDTE3MDcyNzE3MDYxOVowgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjozMUM1LTMwQkEt
'' SIG '' N0M5MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
'' SIG '' bXAgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEP
'' SIG '' ADCCAQoCggEBAOIecb5DBpjvg9ZADf21OXegZrYo3dZo
'' SIG '' +EHwBPPISeZ7MlqE58xEGAZRHfGPw9FPKL225yGd406K
'' SIG '' S4aNDXIKtl6uPV55eQxNilr8zwKzAJY61auCO/Cglq8+
'' SIG '' RRG40oV1PIJLotWSL5wF51Gg5qMmymCpv6P1+nriELNi
'' SIG '' ia1wwe+6OzM8C45kZ149xPK9/KLlr4EqXnZq9B1Mifwb
'' SIG '' Jc2Fcn7j6uDnSqFW0RWCilXerY4S657jb+5Wspk89+T5
'' SIG '' s8AB8U0Sql24Hwg2Q/BlmAfHzwSEYScCHmNFk0DyAFPo
'' SIG '' C4OpdqbpSEK/L/08LcL8MUBLNuav2I+YSl3YRn8Uc3yX
'' SIG '' Px0CAwEAAaOCARswggEXMB0GA1UdDgQWBBSLksJsJor8
'' SIG '' +GyEEHcEdxlVJwHMQjAfBgNVHSMEGDAWgBTVYzpcijGQ
'' SIG '' 80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBHhkVo
'' SIG '' dHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9w
'' SIG '' cm9kdWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5j
'' SIG '' cmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5o
'' SIG '' dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRz
'' SIG '' L01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNV
'' SIG '' HRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
'' SIG '' CSqGSIb3DQEBCwUAA4IBAQAuNxZkKaJTtDDXj1AYT0Jd
'' SIG '' V0uPv4gMfQsWs4qi7lBJ9y2AwY6btRj5QUXtvt29ovJP
'' SIG '' XC2wyb+R/Uyr2Ajlqqb/GowPmEbmByCSSTCbq7djK6z1
'' SIG '' H++7sUpVfYarZIWXp+fr94jAlv2cE5ANIrNmr3J+NM1D
'' SIG '' neum6HvVJzAovNf5u9QLUe3o9dISWDklWZBxipaarpkp
'' SIG '' YFOeh+hE8dI6+o2m+gkJK7BuaSHlmE+phX38Jp1VvrKb
'' SIG '' 9mJFAVIz6Z9ZowQk20rUsN0ir2q8oz/ABQH9wM75no7z
'' SIG '' B6hD0p2KAgb+qzJScJL6QakCNYLAyQef8JA5wg4oAM0i
'' SIG '' Xok3XfakxOQvoYIDeTCCAmECAQEwgeOhgbmkgbYwgbMx
'' SIG '' CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
'' SIG '' MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIx
'' SIG '' JzAlBgNVBAsTHm5DaXBoZXIgRFNFIEVTTjozMUM1LTMw
'' SIG '' QkEtN0M5MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
'' SIG '' U3RhbXAgU2VydmljZaIlCgEBMAkGBSsOAwIaBQADFQCx
'' SIG '' NuJXpegpXNS+a6n595abD/g2JaCBwjCBv6SBvDCBuTEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEn
'' SIG '' MCUGA1UECxMebkNpcGhlciBOVFMgRVNOOjU3RjYtQzFF
'' SIG '' MC01NTRDMSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBT
'' SIG '' b3VyY2UgTWFzdGVyIENsb2NrMA0GCSqGSIb3DQEBBQUA
'' SIG '' AgUA20PPXTAiGA8yMDE2MDcyODAwMjUwMVoYDzIwMTYw
'' SIG '' NzI5MDAyNTAxWjB3MD0GCisGAQQBhFkKBAExLzAtMAoC
'' SIG '' BQDbQ89dAgEAMAoCAQACAgEpAgH/MAcCAQACAhglMAoC
'' SIG '' BQDbRSDdAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisG
'' SIG '' AQQBhFkKAwGgCjAIAgEAAgMW42ChCjAIAgEAAgMHoSAw
'' SIG '' DQYJKoZIhvcNAQEFBQADggEBAJ8si40j47lkWCpbKV/v
'' SIG '' /35Fxu0lpx1yHE6yRthLuDsCQNcy/fE4U+1brA+iZpkj
'' SIG '' Q1wXx0WGOcQzT0Kar1sE0StiJloAPqhLuwRKEdtMhIeT
'' SIG '' RHeSAi8esiujzkNVeLATQTtPCVve9470al1LFSBf0nqs
'' SIG '' cIJIpZhRpM7QeNLITIDEoHRKPtpan9lv6Hec0m0NsdWo
'' SIG '' NffGutswAx25cFT2x1WsWOzefgxGA60PGBH2IKFLNQFP
'' SIG '' 0ZBYE9HQTJHXMRa5iH3dsM/9rFEcrGEOsGgCS2goSS++
'' SIG '' DSaNxbjCsQ72ayGPc8TZ1aCwoXC13OFjLhJKjuXyc75t
'' SIG '' gxDuRadgwVK0dOMxggL1MIIC8QIBATCBkzB8MQswCQYD
'' SIG '' VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
'' SIG '' A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
'' SIG '' IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
'' SIG '' VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAJm6r4vjBDhr
'' SIG '' iAAAAAAAmTANBglghkgBZQMEAgEFAKCCATIwGgYJKoZI
'' SIG '' hvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJ
'' SIG '' BDEiBCAQN1kPSOBJiC7ifxTpOY2Y9bDc4trhjBumK20D
'' SIG '' j+7kAzCB4gYLKoZIhvcNAQkQAgwxgdIwgc8wgcwwgbEE
'' SIG '' FLE24lel6Clc1L5rqfn3lpsP+DYlMIGYMIGApH4wfDEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9z
'' SIG '' b2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAACZuq+L
'' SIG '' 4wQ4a4gAAAAAAJkwFgQUZ7fD9XduVsjOt8pLLqAVvZ5B
'' SIG '' hEIwDQYJKoZIhvcNAQELBQAEggEAMqFQK93hMc9a4P1J
'' SIG '' FZgaVgrxDGPXLcun4jcgiVy5Aq7no2JzZOEjLcG0Sz1F
'' SIG '' UqA0G3jjMGgILqcHJ8yw0R5oa6ItWFnOoLSX6WB+vGdq
'' SIG '' HFovNEEIVTQ/ZbyzBr9QoX77PaRt9FD2mYWIYMJ0MUOt
'' SIG '' Sqa17IpMIxWKrnvGOLR2M3NO9y0cSkrRzuiwO4GS/YVb
'' SIG '' SFe4xDEvJ7JxL/p0XMRbRrvVW30X25R6UnDN5aEd7AFP
'' SIG '' n0zczRwwQf2KnG+dGxXYTw++dXrC5OlAm9mvvASJxbLn
'' SIG '' U3q2YIsf4UD8l5Cam81XrMVs7eXPco21Z7hsaZQIhp+j
'' SIG '' fBMT0cO9OGjutTTlwQ==
'' SIG '' End signature block
