@echo off

REM setting
REM 設定を変更したら、アップデート時に上書きされるのを避けるために別名で保存してください。
REM 音声をwavファイルに変換して抽出しますか？するなら、y しないなら、n
set WAV=y

REM 動画の音声を変換なしにそのまま抽出しますか？するなら、y しないなら、n
set AUDIO=n

REM 動画をaviに変換しますか? するなら、y しないなら、n
set MOVIE=n

REM 上記で変換したaviを音声付きにしますか? するなら、y。無音で良いないなら、n
set MOVIE_AUDIO=y

REM 動画のコーデック
rem 「MCODEC=avi」(イントールされているaviで使用可能なコーデックから選択。推奨)
rem 「MCODEC=mjpeg」 （MotionJPEG）、「MCODEC=rawvideo」（非圧縮avi）、「MCODEC=utvideo」 （Ut Video Codec： 可逆圧縮）
rem 「MCODEC=wmv2」 (Windows Media Video 8)
rem 「avi」で可逆圧縮コーデックを選ぶか、rawvideoで無圧縮にすると、この変換では劣化しない
set MCODEC=avi

rem 他にどんなコーデックに出来るかを知りたい時は、下2行の冒頭の「rem」を削除して、このファイルをダブルクリックしてください。
rem ..\tool\ffmpeg.exe -codecs 
rem pause

REM ------------------------------

cd /d %~dp0

if not exist "..\tool\ffmpeg.exe" (
  echo ^>^> 必要なツールがインストールされていません
  echo ^>^> ツールのダウンロードとインストールを行います
  echo ^>^> ENTERキーを押してください
  pause> nul
  call "..\詳細設定モード【ここに動画をD&D】.bat" installonly
)

set INPUT_FILE_PATH="%~1"
set INPUT_FILE_TYPE=%~x1
set INPUT_FILE_NAME=%~n1
set OUT_PATH="%~dp0

if /i "%INPUT_FILE_TYPE%"==".swf" goto swf
if /i "%WAV%"=="y" (
  ..\tool\ffmpeg.exe -y -i "%~1" -vn -c:a pcm_s16le "%OUT_PATH%\%%INPUT_FILE_NAME%_out.wav"
)
if /i not "%AUDIO%"=="y" goto movie
set TEMP_INFO=temp_audio.txt
..\tool\MediaInfo.exe --Inform=Audio;%%Format%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_FORMAT=%%i

if "%AUDIO_FORMAT%"=="MPEG Audio" set AEXT=.mp3
if "%AUDIO_FORMAT%"=="PCM"        set AEXT=.wav
if "%AUDIO_FORMAT%"=="AAC"        set AEXT=.m4a
if "%AUDIO_FORMAT%"=="WMA"        set AEXT=.wma
if "%AUDIO_FORMAT%"=="Vorbis"     set AEXT=.ogg
if "%AUDIO_FORMAT%"=="FLAC"       set AEXT=.flac
del %TEMP_INFO%

..\tool\ffmpeg.exe -y -i "%~1" -vn -c:a copy "%OUT_PATH%\%~n1%AEXT%"

:movie
if /i not "%MOVIE%"=="y" goto :eof
if /i not "%MCODEC%"=="avi" (
  if /i "%MOVIE_AUDIO%"=="n" (
    ..\tool\ffmpeg.exe -y -i "%~1" -c:v %MCODEC% -copyts -an "%OUT_PATH%\%%INPUT_FILE_NAME%_out.avi"
    goto :eof
  ) else (
    ..\tool\ffmpeg.exe -y -i "%~1" -c:v %MCODEC% -copyts -c:a pcm_s16le "%OUT_PATH%\%%INPUT_FILE_NAME%_out.avi"
    goto :eof
  )
) 
cd ..\tool
set TEMP_DIR=TEMP\WAV_EXTRACT
set INFO_AVS=%TEMP_DIR%\information.avs
if not exist %TEMP_DIR% mkdir %TEMP_DIR%
call :codec_check
call :avi_extract

exit /b

:swf
rem swfextract.exeは別途入手する必要があります
..\tool\swfextract.exe -m "%~1" -o "%OUT_PATH%\%%INPUT_FILE_NAME%_out.mp3"
if /i "%WAV%"=="y" (
..\tool\ffmpeg.exe -y -i "%OUT_PATH%\%~n1_out.mp3" -vn -c:a pcm_s16le -ar 44100 "%OUT_PATH%\%%INPUT_FILE_NAME%_out.wav"
)
exit /b

:codec_check
.\MediaInfo.exe --Inform=Video;%%ScanType%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_TYPE=%%i
if /i "%SCAN_TYPE%"=="Interlaced" (
  if /i "%INPUT_FILE_TYPE%"=="mp4" (
     set DECODER=ffmpeg
     exit /b
  )
)
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".mkv .mp4 .m4v .mov .flv .f4v">nul
if not ERRORLEVEL 1 (
    set DECODER=LSMASH
    exit /b
)
date /t>nul
if /i "%INPUT_FILE_TYPE%"==".wmv" (
    set DECODER=ffmpeg
    exit /b
)
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\System32\findstr.exe" /i ".asf .ogm .ogv .vob .m2v .mpeg .mpg .m2ts .mts .m2t .ts .dv">nul
if not ERRORLEVEL 1 (
    set DECODER=LWLibav
    exit /b
)
.\MediaInfo.exe --Inform=Video;%%CodecID/Info%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
date /t>nul
"%WINDIR%\system32\findstr.exe" /i /C:"Chromatic MPEG 1 Video I Frame" "%TEMP_INFO%">nul 2>&1
if not ERRORLEVEL 1 (
   set DECODER=directshow
   exit /b
)
.\MediaInfo.exe --Inform=Video;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
date /t>nul
"%WINDIR%\system32\findstr.exe" /i "dv mpeg" "%TEMP_INFO%">nul 2>&1
if not ERRORLEVEL 1 (
    set DECODER=ffmpeg
    exit /b
)
.\MediaInfo.exe --Inform=Video;%%Codec/CC%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
date /t>nul
"%WINDIR%\system32\findstr.exe" /i "cvid msvc cram" "%TEMP_INFO%">nul 2>&1
if not ERRORLEVEL 1 (
    set DECODER=ffmpeg
    exit /b
)
.\MediaInfo.exe --Inform=Video;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
date /t>nul
"%WINDIR%\system32\findstr.exe" /i "xtor" "%TEMP_INFO%">nul 2>&1
if not ERRORLEVEL 1 (
    set DECODER=directshow
    exit /b
)

.\MediaInfo.exe --Inform=Audio;%%CodecID%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
date /t>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set AUDIO_CODEC=%%i
if /i "%INPUT_FILE_TYPE%"==".avi" (
   if defined AUDIO_CODEC (
      if not "%AUDIO_CODEC%"=="1" (
         set DECODER=ffmpeg
         exit /b
      )
   )
)
if /i not "%INPUT_FILE_TYPE%"==".avi" (
    set DECODER=directshow
    exit /b
)
set DECODER=avi
exit /b

:avi_extract
if /i "%DECODER%"=="avi" goto avisource_info
if /i "%DECODER%"=="ffmpeg" goto ffmpegsource_info
if /i "%DECODER%"=="directshow" goto directshowsource_info
if /i "%DECODER%"=="LSMASH" goto LSMASHsource_info
if /i "%DECODER%"=="qt" goto qtsource_info

:directshowsource_info
(
    echo LoadPlugin^("DirectShowSource.dll"^)
    echo;
    echo DirectShowSource^(%INPUT_FILE_PATH%, audio = true^)
)> %INFO_AVS%
goto infoavs

:qtsource_info
(
    echo LoadPlugin^("QTSource.dll"^)
    echo;
    echo QTInput^(%INPUT_FILE_PATH%, quality = 100, audio = true^)
)> %INFO_AVS%
goto infoavs

:avisource_info
echo AVISource^(%INPUT_FILE_PATH%, audio = true^)> %INFO_AVS%
goto infoavs

:LSMASHsource_info
(
    echo LoadPlugin^("LSMASHSource.dll"^)
    echo video=LSMASHVideoSource^(%INPUT_FILE_PATH%, 0, 0, 10, 0^)
    echo audio=LSMASHAudioSource^(%INPUT_FILE_PATH%, 0, true^)
    echo AudioDub^(video, audio^)
)> %INFO_AVS%
goto infoavs

:ffmpegsource_info
date /t>nul
echo %INPUT_FILE_TYPE% | findstr /i ".avi .mkv .mp4 .flv">nul
if not ERRORLEVEL 1 (
    set SEEKMODE=1
    ffmsindex.exe -m default -f %INPUT_FILE_PATH% %TEMP_DIR%\input.ffindex
) else (
    set SEEKMODE=-1
    ffmsindex.exe -m lavf -f %INPUT_FILE_PATH% %TEMP_DIR%\input.ffindex
)

rem CFR（固定フレームレート）とVFR（可変フレームレート）の判断
.\MediaInfo.exe --Inform=Video;%%FrameRate_Mode%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set FPS_MODE=%%i
if "%FPS_MODE%"=="VFR" (
  echo;
  echo 可変フレームレート（VFR）な動画はaviに変換できません
  pause>nul
  exit
)

:fps_main
(
    echo LoadPlugin^("ffms2.dll"^)
    echo;
    echo fps_num = Int^(%FPS% * 1000^)
    if "%VFR%"=="true" (
        echo video=FFVideoSource^(%INPUT_FILE_PATH%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1^)
    ) else (
        echo video=FFVideoSource^(%INPUT_FILE_PATH%,cachefile="input.ffindex",seekmode=%SEEKMODE%,threads=1,fpsnum=fps_num, fpsden=1000^)
    )
        echo audio=FFAudioSource^(%INPUT_FILE_PATH%,cachefile="input.ffindex"^)
    echo AudioDub^(video, audio^)
)> %INFO_AVS%

:infoavs
(
    echo;
    echo _isyv12 = IsYV12^(^)
    echo WriteFileStart^("yv12.txt","_isyv12",append = false^)
    if /i "%MOVIE_AUDIO%"=="n" echo killaudio^(^)
    echo;
    echo return last
)>> %INFO_AVS%

.\avs2pipemod.exe -info %INFO_AVS% 1>nul 2>&1

if not exist "%TEMP_DIR%\yv12.txt" (
  if /i "%DECODER%"=="ffmpeg" (
    set FFMS_INFO=f
  )
  if /i "%DECODER%"=="avi" (
    set AVI_INFO=f
  )
  if /i "%DECODER%"=="directshow" (
    set DIRECTSHOW_INFO=f
  )
  if /i "%DECODER%"=="LSMASH" (
    set LSMASH_INFO=f
  )
  if /i "%DECODER%"=="qt" (
    set QT_INFO=f
  )
)

if not exist "%TEMP_DIR%\yv12.txt" (
  if not "%FFMS_INFO%"=="f" (
    set DECODER=ffmpeg
    goto ffmpegsource_info
  )
  if not "%AVI_INFO%"=="f" (
    set DECODER=avi
    goto avisource_info
  )
  if not "%DIRECTSHOW_INFO%"=="f" (
    set DECODER=directshow
    goto directshowsource_info
  )
  if not "%LSMASH_INFO%"=="f" (
    set DECODER=LSMASH
    goto LSMASHsource_info
  )
  if not "%QT_INFO%"=="f" (
    set DECODER=qt
    goto qtsource_info
  )
)

if exist %TEMP_DIR%\yv12.txt (
rem  .\avs2avi.exe "%INFO_AVS%" "%~dpn1_out.avi" -l "..\..\a2a_c_par" -w
  .\avs2avi.exe "%INFO_AVS%" "%OUT_PATH%\%%INPUT_FILE_NAME%_out.avi"  -w
)
exit /b

