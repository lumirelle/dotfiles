@echo off

@REM WinGet only puts the command aliases of portable packages in
@REM `%LOCALAPPDATA%\Microsoft\WinGet\Links` when it is allowed to create symlinks,
@REM which needs `SeCreateSymbolicLinkPrivilege`: elevation or Developer Mode.
@REM Otherwise it silently appends every package directory to PATH instead.
@REM `mise bootstrap` always shells out to
@REM `winget install --id <id> --exact --silent ... --disable-interactivity`
@REM unelevated, so every portable package there adds one more PATH entry.
@REM Same value the `Settings > System > For developers` toggle writes.

sudo reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense /t REG_DWORD /d 1 /f

@REM Verify; `AllowDevelopmentWithoutDevLicense` should read 0x1
reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /v AllowDevelopmentWithoutDevLicense
