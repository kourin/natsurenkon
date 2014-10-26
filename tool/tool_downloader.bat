@echo off
title %DOWNLOADER_TITLE%
color %BG_COLOR%
rem if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_TITLE.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_TITLE.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_TITLE.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_TITLE.wav"
      )
    )
rem  )
rem )

echo %HORIZON%
echo 　%TDENC_NAME%  ToolDownloader
echo %HORIZON%
echo;


rem ################初期処理################
if not exist ..\Archives mkdir ..\Archives
set A2A=f
set A2P=f
rem set A4X=f
set AVS=f
set DIL=f
set DSF=f
set DSS=f
set FFM=f
set FSS=f
set JWP=f
set LIC=f
set LIN=f
set LSS=f
set MDP=f
set MIF=f
set MIFN=f
set MKV=f
set MP4B=f
set MP4F=f
set PCRE=f
set QTS=f
set REG=f
set SED=f
set SORT=f
set WSS=f
set X264=f
set YDF=f

rem audio
set FDK=f
set NERO=f
set QAA=f
set ITS=f
set ACA=f
set AENC=f

call :file_check_sub
date /t>nul
echo %AEC%%AVS%%DSS%%FSS%%QTS%%MIF%%YDF%%X264%%A2A%%A2P%%DSF%%FFM%%JWP%%LIC%%LIN%%LSS%%MDP%%MKV%%MP4B%%MP4F%%PCRE%%REG%%SED%%SORT%%WSS%%AENC% | "%WINDIR%\system32\findstr.exe" "f">nul
if ERRORLEVEL 1 exit

if "%X264%"=="t" goto download_mode

if exist %X264_PATH% del %X264_PATH%

rem ################モード選択################
:download_mode
echo ^>^>%DOWNLOADER_ANNOUNCE%
echo;
rem if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_ANNOUNCE.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_ANNOUNCE.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_ANNOUNCE.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_ANNOUNCE.wav"
      )
    )
rem  )
rem )

if "%HARUMODE%"=="true" (
  set AUTO=y
  goto auto_main
) else if "%INSTALLONYMODE%"=="true" (
  set AUTO=y
  goto auto_main
)

:auto_mode
echo ^>^>%DOWNLOADER_QUESTION1%
echo ^>^>%DOWNLOADER_QUESTION2%
set /p AUTO=^>^>

:auto_main
if /i "%AUTO%"=="y" goto auto_mode_on
if /i "%AUTO%"=="n" goto auto_mode_off

echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto auto_mode


rem ################自動モード################
:auto_mode_on
if "%AVS%"=="f" (
    echo ^>^>Avisynth
    del /Q ..\Archives\Avisynth*.exe 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %AVS_PATH% -L %AVS_URL%
    echo;
)
for %%i in (%AVS_PATH%) do if %%~zi NEQ %AVS_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %AVS_PATH% -L %AVS_URL2%
    echo;
)
for %%i in (%AVS_PATH%) do if %%~zi NEQ %AVS_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %AVS_PATH% -L %AVS_URL3%
    echo;
)
if "%A2A%"=="f" (
    echo ^>^>avs2avi
    del /Q ..\Archives\avs2avi-*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %A2A_PATH% -L %A2A_URL%
    echo;
)
for %%i in (%A2A_PATH%) do if %%~zi NEQ %A2A_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %A2A_PATH% -L %A2A_URL2%
    echo;
)
if "%A2P%"=="f" (
    echo ^>^>avs2pipemod
    del /Q ..\Archives\avs2pipemod-*.7z 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %A2P_PATH% -L %A2P_URL2%
    echo;
)
for %%i in (%A2P_PATH%) do if %%~zi NEQ %A2P_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %A2P_PATH% -L %A2P_URL3%
    echo;
)
rem if "%A4X%"=="f" (
rem    echo ^>^>avs4x264mod
rem    del /Q ..\Archives\avs4x264mod-*.7z 1>nul 2>&1
rem    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %A4X_PATH% -L %A4X_URL%
rem    echo;
rem )
rem for %%i in (%A4X_PATH%) do if %%~zi NEQ %A4X_SIZE% (
rem    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %A4X_PATH% -L %A4X_URL2%
rem    echo;
rem )
if "%SORT%"=="f" (
    echo ^>^>coreutils
    del /Q ..\Archives\coreutils-*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %SORT_PATH% -L %SORT_URL%
    echo;
)
for %%i in (%SORT_PATH%) do if %%~zi NEQ %SORT_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %SORT_PATH% -L %SORT_URL2%
    echo;
)
rem if "%DIL%"=="f" (
rem     echo ^>^>DevIL
rem    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %DIL_PATH% -L %DIL_URL%
rem    echo;
rem )
if "%DSF%"=="f" (
    echo ^>^>DirectShow File Reader plugin for AviUtl
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %DSF_PATH% -L %DSF_URL%
    echo;
)
for %%i in (%DSF_PATH%) do if %%~zi NEQ %DSF_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %DSF_PATH% -L %DSF_URL2%
    echo;
)
if "%DSS%"=="f" (
    echo ^>^>DirectShowSource
    del /Q ..\Archives\DirectShowSource_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %DSS_PATH% -L %DSS_URL%
    echo;
)
for %%i in (%DSS_PATH%) do if %%~zi NEQ %DSS_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %DSS_PATH% -L %DSS_URL2%
    echo;
)
if "%FFM%"=="f" (
    echo ^>^>ffmpeg
    del /Q ..\Archives\ffmpeg-*.7z 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %FFM_PATH% -L %FFM_URL%
    echo;
)
for %%i in (%FFM_PATH%) do if %%~zi NEQ %FFM_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %FFM_PATH% -L %FFM_URL2%
    echo;
)
if "%FSS%"=="f" (
    echo ^>^>FFMpegSource
    del /Q ..\Archives\ffms-*.7z 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %FSS_PATH% -L %FSS_URL%
    echo;
)
for %%i in (%FSS_PATH%) do if %%~zi NEQ %FSS_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %FSS_PATH% -L %FSS_URL2%
    echo;
)
if "%JWP%"=="f" (
    echo ^>^>JWplayer
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %JWP_PATH% -L %JWP_URL%
    echo;
)
if "%LIC%"=="f" (
    echo ^>^>libiconv
    del /Q ..\Archives\libiconv-*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %LIC_PATH% -L %LIC_URL%
    echo;
)
for %%i in (%LIC_PATH%) do if %%~zi NEQ %LIC_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %LIC_PATH% -L %LIC_URL2%
    echo;
)
for %%i in (%LIC_PATH%) do if %%~zi NEQ %LIC_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %LIC_PATH% -L %LIC_URL3%
    echo;
)
if "%LIN%"=="f" (
    echo ^>^>libintl
    del /Q ..\Archives\libintl-*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %LIN_PATH% -L %LIN_URL%
    echo;
)
for %%i in (%LIN_PATH%) do if %%~zi NEQ %LIN_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %LIN_PATH% -L %LIN_URL2%
    echo;
)
if "%LSS%"=="f" (
    echo ^>^>L-SMASH source
    del /Q ..\Archives\L-SMASH_Works* 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %LSS_PATH% -L %LSS_URL%
    echo;
)
for %%i in (%LSS_PATH%) do if %%~zi NEQ %LSS_SIZE% (
   .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %LSS_PATH% -L %LSS_URL2%
   echo;
)
if "%MDP%"=="f" (
    echo ^>^>Minimal DirectShow Player
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MDP_PATH% -L %MDP_URL%
    echo;
)
for %%i in (%MDP_PATH%) do if %%~zi NEQ %MDP_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MDP_PATH% -L %MDP_URL2%
    echo;
)
if "%MIF%"=="f" (
    echo ^>^>MediaInfo
rem    del /Q ..\Archives\MediaInfo_CLI_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MIF_PATH% -L %MIF_URL%
    echo;
)
for %%i in (%MIF_PATH%) do if %%~zi NEQ %MIF_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MIF_PATH% -L %MIF_URL2%
    echo;
)
for %%i in (%MIF_PATH%) do if %%~zi NEQ %MIF_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MIF_PATH% -L %MIF_URL3%
    echo;
)
if "%MKV%"=="f" (
    echo ^>^>mkvtoolnix
    del /Q ..\Archives\mkvtoolnix_*.7z 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MKV_PATH% -L %MKV_URL%
    echo;
)
for %%i in (%MKV_PATH%) do if %%~zi NEQ %MKV_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MKV_PATH% -L %MKV_URL2%
    echo;
)
if "%MP4B%"=="f" (
    echo ^>^>mp4box
    del /Q ..\Archives\MP4Box_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MP4B_PATH% -L %MP4B_URL2%
    echo;
)
for %%i in (%MP4B_PATH%) do if %%~zi NEQ %MP4B_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MP4B_PATH% -L %MP4B_URL%
    echo;
)
if "%MP4F%"=="f" (
    echo ^>^>mp4fpsmod
    del /Q ..\Archives\mp4fpsmod_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MP4F_PATH% -L %MP4F_URL%
    echo;
)
for %%i in (%MP4F_PATH%) do if %%~zi NEQ %MP4F_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %MP4F_PATH% -L %MP4F_URL2%
    echo;
)
if "%PCRE%"=="f" (
    echo ^>^>pcre3
    del /Q ..\Archives\pcre-*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %PCRE_PATH% -L %PCRE_URL%
    echo;
)
for %%i in (%PCRE_PATH%) do if %%~zi NEQ %PCRE_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %PCRE_PATH% -L %PCRE_URL2%
    echo;
)
rem if not "%QAE%"=="t" (
rem     echo ^>^>qtaacenc
rem    del /Q ..\Archives\qtaacenc-*.zip 1>nul 2>&1
rem     .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %QAE_PATH% -L %QAE_URL%
rem     echo;
rem )
rem for %%i in (%QAE_PATH%) do if %%~zi NEQ %QAE_SIZE% (
rem      .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %QAE_PATH% -L %QAE_URL2%
rem    echo;
rem )
if "%QTS%"=="f" (
    echo ^>^>QTSource
    del /Q ..\Archives\QTSource_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %QTS_PATH% -L %QTS_URL%
    echo;
)
for %%i in (%QTS_PATH%) do if %%~zi NEQ %QTS_SIZE% (
      .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %QTS_PATH% -L %QTS_URL2%
    echo;
)
if "%REG%"=="f" (
    echo ^>^>regex
    del /Q ..\Archives\regex-*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %REG_PATH% -L %REG_URL%
    echo;
)
for %%i in (%REG_PATH%) do if %%~zi NEQ %REG_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %REG_PATH% -L %REG_URL2%
    echo;
)
if "%SED%"=="f" (
    echo ^>^>sed
    del /Q ..\Archives\sed-*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %SED_PATH% -L %SED_URL%
    echo;
)
for %%i in (%SED_PATH%) do if %%~zi NEQ %SED_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %SED_PATH% -L %SED_URL2%
    echo;
)
if "%WSS%"=="f" (
    echo ^>^>warpsharp
    del /Q ..\Archives\warpsharp_*.rar 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %WSS_PATH% -L %WSS_URL%
    echo;
)
for %%i in (%WSS_PATH%) do if %%~zi NEQ %WSS_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %WSS_PATH% -L %WSS_URL2%
    echo;
)
if "%YDF%"=="f" (
    echo ^>^>Yadif
    del /Q ..\Archives\yadif*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %YDF_PATH% -L %YDF_URL2%
    echo;
)
for %%i in (%YDF_PATH%) do if %%~zi NEQ %YDF_SIZE% (
        .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %YDF_PATH% -L %YDF_URL%
    echo;
)
if "%X264%"=="f" (
    echo ^>^>x264
    del /Q ..\Archives\x264* 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %X264_PATH% -L %X264_URL2%
    echo;
)
for %%i in (%X264_PATH%) do if %%~zi NEQ %X264_SIZE% (
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %X264_PATH% -L %X264_URL3%
    echo;
)
rem for %%i in (%X264_PATH%) do if %%~zi NEQ %X264_SIZE% (
rem    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %X264_PATH% -L %X264_URL1%
rem    echo;
rem )


rem Audio Encoder
:audio_encoder_select
if "%NERO%"=="t" goto check
if "%FDK%"=="t" goto check
if "%QAAC%"=="t" goto check

:audio_encoder_question
echo;
echo;
echo;
echo ^>^>%A_ENCODER_SELECT1%
echo   1: %A_ENCODER_SELECT2%
echo   2: %A_ENCODER_SELECT3%
echo   3: %A_ENCODER_SELECT4%
echo   4: %A_ENCODER_SELECT5%
echo;    
echo ^>^>%PAUSE_MESSAGE2%
set /p AAC_ENCODER=

if "%AAC_ENCODER%"=="1" (
  set AAC_ENCODERR=fdk
  goto fdk_install
) else if "%AAC_ENCODER%"=="2" (
  set AAC_ENCODER=qt
  goto qt_install
) else if "%AAC_ENCODER%"=="3" (
  set AAC_ENCODER=nero
  goto nero_install
) else if "%AAC_ENCODER%"=="4" (
  set AAC_ENCODER=ffaac
  set AENC=t
  goto check
) else if /i "%AAC_ENCODER%"=="qt" (
  goto qt_install
) else if /i "%AAC_ENCODER%"=="nero" (
  goto nero_install
) else if /i "%AAC_ENCODER%"=="fdk" (
  goto fdk_install
) else if /i "%AAC_ENCODER%"=="ffaac" (
  goto check
) else (
  echo;
  echo ^>^>%RETURN_MESSAGE1%
  if not "%HARUMODE%"=="true" (
    if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
        )
    )
  )
  echo;
  set AAC_ENCODER=
  goto audio_encoder_question
)


:fdk_install
if exist fdkaac.exe goto check
if "%FDKB%"=="f" (
    echo ^>^>fdkaac builder
    del /Q ..\Archives\fdkaac_builder_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %FDKB_PATH% -L %FDKB_URL2%
    echo;
)

if not exist TEMP mkdir TEMP
.\7z.exe x -y %FDKB_PATH% -oTEMP
cd TEMP\fdkaac_builder
./builder.bat
if not exist fdkaac.exe (
  echo ^>^>%FDKAAC_BUILD_FAIL1%
  echo ^>^>%FDKAAC_BUILD_FAIL2%
  echo ^>^>%FDKAAC_BUILD_FAIL3%
  goto audio_encoder_question 
)
cp /y fdkaac.exe ../
cd ..\..
goto check
rem rmdir in tool_installer.bat L35

:qt_install
call :ITS_CHECK
if "%ITS%"=="t" goto qaac_dl

echo ^>^>%COREAUDIO_INSTALL1%
echo ^>^>%COREAUDIO_INSTALL2%
set /p ITUNES_DL_OPEN=

if /i not "%ITUNES_DL_OPEN%"=="y" goto preaac_dl

pause>nul
echo;
start rundll32 url.dll,FileProtocolHandler "http://www.apple.com/jp/itunes/download/"

echo %COREAUDIO_INSTALL3%
pause>nul
echo;

:preaac_dl
call :ITS_CHECK
if "%ITS%"=="t" goto qaac_dl
echo ^>^>%COREAUDIO_INSTALL4%
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
echo;

if "%PREA%"=="f" (
    echo ^>^>preaac
    del /Q ..\Archives\preaac_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %PREA%_PATH% -L %PREA_URL2%
    echo;
)
for %%i in (%PREA_PATH%) do if %%~zi NEQ %PREA_SIZE% (
      .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %PREA_PATH% -L %PREA_URL3%
    echo;
)

.\7z.exe x -y %PREA_PATH%
cd preaac
./builder.bat
if not exist qaac\CoreAudioToolbox.dll (
  echo ^>^>%PREAAC_SETUP_FAIL1%
  echo ^>^>%PREAAC_SETUP_FAIL2%
  echo ^>^>%PREAAC_SETUP_FAIL3%
  goto audio_encoder_question 
)

if exist qaac\qaac.exe (
  set QAA=t
  goto check
)

:qaac_dl
if "%QAA%"=="f" (
    echo ^>^>qaac
    del /Q ..\Archives\qaac_*.zip 1>nul 2>&1
    .\curl.exe -k %PROXY% --connect-timeout 5 -f -o %QAA_PATH% -L %QAA_URL%
    echo;
)

goto check

:nero_install
if "%NERO%"=="t" (
  set AENC=t
  goto check
)
if exist neroAacEnc.exe (
  set NERO=t
  set AENC=t
  goto check
)
for %%i in (%NERO_PATH%) do if %%~zi EQU %NERO_SIZE% (
  set NERO=t
  set AENC=t
  goto check
)
echo;
echo;
echo;
echo ^>^>%NERO_INSTALL1%
echo ^>^>%NERO_INSTALL2%
set /p NERO_CHECK=^>^>

if /i "%NERO_CHECK%"=="n" goto audio_encoder_select
if exist neroAacEnc.exe (
  set NERO=t
  set AENC=t
  goto check
)
for %%i in (%NERO_PATH%) do if %%~zi EQU %NERO_SIZE% (
  set NERO=t
  set AENC=t
  goto check
)
echo ^>^>%NERO_INSTALL3%
goto nero_install

:nero_dl
if "%NERO%"=="t" goto check
echo;
echo;
echo;
echo ^>^>%NERO_LICENSE1%
echo ^>^>%NERO_LICENSE2%
echo ^>^>%NERO_LICENSE3%
echo;
echo ^>^>%PAUSE_MESSAGE2%
rem if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\NERO_LICENSE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\NERO_LICENSE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\NERO_LICENSE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\NERO_LICENSE1.wav"
      )
    )
rem  )
rem )
pause>nul
echo;
rem start rundll32 url.dll,FileProtocolHandler "http://www.nero.com/enu/company/about-nero/nero-aac-codec.php"
start rundll32 url.dll,FileProtocolHandler "..\Docs\Licenses\Nero_AAC_Encoder_license.txt"

:agree
echo ^>^>%NERO_QUESTION%
set /p AGREE=^>^>

if /i "%AGREE%"=="y" goto agree_main
if /i "%AGREE%"=="n" exit

echo;
echo ^>^>%RETURN_MESSAGE1%
echo;
goto agree

:agree_main
echo ^>^>neroAacEnc
.\curl.exe %PROXY% --connect-timeout 5 -f -o %NERO_PATH% -L %NERO_URL%
echo;

goto check


rem ################手動モード################
:auto_mode_off
echo;
echo ^>^>%DOWNLOADER_MANUAL2%

set HTML_FILE=.\DL.html

(
  echo ^<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"^>
  echo ^<html lang="ja"^>
  echo ^<head^>
  echo ^<meta http-equiv="Content-type" content="text/html; charset=Shift_JIS"^>
  echo ^<meta http-equiv="Pragma" content="no-cache"^>
  echo ^<meta http-equiv="Cache-Control" content="no-cache"^>
  echo ^<meta http-equiv="Expires" content="0"^>
  echo ^<title^>Tool Download List</title^>
  echo ^<meta http-equiv="Content-Style-Type" content="text/css"^>
  echo ^</head^>
  echo;
  echo ^<body bgcolor="#ffeaea" text="#000000" link="#0000ff" vlink="#800080" alink="#ff0000"^>
  echo ^<center^>^<h1^>%TDENC_NAME% %C_VERSION%^</h1^>^</center^>
  echo ^<h3^>%DOWNLOADER_MANUAL1%^</h3^>
  echo ^<ul^>
  if "%AVS%"=="f" echo ^<li^>^<a href=%AVS_URL% rel="nofollow" target="_blank"^>Avisynth^</a^> [^<a href=%AVS_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%A2A%"=="f" echo ^<li^>^<a href=%A2A_URL% rel="nofollow" target="_blank"^>avs2avi^</a^> [^<a href=%A2A_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%A2P%"=="f" echo ^<li^>^<a href=%A2P_URL% rel="nofollow" target="_blank"^>avs2pipemod^</a^> [^<a href=%A2P_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
rem  if "%A4X%"=="f" echo ^<li^>^<a href=%A4X_URL% rel="nofollow" target="_blank"^>avs4x264mod^</a^> [^<a href=%A4X_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
rem  echo;
  if "%SORT%"=="f" echo ^<li^>^<a href=%SORT_URL% rel="nofollow" target="_blank"^>coreutils^</a^> [^<a href=%SORT_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
rem  if "%DIL%"=="f" echo ^<li^>^<a href=%DIL_URL% rel="nofollow" target="_blank"^>DevIL^</a^>^</li^>
rem  echo;
  if "%DSF%"=="f" echo ^<li^>^<a href=%DSF_URL% rel="nofollow" target="_blank"^>DirectShow File Reader^</a^> [^<a href=%DSF_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%DSS%"=="f" echo ^<li^>^<a href=%DSS_URL% rel="nofollow" target="_blank"^>DirectShowSource^</a^> [^<a href=%DSS_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%FFM%"=="f" echo ^<li^>^<a href=%FFM_URL% rel="nofollow" target="_blank"^>ffmpeg^</a^> [^<a href=%FFM_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%FSS%"=="f" echo ^<li^>^<a href=%FSS_URL% rel="nofollow" target="_blank"^>FFmpegSource^</a^> [^<a href=%FSS_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%JWP%"=="f" echo ^<li^>^<a href=%JWP_URL% rel="nofollow" target="_blank"^>JWplayer^</a^>^</li^>
  echo;
  if "%LIC%"=="f" echo ^<li^>^<a href=%LIC_URL% rel="nofollow" target="_blank"^>libiconv^</a^> [^<a href=%LIC_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%LIN%"=="f" echo ^<li^>^<a href=%LIN_URL% rel="nofollow" target="_blank"^>libintl^</a^>  [^<a href=%LIN_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%LSS%"=="f" echo ^<li^>^<a href=%LSS_URL% rel="nofollow" target="_blank"^>L-SMASH source^</a^> [^<a href=%LSS_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%MDP%"=="f" echo ^<li^>^<a href=%MDP_URL% rel="nofollow" target="_blank"^>Minimal DirectShow Player^</a^> [^<a href=%MDP_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%MIF%"=="f" echo ^<li^>^<a href=%MIF_URL% rel="nofollow" target="_blank"^>MediaInfo^</a^> [^<a href=%MIF_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%MKV%"=="f" echo ^<li^>^<a href=%MKV_URL% rel="nofollow" target="_blank"^>mkvtoolnix^</a^> [^<a href=%MKV_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%MP4B%"=="f" echo ^<li^>^<a href=%MP4B_URL% rel="nofollow" target="_blank"^>MP4Box^</a^> [^<a href=%MP4B_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%MP4F%"=="f" echo ^<li^>^<a href=%MP4F_URL% rel="nofollow" target="_blank"^>mp4fpsmod^</a^> [^<a href=%MP4F_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%NERO%"=="f" echo ^<li^>^<a href=%NERO_URL2% rel="nofollow" target="_blank"^>NeroDigitalAudio^</a^>^</li^>
  echo;
  if "%PCRE%"=="f" echo ^<li^>^<a href=%PCRE_URL% rel="nofollow" target="_blank"^>pcre3^</a^> [^<a href=%PCRE_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%QAA%"=="f" echo ^<li^>^<a href=%QAA_URL% rel="nofollow" target="_blank"^>qaac^</a^> [^<a href=%QAA_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%QTS%"=="f" echo ^<li^>^<a href=%QTS_URL% rel="nofollow" target="_blank"^>QTSource^</a^> [^<a href=%QTS_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%REG%"=="f" echo ^<li^>^<a href=%REG_URL% rel="nofollow" target="_blank"^>regex^</a^> [^<a href=%REG_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%SED%"=="f" echo ^<li^>^<a href=%SED_URL% rel="nofollow" target="_blank"^>sed^</a^> [^<a href=%SED_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%WSS%"=="f" echo ^<li^>^<a href=%WSS_URL% rel="nofollow" target="_blank"^>yadif^</a^> [^<a href=%WSS_URL2% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%YDF%"=="f" echo ^<li^>^<a href=%YDF_URL2% rel="nofollow" target="_blank"^>yadif^</a^> [^<a href=%YDF_URL% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  if "%X264%"=="f" echo ^<li^>^<a href=%X264_URL2% rel="nofollow" target="_blank"^>x264^</a^> [^<a href=%X264_URL3% rel="nofollow" target="_blank"^>mirror^</a^>]^</li^>
  echo;
  echo ^</ul^>
  echo ^</body^>
  echo ^</html^>
)> %HTML_FILE%

start rundll32.exe url,FileProtocolHandler "%HTML_FILE%"
pause>nul

rem ################落とせたかどうかをチェック################
:check
call :file_check_sub
date /t>nul
echo %AVS%%DSS%%FSS%%QTS%%MIF%%YDF%%X264%%A2A%%A2P%%DSF%%FFM%%JWP%%LIC%%LIN%%LSS%%MDP%%MKV%%MP4B%%MP4F%%PCRE%%REG%%SED%%SORT%%WSS%%AENC% | "%WINDIR%\system32\findstr.exe" "f">nul
if not ERRORLEVEL 1 goto dl_fail

rem ################成功################
echo;
echo ^>^>%DOWNLOADER_END%
echo;
rem if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_END.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_END.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_END.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DOWNLOADER_END.wav"
      )
    )
rem  )
rem )
if not "%HARUMODE%"=="true" (
  if not "%INSTALLONYMODE%"=="true" (
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
  )
)
exit

rem ################失敗################
:dl_fail
set DL_STATUS=fail
echo;
echo ^>^>%DOWNLOADER_ERROR1%
echo ^>^>%DOWNLOADER_ERROR2%
echo;
if "%A2A%"=="f" echo avs2avi
if "%A2P%"=="f" echo avs2pipemod
rem if "%A4X%"=="f" echo avs4x264mod
if "%AVS%"=="f" echo Avisynth
if "%SORT%"=="f" echo coreutils
rem if "%DIL%"=="f" echo DevIL
if "%DSF%"=="f" echo DirectShow File Reader
if "%DSS%"=="f" echo DirectShowSource
if "%FFM%"=="f" echo ffmpeg
if "%FSS%"=="f" echo FFmpegSource
if "%JWP%"=="f" echo JWplayer
if "%LIC%"=="f" echo libiconv
if "%LIN%"=="f" echo libintl
if "%LSS%"=="f" echo L-SMASH source
if "%MDP%"=="f" echo Minimal DirectShow Player
if "%MIF%"=="f" echo MediaInfo
if "%MKV%"=="f" echo mkvtoolnix
if "%MP4B%"=="f" echo MP4Box
if "%MP4F%"=="f" echo mp4fpsmod
if "%NERO%"=="f" echo NeroDigitalAudio
if "%PCRE%"=="f" echo pcre3
if "%QAA%"=="f" echo qaac
rem if "%QAE%"=="f" echo qtaacenc
if "%QTS%"=="f" echo QTSource
if "%REG%"=="f" echo regex
if "%SED%"=="f" echo sed
if "%WSS%"=="f" echo warpsharp
if "%YDF%"=="f" echo yadif
if "%X264%"=="f" echo x264
set DL_FAIL=y%DL_FAIL%
echo;
echo;
echo ^>^>%DOWNLOADER_ERROR3%
echo ^>^>%DOWNLOADER_ERROR4%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
if "%DL_FAIL%"=="yy" goto auto_mode_off
echo ^>^>%DOWNLOADER_QUESTION3%
echo ^>^>%DOWNLOADER_QUESTION2%
set /p AUTO=^>^>
goto auto_main
exit

rem ################ファイルチェックのサブルーチン################
:file_check_sub
for %%i in (%AVS_PATH%) do if %%~zi EQU %AVS_SIZE% set AVS=t
for %%i in (%A2A_PATH%) do if %%~zi EQU %A2A_SIZE% set A2A=t
for %%i in (%A2P_PATH%) do if %%~zi EQU %A2P_SIZE% set A2P=t
rem for %%i in (%A4X_PATH%) do if %%~zi EQU %A4X_SIZE% set A4X=t
rem for %%i in (%DIL_PATH%) do if %%~zi EQU %DIL_SIZE% set DIL=t
for %%i in (%DSF_PATH%) do if %%~zi EQU %DSF_SIZE% set DSF=t
for %%i in (%DSS_PATH%) do if %%~zi EQU %DSS_SIZE% set DSS=t
for %%i in (%FFM_PATH%) do if %%~zi EQU %FFM_SIZE% set FFM=t
for %%i in (%FSS_PATH%) do if %%~zi EQU %FSS_SIZE% set FSS=t
rem for %%i in (%JWP_PATH%) do if %%~zi EQU %JWP_SIZE% set JWP=t
if exist %JWP_PATH% set JWP=t
for %%i in (%LIC_PATH%) do if %%~zi EQU %LIC_SIZE% set LIC=t
for %%i in (%LIN_PATH%) do if %%~zi EQU %LIN_SIZE% set LIN=t
for %%i in (%LSS_PATH%) do if %%~zi EQU %LSS_SIZE% set LSS=t
for %%i in (%MDP_PATH%) do if %%~zi EQU %MDP_SIZE% set MDP=t
for %%i in (%MIF_PATH%) do if %%~zi EQU %MIF_SIZE% set MIF=t
for %%i in (%MIFN_PATH%) do if %%~zi EQU %MIFN_SIZE% set MIFN=t
if "%MIFN%"=="t" set MIF=t
for %%i in (%MKV_PATH%) do if %%~zi EQU %MKV_SIZE% set MKV=t
for %%i in (%MP4B_PATH%) do if %%~zi EQU %MP4B_SIZE% set MP4B=t
for %%i in (%MP4F_PATH%) do if %%~zi EQU %MP4F_SIZE% set MP4F=t
for %%i in (%PCRE_PATH%) do if %%~zi EQU %PCRE_SIZE% set PCRE=t
for %%i in (%REG_PATH%) do if %%~zi EQU %REG_SIZE% set REG=t
rem for %%i in (%QAE_PATH%) do if %%~zi EQU %QAE_SIZE% set QAE=t
for %%i in (%QTS_PATH%) do if %%~zi EQU %QTS_SIZE% set QTS=t
for %%i in (%SED_PATH%) do if %%~zi EQU %SED_SIZE% set SED=t
for %%i in (%SORT_PATH%) do if %%~zi EQU %SORT_SIZE% set SORT=t
for %%i in (%WSS_PATH%) do if %%~zi EQU %WSS_SIZE% set WSS=t
for %%i in (%YDF_PATH%) do if %%~zi EQU %YDF_SIZE% set YDF=t
for %%i in (%X264_PATH%) do if %%~zi EQU %X264_SIZE% set X264=t

rem audio encoder
for %%i in (%NERO_PATH%) do if %%~zi EQU %NERO_SIZE% set NERO=t
if exist neroaacenc.exe set NERO=t
for %%i in (%FDKB_PATH%) do if %%~zi EQU %FDKB_SIZE% set FDKB=t
if exist fdkaac.exe set FDK=t
call :COREAUDIO_CHECK
for %%i in (%PREA_PATH%) do if %%~zi EQU %PREA_SIZE% set PREA=t
for %%i in (%QAA_PATH%) do if %%~zi EQU %QAA_SIZE% set QAA=t

if "%NERO%"=="t" (
  set AENC=t
) else if "%FDK%"=="t" (
  set AENC=t
) else if "%COREAUDIO%"=="true" (
  if "%QAA%"=="t" set AENC=t
)

if exist %X264_PATH% (
  if exist x264.exe del x264.exe
  if exist ..\Archives\x264.exe del ..\Archives\x264.exe
)
exit /b

:COREAUDIO_CHECK
if exist "%ProgramFiles(x86)%\Common Files\Apple\Apple Application Support\CoreAudioToolbox.dll" (
   set COREAUDIO=true
) else if exist "%ProgramFiles%\Common Files\Apple\Apple Application Support\CoreAudioToolbox.dll" (
   set COREAUDIO=true
) else if exist "qaac\CoreAudioToolbox.dll" (
   set COREAUDIO=true
) else set COREAUDIO=false
exit /b