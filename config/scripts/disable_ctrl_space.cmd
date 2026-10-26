@echo off

@REM Disable the hotkey `ctrl+space` which switches the input method language
@REM `HKU\.DEFAULT` needs elevation, `HKCU` does not

sudo reg add "HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000010" /v "Key Modifiers" /t REG_BINARY /d 00000000 /f
sudo reg add "HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000010" /v "Target IME" /t REG_BINARY /d 00000000 /f
sudo reg add "HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000010" /v "Virtual Key" /t REG_BINARY /d ff000000 /f
sudo reg add "HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000070" /v "Key Modifiers" /t REG_BINARY /d 00000000 /f
sudo reg add "HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000070" /v "Target IME" /t REG_BINARY /d 00000000 /f
sudo reg add "HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000070" /v "Virtual Key" /t REG_BINARY /d ff000000 /f

reg add "HKCU\Control Panel\Input Method\Hot Keys\00000010" /v "Key Modifiers" /t REG_BINARY /d 00000000 /f
reg add "HKCU\Control Panel\Input Method\Hot Keys\00000010" /v "Target IME" /t REG_BINARY /d 00000000 /f
reg add "HKCU\Control Panel\Input Method\Hot Keys\00000010" /v "Virtual Key" /t REG_BINARY /d ff000000 /f
reg add "HKCU\Control Panel\Input Method\Hot Keys\00000070" /v "Key Modifiers" /t REG_BINARY /d 00000000 /f
reg add "HKCU\Control Panel\Input Method\Hot Keys\00000070" /v "Target IME" /t REG_BINARY /d 00000000 /f
reg add "HKCU\Control Panel\Input Method\Hot Keys\00000070" /v "Virtual Key" /t REG_BINARY /d ff000000 /f
