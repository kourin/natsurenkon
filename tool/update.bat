@echo off

echo;
echo ^>^>%UPDATE_ANNOUNCE1%
echo;

if exist "..\Archives\update" rmdir /s /q "..\Archives\update"
if "%DEBUG_MODE%"=="true" set UPD_URL2=%UPD_URL3%
date /t>nul
.\curl.exe %PROXY% --connect-timeout 5 -f -o %UPD_PATH2% -L %UPD_URL2%
if ERRORLEVEL 22 (
    echo;
    echo ^>^>%UPDATE_ERROR%
    echo;
    exit /b
)

.\7z.exe x -bd -y %UPD_PATH2% -o"..\Archives\"

echo;
move ..\Archives\natsurenkon* ..\Archives\update
move  /Y ..\Archives\update\tool\update.bat ..\Archives\update\tool\update_new.bat
move /Y ..\Archives\update\setting\x\high.bat ..\Archives\update\setting\x\high_template.bat
del  ..\Archives\update\setting\x264_common.bat
del  ..\Archives\update\setting\user_setting.bat
del  ..\Archives\update\setting\enc_setting.bat
del ..\Archives\update\setting\End_Sound.txt

echo;
xcopy /y /s /c ..\Archives\update\* ..\ 2>nul

echo;
rmdir /s /q ..\Archives\update 2>nul

call ..\setting\template\default_setting.bat
call ..\setting\user_setting.bat
call ..\setting\enc_setting.bat
set VOICE=false

if not exist ..\Extra\Voice goto update_end

.\curl.exe %PROXY% --connect-timeout 5 -f -o %EXV_PATH% -L %EXV_URL% 2>nul
if ERRORLEVEL 22 goto update_end
if not exist latest_Extra_version goto update_end
for /f "delims=" %%i in (latest_Extra_version) do set L_EXTRA_VERSION=%%i

if "%EXTRA_VERSION%"=="%L_EXTRA_VERSION%" goto update_end

if exist "..\Archives\Extra" rmdir /s /q "..\Archives\Extra"
date /t>nul
.\curl.exe %PROXY% --connect-timeout 5 -f -o %UPDEX_PATH% -L %UPDEX_URL%
if ERRORLEVEL 22 goto update_end

.\7z.exe x -bd -y %UPDEX_PATH% -o"..\Archives\"

echo;
xcopy /y /s /c ..\Archives\Extra\* ..\Extra 2>nul

echo;
rmdir /s /q ..\Archives\Extra 2>nul

:update_end
echo;
echo ^>^>%UPDATE_ANNOUNCE2%
rem echo ^>^>%UPDATE_ANNOUNCE3%
echo ^>^>%PAUSE_MESSAGE2%
pause>nul

set INIT_ANNOUNCE=%INIT_ANNOUNCE2%

call ".\initialize.bat"
REM start /wait call ".\initialize.bat"
