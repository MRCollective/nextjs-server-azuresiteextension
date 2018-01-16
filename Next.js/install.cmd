@echo off

powershell.exe -ExecutionPolicy RemoteSigned -File install.ps1

set ErrLevel= %ERRORLEVEL%
set /p output= < err.txt
del err.txt

echo %output%

exit /b %ErrLevel%
