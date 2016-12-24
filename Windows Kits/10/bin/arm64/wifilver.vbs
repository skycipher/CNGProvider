' Windows Installer utility to report or update file versions, sizes, languages
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the access to install engine and actions
'
Option Explicit

' FileSystemObject.CreateTextFile and FileSystemObject.OpenTextFile
Const OpenAsASCII   = 0 
Const OpenAsUnicode = -1

' FileSystemObject.CreateTextFile
Const OverwriteIfExist = -1
Const FailIfExist      = 0

' FileSystemObject.OpenTextFile
Const OpenAsDefault    = -2
Const CreateIfNotExist = -1
Const FailIfNotExist   = 0
Const ForReading = 1
Const ForWriting = 2
Const ForAppending = 8

Const msiOpenDatabaseModeReadOnly = 0
Const msiOpenDatabaseModeTransact = 1

Const msiViewModifyInsert         = 1
Const msiViewModifyUpdate         = 2
Const msiViewModifyAssign         = 3
Const msiViewModifyReplace        = 4
Const msiViewModifyDelete         = 6

Const msiUILevelNone = 2

Const msiRunModeSourceShortNames = 9

Const msidbFileAttributesNoncompressed = &h00002000

Dim argCount:argCount = Wscript.Arguments.Count
Dim iArg:iArg = 0
If argCount > 0 Then If InStr(1, Wscript.Arguments(0), "?", vbTextCompare) > 0 Then argCount = 0
If (argCount < 1) Then
	Wscript.Echo "Windows Installer utility to updata File table sizes and versions" &_
		vbNewLine & " The 1st argument is the path to MSI database, at the source file root" &_
		vbNewLine & " The 2nd argument can optionally specify separate source location from the MSI" &_
		vbNewLine & " The following options may be specified at any point on the command line" &_
		vbNewLine & "  /U to update the MSI database with the file sizes, versions, and languages" &_
		vbNewLine & "  /H to populate the MsiFileHash table (and create if it doesn't exist)" &_
		vbNewLine & " Notes:" &_
		vbNewLine & "  If source type set to compressed, all files will be opened at the root" &_
		vbNewLine & "  Using CSCRIPT.EXE without the /U option, the file info will be displayed" &_
		vbNewLine & "  Using the /H option requires Windows Installer version 2.0 or greater" &_
		vbNewLine & "  Using the /H option also requires the /U option" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Get argument values, processing any option flags
Dim updateMsi    : updateMsi    = False
Dim populateHash : populateHash = False
Dim sequenceFile : sequenceFile = False
Dim databasePath : databasePath = NextArgument
Dim sourceFolder : sourceFolder = NextArgument
If Not IsEmpty(NextArgument) Then Fail "More than 2 arguments supplied" ' process any trailing options
If Not IsEmpty(sourceFolder) And Right(sourceFolder, 1) <> "\" Then sourceFolder = sourceFolder & "\"
Dim console : If UCase(Mid(Wscript.FullName, Len(Wscript.Path) + 2, 1)) = "C" Then console = True

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

Dim errMsg

' Check Installer version to see if MsiFileHash table population is supported
Dim supportHash : supportHash = False
Dim verInstaller : verInstaller = installer.Version
If CInt(Left(verInstaller, 1)) >= 2 Then supportHash = True
If populateHash And NOT supportHash Then
	errMsg = "The version of Windows Installer on the machine does not support populating the MsiFileHash table."
	errMsg = errMsg & " Windows Installer version 2.0 is the mininum required version. The version on the machine is " & verInstaller & vbNewLine
	Fail errMsg
End If

' Check if multiple language package, and force use of primary language
REM	Set sumInfo = database.SummaryInformation(3) : CheckError

' Open database
Dim database, openMode, view, record, updateMode, sumInfo
If updateMsi Then openMode = msiOpenDatabaseModeTransact Else openMode = msiOpenDatabaseModeReadOnly
Set database = installer.OpenDatabase(databasePath, openMode) : CheckError

' Create MsiFileHash table if we will be populating it and it is not already present
Dim hashView, iTableStat, fileHash, hashUpdateRec
iTableStat = Database.TablePersistent("MsiFileHash")
If populateHash Then
	If NOT updateMsi Then
		errMsg = "Populating the MsiFileHash table requires that the database be open for writing. Please include the /U option"
		Fail errMsg		
	End If

	If iTableStat <> 1 Then
		Set hashView = database.OpenView("CREATE TABLE `MsiFileHash` ( `File_` CHAR(72) NOT NULL, `Options` INTEGER NOT NULL, `HashPart1` LONG NOT NULL, `HashPart2` LONG NOT NULL, `HashPart3` LONG NOT NULL, `HashPart4` LONG NOT NULL PRIMARY KEY `File_` )") : CheckError
		hashView.Execute : CheckError
	End If

	Set hashView = database.OpenView("SELECT `File_`, `Options`, `HashPart1`, `HashPart2`, `HashPart3`, `HashPart4` FROM `MsiFileHash`") : CheckError
	hashView.Execute : CheckError

	Set hashUpdateRec = installer.CreateRecord(6)
End If

' Create an install session and execute actions in order to perform directory resolution
installer.UILevel = msiUILevelNone
Dim session : Set session = installer.OpenPackage(database,1) : If Err <> 0 Then Fail "Database: " & databasePath & ". Invalid installer package format"
Dim shortNames : shortNames = session.Mode(msiRunModeSourceShortNames) : CheckError
If Not IsEmpty(sourceFolder) Then session.Property("OriginalDatabase") = sourceFolder : CheckError
Dim stat : stat = session.DoAction("CostInitialize") : CheckError
If stat <> 1 Then Fail "CostInitialize failed, returned " & stat

' Join File table to Component table in order to find directories
Dim orderBy : If sequenceFile Then orderBy = "Directory_" Else orderBy = "Sequence"
Set view = database.OpenView("SELECT File,FileName,Directory_,FileSize,Version,Language FROM File,Component WHERE Component_=Component ORDER BY " & orderBy) : CheckError
view.Execute : CheckError

' Create view on File table to check for companion file version syntax so that we don't overwrite them
Dim companionView
set companionView = database.OpenView("SELECT File FROM File WHERE File=?") : CheckError

' Fetch each file and request the source path, then verify the source path, and get the file info if present
Dim fileKey, fileName, folder, sourcePath, fileSize, version, language, delim, message, info
Do
	Set record = view.Fetch : CheckError
	If record Is Nothing Then Exit Do
	fileKey    = record.StringData(1)
	fileName   = record.StringData(2)
	folder     = record.StringData(3)
REM	fileSize   = record.IntegerData(4)
REM	companion  = record.StringData(5)
	version    = record.StringData(5)
REM	language   = record.StringData(6)

	' Check to see if this is a companion file
	Dim companionRec
	Set companionRec = installer.CreateRecord(1) : CheckError
	companionRec.StringData(1) = version
	companionView.Close : CheckError
	companionView.Execute companionRec : CheckError
	Dim companionFetch
	Set companionFetch = companionView.Fetch : CheckError
	Dim companionFile : companionFile = True
	If companionFetch Is Nothing Then
		companionFile = False
	End If

	delim = InStr(1, fileName, "|", vbTextCompare)
	If delim <> 0 Then
		If shortNames Then fileName = Left(fileName, delim-1) Else fileName = Right(fileName, Len(fileName) - delim)
	End If
	sourcePath = session.SourcePath(folder) & fileName
	If installer.FileAttributes(sourcePath) = -1 Then
		message = message & vbNewLine & sourcePath
	Else
		fileSize = installer.FileSize(sourcePath) : CheckError
		version  = Empty : version  = installer.FileVersion(sourcePath, False) : Err.Clear ' early MSI implementation fails if no version
		language = Empty : language = installer.FileVersion(sourcePath, True)  : Err.Clear ' early MSI implementation doesn't support language
		If language = version Then language = Empty ' Temp check for MSI.DLL version without language support
		If Err <> 0 Then version = Empty : Err.Clear
		If updateMsi Then
			' update File table info
			record.IntegerData(4) = fileSize
			If Len(version)  > 0 Then record.StringData(5) = version
			If Len(language) > 0 Then record.StringData(6) = language
			view.Modify msiViewModifyUpdate, record : CheckError

			' update MsiFileHash table info if this is an unversioned file
			If populateHash And Len(version) = 0 Then
				Set fileHash = installer.FileHash(sourcePath, 0) : CheckError
				hashUpdateRec.StringData(1) = fileKey
				hashUpdateRec.IntegerData(2) = 0
				hashUpdateRec.IntegerData(3) = fileHash.IntegerData(1)
				hashUpdateRec.IntegerData(4) = fileHash.IntegerData(2)
				hashUpdateRec.IntegerData(5) = fileHash.IntegerData(3)
				hashUpdateRec.IntegerData(6) = fileHash.IntegerData(4)
				hashView.Modify msiViewModifyAssign, hashUpdateRec : CheckError
			End If
		ElseIf console Then
			If companionFile Then
				info = "* "
				info = info & fileName : If Len(info) < 12 Then info = info & Space(12 - Len(info))
				info = info & "  skipped (version is a reference to a companion file)"
			Else
				info = fileName : If Len(info) < 12 Then info = info & Space(12 - Len(info))
				info = info & "  size=" & fileSize : If Len(info) < 26 Then info = info & Space(26 - Len(info))
				If Len(version)  > 0 Then info = info & "  vers=" & version : If Len(info) < 45 Then info = info & Space(45 - Len(info))
				If Len(language) > 0 Then info = info & "  lang=" & language
			End If
			Wscript.Echo info
		End If
	End If
Loop
REM Wscript.Echo "SourceDir = " & session.Property("SourceDir")
If Not IsEmpty(message) Then Fail "Error, the following files were not available:" & message

' Update SummaryInformation
If updateMsi Then
	Set sumInfo = database.SummaryInformation(3) : CheckError
	sumInfo.Property(11) = Now
	sumInfo.Property(13) = Now
	sumInfo.Persist
End If

' Commit database in case updates performed
database.Commit : CheckError
Wscript.Quit 0

' Extract argument value from command line, processing any option flags
Function NextArgument
	Dim arg
	Do  ' loop to pull in option flags until an argument value is found
		If iArg >= argCount Then Exit Function
		arg = Wscript.Arguments(iArg)
		iArg = iArg + 1
		If (AscW(arg) <> AscW("/")) And (AscW(arg) <> AscW("-")) Then Exit Do
		Select Case UCase(Right(arg, Len(arg)-1))
			Case "U" : updateMsi    = True
			Case "H" : populateHash = True
			Case Else: Wscript.Echo "Invalid option flag:", arg : Wscript.Quit 1
		End Select
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
	Fail message
End Sub

Sub Fail(message)
	Wscript.Echo message
	Wscript.Quit 2
End Sub

'' SIG '' Begin signature block
'' SIG '' MIIiEAYJKoZIhvcNAQcCoIIiATCCIf0CAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' 90R1z4uuv6FSmeekmrnJ1Xqp08A0D4fjgi9+4dO31L2g
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
'' SIG '' BgkqhkiG9w0BCQQxIgQgaZ81X6BTsfXjZaDeKIpyi4Ut
'' SIG '' eXGGVt5deRIRLgwg7WkwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQBUYl1OYdPe
'' SIG '' q5AQtaH/iwA9ZsjlpMpurCnfmV4enyrN+OyUkRgNBLQ8
'' SIG '' uVIclBoMcIdqUXf2bRuEgxCcSYwaQXIuNTtE/JwrbN8Y
'' SIG '' 9LKkdj+jSWyNegy4JR5U9Wg9bDJbDkn4z3sfZ6XRjo9d
'' SIG '' 7B8kcVE8y54cXGZ4CY8P47uO8z7tqK6d4pkNnjdLl5iw
'' SIG '' iBXIMP/1ZVammSCZokS/ZD4XBquc20sbQUwTo0E6AdXs
'' SIG '' S0O3bHf0KwjqpEq8doY0Jd7WKDy1JdDrTNfmVF0uyEWr
'' SIG '' kH8seaEgP9M8GA5HPochz1OkpuvD5PnxLgjgHieQxEey
'' SIG '' sgpGzvEebZL2jVQ/3xEaK5m8oYITTDCCE0gGCisGAQQB
'' SIG '' gjcDAwExghM4MIITNAYJKoZIhvcNAQcCoIITJTCCEyEC
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCAT0GCyqGSIb3DQEJ
'' SIG '' EAEEoIIBLASCASgwggEkAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIEmjbnnr+sydCjzLbqtHzITy
'' SIG '' JU8mPh48hZ+OQBfp2tqTAgZXkzZfWIgYEzIwMTYwNzI4
'' SIG '' MTQwMDMxLjMxNlowBwIBAYACAfSggbmkgbYwgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo3QUZBLUU0MUMt
'' SIG '' RTE0MjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
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
'' SIG '' AAAAhJOKQo8sfCPoAAAAAACEMA0GCSqGSIb3DQEBCwUA
'' SIG '' MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
'' SIG '' dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
'' SIG '' aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
'' SIG '' Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTE2
'' SIG '' MDMzMDE5MjQyM1oXDTE3MDYzMDE5MjQyM1owgbMxCzAJ
'' SIG '' BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
'' SIG '' DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
'' SIG '' ZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIxJzAl
'' SIG '' BgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo3QUZBLUU0MUMt
'' SIG '' RTE0MjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3Rh
'' SIG '' bXAgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEP
'' SIG '' ADCCAQoCggEBAMumR5RY/GcehjZx9y2umJl/RdI0Z3Xi
'' SIG '' 6mwN7WulnWd4rjm9delsAPj6vq3kUJ9CkdI+B75QiiMM
'' SIG '' RIF902Y/AsvnSBkK8P0H+SFncRnJulF/Uy3BEC37RUil
'' SIG '' h5FkKyQuXBq+1+Tb8l0PNEZw67VKUeSi0wE40Yzuybv4
'' SIG '' cMRIMUx6YUd94SHwS9xTP3U5q3bP2J29Nygo6D7xrxQ1
'' SIG '' CY3RgLYFDX5bDNf4TPbIg1vIrr7tSlfyUtqOP/8jp+HR
'' SIG '' UeEz05SUYcUERHszftf4vOx6dGvoc31f/HAXRK9ovj0f
'' SIG '' z3zrmk+YPboRhuziY/OYAxTGR/xCXzdpwc9cjYLmmgNB
'' SIG '' OHMCAwEAAaOCARswggEXMB0GA1UdDgQWBBQdVAtHA6uZ
'' SIG '' t6HrpUpcdpJgJXRB2zAfBgNVHSMEGDAWgBTVYzpcijGQ
'' SIG '' 80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBHhkVo
'' SIG '' dHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9w
'' SIG '' cm9kdWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5j
'' SIG '' cmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5o
'' SIG '' dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRz
'' SIG '' L01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNV
'' SIG '' HRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
'' SIG '' CSqGSIb3DQEBCwUAA4IBAQCGuHT0XaiXkhmAM2kkTxPI
'' SIG '' kZhU8pvHoYNqJRK6euhT9RZ/zmdmGSQAidUGwjGtXRdi
'' SIG '' zTjHNm3qXQPX/VhMKFFq2QoKvi87+QQ6CyfjiYJLc402
'' SIG '' o+wKXDBfdg7X4baPdBlNX/S226679XFPqblrbTfXDa8A
'' SIG '' AG9upkkjGc7whRslemT+ghlwEQe7lvF8cWZRsjzpFgAR
'' SIG '' 3/CNvoqVx+MywpyR4GYtR3NW6XzqFN8UdPxcF98n/u1s
'' SIG '' 7Nhgs1MDTDpI7tN6mu4/gxQMHeY5sE0KnnyjvVEMSJCW
'' SIG '' XkxDXJgHh+rwIZ8VSO1ncAm7SfCY9NkuBeX1QmM8ZQHu
'' SIG '' e5lDEoqemt85oYIDeDCCAmACAQEwgeOhgbmkgbYwgbMx
'' SIG '' CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
'' SIG '' MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xDTALBgNVBAsTBE1PUFIx
'' SIG '' JzAlBgNVBAsTHm5DaXBoZXIgRFNFIEVTTjo3QUZBLUU0
'' SIG '' MUMtRTE0MjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
'' SIG '' U3RhbXAgU2VydmljZaIlCgEBMAkGBSsOAwIaBQADFQD3
'' SIG '' K25zrOi3OErWRldkakkVC8w2faCBwjCBv6SBvDCBuTEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEn
'' SIG '' MCUGA1UECxMebkNpcGhlciBOVFMgRVNOOjRERTktMEM1
'' SIG '' RS0zRTA5MSswKQYDVQQDEyJNaWNyb3NvZnQgVGltZSBT
'' SIG '' b3VyY2UgTWFzdGVyIENsb2NrMA0GCSqGSIb3DQEBBQUA
'' SIG '' AgUA20QPPTAiGA8yMDE2MDcyODA0NTczM1oYDzIwMTYw
'' SIG '' NzI5MDQ1NzMzWjB2MDwGCisGAQQBhFkKBAExLjAsMAoC
'' SIG '' BQDbRA89AgEAMAkCAQACARgCAf8wBwIBAAICGgMwCgIF
'' SIG '' ANtFYL0CAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYB
'' SIG '' BAGEWQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAwehIDAN
'' SIG '' BgkqhkiG9w0BAQUFAAOCAQEAh6z9/uIFCp6SBf31ly0O
'' SIG '' BcrMTA7UnCVipXwd+KghPLeJiVUPhWzDrSmPt32glPxp
'' SIG '' TsZjUef2sSzWAq5qznsBTsImZKWnzx098u5y2ulLw/W9
'' SIG '' 49rZAajySrZlmFI17TpkJWqIaQn+k+IlEVAkWxXpnwbd
'' SIG '' Ye0WE872ovh7UeMYWtOqKIMNboqgqWWsStlHtqIA0EoQ
'' SIG '' 91iKqi8gfeyRc4dUr7AhW1mRpAsuMgtFy3N8NqUX7gmT
'' SIG '' vweLsdqyFFi9Ev2NRpWY/36w+BfuoFRYV8qVbl1gk56i
'' SIG '' xKPBLjauu5Q3EmSNOWHS6J0OnLXHYasrHV+bmIkpljOe
'' SIG '' 4fXQWsxYRf2F4TGCAvUwggLxAgEBMIGTMHwxCzAJBgNV
'' SIG '' BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
'' SIG '' VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
'' SIG '' Q29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
'' SIG '' aW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAAhJOKQo8sfCPo
'' SIG '' AAAAAACEMA0GCWCGSAFlAwQCAQUAoIIBMjAaBgkqhkiG
'' SIG '' 9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkE
'' SIG '' MSIEIFkW4akwOrvpdpJssb0gvVsOxSQQ0q98kN5nSMrj
'' SIG '' wfivMIHiBgsqhkiG9w0BCRACDDGB0jCBzzCBzDCBsQQU
'' SIG '' 9ytuc6zotzhK1kZXZGpJFQvMNn0wgZgwgYCkfjB8MQsw
'' SIG '' CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
'' SIG '' MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
'' SIG '' b2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3Nv
'' SIG '' ZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAISTikKP
'' SIG '' LHwj6AAAAAAAhDAWBBSmanYiniCzVeVAWHuDFdLKy+L7
'' SIG '' MTANBgkqhkiG9w0BAQsFAASCAQCSOIyQ1OEbSE2q+LPJ
'' SIG '' OjHYo5j2suKUrS4+hsF1H0Ro2bd+N4/4SBUTbw49idTV
'' SIG '' zzVBVDKsjfDxJTC/7TVuGciGU9jtT7ttn6JOS2nc0S+I
'' SIG '' +Nru8m/gRCF1uf1S3OIM2lIA7q6ycox+xJ1w89GM5/ul
'' SIG '' pLHN638u2CIKHJjmSuMtzQ2LeXfu3YT/SGOCAQk/QWum
'' SIG '' FvbhiuUXgN9LL6JQqyYKpylxLvSnEgcalhv3oZ/p4NMA
'' SIG '' sjaJSf4UNdgMFIiPJ7VCkwsAGnavBERIEpRInwmucf0V
'' SIG '' Kz9DXMhUnGKKaYAJDdDA2tt3NkKMiRbw+OkYFe3I0xyR
'' SIG '' l+/okrtvnXgob/s2
'' SIG '' End signature block
