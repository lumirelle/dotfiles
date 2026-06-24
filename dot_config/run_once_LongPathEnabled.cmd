@gsudo status IsElevated --no-output || (gsudo "%~f0" & exit /b)
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem /v LongPathsEnabled /t REG_DWORD /d 00000001
