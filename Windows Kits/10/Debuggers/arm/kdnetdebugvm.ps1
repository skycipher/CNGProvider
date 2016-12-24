#
# Argument initialization
#

$nextarg = "none"
$DebugPort = "unassigned"
$targetcomputer = "."
$VMName = ""
$VMGuid = ""
$AutoAssign = "false"
$DebugOff = "false"

function funHelp()
{
$helpText=@"

DESCRIPTION:
NAME: kdnetdebugvm.ps1
Displays (and optionally sets) the port used to network debug a VM.

PARAMETERS: 
-computerName Specifies the name of the computer on which to run the script
-help         Displays help
-vmname       (optional) Name of the VM of interest
-vmguid       (optional) GUID of the VM of interest
-port         (optional) Network port to use for debugging
-debugoff
-autoassign

Either vmname or vmguid must be specified to identify the VM, but not both.
Note that vmname may not uniquely identify the VM, but vmguid does.

SYNTAX:
kdnetdebugvm.ps1 [-computerName targetcomputer] [-vmname NameOfVM] [-vmguid GuidOfVM] [-port PortNumber]

"@
$helpText
exit
}


foreach ($argument in $args)
{
    # parse commands with no following arguments
    switch ($argument)
    {
        "?"     {funHelp}
        "help"  {funHelp}
        "-help" {funHelp}
        "/?"    {funHelp}
        "-?"    {funHelp}
        "autoassign"    {$AutoAssign = "true"}
        "-autoassign"   {$AutoAssign = "true"}
        "/autoassign"   {$AutoAssign = "true"}
        "debugoff"        {$DebugOff = "true"}
        "-debugoff"       {$DebugOff = "true"}
        "/debugoff"       {$DebugOff = "true"}
        default {}
    }

    # parse values that followed a switch

    switch ($nextarg)
    {
        "vmname"        {$VMName = $argument}
        "-vmname"       {$VMName = $argument}
        "/vmname"       {$VMName = $argument}
        "vmguid"        {$VMGuid = $argument}
        "-vmguid"       {$VMGuid = $argument}
        "/vmguid"       {$VMGuid = $argument}
        "port"          {$DebugPort = $argument}
        "-port"         {$DebugPort = $argument}
        "/port"         {$DebugPort = $argument}
        "computername"  {$targetcomputer = $argument}
        "-computername" {$targetcomputer = $argument}
        "/computername" {$targetcomputer = $argument}
        default         {}
    }

    $nextarg = $argument
}

if (($VMName -eq "") -and ($VMGuid -eq ""))
{
    funHelp
}

if (($VMName -ne "") -and ($VMGuid -ne ""))
{
    funHelp
}

$ns = "root\virtualization\v2"
$VMWPName = "$env:windir\system32\vmwp.exe"

#Get a VMManagementService object
$VMManagementService = gwmi -class "Msvm_VirtualSystemManagementService" -namespace $ns -computername $targetcomputer

#Get the VM object that we want to modify
if ($VMName -ne "")
{
    $VM = Get-VM -computername $targetcomputer -VMName $VMName
}

if ($VMGuid -ne "")
{
    $VM = Get-VM -computername $targetcomputer -Id $VMGuid
}

#Get the VirtualSystemGlobalSettingData of the VM we want to modify
$VMSystemGlobalSettingData = gwmi -namespace $ns -computername $targetcomputer -class Msvm_VirtualSystemSettingData | ? { $_.ConfigurationID -eq $VM.Id }

# Set a new debugport
if ($DebugPort -ne "unassigned")
{
    #Change the ElementName property
    $VMSystemGlobalSettingData.DebugPort = $DebugPort
    $VMSystemGlobalSettingData.DebugPortEnabled = 1

    $VMManagementService.ModifySystemSettings($VMSystemGlobalSettingData.GetText(1))
    $FWRuleName = "SynthDebugInboundRule-$DebugPort"
    New-NetFirewallRule -DisplayName $FWRuleName -Program $VMWPName -Protocol UDP -Action Allow -Direction Inbound -LocalPort $DebugPort
}

# Enable auto assigned debug ports
if ($AutoAssign -ne "false")
{
    #Change the ElementName property
    $VMSystemGlobalSettingData.DebugPortEnabled = 2
    $VMManagementService.ModifySystemSettings($VMSystemGlobalSettingData.GetText(1))
    Write-Host -Foreground Yellow "Firewall Ports for autoassign mode can be opened only after the VM is started."
}

# Turn off debugging
if ($DebugOff -ne "false")
{
    $DebugPort = $VMSystemGlobalSettingData.DebugPort
    #Change the ElementName property
    $VMSystemGlobalSettingData.DebugPortEnabled = 0
    $VMSystemGlobalSettingData.DebugPort = 0
    $VMManagementService.ModifySystemSettings($VMSystemGlobalSettingData.GetText(1))
    # May throw an exception if the rule did not exist already.
    # If two rules exist with the same name, both will be deleted.
    if ($DebugPort -ne 0)
    {
        $FWRuleName = "SynthDebugInboundRule-$DebugPort"
        Remove-NetFirewallRule -DisplayName $FWRuleName
    }
}

$VMSystemGlobalSettingData

exit

# SIG # Begin signature block
# MIIiEAYJKoZIhvcNAQcCoIIiATCCIf0CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDbHDLYuqp9Du8W
# ZSYoLwjEyhkYywkzwemxEtpUqBqajKCCC44wggUWMIID/qADAgECAhMzAAAA9yhU
# 7vvCmBtxAAAAAAD3MA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTAwHhcNMTYwMTA2MTgzOTA2WhcNMTcwNDA2MTgzOTA2WjCBjjEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9Q
# UjEpMCcGA1UEAxMgTWljcm9zb2Z0IFdpbmRvd3MgS2l0cyBQdWJsaXNoZXIwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDUBH7CqzOwW0w/8yfsAUwNHUbb
# PtxZZdRuNFzNShgx5bFMOin65ci469yg+JIvH+peI5YfRDxT3JlEjvSpif8ZUXjR
# UM1BGiy8ZXZgZ/GVJz7DF9zD9rX/Xa88DE2YRjuLD3u+d0ABt1HmAbbFrKZD9nqP
# 8QLCeqjrjMYTZRsSUy6DztRpVft6oZUK9TFKOIiH9aHfe1sxuJKKJNseV51NsbPi
# II8Bl5tf4whV/OEPQ56G0ScCXVtBCDtCRPFNaQR12td7zy5fZd9JSo6iTLgKZd8m
# 2t0ghWrXcbrpD2I3NAiwHaVAPlgtN+/TjZ4oky2XaCLrA8CPpFwjaSbmeMnPAgMB
# AAGjggF6MIIBdjAfBgNVHSUEGDAWBggrBgEFBQcDAwYKKwYBBAGCNwoDFDAdBgNV
# HQ4EFgQUOzBovaofIHs2TaewG/w4H4izOXQwUQYDVR0RBEowSKRGMEQxDTALBgNV
# BAsTBE1PUFIxMzAxBgNVBAUTKjMxNjE4K2IxMjQ1N2EwLTliODQtNDJiMC05OGY3
# LTVkMDFmNzdjZGJmNDAfBgNVHSMEGDAWgBTm/F97uyIAWORyTrX0IXQjMubvrDBW
# BgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNDb2RTaWdQQ0FfMjAxMC0wNy0wNi5jcmwwWgYIKwYBBQUH
# AQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtp
# L2NlcnRzL01pY0NvZFNpZ1BDQV8yMDEwLTA3LTA2LmNydDAMBgNVHRMBAf8EAjAA
# MA0GCSqGSIb3DQEBCwUAA4IBAQBiyDig8Z4IHcNFAmQiXC6E4i5GwjR7zGW2qko4
# GDstl/z4ov4wvBnJCEHOzyMOvFi3BpQrfV9BMI7KCMu4ECqpBjlKqPpTTrB2f/LS
# at3AmHIRLMo9X5tR8X2M3hx00mEOdkWjI0QXm4O3uF4Tt2/G76+6v+EYwPvac/Xb
# 2mMbuM0hNNyke6BG5hcydg++1u56dq2SWNTsHGJFlusdLlzCd30EcjgHanZUzi+A
# nd00Xmj0iy7ZGSlpkHaArqO2TAGbS+bGVOSXkO7i/IJXvMOzCgHJGiWSZmrosJFU
# MtgBUjCyHVKJzm+00AMauG6eM7vkW0jPHcVd+eu3lCCIICKbMIIGcDCCBFigAwIB
# AgIKYQxSTAAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2Vy
# dGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzA2MjA0MDE3WhcNMjUwNzA2
# MjA1MDE3WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgw
# JgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDEwMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6Q5kUHlntcTj/QkATJ6UrPdWaOpE2M/F
# WE+ppXZ8bUW60zmStKQe+fllguQX0o/9RJwI6GWTzixVhL99COMuK6hBKxi3oktu
# SUxrFQfe0dLCiR5xlM21f0u0rwjYzIjWaxeUOpPOJj/s5v40mFfVHV1J9rIqLtWF
# u1k/+JC0K4N0yiuzO0bj8EZJwRdmVMkcvR3EVWJXcvhnuSUgNN5dpqWVXqsogM3V
# sp7lA7Vj07IUyMHIiiYKWX8H7P8O7YASNUwSpr5SW/Wm2uCLC0h31oVH1RC5xuiq
# 7otqLQVcYMa0KlucIxxfReMaFB5vN8sZM4BqiU2jamZjeJPVMM+VHwIDAQABo4IB
# 4zCCAd8wEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFOb8X3u7IgBY5HJOtfQh
# dCMy5u+sMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAP
# BgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjE
# MFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kv
# Y3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEF
# BQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9w
# a2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MIGdBgNVHSAEgZUw
# gZIwgY8GCSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0cDovL3d3dy5taWNy
# b3NvZnQuY29tL1BLSS9kb2NzL0NQUy9kZWZhdWx0Lmh0bTBABggrBgEFBQcCAjA0
# HjIgHQBMAGUAZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQAZQBtAGUAbgB0
# AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAGnTvV08pe8QWhXi4UNMi/AmdrIKX+DT/
# KiyXlRLl5L/Pv5PI4zSp24G43B4AvtI1b6/lf3mVd+UC1PHr2M1OHhthosJaIxrw
# jKhiUUVnCOM/PB6T+DCFF8g5QKbXDrMhKeWloWmMIpPMdJjnoUdD8lOswA8waX/+
# 0iUgbW9h098H1dlyACxphnY9UdumOUjJN2FtB91TGcun1mHCv+KDqw/ga5uV1n0o
# UbCJSlGkmmzItx9KGg5pqdfcwX7RSXCqtq27ckdjF/qm1qKmhuyoEESbY7ayaYkG
# x0aGehg/6MUdIdV7+QIjLcVBy78dTMgW77Gcf/wiS0mKbhXjpn92W9FTeZGFndXS
# 2z1zNfM8rlSyUkdqwKoTldKOEdqZZ14yjPs3hdHcdYWch8ZaV4XCv90Nj4ybLeu0
# 7s8n07VeafqkFgQBpyRnc89NT7beBVaXevfpUk30dwVPhcbYC/GO7UIJ0Q124yNW
# eCImNr7KsYxuqh3khdpHM2KPpMmRM19xHkCvmGXJIuhCISWKHC1g2TeJQYkqFg/X
# YTyUaGBS79ZHmaCAQO4VgXc+nOBTGBpQHTiVmx5mMxMnORd4hzbOTsNfsvU9R1O2
# 4OXbC2E9KteSLM43Wj5AQjGkHxAIwlacvyRdUQKdannSF9PawZSOB3slcUSrBmrm
# 1MbfI5qWdcUxghXYMIIV1AIBATCBlTB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBD
# QSAyMDEwAhMzAAAA9yhU7vvCmBtxAAAAAAD3MA0GCWCGSAFlAwQCAQUAoIHGMBkG
# CSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEE
# AYI3AgEVMC8GCSqGSIb3DQEJBDEiBCD12p2EXg5HuAOMXy8l2stP0pmptaSGI99p
# du8uRzlUuDBaBgorBgEEAYI3AgEMMUwwSqAkgCIATQBpAGMAcgBvAHMAbwBmAHQA
# IABXAGkAbgBkAG8AdwBzoSKAIGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS93aW5k
# b3dzMA0GCSqGSIb3DQEBAQUABIIBADEaHzWElFF+/noT9XY2ubSoF1XGY7HlEoLg
# FbK3IuNtwvtoVkTW7BtPGwPpGgl63RqFeiRdFrK3RYh56XZSh1qd2Q1r2W2WnuIZ
# YgsMASj/GLXHzNIO13UxurngpmkcFA0FQdZs66Hner5LldHc6wzRVyXkF0N4v/sH
# Zcn3zry+OoIwGgrs+GcM7KhPDn+rp7nWZ0iPnaL38R1nBgPeD8k+e8XDdpGPT5uR
# G9qO/xRLR9E+qOm9aevzV6UscPdy3YYQFpdVTqTziSfsRxMbDD9qUVBn4wPwNRIj
# YJNVaLcTET6bs8kXECgy+f+8j+ZOo5BB6FbWs2h09QIRTXHlq3OhghNKMIITRgYK
# KwYBBAGCNwMDATGCEzYwghMyBgkqhkiG9w0BBwKgghMjMIITHwIBAzEPMA0GCWCG
# SAFlAwQCAQUAMIIBOgYLKoZIhvcNAQkQAQSgggEpBIIBJTCCASECAQEGCisGAQQB
# hFkKAwEwMTANBglghkgBZQMEAgEFAAQgH2Ly3ClDoB7U+Fhjam53SJfz1LKucf7M
# OO9K58br5a4CBldpgPQE2hgTMjAxNjA3MTYxNDQ5NDMuOTc4WjAEgAIB9KCBuaSB
# tjCBszELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjENMAsGA1UE
# CxMETU9QUjEnMCUGA1UECxMebkNpcGhlciBEU0UgRVNOOjE0OEMtQzRCOS0yMDY2
# MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIO0DCCBnEw
# ggRZoAMCAQICCmEJgSoAAAAAAAIwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBS
# b290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTEwMDcwMTIxMzY1NVoX
# DTI1MDcwMTIxNDY1NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCpHQ28dxGKOiDs/BOX9fp/aZRr
# dFQQ1aUKAIKF++18aEssX8XD5WHCdrc+Zitb8BVTJwQxH0EbGpUdzgkTjnxhMFmx
# MEQP8WCIhFRDDNdNuDgIs0Ldk6zWczBXJoKjRQ3Q6vVHgc2/JGAyWGBG8lhHhjKE
# HnRhZ5FfgVSxz5NMksHEpl3RYRNuKMYa+YaAu99h/EbBJx0kZxJyGiGKr0tkiVBi
# sV39dx898Fd1rL2KQk1AUdEPnAY+Z3/1ZsADlkR+79BL/W7lmsqxqPJ6Kgox8NpO
# BpG2iAg16HgcsOmZzTznL0S6p/TcZL2kAcEgCZN4zfy8wMlEXV4WnAEFTyJNAgMB
# AAGjggHmMIIB4jAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQU1WM6XIoxkPND
# e3xGG8UzaFqFbVUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQD
# AgGGMA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb
# 186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29t
# L3BraS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoG
# CCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwgaAGA1Ud
# IAEB/wSBlTCBkjCBjwYJKwYBBAGCNy4DMIGBMD0GCCsGAQUFBwIBFjFodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vUEtJL2RvY3MvQ1BTL2RlZmF1bHQuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAFAAbwBsAGkAYwB5AF8AUwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQAH5ohRDeLG4Jg/gXEDPZ2j
# oSFvs+umzPUxvs8F4qn++ldtGTCzwsVmyWrf9efweL3HqJ4l4/m87WtUVwgrUYJE
# Evu5U4zM9GASinbMQEBBm9xcF/9c+V4XNZgkVkt070IQyK+/f8Z/8jd9Wj8c8pl5
# SpFSAK84Dxf1L3mBZdmptWvkx872ynoAb0swRCQiPM/tA6WWj1kpvLb9BOFwnzJK
# J/1Vry/+tuWOM7tiX5rbV0Dp8c6ZZpCM/2pif93FSguRJuI57BlKcWOdeyFtw5yj
# ojz6f32WapB4pm3S4Zz5Hfw42JT0xqUKloakvZ4argRCg7i1gJsiOCC1JeVk7Pf0
# v35jWSUPei45V3aicaoGig+JFrphpxHLmtgOR5qAxdDNp9DvfYPw4TtxCd9ddJgi
# CGHasFAeb73x4QDf5zEHpJM692VHeOj4qEir995yfmFrb3epgcunCaw5u+zGy9iC
# tHLNHfS4hQEegPsbiSpUObJb2sgNVZl6h3M7COaYLeqN4DMuEin1wC9UJyH3yKxO
# 2ii4sanblrKnQqLJzxlBTeCG+SqaoxFmMNO7dDJL32N79ZmKLxvHIa9Zta7cRDyX
# UHHXodLFVeNp3lfB0d4wwP3M5k37Db9dT+mdHhk4L7zPWAUu7w2gUDXa7wknHNWz
# fjUeCLraNtvTX4/edIhJEjCCBNowggPCoAMCAQICEzMAAACJSfUM5PGLlLMAAAAA
# AIkwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAw
# HhcNMTYwMzMwMTkyNDI2WhcNMTcwNjMwMTkyNDI2WjCBszELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UECxMe
# bkNpcGhlciBEU0UgRVNOOjE0OEMtQzRCOS0yMDY2MSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
# CgKCAQEAvn5BtffxxzUhO05XTh44IFz1qtxVJw6xH0I3p3p9hpv8TrYJbT3nKCB9
# GhkaG8uTYhugsS4mRQN8p6seF/tQh4AV8wHjagHoVq1u2H6QZz71ity62qOOgzGO
# 2UKtnOIRJ0k+Ej9ZbJatIX6ZJ5K5seN0ZjQkIKD7GU1y0AGytuG4B2pPrWHKHeDe
# MJo+O4dca+ABNUy9smENvtA9Dhw8UFJxkVsiFXoUqBavlZBUIYOh8tKoiH6K23LS
# 82PIN788RAGgkSynHqr5qAODfLKq9/aQ/8IpkqTJDxSFCS5NMm3Vl8VmhcSOgeqh
# d0zcu++hhCr+UhHq/6FN8Xn9SePwQwIDAQABo4IBGzCCARcwHQYDVR0OBBYEFNXA
# +kEUXZfXTnkK2ZuHpL9X/lOwMB8GA1UdIwQYMBaAFNVjOlyKMZDzQ3t8RhvFM2ha
# hW1VMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9w
# a2kvY3JsL3Byb2R1Y3RzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNybDBaBggr
# BgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNv
# bS9wa2kvY2VydHMvTWljVGltU3RhUENBXzIwMTAtMDctMDEuY3J0MAwGA1UdEwEB
# /wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZIhvcNAQELBQADggEBAKNT
# LOj8EHnj0fw7KPPTF766GQnE+9ULmtZjzmYSZT6UmA7EboBA7uwXZVDdngwXBxCc
# xwAUqh/IWPoA352tGPCvYXfRXGHF5gM7FpZUttBj1hWXexO23bcMoDTdzlsKQwYr
# fAdz+hYHs9KQYOHJMas8xZmMPsgwBAZzwb6uA3zaKPEKYdOcCGWk07W/RhXcJYuM
# ubshU3H/Z3L61MymK0emc9p/XtRa4XTFxyxOAQC93et6EsR2fKWb96hhHK+TZuNz
# UmSPuH9qC7pDwcVje+cYtDH7z+LWIP3iPpNkg2RtbHQP6CUNMW3h6Lun0LfRamif
# d2rh+o5Q5+7N/8U5Za+hggN5MIICYQIBATCB46GBuaSBtjCBszELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjENMAsGA1UECxMETU9QUjEnMCUGA1UE
# CxMebkNpcGhlciBEU0UgRVNOOjE0OEMtQzRCOS0yMDY2MSUwIwYDVQQDExxNaWNy
# b3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiUKAQEwCQYFKw4DAhoFAAMVAIZYkkTp
# PoF756DZAHjgQvt8osrooIHCMIG/pIG8MIG5MQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMQ0wCwYDVQQLEwRNT1BSMScwJQYDVQQLEx5uQ2lwaGVy
# IE5UUyBFU046NERFOS0wQzVFLTNFMDkxKzApBgNVBAMTIk1pY3Jvc29mdCBUaW1l
# IFNvdXJjZSBNYXN0ZXIgQ2xvY2swDQYJKoZIhvcNAQEFBQACBQDbND0zMCIYDzIw
# MTYwNzE2MDQ1NzIzWhgPMjAxNjA3MTcwNDU3MjNaMHcwPQYKKwYBBAGEWQoEATEv
# MC0wCgIFANs0PTMCAQAwCgIBAAICHyoCAf8wBwIBAAICGlgwCgIFANs1jrMCAQAw
# NgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGEWQoDAaAKMAgCAQACAwehIKEKMAgC
# AQACAwehIDANBgkqhkiG9w0BAQUFAAOCAQEAJN+z0Un+7yKAsCGR2G7B4o8tI1JX
# XIcq9F58wvc5CDPgNB/qqGtxsp3XKwJJ64vNYzLShWdFIFvBj4Kb7V/+VTX6khoE
# gK27I2x+OMcJ6UVoc31GTb1HJ5JWZrL6FNK41sL1KaYtxP8BOvnAnjs/f1pLq1u/
# O8O9dE2YwSVtVs3YrTOeAS6Fj8YldwATg3ZVuBjBOVyEI3SNv3j/B2gwTiJlmZHO
# h+vXtbzORIbuqIJbsBhM0IdUr7MOa7Bn3G7yS9sXvpWflMnlMqdaTaQh8+Y88NB1
# 6q14ksveQVdAiATjrk2RowkuqT+MLLoS3mLGM6FHealrvLIKPo5+Or4LWzGCAvUw
# ggLxAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# JjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAAiUn1
# DOTxi5SzAAAAAACJMA0GCWCGSAFlAwQCAQUAoIIBMjAaBgkqhkiG9w0BCQMxDQYL
# KoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIOhzjlQ2l+R3nkKJ0MOf0AnqEcPT
# KH4KOwOPGr/laaGKMIHiBgsqhkiG9w0BCRACDDGB0jCBzzCBzDCBsQQUhliSROk+
# gXvnoNkAeOBC+3yiyugwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Eg
# MjAxMAITMwAAAIlJ9Qzk8YuUswAAAAAAiTAWBBTmzjg5n2RIxEv0Lz7EsVP8vYbn
# xTANBgkqhkiG9w0BAQsFAASCAQAOCT2A3A31WEgxRf71kn54L4kVGrEq/B1Dx5XG
# dfBKaZQG0WpDyBi9OHCnxrgSEYUTXfJcwlZgEe+A7PKFvGVHY0TUWGATYuUtklbw
# zS9l6rXGqklbjh3lOHSjvjkl4ossBVmk2t9/PwHcglwk+wRkChAXhjmstr0Ieobx
# DOrbmj1MN8WqyQEdQK8o8r3S+qpZnRi6hjleahbkaNAP1JIQ51m1MfHINreE2wVX
# bRrBZUQmk/vlFBVMB2gsWiwwW6y60brlLKt2tNargxG6Xk8EkIZ60jEI/VMstAcj
# NAcamT2atv6yBQnFFCTU4/K5/1yL8oXJidtKBUoo0ozR37Zx
# SIG # End signature block
