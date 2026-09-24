@echo off

@REM Manually restore the default Windows system UI font
@REM Counterpart of `run_onchange_ui.cmd`, run it by hand when the custom UI font breaks the system

sudo reg delete "HKLM\SOFTWARE\Microsoft\XAML" /v AutoFontFamily /f
sudo reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" /v "Space Grotesk" /f
sudo reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" /v "Space Grotesk Bold" /f
