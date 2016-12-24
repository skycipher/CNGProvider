' Windows Installer utility to manage binary streams in an installer package
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the use of the database _Streams table
' Used for entering non-database binary streams such as compressed file cabinets
' Streams that persist database binary values should be managed with table views
' Streams that persist database tables and system data are invisible in _Streams
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
	Wscript.Echo "Windows Installer database stream import utility" &_
		vbNewLine & " 1st argument is the path to MSI database (installer package)" &_
		vbNewLine & " 2nd argument is the path to a file containing the stream data" &_
		vbNewLine & " If the 2nd argument is missing, streams will be listed" &_
		vbNewLine & " 3rd argument is optional, the name used for the stream" &_
		vbNewLine & " If the 3rd arugment is missing, the file name is used" &_
		vbNewLine & " To remove a stream, use /D or -D as the 2nd argument" &_
		vbNewLine & " followed by the name of the stream in the 3rd argument" &_
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
Dim streamName  : If argCount > 2 Then streamName = Wscript.Arguments(2)
If streamName = Empty And importPath <> Empty Then streamName = Right(importPath, Len(importPath) - InStrRev(importPath, "\",-1,vbTextCompare))
If UCase(importPath) = "/D" Or UCase(importPath) = "-D" Then updateMode = msiViewModifyDelete : importPath = Empty 'Stream will be deleted if no input data

' Open database and create a view on the _Streams table
Dim sqlQuery : Select Case updateMode
	Case msiOpenDatabaseModeReadOnly: sqlQuery = "SELECT `Name` FROM _Streams"
	Case msiViewModifyAssign:         sqlQuery = "SELECT `Name`,`Data` FROM _Streams"
	Case msiViewModifyDelete:         sqlQuery = "SELECT `Name` FROM _Streams WHERE `Name` = ?"
End Select
Dim database : Set database = installer.OpenDatabase(databasePath, openMode) : CheckError
Dim view     : Set view = database.OpenView(sqlQuery)
Dim record

If openMode = msiOpenDatabaseModeReadOnly Then 'If listing streams, simply fetch all records
	Dim message, name
	view.Execute : CheckError
	Do
		Set record = view.Fetch
		If record Is Nothing Then Exit Do
		name = record.StringData(1)
		If message = Empty Then message = name Else message = message & vbNewLine & name
	Loop
	Wscript.Echo message
Else 'If adding a stream, insert a row, else if removing a stream, delete the row
	Set record = installer.CreateRecord(2)
	record.StringData(1) = streamName
	view.Execute record : CheckError
	If importPath <> Empty Then  'Insert stream - copy data into stream
		record.SetStream 2, importPath : CheckError
	Else  'Delete stream, fetch first to provide better error message if missing
		Set record = view.Fetch
		If record Is Nothing Then Wscript.Echo "Stream not present:", streamName : Wscript.Quit 2
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
'' SIG '' MIIiCwYJKoZIhvcNAQcCoIIh/DCCIfgCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' cI6yPc6nU50pwvCvjhpQqcdV9XZAulr8Q0FGvLPiuv6g
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
'' SIG '' 0hfT2sGUjgd7JXFEqwZq5tTG3yOalnXFMYIV1TCCFdEC
'' SIG '' AQEwgZUwfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
'' SIG '' c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
'' SIG '' BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UE
'' SIG '' AxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAx
'' SIG '' MAITMwAAAPcoVO77wpgbcQAAAAAA9zANBglghkgBZQME
'' SIG '' AgEFAKCBxjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
'' SIG '' BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAv
'' SIG '' BgkqhkiG9w0BCQQxIgQgQokwC+HG3/TZ4gbQnFv4cBB6
'' SIG '' +FknILF1a4HcmtoisjAwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQBSSRF8SDJK
'' SIG '' l9VoIoaBoIQCajNWznWH3u0GBcSBySF10V+iyKQDbvVp
'' SIG '' t2Y7p0V46+vsmPuiuTVk9dr07nIAc0snPrHkXDBY/gM/
'' SIG '' igj/r4fShW2OqLj3YBauWx4t3B0m/7MS61ZBr1VeBcd9
'' SIG '' Tzj/VxMnrYQzbIbq9DYddzIXavKal5TSigCflKVVfEFl
'' SIG '' m/X/5wNHyTdAPK2g4xXWPQpg/7OeBRB9TDsjOkpEFPCl
'' SIG '' mNtzBRr29J+hh0p2Io14ex5IbVBaiwsiHNVb53vyKC1H
'' SIG '' LiWzL6r6dNNGXXw9gf21utolmRJpWmplJGfZZYzogonw
'' SIG '' ZmVesjLZOyxUJG26iJdgnkOEoYITRzCCE0MGCisGAQQB
'' SIG '' gjcDAwExghMzMIITLwYJKoZIhvcNAQcCoIITIDCCExwC
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCAToGCyqGSIb3DQEJ
'' SIG '' EAEEoIIBKQSCASUwggEhAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIMkFqLIIZIlx6sy5sI31Vfzv
'' SIG '' OwvcScNji26BRa9u/Eh+AgZXj6EwvZgYEzIwMTYwNzI4
'' SIG '' MTQwMDMzLjI1M1owBIACAfSggbmkgbYwgbMxCzAJBgNV
'' SIG '' BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
'' SIG '' VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
'' SIG '' Q29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAlBgNV
'' SIG '' BAsTHm5DaXBoZXIgRFNFIEVTTjoxNDhDLUM0QjktMjA2
'' SIG '' NjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
'' SIG '' U2VydmljZaCCDs0wggZxMIIEWaADAgECAgphCYEqAAAA
'' SIG '' AAACMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBD
'' SIG '' ZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0xMDA3
'' SIG '' MDEyMTM2NTVaFw0yNTA3MDEyMTQ2NTVaMHwxCzAJBgNV
'' SIG '' BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
'' SIG '' VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
'' SIG '' Q29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
'' SIG '' aW1lLVN0YW1wIFBDQSAyMDEwMIIBIjANBgkqhkiG9w0B
'' SIG '' AQEFAAOCAQ8AMIIBCgKCAQEAqR0NvHcRijog7PwTl/X6
'' SIG '' f2mUa3RUENWlCgCChfvtfGhLLF/Fw+Vhwna3PmYrW/AV
'' SIG '' UycEMR9BGxqVHc4JE458YTBZsTBED/FgiIRUQwzXTbg4
'' SIG '' CLNC3ZOs1nMwVyaCo0UN0Or1R4HNvyRgMlhgRvJYR4Yy
'' SIG '' hB50YWeRX4FUsc+TTJLBxKZd0WETbijGGvmGgLvfYfxG
'' SIG '' wScdJGcSchohiq9LZIlQYrFd/XcfPfBXday9ikJNQFHR
'' SIG '' D5wGPmd/9WbAA5ZEfu/QS/1u5ZrKsajyeioKMfDaTgaR
'' SIG '' togINeh4HLDpmc085y9Euqf03GS9pAHBIAmTeM38vMDJ
'' SIG '' RF1eFpwBBU8iTQIDAQABo4IB5jCCAeIwEAYJKwYBBAGC
'' SIG '' NxUBBAMCAQAwHQYDVR0OBBYEFNVjOlyKMZDzQ3t8RhvF
'' SIG '' M2hahW1VMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBB
'' SIG '' MAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8G
'' SIG '' A1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYG
'' SIG '' A1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9z
'' SIG '' b2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0Nl
'' SIG '' ckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQRO
'' SIG '' MEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9z
'' SIG '' b2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIw
'' SIG '' MTAtMDYtMjMuY3J0MIGgBgNVHSABAf8EgZUwgZIwgY8G
'' SIG '' CSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0cDov
'' SIG '' L3d3dy5taWNyb3NvZnQuY29tL1BLSS9kb2NzL0NQUy9k
'' SIG '' ZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0HjIgHQBMAGUA
'' SIG '' ZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQAZQBt
'' SIG '' AGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAB+aI
'' SIG '' UQ3ixuCYP4FxAz2do6Ehb7Prpsz1Mb7PBeKp/vpXbRkw
'' SIG '' s8LFZslq3/Xn8Hi9x6ieJeP5vO1rVFcIK1GCRBL7uVOM
'' SIG '' zPRgEop2zEBAQZvcXBf/XPleFzWYJFZLdO9CEMivv3/G
'' SIG '' f/I3fVo/HPKZeUqRUgCvOA8X9S95gWXZqbVr5MfO9sp6
'' SIG '' AG9LMEQkIjzP7QOllo9ZKby2/QThcJ8ySif9Va8v/rbl
'' SIG '' jjO7Yl+a21dA6fHOmWaQjP9qYn/dxUoLkSbiOewZSnFj
'' SIG '' nXshbcOco6I8+n99lmqQeKZt0uGc+R38ONiU9MalCpaG
'' SIG '' pL2eGq4EQoO4tYCbIjggtSXlZOz39L9+Y1klD3ouOVd2
'' SIG '' onGqBooPiRa6YacRy5rYDkeagMXQzafQ732D8OE7cQnf
'' SIG '' XXSYIghh2rBQHm+98eEA3+cxB6STOvdlR3jo+KhIq/fe
'' SIG '' cn5ha293qYHLpwmsObvsxsvYgrRyzR30uIUBHoD7G4kq
'' SIG '' VDmyW9rIDVWZeodzOwjmmC3qjeAzLhIp9cAvVCch98is
'' SIG '' TtoouLGp25ayp0Kiyc8ZQU3ghvkqmqMRZjDTu3QyS99j
'' SIG '' e/WZii8bxyGvWbWu3EQ8l1Bx16HSxVXjad5XwdHeMMD9
'' SIG '' zOZN+w2/XU/pnR4ZOC+8z1gFLu8NoFA12u8JJxzVs341
'' SIG '' Hgi62jbb01+P3nSISRIwggTaMIIDwqADAgECAhMzAAAA
'' SIG '' iUn1DOTxi5SzAAAAAACJMA0GCSqGSIb3DQEBCwUAMHwx
'' SIG '' CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
'' SIG '' MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
'' SIG '' c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE2MDMz
'' SIG '' MDE5MjQyNloXDTE3MDYzMDE5MjQyNlowgbMxCzAJBgNV
'' SIG '' BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
'' SIG '' VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
'' SIG '' Q29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAlBgNV
'' SIG '' BAsTHm5DaXBoZXIgRFNFIEVTTjoxNDhDLUM0QjktMjA2
'' SIG '' NjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
'' SIG '' U2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
'' SIG '' AQoCggEBAL5+QbX38cc1ITtOV04eOCBc9arcVScOsR9C
'' SIG '' N6d6fYab/E62CW095yggfRoZGhvLk2IboLEuJkUDfKer
'' SIG '' Hhf7UIeAFfMB42oB6Fatbth+kGc+9YrcutqjjoMxjtlC
'' SIG '' rZziESdJPhI/WWyWrSF+mSeSubHjdGY0JCCg+xlNctAB
'' SIG '' srbhuAdqT61hyh3g3jCaPjuHXGvgATVMvbJhDb7QPQ4c
'' SIG '' PFBScZFbIhV6FKgWr5WQVCGDofLSqIh+itty0vNjyDe/
'' SIG '' PEQBoJEspx6q+agDg3yyqvf2kP/CKZKkyQ8UhQkuTTJt
'' SIG '' 1ZfFZoXEjoHqoXdM3LvvoYQq/lIR6v+hTfF5/Unj8EMC
'' SIG '' AwEAAaOCARswggEXMB0GA1UdDgQWBBTVwPpBFF2X1055
'' SIG '' Ctmbh6S/V/5TsDAfBgNVHSMEGDAWgBTVYzpcijGQ80N7
'' SIG '' fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBHhkVodHRw
'' SIG '' Oi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9k
'' SIG '' dWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmww
'' SIG '' WgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRw
'' SIG '' Oi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01p
'' SIG '' Y1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMB
'' SIG '' Af8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqG
'' SIG '' SIb3DQEBCwUAA4IBAQCjUyzo/BB549H8Oyjz0xe+uhkJ
'' SIG '' xPvVC5rWY85mEmU+lJgOxG6AQO7sF2VQ3Z4MFwcQnMcA
'' SIG '' FKofyFj6AN+drRjwr2F30VxhxeYDOxaWVLbQY9YVl3sT
'' SIG '' tt23DKA03c5bCkMGK3wHc/oWB7PSkGDhyTGrPMWZjD7I
'' SIG '' MAQGc8G+rgN82ijxCmHTnAhlpNO1v0YV3CWLjLm7IVNx
'' SIG '' /2dy+tTMpitHpnPaf17UWuF0xccsTgEAvd3rehLEdnyl
'' SIG '' m/eoYRyvk2bjc1Jkj7h/agu6Q8HFY3vnGLQx+8/i1iD9
'' SIG '' 4j6TZINkbWx0D+glDTFt4ei7p9C30Wpon3dq4fqOUOfu
'' SIG '' zf/FOWWvoYIDdjCCAl4CAQEwgeOhgbmkgbYwgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjoxNDhDLUM0Qjkt
'' SIG '' MjA2NjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
'' SIG '' bXAgU2VydmljZaIlCgEBMAkGBSsOAwIaBQADFQCGWJJE
'' SIG '' 6T6Be+eg2QB44EL7fKLK6KCBwjCBv6SBvDCBuTELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUG
'' SIG '' A1UECxMebkNpcGhlciBOVFMgRVNOOjRERTktMEM1RS0z
'' SIG '' RTA5MSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBTb3Vy
'' SIG '' Y2UgTWFzdGVyIENsb2NrMA0GCSqGSIb3DQEBBQUAAgUA
'' SIG '' 20QPNDAiGA8yMDE2MDcyODA0NTcyNFoYDzIwMTYwNzI5
'' SIG '' MDQ1NzI0WjB0MDoGCisGAQQBhFkKBAExLDAqMAoCBQDb
'' SIG '' RA80AgEAMAcCAQACAgVrMAcCAQACAhnjMAoCBQDbRWC0
'' SIG '' AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkK
'' SIG '' AwGgCjAIAgEAAgMHoSChCjAIAgEAAgMHoSAwDQYJKoZI
'' SIG '' hvcNAQEFBQADggEBAIAAysNOpiM6J0mOzvl9hFes/WJl
'' SIG '' da0jDoUl0/wTaikPR/ohe4PRcMZ9x0EbG0jS/PWUfEZb
'' SIG '' BraThT1b/YCCN0fE2fex3nqcI/4JuFc1oYNRJfNHOwn1
'' SIG '' +93B80Man2Elft+5QkDD1E0UCZKDNd9En0PvgXZ6WSTZ
'' SIG '' 3OpwCrQhqF6AGqjOlS9xsioubpTEGqpzeNSMul7XbX5k
'' SIG '' pnE9T0bNXJCthn4mlRG5gdjpPd5r09bWe2GtiMxoCZBQ
'' SIG '' 8e1w4YJFi30fkODDlrQluKEz+FkO0OuYWLqveqqHJ956
'' SIG '' YkYo1JPMrSS+2gcBIhybvKqrS4yvU5DJtv6d76ZFrrLZ
'' SIG '' Rx/aERAxggL1MIIC8QIBATCBkzB8MQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
'' SIG '' dGFtcCBQQ0EgMjAxMAITMwAAAIlJ9Qzk8YuUswAAAAAA
'' SIG '' iTANBglghkgBZQMEAgEFAKCCATIwGgYJKoZIhvcNAQkD
'' SIG '' MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCAL
'' SIG '' I/xyUQqxDcx9fLFCOY6Feenxl/qs2mJNyCzD8zgirTCB
'' SIG '' 4gYLKoZIhvcNAQkQAgwxgdIwgc8wgcwwgbEEFIZYkkTp
'' SIG '' PoF756DZAHjgQvt8osroMIGYMIGApH4wfDELMAkGA1UE
'' SIG '' BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
'' SIG '' BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
'' SIG '' b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
'' SIG '' bWUtU3RhbXAgUENBIDIwMTACEzMAAACJSfUM5PGLlLMA
'' SIG '' AAAAAIkwFgQUHbay92aXLc4/qzBA4OkLLdeHvfMwDQYJ
'' SIG '' KoZIhvcNAQELBQAEggEAOgNoRZ3i5fsLy926ySFOJRKz
'' SIG '' FubWsKBF6md4Yc4orX+NOCeXGzSbhE08udrgEtnlcSky
'' SIG '' xGNiSp+LXO5yd2g3xJAwmCughb6Zzb+JySkC8evDjRKa
'' SIG '' 5SiHMmf4owSLDkr6PiJjbmMdkkFuDytVHaOCxOfBmRY3
'' SIG '' SSacVS6e88mC5m06K7vyp3DjsyOVF9tLVSypdDLk2g2S
'' SIG '' 2EWx33WhLyR4UFjR/5xzo5s1NcX6p/C3k9t+B9TruGth
'' SIG '' X8SJa6HretebiEepg3l2xaC2KXaYi+3egksoOVROse6h
'' SIG '' uH2J9OB74LxiwkbtSvDpNJ4qxNtjgF48i76vciT5MQt3
'' SIG '' yxHNGo3rEA==
'' SIG '' End signature block
