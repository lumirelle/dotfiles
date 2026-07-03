@gsudo status IsElevated --no-output || (gsudo "%~f0" & exit /b)
reg import "%USERPROFILE%\.config\ui_fraunces.reg"
