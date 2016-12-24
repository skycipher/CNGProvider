' Windows Installer utility to add a transform or nested database as a substorage
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the use of the database _Storages table
'
Option Explicit

Const msiOpenDatabaseModeReadOnly     = 0
Const msiOpenDatabaseModeTransact     = 1
Const msiOpenDatabaseModeCreate       = 3

Const msiViewModifyInsert         = 1
Const msiViewModifyUpdate         = 2
Const msiViewModifyAssign         = 3
Const msiViewModifyReplace        = 4
Const msiViewModifyDelete         = 6

Const ForAppending = 8
Const ForReading = 1
Const ForWriting = 2
Const TristateTrue = -1

' Check arg count, and display help if argument not present or contains ?
Dim argCount:argCount = Wscript.Arguments.Count
If argCount > 0 Then If InStr(1, Wscript.Arguments(0), "?", vbTextCompare) > 0 Then argCount = 0
If (argCount = 0) Then
	Wscript.Echo "Windows Installer database substorage managment utility" &_
		vbNewLine & " 1st argument is the path to MSI database (installer package)" &_
		vbNewLine & " 2nd argument is the path to a transform or database to import" &_
		vbNewLine & " If the 2nd argument is missing, substorages will be listed" &_
		vbNewLine & " 3rd argument is optional, the name used for the substorage" &_
		vbNewLine & " If the 3rd arugment is missing, the file name is used" &_
		vbNewLine & " To remove a substorage, use /D or -D as the 2nd argument" &_
		vbNewLine & " followed by the name of the substorage to remove" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

' Evaluate command-line arguments and set open and update modes
Dim databasePath:databasePath = Wscript.Arguments(0)
Dim openMode    : If argCount = 1 Then openMode = msiOpenDatabaseModeReadOnly Else openMode = msiOpenDatabaseModeTransact
Dim updateMode  : If argCount > 1 Then updateMode = msiViewModifyAssign  'Either insert or replace existing row
Dim importPath  : If argCount > 1 Then importPath = Wscript.Arguments(1)
Dim storageName : If argCount > 2 Then storageName = Wscript.Arguments(2)
If storageName = Empty And importPath <> Empty Then storageName = Right(importPath, Len(importPath) - InStrRev(importPath, "\",-1,vbTextCompare))
If UCase(importPath) = "/D" Or UCase(importPath) = "-D" Then updateMode = msiViewModifyDelete : importPath = Empty 'substorage will be deleted if no input data

' Open database and create a view on the _Storages table
Dim sqlQuery : Select Case updateMode
	Case msiOpenDatabaseModeReadOnly: sqlQuery = "SELECT `Name` FROM _Storages"
	Case msiViewModifyAssign:         sqlQuery = "SELECT `Name`,`Data` FROM _Storages"
	Case msiViewModifyDelete:         sqlQuery = "SELECT `Name` FROM _Storages WHERE `Name` = ?"
End Select
Dim database : Set database = installer.OpenDatabase(databasePath, openMode) : CheckError
Dim view     : Set view = database.OpenView(sqlQuery)
Dim record

If openMode = msiOpenDatabaseModeReadOnly Then 'If listing storages, simply fetch all records
	Dim message, name
	view.Execute : CheckError
	Do
		Set record = view.Fetch
		If record Is Nothing Then Exit Do
		name = record.StringData(1)
		If message = Empty Then message = name Else message = message & vbNewLine & name
	Loop
	Wscript.Echo message
Else 'If adding a storage, insert a row, else if removing a storage, delete the row
	Set record = installer.CreateRecord(2)
	record.StringData(1) = storageName
	view.Execute record : CheckError
	If importPath <> Empty Then  'Insert storage - copy data into stream
		record.SetStream 2, importPath : CheckError
	Else  'Delete storage, fetch first to provide better error message if missing
		Set record = view.Fetch
		If record Is Nothing Then Wscript.Echo "Storage not present:", storageName : Wscript.Quit 2
	End If
	view.Modify updateMode, record : CheckError
	database.Commit : CheckError
	Set view = Nothing
	Set database = Nothing
	CheckError
End If

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
'' SIG '' MIIiEQYJKoZIhvcNAQcCoIIiAjCCIf4CAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' sTAYbRu9/MmUNmYRZx8kYofzzKM5ELfE6P0ECXnWOFWg
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
'' SIG '' BgkqhkiG9w0BCQQxIgQgPx5Ydb0eocKGuSqV7yII1JQh
'' SIG '' IeeOjapMIdMo3bllOXwwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQA3hqV5ae6/
'' SIG '' 1nRY/NYc9X2DBHY641kiWXnqqgZRRDKX+RfX4K4dHj2p
'' SIG '' CKC5k/igDMP0g9X6w7rQFflubrMyrqbfvBsFJrHaUnrB
'' SIG '' NGkpPV4Fy5BWJ+BhdDuB5v3uzsh9PinY7YDncAbXeEA/
'' SIG '' WizFTht0ZYMFl67wbdpHW5vbtT1dG1sYRAUmec2i/3Tq
'' SIG '' QH1mjhbRT0doR2eVajm7bl4kQqtwENSPhEGbEwrVTo3Q
'' SIG '' 8EFdKf35Wk+eELiCHsneR0E6W81V3f4GQn4Y2CKgDYR4
'' SIG '' TMEMhsjdwc8yGBJNj7eWxj8yeU/OgxOBGxm3BzfSVuMM
'' SIG '' s3n+tMpiRj+a84EZTFKhH6WVoYITTTCCE0kGCisGAQQB
'' SIG '' gjcDAwExghM5MIITNQYJKoZIhvcNAQcCoIITJjCCEyIC
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCAT0GCyqGSIb3DQEJ
'' SIG '' EAEEoIIBLASCASgwggEkAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIIaNdfYTBlOY5XifjhbbrKeO
'' SIG '' ligw7B6nxXQBsEnU9nukAgZXj6OZ13YYEzIwMTYwNzI4
'' SIG '' MTQwMDMzLjI4OVowBwIBAYACAfSggbmkgbYwgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo3RDJFLTM3ODIt
'' SIG '' QjBGNzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
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
'' SIG '' AAAAmyHXlgGTV4ukAAAAAACbMA0GCSqGSIb3DQEBCwUA
'' SIG '' MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
'' SIG '' dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
'' SIG '' aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
'' SIG '' Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE2
'' SIG '' MDQyNzE3MDYyMFoXDTE3MDcyNzE3MDYyMFowgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo3RDJFLTM3ODIt
'' SIG '' QjBGNzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
'' SIG '' bXAgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEP
'' SIG '' ADCCAQoCggEBALbvrriJuDqeVY4pFrPxu5il65hIPBbo
'' SIG '' W+7UkVGQjnqL+j2yyrMeurr5tfOnaDxyK49uL/hKJefD
'' SIG '' e7GV17b6C+IJxlE8Cl+XAPfGlXLENS+9rByDJriCw8VD
'' SIG '' sOvYe3C2w9/d/rLgcTdDjhuDRjSPEBbk93VtQm8lzYSO
'' SIG '' 1GXooHqunYwMAEfKvWSEtY6M7PDeIqafk9dC7wY+OMGS
'' SIG '' ICONF6OamSMWz3dO9OXCmQQiDDcvrS5wXeiRiM3ayg/C
'' SIG '' RBfIiJFI09DkBJ7CEWCdLWIrA9acYMgNc0BkRIFYiZsB
'' SIG '' 3dQcQkH6cjmGNJvq+IERvzdSKcFHI5Y63Qz1BbtoMRfV
'' SIG '' KD8CAwEAAaOCARswggEXMB0GA1UdDgQWBBTW/1AJEHzC
'' SIG '' NERnrnprbal1uGJ/qTAfBgNVHSMEGDAWgBTVYzpcijGQ
'' SIG '' 80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBHhkVo
'' SIG '' dHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9w
'' SIG '' cm9kdWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5j
'' SIG '' cmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5o
'' SIG '' dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRz
'' SIG '' L01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNV
'' SIG '' HRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
'' SIG '' CSqGSIb3DQEBCwUAA4IBAQCkazOWSp3Gmhf0RZ/zQwSw
'' SIG '' ADscSbXlhjDYWYLmMilSN75eE7krj7U+W6/cC4i/UpBv
'' SIG '' bW49nnT8PHlJ8pP8b33X7O3N4TUCJvR1ip2U8u6lNiap
'' SIG '' MidVZOEITBMG+jBcV5mMsiBsi4WQGxOKgLT9xdoN/rG6
'' SIG '' abXf6hwhHcUhI3JfgkkJPYNlakPyiRwiaWP4M2l2FnR6
'' SIG '' RKztf1tv8d98X8Saxap+ttdBPlssIYccBTpsUOQ9f2Sz
'' SIG '' tSrdsgR+gtZJL5ZusZdvdrKYGONH9phCVH2D2DMFYgfP
'' SIG '' zfVDDRyLVXL3D/RZBhwBE68Dk2iyBMm5Sha2v0LZZHlm
'' SIG '' FgwWs7KiUzqNoYIDeTCCAmECAQEwgeOhgbmkgbYwgbMx
'' SIG '' CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
'' SIG '' MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIx
'' SIG '' JzAlBgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo3RDJFLTM3
'' SIG '' ODItQjBGNzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
'' SIG '' U3RhbXAgU2VydmljZaIlCgEBMAkGBSsOAwIaBQADFQA1
'' SIG '' 1OJfvIyQac7J9puhCKNY17V/7KCBwjCBv6SBvDCBuTEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEn
'' SIG '' MCUGA1UECxMebkNpcGhlciBOVFMgRVNOOjU3RjYtQzFF
'' SIG '' MC01NTRDMSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBT
'' SIG '' b3VyY2UgTWFzdGVyIENsb2NrMA0GCSqGSIb3DQEBBQUA
'' SIG '' AgUA20PQHTAiGA8yMDE2MDcyODAwMjgxM1oYDzIwMTYw
'' SIG '' NzI5MDAyODEzWjB3MD0GCisGAQQBhFkKBAExLzAtMAoC
'' SIG '' BQDbQ9AdAgEAMAoCAQACAgjwAgH/MAcCAQACAhhXMAoC
'' SIG '' BQDbRSGdAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisG
'' SIG '' AQQBhFkKAwGgCjAIAgEAAgMW42ChCjAIAgEAAgMHoSAw
'' SIG '' DQYJKoZIhvcNAQEFBQADggEBABM8JuLP4wVlbgYP+VOV
'' SIG '' GanpAMmmPfMrsSctFnw6AWEPHGlab0fgEhroV58jGDac
'' SIG '' J6tEZdILsUD/M0vwzLk4w2jpOWCn3mSPR/pJKVqbdjJu
'' SIG '' dYINpQvF4InYXqFZNf7H7rVionh4G/C4H0DsITYSNAQ+
'' SIG '' qlTSKWwGjmuRfh6q8FgElGqyJvKUA2nziZ7hFY7/xLl3
'' SIG '' p8euljz1Xb3dwIFuInoIc3ZfhTdZmnlujMwrnsAumyx+
'' SIG '' lVgClJvfbfc5nJCSBfmI54MicOWuBrLwZPSebAq5DTcY
'' SIG '' YsYo6NaUQsGIZxYxqg+zUsgWpmws5Ztwc4W2ymOo6MPt
'' SIG '' bGCeSpEldIwgynYxggL1MIIC8QIBATCBkzB8MQswCQYD
'' SIG '' VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
'' SIG '' A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
'' SIG '' IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
'' SIG '' VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAJsh15YBk1eL
'' SIG '' pAAAAAAAmzANBglghkgBZQMEAgEFAKCCATIwGgYJKoZI
'' SIG '' hvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJ
'' SIG '' BDEiBCDlmn6vJ573id/I/53N4FgABRzaTu5qvniAP1Pz
'' SIG '' KW0ClDCB4gYLKoZIhvcNAQkQAgwxgdIwgc8wgcwwgbEE
'' SIG '' FDXU4l+8jJBpzsn2m6EIo1jXtX/sMIGYMIGApH4wfDEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9z
'' SIG '' b2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAACbIdeW
'' SIG '' AZNXi6QAAAAAAJswFgQUilBz6fOEr4KcWkrH++4yR4B2
'' SIG '' 0JAwDQYJKoZIhvcNAQELBQAEggEALihde8oCbcT6lGZO
'' SIG '' vSmLPOp2x+VaSu+5wQOJlx37CUtK3zJ6HPdOV2xOlwc4
'' SIG '' sZ2i3mMq1BFjvN7vW65vXZYHplDkvcXXZ+V62vLAKsCd
'' SIG '' IwWxUR8O3wJ+3DocalqY4j+MNkkvjm8lK/tL8AMT52i1
'' SIG '' 3g4EeMb5T7cm3ZNu1qbSnpn1CC+Dz/paXoE7tiiUncH8
'' SIG '' axu2FAwTOfa+tab3zJTcq+nIIJs9HjzISS7vtrqgcb/G
'' SIG '' 58p11j1ErB+SRncubAZRpUEY67kWNi6d8YBJI75KMlWZ
'' SIG '' FIpjNOWv3ZHx0BS6eJcyVeJ8wbZwwRk1JSKgIjo+5Xk3
'' SIG '' KAar72rJL4r8r+Bi8Q==
'' SIG '' End signature block
