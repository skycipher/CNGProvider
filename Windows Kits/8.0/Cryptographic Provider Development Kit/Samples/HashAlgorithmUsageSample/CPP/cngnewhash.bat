reg add "HKLM\SYSTEM\CurrentControlSet\Control\Cryptography\Providers\Microsoft Test Provider\UM" /v Image /t REG_SZ /d "HashProv.dll" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Cryptography\Providers\Microsoft Test Provider\UM\00000002" /v Flags /t REG_DWORD /d 0 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Cryptography\Providers\Microsoft Test Provider\UM\00000002" /v Functions /t REG_MULTI_SZ /d "MD0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\Default\00000002\MD0" /v Flags /t REG_DWORD /d 0 /F 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Cryptography\Configuration\Local\Default\00000002\MD0" /v Providers /t REG_MULTI_SZ /d "Microsoft Test Provider" /f

