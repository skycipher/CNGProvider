@echo off
IF "%1"=="" echo Missing first parameter.  &GOTO Help
IF "%1"=="-?" GOTO Help
IF "%1"=="/?" GOTO Help
IF "%2"=="" echo Missing second parameter. &GOTO Help
IF "%2"=="-?" GOTO Help
IF "%2"=="/?" GOTO Help


if /I %2==UMDF (
  echo Looking for UMDF service key.
  echo reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Wudf\Services\%1"
  reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Wudf\Services\%1"
  if NOT ERRORLEVEL 1 (  
    goto :SetUmdfServiceKey
    goto :eof
  ) else (
  echo Error:
  echo UMDF service key for %1 not found. Exiting.
  echo ** Was the driver installed?
  goto :eof
  )
)

if /I %2==KMDF (
  echo Looking for KMDF service key.
  echo reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%1\Parameters\Wdf"
  reg query "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%1\Parameters\Wdf"
  if NOT ERRORLEVEL 1 (  
    goto :SetKmdfServiceKey
    goto :eof
  ) else (
  echo Error:
  echo KMDF service key for %1 not found. Exiting.
  echo ** Was the driver installed?
  goto :eof
  )
)
echo Invalid argument %2
GOTO Help
goto :eof

:SetUmdfServiceKey
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Wudf\Services\%1\Parameters\Wdf" /v EnhancedVerifierOptions /t REG_DWORD /d 0x00f00000 /f 
if NOT ERRORLEVEL 1 (
  echo Done.
  echo ** Enhanced verifier enabled. Reload the driver for it to take effect.
)
goto :eof

:SetKmdfServiceKey
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\%1\Parameters\Wdf" /v EnhancedVerifierOptions /t REG_DWORD /d 0x00f00000 /f
if NOT ERRORLEVEL 1 (
  echo Done.
  echo ** Enhanced verifier enabled. Reload the driver for it to take effect.
)
goto :eof

:Help
echo Usage: WdfPerfEnhancedVerifier (ServiceName) (Umdf or Kmdf)
echo example: WdfPerfEnhancedVerifier MyUmdfServiceName Umdf
echo example: WdfPerfEnhancedVerifier MyKmdfServiceName Kmdf
