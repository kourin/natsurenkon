rem ################変数設定################
set INFO_AVS=%TEMP_DIR%\information.avs
set X264_TC_FILE=%TEMP_DIR%\x264.tc
set FPS=
set TOTAL_TIME=
set A_TOTAL_TIME=
set B_TOTAL_TIME=
set KEYINT=
set WAV_FAIL=
set X264_VFR_ENC=
set AVI1_ERROR=
set MINFO=
set TRIM_AUDIO=false

rem ################動画情報取得################
echo;
echo ^>^>%ANALYZE_ANNOUNCE%
echo;
rem if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ANNOUNCE.wav"
    )
  )
rem )

rem 動画のフォーマット書き出し
.\MediaInfo.exe --Inform=General;%%Format/String%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set C_FORMAT=%%i
.\MediaInfo.exe --Inform=General;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set C_FORMAT2=%%i
.\MediaInfo.exe --Inform=Video;%%Format%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set V_FORMAT=%%i
.\MediaInfo.exe --Inform=Video;%%CodecID/Info%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
if not defined V_CODEC (
  .\MediaInfo.exe --Inform=Video;%%Codec/Info%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
   for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
)
if not defined V_CODEC (
  .\MediaInfo.exe --Inform=Video;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
   for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
)
if not defined V_CODEC (
  .\MediaInfo.exe --Inform=Video;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
   for /f "delims=" %%i in (%TEMP_INFO%) do set V_CODEC=%%i
)
if not defined V_FORMAT (
	if "%ENC_MODE%"=="SEQUENCE" (
		set /a FAILED_MOVIES=%FAILED_MOVIES% + 1
		set DECODE_FAILED=true
		goto :eof
	)
  call .\ffprobe.bat
  goto info_check
)
echo File Format    : "%C_FORMAT%"
echo Video Format   : "%V_FORMAT%"
if defined V_CODEC echo Video Codec    : "%V_CODEC%"
.\MediaInfo.exe --Inform=Audio;%%Format%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_FORMAT=%%i
if defined AUDIO_FORMAT echo Audio Format   : "%AUDIO_FORMAT%"
.\MediaInfo.exe --Inform=Audio;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CODEC=%%i
if defined AUDIO_CODEC echo Audio Codec    : "%AUDIO_CODEC%"
.\MediaInfo.exe --Inform=Audio;%%Channels%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CHANNELS=%%i
if defined AUDIO_CHANNELS (
  if "%AUDIO_CHANNELS%"=="1" (
     echo Audio Type     : %MONAURAL%
  ) else if "%AUDIO_CHANNELS%"=="2" (
     echo Audio Type     : %STEREO%
  ) else (
     echo Audio Channnels: %AUDIO_CHANNELS%
  )
)
.\MediaInfo.exe --Inform=Audio;%%BitRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set ABITRATE_MODE=%%i
if defined ABITRATE_MODE echo AudioBR Mode   : %ABITRATE_MODE%

rem 音声ビットレートの書き出し
.\MediaInfo.exe --Inform=Audio;%%BitRate%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a INPUT_A_BITRATE=%%i /1000 1>nul 2>&1
if defined INPUT_A_BITRATE echo Audio Bitrate  : %INPUT_A_BITRATE% kbps

rem 音声サンプリングレートの書き出し
.\MediaInfo.exe --Inform=Audio;%%SamplingRate%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a SAMPLERATE=%%i
if defined SAMPLERATE echo Sampling rate  : %SAMPLERATE% Hz

rem 動画の容量書き出し
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FILE_SIZE=%%i
echo FileSize       : %INPUT_FILE_SIZE% byte
set INPUT_FILESIZE_MB1=%INPUT_FILE_SIZE:~0,-6%
set INPUT_FILESIZE_MB2=%INPUT_FILE_SIZE:~-6%
if not defined INPUT_FILESIZE_MB1 set INPUT_FILESIZE_MB1=0

rem 再生時間の書き出し
.\MediaInfo.exe --Inform=General;%%Duration%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul

rem 再生時間の設定
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
echo PlayTime       : %TOTAL_TIME% ms

rem フレーム数
.\MediaInfo.exe --Inform=Video;%%FrameCount%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set MFRAMES=%%i
rem echo Frame          : %FRAMES%

rem CFR（固定フレームレート）とVFR（可変フレームレート）の判断
.\MediaInfo.exe --Inform=Video;%%FrameRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set FPS_MODE=%%i
if /i "%FPS_MODE%"=="VFR" goto vfr_info
if not defined FPS_MODE set FPS_MODE=CFR

.\MediaInfo.exe --Inform=Video;%%FrameRate_Mode_Original%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set FPS_MODE_ORIGINAL=%%i
if /i "%FPS_MODE_ORIGINAL%"=="VFR" (
	set FPS_MODE=VFR
	goto vfr_info
)
rem CFRの設定
set VFR=false
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
if defined INPUT_FPS echo Framerate      : %INPUT_FPS%fps^(CFR^)

.\MediaInfo.exe --Inform=Video;%%FrameRate_Original%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set ORIGINAL_FPS=%%i
if defined ORIGINAL_FPS echo ^(Original FPS  : %ORIGINAL_FPS%fps^)

goto fps_main

rem VFRの設定
:vfr_info
set VFR=true
set FPS_CHECK=false
.\MediaInfo.exe --Inform=Video;%%FrameRate%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set INPUT_FPS=%%i
echo Framerate      : %INPUT_FPS%fps^(VFR^)
.\MediaInfo.exe --Inform=Video;%%FrameRate_Minimum%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Minimum FPS    : %%i
.\MediaInfo.exe --Inform=Video;%%FrameRate_Maximum%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
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
.\MediaInfo.exe --Inform=Video;%%Width%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set IN_WIDTH=%%i
echo Width          : %IN_WIDTH%pixels
.\MediaInfo.exe --Inform=Video;%%Height%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a IN_HEIGHT=%%i 1>nul 2>&1
echo Height         : %IN_HEIGHT%pixels

rem アスペクト比
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio/String%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set D_ASPECT=%%i
echo Aspect Ratio   : %D_ASPECT%
.\MediaInfo.exe --Inform=Video;%%PixelAspectRatio%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set P_ASPECT=%%i

rem インターレース関連の設定
:interlace
.\MediaInfo.exe --Inform=Video;%%ScanType%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_TYPE=%%i
if defined SCAN_TYPE echo Scan Type      : %SCAN_TYPE%
.\MediaInfo.exe --Inform=Video;%%ScanOrder%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_ORDER=%%i
if defined SCAN_ORDER echo Scan Order     : %SCAN_ORDER%

rem RGBかYUVか
.\Mediainfo.exe --Inform=Video;%%ColorSpace%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set COLOR_SPACE=%%i

rem 例外処理
rem .\MediaInfo.exe --Inform=General;%%Copyright%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
rem for /f "delims=" %%i in (%TEMP_INFO%) do set COPYRIGHT=%%i
rem if "%COPYRIGHT%"=="SEGA Corporation" set FFPIPE=y

rem .\MediaInfo.exe --Inform=Video;%%ID/String%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
rem for /f "delims=" %%i in (%TEMP_INFO%) do set V_ID=%%i
rem if "%V_FORMAT%"=="MPEG Video" (
rem   if "%V_ID%"=="224 (0xE0)" set FFPIPE=y
)

rem IDRフレーム間の最大間隔・容量上限の設定
if /i "%DECODER%"=="avi" goto avisource_info
if /i "%DECODER%"=="directshow" goto directshowsource_info
if /i "%DECODER%"=="ds_input" goto directshowsource_info
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_info
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
    echo DirectShowSource^(%INPUT_FILE_PATH%, audio = false^)
)> %INFO_AVS%
goto infoavs

:avisource_info
echo AVISource^(%INPUT_FILE_PATH%, audio = false^)> %INFO_AVS%
goto infoavs

:qtsource_info
if "%VFR%"=="true" (
  if not defined X264_VFR_ENC call :vfr_timecode_export
)
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_FILE_PATH%, quality = 100, audio = 0^)
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
    echo LSMASHVideoSource^(%INPUT_FILE_PATH%, track=0, threads=0, seek_threshold=10, seek_mode=0^)
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
    echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0^)
)> %INFO_AVS%

goto infoavs

:ffmpegsource_info
if "%VFR%"=="true" (
  if not defined X264_VFR_ENC call :vfr_timecode_export
)
(
    echo LoadPlugin^("ffms2.dll"^)
    echo FFVideoSource^(%INPUT_FILE_PATH%,seekmode=-1,cache=false,threads=1^)
)> %INFO_AVS%

:infoavs
(
    echo;
    echo _isyv12 = IsYV12^(^)
    echo _isrgb = IsRGB^(^)
    if "%CHANGE_FPS%"=="true" echo ChangeFPS^(%FPS%^)
    echo _fps = Framerate^(^)
    echo _afps2 = String^(Framerate^(^) * 2^)
    if defined FPS (
        echo _keyint = String^(Round^(%FPS%^)^)
        echo _fps2 = String^(%FPS% * 2 ^)
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
    echo _premium_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _normal_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _in_width = String^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT%^)^)
    echo _in_height = Height^(^)
    echo _in_aratio = String^(Ceil^( height^(^) / Float^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT%^)^) * 10000 ^)^)
    echo _hasaudio = HasAudio^(^)
    echo;
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    echo WriteFileStart^("rgb.txt","_isrgb",append = false^)
    echo WriteFileStart^("fps.txt","_fps",append = false^)
    echo WriteFileStart^("afps2.txt","_afps2",append = false^)
    echo WriteFileStart^("frames.txt","_frames",append = false^)
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_max_filesize.txt","_premium_max_filesize",append = false^)
    echo WriteFileStart^("normal_max_filesize.txt","_normal_max_filesize",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_height.txt","_in_height",append = false^)
    echo WriteFileStart^("in_aratio.txt","_in_aratio",append = false^)
    echo WriteFileStart^("hasaudio.txt","_hasaudio",append = false^)
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
for /f "delims=" %%i in (%TEMP_DIR%\fps_check.txt) do set FPS_CHECK=%%i
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
if /i "%DECODER%"=="ffmpeg" (
  set FFMS_INFO=f
  echo ^>^>ffmpegsource %ANALYZE_ERROR2%
)
if /i "%DECODER%"=="avi" (
  set AVI_INFO=f
  echo ^>^>avi %ANALYZE_ERROR2%
)
if /i "%DECODER%"=="directshow" (
  set DIRECTSHOW_INFO=f
  echo ^>^>directshow %ANALYZE_ERROR2%
)
if /i "%DECODER%"=="ds_input" (
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
if /i "%DECODER%"=="qt" (
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
if not "%DIRECTSHOW_INFO%"=="f" (
  set DECODER=directshow
  echo ^>^>%ANALYZE_ERROR3%
  goto directshowsource_info
)
if not "%AVI_INFO%"=="f" (
  set DECODER=avi
  echo ^>^>%ANALYZE_ERROR3%
  goto avisource_info
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
					if "%ENC_MODE%"=="SEQUENCE" (
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
for /f "delims=" %%i in (%TEMP_DIR%\fps.txt) do set AVS_FPS=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\afps2.txt) do set AVS_FPS2=%%i>nul
if defined FPS (
  for /f "delims=" %%i in (%TEMP_DIR%\fps2.txt) do set FPS2=%%i>nul
)
for /f "delims=" %%i in (%TEMP_DIR%\frames.txt) do set FRAMES=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=%%i*10>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_max_filesize.txt) do set /a P_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_max_filesize.txt) do set /a I_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set IN_WIDTH_MOD=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\in_aratio.txt) do set /a IN_ARATIO=%%i>nul
if not defined IN_HEIGHT (
  for /f "delims=" %%i in (%TEMP_DIR%\in_height.txt) do set IN_HEIGHT=%%i>nul
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
if not "%MINFO%"=="wrong" (
	if %FRAME_DIFF% GTR 20 (
		set AVI1_ERROR=true
		goto decoder_reselect
	) else if %FRAME_DIFF% LSS -20 (
		set AVI1_ERROR=true
		goto decoder_reselect
	)
)

:framecheck_fin
date /t>nul
"%WINDIR%\system32\findstr.exe" /i "false" "%TEMP_DIR%\hasaudio.txt">nul 2>&1
if not ERRORLEVEL 1 (
  if "%INPUT_A_BITRATE%"=="0" (
    set SILENT=true
    set /a TEMP_BITRATE=0
    if defined ABITRATE_MODE set AUTOBITRATEOFF=y
  ) else if "%INPUT_A_BITRATE%"=="" (
    set SILENT=true
    set /a TEMP_BITRATE=0
    if defined ABITRATE_MODE set AUTOBITRATEOFF=y
  ) else (
    set SILENT=false
  )
) else (
  set SILENT=false
)

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
   ver
   echo Version      : %TDENC_NAME%%C_VERSION%
   echo %USED_SOFTWARE%
   if "%ENC_MODE%"=="SEQUENCE" (
      echo Enc Mode     : %SEQUENCE_ANNOUNCE%
   ) else (
      echo Enc Mode     : %ONE_MOVIE_ANNOUNCE%
   )
   echo Source Movie : %ORIGINAL_VIDEO%
   echo File Format  : %C_FORMAT%
   echo Video Format : "%V_FORMAT%"
   echo Video Codec  : "%V_CODEC%"
   echo FPS MODE     : %FPS_MODE%
   echo Audio Format : "%AUDIO_FORMAT%"
   echo Audio Codec  : "%AUDIO_CODEC%"
   echo AudioBR Mode : %ABITRATE_MODE%
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
   echo WidthxHeight : %IN_WIDTH% pixels x %IN_HEIGHT% pixels
   echo AspectRatio  : %D_ASPECT%
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
rem if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav"
    )
  )
rem )
    call .\quit.bat
    echo;
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
    goto conv_ask
)

goto diskspace_test

:conv_ask
echo ^>^>%ANALYZE_ERROR1%
echo;
rem if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_ERROR1.wav"
    )
  )
rem )
call .\quit.bat
echo;

:ffmpegpipemode
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo;
    echo _keyint = String^(Round^(%FPS%^)^)
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM% * 0.99^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL% * 0.99^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM%^) * 1024 * 1024^)^)
    echo _normal_max_filesize = String^(Floor^(Float^(%DEFAULT_SIZE_NORMAL%^) * 1024 * 1024^)^)
    echo _youtube_partner_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_PARTNER%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _youtube_normal_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_YOUTUBE_NORMAL%^) * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _in_width = String^(Floor^(Float^(%IN_WIDTH%^) * %P_ASPECT%^)^)
    echo _in_aratio = String^(Ceil^(height^(^) / ^(%IN_WIDTH% * %P_ASPECT% ^)* 10000 ^)^)
    echo;
    echo WriteFileStart^("keyint.txt","_keyint",append = false^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("normal_bitrate.txt","_normal_bitrate",append = false^)
    echo WriteFileStart^("premium_max_filesize.txt","_premium_max_filesize",append = false^)
    echo WriteFileStart^("normal_max_filesize.txt","_normal_max_filesize",append = false^)
    echo WriteFileStart^("youtube_partner_bitrate.txt","_youtube_partner_bitrate",append = false^)
    echo WriteFileStart^("youtube_normal_bitrate.txt","_youtube_normal_bitrate",append = false^)
    echo WriteFileStart^("in_width.txt","_in_width",append = false^)
    echo WriteFileStart^("in_aratio.txt","_in_aratio",append = false^)
    echo;
    echo Trim^(0,-1^)
    echo;
    echo return last
)>> %INFO_AVS%

.\avs2pipemod.exe -info %INFO_AVS% 1>nul 2>&1

for /f "delims=" %%i in (%TEMP_DIR%\keyint.txt) do set /a KEYINT=%%i*10>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_bitrate.txt) do set /a I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_max_filesize.txt) do set /a P_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\normal_max_filesize.txt) do set /a I_MAX_FILESIZE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_partner_bitrate.txt) do set /a Y_P_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\youtube_normal_bitrate.txt) do set /a Y_I_TEMP_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\in_width.txt) do set IN_WIDTH_MOD=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\in_aratio.txt) do set /a IN_ARATIO=%%i>nul

if not defined FPS set FPS=%AVS_FPS%

rem ################HDD free space check for temp mkv################
:diskspace_test
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "m2ts mts ts m2t">nul
if ERRORLEVEL 1 goto movie_mode_question
start /min /wait diskspace_check.bat

for /f "tokens=3" %%i in (%TEMP_INFO2%) do set FREESPACE=%%~i

echo %FREESPACE% > %TEMP_INFO%
for %%i IN (%TEMP_INFO%) do set /a FREESPACEO=%%~zi -3

echo %INPUT_FILE_SIZE% > %TEMP_INFO%
for %%i IN (%TEMP_INFO%) do set /a INPUT_FILE_SIZEO=%%~zi -3

set MAKE_MKV=y

if %FREESPACEO% GTR %INPUT_FILE_SIZEO% goto movie_mode_question
set FREESPACE_KB=%FREESPACE:~0,-3%
set /a INPUT_FILE_SIZE_KB=%INPUT_FILE_SIZE:~0,-3% + 200000
if %FREESPACE_KB% GTR %INPUT_FILE_SIZE_KB% goto movie_mode_question

set MAKE_MKV=n

rem ################設定の質問################
:movie_mode_question
echo Decoder        : %DECODER%
echo;
echo ^>^>%ANALYZE_END%
echo;
echo;
rem if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ANALYZE_END.wav"
    )
  )
rem )

call .\setting_question.bat

rem ################エンコ作業開始################
echo;
echo %HORIZON%
echo;

rem ################音声エンコード################
if "%SKIP_A_ENC%"=="true" (
	set TEMP_M4A=%INPUT_AUDIO%"
)

date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".m2ts .mts .ts .m2t">nul
if ERRORLEVEL 1 goto audio_enc

if /i not "%MAKE_MKV%"=="y" goto audio_enc
set TEMP_MKV=movie.mkv
.\mkvmerge -o %TEMP_DIR%\%TEMP_MKV% %INPUT_FILE_PATH%
set INPUT_FILE_PATH="%TDEDIR%\tool\%TEMP_DIR%\%TEMP_MKV%"
set INPUT_VIDEO=%INPUT_FILE_PATH%

:audio_enc
echo ^>^>%AUDIO_ENC_ANNOUNCE%
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_ENC_ANNOUNCE.wav"
  )
)
:silent
if "%SILENT%"=="true" set A_BITRATE=0
if "%A_BITRATE%"=="0" (
    echo ^>^>%SILENCE_ANNOUNCE%
    echo;
    copy /y mute.m4a %TEMP_DIR%\audio.m4a 1>nul 2>&1
    set /a TEMP_M4A_BITRATE=4
    set KEEPWAV=n
    goto movie_enc
)

if "%SKIP_A_ENC%"=="true" (
    echo ^>^>%SKIP_A_ENC_ANNOUNCE%
    echo;
    goto movie_enc
)

echo ^>^>%WAV_ANNOUNCE%
echo;

:audio_decoder_select
if "%AUDIO_CODEC%"=="129" goto ffmpeg_audio
if /i "%DECODER%"=="avi" goto avisource_audio
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_audio
if /i "%DECODER%"=="directshow" goto directshowsource_audio
if /i "%DECODER%"=="ds_input" goto directshowsource_audio
if /i "%DECODER%"=="LSMASH" goto LSMASHsource_audio
if /i "%DECODER%"=="LWLibav" goto LSMASHsource_audio2
if /i "%DECODER%"=="qt" goto qtsource_audio
if /i "%DECODER%"=="swf" goto swf_audio

:directshowsource_audio
set A_DECODER=directshow
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    echo DirectShowSource^(%INPUT_FILE_PATH%, video = false^)
)> %AUDIO_AVS%
goto temp_wav

:qtsource_audio
set A_DECODER=qt
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_FILE_PATH%, quality = 100, audio = 1^)
    echo;
    echo return last
)> %AUDIO_AVS%
goto temp_wav

:avisource_audio
set A_DECODER=avi
if not "%AUDIO_FORMAT%"=="PCM" goto directshowsource_audio 
(
    echo AVISource^(%INPUT_FILE_PATH%, audio = true^)
)> %AUDIO_AVS%
goto temp_wav

:LSMASHsource_audio
set A_DECODER=LSMASH
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    echo LSMASHAudioSource^(%INPUT_FILE_PATH%^)
)> %AUDIO_AVS%
goto temp_wav

:LSMASHsource_audio2
set A_DECODER=LWLibav
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    echo LWLibavAudioSource^(%INPUT_FILE_PATH%, cache=false^)
)> %AUDIO_AVS%
goto temp_wav

:ffmpegsource_audio
set A_DECODER=ffmpeg
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "avi mkv mp4 flv">nul
if not ERRORLEVEL 1 (
    set SEEKMODE=1
    ffmsindex.exe -m default -f %INPUT_FILE_PATH% %TEMP_DIR%\input.ffindex
) else (
    set SEEKMODE=-1
    ffmsindex.exe -m lavf -f %INPUT_FILE_PATH% %TEMP_DIR%\input.ffindex
)
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo FFAudioSource^(%INPUT_FILE_PATH%, cachefile="input.ffindex"^)
)> %AUDIO_AVS%
goto temp_wav

:swf_audio
set A_DECODER=swf
.\swfextract.exe -m %INPUT_FILE_PATH% -o %TEMP_MP3%
.\ffmpeg.exe -y -i %TEMP_MP3% -vn -c:a pcm_s16le %TEMP_WAV%
for %%i in (%TEMP_WAV%) do if %%~zi EQU 0 goto audio_fail
goto ffmpeg_wav_check

:ffmpeg_audio
set A_DECODER=ffmpegexe
.\ffmpeg.exe -y -i %INPUT_FILE_PATH% -vn -c:a pcm_s16le %TEMP_WAV%
for %%i in (%TEMP_WAV%) do if %%~zi EQU 0 goto audio_fail

rem 出力した音声の確認
:ffmpeg_wav_check
.\MediaInfo.exe --Inform=Audio;%%Duration%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set A_TOTAL_TIME=%%i

.\MediaInfo.exe --Inform=Audio;%%Duration%% --LogFile=%TEMP_INFO% %TEMP_WAV%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set B_TOTAL_TIME=%%i

if not defined A_TOTAL_TIME (
  set A_BITRATE=0
  goto audio_fail
)
if not defined B_TOTAL_TIME goto audio_fail

set /a B_TOTAL_TIME_MAX=%A_TOTAL_TIME% /2*3
set /a B_TOTAL_TIME_MIN=%A_TOTAL_TIME% /5*3
if %B_TOTAL_TIME% GTR %B_TOTAL_TIME_MAX% goto audio_fail
if %B_TOTAL_TIME% LSS %B_TOTAL_TIME_MIN% goto audio_fail
if "%A_GAIN%"=="0" goto m4a_enc_start

(
  echo WavSource^("%TEMP_WAV%"^)
  echo;
  echo Normalize^(^)
  echo AmplifydB^(%A_GAIN%^)
  echo;
  echo return last
)> %AUDIO_AVS%

echo ^>^>%WAV_ANNOUNCE%
.\avs2pipemod.exe -wav %AUDIO_AVS% > %TEMP_WAV3% 2>nul
set TEMP_WAV=%TEMP_WAV3%

echo;

goto m4a_enc_start

:temp_wav
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

if exist %PROCESS_E_FILE% del /f %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul

.\avs2pipemod.exe -wav %AUDIO_AVS% > %TEMP_WAV% 2>nul
:temp_wav_check
for %%i in (%TEMP_WAV%) do if %%~zi EQU 0 goto audio_fail

.\MediaInfo.exe --Inform=Audio;%%Duration%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set A_TOTAL_TIME=%%i

.\MediaInfo.exe --Inform=Audio;%%Duration%% --LogFile=%TEMP_INFO% %TEMP_WAV%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set B_TOTAL_TIME=%%i

if not defined A_TOTAL_TIME (
  set A_BITRATE=0
  goto silent
)
if not defined B_TOTAL_TIME goto audio_fail

set /a B_TOTAL_TIME_MAX=%A_TOTAL_TIME% /2*3
set /a B_TOTAL_TIME_MIN=%A_TOTAL_TIME% /5*3
if %B_TOTAL_TIME% GTR %B_TOTAL_TIME_MAX% goto audio_fail
if %B_TOTAL_TIME% LSS %B_TOTAL_TIME_MIN% goto audio_fail
goto wav_process

:audio_fail
if "%A_DECODER%"=="avi" set AVI_AUDIO=f
if "%A_DECODER%"=="ffmpeg" set FFMPEG_AUDIO=f
if "%A_DECODER%"=="directshow" set DIRECTSHOW_AUDIO=f
if "%A_DECODER%"=="LSMASH" set LSMASH_AUDIO=f
if "%A_DECODER%"=="LWLibav" set LWLibav_AUDIO=f
if "%A_DECODER%"=="qt" set QT_AUDIO=f
if "%A_DECODER%"=="ffmpegexe" set FFMPEGEXE_AUDIO=f
rem if "%A_DECODER%"=="swf" goto silent

if not "%FFMPEGEXE_AUDIO%"=="f" (
  del /f %PROCESS_S_FILE% 2>nul
  echo;
  echo %ANALYZE_ERROR3%
  echo;
  goto ffmpeg_audio
)
if not "%LWLIbav_AUDIO%"=="f" goto LSMASHsource_audio2
if not "%DIRECTSHOW_AUDIO%"=="f" goto directshowsource_audio


:wav_process
del /f %PROCESS_S_FILE% 2>nul
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto wav_process 
del /f %PROCESS_E_FILE% 2>nul

:m4a_enc_start
del /f %PROCESS_S_FILE% 2>nul
del /f %PROCESS_E_FILE% 2>nul
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

if /i "%DECODER%"=="avi" goto avisource_video
if /i "%DECODER%"=="LSMASH" goto LSMASHsource_video
if /i "%DECODER%"=="LWLibav" goto LSMASHsource_video2
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_video
if /i "%DECODER%"=="directshow" goto directshowsource_video
if /i "%DECODER%"=="ds_input" goto ds_input_video
if /i "%DECODER%"=="qt" goto qtsource_video
if /i "%DECODER%"=="swf" goto swf_video
if /i "%FFPIPE%"=="y" goto x264_enc_start

:directshowsource_video
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    if "%VFR%"=="true" (
        echo DirectShowSource^(%INPUT_FILE_PATH%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo DirectShowSource^(%INPUT_FILE_PATH%, audio = false, fps=%INPUT_FPS%, convertfps=false^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:ds_input_video
(
    if "%VFR%"=="true" (
        echo LoadPlugin^("DirectShowSource.dll"^)
        echo;
        echo DirectShowSource^(%INPUT_FILE_PATH%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo LoadPlugin^("warpsharp.dll"^) 
        echo LoadAviUtlInputPlugin^("ds_input.aui", "DS_AVIUTL"^)
        echo DS_AVIUTL^(%INPUT_FILE_PATH%^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:swf_video
(
        echo LoadPlugin^("warpsharp.dll"^) 
        echo LoadAviUtlInputPlugin^("swf.vfp", "SWF_AVIUTL"^)
        echo SWF_AVIUTL^(%INPUT_FILE_PATH%^)
)> %VIDEO_AVS%
goto vbr_avs

:qtsource_video
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_FILE_PATH%, quality = 100, audio = 0^)
)> %VIDEO_AVS%
goto vbr_avs

:avisource_video
if /i not "%RGB%"=="true" (
    if "%IMAGE_SIZE_ERROR%"=="t" (
       echo AVISource^(%INPUT_FILE_PATH%, audio = false, pixel_type="YUY2"^)> %VIDEO_AVS%
    ) else (
       echo AVISource^(%INPUT_FILE_PATH%, audio = false^)> %VIDEO_AVS%
    )
) else (
    echo AVISource^(%INPUT_FILE_PATH%^)> %VIDEO_AVS%
)
goto vbr_avs

:LSMASHsource_video
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    if "%SCAN_TYPE%"=="Interlaced" (
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if "%SCAN_TYPE%"=="MBAFF" (
      echo LSMASHVideoSource^(%INPUT_FILE_PATH%, track=0, threads=0, seek_threshold=10, seek_mode=0^)
    ) else if /i "%DEINT%"=="y" (
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if /i "%DEINT%"=="d" (
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else (
rem dr=trueにするなら、後でcropしないとダメ
rem      echo LSMASHVideoSource^(%INPUT_FILE_PATH%, track=0, threads=0, seek_threshold=10, seek_mode=0, dr=true^)
      echo LSMASHVideoSource^(%INPUT_FILE_PATH%, track=0, threads=0, seek_threshold=10, seek_mode=0^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:LSMASHsource_video2
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    if "%SCAN_TYPE%"=="Interlaced" (
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if "%SCAN_TYPE%"=="MBAFF" (
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0^)
    ) else if /i "%DEINT%"=="y" (
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else if /i "%DEINT%"=="d" (
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, repeat=true^)
    ) else (
rem      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=true, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0, dr=true^)
      echo LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0^)
    )
)> %VIDEO_AVS%
goto vbr_avs

:ffmpegsource_video
if exist %TEMP_DIR%\input.ffindex goto ffmpegsource_video2
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "avi mkv mp4 flv">nul
if not ERRORLEVEL 1 (
    set SEEKMODE=1
    ffmsindex.exe -m default -f %INPUT_FILE_PATH% %TEMP_DIR%\input.ffindex
) else (
    set SEEKMODE=-1
    ffmsindex.exe -m lavf -f %INPUT_FILE_PATH% %TEMP_DIR%\input.ffindex
)
:ffmpegsource_video2
echo;
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo fps_num = Int^(%FPS% * 1000^)
    if "%VFR%"=="true" (
        echo FFVideoSource^(%INPUT_FILE_PATH%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1^)
    ) else (
        echo FFVideoSource^(%INPUT_FILE_PATH%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1,fpsnum=fps_num, fpsden=1000^)
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

exit /b
