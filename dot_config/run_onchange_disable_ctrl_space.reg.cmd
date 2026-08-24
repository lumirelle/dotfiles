@REM {{ joinPath .chezmoi.homeDir ".config/disable_ctrl_space.reg" | include | sha256sum }}

sudo reg import "%USERPROFILE%\.config\disable_ctrl_space.reg"
