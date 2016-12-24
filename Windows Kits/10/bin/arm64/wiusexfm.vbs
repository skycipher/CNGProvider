' Windows Installer utility to applay a transform to an installer database
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates use of Database.ApplyTransform and MsiDatabaseApplyTransform
'
Option Explicit

' Error conditions that may be suppressed when applying transforms
Const msiTransformErrorAddExistingRow         = 1 'Adding a row that already exists. 
Const msiTransformErrorDeleteNonExistingRow   = 2 'Deleting a row that doesn't exist. 
Const msiTransformErrorAddExistingTable       = 4 'Adding a table that already exists. 
Const msiTransformErrorDeleteNonExistingTable = 8 'Deleting a table that doesn't exist. 
Const msiTransformErrorUpdateNonExistingRow  = 16 'Updating a row that doesn't exist. 
Const msiTransformErrorChangeCodePage       = 256 'Transform and database code pages do not match 

Const msiOpenDatabaseModeReadOnly     = 0
Const msiOpenDatabaseModeTransact     = 1
Const msiOpenDatabaseModeCreate       = 3

If (Wscript.Arguments.Count < 2) Then
	Wscript.Echo "Windows Installer database tranform application utility" &_
		vbNewLine & " 1st argument is the path to an installer database" &_
		vbNewLine & " 2nd argument is the path to the transform file to apply" &_
		vbNewLine & " 3rd argument is optional set of error conditions to suppress:" &_
		vbNewLine & "     1 = adding a row that already exists" &_
		vbNewLine & "     2 = deleting a row that doesn't exist" &_
		vbNewLine & "     4 = adding a table that already exists" &_
		vbNewLine & "     8 = deleting a table that doesn't exist" &_
		vbNewLine & "    16 = updating a row that doesn't exist" &_
		vbNewLine & "   256 = mismatch of database and transform codepages" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

' Open database and apply transform
Dim database : Set database = installer.OpenDatabase(Wscript.Arguments(0), msiOpenDatabaseModeTransact) : CheckError
Dim errorConditions:errorConditions = 0
If Wscript.Arguments.Count >= 3 Then errorConditions = CLng(Wscript.Arguments(2))
Database.ApplyTransform Wscript.Arguments(1), errorConditions : CheckError
Database.Commit : CheckError

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
'' SIG '' MIIiDQYJKoZIhvcNAQcCoIIh/jCCIfoCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' ocXRzPIBsTOs40BugTYvo1tESbFrFB3U6AbYVQhStNmg
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
'' SIG '' 0hfT2sGUjgd7JXFEqwZq5tTG3yOalnXFMYIV1zCCFdMC
'' SIG '' AQEwgZUwfjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
'' SIG '' c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
'' SIG '' BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UE
'' SIG '' AxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAx
'' SIG '' MAITMwAAAPcoVO77wpgbcQAAAAAA9zANBglghkgBZQME
'' SIG '' AgEFAKCBxjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
'' SIG '' BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAv
'' SIG '' BgkqhkiG9w0BCQQxIgQgLQn6o9kUODATKIS+smjNPFWN
'' SIG '' t2x3Bw5gzkZaBTK4sbgwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQAJ1naPNF1I
'' SIG '' ZsqEGIZ62nPH5IbXx3hqFyQ1Lm6fnCQrsBfYxjUz4gq1
'' SIG '' AnI0VRfWggWYMikg/kjQD84Xq5HeQPdIinEIKAoDC+NM
'' SIG '' 0Lv/3JxeTNfVpE6kZ2CdAFd6R08SHihpnGzYmE8nj9Xi
'' SIG '' LvnfuyzclQlLv6lJ76FykIobnvhGiwCM3OtLSy+28mhq
'' SIG '' 3xfNeTPnccpxo2CPB4UtxozhwbH2twWM7dgTQ/FXBeiM
'' SIG '' 9lDBhyD+u7tHI6YXmqxjadkZhRqh0Fq9r6LXyc1Gqsu6
'' SIG '' BrpCg856mUUkDduJn1Jhygc5lbWHjwg9BliEorpx505I
'' SIG '' VIPh2aHNAj/j9IRkcBVpblF3oYITSTCCE0UGCisGAQQB
'' SIG '' gjcDAwExghM1MIITMQYJKoZIhvcNAQcCoIITIjCCEx4C
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCATwGCyqGSIb3DQEJ
'' SIG '' EAEEoIIBKwSCAScwggEjAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIEZQHobTSa6ocqLCnlfHp/zU
'' SIG '' E+0j2CEjEjORAF5FoeW0AgZXj6RxyMwYEjIwMTYwNzI4
'' SIG '' MTQwMDMzLjAzWjAHAgEBgAIB9KCBuaSBtjCBszELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUG
'' SIG '' A1UECxMebkNpcGhlciBEU0UgRVNOOkJCRUMtMzBDQS0y
'' SIG '' REJFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
'' SIG '' cCBTZXJ2aWNloIIOzTCCBnEwggRZoAMCAQICCmEJgSoA
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
'' SIG '' AACaPqsBpTZgpwsAAAAAAJowDQYJKoZIhvcNAQELBQAw
'' SIG '' fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
'' SIG '' b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
'' SIG '' Y3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWlj
'' SIG '' cm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMTYw
'' SIG '' NDI3MTcwNjE5WhcNMTcwNzI3MTcwNjE5WjCBszELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUG
'' SIG '' A1UECxMebkNpcGhlciBEU0UgRVNOOkJCRUMtMzBDQS0y
'' SIG '' REJFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
'' SIG '' cCBTZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
'' SIG '' MIIBCgKCAQEA8F4dywmPfCaBA70I0wjKUUEagcWpV3Lb
'' SIG '' 4TRCdqrfyVJgeaN0Uu3KY4YU14qMrkXJCqzDL7t6MhpC
'' SIG '' 0JL/I+W2DT+cyGmE+HdTJU2RKaP3IZWoID3GYlOQvCCv
'' SIG '' orxQ+BpQLzAobRIb4/c6NdEiycxrBNlOG22iGDbKBMaK
'' SIG '' K4DtaSZzhOZzx/fCEGHaC+G9bp/SvqSNSifZuDe9rx2p
'' SIG '' jdCSx+JXnTeaAfNHkwdf5eenFb7HQ8kzD8SE7PCECIxc
'' SIG '' 4IyBWpU2jVPrFAKBRyT7KC2ujP/TG0Y1GiIA5jGYwjZs
'' SIG '' C6968eWuwPfMtd/myQZPWsZ7B7p9/pDK140cFChDtuMd
'' SIG '' CQIDAQABo4IBGzCCARcwHQYDVR0OBBYEFAw/6idGc6Nj
'' SIG '' 417n0n6rkd9aZe96MB8GA1UdIwQYMBaAFNVjOlyKMZDz
'' SIG '' Q3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJoEeGRWh0
'' SIG '' dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3By
'' SIG '' b2R1Y3RzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNy
'' SIG '' bDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0
'' SIG '' dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMv
'' SIG '' TWljVGltU3RhUENBXzIwMTAtMDctMDEuY3J0MAwGA1Ud
'' SIG '' EwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJ
'' SIG '' KoZIhvcNAQELBQADggEBAHic9lK2PwvPyaHPv8/8y7tk
'' SIG '' PSGuOEwoZjJ3eb2uIW5W3sMGGv3TylYz3M+nA5m7hbHK
'' SIG '' CXvSMXwVZrcZ9P49CF4ZwmHGIEJG3haeLdnKk/F9Xia4
'' SIG '' ms8g0HGKyKZLpiarNChxZbFGsiFMBzYRAQA6ZqS/N+WU
'' SIG '' e/msSChkUhh73Eelwc6ObKHFm2h9FLGQpN6rL+OXqli4
'' SIG '' DpvDkHfH7/wy8ZB+fJveJ1L099BaySvhEMTlDr4D0Hrb
'' SIG '' ryyGD5lt1IHE+PRBfoF4EBLPu32p+ZSnswxMkPUg+9EB
'' SIG '' f5pMJmONIR/awb19h3DjPJu1D7zW8BFqwu9mgDZrdM1o
'' SIG '' KFMHzn6TwqqhggN2MIICXgIBATCB46GBuaSBtjCBszEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEn
'' SIG '' MCUGA1UECxMebkNpcGhlciBEU0UgRVNOOkJCRUMtMzBD
'' SIG '' QS0yREJFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1T
'' SIG '' dGFtcCBTZXJ2aWNloiUKAQEwCQYFKw4DAhoFAAMVAM/D
'' SIG '' 4wGOplZm3OSE/HAW60LR8QipoIHCMIG/pIG8MIG5MQsw
'' SIG '' CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
'' SIG '' MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
'' SIG '' b2Z0IENvcnBvcmF0aW9uMQ0wCwYDVQQLEwRNT1BSMScw
'' SIG '' JQYDVQQLEx5uQ2lwaGVyIE5UUyBFU046NTdGNi1DMUUw
'' SIG '' LTU1NEMxKzApBgNVBAMTIk1pY3Jvc29mdCBUaW1lIFNv
'' SIG '' dXJjZSBNYXN0ZXIgQ2xvY2swDQYJKoZIhvcNAQEFBQAC
'' SIG '' BQDbQ8++MCIYDzIwMTYwNzI4MDAyNjM4WhgPMjAxNjA3
'' SIG '' MjkwMDI2MzhaMHQwOgYKKwYBBAGEWQoEATEsMCowCgIF
'' SIG '' ANtDz74CAQAwBwIBAAICAJowBwIBAAICF94wCgIFANtF
'' SIG '' IT4CAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGE
'' SIG '' WQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAwehIDANBgkq
'' SIG '' hkiG9w0BAQUFAAOCAQEAK6e1avPCx+6kLc3kuTAV695O
'' SIG '' ulL+ZXnwsj3MJorlTdft5DF4MXwRefjGPD5+f6vG4NHU
'' SIG '' 3G1z02JZQVJCUMfwd5ddSW8KSEBHq5Q3byn+Rs+NcmL8
'' SIG '' YmF1d8TpkjNcvla68/cG3h3LT3ljxIxl5J1HQMWo2qq7
'' SIG '' LyHvewVI2aWxt+vCPe8OXMGKTFJZvSEZNLuUPDH/N3V4
'' SIG '' seIPi4lqnd4u55kacdH/IujIHUrNmT22jI8tpltVM67w
'' SIG '' Hbl/UjwNi/bW075umvneWoZIEZmlCHXgUokeJGU6yS+h
'' SIG '' Fy71HQkHEUoBaOsyOhHmmJuFUTDvcndHEc7a5iT01vRI
'' SIG '' Hjcc9aBSIzGCAvUwggLxAgEBMIGTMHwxCzAJBgNVBAYT
'' SIG '' AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
'' SIG '' EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
'' SIG '' cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1l
'' SIG '' LVN0YW1wIFBDQSAyMDEwAhMzAAAAmj6rAaU2YKcLAAAA
'' SIG '' AACaMA0GCWCGSAFlAwQCAQUAoIIBMjAaBgkqhkiG9w0B
'' SIG '' CQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIE
'' SIG '' IIW7mqfhJW502WdIN6uTGAQSd1JMQPHKnbgjHyZkYfwV
'' SIG '' MIHiBgsqhkiG9w0BCRACDDGB0jCBzzCBzDCBsQQUz8Pj
'' SIG '' AY6mVmbc5IT8cBbrQtHxCKkwgZgwgYCkfjB8MQswCQYD
'' SIG '' VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
'' SIG '' A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
'' SIG '' IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQg
'' SIG '' VGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAJo+qwGlNmCn
'' SIG '' CwAAAAAAmjAWBBQ7WUlV1c1uzRTbTqtyrtRFYD/4hTAN
'' SIG '' BgkqhkiG9w0BAQsFAASCAQBXgQec84Zw9OQrpCXqvlo4
'' SIG '' 16Y4WCYIMgmeTEBcAvTC4z2v/8FrFn7VGj6axVFRTNKJ
'' SIG '' ywEiU+5d3IhzbHkYmu/k8kH7MXi2DkJYWpMctRG23ZGH
'' SIG '' j7aJj2dEJC7Ojq2qW2p0HMoZBx+51h/ik72vnQzz9rk3
'' SIG '' xk8isOoKorEK14ThtxFAfB9wRE4i76sV4n1k+P/86d1U
'' SIG '' 0dhuWOSKjKZ+yOM2e2iSikJlFRrYnjJO9zyu5KTvN98A
'' SIG '' FWiZApWAeuSAili8SYzcFCpLd4Jm8fxL1yK2kXXF61mn
'' SIG '' uBV31C+b2YNcRod/SU3TYZdTOltdBTk52Bbmw6tEoo2T
'' SIG '' fKsBb3nL7Pdb
'' SIG '' End signature block
