@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------   
 
@echo off
set instpath="C:\Program Files\PhoneVR"
mkdir %instpath%
icacls %instpath% /grant:r Everyone:(OI)(CI)F
xcopy /eyi %~dp0bin %instpath%

if "%PROCESSOR_ARCHITECTURE%" == "x86" (
  "C:\Program Files\Steam\steamapps\common\SteamVR\bin\win32\vrpathreg" adddriver %instpath%\PVRServer
)
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
  "C:\Program Files (x86)\Steam\steamapps\common\SteamVR\bin\win64\vrpathreg" adddriver %instpath%\PVRServer
)

echo.
echo PhoneVR installed
echo.
pause