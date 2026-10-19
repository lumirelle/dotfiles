@echo off

@REM Set the Windows system UI font to `Aporetic Serif` with `Zhuque Fangsong (technical preview)` as fallback
sudo reg add "HKLM\SOFTWARE\Microsoft\XAML" /v AutoFontFamily /t REG_SZ /d "Aporetic Serif, Zhuque Fangsong (technical preview)" /f

@REM Font links used to render the CJK glyphs missing from `Aporetic Serif`
sudo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" /v "Aporetic Serif" /t REG_MULTI_SZ /s "|" /d "ZHUQUEFANGSONG-REGULAR.TTF,Zhuque Fangsong (technical preview),128,96|ZHUQUEFANGSONG-REGULAR.TTF,Zhuque Fangsong (technical preview)|MSYH.TTC,Microsoft YaHei,128,96|MSYH.TTC,Microsoft YaHei|SEGUISYM.TTF,Segoe UI Symbol" /f
sudo reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink" /v "Aporetic Serif Bold" /t REG_MULTI_SZ /s "|" /d "ZHUQUEFANGSONG-BOLD.TTF,Zhuque Fangsong (technical preview) Bold,128,96|ZHUQUEFANGSONG-BOLD.TTF,Zhuque Fangsong (technical preview) Bold|MSYHBD.TTC,Microsoft YaHei Bold,128,96|MSYHBD.TTC,Microsoft YaHei Bold|SEGUISYM.TTF,Segoe UI Symbol" /f
