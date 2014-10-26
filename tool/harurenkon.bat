@echo off
cd /d "%~d0" 1>nul 2>&1
cd "%~p0" 1>nul 2>&1

if exist "%ProgramFiles(x86)%" (
  set XARCH=64bit
) else (
  set XARCH=32bit
)
set TEMP_DIR0=TEMP

call ".\version.bat"
call "..\setting\template\default_setting.bat"
call "..\setting\user_setting.bat"
if "%~1"=="natsurenkonupdate" (
  .\curl.exe -k %PROXY%  --connect-timeout 5 -f -o tool_url.zip -L "http://bit.ly/K1u07h" 2>nul
  if ERRORLEVEL 22 (
      call ".\tool_url_bk.bat"
  ) else (
      .\7z.exe e -bd -y ".\tool_url.zip" "tool_url.bat" 1>nul 2>&1
       copy /y tool_url.bat tool_url_bk.bat 1>nul 2>&1
       call ".\tool_url.bat"
  )
   call ".\update.bat"
   copy /y latest_version  current_version  1>nul 2>&1
   exit /b
) 
call "..\Ú×Ý’èƒ‚[ƒhy‚±‚±‚É“®‰æ‚ðD&Dz.bat" "%~1" "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8" "%~9" 
exit