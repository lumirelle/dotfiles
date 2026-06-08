@gsudo status IsElevated --no-output || (gsudo "%~f0" & exit /b)

reg import "%APPDATA%\Rime\disable-ctrl+space.reg"