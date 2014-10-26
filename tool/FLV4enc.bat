set INFO_AVS2=%TEMP_DIR%\information2.avs

echo ^>^>%FLV_ANNOUNCE%

(
    echo ImageSource^(%INPUT_VIDEO%,end=1,fps=%FPS%^)
    echo Spline16Resize^(%WIDTH%,%HEIGHT%^)
    echo Flipvertical^(^)
    echo;
    echo return last
)> %INFO_AVS%

.\avs2avi.exe "%INFO_AVS%" "%TEMP_AVI%" -l "..\..\a2a_c_par" -w
.\ffmpeg.exe -y -i %INPUT_AUDIO% -c:a copy -i "%TEMP_DIR%\%TEMP_AVI%" -c:v copy -loop 1 "%TEMP_FLV%"

if exist "%MP4_DIR%\%FINAL_FLV%" move /y "%MP4_DIR%\%FINAL_FLV%" %MP4_DIR%\old.flv>nul
move /y "%TEMP_FLV%" "%MP4_DIR%\%FINAL_FLV%">nul

if not exist "%MP4_DIR%\%FINAL_FLV%" (
    echo ^>^>%MP4_ERROR1%
    echo ^>^>%MP4_ERROR2%
    echo;
    echo ^>^>%PAUSE_MESSAGE1%
    pause>nul
    call .\quit.bat
)

echo;
echo ^>^>%FLV_SUCCESS%
echo;


rem ################FLVの情報を表示################
echo %HORIZON%
echo   FLV INFO
echo %HORIZON%

rem ファイル名
echo File Name     : %FINAL_FLV%

set FINAL_MP4=%FINAL_FLV%

rem 容量
.\MediaInfo.exe --Inform=General;%%FileSize/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo File Size     : %%i

rem 総ビットレート
.\MediaInfo.exe --Inform=General;%%OverallBitRate/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Total Bitrate : %%i

rem FPS
.\MediaInfo.exe --Inform=Video;%%FrameRate/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo FPS           : %%i

rem 解像度
.\MediaInfo.exe --Inform=Video;%%Width/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Width         : %%i
.\MediaInfo.exe --Inform=Video;%%Height/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Height        : %%i

rem アスペクト比
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio/String%% --LogFile=%TEMP_INFO% "%MP4_DIR%\%FINAL_MP4%">nul
for /f "delims=" %%i in (%TEMP_INFO%) do echo Aspect Ratio  : %%i

echo %HORIZON%
echo;


rem ################容量チェック################
.\MediaInfo.exe --Inform=General;%%FileSize%% "%MP4_DIR%\%FINAL_MP4%"> %TEMP_INFO%
for /f %%i in (%TEMP_INFO%) do set /a FINAL_MP4_SIZE=%%i

set /a SIZE_TEMP=%DEFAULT_SIZE_PREMIUM% 1>nul 2>&1

if %SIZE_TEMP% GEQ 101 (
set /a MAX_SIZE_LIMIT=%DEFAULT_SIZE_PREMIUM% * 1024 * 1024
) else (
set /a MAX_SIZE_LIMIT=104857600
)

if /i "%ACTYPE%"=="y" goto mp4_check_premium
if %FINAL_MP4_SIZE% LEQ 41943040 (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%SIZE_SUCCESS2%
    echo;
    goto last
) else (
    echo ^>^>%SIZE_ERROR%
    echo;
    call :eof
)

:mp4_check_premium
if %FINAL_MP4_SIZE% LEQ %MAX_SIZE_LIMIT% (
    echo ^>^>%SIZE_SUCCESS1%
    echo ^>^>%SIZE_SUCCESS2%
    echo;
    goto last
) else (
    echo ^>^>%SIZE_ERROR%
    echo;
    call :eof
)

rem ################後処理################
:last
if exist %ERROR_REPORT% del /f "%ERROR_REPORT%" 1>nul 2>&1

echo ^>^>%DERE_MESSAGE1%
echo;
echo ^>^>%DERE_MESSAGE2%
echo;
