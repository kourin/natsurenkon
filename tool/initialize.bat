@echo off
title %INIT_TITLE%
color %BG_COLOR%

echo %HORIZON%
echo Å@%TDENC_NAME%  %INIT_ANNOUNCE%
echo %HORIZON%
echo;
if "%INIT_ANNOUNCE%"=="%INIT_ANNOUNCE2%" (
rem  if not "%INSTALLONYMODE%"=="true" (
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.wav"
        )
      )
rem    )
rem  )
)
start /wait call .\tool_downloader.bat
if not "%DL_STATUS%"=="fail" start /wait call .\tool_installer.bat

exit