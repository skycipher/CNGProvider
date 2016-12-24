' Windows Installer utility to list feature composition in an MSI database
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the use of adding temporary columns to a read-only database
'
Option Explicit
Public isGUI, installer, database, message, featureParam, nextSequence  'global variables accessed across functions

Const msiOpenDatabaseModeReadOnly = 0
Const msiDbNullInteger            = &h80000000
Const msiViewModifyUpdate         = 2

' Check if run from GUI script host, in order to modify display
If UCase(Mid(Wscript.FullName, Len(Wscript.Path) + 2, 1)) = "W" Then isGUI = True

' Show help if no arguments or if argument contains ?
Dim argCount:argCount = Wscript.Arguments.Count
If argCount > 0 Then If InStr(1, Wscript.Arguments(0), "?", vbTextCompare) > 0 Then argCount = 0
If argCount = 0 Then
	Wscript.Echo "Windows Installer utility to list feature composition in an installer database." &_
		vbLf & " The 1st argument is the path to an install database, relative or complete path" &_
		vbLf & " The 2nd argument is the name of the feature (the primary key of Feature table)" &_
		vbLf & " If the 2nd argument is not present, all feature names will be listed as a tree" &_
		vbLf & " If the 2nd argument is ""*"" then the composition of all features will be listed" &_
		vbLf & " Large databases or features are better displayed by using CScript than WScript" &_
		vbLf & " Note: The name of the feature, if provided,  is case-sensitive" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

' Open database
Dim databasePath:databasePath = Wscript.Arguments(0)
Set database = installer.OpenDatabase(databasePath, msiOpenDatabaseModeReadOnly) : CheckError
REM Set database = installer.OpenDatabase(databasePath, 1) : CheckError

If argCount = 1 Then  'If no feature specified, then simply list features
	ListFeatures False
	ShowOutput "Features for " & databasePath, message
ElseIf Left(Wscript.Arguments(1), 1) = "*" Then 'List all features
	ListFeatures True
Else
	QueryFeature Wscript.Arguments(1) 
End If
Wscript.Quit 0

' List all table rows referencing a given feature
Function QueryFeature(feature)
	' Get feature info and format output header
	Dim view, record, header, parent
	Set view = database.OpenView("SELECT `Feature_Parent` FROM `Feature` WHERE `Feature` = ?") : CheckError
	Set featureParam = installer.CreateRecord(1)
	featureParam.StringData(1) = feature
	view.Execute featureParam : CheckError
	Set record = view.Fetch : CheckError
	Set view = Nothing
	If record Is Nothing Then Fail "Feature not in database: " & feature
	parent = record.StringData(1)
	header = "Feature: "& feature & "  Parent: " & parent

	' List of tables with foreign keys to Feature table - with subsets of columns to display
	DoQuery "FeatureComponents","Component_"                         '
	DoQuery "Condition",        "Level,Condition"                    '
	DoQuery "Billboard",        "Billboard,Action"                   'Ordering

	QueryFeature = ShowOutput(header, message)
	message = Empty
End Function

' Query used for sorting and corresponding record field indices
const irecParent   = 1  'put first in order to use as query parameter
const irecChild    = 2  'primary key of Feature table
const irecSequence = 3  'temporary column added for sorting
const sqlSort = "SELECT `Feature_Parent`,`Feature`,`Sequence` FROM `Feature`"

' Recursive function to resolve parent feature chain, return tree level (low order 8 bits of sequence number)
Function LinkParent(childView)
	Dim view, record, level
	On Error Resume Next
	Set record = childView.Fetch
	If record Is Nothing Then Exit Function  'return Empty if no record found
	If Not record.IsNull(irecSequence) Then LinkParent = (record.IntegerData(irecSequence) And 255) + 1 : Exit Function 'Already resolved
	If record.IsNull(irecParent) Or record.StringData(irecParent) = record.StringData(irecChild) Then 'Root node
		level = 0
	Else  'child node, need to get level from parent
		Set view = database.OpenView(sqlSort & " WHERE `Feature` = ?") : CheckError
		view.Execute record : CheckError '1st param is parent feature
		level = LinkParent(view)
		If IsEmpty(level) Then Fail "Feature parent does not exist: " & record.StringData(irecParent)
	End If
	record.IntegerData(irecSequence) = nextSequence + level
	nextSequence = nextSequence + 256
	childView.Modify msiViewModifyUpdate, record : CheckError
	LinkParent = level + 1
End Function

' List all features in database, sorted hierarchically
Sub ListFeatures(queryAll)
	Dim viewSchema, view, record, feature, level
	On Error Resume Next
	Set viewSchema = database.OpenView("ALTER TABLE Feature ADD Sequence LONG TEMPORARY") : CheckError
	viewSchema.Execute : CheckError  'Add ordering column, keep view open to hold temp columns
	Set view = database.OpenView(sqlSort) : CheckError
	view.Execute : CheckError
	nextSequence = 0
	While LinkParent(view) : Wend  'Loop to link rows hierachically
	Set view = database.OpenView("SELECT `Feature`,`Title`, `Sequence` FROM `Feature` ORDER BY Sequence") : CheckError
	view.Execute : CheckError
	Do
		Set record = view.Fetch : CheckError
		If record Is Nothing Then Exit Do
		feature = record.StringData(1)
		level = record.IntegerData(3) And 255
		If queryAll Then
			If QueryFeature(feature) = vbCancel Then Exit Sub
		Else
			If Not IsEmpty(message) Then message = message & vbLf
			message = message & Space(level * 2) & feature & "  (" & record.StringData(2) & ")"
		End If
	Loop
End Sub

' Perform a join to query table rows linked to a given feature, delimiting and qualifying names to prevent conflicts
Sub DoQuery(table, columns)
	Dim view, record, columnCount, column, output, header, delim, columnList, tableList, tableDelim, query, joinTable, primaryKey, foreignKey, columnDelim
	On Error Resume Next
	tableList  = Replace(table,   ",", "`,`")
	tableDelim = InStr(1, table, ",", vbTextCompare)
	If tableDelim Then  ' need a 3-table join
		joinTable = Right(table, Len(table)-tableDelim)
		table = Left(table, tableDelim-1)
		foreignKey = columns
		Set record = database.PrimaryKeys(joinTable)
		primaryKey = record.StringData(1)
		columnDelim = InStr(1, columns, ",", vbTextCompare)
		If columnDelim Then foreignKey = Left(columns, columnDelim - 1)
		query = " AND `" & foreignKey & "` = `" & primaryKey & "`"
	End If
	columnList = table & "`." & Replace(columns, ",", "`,`" & table & "`.`")
	query = "SELECT `" & columnList & "` FROM `" & tableList & "` WHERE `Feature_` = ?" & query
	If database.TablePersistent(table) <> 1 Then Exit Sub
	Set view = database.OpenView(query) : CheckError
	view.Execute featureParam : CheckError
	Do
		Set record = view.Fetch : CheckError
		If record Is Nothing Then Exit Do
		If IsEmpty(output) Then
			If Not IsEmpty(message) Then message = message & vbLf
			message = message & "----" & table & " Table----  (" & columns & ")" & vbLf
		End If
		output = Empty
		columnCount = record.FieldCount
		delim = "  "
		For column = 1 To columnCount
			If column = columnCount Then delim = vbLf
			output = output & record.StringData(column) & delim
		Next
		message = message & output
	Loop
End Sub

Sub CheckError
	Dim message, errRec
	If Err = 0 Then Exit Sub
	message = Err.Source & " " & Hex(Err) & ": " & Err.Description
	If Not installer Is Nothing Then
		Set errRec = installer.LastErrorRecord
		If Not errRec Is Nothing Then message = message & vbLf & errRec.FormatText
	End If
	Fail message
End Sub

Function ShowOutput(header, message)
	ShowOutput = vbOK
	If IsEmpty(message) Then Exit Function
	If isGUI Then
		ShowOutput = MsgBox(message, vbOKCancel, header)
	Else
		Wscript.Echo "> " & header
		Wscript.Echo message
	End If
End Function

Sub Fail(message)
	Wscript.Echo message
	Wscript.Quit 2
End Sub

'' SIG '' Begin signature block
'' SIG '' MIIiEAYJKoZIhvcNAQcCoIIiATCCIf0CAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' o40u8w/79QYYEVTk+LHUW40T5s95rhdh/xj2PF/Wgf2g
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
'' SIG '' BgkqhkiG9w0BCQQxIgQgZi2jXnHmXUs+wBApyuT8W3+J
'' SIG '' K0Ql3la+1qnCnmPAE0QwWgYKKwYBBAGCNwIBDDFMMEqg
'' SIG '' JIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBpAG4AZABv
'' SIG '' AHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20v
'' SIG '' d2luZG93czANBgkqhkiG9w0BAQEFAASCAQCJ9MUZIubk
'' SIG '' vh2PPurQHoUzcWQb9Y2fjVjy38C/1L9vRnQnla59YaWS
'' SIG '' 7SgLrUQP9hn1IqYENEERy4WLDnTsLU8ZJt8itl31yyqh
'' SIG '' gWAKBFF9aNNmtGr4KzDZq1HYajkXIVEVstJPS7okuQUG
'' SIG '' a9wPS99zoWPbbhfAfEv/omy4G2/DoRJO030qtH4KkRHA
'' SIG '' T9ELh185vJzBaCzXvyc8fylI94oiXT4jXz5jK+03awWc
'' SIG '' iYgP7H82sPUqmV8WCp4J/g+KuWPSctPTBLMckGrWMrw/
'' SIG '' 5ez5nYiyoaO0QkjYE1SxyeZvpjYIM102NAObdjAvNWus
'' SIG '' xL9i5InQUCvh5CH8n2NrRJt4oYITTDCCE0gGCisGAQQB
'' SIG '' gjcDAwExghM4MIITNAYJKoZIhvcNAQcCoIITJTCCEyEC
'' SIG '' AQMxDzANBglghkgBZQMEAgEFADCCATwGCyqGSIb3DQEJ
'' SIG '' EAEEoIIBKwSCAScwggEjAgEBBgorBgEEAYRZCgMBMDEw
'' SIG '' DQYJYIZIAWUDBAIBBQAEIPDE1brImfRreL+CmMaCq4DB
'' SIG '' 4AlkP0kKkuKYtn0JSWZ5AgZXj6OZ1vAYEjIwMTYwNzI4
'' SIG '' MTQwMDMxLjQxWjAHAgEBgAIB9KCBuaSBtjCBszELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUG
'' SIG '' A1UECxMebkNpcGhlciBEU0UgRVNOOjdEMkUtMzc4Mi1C
'' SIG '' MEY3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
'' SIG '' cCBTZXJ2aWNloIIO0DCCBnEwggRZoAMCAQICCmEJgSoA
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
'' SIG '' AACbIdeWAZNXi6QAAAAAAJswDQYJKoZIhvcNAQELBQAw
'' SIG '' fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
'' SIG '' b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
'' SIG '' Y3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWlj
'' SIG '' cm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMTYw
'' SIG '' NDI3MTcwNjIwWhcNMTcwNzI3MTcwNjIwWjCBszELMAkG
'' SIG '' A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAO
'' SIG '' BgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
'' SIG '' dCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUG
'' SIG '' A1UECxMebkNpcGhlciBEU0UgRVNOOjdEMkUtMzc4Mi1C
'' SIG '' MEY3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
'' SIG '' cCBTZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
'' SIG '' MIIBCgKCAQEAtu+uuIm4Op5VjikWs/G7mKXrmEg8Fuhb
'' SIG '' 7tSRUZCOeov6PbLKsx66uvm186doPHIrj24v+Eol58N7
'' SIG '' sZXXtvoL4gnGUTwKX5cA98aVcsQ1L72sHIMmuILDxUOw
'' SIG '' 69h7cLbD393+suBxN0OOG4NGNI8QFuT3dW1CbyXNhI7U
'' SIG '' Zeigeq6djAwAR8q9ZIS1jozs8N4ipp+T10LvBj44wZIg
'' SIG '' I40Xo5qZIxbPd0705cKZBCIMNy+tLnBd6JGIzdrKD8JE
'' SIG '' F8iIkUjT0OQEnsIRYJ0tYisD1pxgyA1zQGREgViJmwHd
'' SIG '' 1BxCQfpyOYY0m+r4gRG/N1IpwUcjljrdDPUFu2gxF9Uo
'' SIG '' PwIDAQABo4IBGzCCARcwHQYDVR0OBBYEFNb/UAkQfMI0
'' SIG '' RGeuemttqXW4Yn+pMB8GA1UdIwQYMBaAFNVjOlyKMZDz
'' SIG '' Q3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJoEeGRWh0
'' SIG '' dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3By
'' SIG '' b2R1Y3RzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNy
'' SIG '' bDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0
'' SIG '' dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMv
'' SIG '' TWljVGltU3RhUENBXzIwMTAtMDctMDEuY3J0MAwGA1Ud
'' SIG '' EwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJ
'' SIG '' KoZIhvcNAQELBQADggEBAKRrM5ZKncaaF/RFn/NDBLAA
'' SIG '' OxxJteWGMNhZguYyKVI3vl4TuSuPtT5br9wLiL9SkG9t
'' SIG '' bj2edPw8eUnyk/xvfdfs7c3hNQIm9HWKnZTy7qU2Jqky
'' SIG '' J1Vk4QhMEwb6MFxXmYyyIGyLhZAbE4qAtP3F2g3+sbpp
'' SIG '' td/qHCEdxSEjcl+CSQk9g2VqQ/KJHCJpY/gzaXYWdHpE
'' SIG '' rO1/W2/x33xfxJrFqn6210E+WywhhxwFOmxQ5D1/ZLO1
'' SIG '' Kt2yBH6C1kkvlm6xl292spgY40f2mEJUfYPYMwViB8/N
'' SIG '' 9UMNHItVcvcP9FkGHAETrwOTaLIEyblKFra/QtlkeWYW
'' SIG '' DBazsqJTOo2hggN5MIICYQIBATCB46GBuaSBtjCBszEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEn
'' SIG '' MCUGA1UECxMebkNpcGhlciBEU0UgRVNOOjdEMkUtMzc4
'' SIG '' Mi1CMEY3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1T
'' SIG '' dGFtcCBTZXJ2aWNloiUKAQEwCQYFKw4DAhoFAAMVADXU
'' SIG '' 4l+8jJBpzsn2m6EIo1jXtX/soIHCMIG/pIG8MIG5MQsw
'' SIG '' CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
'' SIG '' MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
'' SIG '' b2Z0IENvcnBvcmF0aW9uMQ0wCwYDVQQLEwRNT1BSMScw
'' SIG '' JQYDVQQLEx5uQ2lwaGVyIE5UUyBFU046NTdGNi1DMUUw
'' SIG '' LTU1NEMxKzApBgNVBAMTIk1pY3Jvc29mdCBUaW1lIFNv
'' SIG '' dXJjZSBNYXN0ZXIgQ2xvY2swDQYJKoZIhvcNAQEFBQAC
'' SIG '' BQDbQ9AdMCIYDzIwMTYwNzI4MDAyODEzWhgPMjAxNjA3
'' SIG '' MjkwMDI4MTNaMHcwPQYKKwYBBAGEWQoEATEvMC0wCgIF
'' SIG '' ANtD0B0CAQAwCgIBAAICCPACAf8wBwIBAAICGFcwCgIF
'' SIG '' ANtFIZ0CAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYB
'' SIG '' BAGEWQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAwehIDAN
'' SIG '' BgkqhkiG9w0BAQUFAAOCAQEAEzwm4s/jBWVuBg/5U5UZ
'' SIG '' qekAyaY98yuxJy0WfDoBYQ8caVpvR+ASGuhXnyMYNpwn
'' SIG '' q0Rl0guxQP8zS/DMuTjDaOk5YKfeZI9H+kkpWpt2Mm51
'' SIG '' gg2lC8XgidheoVk1/sfutWKieHgb8LgfQOwhNhI0BD6q
'' SIG '' VNIpbAaOa5F+HqrwWASUarIm8pQDafOJnuEVjv/EuXen
'' SIG '' x66WPPVdvd3AgW4ieghzdl+FN1maeW6MzCuewC6bLH6V
'' SIG '' WAKUm99t9zmckJIF+YjngyJw5a4GsvBk9J5sCrkNNxhi
'' SIG '' xijo1pRCwYhnFjGqD7NSyBambCzlm3BzhbbKY6jow+1s
'' SIG '' YJ5KkSV0jCDKdjGCAvUwggLxAgEBMIGTMHwxCzAJBgNV
'' SIG '' BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
'' SIG '' VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
'' SIG '' Q29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
'' SIG '' aW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAAmyHXlgGTV4uk
'' SIG '' AAAAAACbMA0GCWCGSAFlAwQCAQUAoIIBMjAaBgkqhkiG
'' SIG '' 9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkE
'' SIG '' MSIEIF+elFuF063e6FLgQYaHC3aRPZZ060B1G/hNIAQS
'' SIG '' Z5y+MIHiBgsqhkiG9w0BCRACDDGB0jCBzzCBzDCBsQQU
'' SIG '' NdTiX7yMkGnOyfaboQijWNe1f+wwgZgwgYCkfjB8MQsw
'' SIG '' CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
'' SIG '' MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
'' SIG '' b2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3Nv
'' SIG '' ZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAJsh15YB
'' SIG '' k1eLpAAAAAAAmzAWBBSKUHPp84SvgpxaSsf77jJHgHbQ
'' SIG '' kDANBgkqhkiG9w0BAQsFAASCAQAks4ygvm5YcB4r79Z6
'' SIG '' tQm4TaOplGRiP2dX0hmdg4hz6Wk2lScVGPPpTDr6AUDf
'' SIG '' YlQm0AE/l4Ua2LIGNhblU3ptIrOBnRyc13LCTK687kci
'' SIG '' i4BuN8UZPP+UBHjdBpGRZICWgviN22m9gXDhQbpH9i+0
'' SIG '' z+HANeNqhbUVxGuxrT7npwNK5Iujhlbig6px2Bq8EAI0
'' SIG '' CmY8HKapyjNoip4nl9Fmof6qbw77MnUYyUxDfVG0TgoU
'' SIG '' H4XebYBH29raFtZ+v2yQ6qHB4hGz1eAYeBy4MJdPKY1l
'' SIG '' uZZiMZGJpMNKZ5A0cKo2fJM/MLJu6XTLKnFxoYsrdVFz
'' SIG '' VumEX1JzVJdFjDKW
'' SIG '' End signature block
