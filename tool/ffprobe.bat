rem ################変数設定################
set TRIM_AUDIO=false
set FFPROBE=true
if not "%ENCMODE%"=="MOVIEMUX" set AUTOBITRATEOFF=y

rem ################動画情報取得################
rem 再生時間取得

echo;
.\MediaInfo.exe --Inform=General;%%Format/String%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set C_FORMAT=%%i
echo File Format    : "%C_FORMAT%"
.\MediaInfo.exe --Inform=General;%%Format%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set C_FORMAT2=%%i

.\ffprobe.exe %INPUT_VIDEO% 2>%TEMP_INFO%
"%WINDIR%\system32\findstr.exe" "Stream" "%TEMP_INFO%"> %TEMP_INFO2%
"%WINDIR%\system32\findstr.exe" /i "Video" "%TEMP_INFO2%"> %TEMP_INFO4%

if "%ENCMODE%"=="MOVIEMUX" (
  .\ffprobe.exe %INPUT_AUDIO% 2>%TEMP_INFO%
   "%WINDIR%\system32\findstr.exe" "Stream" "%TEMP_INFO%"> %TEMP_INFO2%
)
"%WINDIR%\system32\findstr.exe" /i "Audio" "%TEMP_INFO2%"> %TEMP_INFO3%

cd %TEMP_DIR%
  ..\..\sed.exe -i -e "s/, /\n/g" temp3.txt
  ..\..\sed.exe -i -e "s/: /\n/g" temp3.txt
  ..\..\sed.exe -i -e "s/, /\n/g" temp4.txt
  ..\..\sed.exe -i -e "s/: /\n/g" temp4.txt
cd ..\..

for /f "skip=2" %%i in (%TEMP_INFO4%) do (
  set V_FORMAT=%%i
  goto v_format_fin
)
:v_format_fin
if defined V_FORMAT (
  echo Video Format   : "%V_FORMAT%"
) else goto info_check

for /f "skip=2" %%i in (%TEMP_INFO3%) do (
  set AUDIO_FORMAT=%%i
  goto a_codec_fin
)
:a_codec_fin
if defined AUDIO_FORMAT (
  echo Audio Format   : "%AUDIO_FORMAT%"
) else goto info_check

date /t>nul
"%WINDIR%\system32\findstr.exe" /i "stereo" "%TEMP_INFO3%">nul
if not ERRORLEVEL 1 (
  set AUDIO_CHANNELS=2
  goto audio channel_check_fin
)
date /t>nul
"%WINDIR%\system32\findstr.exe" /i "mono" "%TEMP_INFO3%">nul
if not ERRORLEVEL 1 set AUDIO_CHANNELS=1

:audio channel_check_fin
if defined AUDIO_CHANNELS (
  if "%AUDIO_CHANNELS%"=="1" (
     echo Audio Type     : %MONAURAL%
  ) else if "%AUDIO_CHANNELS%"=="2" (
     echo Audio Type     : %STEREO%
  ) else (
     echo Audio Channnels: %AUDIO_CHANNELS%
  )
)

rem 音声ビットレートの書き出し
if "%ENCMODE%"=="MOVIEMUX"  (
  .\MediaInfo.exe --Inform=Audio;%%BitRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
  for /f "delims=" %%i in (%TEMP_INFO%) do set ABITRATE_MODE=%%i
  if defined ABITRATE_MODE echo AudioBR Mode   : %ABITRATE_MODE%
  .\MediaInfo.exe --Inform=Audio;%%BitRate%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
  for /f "delims=" %%i in (%TEMP_INFO%) do set /a INPUT_A_BITRATE=%%i /1000 1>nul 2>&1
  echo Audio Bitrate  : %INPUT_A_BITRATE% kbps
)

rem 音声サンプリングレートの書き出し
"%WINDIR%\system32\findstr.exe" /i " Hz" "%TEMP_INFO3%"> %TEMP_INFO%
for /f "tokens=1" %%i in (%TEMP_INFO%) do (
  set SAMPLERATE=%%i
  goto samplerate_fin
)
:samplerate_fin
if defined SAMPLERATE echo Sampling rate  : %SAMPLERATE% Hz

rem 動画の容量書き出し
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FILE_SIZE=%%i
echo FileSize       : %INPUT_FILE_SIZE% byte

rem 再生時間の書き出し
.\MediaInfo.exe --Inform=General;%%Duration%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul

rem 再生時間の設定
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
echo PlayTime       : %TOTAL_TIME% ms

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

rem RGBかYUVか
date /t>nul
"%WINDIR%\system32\findstr.exe" /i "yuv420" "%TEMP_INFO4%">nul
if not ERRORLEVEL 1 (
  set YV12=true
  set RGB=false
) else (
  set YV12=false
  set RGB=true
)

rem フレームレート (VFRはとりあえず放置)
"%WINDIR%\system32\findstr.exe" /i " tbr" "%TEMP_INFO4%"> %TEMP_INFO%
for /f "tokens=1" %%i in (%TEMP_INFO%) do (
  set INPUT_FPS=%%i
  goto fps_setfin
)
:fps_setfin
echo FPS            : %INPUT_FPS%fps^(CFR^)

"%WINDIR%\system32\findstr.exe" /i /R /C:"[0-9]x[0-9]" "%TEMP_INFO4%"> %TEMP_INFO2%
for /f "delims=xX tokens=1" %%i in (%TEMP_INFO2%) do set /a IN_WIDTH=%%i
date /t>nul
for /f "delims=xX tokens=2" %%i in (%TEMP_INFO2%) do set /a IN_HEIGHT=%%i

if not defined DEFAULT_FPS (
    set CHANGE_FPS=false
    set FPS=%INPUT_FPS%
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
    set CONVERT_FPS=-r %DEFAULT_FPS%
)

rem ビットレート情報の取得
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM% * %DEFAULT_SIZE_PERCENT% ^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL% * %DEFAULT_SIZE_PERCENT%^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _normal_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _keyint = String^(Round^(%FPS%^)^)
    echo _in_aratio = String^(Ceil^(%IN_HEIGHT% / %IN_WIDTH% * 10000 ^)^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_max_filesize.txt","_premium_max_filesize",append = false^)
    echo WriteFileStart^("normal_max_filesize.txt","_normal_max_filesize",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("in_aratio.txt","_in_aratio",append = false^)
    echo;
    echo return last
)> %INFO_AVS%

.\avs2pipemod.exe -info %INFO_AVS% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_max_filesize.txt) do set /a P_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_max_filesize.txt) do set /a I_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=10*%%i

echo Width          : %IN_WIDTH%pixels
set /a IN_WIDTH_MOD=%IN_WIDTH%

echo Height         : %IN_HEIGHT%pixels

for /f "delims=" %%i in (%TEMP_DIR%\in_aratio.txt) do set /a IN_ARATIO=%%i
if not defined IN_ARATIO goto info_check

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
   echo Video Format : "Flash Video (niconamarecoder)"
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
set DECODER=directshow
set FFPIPE=y
exit /b
