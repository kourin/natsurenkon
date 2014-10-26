rem ################変数設定################
set INFO_AVS1=%TEMP_DIR%\information1.avs
set INFO_AVS2=%TEMP_DIR%\information2.avs
set ENC_MODE=CATENC
set AUTOBITRATEOFF=y
set DECODER=avi

rem ################動画情報取得################
echo;
echo ^>^>%ANALYZE_ANNOUNCE%
echo;
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.wav"
  )
)

:fps_main
if defined DEFAULT_FPS (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
    set CONVERT_FPS=-r %DEFAULT_FPS%
)


rem 再生時間取得
(
    echo AVISource^(%INPUT_FILE_PATH%^)
    echo;
    echo _time = String^(Ceil^(framecount^(^) / framerate^(^)^)^)
    echo _fps = String^(framerate^(^)^)
    echo _isyv12 = IsYV12^(^)
    echo _isrgb = IsRGB^(^)
    echo _keyint = String^(Round^(framerate^(^)^)^)
    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo _frames = Framecount^(^)
    echo _in_width = String^(Ceil(width^(^)^)^)
    echo _in_height = String^(Ceil(height^(^)^)^)
    echo _in_aratio = String^(Ceil(height^(^) / width^(^) * 10000 ^)^)
    echo _hasaudio = HasAudio^(^)
    echo _audiorate = String^(Audiorate^(^)^)
    echo _audiochannels = String^(Audiochannels^(^)^)
    echo;
    echo WriteFileStart^("time.txt","_time",append = false^)
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("frames.txt","_frames",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_height.txt","_in_height",append = false^)
    echo WriteFileStart^("in_aratio.txt","_in_aratio",append = false^)
    echo WriteFileStart^("hasaudio.txt","_hasaudio",append = false^)
    echo WriteFileStart^("audiochannels.txt","_audiochannels",append = false^)
    echo WriteFileStart^("audiorate.txt","_audiorate",append = false^)
    echo Trim^(0,-1^)
    echo;
    echo return last
)> %INFO_AVS1%

.\avs2pipemod.exe -info %INFO_AVS1% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\time.txt) do set /a TOTAL_TIME=%%i * 1000
if not defined TOTAL_TIME (
    echo ^>^>%ANALYZE_ERROR1%
    echo;
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav"
      )
    )
    call .\quit.bat
)
echo PlayTime       : %TOTAL_TIME%ms

for /f "delims=" %%i in (%TEMP_DIR%\yv12.txt) do set YV12=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\rgb.txt) do set RGB=%%i>nul

echo Format         : AVS^(Avisynth Script^)

for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set INPUT_FPS=%%i

if not defined DEFAULT_FPS (
    set CHANGE_FPS=false
    set FPS=%INPUT_FPS%
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
)

for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=10*%%i

echo FPS            : %FPS%fps^(CFR^)

for /f "delims=" %%i in (%TEMP_DIR%\frames.txt) do set FRAMES=%%i

for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set /a IN_WIDTH=%%i
echo Width          : %IN_WIDTH%pixels
set /a IN_WIDTH_MOD=%IN_WIDTH%

for /f "delims=" %%i in (%TEMP_DIR%\in_height.txt) do set /a IN_HEIGHT=%%i
echo Height         : %IN_HEIGHT%pixels

for /f "delims=" %%i in (%TEMP_DIR%\in_aratio.txt) do set /a IN_ARATIO=%%i

"%WINDIR%\system32\findstr.exe" /i "false" "%TEMP_DIR%\hasaudio.txt">nul
if not ERRORLEVEL 1 (
  set SILENT=true
) else (
  set SILENT=false
)

for /f "delims=" %%i in (%TEMP_DIR%\audiochannels.txt) do set AUDIO_CHANNELS=%%i
for /f "delims=" %%i in (%TEMP_DIR%\audiorate.txt) do set /a SAMPLERATE=%%i

.\MediaInfo.exe --Inform=Audio;%%BitRate%% --LogFile=%TEMP_INFO% "%CATAVI1%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a INPUT_A_BITRATE=%%i /1000 1>nul 2>&1

if defined CAT_WAV_PATH (
   .\MediaInfo.exe --Inform=Audio;%%BitRate%% --LogFile=%TEMP_INFO% "%INPUT_WAV1%">nul
   for /f "delims=" %%i in (%TEMP_INFO%) do set /a INPUT_A_BITRATE=%%i /1000 1>nul 2>&1
)

if "%SILENT%"=="false" (
  if "%AUDIO_CHANNELS%"=="1" (
     echo Audio Type     : %MONAURAL%
  ) else if "%AUDIO_CHANNELS%"=="2" (
     echo Audio Type     : %STEREO%
  ) else (
     echo Audio Channnels: %AUDIO_CHANNELS%
  )
  if defined INPUT_A_BITRATE echo Audio Bitrate  : %INPUT_A_BITRATE% kbps
  if defined SAMPLERATE echo Sampling rate  : %SAMPLERATE% Hz
)

rem RGBかYUVか
.\Mediainfo.exe --Inform=Video;%%ColorSpace%% --LogFile=%TEMP_INFO% %CATAVI1%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set COLOR_SPACE=%%i

rem ビットレート情報の取得
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM% * %DEFAULT_SIZE_PERCENT% ^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL% * %DEFAULT_SIZE_PERCENT%^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _normal_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_max_filesize.txt","_premium_max_filesize",append = false^)
    echo WriteFileStart^("normal_max_filesize.txt","_normal_max_filesize",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS2%

.\avs2pipemod.exe -info %INFO_AVS2% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_max_filesize.txt) do set /a P_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_max_filesize.txt) do set /a I_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul

rem 出力解像度の設定
set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2

if %IN_ARATIO% LEQ %CONST_WIDERATIO% (
  if defined DEFAULT_HEIGHTW (
      set /a WIDTH=%DEFAULT_WIDTHW% - %DEFAULT_WIDTHW% %% 2
      set /a HEIGHT=%DEFAULT_HEIGHTW% - %DEFAULT_HEIGHTW% %% 2
      set RESIZE=force
      goto error_report_record
  )
) else (
  if defined DEFAULT_WIDTH (
      set /a WIDTH=%DEFAULT_WIDTH% - %DEFAULT_WIDTH% %% 2
      set /a HEIGHT=%DEFAULT_HEIGHT% - %DEFAULT_HEIGHT% %% 2
      set RESIZE=force
      goto error_report_record
  )
)

if %IN_ARATIO% LEQ %CONST_WIDERATIO% (
    set /a OUT_WIDTH=%DEFAULT_WIDTHW%
    set /a OUT_HEIGHT=%DEFAULT_WIDTHW% * %IN_HEIGHT% / %IN_WIDTH_MOD% 
) else (
    set /a OUT_WIDTH=%DEFAULT_HEIGHT% * %IN_WIDTH_MOD% / %IN_HEIGHT%
    set /a OUT_HEIGHT=%DEFAULT_HEIGHT%
)
set /a OUT_WIDTH=%OUT_WIDTH% - %OUT_WIDTH% %% 2
set /a OUT_HEIGHT=%OUT_HEIGHT% - %OUT_HEIGHT% %% 2

rem 解像度が4の倍数かどうかの判定
set /a WIDTH_REM=%IN_WIDTH% %% 4
set /a HEIGHT_REM=%IN_HEIGHT% %% 4

if not "%WIDTH_REM%"=="0" (
  set IMAGE_SIZE_ERROR=t
)
if not "%HEIGHT_REM%"=="0" (
  set IMAGE_SIZE_ERROR=t
)

:error_report_record
(
  if exist "%ProgramFiles(x86)%" (
     echo OS           : Windows XP Vista 7 64 bit
  ) else (
     echo OS           : Windows 2000 XP Vista 7 32 bit
  )
   echo Version      : %TDENC_NAME%%C_VERSION%
   echo Source Movie : %INPUT_FILE_PATH%
   echo Video Format : "%V_Format%"
   echo PlayTime     : %TOTAL_TIME% ms
   echo FPS          : %FPS% fps
   echo Width        : %IN_WIDTH% pixels
   echo Height       : %IN_HEIGHT% pixels
   echo Decoder      : %DECODER%
)>> %ERROR_REPORT%

:info_check
if not defined TOTAL_TIME (
    echo ^>^>%ANALYZE_ERROR1%
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav"
      )
    )
    call .\quit.bat
    echo;
)

if not defined KEYINT (
    echo ^>^>%ANALYZE_ERROR1%
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav"
      )
    )
    call .\quit.bat
    echo;
)

echo ^>^>%ANALYZE_END%
echo;
echo;
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.wav"
  )
)

rem ################設定の質問################
call .\setting_question.bat

rem ################エンコ作業開始################
echo;
echo %HORIZON%
echo;

rem ################音声エンコード################
echo ^>^>%AUDIO_ENC_ANNOUNCE%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.wav"
  )
)

if "%A_BITRATE%"=="0" (
    echo ^>^>%SILENCE_ANNOUNCE%
    echo;
    copy /y mute.m4a %TEMP_DIR%\audio.m4a 1>nul 2>&1
    set /a TEMP_M4A_BITRATE=4
    set KEEPWAV=n
    goto movie_enc
)

echo ^>^>%WAV_ANNOUNCE%
if exist %PROCESS_E_FILE% del /f %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul
.\avs2pipemod.exe -wav %INPUT_FILE_PATH% > %TEMP_WAV% 2>nul

if "%A_GAIN%"=="0" (
  del /f %PROCESS_S_FILE% 2>nul
  goto wav_process
)

(
   echo WavSource^("%TEMP_WAV%"^)
   echo Normalize^(^)
   echo AmplifydB^(%A_GAIN%^)
   echo;
   echo return last
)> %AUDIO_AVS%

.\avs2pipemod.exe -wav %AUDIO_AVS% > %TEMP_WAV2% 2>nul
set TEMP_WAV=%TEMP_WAV2%

del %PROCESS_S_FILE% 2>nul
:wav_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_process 1>nul 2>&1
del %PROCESS_E_FILE%

call .\m4a_enc.bat

rem ################映像エンコード################
:movie_enc
echo;
echo ^>^>%VIDEO_ENC_ANNOUNCE%
echo;
if /i not "%SKIP_MODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_ANNOUNCE.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_ANNOUNCE.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_ANNOUNCE.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_ANNOUNCE.wav"
    )
  )
)

rem AVSファイル作成
if /i "%RGB%"=="true" (
    if /i "%FULL_RANGE%"=="on" (
        if /i "%COLORMATRIX%"=="BT.709" (
            set AVS_SCALE=matrix^=^"PC.709^"^,
        ) else (
            set AVS_SCALE=matrix^=^"PC.601^"^,
        )
    ) else (
        if /i "%COLORMATRIX%"=="BT.709" (
            set AVS_SCALE=matrix^=^"Rec709^"^,
        ) else (
            set AVS_SCALE=matrix^=^"Rec601^"^,
        )
    )
) else (
    set AVS_SCALE=
)

if not defined RESIZER set RESIZER=Spline16Resize
(
    if /i not "%RGB%"=="true" (
        if "%IMAGE_SIZE_ERROR%"=="t" (
            echo AVISource^(%INPUT_FILE_PATH%, audio = false, pixel_type="YUY2"^)
        ) else (
           echo AVISource^(%INPUT_FILE_PATH%, audio = false^)
        )
    ) else (
       echo AVISource^(%INPUT_FILE_PATH%, audio = false^)
    )
   
    if "%IN_WIDTH_ODD%"=="1" (
       if "%IN_HEIGHT_ODD%"=="1" (
          echo Crop^(0,0,-1,-1^)>> %VIDEO_AVS%
       ) else (
          echo Crop^(0,0,-1,0^)>> %VIDEO_AVS%
       )
    ) else if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)>> %VIDEO_AVS%

    echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)
    echo;

    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo;

    if not "%IN_WIDTH%"=="%WIDTH%" echo %RESIZER%^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo %RESIZER%^(last.width^(^),%HEIGHT%^)
    echo;
    echo return last
)> %VIDEO_AVS%

echo ^>^>%AVS_END%
echo;

call .\x264_enc.bat

echo ^>^>%VIDEO_ENC_END%
echo;
if /i not "%SKIP_MODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.wav"
    )
  )
)
