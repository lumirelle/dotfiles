@echo off
rem build-pyyaml - build a PyYAML wheel for the active interpreter into the local
rem pip wheelhouse, for Pythons that have no prebuilt PyYAML wheel yet.
rem The work lives in build-pyyaml.py so the sh and nushell front ends share it.

setlocal

rem Match mason's own lookup order on Windows: python, then python3.
set "_build_pyyaml_python=python"
where python >nul 2>nul || set "_build_pyyaml_python=python3"

"%_build_pyyaml_python%" "%~dp0build-pyyaml.py"

exit /b %ERRORLEVEL%
