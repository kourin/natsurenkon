rem ################変数設定################
set INFO_AVS=%TEMP_DIR%\information.avs
set X264_TC_FILE=%TEMP_DIR%\x264.tc
set SILENT=false
set AVI1_ERROR=
if /i "%INPUT_AUDIO_TYPE%"==".wav" set KEEPWAV=n

rem ################動画情報取得################
echo ^>^>%ANALYZE_ANNOUNCE%
echo;
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.wav"
  )
)

rem 音声ビットレートの書き出し
.\MediaInfo.exe --Inform=Audio;%%BitRate%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a INPUT_A_BITRATE=%%i /1000 1>nul 2>&1

rem 音声サンプリングレートの書き出し
.\MediaInfo.exe --Inform=Audio;%%SamplingRate%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a SAMPLERATE=%%i

.\MediaInfo.exe --Inform=Audio;%%Channels%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CHANNELS=%%i

if not "%ENC_MODE%"=="IMAGEMUX" goto movie_mux_mode

if /i "%INPUT_AUDIO_TYPE%"==".mp3" set MAKEFLV=f

rem 画像と音声のMUX
set TRIM_AUDIO=false
.\MediaInfo.exe --Inform=Audio;%%Duration%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
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
.\MediaInfo.exe --Inform=Audio;%%Format%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_FORMAT=%%i
if defined AUDIO_FORMAT echo Audio Format   : "%AUDIO_FORMAT%"
.\MediaInfo.exe --Inform=Audio;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CODEC=%%i
if defined AUDIO_CODEC echo Audio Codec    : "%AUDIO_CODEC%"

if defined AUDIO_CHANNELS (
  if "%AUDIO_CHANNELS%"=="1" (
     echo Audio Type     : %MONAURAL%
  ) else if "%AUDIO_CHANNELS%"=="2" (
     echo Audio Type     : %STEREO%
  ) else (
     echo Audio Channnels: %AUDIO_CHANNELS%
  )
)

.\MediaInfo.exe --Inform=General;%%FileSize%% %INPUT_AUDIO%> %TEMP_INFO%
for /f %%i in (%TEMP_INFO%) do set /a AUDIO_SIZE=%%i
echo %INPUT_AUDIO_TYPE% File Size : %AUDIO_SIZE% byte

echo Sampling Rate  : %SAMPLERATE% Hz

if /i "%INPUT_AUDIO_TYPE%"==".wav" goto audio_info_end
if "%AUDIO_CODEC%"=="40" goto audio_info_end

if exist "%ProgramFiles(x86)%" (
    if exist %WINDIR%\SysWOW64\vp6vfw.dll (
      set VP6VFW_CHECK=t
    )
) else (
    if exist %WINDIR%\system32\vp6vfw.dll (
      set VP6VFW_CHECK=t
    )
)

if "%SAMPLERATE%"=="44100" (
  set A_RATE_MP3=t
  goto audio_info_end
) 
if "%SAMPLERATE%"=="22000" (
  set A_RATE_MP3=t
  goto audio_info_end
) 

:audio_info_end 
set /a FPS=%IMAGE_FPS%
set /a KEYINT=%IMAGE_KEYINT%

(
    echo ImageSource^(%INPUT_VIDEO%,end=1,fps=%FPS%^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM% * %DEFAULT_SIZE_PERCENT% ^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL% * %DEFAULT_SIZE_PERCENT%^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _normal_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _max_size_limit = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _in_aratio = String^(Ceil^(height^(^) / width^(^) * 10000 ^)^)
    echo _frames = String^(Floor^(Float^(%TOTAL_TIME% * %FPS% / 1000 ^)^)^)
    echo;
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_max_filesize.txt","_premium_max_filesize",append = false^)
    echo WriteFileStart^("normal_max_filesize.txt","_normal_max_filesize",append = false^)
    echo WriteFileStart^("in_aratio.txt","_in_aratio",append = false^)
    echo WriteFileStart^("frames.txt","_frames",append = false^)
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
for /f "delims=" %%i in (%TEMP_DIR%\in_aratio.txt) do set /a IN_ARATIO=%%i
for /f "delims=" %%i in (%TEMP_DIR%\frames.txt) do set FRAMES=%%i>nul

.\MediaInfo.exe --Inform=Image;%%Width%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_WIDTH=%%i
echo Width          : %IN_WIDTH%pixels
set IN_WIDTH_MOD=%IN_WIDTH%
.\MediaInfo.exe --Inform=Image;%%Height%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_HEIGHT=%%i
echo Height         : %IN_HEIGHT%pixels

rem 出力解像度の設定
set /a IN_WIDTH_ODD=%IN_WIDTH% %% 2
set /a IN_HEIGHT_ODD=%IN_HEIGHT% %% 2

if %IN_ARATIO% LEQ %CONST_WIDERATIO% (
  if defined DEFAULT_HEIGHTW (
      set /a WIDTH=%DEFAULT_WIDTHW% - %DEFAULT_WIDTHW% %% 2
      set /a HEIGHT=%DEFAULT_HEIGHTW% - %DEFAULT_HEIGHTW% %% 2
      set RESIZE=force
rem      goto error_report_record
  )
) else (
  if defined DEFAULT_WIDTH (
      set /a WIDTH=%DEFAULT_WIDTH% - %DEFAULT_WIDTH% %% 2
      set /a HEIGHT=%DEFAULT_HEIGHT% - %DEFAULT_HEIGHT% %% 2
      set RESIZE=force
rem      goto error_report_record
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

if not "%WIDTH_REM%"=="0"  set IMAGE_SIZE_ERROR=t
if not "%HEIGHT_REM%"=="0"  set IMAGE_SIZE_ERROR=t

:image_info_end
echo Decoder        : %DECODER%
echo;
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
set PRETYPE=m
rem if %I_TEMP_BITRATE% GEQ %E_TARGET_BITRATE% (
rem  set ENCTYPE=y
rem  set RESIZE=y
rem  set TEMP_BITRATE=a
rem )
rem if %OUT_WIDTH% LEQ %I_MAX_WIDTH% (
rem  if %OUT_HEIGHT% LEQ %I_MAX_HEIGHT% set ACTYPE=n
rem )

call .\setting_question.bat
set SIZEOK=n
set TRIM_AUDIO=false

rem ################エンコ作業開始################
echo;
echo %HORIZON%
echo;
if "%MAKEFLV%"=="y" (
    call .\FLV4enc.bat
    call .\shut.bat
)

rem ################音声エンコード################
:imageaudio
echo ^>^>%AUDIO_ENC_ANNOUNCE%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.wav"
  )
)

rem .\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
rem for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i/(%TOTAL_TIME%/8)
rem 
rem (
rem   echo;
rem   echo CRF BR: %TEMP_264_BITRATE% kbps
rem )>> %ERROR_REPORT%


if "%A_BITRATE%"=="0" (
    echo ^>^>%SILENCE_ANNOUNCE%
    echo;
    copy /y mute.m4a %TEMP_DIR%\audio.m4a 1>nul 2>&1
    goto :eof
)

if "%SKIP_A_ENC%"=="true" (
    echo ^>^>%SKIP_A_ENC_ANNOUNCE%
    echo;
    goto image_movie_enc
)
if /i "%INPUT_AUDIO_TYPE%"==".wav" (
  (
    echo WavSource^(%INPUT_AUDIO%^)
    echo;
  )> %AUDIO_AVS%
) else (
  (
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    echo DirectShowSource^(%INPUT_AUDIO%, video = false^)
  )> %AUDIO_AVS%
)  

if "%A_GAIN%"=="0" goto close_audio_avs
(
  echo Normalize^(^)
  echo AmplifydB^(%A_GAIN%^)
)>> %AUDIO_AVS%

:close_audio_avs
(
    echo;
    echo return last
)>> %AUDIO_AVS%

echo ^>^>%WAV_ANNOUNCE%
.\avs2pipemod.exe -wav %AUDIO_AVS% > %TEMP_WAV% 2>nul

echo;

call .\m4a_enc.bat

rem ################映像エンコード################
:image_movie_enc
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
if not defined RESIZER set RESIZER=Spline16Resize

(
    echo ImageSource^(%INPUT_VIDEO%,end=%FRAMES%,fps=%FPS%^)
    if "%IN_WIDTH_ODD%"=="1" (
       if "%IN_HEIGHT_ODD%"=="1" (
           echo Crop^(0,0,-1,-1^)
       ) else (
           echo Crop^(0,0,-1,0^)
       )
    ) else if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)

    if "%SETTING2%"=="noresize" (
        echo # no resize
    ) else (
        echo %RESIZER%^(%WIDTH%,%HEIGHT%^)
        echo;
    )
    echo ConvertToYV12^(^)
    echo;
    echo return last
)> %VIDEO_AVS%

echo ^>^>%AVS_END%
echo;

rem 264にエンコード

rem １pass処理
if /i "%FULL_RANGE%"=="off" (
    set RANGE=tv
) else if /i "%FULL_RANGE%"=="on" (
    set RANGE=pc
) else (
    set RANGE=auto
)

if "%XARCH%"=="64bit" goto imagemux_x64

if "%CRFMODE%"=="y" (
  echo ^>^>%PASS_ANNOUNCE10%
  echo;
  if /i  "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav"
    )
  )
   .\%X264EXE% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 --crf %CRF% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264% %VIDEO_AVS%
  goto :eof
)

echo ^>^>%PASS_ANNOUNCE2%
echo;
  if /i  "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav"
    )
  )

.\%X264EXE% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 1 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o "nul" %VIDEO_AVS%
echo;

rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
  if /i  "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav"
    )
  )
.\%X264EXE% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 3 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264% %VIDEO_AVS%
echo;

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i
set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE%*8/%TOTAL_TIME_SEC%/1000

if %TEMP_264_BITRATE% LEQ %V_BITRATE% (
	echo ^>^>%VIDEO_ENC_END%
	echo;
	goto :eof 
)

rem 3pass処理
echo ^>^>%PASS_ANNOUNCE4%
echo ^>^>%PASS_ANNOUNCE5%
echo;
echo ^>^>%PASS_ANNOUNCE6%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav"
  )
)
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.wav"
  )
)
rem  if /i  "%VOICE%"=="true" (
rem    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.mp3" (
rem      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.mp3"
rem    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.wav" (
rem      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.wav"
rem    )
rem  )
.\%X264EXE% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 2 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264% %VIDEO_AVS%
echo;
echo ^>^>%VIDEO_ENC_END%
echo;
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.wav"
  )
)
goto :eof

:imagemux_x64
.\avs2pipemod.exe -x264raw=8 %VIDEO_AVS%> %TEMP_INFO%
for /f "delims=" %%i in (%TEMP_INFO%) do set X264_A2POPT=%%i

if "%CRFMODE%"=="y" (
  echo ^>^>%PASS_ANNOUNCE10%
  echo;
  if /i  "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav"
    )
  )
.\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE% - --demuxer y4m --frames %FRAMES% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 --crf %CRF% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264% 
  goto :eof
)

echo ^>^>%PASS_ANNOUNCE2%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav"
  )
)
.\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE% - --demuxer y4m --frames %FRAMES% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 1 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o "nul"
echo;

rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav"
  )
)
.\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE% - --demuxer y4m --frames %FRAMES% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 3 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264%
echo;

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i
set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE%*8/%TOTAL_TIME_SEC%/1000

if %TEMP_264_BITRATE% LEQ %V_BITRATE% (
	echo ^>^>%VIDEO_ENC_END%
	echo;
	goto :eof 
)

rem 3pass処理
echo ^>^>%PASS_ANNOUNCE4%
echo ^>^>%PASS_ANNOUNCE5%
echo;
echo ^>^>%PASS_ANNOUNCE6%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav"
  )
)
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.wav"
  )
)
rem  if /i  "%VOICE%"=="true" (
rem    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.mp3" (
rem      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.mp3"
rem    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.wav" (
rem      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.wav"
rem    )
rem  )
.\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE% - --demuxer y4m --frames %FRAMES% --range %RANGE% -I %KEYINT% -i %KEYINT% --no-scenecut -b 0 -r 1 -f -1:-1 -B %V_BITRATE% --ipratio 1.0 --aq-mode 2 --aq-strength 0.70 -p 2 --stats %TEMP_DIR%\x264_2pass.log --qcomp 0.8 --direct auto --weightp 0 --me dia -m 1 -t 1 --no-fast-pskip --no-dct-decimate --threads 0 --thread-input --colormatrix smpte170m --quiet -o %TEMP_264%
echo;
echo ^>^>%VIDEO_ENC_END%
echo;
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\VIDEO_ENC_END.wav"
  )
)
goto :eof

rem 動画と音声のMUX
:movie_mux_mode

rem 動画のフォーマット書き出し
.\MediaInfo.exe --Inform=General;%%Format/String%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set C_FORMAT=%%i
.\MediaInfo.exe --Inform=General;%%Format%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set C_FORMAT2=%%i
.\MediaInfo.exe --Inform=Video;%%Format%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set V_FORMAT=%%i
.\MediaInfo.exe --Inform=Video;%%CodecID/Info%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
if not defined V_CODEC (
  .\MediaInfo.exe --Inform=Video;%%Codec/Info%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
   for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
)
if not defined V_CODEC (
  .\MediaInfo.exe --Inform=Video;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
   for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
)
if not defined V_CODEC  (
  .\MediaInfo.exe --Inform=Video;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
   for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
)
if not defined V_FORMAT (
	if "%PAIR_MODE%"=="true" (
		set /a FAILED_MOVIES=%FAILED_MOVIES% + 1
		set DECODE_FAILED=true
		goto :eof
	)
  set PRESET_S_ENABLE=false
  set PRESET_SI_ENABLE=false
  call .\ffprobe.bat
  goto info_check
)
echo File Format    : "%C_FORMAT%"
echo Video Format   : "%V_FORMAT%"
if defined V_CODEC echo Video Codec    : "%V_CODEC%"
.\MediaInfo.exe --Inform=Video;%%BitRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a S_V_BITRATE=%%i/1000
echo Video Bitrate  : %S_V_BITRATE% kbps
.\MediaInfo.exe --Inform=Audio;%%Format%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_FORMAT=%%i
if defined AUDIO_FORMAT echo Audio Format   : "%AUDIO_FORMAT%"
.\MediaInfo.exe --Inform=Audio;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CODEC=%%i
if defined AUDIO_CODEC echo Audio Codec    : "%AUDIO_CODEC%"

.\MediaInfo.exe --Inform=Audio;%%Channels%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CHANNELS=%%i
if defined AUDIO_CHANNELS (
  if "%AUDIO_CHANNELS%"=="1" (
     echo Audio Type     : Monaural
  ) else if "%AUDIO_CHANNELS%"=="2" (
     echo Audio Type     : Stereo
  ) else (
     echo Audio Channnels: %AUDIO_CHANNELS%
  )
)

if defined AUDIO_CHANNELS echo Audio Channels : %AUDIO_CHANNELS%
.\MediaInfo.exe --Inform=Audio;%%BitRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_AUDIO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set ABITRATE_MODE=%%i
if defined ABITRATE_MODE echo AudioBR Mode   : %ABITRATE_MODE%
echo Audio Bitrate  : %INPUT_A_BITRATE% kbps

rem 動画の容量書き出し
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FILE_SIZE=%%i
echo FileSize       : %INPUT_FILE_SIZE% byte
set INPUT_FILESIZE_MB1=%INPUT_FILE_SIZE:~0,-6%
set INPUT_FILESIZE_MB2=%INPUT_FILE_SIZE:~-6%
if not defined INPUT_FILESIZE_MB1 set INPUT_FILESIZE_MB1=0

rem 再生時間の書き出し
.\MediaInfo.exe --Inform=General;%%Duration%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul

rem 再生時間・上限ビットレートの設定
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
echo PlayTime       : %TOTAL_TIME% ms

rem フレーム数
.\MediaInfo.exe --Inform=Video;%%FrameCount%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set MFRAMES=%%i
rem echo Frame          : %FRAMES%

rem CFR（固定フレームレート）とVFR（可変フレームレート）の判断
.\MediaInfo.exe --Inform=Video;%%FrameRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set FPS_MODE=%%i
if /i "%FPS_MODE%"=="VFR" goto vfr_info
if not defined FPS_MODE set FPS_MODE=CFR

rem CFRの設定
set VFR=false
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
if defined INPUT_FPS echo FPS            : %INPUT_FPS% fps^(CFR^)
.\MediaInfo.exe --Inform=Video;%%FrameRate_Original%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set ORIGINAL_FPS=%%i
if defined ORIGINAL_FPS echo ^(Original FPS  : %ORIGINAL_FPS%fps^)

goto fps_main

rem VFRの設定
:vfr_info
set VFR=true
set FPS_CHECK=false
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
echo FPS            : %INPUT_FPS%fps^(VFR^)
.\MediaInfo.exe --Inform=Video;%%FrameRate_Minimum%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Minimum FPS    : %%i
.\MediaInfo.exe --Inform=Video;%%FrameRate_Maximum%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Maximum FPS    : %%i

:fps_main
if not defined DEFAULT_FPS (
    set CHANGE_FPS=false
	if "%ORIGINAL_FPS%"=="" (
      set FPS=%INPUT_FPS%
	) else if "%ORIGINAL_FPS%"=="%INPUT_FPS%" (
      set FPS=%INPUT_FPS%
    ) else (
      set FPS=%INPUT_FPS%
      set ASSUME_FPS=true
      set CONVERT_FPS=-r %INPUT_FPS%
    )
) else (
    set CHANGE_FPS=true
    set FPS=%DEFAULT_FPS%
    set CONVERT_FPS=-r %DEFAULT_FPS%
)

rem 解像度の設定
.\MediaInfo.exe --Inform=Video;%%Width%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_WIDTH=%%i
echo Width          : %IN_WIDTH%pixels
.\MediaInfo.exe --Inform=Video;%%Height%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_HEIGHT=%%i
echo Height         : %IN_HEIGHT%pixels

rem アスペクト比
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio/String%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set D_ASPECT=%%i
echo AspectRatio    : %D_ASPECT%
.\MediaInfo.exe --Inform=Video;%%PixelAspectRatio%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set P_ASPECT=%%i

rem インターレース関連の設定
:interlace
.\MediaInfo.exe --Inform=Video;%%ScanType%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_TYPE=%%i
if defined SCAN_TYPE echo Scan type      : %SCAN_TYPE%
.\MediaInfo.exe --Inform=Video;%%ScanOrder%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f  %%i in (%TEMP_INFO%) do set SCAN_ORDER=%%i
if defined SCAN_ORDER echo Scan order     : %SCAN_ORDER%

rem RGBかYUVか
.\Mediainfo.exe --Inform=Video;%%ColorSpace%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set COLOR_SPACE=%%i

rem 例外処理
rem .\MediaInfo.exe --Inform=General;%%Copyright%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
rem for /f "delims=" %%i in (%TEMP_INFO%) do set COPYRIGHT=%%i
rem if "%COPYRIGHT%"=="SEGA Corporation" set FFPIPE=y

rem .\MediaInfo.exe --Inform=Video;%%ID/String%% --LogFile=%TEMP_INFO% %INPUT_VIDEO%>nul
rem for /f "delims=" %%i in (%TEMP_INFO%) do set V_ID=%%i
rem if "%V_FORMAT%"=="MPEG Video" (
rem    if "%V_ID%"=="224 (0xE0)" set FFPIPE=y
rem )

if /i not "%INPUT_FILE_TYPE%"==".mp4" goto video_info
.\MediaInfo.exe --Inform=Video;%%Encoded_Library_Settings%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
cd %TEMP_DIR%
  ..\..\sed.exe -i -e "s/ \/ /\n/g" temp.txt
cd ..\..
type %TEMP_INFO% | "%WINDIR%\system32\findstr.exe" /B "ref="> %TEMP_INFO2%
for /f "delims=\= tokens=2" %%i in (%TEMP_INFO2%) do set REFVALUE=%%i

type %TEMP_INFO% | "%WINDIR%\system32\findstr.exe" /B "bframes="> %TEMP_INFO2%
for /f "delims=\= tokens=2" %%i in (%TEMP_INFO2%) do set BFRAMEVALUE=%%i

type %TEMP_INFO% | "%WINDIR%\system32\findstr.exe" /B "keyint="> %TEMP_INFO2%
for /f "delims=\= tokens=2" %%i in (%TEMP_INFO2%) do set KEYINTVALUE=%%i
rem echo  x264 ref value : %REFVALUE%
rem echo  x264 keyint value = %KEYINTVALUE%

rem IDRフレーム間の最大間隔・容量上限の設定
:video_info
if /i "%DECODER%"=="avi" goto avisource_info
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_info
if /i "%DECODER%"=="directshow" goto directshowsource_info
if /i "%DECODER%"=="ds_input" goto directshowsource_info
if /i "%DECODER%"=="LSMASH" goto LSMASHsource_info
if /i "%DECODER%"=="LWLibav" goto LSMASHsource_info2
if /i "%DECODER%"=="qt" goto qtsource_info
goto directshowsource_info

:vfr_timecode_export
if "%VFR%"=="true" (
    echo;
    echo exporting timecode...
    if exist %X264_TC_FILE% del %X264_TC_FILE%
    if /i "%C_FORMAT2%"=="MPEG-4" (
       .\mp4fpsmod.exe -p %X264_TC_FILE% %INPUT_FILE_PATH%
    ) else (
        .\%X264EXE% --preset ultrafast -q 51 -o nul --tcfile-out %X264_TC_FILE% %INPUT_FILE_PATH%
    )
    if exist %X264_TC_FILE% (
        echo done.
        set X264_VFR_ENC=true
    ) else (
        set X264_VFR_ENC=false
        echo failed.
        echo ^(encode as cfr^)
    )
)
exit /b

:directshowsource_info
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    echo DirectShowSource^(%INPUT_VIDEO%, audio = false^)
)> %INFO_AVS%
goto infoavs

:avisource_info
echo AVISource^(%INPUT_VIDEO%, audio = false^)> %INFO_AVS%
goto infoavs

:qtsource_info
if "%VFR%"=="true" (
  if not defined X264_VFR_ENC call :vfr_timecode_export
)
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_VIDEO%, quality = 100, audio = 0^)
)> %INFO_AVS%
goto infoavs

:LSMASHsource_info
if /i "%C_FORMAT2%"=="MPEG-4" (
  set DECODER=LSMASH
) else if not "%LWLIBAV_INFO%"=="f" goto LSMASHsource_info2
if "%VFR%"=="true" (
  if not defined X264_VFR_ENC call :vfr_timecode_export
)

(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo LSMASHVideoSource^(%INPUT_VIDEO%, track=0, threads=0, seek_threshold=10, seek_mode=0^)
)> %INFO_AVS%
goto infoavs

:LSMASHsource_info2
if /i "%C_FORMAT2%"=="MPEG-4" (
  if not "%LSMASH_INFO%"=="f" goto LSMASHsource_info
)
set DECODER=LWLibav
if "%VFR%"=="true" (
  if not defined X264_VFR_ENC call :vfr_timecode_export
)
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0^)
)> %INFO_AVS%
goto infoavs

:ffmpegsource_info
if "%VFR%"=="true" (
  if not defined X264_VFR_ENC call :vfr_timecode_export
)
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo FFVideoSource^(%INPUT_VIDEO%,cache=false,threads=1^)
)> %INFO_AVS%

:infoavs
(
    echo;
    echo _isyv12 = IsYV12^(^)
    echo _isrgb = IsRGB^(^)
    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo _fps = Framerate^(^)
    echo _afps2 = String^(Framerate^(^) * 2 ^)
    if defined FPS (
        echo _keyint = String^(Round^(%FPS%^)^)
        echo _fps2 = String^(Framerate^(^) * 2 ^)
        echo _fps_check = String^(Floor^(_fps / %FPS% ^)^)
        echo _fps_check2 = String^( Round ^(%FPS% * %TOTAL_TIME% / 1000 / %MFRAMES% ^) ^)
        echo WriteFileStart^("fps2.txt","_fps2",append = false^)
        echo WriteFileStart^("fps_check.txt","_fps_check",append = false^)
        echo WriteFileStart^("fps_check2.txt","_fps_check2",append = false^)
    ) else (
        echo _keyint = String^(Round^(_fps^)^)
    )
    echo _frames = Framecount^(^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM% * %DEFAULT_SIZE_PERCENT% ^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL% * %DEFAULT_SIZE_PERCENT%^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    if %INPUT_FILESIZE_MB1% LSS 2147 (
        echo _current_bitrate = String^(Floor^(Float^(%INPUT_FILE_SIZE%^) / %TOTAL_TIME% * 8^)^)
    ) else (
        echo _current_bitrate = String^(Floor^(Float^(%INPUT_FILESIZE_MB1%^) / %TOTAL_TIME% * 8^* 1000^)^)
    )
    echo _premium_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _normal_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _max_size_limit = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _in_width = String^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT%^)^)
    echo _in_height = Height^(^)
    echo _in_aratio = String^(Ceil^(height^(^) / Float^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT% ^)^)* 10000 ^)^)
    echo;
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("afps2.txt","_afps2",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("frames.txt","_frames",append = false^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("current_bitrate.txt","_current_bitrate",append = false^)
    echo WriteFileStart^("premium_max_filesize.txt","_premium_max_filesize",append = false^)
    echo WriteFileStart^("normal_max_filesize.txt","_normal_max_filesize",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_height.txt","_in_height",append = false^)
    echo WriteFileStart^("in_aratio.txt","_in_aratio",append = false^)
    echo;
    echo Trim^(0,-1^)
    echo;
    echo return last
)>> %INFO_AVS%

.\avs2pipemod.exe -info %INFO_AVS% 1>nul 2>&1

if not defined FPS (
   if exist "%TEMP_DIR%\keyint.txt" (
     goto info_set
   ) else (
     goto decoder_reselect
   )
)
if "%FPS_CHECK%"=="false" (
   if exist "%TEMP_DIR%\keyint.txt" (
     goto info_set
   ) else (
     goto decoder_reselect
   )
)
if %INPUT_FILESIZE_MB1% GEQ 2147 (
	if %INPUT_FILESIZE_MB2% GEQ 483648 (
		if /i "%DECODER%"=="ffmpeg" (
			if not "%LWLIBAV_INFO%"=="f" (
				set DECODER=LWLibav
				goto decoder_reselect
			)
		)
	)
)

if not exist "%TEMP_DIR%\fps_check.txt" goto decoder_reselect
if "%CHANGE_FPS%"=="true" goto info_set
for /f "delims=" %%i in (%TEMP_DIR%\fps_check2.txt) do set FPS_CHECK2=%%i
if %FPS_CHECK2% NEQ 1 (
  set MINFO=wrong
  goto info_set
)
for /f "delims=" %%i in (%TEMP_DIR%\fps_check.txt) do set FPS_CHECK=%%i>nul
if %FPS_CHECK% LEQ 2 goto info_set

del /f "%TEMP_DIR%\keyint.txt"
del /f "%TEMP_DIR%\fps_check.txt"

if /i "%DECODER%"=="ffmpeg" set FFMS_FPS=wrong
if /i "%DECODER%"=="directshow" set DIRECTSHOW_FPS=wrong

if "%FFMS_FPS%"=="wrong" (
  if "%DIRECTSHOW_FPS%"=="wrong" (
     set FPS_CHECK=false
     set DECODER=ffmpeg
     echo ^>^>%ANALYZE_ERROR3%  
     goto ffmpegsource_info
  )
)

:decoder_reselect
if "%DECODER%"=="ffmpeg" (
  set FFMS_INFO=f
  echo ^>^>ffmpegsource %ANALYZE_ERROR2%
)
if "%DECODER%"=="avi" (
  set AVI_INFO=f
  echo ^>^>avi %ANALYZE_ERROR2%
)
if "%DECODER%"=="directshow" (
  set DIRECTSHOW_INFO=f
  echo ^>^>directshow %ANALYZE_ERROR2%
)
if "%DECODER%"=="ds_input" (
  set DIRECTSHOW_INFO=f
  echo ^>^>directshow %ANALYZE_ERROR2%
)
if /i "%DECODER%"=="LSMASH" (
  set LSMASH_INFO=f
  echo ^>^>LSMASHsource %ANALYZE_ERROR2%
)
if /i "%DECODER%"=="LWLibav" (
  set LWLIBAV_INFO=f
  echo ^>^>LWLibavsource %ANALYZE_ERROR2%
)
if "%DECODER%"=="qt" (
  set QT_INFO=f
  echo ^>^>QuickTime %ANALYZE_ERROR2%
)

if "%AVI_INFO%"=="f" (
  if not "%DIRECTSHOW_INFO%"=="f" (
     set DECODER=directshow
     echo ^>^>%ANALYZE_ERROR3%
     goto directshowsource_info
   )
)
if /i "%INPUT_FILE_TYPE%"==".avi" (
  if "%AVI1_ERROR%"=="true" (
    if not "%DIRECTSHOW_INFO%"=="f" (
      set DECODER=directshow
      echo ^>^>%ANALYZE_ERROR3%
      goto directshowsource_info
    )
  )
)
if not "%FFMS_INFO%"=="f" (
  set DECODER=ffmpeg
  echo ^>^>%ANALYZE_ERROR3%  
  goto ffmpegsource_info
)
if not "%LWLIBAV_INFO%"=="f" (
  set DECODER=LWLibav
  echo ^>^>%ANALYZE_ERROR3%  
  goto LSMASHsource_info2
)
if not "%LSMASH_INFO%"=="f" (
  set DECODER=LSMASH
  echo ^>^>%ANALYZE_ERROR3%  
  goto LSMASHsource_info
)
if not "%AVI_INFO%"=="f" (
  set DECODER=avi
  echo ^>^>%ANALYZE_ERROR3%  
  goto avisource_info
)
if not "%DIRECTSHOW_INFO%"=="f" (
  set DECODER=directshow
  echo ^>^>%ANALYZE_ERROR3%  
  goto directshowsource_info
)
if not "%QT_INFO%"=="f" (
  set DECODER=qt
  echo ^>^>%ANALYZE_ERROR3%  
  goto qtsource_info
)
if "%FFMS_INFO%"=="f" (
	if "%LSMASH_INFO%"=="f" (
		if "%DIRECTSHOW_INFO%"=="f" (
			if "%AVI_INFO%"=="f" (
				if "%QT_INFO%"=="f" (
					echo ^>^>%ANALYZE_ERROR1%
					if /i "%VOICE%"=="true" (
						if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3" (
							%PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3"
						) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav" (
							%PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav"
						)
					)
					if "%PAIR_MODE%"=="true" (
					  set /a FAILED_MOVIES=%FAILED_MOVIES% + 1
					  set DECODE_FAILED=true
					  goto :eof
					)
					call .\quit.bat
				)
			)
		)
	)
)

:info_set
if not exist %TEMP_DIR%\yv12.txt goto info_check
for /f "delims=" %%i in (%TEMP_DIR%\fps_check2.txt) do set FPS_CHECK2=%%i
if %FPS_CHECK2% NEQ 1 set MINFO=wrong

for /f "delims=" %%i in (%TEMP_DIR%\yv12.txt) do set YV12=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\rgb.txt) do set RGB=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set AVS_FPS=%%i>nul 2>&1
if defined FPS (
  for /f "delims=" %%i in (%TEMP_DIR%\fps2.txt) do set FPS2=%%i>nul 2>&1
)
for /f "delims=" %%i in (%TEMP_DIR%\afps2.txt) do set AVS_FPS2=%%i>nul 2>&1
for /f "delims=" %%i in (%TEMP_DIR%\frames.txt) do set FRAMES=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=%%i*10>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_max_filesize.txt) do set /a P_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_max_filesize.txt) do set /a I_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set IN_WIDTH_MOD=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\in_aratio.txt) do set /a IN_ARATIO=%%i
if not defined IN_HEIGHT (
  for /f "delims=" %%i in (%TEMP_DIR%\in_height.txt) do set IN_HEIGHT=%%i>nul
)
for /f "delims=" %%i in (%TEMP_DIR%\current_bitrate.txt) do set /a CURRENT_BITRATE=%%i>nul

set /a EA_BITRATE = %E_MAX_BITRATE% - %CURRENT_BITRATE%
if %EA_BITRATE% GEQ 0 (
  if %EA_BITRATE% LEQ 5 set /a EA_BITRATE = 5
)
if "%CHANGE_FPS%"=="true" goto framecheck_fin
if not defined FPS set FPS=%AVS_FPS%
if not defined FPS2 set FPS2=%AVS_FPS2%
if "%MINFO%"=="wrong" (
	if defined AVS_FPS (
		set FPS=%AVS_FPS%
		set FPS2=%AVS_FPS2%
	) else (
	  goto decoder_reselect
	)
)
if /i "%INPUT_FILE_TYPE%"==".wmv" goto framecheck_fin
if "%FRAMES%"=="" (
	if not "%MFRAMES%"=="" set FRAMES=%MFRAMES%
	goto framecheck_fin
)

if "%SCAN_TYPE%"=="Interlaced" (
  if /i "%DECODER%"=="ffmpeg" set /a FRAMES=%FRAMES% / 2 1>nul 2>&1
  if /i "%DECODER%"=="LSMASH" set /a FRAMES=%FRAMES% / 2 1>nul 2>&1
  if /i "%DECODER%"=="LWLibav" set /a FRAMES=%FRAMES% / 2 1>nul 2>&1
)

set /a FRAME_DIFF=%FRAMES% - %MFRAMES%
set FRAMES_RECORD=%FRAMES_RECORD%Mediainfo: %FRAMES% frames, Avisynth: %MFRAMES% frames
if %FRAME_DIFF% GTR 20 (
  set AVI1_ERROR=true
  goto decoder_reselect
) else if %FRAME_DIFF% LSS -20 (
  set AVI1_ERROR=true
  goto decoder_reselect
)

:framecheck_fin
set /a KEYINT_HIGH_LIMIT=%KEYINT% * 2

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

rem set /a INPUT_FILE_SIZE_KB=%INPUT_FILE_SIZE:~0,-3%
rem set /a P_MAX_FILESIZE_KB=%P_MAX_FILESIZE% / 1000
rem set /a I_MAX_FILESIZE_KB=%I_MAX_FILESIZE% / 1000

if /i not "%INPUT_FILE_TYPE%"==".mp4" goto error_report_record
set PRESET_S_ENABLE=pending
if %INPUT_FILE_SIZE% LEQ %P_MAX_FILESIZE% set PRESET_S_ENABLE=true

if %INPUT_FILE_SIZE% LEQ %I_MAX_FILESIZE% (
  if %IN_WIDTH_MOD% LEQ %I_MAX_WIDTH% (
    if %IN_HEIGHT% LEQ %I_MAX_HEIGHT% set PRESET_SI_ENABLE=true
  )
)

:error_report_record
(
    if exist "%ProgramFiles(x86)%" (
      echo OS           : Windows XP Vista 7 64 bit
    ) else (
      echo OS           : Windows 2000 XP Vista 7 32 bit
    )
      ver
      echo Version      : %TDENC_NAME%%C_VERSION%
      echo Enc Mode     : %MUX_ANNOUNCE%
      echo %USED_SOFTWARE%
      echo Source Movie : %ORIGINAL_VIDEO%
      echo Source Audio : %ORIGINAL_AUDIO%
      echo File Format  : %C_FORMAT%
      echo Video Format : "%V_Format%"
      echo Video Codec  : "%V_CODEC%"
      echo VideoBitrate : %S_V_BITRATE% kbps
      echo FPS MODE     : %FPS_MODE%
      echo x264 ref     : %REFVALUE%
      echo x264 bframes : %BFRAMEVALUE%
      echo x264 keyint  : %KEYINTVALUE%
      echo Audio Format : "%AUDIO_FORMAT%"
      echo Audio Codec  : "%AUDIO_CODEC%"
      echo AudioBitRate : %INPUT_A_BITRATE% kbps
      echo AudioChannels: %AUDIO_CHANNELS%
      echo Sampling rate: %SAMPLERATE% Hz
      echo FileSize     : %INPUT_FILE_SIZE% byte
      echo PlayTime     : %TOTAL_TIME% ms
      if defined INPUT_FPS (
        if /i "%FPS_MODE%"=="VFR" (
           echo FPS          : %INPUT_FPS% fps^(VFR^)
        ) else (
           echo FPS          : %INPUT_FPS% fps^(CFR^)
        )
      ) else (
         echo FPS          : %AVS_FPS% fps^(CFR^) ^(from Avisynth^)
      )
      echo WidthxHeight : %IN_WIDTH_MOD% pixels x %IN_HEIGHT% pixels ^(AspectRatio : %D_ASPECT%^)
      if defined SCAN_TYPE echo Scan type    : %SCAN_TYPE%
      if defined SCAN_ORDER echo Scan order   : %SCAN_ORDER%
      echo Decoder      : %DECODER% ^(FFMS=%FFMS_INFO%, AVI=%AVI_INFO%, DIRECTSHOW=%DIRECTSHOW_INFO%, LSMASH=%LSMASH_INFO%, LWLibav=%LWLIBAV_INFO%, QT=%QT_INFO%^)
      echo FFPIPE       : %FFPIPE%
      echo Frames read  : %FRAMES_RECORD%
)>> %ERROR_REPORT%

set FFMS_INFO=
set DIRECTSHOW_INFO=
set AVI_INFO=
set LSMASH_INFO=
set QT_INFO=

:info_check
if not exist %TEMP_DIR%\yv12.txt (
  if /i "%V_CODEC:~0,3%"=="AMV" (
     echo;
     echo %AMV_INSTALL1%
     echo %AMV_INSTALL2%
     echo %AMV_INSTALL3%
     start rundll32 url.dll,FileProtocolHandler "http://www.amarectv.com/"
     call .\quit.bat
     echo;
  )
)
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
)
if not defined KEYINT (
    echo;
    echo ^>^>%DECODE_ERROR3%
    if "%XARCH%"=="64bit" (
      if not exist "%SystemRoot%\SysWOW64\avisynth.dll" (
        echo ^>^>%DECODE_ERROR4%
      )
    ) else (
      if not exist "%SystemRoot%\System32\avisynth.dll" (
        echo ^>^>%DECODE_ERROR4%
       )
    )
    echo ^>^>%DECODE_ERROR5%
    echo ^>^>%DECODE_ERROR6%
    call .\quit.bat
)

rem ################HDD free space check for temp mkv################
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "m2ts mts ts m2t">nul
if ERRORLEVEL 1 goto mux_mode_question
start /min /wait diskspace_check.bat

for /f "tokens=3" %%i in (%TEMP_INFO2%) do set FREESPACE=%%~i

echo %FREESPACE% > %TEMP_INFO%
for %%i IN (%TEMP_INFO%) do set /a FREESPACEO=%%~zi -3

echo %INPUT_FILE_SIZE% > %TEMP_INFO%
for %%i IN (%TEMP_INFO%) do set /a INPUT_FILE_SIZEO=%%~zi -3

set MAKE_MKV=y

if %FREESPACEO% GTR %INPUT_FILE_SIZEO% goto mux_mode_question
set FREESPACE_KB=%FREESPACE:~0,-3%
set /a INPUT_FILE_SIZE_KB=%INPUT_FILE_SIZE:~0,-3% + 100000
if %FREESPACE_KB% GTR %INPUT_FILE_SIZE_KB% goto mux_mode_question

set MAKE_MKV=n

rem ################設定の質問################
:mux_mode_question
echo Decoder        : %DECODER%
echo;
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
call .\setting_question.bat

rem ################エンコ作業開始################
echo;
echo %HORIZON%
echo;

rem ################音声エンコード################

date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "m2ts mts ts m2t">nul
if ERRORLEVEL 1 goto audio_enc

if /i not "%MAKE_MKV%"=="y" goto audio_enc
set TEMP_MKV=movie.mkv
.\mkvmerge -o %TEMP_DIR%\%TEMP_MKV% %INPUT_VIDEO%
set INPUT_FILE_PATH="%TDEDIR%\tool\%TEMP_DIR%\%TEMP_MKV%"
set INPUT_VIDEO=%INPUT_FILE_PATH%

:audio_enc
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
    goto movie_enc2
)

:mux_audio_start
if "%SKIP_A_ENC%"=="true" (
    echo ^>^>%SKIP_A_ENC_ANNOUNCE%
    echo;
    goto movie_enc2
)

if /i "%INPUT_AUDIO_TYPE%"==".wav" (
  (
    echo WavSource^(%INPUT_AUDIO%^)
    echo;
  )> %AUDIO_AVS%
) else (
  (
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    echo DirectShowSource^(%INPUT_AUDIO%, video = false^)
  )> %AUDIO_AVS%
)  

if "%A_GAIN%"=="0" goto close_audio_avs
(
  echo Normalize^(^)
  echo AmplifydB^(%A_GAIN%^)
)>> %AUDIO_AVS%

:close_audio_avs
(
    echo;
    echo return last
)>> %AUDIO_AVS%

echo ^>^>%WAV_ANNOUNCE%
if exist %PROCESS_E_FILE% del /f %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul
.\avs2pipemod.exe -wav %AUDIO_AVS% > %TEMP_WAV% 2>nul

del %PROCESS_S_FILE% 2>nul
:wav_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_process 1>nul 2>&1
del %PROCESS_E_FILE%

call .\m4a_enc.bat

:movie_enc2
rem ################映像エンコード################
if /i "%PRETYPE%"=="s" (
  set TEMP_264=%INPUT_VIDEO%
  goto :eof
)

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

if /i "%DECODER%"=="avi" goto avisource_video
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_video
if /i "%DECODER%"=="directshow" goto directshowsource_video
if /i "%DECODER%"=="ds_input" goto ds_input_video
if /i "%DECODER%"=="LSMASH" goto LSMASHsource_video
if /i "%DECODER%"=="LWLibav" goto LSMASHsource_video2
if /i "%DECODER%"=="qt" goto qtsource_video
if /i "%FFPIPE%"=="y" goto x264_enc_start

:directshowsource_video
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    if "%VFR%"=="true" (
        echo DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=false^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:ds_input_video
(
    if "%VFR%"=="true" (
        echo LoadPlugin^("DirectShowSource.dll"^)
        echo;
        echo DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo LoadPlugin^("warpsharp.dll"^) 
        echo LoadAviUtlInputPlugin^("ds_input.aui", "DS_AVIUTL"^)
        echo DS_AVIUTL^(%INPUT_VIDEO%^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:qtsource_video
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_VIDEO%, quality = 100, audio = 0^)
)> %VIDEO_AVS%
goto vbr_avs

:avisource_video
if /i not "%RGB%"=="true" (
    if "%IMAGE_SIZE_ERROR%"=="t" (
       echo AVISource^(%INPUT_VIDEO%, audio = false, pixel_type="YUY2"^)> %VIDEO_AVS%
    ) else (
       echo AVISource^(%INPUT_VIDEO%, audio = false^)> %VIDEO_AVS%
    )
) else (
    echo AVISource^(%INPUT_VIDEO%, audio = false^)> %VIDEO_AVS%
)
goto vbr_avs

:LSMASHsource_video
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    if "%SCAN_TYPE%"=="Interlaced" (
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if "%SCAN_TYPE%"=="MBAFF" (
      echo LSMASHVideoSource^(%INPUT_VIDEO%, track=0, threads=0, seek_threshold=10, seek_mode=0^)
    ) else if /i "%DEINT%"=="y" (
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if /i "%DEINT%"=="d" (
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else (
rem dr=trueにするなら、後でcropしないとダメ
rem      echo LSMASHVideoSource^(%INPUT_VIDEO%, track=0, threads=0, seek_threshold=10, seek_mode=0, dr=true^)
      echo LSMASHVideoSource^(%INPUT_VIDEO%, track=0, threads=0, seek_threshold=10, seek_mode=0^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:LSMASHsource_video2
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    if "%SCAN_TYPE%"=="Interlaced" (
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if "%SCAN_TYPE%"=="MBAFF" (
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0^)
    ) else if /i "%DEINT%"=="y" (
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if /i "%DEINT%"=="d" (
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else (
rem dr=trueにするなら、後でcropしないとダメ
rem      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=true, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, dr=true^)
      echo LWLibavVideoSource^(%INPUT_VIDEO%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:ffmpegsource_video
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "avi mkv mp4 flv">nul
if not ERRORLEVEL 1 (
    set SEEKMODE=1
    ffmsindex.exe -m default -f %INPUT_VIDEO% %TEMP_DIR%\input.ffindex
) else (
    set SEEKMODE=-1
    ffmsindex.exe -m lavf -f %INPUT_VIDEO% %TEMP_DIR%\input.ffindex
)
echo;
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo fps_num = Int^(%FPS% * 1000^)
    if not "%VFR%"=="true" (
        echo FFVideoSource^(%INPUT_VIDEO%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1^)
    ) else if "%CHANGE_FPS%"=="true" (
        echo FFVideoSource^(%INPUT_VIDEO%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1,fpsnum=fps_num, fpsden=1000^)
    ) else (
        echo FFVideoSource^(%INPUT_VIDEO%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1^)
    )
)> %VIDEO_AVS%

:vbr_avs
echo;>> %VIDEO_AVS%
if "%ABITRATE_MODE%"=="VBR" (
    if /i not "%A_SYNC%"=="n" (
    echo EnsureVBRMP3Sync^(^)>> %VIDEO_AVS%
    )
)
echo;>> %VIDEO_AVS%
if /i "%DEINT%"=="a" (
    set BOB=false
    if "%SCAN_TYPE%"=="Interlaced" goto interlace
    if "%SCAN_TYPE%"=="MBAFF" goto interlace
) else if /i "%DEINT%"=="b" (
    set BOB=true
    set /a FRAMES=%FRAMES% * 2
    if "%SCAN_TYPE%"=="Interlaced" goto interlace
    if "%SCAN_TYPE%"=="MBAFF" goto interlace
) else if /i "%DEINT%"=="d" (
    set BOB=true
    set /a FRAMES=%FRAMES% * 2
    goto interlace
) else if /i "%DEINT%"=="y" (
    set BOB=false
    goto interlace
)

rem プログレッシブ
if /i "%YV12%"=="true" goto fps_avs
if "%IN_WIDTH_ODD%"=="1" (
    if "%IN_HEIGHT_ODD%"=="1" (
        echo Crop^(0,0,-1,-1^)>> %VIDEO_AVS%
    ) else (
        echo Crop^(0,0,-1,0^)>> %VIDEO_AVS%
    )
) else if "%IN_HEIGHT_ODD%"=="1" echo Crop^(0,0,0,-1^)>> %VIDEO_AVS%

echo ConvertToYV12^(%AVS_SCALE%interlaced=false^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
goto fps_avs

rem インターレース
:interlace
if "%BOB%"=="true" (
    if not defined DEFAULT_FPS (
      set CHANGE_FPS=true
      set FPS=%FPS2%
    )
    set YADIF_MODE=1
) else (
    set YADIF_MODE=0
)
echo Load_Stdcall_Plugin^("yadif.dll"^)>> %VIDEO_AVS%
if /i "%YV12%"=="true" goto yadif
echo ConvertToYV12^(%AVS_SCALE%interlaced=true^)>> %VIDEO_AVS%
echo;>> %VIDEO_AVS%
:yadif
if "%SCAN_TYPE%"=="MBAFF" (
    echo Yadif^(mode=%YADIF_MODE%,order=1^)>> %VIDEO_AVS%
    goto fps_avs
)
if "%SCAN_ORDER%"=="Top" (
    echo Yadif^(mode=%YADIF_MODE%,order=1^)>> %VIDEO_AVS%
    goto fps_avs
)
if "%SCAN_ORDER%"=="Bottom" (
    echo Yadif^(mode=%YADIF_MODE%,order=0^)>> %VIDEO_AVS%
    goto fps_avs
)
echo Yadif^(mode=%YADIF_MODE%,order=-1^)>> %VIDEO_AVS%

:fps_avs
if not defined RESIZER set RESIZER=Spline16Resize
(
    echo;
    if "%CHANGE_FPS%"=="true" (
    	echo ChangeFPS^(%FPS%^)
    ) else if "%ASSUME_FPS%"=="true" (
    	echo AssumeFPS^(%FPS%^)
    )
    echo;
    if not "%IN_WIDTH%"=="%WIDTH%" echo %RESIZER%^(%WIDTH%,last.height^(^)^)
    if not "%IN_HEIGHT%"=="%HEIGHT%" echo %RESIZER%^(last.width^(^),%HEIGHT%^)
    echo;
    echo return last
)>> %VIDEO_AVS%

echo ^>^>%AVS_END%
echo;

:x264_enc_start
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

if /i "%ACTYPE%"=="y" (
  if "%PRESET_S_ENABLE%"=="false" goto :eof
) else if /i "%ACTYPE%"=="n" (
  if "%PRESET_SI_ENABLE%"=="false" goto :eof 
)

if /i "%FFPIPE%"=="y" goto :eof

if not "%PRETYPES_TEST%"=="y" goto :eof
if "%HARUMODE%"=="false" (
  if "%BEGINNER%"=="false" goto :eof
)
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i/(%TOTAL_TIME%/8)

set /a S_V_BITRATE_L=%S_V_BITRATE% * 105 / 100

if %TEMP_264_BITRATE% GTR %S_V_BITRATE_L% (
   echo;
   echo %BITRATE_OVER1%: %S_V_BITRATE% kbps
   echo %BITRATE_OVER2%: %TEMP_264_BITRATE% kbps
   echo %PRETYPES4%
   echo %BITRATE_OVER3%
   echo;
   set TEMP_264=%INPUT_VIDEO%
   if /i "%VOICE%"=="true" (
     if exist "..\Extra\Voice\%VOICE_DIR%\PRETYPES4.mp3" (
       %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PRETYPES4.mp3"
     ) else if exist "..\Extra\Voice\%VOICE_DIR%\PRETYPES4.wav" (
       %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PRETYPES4.wav"
     )
   )
)
