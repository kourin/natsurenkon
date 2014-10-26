@echo off

rem ------------------------------------------------------------------------------
rem 　つんでれんこ  バージョンチェック
rem ------------------------------------------------------------------------------


rem ################初期処理################
if not exist current_version echo %C_VERSION%> current_version
for %%i in (current_version) do if %%~zi GTR 50 (
  echo %C_VERSION%> current_version
)
if "%DEBUG_MODE%"=="true" set VER_URL="http://kourindrug.sakura.ne.jp/files/tde/latest_version2"

date /t>nul
.\curl.exe %PROXY% --connect-timeout 5 -f -o %VER_PATH% -L %VER_URL% 2>nul
if ERRORLEVEL 22 (
    echo;
    echo ^>^>%VER_CHECK_ERROR%
    echo;
    exit /b
)
for /f "usebackq" %%i in (%VER_PATH%) do if %%~zi GTR 50 (
    echo;
    echo ^>^>%VER_CHECK_ERROR%
    echo;
    exit /b
)
for /f "delims=" %%i in (current_version) do set C_VERSION=%%i
if not exist %VER_PATH% (
  copy /y tool_url.bat tool_url_bk.bat 1>nul 2>&1
  goto :eof
)
for /f "usebackq delims=" %%i in (%VER_PATH%) do set L_VERSION=%%i
if "%C_VERSION%"=="%L_VERSION%" goto :eof

.\curl.exe %PROXY% --connect-timeout 5 -f -o %LOG_PATH% -L %LOG_URL% 2>nul
echo;
echo ^>^>%VER_CHECK_NEW1%^(%L_VERSION%^)
rem echo ^>^>%VER_CHECK_NEW2%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
echo;
echo;
echo ^<%VER_CHECK_LOG%^>
type ChangeLog

echo;
echo;
echo;

:version_check
echo ^>^>%UPDATE_QUESTION1%
echo ^>^>%UPDATE_QUESTION2%
echo ^>^>%UPDATE_QUESTION3%
rem echo ^>^>%UPDATE_QUESTION4%
set /p VERSION_UP=^>^>
if /i "%VERSION_UP%"=="y" (
    echo %L_VERSION%> current_version
    copy /y tool_url.bat tool_url_bk.bat 1>nul 2>&1
    call ".\update.bat"
    goto :eof
)
if /i "%VERSION_UP%"=="n" (
  copy /y tool_url_bk.bat tool_url.bat 1>nul 2>&1
  goto :eof
)
if /i "%VERSION_UP%"=="s" (
  echo %L_VERSION%> current_version
  copy /y tool_url_bk.bat tool_url.bat 1>nul 2>&1
  goto :eof
)
echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto version_check
