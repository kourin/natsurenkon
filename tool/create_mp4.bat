rem ################MP4作成################
rem if "%HARUMODE%"=="false" (
rem  if "%BEGINNER%"=="false" goto main
rem )

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i
set TEMP_264_FILESIZE_MB1=%TEMP_264_FILESIZE:~0,-6%
set TEMP_264_FILESIZE_MB2=%TEMP_264_FILESIZE:~-6%
if not defined TEMP_264_FILESIZE_MB1 set TEMP_264_FILESIZE_MB1=0
if %TEMP_264_FILESIZE_MB1% LEQ 2147 (
	set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE%*8/%TOTAL_TIME_SEC%/1000 2>nul
	if /i "%AUTOECO%"=="n" (
		goto main
	) else (
		goto autoeco_check
	)

)
.\MediaInfo.exe --Inform=Video;%%BitRate%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i /1000 1>nul 2>&1
goto main

:autoeco_check
set /a EB_BITRATE = %E_MAX_BITRATE% - %TEMP_264_BITRATE% - 5

if %EB_BITRATE% LSS 240 goto main
if %TEMP_M4A_BITRATE% LEQ %EB_BITRATE% goto main

set /a A_BITRATE=%EB_BITRATE%

if %EB_BITRATE% GTR 320 set /a A_BITRATE=320

set /a T_BITRATE2=%A_BITRATE% + %TEMP_264_BITRATE%

if /i "%ACTYPE%"=="y" (
  if %T_BITRATE2% GTR %P_TEMP_BITRATE% goto main
) else if /i "%ACTYPE%"=="n" (
  if %T_BITRATE2% GTR %I_TEMP_BITRATE% goto main
)

echo;
echo ^>^>%BITRATE_OVER4%
rem if not "%HARUMODE%"=="true" (
  if /i  "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\BITRATE_OVER4.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\BITRATE_OVER4.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\BITRATE_OVER4.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\BITRATE_OVER4.wav"
    )
  )
rem )

if "%SKIP_A_ENC%"=="false" goto m4a_re-enc
set SKIP_A_ENC=false

set A_DECODER=ffmpegexe
.\ffmpeg.exe -y -i %INPUT_FILE_PATH% -vn -c:a pcm_s16le %TEMP_WAV%
for %%i in (%TEMP_WAV%) do if %%~zi EQU 0 goto main

rem 出力した音声の確認
.\MediaInfo.exe --Inform=Audio;%%Duration%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set A_TOTAL_TIME=%%i

.\MediaInfo.exe --Inform=Audio;%%Duration%% --LogFile=%TEMP_INFO% %TEMP_WAV%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set B_TOTAL_TIME=%%i

if not defined A_TOTAL_TIME goto main
if not defined B_TOTAL_TIME goto main

set /a B_TOTAL_TIME_MAX=%A_TOTAL_TIME% /2*3
set /a B_TOTAL_TIME_MIN=%A_TOTAL_TIME% /5*3
if %B_TOTAL_TIME% GTR %B_TOTAL_TIME_MAX% goto main
if %B_TOTAL_TIME% LSS %B_TOTAL_TIME_MIN% goto main

set TEMP_M4A=%TEMP_DIR%\audio.m4a

:m4a_re-enc
echo ^>^>%M4A_ENC_ANNOUNCE%
echo;
if /i "%AAC_ENCODER%"=="nero" (
    .\neroAacEnc.exe %AAC% -2pass -br %A_BITRATE%000 -if %TEMP_WAV% -of %TEMP_M4A%
) else if /i "%AAC%"=="-lc" (
rem    .\qtaacenc.exe --highest --cvbr %A_BITRATE% %FINAL_WAV% %TEMP_M4A%
    %QAAC% --cvbr %A_BITRATE% -o %TEMP_M4A% %TEMP_WAV%
) else (
rem    .\qtaacenc.exe --he --highest --cvbr %A_BITRATE% %FINAL_WAV% %TEMP_M4A%
    %QAAC% --he --cvbr %A_BITRATE% -o %TEMP_M4A% %TEMP_WAV%
)

:main
if "%SIZEOK%"=="y" goto make_final_mp4

for %%i in (%TEMP_264%) do if %%~zi EQU 0 (
    echo ^>^>%MP4_ERROR1%
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.wav"
        )
      )
rem    )

    if %V_BITRATE% GTR 200 (
       echo ^>^>%MP4_ERROR2%
    ) else (
       echo ^>^>%MP4_ERROR3%
       echo ^>^>%MP4_ERROR4%
    )
    echo;
    echo ^>^>%PAUSE_MESSAGE1%
    pause>nul
    call .\quit.bat
)

echo ^>^>%MP4_ANNOUNCE%
rem if not "%HARUMODE%"=="true" (
rem   if /i  "%VOICE%"=="true" (
rem     if exist "..\Extra\Voice\%VOICE_DIR%\MP4_ANNOUNCE.mp3" (
rem       %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_ANNOUNCE.mp3"
rem     ) else if exist "..\Extra\Voice\%VOICE_DIR%\MP4_ANNOUNCE.wav" (
rem       %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_ANNOUNCE.wav"
rem     )
rem   )
rem )
echo;
if /i not "%PRETYPE%"=="s" (
    if not "%X264_VFR_ENC%"=="true" (
        set MP4_FPS=-fps %FPS%
    )
)

if "%SKIP_A_ENC%"=="true" set TEMP_M4A=%INPUT_AUDIO%

if not exist %TEMP_MP4% (
  .\MP4Box.exe -brand mp42 %MP4_FPS% -add %TEMP_264%#video:delay=noct -add %TEMP_M4A%#audio -new %TEMP_MP4%
)

:make_final_mp4
if exist "%MP4_DIR%\%FINAL_MP4%" move /y "%MP4_DIR%\%FINAL_MP4%" %MP4_DIR%\old.mp4>nul
move /y %TEMP_MP4% "%MP4_DIR%\%FINAL_MP4%">nul

if not exist "%MP4_DIR%\%FINAL_MP4%" (
    echo ^>^>%MP4_ERROR1%
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_ERROR1.wav"
        )
      )
rem    )
    echo ^>^>%MP4_ERROR2%
    echo;
    echo ^>^>%PAUSE_MESSAGE1%
    pause>nul
    call .\quit.bat
)

echo;
echo ^>^>%MP4_SUCCESS%
echo;
rem if not "%HARUMODE%"=="true" (
  if /i  "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\MP4_SUCCESS.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_SUCCESS.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\MP4_SUCCESS.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MP4_SUCCESS.wav"
    )
  )
rem )


rem ################MP4の情報を表示################
echo %HORIZON%
echo   MP4 INFO
echo %HORIZON%

rem ファイル名
echo File Name     : %FINAL_MP4%

rem 容量
.\MediaInfo.exe --Inform=General;%%FileSize/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo File Size     : %%i
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do set MP4FILESIZE=%%i

rem 再生時間
.\MediaInfo.exe --Inform=General;%%Duration%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do set MP4_TIME=%%i

rem 総ビットレート
if %TEMP_264_FILESIZE_MB1% LEQ 2147 goto normal_bitrate

rem 2GB越えの時は、Mediainfo任せ
.\MediaInfo.exe --Inform=General;%%BitRate%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a MP4BITRATE=%%i /1000 1>nul 2>&1
goto bitrate_fin

:normal_bitrate
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo;
    echo _file_size_MB = String^(Ceil^(%MP4FILESIZE% / 1024 / 1024 ^)^) 
    echo _effective_bitrate = String^(Floor^(Float^(%MP4FILESIZE%^) * 8 / Floor^(%MP4_TIME% / 1000^) / 1000 ^)^)
    echo WriteFileStart^("file_size_MB.txt","_file_size_MB",append = false^)
    echo WriteFileStart^("effective_bitrate.txt","_effective_bitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS4%

.\avs2pipemod.exe -info %INFO_AVS4% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\file_size_MB.txt) do set /a MP4FILESIZE_MB=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\effective_bitrate.txt) do set /a MP4BITRATE=%%i>nul

:bitrate_fin
echo Total Bitrate : %MP4BITRATE% kbps

rem FPS
.\MediaInfo.exe --Inform=Video;%%FrameRate/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo FPS           : %%i

rem 解像度
.\MediaInfo.exe --Inform=Video;%%Width%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a MP4WIDTH=%%i
echo Width         : %MP4WIDTH% pixel
.\MediaInfo.exe --Inform=Video;%%Height%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a MP4HEIGHT=%%i
echo Height        : %MP4HEIGHT% pixel

rem アスペクト比
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Aspect Ratio  : %%i

echo %HORIZON%
echo;

(
   echo;
   echo #################### MP4 Info ####################
   echo Width:Height  : %MP4WIDTH% x %MP4HEIGHT%
   echo FPS           : %FPS% ^(%FPS_MODE%^)
   echo Play Time     : %MP4_TIME% ms
   echo Total Bitrate : %MP4BITRATE% kbps
   echo Movie Bitrate : %TEMP_264_BITRATE% kbps
   echo Audio Bitrate : %TEMP_M4A_BITRATE% kbps
   echo MP4 file size : %MP4FILESIZE% byte
)>> %ERROR_REPORT%

rem ################容量チェック################
if /i "%PRETYPE%"=="y" goto last
if /i "%PRETYPE%"=="t" (
	if %TEMP_264_FILESIZE_MB1% GTR 2147 goto last
)

rem if %MAX_FILESIZE% LEQ 104857600 set /a MAX_FILESIZE=104857600

if /i "%ACTYPE%"=="y" goto mp4_check_premium
if "%CRFMODE%"=="y" goto mp4_check_crf
if %MP4FILESIZE% LEQ 41943040 (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%SIZE_SUCCESS2%
    echo;
    goto last
) else (
    echo ^>^>%SIZE_ERROR1%
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.wav"
        )
      )
rem    )
    echo;
    goto last
)

:mp4_check_premium
if %MP4FILESIZE% LEQ %MAX_FILESIZE% (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%SIZE_SUCCESS2%
    echo;
    if "%BEGINNER%"=="true" (
       if "%CHANGE_AUTO_BR_LIMIT%"=="true" (
          if %AUTO_ENC_LIMIT% NEQ 2500 (
               echo %AUTO_BR_LIMIT_CHANGE1%
             if %MAX_BR_RECORD% LEQ 2000 (
               echo %AUTO_BR_LIMIT_CHANGE2%
             ) else (
               echo %AUTO_BR_LIMIT_CHANGE3%
             )
          )
       )
    )
    goto last
) else (
    echo ^>^>%SIZE_ERROR1%
    echo;
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.wav"
        )
      )
rem    )
    goto last
)

:mp4_check_crf
if %MP4FILESIZE% LEQ 41943040 (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%CONFIRM_ACCOUNT2%, %CONFIRM_ACCOUNT3%: %SIZE_SUCCESS2%
    echo;
) else if %MP4FILESIZE% LEQ %MAX_FILESIZE% (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%CONFIRM_ACCOUNT2%: %SIZE_SUCCESS2%
    echo ^>^>%CONFIRM_ACCOUNT3%: %SIZE_ERROR1%
    echo;
) else (
    echo ^>^>%SIZE_ERROR1%
    echo ^>^>%SIZE_ERROR2%
    echo;
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SIZE_ERROR1.wav"
        )
      )
rem    )
)

if %MP4BITRATE% GTR %I_MAX_BITRATE% echo ^>^>%CONFIRM_ACCOUNT3%: %RETURN_MESSAGE3%
if %MP4WIDTH% GTR %I_MAX_WIDTH% (
   echo ^>^>%RETURN_MESSAGE10%
)  else if %MP4HEIGHT% GTR %I_MAX_HEIGHT% (
   echo ^>^>%RETURN_MESSAGE10%
)
echo;

rem ################後処理################
:last
if %MP4BITRATE% LEQ %E_MAX_BITRATE% (
   echo ^>^>%ECONOMY_SUCCESS%
   echo;
) else if /i "%ENCTYPE%"=="y" (
   echo ^>^>%ECONOMY_ERROR%
   echo;
)

if /i "%KEEPWAV%"=="y" (
  move /y %TEMP_WAV% "%MP4_DIR%\%FINAL_FILE%.wav" 1>nul 2>&1
rem  move /y %TEMP_AVI2% "%MP4_DIR%\%FINAL_FILE%.avi" 1>nul 2>&1
rem  copy /y how_to_retry_template.txt %MP4_DIR%\how_to_retry.txt 1>nul 2>&1
)

if /i not "%KEEPWAV%"=="y" goto closing

rem if exist %MP4_DIR%\%FINAL_FILE%.avi (
rem  (echo "%TDE_DIR%\%MP4_DIR%\%FINAL_FILE%.avi")>> %MP4_DIR%\how_to_retry.txt
rem ) else (
rem  (echo %ORIGINAL_VIDEO%)>> %MP4_DIR%\how_to_retry.txt
rem )

rem if exist %MP4_DIR%\%FINAL_FILE%.wav (
rem   (echo "%TDE_DIR%\%MP4_DIR%\%FINAL_FILE%.wav")>> %MP4_DIR%\how_to_retry.txt
rem ) else (
rem   (echo %ORIGINAL_AUDIO%)>> %MP4_DIR%\how_to_retry.txt
rem )

rem if not "%ENC_MODE%"=="SEQUENCE" (
rem  start %MP4_DIR%\how_to_retry.txt
rem )

:closing
if not "%KEEP_ERROR_REPORT%"=="true" (
  if not "%WAV_FAIL%"=="y" (
    if exist %ERROR_REPORT% del /f %ERROR_REPORT% 1>nul 2>&1
  )
)
echo ^>^>%DERE_MESSAGE1%
echo;
echo ^>^>%DERE_MESSAGE2%
echo;
rem if not "%HARUMODE%"=="true" (
  if /i  "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\DERE_MESSAGE1.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DERE_MESSAGE1.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\DERE_MESSAGE1.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DERE_MESSAGE1.wav"
    )
  )
rem )
