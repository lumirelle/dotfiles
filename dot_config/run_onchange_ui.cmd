@echo off

@REM Set the Windows system UI font to `Space Grotesk` with `Resource Han Rounded SC` as fallback
sudo reg add "HKLM\SOFTWARE\Microsoft\XAML" /v AutoFontFamily /t REG_SZ /d "Space Grotesk, Resource Han Rounded SC" /f

@REM Font links used to render the CJK glyphs missing from `Space Grotesk`
sudo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" /v "Space Grotesk" /t REG_MULTI_SZ /s "|" /d "RESOURCEHANROUNDEDSC-REGULAR.TTC,Resource Han Rounded SC Regular,128,96|RESOURCEHANROUNDEDSC-REGULAR.TTC,Resource Han Rounded SC Regular|MSYH.TTC,Microsoft YaHei,128,96|MSYH.TTC,Microsoft YaHei|SEGUISYM.TTF,Segoe UI Symbol" /f
sudo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" /v "Space Grotesk Bold" /t REG_MULTI_SZ /s "|" /d "RESOURCEHANROUNDEDSC-BOLD.TTC,Resource Han Rounded SC Bold,128,96|RESOURCEHANROUNDEDSC-BOLD.TTC,Resource Han Rounded SC Bold|MSYHBD.TTC,Microsoft YaHei Bold,128,96|MSYHBD.TTC,Microsoft YaHei Bold|SEGUISYM.TTF,Segoe UI Symbol" /f
