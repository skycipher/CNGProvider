' Windows Installer database table import for use with Windows Scripting Host
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the use of the Database.Import method and MsiDatabaseImport API
'
Option Explicit

Const msiOpenDatabaseModeReadOnly     = 0
Const msiOpenDatabaseModeTransact     = 1
Const msiOpenDatabaseModeCreate       = 3
Const ForAppending = 8
Const ForReading = 1
Const ForWriting = 2
Const TristateTrue = -1

Dim argCount:argCount = Wscript.Arguments.Count
Dim iArg:iArg = 0
If (argCount < 3) Then
	Wscript.Echo "Windows Installer database table import utility" &_
		vbNewLine & " 1st argument is the path to MSI database (installer package)" &_
		vbNewLine & " 2nd argument is the path to folder containing the imported files" &_
		vbNewLine & " Subseqent arguments are names of archive files to import" &_
		vbNewLine & " Wildcards, such as *.idt, can be used to import multiple files" &_
		vbNewLine & " Specify /c or -c anywhere before file list to create new database" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

Dim openMode:openMode = msiOpenDatabaseModeTransact
Dim databasePath:databasePath = NextArgument
Dim folder:folder = NextArgument

Dim WshShell, fileSys
Set WshShell = Wscript.CreateObject("Wscript.Shell") : CheckError
Set fileSys = CreateObject("Scripting.FileSystemObject") : CheckError

' Open database and process list of files
Dim database, table
Set database = installer.OpenDatabase(databasePath, openMode) : CheckError
While iArg < argCount
	table = NextArgument
	' Check file name for wildcard specification
	If (InStr(1,table,"*",vbTextCompare) <> 0) Or (InStr(1,table,"?",vbTextCompare) <> 0) Then
		' Obtain list of files matching wildcard specification
		Dim file, tempFilePath
		tempFilePath = WshShell.ExpandEnvironmentStrings("%TEMP%") & "\dir.tmp"
		WshShell.Run "cmd.exe /U /c dir /b " & folder & "\" & table & ">" & tempFilePath, 0, True : CheckError
		Set file = fileSys.OpenTextFile(tempFilePath, ForReading, False, TristateTrue) : CheckError
		' Import each file in directory list
		Do While file.AtEndOfStream <> True
			table = file.ReadLine
			database.Import folder, table : CheckError
		Loop
		file.Close
		fileSys.DeleteFile(tempFilePath)
	Else
		database.Import folder, table : CheckError
	End If
Wend
database.Commit 'commit changes if no import errors
Wscript.Quit 0

Function NextArgument
	Dim arg, chFlag
	Do
		arg = Wscript.Arguments(iArg)
		iArg = iArg + 1
		chFlag = AscW(arg)
		If (chFlag = AscW("/")) Or (chFlag = AscW("-")) Then
			chFlag = UCase(Right(arg, Len(arg)-1))
			If chFlag = "C" Then 
				openMode = msiOpenDatabaseModeCreate
			Else
				Wscript.Echo "Invalid option flag:", arg : Wscript.Quit 1
			End If
		Else
			Exit Do
		End If
	Loop
	NextArgument = arg
End Function

Sub CheckError
	Dim message, errRec
	If Err = 0 Then Exit Sub
	message = Err.Source & " " & Hex(Err) & ": " & Err.Description
	If Not installer Is Nothing Then
		Set errRec = installer.LastErrorRecord
		If Not errRec Is Nothing Then message = message & vbNewLine & errRec.FormatText
	End If
	Wscript.Echo message
	Wscript.Quit 2
End Sub

'' SIG '' Begin signature block
'' SIG '' MIIiDwYJKoZIhvcNAQcCoIIiADCCIfwCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' URtattTTdos4rg+Jt96T7zPQ8Pzvx4qAdD0rt5bwgTmg
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
'' SIG '' 0hfT2sGUjgd7JXFEqwZq5tTG3yOalnXFMYIV2TCCFdUC
'' SIG '' AQEwgZUwfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
'' SIG '' c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
'' SIG '' BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UE
'' SIG '' AxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAx
'' SIG '' MAITMwAAAPcoVO77wpgbcQAAAAAA9zANBglghkgBZQME
'' SIG '' AgEFAKCBxjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
'' SIG '' BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAv
'' SIG '' BgkqhkiG9w0BCQQxIgQg7eWUfGzAc/5A7zipkVLl2TNP
'' SIG '' bIlzesQq/vdNLq54wLAwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQBbEuPYHatq
'' SIG '' L+/4LTXpewUSiM/wfkd0NWDGYpgZMClGf/sMYhbwliq9
'' SIG '' ErEUskZzPIY+fcF4/IQQNCCav1RQkMXGdhF0rg+QLdf9
'' SIG '' fcbpTWxYrOtoIEwKocJRxLoa9R+08OCLBiDyy9zA1a5I
'' SIG '' LeeBSmYUHsIM9xWI5+e+OgKrBbx+33zrWaIozPfH2Z2Q
'' SIG '' bfSCE0NBx5Txxeur1iFItZoPX2x+H7EVCPolmKoTafVi
'' SIG '' Zn56E++OvKgsKFuQi2HfADGS+h+a6JFt8bwlXjlD1htV
'' SIG '' lFnHNeAs2d0LDWjLFOijAglZ8w4/KXPCi9kd+YYN5M7/
'' SIG '' EiUDxnKwrkHIpVqTWFDzwlZsoYITSzCCE0cGCisGAQQB
'' SIG '' gjcDAwExghM3MIITMwYJKoZIhvcNAQcCoIITJDCCEyAC
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCATwGCyqGSIb3DQEJ
'' SIG '' EAEEoIIBKwSCAScwggEjAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIEck1japfqLD9i6azzunFxfR
'' SIG '' 4qyt2m2Zft+I5lCyBnx5AgZXj597ys4YEjIwMTYwNzI4
'' SIG '' MTQwMDMyLjI2WjAHAgEBgAIB9KCBuaSBtjCBszELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUG
'' SIG '' A1UECxMebkNpcGhlciBEU0UgRVNOOjcyOEQtQzQ1Ri1G
'' SIG '' OUVCMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
'' SIG '' cCBTZXJ2aWNloIIOzzCCBnEwggRZoAMCAQICCmEJgSoA
'' SIG '' AAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYT
'' SIG '' AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
'' SIG '' EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
'' SIG '' cG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290
'' SIG '' IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEw
'' SIG '' MDcwMTIxMzY1NVoXDTI1MDcwMTIxNDY1NVowfDELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
'' SIG '' IFRpbWUtU3RhbXAgUENBIDIwMTAwggEiMA0GCSqGSIb3
'' SIG '' DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX
'' SIG '' 9fp/aZRrdFQQ1aUKAIKF++18aEssX8XD5WHCdrc+Zitb
'' SIG '' 8BVTJwQxH0EbGpUdzgkTjnxhMFmxMEQP8WCIhFRDDNdN
'' SIG '' uDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhH
'' SIG '' hjKEHnRhZ5FfgVSxz5NMksHEpl3RYRNuKMYa+YaAu99h
'' SIG '' /EbBJx0kZxJyGiGKr0tkiVBisV39dx898Fd1rL2KQk1A
'' SIG '' UdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox8NpO
'' SIG '' BpG2iAg16HgcsOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8
'' SIG '' wMlEXV4WnAEFTyJNAgMBAAGjggHmMIIB4jAQBgkrBgEE
'' SIG '' AYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIoxkPNDe3xG
'' SIG '' G8UzaFqFbVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBD
'' SIG '' AEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8w
'' SIG '' HwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186aGMQw
'' SIG '' VgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNy
'' SIG '' b3NvZnQuY29tL3BraS9jcmwvcHJvZHVjdHMvTWljUm9v
'' SIG '' Q2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsGAQUFBwEB
'' SIG '' BE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNy
'' SIG '' b3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRf
'' SIG '' MjAxMC0wNi0yMy5jcnQwgaAGA1UdIAEB/wSBlTCBkjCB
'' SIG '' jwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRw
'' SIG '' Oi8vd3d3Lm1pY3Jvc29mdC5jb20vUEtJL2RvY3MvQ1BT
'' SIG '' L2RlZmF1bHQuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwA
'' SIG '' ZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEAdABl
'' SIG '' AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH
'' SIG '' 5ohRDeLG4Jg/gXEDPZ2joSFvs+umzPUxvs8F4qn++ldt
'' SIG '' GTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgrUYJEEvu5
'' SIG '' U4zM9GASinbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/
'' SIG '' f8Z/8jd9Wj8c8pl5SpFSAK84Dxf1L3mBZdmptWvkx872
'' SIG '' ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFwnzJKJ/1Vry/+
'' SIG '' tuWOM7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlK
'' SIG '' cWOdeyFtw5yjojz6f32WapB4pm3S4Zz5Hfw42JT0xqUK
'' SIG '' loakvZ4argRCg7i1gJsiOCC1JeVk7Pf0v35jWSUPei45
'' SIG '' V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4Ttx
'' SIG '' Cd9ddJgiCGHasFAeb73x4QDf5zEHpJM692VHeOj4qEir
'' SIG '' 995yfmFrb3epgcunCaw5u+zGy9iCtHLNHfS4hQEegPsb
'' SIG '' iSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3
'' SIG '' yKxO2ii4sanblrKnQqLJzxlBTeCG+SqaoxFmMNO7dDJL
'' SIG '' 32N79ZmKLxvHIa9Zta7cRDyXUHHXodLFVeNp3lfB0d4w
'' SIG '' wP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wknHNWz
'' SIG '' fjUeCLraNtvTX4/edIhJEjCCBNowggPCoAMCAQICEzMA
'' SIG '' AACHkOfsJ+GfSXYAAAAAAIcwDQYJKoZIhvcNAQELBQAw
'' SIG '' fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
'' SIG '' b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
'' SIG '' Y3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWlj
'' SIG '' cm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMTYw
'' SIG '' MzMwMTkyNDI1WhcNMTcwNjMwMTkyNDI1WjCBszELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUG
'' SIG '' A1UECxMebkNpcGhlciBEU0UgRVNOOjcyOEQtQzQ1Ri1G
'' SIG '' OUVCMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
'' SIG '' cCBTZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
'' SIG '' MIIBCgKCAQEAtFVNhQqJjK72YtAbldHHTSQ2uYZysFMg
'' SIG '' +3gurDv+AAUcaNlK3hTgAxs5ZAP8uZjiGXczHEu1zQyu
'' SIG '' AHqdzHScp/G1ONi9XwTH+M+i6QwD5y3se3heiq0xsSaT
'' SIG '' U9zo51dnOyzIVcnxAhZHYS6rzVO/yFqEbp7LWu7zcWcw
'' SIG '' RSaG3KfsfUOXUPQARMp0uckjkVb8FHsIKwo0OCHjB3Kc
'' SIG '' nikwejYFFQwf1dsoDgWjnGESkKKkYrC6nQUNLRojhGDO
'' SIG '' nJlCbBlPhkMOj/CsizBq0lR1lusZ4imOWCR+ItVX/V82
'' SIG '' py73OkeGQcUhLY26U5SigRCBXrT9xyhQDmIHzi4glKU6
'' SIG '' EQIDAQABo4IBGzCCARcwHQYDVR0OBBYEFE6MSEWj/5dS
'' SIG '' E7+8XjN+P4b/vmb6MB8GA1UdIwQYMBaAFNVjOlyKMZDz
'' SIG '' Q3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJoEeGRWh0
'' SIG '' dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3By
'' SIG '' b2R1Y3RzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNy
'' SIG '' bDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0
'' SIG '' dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMv
'' SIG '' TWljVGltU3RhUENBXzIwMTAtMDctMDEuY3J0MAwGA1Ud
'' SIG '' EwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJ
'' SIG '' KoZIhvcNAQELBQADggEBAF+DV6UKRZFHKjIWIjhZI7Zj
'' SIG '' ImgOjOeCPXIh5lqSmTgLdMTY2lGP+7YfdVEQROtUMT2/
'' SIG '' qDwiX2AYqHEa52N1WnueMPQVpkz/04+d8ce6aDkPsq85
'' SIG '' QohOxfIriHLHFuF7Pt7j+1oMOrF1OO+xa/HZZecrU+Gf
'' SIG '' fQEwELTXlcyfVA4o1+vDHSfiIcpYoptHATC5av0J5gWY
'' SIG '' m4mYd+wy8vo1t2mknLcm8tq8O5aX8Ri13nnftrbaTUL8
'' SIG '' A4DgyaGCrW6BiCtOuGL3YcqwsMgjcSmjReCERtyhUUe+
'' SIG '' 5O8QL+4pc6B6YHXIAW/k5IoOzZ/Dq8zihi4xWL91Shr0
'' SIG '' 2w9CD7XOf+WhggN4MIICYAIBATCB46GBuaSBtjCBszEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEn
'' SIG '' MCUGA1UECxMebkNpcGhlciBEU0UgRVNOOjcyOEQtQzQ1
'' SIG '' Ri1GOUVCMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1T
'' SIG '' dGFtcCBTZXJ2aWNloiUKAQEwCQYFKw4DAhoFAAMVAHfl
'' SIG '' GF9D6izjBkctfjej5HLCUbfdoIHCMIG/pIG8MIG5MQsw
'' SIG '' CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
'' SIG '' MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
'' SIG '' b2Z0IENvcnBvcmF0aW9uMQ0wCwYDVQQLEwRNT1BSMScw
'' SIG '' JQYDVQQLEx5uQ2lwaGVyIE5UUyBFU046NTdGNi1DMUUw
'' SIG '' LTU1NEMxKzApBgNVBAMTIk1pY3Jvc29mdCBUaW1lIFNv
'' SIG '' dXJjZSBNYXN0ZXIgQ2xvY2swDQYJKoZIhvcNAQEFBQAC
'' SIG '' BQDbRA8yMCIYDzIwMTYwNzI4MDQ1NzIyWhgPMjAxNjA3
'' SIG '' MjkwNDU3MjJaMHYwPAYKKwYBBAGEWQoEATEuMCwwCgIF
'' SIG '' ANtEDzICAQAwCQIBAAIBDAIB/zAHAgEAAgIYszAKAgUA
'' SIG '' 20VgsgIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEE
'' SIG '' AYRZCgMBoAowCAIBAAIDFuNgoQowCAIBAAIDB6EgMA0G
'' SIG '' CSqGSIb3DQEBBQUAA4IBAQCSsxLZL3uQPIgYhdlpS6yW
'' SIG '' CCwe4mf+MDKyF3tIZNFg6iK50dShqWdeecpg2E495IlD
'' SIG '' mT10V6f9V8fFkY8CJnqqQUlo2qShj+Vgwz+W86NvjPO4
'' SIG '' bP5qMJz+P+gPEvzzh8HJs+LNUZZruzWWajT/aGrWMm8p
'' SIG '' 7IUlC1ND08gkcYaSu7QgyxKFjz32KaORVTQ/8+NCxpf/
'' SIG '' Cvw7PSoc+7f/4YEhQKuJoweLsJ6nLiiObxgbeIZjHM5k
'' SIG '' nU9anUVcj/QF7+8zoj5TG5V+dnu8op7d4MJHsvXIc5RL
'' SIG '' 2lF9JbpLtbArbG2+W2oWzHz9MTwYPQvZzx0h7IRZTNqU
'' SIG '' 9V6RfB+g3IwvMYIC9TCCAvECAQEwgZMwfDELMAkGA1UE
'' SIG '' BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
'' SIG '' BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
'' SIG '' b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
'' SIG '' bWUtU3RhbXAgUENBIDIwMTACEzMAAACHkOfsJ+GfSXYA
'' SIG '' AAAAAIcwDQYJYIZIAWUDBAIBBQCgggEyMBoGCSqGSIb3
'' SIG '' DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQx
'' SIG '' IgQgYZSXIj4pK+UvQQwxPLlhT/rTC7BY5CgIia+n+sng
'' SIG '' DDswgeIGCyqGSIb3DQEJEAIMMYHSMIHPMIHMMIGxBBR3
'' SIG '' 5RhfQ+os4wZHLX43o+RywlG33TCBmDCBgKR+MHwxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29m
'' SIG '' dCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAAh5Dn7Cfh
'' SIG '' n0l2AAAAAACHMBYEFAZZSArNsTQr+wmVVhjD2qrsw3zn
'' SIG '' MA0GCSqGSIb3DQEBCwUABIIBAE35o+aOJv0TIVOvg5hi
'' SIG '' cFrtSddfBl7d1Ko2jukwcZBoMafkU3NhVzUO5AU1kRfI
'' SIG '' sMiGuw5tw+z+htZeiArXkI5dzO/cmo8mjgW+zCX2REHF
'' SIG '' /GFLG4TGN3XNBOTQGuI3YmlymSBd1+VXANi34HIF9/xx
'' SIG '' LopWOUzGVMyElzMB5PqLRm+ll958PHhW5lvzP8GN4RpC
'' SIG '' OKT3PwSDwRVm6NMbxGs1JWDN2vv0unF4oH8CEWJRsbha
'' SIG '' HdlBYztvt7XpJr0y5oK2Ko0M4NBulz2AQz/Vkgin+qoA
'' SIG '' H+roKUazXaJc6GayddSHSKx+uRlgXN9trfRfobvW/WH0
'' SIG '' 4JKJC8l6KhlEe94=
'' SIG '' End signature block
