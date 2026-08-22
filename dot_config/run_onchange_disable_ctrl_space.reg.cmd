@REM {{ joinPath .chezmoi.homeDir ".config/disable_ctrl_space.reg" | include | sha256sum }}

@gsudo status IsElevated --no-output || (gsudo "%~f0" & exit /b)
reg import "%USERPROFILE%\.config\disable_ctrl_space.reg"
