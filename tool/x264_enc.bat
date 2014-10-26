rem tool set-up
set X264_A2POPT=
set SIZEOK=n

rem x264オプション読み込み
:set_x264_option
if "%CRFMODE%"=="y" (
    set DEFAULT_PASS=1
    goto x264_option_setting
)

if not "%FLASH%"=="1" (
  if not "%FLASH%"=="2" (
    if not "%FLASH%"=="3" set FLASH=a
  )
)

if /i "%FLASH%"=="a" (
  if %TOTAL_TIME% GEQ 600000 set FLASH=1
)

date /t>nul
echo %PRETYPE% | "%WINDIR%\system32\findstr.exe" /i "a l m n">nul
if not ERRORLEVEL 1 (
  if /i "%FLASH%"=="a" set FLASH=2
)
if /i "%FLASH%"=="a" set FLASH=1

if /i "%PRETYPEI%"=="t" (
    set DEFAULT_PASS=1
    goto x264_option_setting
)
date /t>nul
echo %PRETYPE% | "%WINDIR%\system32\findstr.exe" /i "l o">nul
if not ERRORLEVEL 1 (
    set DEFAULT_PASS=%DEFAULT_PASS_SPEED%
    goto x264_option_setting
)
date /t>nul
echo %PRETYPE% | "%WINDIR%\system32\findstr.exe" /i "m p">nul
if not ERRORLEVEL 1 (
    set DEFAULT_PASS=%DEFAULT_PASS_BALANCE%
    goto x264_option_setting
)
date /t>nul
echo %PRETYPE% | "%WINDIR%\system32\findstr.exe" /i "n q">nul
if not ERRORLEVEL 1 (
    set DEFAULT_PASS=%DEFAULT_PASS_QUALITY%
    goto x264_option_setting
)
if /i "%PRETYPE%"=="y" (
    set DEFAULT_PASS=1
    goto x264_option_setting
)
if /i "%PRETYPE%"=="c" (
    set DEFAULT_PASS=%DEFAULT_PASS_QUALITY%
    goto x264_option_setting
)

rem PRETYPE x 
set DEFAULT_PASS=%DEFAULT_PASS_QUALITY%
goto x264_option_setting

:x264_option_setting
if /i not "%PRETYPE%"=="c" call ..\setting\x264_common.bat
if /i "%PRETYPE%"=="t" (
  call ..\setting\m\%SETTING1%.bat
) else if /i "%PRETYPE%"=="a" (
  call ..\setting\m\%SETTING1%.bat
) else if /i not "%PRETYPE%"=="c" (
  call ..\setting\%PRETYPE%\%SETTING1%.bat
)
if /i "%CRF_TEST%"=="y" (
  if defined CRF set CRF_TEST_CRF=%CRF%
)

if /i "%COLORMATRIX%"=="BT.709" (
    set X264_COLORMATRIX=bt709
) else (
    set X264_COLORMATRIX=smpte170m
)
if /i "%FULL_RANGE%"=="off" (
    set RANGE=tv
) else if /i "%FULL_RANGE%"=="on" (
    set RANGE=pc
) else (
    set RANGE=auto
)

if /i not "%PRETYPE%"=="s" (
    if not "%X264_VFR_ENC%"=="true" (
        set MP4_FPS=-fps %FPS%
    )
)

if "%X264_VFR_ENC%"=="true" (
   set X264_TIMECODE=--tcfile-in %X264_TC_FILE%
   set TEMP_264=%TEMP_DIR%\video.mp4
)

if %FLASH% GEQ 2 set MISC=%MISC% --no-deblock
if %FLASH% EQU 3 set MISC=%MISC% --weightp 0

if "%BEGINNER%"=="true" (
    set QUIET=--quiet
) else if "%HARUMODE%"=="true" (
    set QUIET=--quiet
) else (  
    set QUIET=--ssim
)

set X264_COMMON=--range %RANGE% -I %KEYINT% -i %MIN_KEYINT% --scenecut %SCENECUT% -b %BFRAMES% --b-adapt %B_ADAPT% --b-pyramid %B_PYRAMID% -r %REF% -B %V_BITRATE% --rc-lookahead %RC_LOOKAHEAD% --qpstep %QPSTEP% --aq-mode %AQ_MODE% --aq-strength %AQ_STRENGTH% --qcomp %QCOMP% --weightp %WEIGHTP% --me %ME% -m %SUBME% --psy-rd %PSY_RD% -t %TRELLIS% --threads %THREADS% --colormatrix %X264_COLORMATRIX% %X264_TIMECODE% %COMMON_MISC% %QUIET% %MISC% 
echo %X264_COMMON%> %TEMP_DIR%\x264_option.txt
echo ^>^>%OPTION_SUCCESS%
echo;

rem ################映像エンコード################
rem 264にエンコード
echo ^>^>%X264_ENC_START%
echo;

if "%DEFAULT_PASS%"=="0" goto auto_pass_mode
if "%DEFAULT_PASS%"=="1" goto 1_pass_mode
if "%DEFAULT_PASS%"=="2" goto 2_pass_mode
if "%DEFAULT_PASS%"=="3" goto 3_pass_mode

echo ^>^>%PASS_ERROR%
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
exit /b

rem パス数自動設定モード
:auto_pass_mode
echo ^>^>%PASS_ANNOUNCE1%
echo;

rem crfエンコード
if /i "%CRF_TEST%"=="n" goto crf_encode_end
echo ^>^>%PASS_ANNOUNCE10%
echo;
if /i "%QP_ENC%"=="y" (
  set YOUTUBE=--qp %CRF_TEST_CRF%
) else (
  set YOUTUBE=--crf %CRF_TEST_CRF%
)

if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav"
  )
)

call :abr_encode
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i
set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE% * 8 / %TOTAL_TIME_SEC% / 1000 2>nul
if not defined TEMP_264_BITRATE set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE% / (%TOTAL_TIME%/8)
if %TEMP_264_BITRATE% LEQ %V_BITRATE% goto :eof

echo ^>^>%PASS_ANNOUNCE4%
echo;
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav"
  )
)

:crf_encode_end

rem １pass処理
echo ^>^>%PASS_ANNOUNCE2%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav"
  )
)
call :first_encode
rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav"
  )
)
call :second_encode
rem ３pass処理
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i

if defined TEMP_264_FILESIZE (
  if not "%TEMP_264_FILESIZE%"=="0" goto x264enc_continue
)

echo %X264E_ERROR1%
echo %X264E_ERROR2%
echo %X264E_ERROR3%

if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\X264E_ERROR1.mp3" (
     %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%X264E_ERROR1.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR\X264E_ERROR1.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\X264E_ERROR1.wav"
  )
)
set KEEP_ERROR_REPORT=true
call .\quit.bat
exit

:x264enc_continue
set /a TEMP_264_FILESIZE_KB=%TEMP_264_FILESIZE:~0,-3%
set /a V_FILESIZE_YMAX_KB = %V_BITRATE% * %TOTAL_TIME_SEC% / 8
set /a MIN_FILESIZE_KB = %V_FILESIZE_YMAX_KB% / 2

if /i "%FFPIPE%"=="y" (
  if %TEMP_264_FILESIZE_KB% LEQ %MIN_FILESIZE_KB% (
     set FFPIPE=n
     goto auto_pass_mode
  )
)

if /i not "%PRETYPE%"=="y" goto nico_thirdpass

set /a TEMP_264_FILESIZE_MB=%TEMP_264_FILESIZE:~0,-6%
if %TEMP_264_FILESIZE_MB% LEQ %DEFAULT_SIZE_YOUTUBE_NORMAL% goto :eof

if /i "%YTTYPE%"=="y" (
  if %TEMP_264_FILESIZE_MB% LEQ %DEFAULT_SIZE_YOUTUBE_PARTNER% goto :eof
)

(
echo V_BITRATE: %V_BITRATE% kbps
echo V_FILESIZE_YMAX_KB: %V_FILESIZE_YMAX_KB% KB
echo TEMP_264_FILESIZE_KB: %TEMP_264_FILESIZE_KB% KB
)>> %ERROR_REPORT%

if %TEMP_264_FILESIZE_KB% LEQ %V_FILESIZE_YMAX_KB% goto :eof

goto auto_third_pass

:nico_thirdpass
set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE% * 8 / %TOTAL_TIME_SEC% / 1000 2>nul
if not defined TEMP_264_BITRATE set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE% / (%TOTAL_TIME%/8)

if /i "%ACTYPE%"=="y" (
  set /a V_MAX_BITRATE = %P_TEMP_BITRATE% - %TEMP_M4A_BITRATE%
  set /a I_TMAX_BITRATE = %P_TEMP_BITRATE%
) else (
  set /a V_MAX_BITRATE = %I_TMAX_BITRATE% - %TEMP_M4A_BITRATE%
)
if /i "%ENCTYPE%"=="y" (
  if %E_MAX_BITRATE% LEQ %V_MAX_BITRATE% (
    set /a V_MAX_BITRATE = %E_MAX_BITRATE% - %TEMP_M4A_BITRATE%
  )
)

set /a V_BITRATE_L=%V_BITRATE% * 102 / 100

(
   echo 2nd Pass BR: %TEMP_264_BITRATE% kbps
)>> %ERROR_REPORT%

if %TEMP_264_BITRATE% GTR %V_MAX_BITRATE% goto auto_third_pass

if %TEMP_264_BITRATE% LEQ %V_BITRATE_L% goto :eof

:auto_third_pass
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
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE5.wav"
  )
)

call :second_encode

if /i "%PRETYPE%"=="y" goto :eof

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i
set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE% * 8 / %TOTAL_TIME_SEC% / 1000 2>nul
if not defined TEMP_264_BITRATE set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE% / (%TOTAL_TIME%/8)

(
   echo 3rd Pass BR: %TEMP_264_BITRATE% kbps
)>> %ERROR_REPORT%

if /i "%ENCTYPE%"=="y" (
  if %TEMP_264_BITRATE% GTR %V_MAX_BITRATE% goto auto_fourth_pass
)

if %TEMP_264_BITRATE% LEQ %V_MAX_BITRATE%  goto :eof

if %T_BITRATE% LEQ %I_MAX_BITRATE% (
  if %TEMP_264_BITRATE% GTR %V_MAX_BITRATE% goto auto_fourth_pass
)

.\MP4Box.exe -brand mp42 %MP4_FPS% -add %TEMP_264%#video:delay=noct -add %TEMP_M4A% -new %TEMP_MP4%
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_MP4%>nul
for /f %%i in (%TEMP_INFO%) do set TEMP_MP4_SIZE=%%i
set /a TEMP_MP4_BITRATE=%TEMP_MP4_SIZE% * 8 / %TOTAL_TIME_SEC% / 1000 2>nul
if not defined TEMP_MP4_BITRATE set /a TEMP_MP4_BITRATE=%TEMP_MP4_FILESIZE% / (%TOTAL_TIME%/8)
if %TEMP_MP4_SIZE% LEQ %MAX_FILESIZE% (
  set SIZEOK=y
  goto :eof
)

:auto_fourth_pass
echo ^>^>%PASS_ANNOUNCE4%
echo ^>^>%PASS_ANNOUNCE11%
echo;
echo ^>^>%PASS_ANNOUNCE12%
echo;
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav" (
    %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav"
  )
)
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE11.mp3" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE11.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE11.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE11.wav"
  )
)

set KEEP_ERROR_REPORT=true

set /a V_BITRATE = %V_BITRATE% - (%TEMP_264_BITRATE% - %V_BITRATE%) -2

(
   echo 4th Pass target BR: %V_BITRATE% kbps
)>> %ERROR_REPORT%


if %V_BITRATE% LEQ 0 (
	set SIZEOK=y
	goto :eof
)

set X264_COMMON=--range %RANGE% -I %KEYINT% -i %MIN_KEYINT% --scenecut %SCENECUT% -b %BFRAMES% --b-adapt %B_ADAPT% --b-pyramid %B_PYRAMID% -r %REF% -B %V_BITRATE% --rc-lookahead %RC_LOOKAHEAD% --qpstep %QPSTEP% --aq-mode %AQ_MODE% --aq-strength %AQ_STRENGTH% --qcomp %QCOMP% --weightp %WEIGHTP% --me %ME% -m %SUBME% --psy-rd %PSY_RD% -t %TRELLIS% --threads %THREADS% --colormatrix %X264_COLORMATRIX% %X264_TIMECODE% %COMMON_MISC% %MISC% 

call :final_encode
goto :eof

rem 強制1passモード
:1_pass_mode
if /i "%PRETYPE%"=="y" (
    set YOUTUBE=--crf %CRF%
    echo ^>^>%PASS_ANNOUNCE10%
    echo;
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav"
      )
    )
) else if /i "%CRFMODE%"=="y" (
    if /i "%QP_ENC%"=="y" (
      set YOUTUBE=--qp %CRF%
    ) else (
      set YOUTUBE=--crf %CRF%
    )
    echo ^>^>%PASS_ANNOUNCE10%
    echo;
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE10.wav"
      )
    )
) else (
    echo ^>^>%PASS_ANNOUNCE7%
    echo;
    echo ^>^>%PASS_ANNOUNCE2%
    echo;
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav" (
        %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav"
      )
    )
)
call :abr_encode

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i

set /a TEMP_264_FILESIZE_KB=%TEMP_264_FILESIZE:~0,-3%
rem set /a MIN_FILESIZE_KB = %V_BITRATE% * %TOTAL_TIME_SEC% / 8
rem set /a MIN_FILESIZE_KB = %V_FILESIZE_YMAX_KB% / 2

if /i "%FFPIPE%"=="y" (
  if %TEMP_264_FILESIZE_KB% LEQ 50 (
     set FFPIPE=n
     goto 1_pass_mode
  )
)

if /i not "%PRETYPE%"=="y" goto beginner_check

set TEMP_264_FILESIZE_GB=%TEMP_264_FILESIZE:~0,-9%

if not defined TEMP_264_FILESIZE_GB goto :eof

set /a TEMP_264_FILESIZE_MB=%TEMP_264_FILESIZE:~0,-6%

if %TEMP_264_FILESIZE_MB% LEQ %DEFAULT_SIZE_YOUTUBE_NORMAL% goto :eof

if /i "%YTTYPE%"=="y" (
  if %TEMP_264_FILESIZE_MB% LEQ %DEFAULT_SIZE_YOUTUBE_PARTNER% goto :eof
)

echo;
echo ^>^>%SIZE_ERROR1%
echo ^>^>%PASS_ANNOUNCE4%
echo;
set YOUTUBE=
set DEFAULT_PASS=0
if /i "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav"
  )
)
goto x264_option_setting

:beginner_check
set /a TEMP_264_BITRATE=%TEMP_264_FILESIZE%/(%TOTAL_TIME%/8)

(
   echo CRF BR: %TEMP_264_BITRATE% kbps
)>> %ERROR_REPORT%

if not "%BEGINNER%"=="true" goto :eof

if %TEMP_264_BITRATE% LEQ %V_BITRATE% (
    goto :eof
) else (
	echo;
    echo ^>^>%SIZE_ERROR1%
    echo ^>^>%PASS_ANNOUNCE4%
	echo;
    set YOUTUBE=
    set DEFAULT_PASS=0
	if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE4.wav"
      )
    )
    if "%BEGINNER%"=="true" (
       if %KEYINT% LEQ 300 (
          (echo %TEMP_264_BITRATE%)> %ENC_RECORD%
       )
       set /a MAX_BR_RECORD=%TEMP_264_BITRATE%
       set CHANGE_AUTO_BR_LIMIT=true
       set /a V_BITRATE=1000
    )
    goto x264_option_setting
)
exit /b

rem 強制2passモード
:2_pass_mode
echo ^>^>%PASS_ANNOUNCE8%
echo;
rem １pass処理
echo ^>^>%PASS_ANNOUNCE2%
echo;
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav"
    )
  )
call :first_encode
rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav"
    )
  )
call :final_encode

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i/(%TOTAL_TIME%/8)
for /f "delims=" %%i in (%TEMP_INFO%) do set TEMP_264_FILESIZE=%%i
set /a TEMP_264_FILESIZE_KB=%TEMP_264_FILESIZE:~0,-3%
set /a V_FILESIZE_YMAX_KB = %V_BITRATE% * %TOTAL_TIME_SEC% / 8
set /a MIN_FILESIZE_KB = %V_FILESIZE_YMAX_KB% / 2

if /i "%FFPIPE%"=="y" (
  if %TEMP_264_FILESIZE_KB% LEQ %MIN_FILESIZE_KB% (
     set FFPIPE=n
     goto 2_pass_mode
  )
)

(
   echo CRF BR: %TEMP_264_BITRATE% kbps
)>> %ERROR_REPORT%

goto :eof

rem 強制3passモード
:3_pass_mode
echo ^>^>%PASS_ANNOUNCE9%
echo;
rem １pass処理
echo ^>^>%PASS_ANNOUNCE2%
echo;
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE2.wav"
    )
  )
call :first_encode
rem ２pass処理
echo ^>^>%PASS_ANNOUNCE3%
echo;
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav" (
      %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE3.wav"
    )
  )
call :second_encode

rem ３pass処理
echo ^>^>%PASS_ANNOUNCE6%
echo;
if /i  "%VOICE%"=="true" (
  if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.mp3" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.mp3"
  ) else if exist "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.wav" (
    %PLAY_CMD2% "..\Extra\Voice\%VOICE_DIR%\PASS_ANNOUNCE6.wav"
  )
)
call :final_encode

.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% %TEMP_264%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set /a TEMP_264_BITRATE=%%i/(%TOTAL_TIME%/8)

(
   echo CRF BR: %TEMP_264_BITRATE% kbps
)>> %ERROR_REPORT%

goto :eof

:abr_encode
if /i "%FFPIPE%"=="y" (
  .\ffmpeg.exe -i %INPUT_VIDEO% -an -f yuv4mpegpipe -pix_fmt yuv420p -s %WIDTH%x%HEIGHT% %CONVERT_FPS% - |.\%X264EXE% - --no-progress --demuxer y4m -o %TEMP_264% %X264_COMMON% %YOUTUBE%
  echo;
  exit /b
) 
if not "%XARCH%"=="64bit" (
  .\%X264EXE% -o %TEMP_264% %X264_COMMON% %VIDEO_AVS% %YOUTUBE% 
) else (
  .\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE% - --demuxer y4m --frames %FRAMES% -o %TEMP_264% %X264_COMMON% %VIDEO_AVS% %YOUTUBE%
)
echo;
exit /b
:first_encode
if /i "%FFPIPE%"=="y" (
  .\ffmpeg.exe -i %INPUT_VIDEO% -an -f yuv4mpegpipe -pix_fmt yuv420p -s %WIDTH%x%HEIGHT% %CONVERT_FPS% - |.\%X264EXE% - --no-progress --demuxer y4m -p 1 -o "nul"  %X264_COMMON%
  echo;
  exit /b
)
if not "%XARCH%"=="64bit" (
  .\%X264EXE% -p 1 -o "nul" %X264_COMMON% %VIDEO_AVS%
) else (
  .\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE%  - --demuxer y4m --frames %FRAMES% -p 1 -o "nul" %X264_COMMON% %VIDEO_AVS%
)
echo;
exit /b
:second_encode
if /i "%FFPIPE%"=="y" (
  .\ffmpeg.exe -i %INPUT_VIDEO% -an -f yuv4mpegpipe -pix_fmt yuv420p -s %WIDTH%x%HEIGHT% %CONVERT_FPS% - |.\%X264EXE% - --no-progress --demuxer y4m -p 3 -o %TEMP_264% %X264_COMMON%
  echo;
  exit /b
)
if not "%XARCH%"=="64bit" (
  .\%X264EXE% -p 3 -o %TEMP_264% %X264_COMMON% %VIDEO_AVS%
) else (
  .\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE%  - --demuxer y4m --frames %FRAMES% -p 3 -o %TEMP_264% %X264_COMMON% %VIDEO_AVS%
)
echo;
exit /b
:final_encode
if /i "%FFPIPE%"=="y" (
  .\ffmpeg.exe -i %INPUT_VIDEO% -an -f yuv4mpegpipe -pix_fmt yuv420p -s %WIDTH%x%HEIGHT% %CONVERT_FPS% - |.\%X264EXE% - --no-progress --demuxer y4m -p 2 -o %TEMP_264% %X264_COMMON%
  echo;
  exit /b
)
if not "%XARCH%"=="64bit" (
  .\%X264EXE% -p 2 -o %TEMP_264% %X264_COMMON% %VIDEO_AVS%
) else (
  .\avs2pipemod.exe -y4mp %VIDEO_AVS% | .\%X264EXE% - --demuxer y4m --frames %FRAMES% -p 2 -o %TEMP_264% %X264_COMMON% %VIDEO_AVS%
)
echo;
exit /b
