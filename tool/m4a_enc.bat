set AAC_ENC=first
set NEW_SAMPLERATE=

rem from 1.100 
if %TOTAL_TIME% GTR 600000 set TRIM_AUDIO=false
if not defined INPUT_FILESIZE_MB1 set INPUT_FILESIZE_MB1=0

if %INPUT_FILESIZE_MB1% GTR 2147 (
  set TRIM_AUDIO=false
)
:audio_encoder_select
if /i not "%AAC_ENCODER%"=="auto" goto audio_encoder_select_fin
if "%XARCH%"=="64bit" (
	if exist "%ProgramFiles(x86)%\Common Files\Apple\Apple Application Support\CoreAudioToolbox.dll" (
		set AAC_ENCODER=qt
	) else set AAC_ENCODER=nero
) else (
	if exist "%ProgramFiles%\Common Files\Apple\Apple Application Support\CoreAudioToolbox.dll" (
		set AAC_ENCODER=qt
	) else set AAC_ENCODER=nero
)

:audio_encoder_select_fin
if not exist %TEMP_WAV% goto wav_not_exist

.\MediaInfo.exe --Inform=Audio;%%SamplingRate%% --LogFile=%TEMP_INFO% %TEMP_WAV%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a SAMPLERATE=%%i

if not defined SAMPLERATE goto wav_not_exist

if not "%AUDIO_CHANNELS%"=="1" goto samplerate_check_end
if /i "%AAC_PROFILE%"=="lc" goto samplerate_check_end
if /i "%AAC_PROFILE%"=="auto" (
  if %A_BITRATE% GTR 96 goto samplerate_check_end
)
if %SAMPLERATE% LSS 16000 set /a NEW_SAMPLERATE=%SAMPLERATE% * 2

:samplerate_check_end
rem 音声エンコード
if /i "%AAC_PROFILE%"=="auto" (
    if %A_BITRATE% LEQ 32 (
        set AAC=-hev2
        if "%AUDIO_CHANNELS%"=="1" (
            set MONOAUDIO=true
        )
    ) else if %A_BITRATE% LEQ 96 (
        set AAC=-he
    ) else (
        set AAC=-lc
    )
) else if /i "%AAC_PROFILE%"=="he" (
    set AAC=-he
) else if /i "%AAC_PROFILE%"=="hev2" (
    if "%AUDIO_CHANNELS%"=="2" (
        set AAC=-hev2
        if "%AUDIO_CHANNELS%"=="1" (
            set MONOAUDIO=true
        )
    )
) else (
    set AAC=-lc
)

:audio_length_trim
if /i "%DECODER%"=="avi" goto avisource_audio
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_audio
if /i "%DECODER%"=="directshow" goto directshowsource_audio
if /i "%DECODER%"=="LSMASH" goto LSMASHsource_audio
if /i "%DECODER%"=="LWLibav" goto LSMASHsource_audio2
if /i "%DECODER%"=="qt" goto qtsource_audio

:directshowsource_audio
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    if "%VFR%"=="true" (
        echo vidoe = DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=true^)
    ) else (
        echo video = DirectShowSource^(%INPUT_VIDEO%, audio = false, fps=%INPUT_FPS%, convertfps=false^)
    )
)> %AUDIO_AVS2%
goto samplerate_check

:qtsource_audio
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo video = QTInput^(%INPUT_VIDEO%, quality = 100, audio = 0^)
)> %AUDIO_AVS2%
goto samplerate_check

:avisource_audio
if /i not "%RGB%"=="true" (
    if "%IMAGE_SIZE_ERROR%"=="t" (
       echo video=AVISource^(%INPUT_FILE_PATH%, audio=false, pixel_type="YUY2"^)> %AUDIO_AVS2%
    ) else (
       echo video=AVISource^(%INPUT_FILE_PATH%, audio=false^)> %AUDIO_AVS2%
    )
) else (
    echo video=AVISource^(%INPUT_FILE_PATH%, audio=false^)> %AUDIO_AVS2%
)
goto samplerate_check

:LSMASHsource_audio
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    echo video=LSMASHVideoSource^(%INPUT_FILE_PATH%, track=0, threads=0, seek_threshold=10, seek_mode=0^)
)> %AUDIO_AVS2%
goto samplerate_check

:LSMASHsource_audio2
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo;
    echo video=LWLibavVideoSource^(%INPUT_FILE_PATH%, cache=false, stream_index=-1, threads=0, seek_threshold=10, seek_mode=0^)
)> %AUDIO_AVS2%
goto samplerate_check

:ffmpegsource_audio
if exist %TEMP_DIR%\input.ffindex goto ffmpegsource_audio2
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "avi mkv mp4 flv">nul
if not ERRORLEVEL 1 (
    set SEEKMODE=1
    ffmsindex.exe -m default -f %INPUT_VIDEO% %TEMP_DIR%\input.ffindex
) else (
    set SEEKMODE=-1
    ffmsindex.exe -m lavf -f %INPUT_VIDEO% %TEMP_DIR%\input.ffindex
)
:ffmpegsource_audio2
echo;
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo fps_num = Int^(%FPS% * 1000^)
    if "%VFR%"=="true" (
        echo video = FFVideoSource^(%INPUT_VIDEO%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1^)
    ) else (
        echo video = FFVideoSource^(%INPUT_VIDEO%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1,fpsnum=fps_num,fpsden=1000^)
    )
)> %AUDIO_AVS2%

:samplerate_check

if %SAMPLERATE% GTR %MAX_SAMPLERATE% (
    echo %SAMPLERATE_ALERT%
    echo Original  : %SAMPLERATE% bps
    echo Converted : %MAX_SAMPLERATE% bps
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\SAMPLERATE_ALERT.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SAMPLERATE_ALERT.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\SAMPLERATE_ALERT.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SAMPLERATE_ALERT.wav"
        )
      )
rem    )
)

(
    echo WAVSource^("%TEMP_WAV%"^)
    echo;
    if %SAMPLERATE% GTR %MAX_SAMPLERATE% (
       echo AutoResample^(%MAX_SAMPLERATE%^)
       echo;
       type resample_function.txt
    ) else if defined NEW_SAMPLERATE (
       echo AutoResample^(%NEW_SAMPLERATE%^)
       echo;
       type resample_function.txt
    )
    if "%MONOAUDIO%"=="true" (
       echo l_ch = GetChannel^(1^)
       echo MergeChannels^(l_ch, l_ch^)
       echo;
    )
    echo return last
)> %AUDIO_AVS%

:audio_sync
if /i "%A_SYNC%"=="n" (
   if /i not "%TRIM_AUDIO%"=="true" (
     .\avs2pipemod.exe -wav %AUDIO_AVS% > %FINAL_WAV%
    goto m4a_encode
   )
   (
   echo audio = WAVSource^("%TEMP_WAV%"^)
   echo;
     if %SAMPLERATE% GTR %MAX_SAMPLERATE% (
       echo AutoResample^(audio,%MAX_SAMPLERATE%^)
       echo;
       type resample_function.txt
     ) else if defined NEW_SAMPLERATE (
       echo AutoResample^(audio,%NEW_SAMPLERATE%^)
       echo;
       type resample_function.txt
     )
   echo;
   if "%MONOAUDIO%"=="true" (
     echo l_ch = GetChannel^(audio, 1^)
     echo stereo = MergeChannels^(l_ch, l_ch^)
     echo AudioDub^(video, stereo^)
   ) else  echo AudioDub^(video, audio^)
   echo;
   echo Trim^(0,0^)
   echo;
   echo KillVideo^(^)
   echo:
   echo return last
   )>> %AUDIO_AVS2%
     .\avs2pipemod.exe -wav %AUDIO_AVS2% > %FINAL_WAV%
   goto m4a_encode
)
if /i "%A_SYNC%"=="y" goto auto_sync

set M4A_LAG=%A_SYNC%
goto wav_avs

:auto_sync
rem 音ズレ修正
:sync_gap
echo ^>^>%SYNC_ANNOUNCE%
if exist %PROCESS_E_FILE% del /f %PROCESS_E_FILE%
echo s>%PROCESS_S_FILE%
start /b process.bat 2>nul
rem if /i "%AAC_ENCODER%"=="nero" (
  .\avs2pipemod.exe -wav %AUDIO_AVS% 2>nul | .\neroAacEnc.exe %AAC% -ignorelength -br %A_BITRATE%000 -if - -of %TEMP_M4A% 1>nul 2>&1
rem ) else (
rem   .\avs2pipemod.exe -wav %AUDIO_AVS% 2>nul | %QAAC% -ignorelength --cvbr %A_BITRATE% -o %TEMP_M4A% - 1>nul 2>&1
rem )
.\MediaInfo.exe --Inform=General;%%Duration%% --LogFile=%TEMP_INFO% %TEMP_M4A%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set M4A_TIME=%%i
.\MediaInfo.exe --Inform=General;%%Duration%% --LogFile=%TEMP_INFO% %TEMP_WAV%>nul
for /f "delims=." %%i in (%TEMP_INFO%) do set WAV_TIME=%%i
set /a M4A_LAG_TEMP=%M4A_TIME%-%WAV_TIME%
set /a M4A_LAG=-%M4A_LAG_TEMP%/2
del /f %PROCESS_S_FILE% 2>nul
:sync_process
ping localhost -n 1 >nul
if not exist %PROCESS_E_FILE% goto sync_process 1>nul 2>&1
del /f %PROCESS_E_FILE%

:wav_avs
(
    echo WAVSource^("%TEMP_WAV%"^)
    echo;
    if %SAMPLERATE% GTR %MAX_SAMPLERATE% (
       echo AutoResample^(%MAX_SAMPLERATE%^)
       echo;
       type resample_function.txt
    ) else if defined NEW_SAMPLERATE (
       echo AutoResample^(%NEW_SAMPLERATE%^)
       echo;
       type resample_function.txt
    )
    echo _lag = Float^(%M4A_LAG%^) / 1000
    echo DelayAudio^(_lag^)
    echo;
    if "%MONOAUDIO%"=="true" (
       echo l_ch = GetChannel^(1^)
       echo MergeChannels^(l_ch, l_ch^)
       echo;
    )
    echo return last
)> %AUDIO_AVS%

.\avs2pipemod.exe -wav %AUDIO_AVS% > %TEMP_WAV2%

if /i not "%TRIM_AUDIO%"=="true" (
  set FINAL_WAV=%TEMP_WAV2%
  goto m4a_encode
)

(
    echo audio = WAVSource^("%TEMP_WAV2%"^)
    echo AudioDub^(video, audio^)
    echo;
    echo Trim^(0,0^)
    echo;
    echo KillVideo^(^)
    echo;
    echo return last
)>> %AUDIO_AVS2%

echo ^>^>^(fixed : %M4A_LAG%ms^)
echo;

.\avs2pipemod.exe -wav %AUDIO_AVS2% > %FINAL_WAV%

rem m4aにエンコード
:m4a_encode
if not exist %FINAL_WAV% goto wav_not_exist
echo;
echo ^>^>%WAV_END%
echo;
echo ^>^>%M4A_ENC_ANNOUNCE%
echo;
if /i "%AAC_ENCODER%"=="nero" (
    .\neroAacEnc.exe %AAC% -2pass -br %A_BITRATE%000 -if %FINAL_WAV% -of %TEMP_M4A%
) else if /i "%AAC%"=="-lc" (
rem    .\qtaacenc.exe --highest --cvbr %A_BITRATE% %FINAL_WAV% %TEMP_M4A%
    %QAAC% --cvbr %A_BITRATE% -o %TEMP_M4A% %FINAL_WAV%
) else (
rem    .\qtaacenc.exe --he --highest --cvbr %A_BITRATE% %FINAL_WAV% %TEMP_M4A%
    %QAAC% --he --cvbr %A_BITRATE% -o %TEMP_M4A% %FINAL_WAV%
)

:wav_not_exist
echo;
if not exist %TEMP_M4A% (
    echo ^>^>%WAV_ERROR%
    echo;
    copy /y mute.m4a %TEMP_DIR%\audio.m4a 1>nul 2>&1
    set /a TEMP_M4A_BITRATE=4
rem    if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\WAV_ERROR.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\WAV_ERROR.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\WAV_ERROR.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\WAV_ERROR.wav"
        )
      )
rem    )
    goto :eof
)
echo ^>^>%M4A_SUCCESS%
echo;

if %A_BITRATE% LEQ 4 (
    set /a TEMP_M4A_BITRATE=4
    goto :eof
)

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_M4A%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_M4A_FILESIZE=%%i
set /a TEMP_M4A_BITRATE=%TEMP_M4A_FILESIZE% * 8 / %TOTAL_TIME_SEC% / 1000 2>nul
if not defined TEMP_M4A_BITRATE set /a TEMP_M4A_BITRATE=%TEMP_M4A_FILESIZE%/(%TOTAL_TIME%/8) 2>nul

(
   echo;
   echo #################### Result ####################
   echo actural Audio BR: %TEMP_M4A_BITRATE% kbps
)>> %ERROR_REPORT%
set /a A_BITRATE_L = %A_BITRATE% * 120 / 100

if %TEMP_M4A_BITRATE% LEQ %A_BITRATE_L% goto :eof

if "%AAC_ENC%"=="second" goto :eof

echo;
echo %AUDIO_BITRATE_ERROR1%
echo %AUDIO_BITRATE_ERROR2%
echo;

if exist %TEMP_WAV% del %TEMP_WAV%
if exist %TEMP_M4A% del %TEMP_M4A%

.\ffmpeg.exe -y -i %INPUT_AUDIO% -vn -c:a pcm_s16le %TEMP_WAV%

set AAC_ENC=second

goto audio_length_trim
