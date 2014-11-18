@echo off
title %INSTALLER_TITLE%
color %BG_COLOR%
rem if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\INSTALLER_TITLE.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\INSTALLER_TITLE.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\INSTALLER_TITLE.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\INSTALLER_TITLE.wav"
      )
    )
rem  )
rem )

echo %HORIZON%
echo @%TDENC_NAME%  installer
echo %HORIZON%
echo;

rem call ..\setting\template\default_setting.bat
rem call ..\setting\user_setting.bat
call .\tool_url.bat

echo ^>^>%INSTALLER_ANNOUNCE%
echo;
if not "%HARUMODE%"=="true" (
  if not "%INSTALLONYMODE%"=="true" (
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
  )
)
echo;

.\7z.exe e -bd -y %AVS_PATH% "avisynth.dll" "devil.dll"
.\7z.exe e -bd -y %A2A_PATH% "avs2avi\Release\avs2avi.exe"
.\7z.exe e -bd -y %A2P_PATH% "avs2pipemod.exe"
rem .\7z.exe e -bd -y %A4X_PATH% "avs4x264mod.exe"
.\7z.exe e -bd -y %DSF_PATH% "ds_input\ds_input.aui"
.\7z.exe e -bd -y %DSS_PATH% "DirectShowSource.dll"
rem .\7z.exe e -bd -y %DIL_PATH% "DevIL.dll"
.\7z.exe e -bd -y %FFM_PATH% "ffmpeg-%FFM_VER%-win32-static\bin\ffmpeg.exe" "ffmpeg-%FFM_VER%-win32-static\bin\ffprobe.exe"
rem .\7z.exe e -bd -y %FSS_PATH% "*\x86\ffms2.dll" "*\x86\ffmsindex.exe"
.\7z.exe e -bd -y %FSS_PATH% "*\ffms2.dll" "*\ffmsindex.exe"
.\7z.exe e -bd -y %LIC_PATH% "bin\libiconv2.dll"
.\7z.exe e -bd -y %LIN_PATH% "bin\libintl3.dll"
rem pop
rem .\7z.exe e -bd -y %LSS_PATH% "AviSynth\LSMASHSource.dll"
rem takuan
.\7z.exe e -bd -y %LSS_PATH% "L-SMASH-Works_%LSS_VER%\AviSynth\LSMASHSource.dll"
.\7z.exe e -bd -y %MDP_PATH% "mdsplayc.exe"
.\7z.exe e -bd -y %JWP_PATH% "mediaplayer-*\player.swf" "mediaplayer-*\jwplayer.js"
if exist %MIFN_PATH% (
   .\7z.exe e -bd -y %MIFN_PATH% "MediaInfo.exe" "MediaInfo.dll"
) else (
   .\7z.exe e -bd -y %MIF_PATH% "MediaInfo.exe" "MediaInfo.dll"
)
.\7z.exe e -bd -y %MKV_PATH% "mkvtoolnix\mkvmerge.exe"
if "%XARCH%"=="64bit" (
  .\7z.exe e -bd -y %MP4B_PATH% "MP4Box_%MP4B_VER%_x64.exe"
  move /Y MP4Box_%MP4B_VER%_x64.exe MP4Box.exe
) else (
  .\7z.exe e -bd -y %MP4B_PATH% "MP4Box_%MP4B_VER%.exe"
  move /Y MP4Box_%MP4B_VER%.exe MP4Box.exe
)
.\7z.exe e -bd -y %MP4F_PATH% "mp4fpsmod_%MP4F_VER%\mp4fpsmod.exe" "mp4fpsmod_%MP4F_VER%\*.dll"
.\7z.exe e -bd -y %NERO_PATH% "win32\neroAacEnc.exe"
.\7z.exe e -bd -y %PCRE_PATH% "bin\pcre3.dll"
.\7z.exe e -bd -y %QAA_PATH% "qaac_%QAA_VER%\x86\qaac.exe"
if not exist msvcp120.dll (
  .\7z.exe e -bd -y %QAA_PATH% "qaac_%QAA_VER%\x86\msvcp120.dll" >nul 2>&1
)
if not exist msvcr120.dll (
  .\7z.exe e -bd -y %QAA_PATH% "qaac_%QAA_VER%\x86\msvcr120.dll" >nul 2>&1
)

rem .\7z.exe e -bd -y %QAE_PATH% "qtaacenc-%QAE_VER%\qtaacenc.exe"
.\7z.exe e -bd -y %QTS_PATH% "QTSource.dll"
.\7z.exe e -bd -y %REG_PATH% "bin\regex2.dll"
.\7z.exe e -bd -y %SED_PATH% "bin\sed.exe"
.\7z.exe e -bd -y %SORT_PATH% "bin\sort.exe" "bin\date.exe"
move /Y .\date.exe GNU_date.exe
.\7z.exe e -bd -y %WSS_PATH% "VC09\warpsharp.dll"
.\7z.exe e -bd -y %YDF_PATH% "yadif.dll"

:x264_install
for /f %%i in (%X264_PATH%) do (
	if /i "%%~xi"==".exe" (
		goto x264_exe_install
	) else if /i "%%~xi"==".zip" (
		goto x264_zip_install
	) else (
		goto x264_7z_install
	)
)

:x264_exe_install
move /y %X264_PATH% %X264EXE%
goto x264_installed

:x264_zip_install
if "%XARCH%"=="32bit" (
  .\7z.exe e -bd -y %X264_PATH% "x264.r%X264_VERSION%_win32.exe"
  move /y x264.r%X264_VERSION%_win32.exe %X264EXE%
) else (
  .\7z.exe e -bd -y %X264_PATH% "x264.r%X264_VERSION%_win64.exe"
  move /y x264.r%X264_VERSION%_win64.exe %X264EXE%
)
goto x264_installed

:x264_7z_install
if "%XARCH%"=="32bit" (
  .\7z.exe e -bd -y %X264_PATH% "*\x264.%X264_VERSION%.x86.exe"
  move /y x264.%X264_VERSION%.x86.exe %X264EXE%
) else (
  .\7z.exe e -bd -y %X264_PATH% "*\x264.%X264_VERSION%.x86_64.exe"
  move /y x264.%X264_VERSION%.x86_64.exe %X264EXE%
)

:x264_installed
if exist update_new.bat (
  move  /Y update_new.bat update.bat 1>nul 2>&1
)

set /a C_MIVER=%C_VERSION:~-2%
if %C_MIVER% LEQ 17 (
   mkdir %TEMP_DIR0%\20000101-000000
   cd %TEMP_DIR0%\20000101-000000
     ..\..\sed.exe -i -e "s/^set THIS_VERSION=[0-9]\{,2\}/set USER_VERSION=%THIS_VERSION%/" "..\..\..\setting\user_setting.bat"
     ..\..\sed.exe -i -e "s/295)/420)/" "..\..\..\setting\user_setting.bat"
     ..\..\sed.exe -i -e "s/^set E_TARGET_BITRATE=[0-9]\{,3\}/set E_TARGET_BITRATE=420/" "..\..\..\setting\user_setting.bat"
     ..\..\sed.exe -i -e "s/^set E_MAX_BITRATE=[0-9]\{,3\}/set E_MAX_BITRATE=445/" "..\..\..\setting\user_setting.bat"
   cd ..\..
)

:file_exist_check
if not exist Avisynth.dll echo Avisynth.dll is missing
if not exist avs2avi.exe echo avs2avi.exe is missing
if not exist avs2pipemod.exe echo avs2pipemod.exe is missing
rem if not exist avs4x264mod.exe echo avs4x264mod.exe is missing
if not exist GNU_date.exe echo date.exe is missing
if not exist ds_input.aui echo ds_input.aui is missing
if not exist DirectShowSource.dll echo DirectShowSource.dll is missing
if not exist DevIL.dll echo DevIL.dll is missing
if not exist ffmpeg.exe echo ffmpeg.exe is missing
if not exist ffprobe.exe echo ffprobe.exe is missing
if not exist ffms2.dll echo ffms2.dll is missing
if not exist ffmsindex.exe echo ffmsindex.exe is missing
if not exist libiconv2.dll echo libiconv2.dll is missing
if not exist libintl3.dll echo libintl3.dll is missing
if not exist LSMASHSource.dll echo LSMASHSource.dll is missing
if not exist mdsplayc.exe  start /wait call initialize.bat
if not exist MediaInfo.exe start /wait call initialize.bat
if not exist MediaInfo.dll start /wait call initialize.bat
if not exist mkvmerge.exe start /wait call initialize.bat
if not exist MP4Box.exe start /wait call initialize.bat
if not exist mp4fpsmod.exe start /wait call initialize.bat
if not exist neroAacEnc.exe echo neroAacEnc.exe is missing
if not exist pcre3.dll echo pcre3.dll is missing
if not exist player.swf echo player.swf is missing
if not exist qaac.exe echo qaac.exe is missing
if not exist regex2.dll echo regex2.dll is missing
if not exist sed.exe echo sed.exe is missing
if not exist sort.exe echo sort.exe is missing
if not exist warpsharp.dll echo warpsharp.dll is missing
if not exist yadif.dll echo yadif.dll is missing
if not exist %X264EXE% echo %X264EXE% is missing
.\%X264EXE% --version>"%TEMP_DIR0%\x264_version.txt" 2>nul
"%WINDIR%\system32\findstr.exe" /i "%X264_VERSION%" "%TEMP_DIR0%\x264_version.txt">nul 2>&1
if "%ERRORLEVEL%"=="1" echo %X264EXE% is missing

if not exist "%TEMP_DIR0%\x264_version.txt" (
   echo;
   echo %ANTIVIRUS_ERROR4%
   echo %ANTIVIRUS_ERROR5%
   echo;
   call .\quit.bat
)

echo;
echo ^>^>%INSTALLER_END%
echo ^>^>%PAUSE_MESSAGE2%
rem if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\INSTALLER_END.wav"
      )
    )
rem  )
rem )
pause>nul
exit
