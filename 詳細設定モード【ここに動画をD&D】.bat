@echo off

cd /d "%~d0" 1>nul 2>&1
cd "%~p0tool\" 1>nul 2>&1

set TDEDIR=%~dp0
call ..\setting\template\default_setting.bat
call ..\setting\enc_setting.bat
call ..\setting\user_setting.bat

set PLAY_CMD1=.\mdsplayc.exe
set PLAY_CMD2=start /b .\mdsplayc.exe

:haru_test
set HARUMODE=false
if "%~1"=="installonly" set INSTALLONYMODE=true

if not exist "TEMP\HARU\haru_enc_start.bat" goto natsu_begin

set HARUMODE=true

if exist "TEMP\HARU\haru_enc_setting1.txt" (
  for /f "delims=" %%i in (TEMP\HARU\haru_enc_setting1.txt) do (
    set ENDNOTICE=%%i
    set VOICE=%%i
  )
)
if exist "TEMP\HARU\haru_enc_setting2.txt" (
  for /f "delims=" %%i in (TEMP\HARU\haru_enc_setting2.txt) do set HARUTYPE=%%i
)
del /F "TEMP\HARU\haru_enc_start.bat" 1>nul 2>&1
del /F "TEMP\HARU\haru_enc_setting1.txt" 1>nul 2>&1
del /F "TEMP\HARU\haru_enc_setting2.txt" 1>nul 2>&1

:natsu_begin
color %BG_COLOR%
title %TDENC_TITLE%
rem if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\TDENC_TITLE.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\TDENC_TITLE.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\TDENC_TITLE.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\TDENC_TITLE.wav"
      )
    )
rem  )
rem )
if exist debug.txt (
   set DEBUG_MODE=true
   set KEEP_ERROR_REPORT=true
) else (
   set DEBUG_MODE=false
   set KEEP_ERROR_REPORT=false
)


rem ################ユーザー設定読み込み################
dir ".\" | "%WINDIR%\system32\findstr.exe" version>nul
IF ERRORLEVEL 1 (
  echo %PATH_ERROR1%
  echo %PATH_ERROR2%
  pause
  start "ie" "http://www43.atwiki.jp/tdenc/pages/13.html"
  call .\quit.bat
)

dir ".\" | "%WINDIR%\system32\findstr.exe" user_setting_template.bat>nul
IF ERRORLEVEL 1 goto zip_passed
call .\message_tsundere.bat
echo %UNZIP_ERROR1%
pause
call .\quit.bat

:zip_passed
dir ".\" | "%WINDIR%\system32\findstr.exe" 7z.exe>nul
IF ERRORLEVEL 1 (
  echo %ANTIVIRUS_ERROR1%
  echo %ANTIVIRUS_ERROR2%
  echo %ANTIVIRUS_ERROR3%
  pause
  call .\quit.bat
)
dir ".\" | "%WINDIR%\system32\findstr.exe" curl.exe>nul
IF ERRORLEVEL 1 (
  echo %ANTIVIRUS_ERROR1%
  echo %ANTIVIRUS_ERROR2%
  echo %ANTIVIRUS_ERROR3%
  pause
  call .\quit.bat
)

if exist ".\date.exe" move /Y date.exe GNU_date.exe


rem ################関連ツールのバージョンチェック関連###############
if exist "%ProgramFiles(x86)%" (
  set XARCH=64bit
) else (
  set XARCH=32bit
)

echo %PROCESSOR_IDENTIFIER% | "%WINDIR%\system32\findstr.exe" "Intel">nul
if not ERRORLEVEL 1 (
  set CPU=Intel
) else (
  set CPU=Other
)
echo %INTELCPU%

call .\version.bat

if defined PROXY set PROXY=--proxy %PROXY%
set URL_PATH=".\tool_url.bat"

if "%DEBUG_MODE%"=="true" set DEFAULT_VERSION_CHECK=true

date /t>nul
if /i "%DEFAULT_VERSION_CHECK%"=="true" (
  .\curl.exe -k %PROXY%  --connect-timeout 5 -f -o tool_url.zip -L "http://bit.ly/K1u07h" 2>nul
  if ERRORLEVEL 22 (
      set URL_PATH=".\tool_url_bk.bat"
  ) else (
      .\7z.exe e -bd -y ".\tool_url.zip" "tool_url.bat" 1>nul 2>&1
       copy /y tool_url.bat tool_url_bk.bat 1>nul 2>&1
  )
)

if "%DEBUG_MODE%"=="true" (
    .\curl.exe -k %PROXY%  --connect-timeout 5 -f -o tool_url.zip -L "http://bit.ly/WlIW93" 2>nul
     .\7z.exe e -bd -y ".\tool_url.zip" "tool_url.bat" 1>nul 2>&1
      copy /y tool_url.bat tool_url_bk.bat 1>nul 2>&1
)

call %URL_PATH%

set /a TVER=%THIS_VERSION%
if %TVER% LEQ 17 set THIS_VERSION=%PRESET_VERSION%

if not "%THIS_VERSION%"=="%PRESET_VERSION%" (
    echo ^>^>%PRESET_ALERT%
    echo;
    call .\quit.bat
)

rem ################バージョン＆プリセット表示################
echo %HORIZON_B%
echo 　　　%TDENC_NAME%  version %C_VERSION% %TDENC_NAME2%
echo 　　　preset : version %THIS_VERSION%
echo %HORIZON_B%

rem ################フォルダ作成################
rem 一時ファイルを保存するフォルダは変更しないで下さい
rem 不都合がある場合は、夏蓮根をフォルダごと移動させて下さい
set TEMP_DIR0=TEMP

if not exist %TEMP_DIR0% mkdir %TEMP_DIR0%
if not exist %MP4_DIR% mkdir %MP4_DIR%


rem ################フォルダ書き込みテスト################
set RMD=%RANDOM%
echo %RMD% > %TEMP_DIR0%\temp.txt
"%WINDIR%\system32\findstr.exe" "%RMD%" %TEMP_DIR0%\temp.txt 1>nul 2>&1
if ERRORLEVEL 1 (
    echo ^>^>%FOLDER_ALERT1%
    echo ^>^>%FOLDER_ALERT2%
    echo 
    call .\quit.bat
)

:ver_check
rem ################バージョンチェック################
if "%~1"=="" (
    call .\version_check.bat
    goto version_up_select
)
:filename_check
set TEMP_INFO=%TEMP_DIR0%\temp.txt
set ALL_ARGUMENTS=%*
set ALL_ARGUMENTS_CMD0="%ALL_ARGUMENTS:"=%"
set ALL_ARGUMENTS_CMD1=%ALL_ARGUMENTS_CMD0:&=?%
set ALL_ARGUMENTS_CMD2=%ALL_ARGUMENTS_CMD1:"=%
echo %ALL_ARGUMENTS_CMD2%> %TEMP_INFO%
for /f "delims=" %%i in (%TEMP_INFO%) do set ALL_ARGUMENTS_TXT=%%i
if not %ALL_ARGUMENTS_CMD0%=="%ALL_ARGUMENTS_TXT%" set FILENAME_PROBLEM=true

if /i "%DEFAULT_VERSION_CHECK%"=="true" (
    echo @echo off> "%TEMP_DIR0%\next_encode.bat"
    if "%FILENAME_PROBLEM%"=="true" (
      echo start /i call "..\詳細設定モード【ここに動画をD&D】.bat" "%~fs1" "%~fs2" "%~fs3" "%~fs4" "%~fs5" "%~fs6" "%~fs7" "%~fs8" "%~fs9">> "%TEMP_DIR0%\next_encode.bat"
    ) else (
      echo start /i call "..\詳細設定モード【ここに動画をD&D】.bat" "%~1" "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8" "%~9">> "%TEMP_DIR0%\next_encode.bat"
    )
    echo exit>> "%TEMP_DIR0%\next_encode.bat"
    call .\version_check.bat
)

:version_up_select
if /i "%VERSION_UP%"=="y" (
  if exist "%TEMP_DIR0%\next_encode.bat" start /i call "%TEMP_DIR0%\next_encode.bat"
  exit
) else (
  if exist "%TEMP_DIR0%\next_encode.bat" del "%TEMP_DIR0%\next_encode.bat" 1>nul 2>&1
)

call ..\setting\x264_common.bat
if not defined USER_XCOMMON (
  move /Y ..\setting\x264_common.bat ..\setting\x264_common_old.bat
  copy ..\setting\template\x264_common_template.bat ..\setting\x264_common.bat
  call ..\setting\x264_common.bat
)
if exist ..\setting\x264_common_new.bat del ..\setting\x264_common_new.bat

call ..\setting\x\high.bat
if not defined USER_PRESETX (
  move /Y ..\setting\x\high.bat ..\setting\x\high_old.bat
  copy ..\setting\x\high_template.bat ..\setting\x\high.bat
  call ..\setting\x\high.bat
)
set CRF=
if exist ..\setting\x\high_new.bat del ..\setting\x\high_new.bat

if exist "..\【ここに動画をD&D】.bat" del "..\【ここに動画をD&D】.bat"
if exist "..\初心者の方はこちら(簡易版).exe" del "..\初心者の方はこちら(簡易版).exe"

"%WINDIR%\system32\findstr.exe" "E:\\Windows" "..\setting\End_Sound.txt">nul
if not ERRORLEVEL 1 (
  if exist sed.exe (
    cd %TEMP_DIR0%
    ..\sed.exe -i -e "s/^E:\\Windows/%%%WINDIR%%%/" "..\..\setting\End_Sound.txt"
    del /Q sed*
    cd ..
  )
)
rem user_setting.batの更新
if "%ENC_VERSION%"=="%THIS_VERSION%" (
  if "%USER_XCOMMON%"=="%XCOMMON_VERSION%" (
    if "%USER_PRESETX%"=="%PRESETX_VERSION%" (
      if "%USER_VERSION%"=="%CUSTOM_VERSION%" (
        goto user_setting_update_end
      )
    )
  )
)
:user_setting_update
echo;
echo ^>^>%USER_SETTING1%
if "%HARUMODE%"=="true" (
  echo ^>^>%USER_SETTING2%
  echo ^>^>y
  set USER_UPDATE=y
  goto user_update_start
)
echo ^>^>%USER_SETTING2%
set /p USER_UPDATE=^>^>
:user_update_start
if /i "%USER_UPDATE%"=="y" (
    if not "%ENC_VERSION%"=="%THIS_VERSION%" (
      echo enc_setting.bat %USER_SETTING3% enc_setting_old.bat %USER_SETTING4%
      move /Y ..\setting\enc_setting.bat ..\setting\enc_setting_old.bat
      copy ..\setting\template\enc_setting_template.bat ..\setting\enc_setting.bat
      call ..\setting\enc_setting.bat
    )
    if not "%USER_VERSION%"=="%CUSTOM_VERSION%" (
      echo user_setting.bat %USER_SETTING3% user_setting_old.bat %USER_SETTING4%
      move /Y ..\setting\user_setting.bat ..\setting\user_setting_old.bat
      copy ..\setting\template\user_setting_template.bat ..\setting\user_setting.bat
      call ..\setting\user_setting.bat
    )
    if not "%USER_XCOMMON%"=="%XCOMMON_VERSION%" (
      echo x264_common.bat %USER_SETTING3% x264_common_old.bat %USER_SETTING4%
      move /Y ..\setting\x264_common.bat ..\setting\x264_common_old.bat
      copy ..\setting\template\x264_common_template.bat ..\setting\x264_common.bat
    )
    if not "%USER_PRESETX%"=="%PRESETX_VERSION%" (
      echo x\high.bat %USER_SETTING3% x\high_old.bat %USER_SETTING4%
      move /Y ..\setting\x\high.bat ..\setting\x\high_old.bat
      copy ..\setting\x\high_template.bat ..\setting\x\high.bat
    )
) else if /i "%USER_UPDATE%"=="n" (
    echo ^>^>%PRESET_ALERT2%
    echo ^>^>%PAUSE_MESSAGE1%
    pause>nul
) else (
    echo ^>^>%RETURN_MESSAGE1%
    goto user_setting_update
)
if not defined DEFAULT_SIZE_YOUTUBE_PARTNER (
    echo ^>^>%USER_SETTING1%
    echo ^>^>%PRESET_ALERT3%
)
echo;
:user_setting_update_end


if exist ..\setting\*_template.bat del /Q ..\setting\*_template.bat
if exist ..\setting\default_setting.bat del ..\setting\default_setting.bat

rem ################ツール類の設定################
call :file_exist_check

if defined INSTALLONYMODE exit

rem ################古いTEMPフォルダの削除と新しいTEMPフォルダの作成################
if "%DEBUG_MODE%"=="true" (
  set FOLDER_LIMIT=10
  goto delete_temp
)
set FOLDER_LIMIT=5

date /t>nul
ver | "%WINDIR%\system32\findstr.exe" "4. 5.0 5.1">nul
if ERRORLEVEL 1 (
  forfiles /P %TEMP_DIR0% /D -7 /C "cmd /c if @isdir==TRUE rmdir /S /Q @path" 1>nul 2>&1
  goto make_temp
)

:delete_temp
dir /b /ad %TEMP_DIR0% | find /c /v ""> temp.txt
for /f "delims=" %%i in (temp.txt) do set /a NTEMP=%%i
if %NTEMP% LEQ %FOLDER_LIMIT% goto make_temp

echo ^>^>%DELTEMP1%
echo ^>^>%DELTEMP2%
set /p DTEMP=^>^>
if /i "%DTEMP%"=="y" (
	rmdir /s /q %TEMP_DIR0%
	mkdir %TEMP_DIR0%
)
del temp.txt
echo;

:make_temp
.\GNU_date.exe > %TEMP_DIR0%\temp.txt 2>nul
date /t>nul
"%WINDIR%\system32\findstr.exe" /R "[0-9]" %TEMP_DIR0%\temp.txt 1>nul 2>&1
if ERRORLEVEL 1 (
  set TEMP_DIR=%TEMP_DIR0%\%RANDOM%
  goto make_tempdir
)

for /f "usebackq tokens=*" %%i in (`.\GNU_date.exe +%%Y%%m%%d`) do set FDATE=%%i
for /f "usebackq tokens=*" %%i in (`.\GNU_date.exe +%%H%%M%%S`) do set FTIME=%%i
set TEMP_DIR=%TEMP_DIR0%\%FDATE%-%FTIME%

:make_tempdir
mkdir %TEMP_DIR%
rem ################変数設定################
set TEMP_INFO=%TEMP_DIR%\temp.txt
set TEMP_INFO2=%TEMP_DIR%\temp2.txt
set TEMP_INFO3=%TEMP_DIR%\temp3.txt
set TEMP_INFO4=%TEMP_DIR%\temp4.txt
set INFO_AVS=%TEMP_DIR%\information.avs
set INFO_AVS3=%TEMP_DIR%\information3.avs
set INFO_AVS4=%TEMP_DIR%\information4.avs
set PROCESS_S_FILE=%TEMP_DIR%\proccess.txt
set PROCESS_E_FILE=%TEMP_DIR%\end.txt
set VIDEO_AVS=%TEMP_DIR%\video.avs
set AUDIO_AVS=%TEMP_DIR%\audio.avs
set AUDIO_AVS2=%TEMP_DIR%\audio2.avs
set TEMP_264=%TEMP_DIR%\video.264
set TEMP_WAV=%TEMP_DIR%\audio.wav
set TEMP_WAV2=%TEMP_DIR%\audio2.wav
set TEMP_WAV3=%TEMP_DIR%\audio3.wav
set TEMP_M4A=%TEMP_DIR%\audio.m4a
set TEMP_MP3=%TEMP_DIR%\audio.mp3
set FINAL_WAV=%TEMP_DIR%\audio_repair.wav
set TEMP_MP4=%TEMP_DIR%\movie.mp4
set TEMP_AVI=%TEMP_DIR%\movie.avi
set TEMP_FLV=%TEMP_DIR%\movie.flv
set ENC_RECORD=..\setting\beginner_enc_record.txt
set DECODERS=%DECODER%
set FFPIPES=%FFPIPE%
set PRESET_S_ENABLE=false
set FAILED_MOVIES=0
set DECODE_FAILED=false
set SKIP_A_ENC=false
rem set /a I_MAX_BITRATE=%I_MAX_BITRATE%

rem ################レジストリチェック################
rem call :registry_check

rem ################アンチウィルスチェック################

rem 一時的にGNU_date off
goto mode_select
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo;
    echo _start_date = String^( %FDATE% ^)
    echo _start_time = String^( -%FTIME% ^)
    echo WriteFileStart^("time_start.txt","_start_date", "_start_time",append = false^)
    echo;
    echo return last
)> %INFO_AVS%

.\avs2pipemod.exe -info %INFO_AVS% 1>nul 2>&1
if not exist %TEMP_DIR%\time_start.txt (
   echo;
   echo %ANTIVIRUS_ERROR4%
   echo %ANTIVIRUS_ERROR5%
   echo;
   call .\quit.bat
)

:mode_select
rem ################エンコードモード分岐################
if "%~1"=="" goto file_drop_mode

dir "%~1" | "%WINDIR%\system32\findstr.exe" \^<\.$>nul
if ERRORLEVEL 1 (
  if /i "%SHORTNAME%"=="true" goto filename_check_skip
)

:filename_check2
if "%FILENAME_PROBLEM%"=="true" (
    echo ^<List1^>
    echo   %ALL_ARGUMENTS_CMD0%
    echo ^<List2^>
    echo   "%ALL_ARGUMENTS_TXT%"
    echo;
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR2%
    echo;
    set FILENAME_ERROR_FOUND=y
    call .\quit.bat
)

:filename_check_skip
if /i exist "..\setting\custom_enc_settings\enc_test.txt" set ENC_TESTS=y
if /i "%ENC_TESTS%"=="y" goto sequence_mode

start /b /wait filecheck.bat "%~1" "%~2" "%~3" "%~4" "%~5" "%~6" "%~7" "%~8" "%~9"
for /f "delims=" %%i in (%TEMP_INFO%) do set FILE_CHECK_RESULT=%%~i
echo %FILE_CHECK_RESULT% | "%WINDIR%\system32\findstr.exe" file_NOT_found >nul
if not ERRORLEVEL 1 call .\quit.bat

echo "%~n1"> %TEMP_INFO%
for /f "delims=" %%i in (%TEMP_INFO%) do set FINAL_FILE=%%~i
if not "%~n1"=="%FINAL_FILE%" set FINAL_FILE=%FILENAME_ERROR_MP4%
set FINAL_FILE=%FINAL_FILE:+=-%

if not "%~3"=="" (
  if "%~4"=="" goto sequence_mode
    echo "%~1"> %TEMP_INFO%
    echo "%~2">> %TEMP_INFO%
    echo "%~3">> %TEMP_INFO%
    echo "%~4">> %TEMP_INFO%
  If not "%~5"=="" (
    if "%~6"=="" goto sequence_mode
  ) else (
    set NFILES=4
    set NPAIRS=2
    goto pair_check
  )
    echo "%~5">> %TEMP_INFO%
    echo "%~6">> %TEMP_INFO%
  If not "%~7"=="" (
    if "%~8"=="" goto sequence_mode
  ) else (
    set NFILES=6
    set NPAIRS=3
    goto pair_check
  )
    echo "%~7">> %TEMP_INFO%
    echo "%~8">> %TEMP_INFO%
  if not "%~9"=="" (
    goto sequence_mode
  ) else (
    set NFILES=8
    set NPAIRS=4
    goto pair_check
  )
)
if not "%~2"=="" (
  if not "%~2"=="%~1" goto mux_mode
)
rem 1ファイルのエンコード
date /t>nul
dir "%~1" | "%WINDIR%\system32\findstr.exe" \^<\.$>nul
if not ERRORLEVEL 1 (
    if not exist "%~1" (
       echo "%~1"
       echo ^>^>%FILENAME_ERROR1%
       echo ^>^>%FILENAME_ERROR3%
       call .\quit.bat
    )

    echo ^>^>%UNITE_AVI_ANNOUNCE1%
    echo ^>^>%UNITE_AVI_ANNOUNCE2%
    echo ^>^>"%~f1" %PROCESS_ANNOUNCE%
    echo;
    call :cat_avi "%~1"
    set ERROR_REPORT="%MP4_DIR%\%FINAL_FILE%_error_report.txt"
    copy /y error_report_template.txt %ERROR_REPORT% 1>nul 2>&1
    call .\cat.bat
    call :temp_264_check
    call .\create_mp4.bat
    call .\shut.bat
)
echo;
echo ^>^>%ONE_MOVIE_ANNOUNCE%
if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i not "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\ONE_MOVIE_ANNOUNCE.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ONE_MOVIE_ANNOUNCE.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\ONE_MOVIE_ANNOUNCE.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ONE_MOVIE_ANNOUNCE.wav"
      )
    )
rem  )
)
echo ^>^>"%~1" %PROCESS_ANNOUNCE%
echo;

:one_movie_mode
set INPUT_FILE_TYPE=%~x1
if /i "%SHORTNAME%"=="true" (
  set INPUT_FILE_PATH="%~fs1"
) else (
  set INPUT_FILE_PATH="%~1"
)
set ORIGINAL_VIDEO="%~1"
set ORIGINAL_AUDIO="%~1"

:one_movie_mode_main
set ENC_MODE=ONEMOVIE
set INPUT_VIDEO=%INPUT_FILE_PATH%
set INPUT_AUDIO=%INPUT_FILE_PATH%
set FINAL_MP4=%FINAL_FILE%.mp4
set ERROR_REPORT="%MP4_DIR%\%FINAL_FILE%_error_report.txt"
copy /y error_report_template.txt %ERROR_REPORT% 1>nul 2>&1

if not exist %INPUT_FILE_PATH% (
    echo %INPUT_FILE_PATH%
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR3%
    call .\quit.bat
)

date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".mswmm .wlmp .vsp .nvp2 .aup .nmm .exo .ksp">nul
if not ERRORLEVEL 1 (
    echo ^>^>%PROJECTFILE_ERROR1%
    if /i "%INPUT_FILE_TYPE%"==".mswmm" echo ^>^>%PROJECTFILE_ERROR2% 
    if /i "%INPUT_FILE_TYPE%"==".wlmp" echo ^>^>%PROJECTFILE_ERROR3% 
    if /i "%INPUT_FILE_TYPE%"==".aup" echo ^>^>%PROJECTFILE_ERROR4% 
    if /i "%INPUT_FILE_TYPE%"==".nmm" echo ^>^>%PROJECTFILE_ERROR5% 
    if /i "%INPUT_FILE_TYPE%"==".exo" echo ^>^>%PROJECTFILE_ERROR6% 
    if /i "%INPUT_FILE_TYPE%"==".ksp" echo ^>^>%PROJECTFILE_ERROR7% 
    call .\quit.bat
)

if /i not "%DECODER%"=="auto" set FPS_CHECK=false
if /i "%DECODER%"=="auto" call :codec_check "%~1"
rem if /i "%DECODER%"=="aup" (
rem    call :normal_main
rem    call .\shut.bat
rem )
rem if /i "%DECODER%"=="swf" (
rem    call :normal_main
rem    call .\shut.bat
rem )
if /i "%DECODER%"=="avi" (
    call :normal_main
    call .\shut.bat
)
if /i "%DECODER%"=="qt" (
    call :normal_main
    call .\shut.bat
)
if /i "%DECODER%"=="directshow" (
    call :normal_main
    call .\shut.bat
)
if /i "%DECODER%"=="ds_input" (
    call :normal_main
    call .\shut.bat
)
if /i "%DECODER%"=="LSMASH" (
    call :normal_main
    call .\shut.bat
)
if /i "%DECODER%"=="LWLibav" (
    call :normal_main
    call .\shut.bat
)
if /i "%DECODER%"=="ffmpeg" (
    call :normal_main
    call .\shut.bat
)
set DECODER=ffmpeg

call :normal_main
call .\shut.bat
exit

rem 複数ファイルの連続エンコード
:sequence_mode
echo;
if /i not "%ENC_TESTS%"=="y" ( 
   echo ^>^>%SEQUENCE_ANNOUNCE%
) else (
   echo ^>^>%SEQUENCE_ANNOUNCE2%
)
if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i not "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\SEQUENCE_ANNOUNCE.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SEQUENCE_ANNOUNCE.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\SEQUENCE_ANNOUNCE.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SEQUENCE_ANNOUNCE.wav"
      )
    )
rem  )
)

set TEST_NUM=1
:sequence_start
if "%~1"=="" goto sequence_end
set DECODE_FAILED=false
echo ^>^>"%~f1" %PROCESS_ANNOUNCE%
echo;

set INPUT_FILE_TYPE=%~x1
if not defined INPUT_FILE_TYPE (
    echo "%~1"
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR3%
    pause
    call .\quit.bat
)

if /i "%SHORTNAME%"=="true" (
  set INPUT_FILE_PATH="%~fs1"
) else (
  set INPUT_FILE_PATH="%~1"
)

set INPUT_VIDEO=%INPUT_FILE_PATH%
set INPUT_AUDIO=%INPUT_FILE_PATH%
set ORIGINAL_VIDEO="%~1"
set ORIGINAL_AUDIO="%~1"
set ENC_MODE=SEQUENCE

date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".mswmm .wlmp .vsp .nvp2 .aup .nmm .exo .ksp">nul
if not ERRORLEVEL 1 (
    echo ^>^>%PROJECTFILE_ERROR1%
    if /i "%INPUT_FILE_TYPE%"==".mswmm" echo ^>^>%PROJECTFILE_ERROR2% 
    if /i "%INPUT_FILE_TYPE%"==".wlmp" echo ^>^>%PROJECTFILE_ERROR3% 
    if /i "%INPUT_FILE_TYPE%"==".aup" echo ^>^>%PROJECTFILE_ERROR4% 
    if /i "%INPUT_FILE_TYPE%"==".nmm" echo ^>^>%PROJECTFILE_ERROR5% 
    if /i "%INPUT_FILE_TYPE%"==".exo" echo ^>^>%PROJECTFILE_ERROR6% 
    if /i "%INPUT_FILE_TYPE%"==".ksp" echo ^>^>%PROJECTFILE_ERROR7% 
    call .\quit.bat
)

echo "%~n1"> %TEMP_INFO%
for /f "delims=" %%i in (%TEMP_INFO%) do set FINAL_FILE=%%~i
if not "%~n1"=="%FINAL_FILE%" set FINAL_FILE=%FILENAME_ERROR_MP4%
set FINAL_FILE=%FINAL_FILE:+=-%

:sequence_start2
if /i "%ENC_TESTS%"=="y" set FINAL_FILE=%FINAL_FILE%_%TEST_NUM%
if /i "%ENC_TESTS%"=="y" call "..\setting\custom_enc_settings\custom_setting%TEST_NUM%.bat"

set FINAL_MP4=%FINAL_FILE%.mp4
set ERROR_REPORT="%MP4_DIR%\%FINAL_FILE%_error_report.txt"
copy /y error_report_template.txt %ERROR_REPORT% 1>nul 2>&1

if /i not "%DECODER%"=="auto" set FPS_CHECK=false
if /i "%DECODER%"=="auto" call :codec_check "%~1"
if /i "%DECODER%"=="avi" (
    goto ext_check
)
if /i "%DECODER%"=="qt" (
    goto ext_check
)
if /i "%DECODER%"=="directshow" (
    goto ext_check
)
if /i "%DECODER%"=="ds_input" (
    goto ext_check
)
if /i "%DECODER%"=="LSMASH" (
    goto ext_check
)
if /i "%DECODER%"=="LWLibav" (
    goto ext_check
)
if /i "%DECODER%"=="ffmpeg" (
    goto ext_check
)
set DECODER=LSMASH

:ext_check
if not defined INPUT_FILE_TYPE (
    echo ^>^>%MOVIE_INFO_ERROR1%
    echo ^>^>%MOVIE_INFO_ERROR2%
    echo;
    echo %MOVIE_INFO_ERROR3%
    echo %MOVIE_INFO_ERROR4%
    echo;
    call .\quit.bat
)

call :normal_main

echo;

if /i not "%ENC_TESTS%"=="y" shift

if "%TEST_NUM%"=="1" (
  if /i "%KEEPWAV%"=="y" (
    if exist %TEMP_WAV% (
      move /y %TEMP_WAV% "%MP4_DIR%\%FINAL_FILE%.wav" 1>nul 2>&1
    ) else (
      move /y %FINAL_WAV% "%MP4_DIR%\%FINAL_FILE%.wav" 1>nul 2>&1
    )
  )
)

if exist %TEMP_DIR% rmdir /s /q %TEMP_DIR%
mkdir %TEMP_DIR%

set FFPIPE=%FFPIPES%
set DECODER=%DECODERS%

if /i not "%ENC_TESTS%"=="y" goto sequence_start
set /a TEST_NUM=%TEST_NUM% + 1
if exist "..\setting\custom_enc_settings\custom_setting%TEST_NUM%.bat" goto sequence_start2

:sequence_end
echo;
echo ^>^>%SEQUENCE_END1%
if not "%FAILED_MOVIES%"=="0" (
  echo;
  echo ^>^>%FAILED_MOVIES% %SEQUENCE_END4%
  if not "%ENC_FAILED%"=="true" echo ^>^>%SEQUENCE_END5%
)
echo ^>^>%SEQUENCE_END2%
echo ^>^>%SEQUENCE_END3%
call .\shut.bat
exit

rem 音声とのMUXエンコード
:mux_mode
set DECODE_FAILED=false
date /t>nul
echo %~x2 | "%WINDIR%\system32\findstr.exe" /i ".wav .mp3 .m4a .aac">nul
if not ERRORLEVEL 1 (
    echo ^>^>%MUX_ANNOUNCE%
    if /i "%SHORTNAME%"=="true" (
       set INPUT_AUDIO="%~fs2"
       set INPUT_VIDEO="%~fs1"
    ) else (
       set INPUT_AUDIO="%~2"
       set INPUT_VIDEO="%~1"
    )
    set INPUT_FILE_TYPE=%~x1
    set INPUT_AUDIO_TYPE=%~x2
    set ORIGINAL_VIDEO="%~1"
    set ORIGINAL_AUDIO="%~2"
    echo ^>^>%MOVIE_FILE_ANNOUNCE% "%~f1" %PROCESS_ANNOUNCE%
    echo ^>^>%AUDIO_FILE_ANNOUNCE% "%~f2" %PROCESS_ANNOUNCE%
    goto mux_encode_start
)
date /t>nul
echo %~x1 | "%WINDIR%\system32\findstr.exe" /i ".wav .mp3 .m4a .aac">nul
if not ERRORLEVEL 1 (
    echo ^>^>%MUX_ANNOUNCE%
    if /i "%SHORTNAME%"=="true" (
       set INPUT_AUDIO="%~fs1"
       set INPUT_VIDEO="%~fs2"
    ) else (
       set INPUT_AUDIO="%~1"
       set INPUT_VIDEO="%~2"
    )
    set INPUT_FILE_TYPE=%~x2
    set INPUT_AUDIO_TYPE=%~x1
    set ORIGINAL_VIDEO="%~2"
    set ORIGINAL_AUDIO="%~1"
    echo ^>^>%MOVIE_FILE_ANNOUNCE% "%~f2" %PROCESS_ANNOUNCE%
    echo ^>^>%AUDIO_FILE_ANNOUNCE% "%~f1" %PROCESS_ANNOUNCE%
) else (
    goto sequence_mode
)
if not "%INSTALLONYMODE%"=="true" (
rem  if not "%HARUMODE%"=="true" (
    if /i not "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\MUX_ANNOUNCE.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MUX_ANNOUNCE.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\MUX_ANNOUNCE.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\MUX_ANNOUNCE.wav"
      )
    )
rem  )
)

echo "%~n2"> %TEMP_INFO%
for /f "delims=" %%i in (%TEMP_INFO%) do set FINAL_FILE=%%~i
if not "%~n2"=="%FINAL_FILE%" set FINAL_FILE=%FILENAME_ERROR_MP4%
set FINAL_FILE=%FINAL_FILE:+=-%

:mux_encode_start
if not defined INPUT_FILE_TYPE (
    echo %INPUT_VIDEO% %INPUT_AUDIO%
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR3%
    call .\quit.bat
)
if not defined INPUT_AUDIO_TYPE (
    echo %INPUT_VIDEO% %INPUT_AUDIO%
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR3%
    call .\quit.bat
)
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".jpg .jpeg .png .bmp">nul
if not ERRORLEVEL 1 (
  set ENC_MODE=IMAGEMUX
) else (
  set ENC_MODE=MOVIEMUX
)
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".mswmm .wlmp .vsp .nvp2 .aup .nmm .exo">nul
if not ERRORLEVEL 1 (
    echo ^>^>%PROJECTFILE_ERROR1%
    if /i "%INPUT_FILE_TYPE%"==".mswmm" echo ^>^>%PROJECTFILE_ERROR2% 
    if /i "%INPUT_FILE_TYPE%"==".wlmp" echo ^>^>%PROJECTFILE_ERROR3% 
    if /i "%INPUT_FILE_TYPE%"==".aup" echo ^>^>%PROJECTFILE_ERROR4% 
    if /i "%INPUT_FILE_TYPE%"==".nmm" echo ^>^>%PROJECTFILE_ERROR5% 
    if /i "%INPUT_FILE_TYPE%"==".exo" echo ^>^>%PROJECTFILE_ERROR6% 
    call .\quit.bat
)

set FINAL_MP4=%FINAL_FILE%.mp4
set FINAL_FLV=%FINAL_FILE%.flv
set ERROR_REPORT="%MP4_DIR%\%FINAL_FILE%_error_report.txt"
copy /y error_report_template.txt %ERROR_REPORT% 1>nul 2>&1

set INPUT_FILE_PATH=%INPUT_VIDEO%
rem call :mux_filetype_check

if /i not "%DECODER%"=="auto" set FPS_CHECK=false
if /i "%DECODER%"=="auto" call :codec_check "%~1"
rem if /i "%DECODER%"=="swf" (
rem  call .\swf.bat
rem  call :temp_264_check
rem  call .\create_mp4.bat
rem  call .\shut.bat
rem )
if /i not "%DECODER%"=="avi" (
  if /i not "%DECODER%"=="qt" (
    if /i not "%DECODER%"=="directshow" (
      if /i not "%DECODER%"=="ds_input" (
        if /i not "%DECODER%"=="LSMASH" (
          if /i not "%DECODER%"=="LWLibav" (
            if /i not "%DECODER%"=="ffmpeg" (
              set DECODER=LSMASH
            )
          )
        )
      )
    )
  )
)
call .\mux.bat
if not "%PAIR_MODE%"=="true" (
	call :temp_264_check
	call .\create_mp4.bat
	call .\shut.bat
	exit
)
if "%DECODE_FAILED%"=="false" call :temp_264_check
if "%DECODE_FAILED%"=="false" call .\create_mp4.bat
exit /b

:pair_check
.\sort.exe -n %TEMP_INFO% -o %TEMP_INFO2%
:file1
for /f "delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME1=%%~dpni
  set FILEPATH1="%%~i"
  goto file2
)

:file2
for /f "skip=1 delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME2=%%~dpni
  set FILEPATH2="%%~i"
  goto file3
)

:file3
for /f "skip=2 delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME3=%%~dpni
  set FILEPATH3="%%~i"
  goto file4
)

:file4
for /f "skip=3 delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME4=%%~dpni
  set FILEPATH4="%%~i"
  goto file5
)

:file5
if %NFILES% EQU 4 goto filename_compare
for /f "skip=4 delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME5=%%~dpni
  set FILEPATH5="%%~i"
  goto file6
)

:file6
for /f "skip=5 delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME6=%%~dpni
  set FILEPATH6="%%~i"
  goto file7
)

:file7
if %NFILES% EQU 6 goto filename_compare
for /f "skip=6 delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME7=%%~dpni
  set FILEPATH7="%%~i"
  goto file8
)

:file8
for /f "skip=7 delims=" %%i in (%TEMP_INFO2%) do (
  set FILENAME8=%%~dpni
  set FILEPATH8="%%~i"
)

:filename_compare
if not "%FILENAME1%"=="%FILENAME2%" goto sequence_mode
if not "%FILENAME3%"=="%FILENAME4%" goto sequence_mode
if not "%FILENAME5%"=="%FILENAME6%" goto sequence_mode
if not "%FILENAME7%"=="%FILENAME8%" goto sequence_mode

set PAIR_MODE=true
echo;
echo ^>^>%SEQUENCE_ANNOUNCE%
call :mux_mode %FILEPATH1% %FILEPATH2%
call :mux_mode %FILEPATH3% %FILEPATH4%
if %NPAIRS% EQU 2 goto sequence_end
call :mux_mode %FILEPATH5% %FILEPATH6%
if %NPAIRS% EQU 3 goto sequence_end
call :mux_mode %FILEPATH7% %FILEPATH8%
goto sequence_end

rem ################関数っぽいもの################
:file_exist_check
if not exist Avisynth.dll  start /wait call .\initialize.bat
if not exist avs2avi.exe  start /wait call .\initialize.bat
if not exist avs2pipemod.exe  start /wait call .\initialize.bat
rem if not exist avs4x264mod.exe  start /wait call .\initialize.bat
if not exist GNU_date.exe start /wait call .\initialize.bat
if not exist DirectShowSource.dll  start /wait call .\initialize.bat
if not exist DevIL.dll start /wait call .\initialize.bat
if not exist ds_input.aui  start /wait call .\initialize.bat
if not exist ffmpeg.exe  start /wait call .\initialize.bat
if not exist ffms2.dll start /wait call .\initialize.bat
if not exist ffmsindex.exe start /wait call .\initialize.bat
if not exist ffprobe.exe  start /wait call .\initialize.bat
if not exist libiconv2.dll  start /wait call .\initialize.bat
if not exist libintl3.dll  start /wait call .\initialize.bat
if not exist LSMASHSource.dll  start /wait call .\initialize.bat
if not exist mdsplayc.exe  start /wait call .\initialize.bat
if not exist MediaInfo.exe start /wait call .\initialize.bat
if not exist MediaInfo.dll start /wait call .\initialize.bat
if not exist mkvmerge.exe start /wait call .\initialize.bat
if not exist MP4Box.exe start /wait call .\initialize.bat
if not exist mp4fpsmod.exe start /wait call .\initialize.bat
if not exist neroAacEnc.exe start /wait call .\initialize.bat
if not exist pcre3.dll  start /wait call .\initialize.bat
if not exist player.swf  start /wait call .\initialize.bat
if not exist qaac.exe  start /wait call .\initialize.bat
rem if not exist qtaacenc.exe  start /wait call .\initialize.bat
if not exist QTSource.dll start /wait call .\initialize.bat
if not exist regex2.dll  start /wait call .\initialize.bat
if not exist sed.exe start /wait call .\initialize.bat
if not exist sort.exe start /wait call .\initialize.bat
if not exist warpsharp.dll start /wait call .\initialize.bat
if not exist yadif.dll start /wait call .\initialize.bat
if not exist %X264EXE% start /wait call .\initialize.bat
.\%X264EXE% --version>"%TEMP_DIR0%\x264_version.txt" 2>nul
rem "%WINDIR%\system32\findstr.exe" /i "%X264_VERSION%" "%TEMP_DIR0%\x264_version.txt">nul 2>&1
rem if "%ERRORLEVEL%"=="1" start /wait call .\initialize.bat

if not exist "%TEMP_DIR0%\x264_version.txt" (
   echo;
   echo %ANTIVIRUS_ERROR4%
   echo %ANTIVIRUS_ERROR5%
   echo;
   call .\quit.bat
)

exit /b

:codec_check
if /i "%INPUT_FILE_TYPE%"==".nvv" (
    echo ^>^>%NVV_ALERT%
    call .\quit.bat
)
.\MediaInfo.exe --Inform=General;%%Codec%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
date /t>nul
"%WINDIR%\system32\findstr.exe" /i "ShockWave" "%TEMP_INFO%">nul 2>&1
if not ERRORLEVEL 1 (
  echo ^>^>%SWF_ALERT%
  echo ^>^>%SWF_ALERT2%
  start rundll32 url.dll,FileProtocolHandler "http://nicowiki.com/swftomovie.html"
  start rundll32 url.dll,FileProtocolHandler "http://chround30.blog.fc2.com/blog-entry-5.html"
  call .\quit.bat
)

rem if /i "%INPUT_FILE_TYPE%"==".swf" (
rem   set DECODER=swf
rem   exit /b
rem )
rem if /i "%INPUT_FILE_TYPE%"==".aup" (
rem   set DECODER=aup
rem   exit /b
rem )

.\MediaInfo.exe --Inform=Video;%%ScanType%% --LogFile=%TEMP_INFO% %INPUT_FILE_PATH%>nul
for /f "delims=" %%i in (%TEMP_INFO%) do set SCAN_TYPE=%%i
if /i "%SCAN_TYPE%"=="Interlaced" (
  if /i "%INPUT_FILE_TYPE%"=="mp4" (
     set DECODER=ffmpeg
     exit /b
  )
)
date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".mkv .mp4 .m4v .mov .flv">nul
if not ERRORLEVEL 1 (
    set DECODER=LSMASH
    exit /b
)
date /t>nul
if /i "%INPUT_FILE_TYPE%"==".wmv" (
    set DECODER=LWLibav
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
    set DECODER=ds_input
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

:cat_avi
set CAT_DIR=%~1
set CAT_AVI_LIST1=%TEMP_DIR%\cat_avi1.txt
set CAT_AVI_LIST2=%TEMP_DIR%\cat_avi2.txt
set CAT_WAV_LIST1=%TEMP_DIR%\cat_wav1.txt
set CAT_WAV_LIST2=%TEMP_DIR%\cat_wav2.txt
set INPUT_FILE_PATH="%CAT_DIR%\%FINAL_FILE%.avs"
set INPUT_VIDEO=%INPUT_FILE_PATH%
set INPUT_AUDIO=%INPUT_FILE_PATH%
set INPUT_FILE_TYPE=.avs
set FINAL_MP4=%FINAL_FILE%.mp4
dir /b /on "%CAT_DIR%" | "%WINDIR%\system32\findstr.exe" /i .avi$> %CAT_AVI_LIST1%
.\sort.exe -n "%CAT_AVI_LIST1%" -o "%CAT_AVI_LIST2%"
dir /b /on "%CAT_DIR%" | "%WINDIR%\system32\findstr.exe" /i .wav$> %CAT_WAV_LIST1%
.\sort.exe -n "%CAT_WAV_LIST1%" -o "%CAT_WAV_LIST2%"
for /f "delims=" %%i in (%CAT_WAV_LIST2%) do set CAT_WAV_PATH=%%i
for %%i in (%CAT_WAV_LIST2%) do (
  set /p INPUT_WAV1=<"%%~i"
)
(
    if defined CAT_WAV_PATH (
        echo AudioDub^(AVISource^(^\
    ) else (
        set KEEPWAV=n
        echo AVISource^(^\
    )
    for /f "delims=" %%i in (%CAT_AVI_LIST2%) do echo "%%i", ^\
    if not defined CAT_WAV_PATH (
        echo audio = true^)
    ) else (
        echo audio = false^),WAVSource^(^\
        echo "%INPUT_WAV1%" ^\
        for /f "skip=1 delims=" %%i in (%CAT_WAV2%) do echo , "%%i" ^\
        echo ^)^)
    )
    echo;
    echo return last
    )> %INPUT_FILE_PATH%
)

(SET /P CATAVI1=)<%CAT_AVI_LIST2%
set CATAVI1=%CAT_DIR%\%CATAVI1%
(SET /P INPUT_WAV1=)<%CAT_WAV_LIST2%
set INPUT_WAV1=%CAT_DIR%\%INPUT_WAV1%

exit /b

:normal_main
rem if /i "%INPUT_FILE_TYPE%"==".aup" (
rem   call .\aup.bat
rem   call :temp_264_check
rem   call .\create_mp4.bat
rem   exit /b
rem )
if /i "%INPUT_FILE_TYPE%"==".avs" (
    call .\avs.bat
    call :temp_264_check
    call .\create_mp4.bat
    exit /b
)
if /i "%INPUT_FILE_TYPE%"==".nvv" (
    echo ^>^>%NVV_ALERT%
    call .\quit.bat
)
rem if /i "%INPUT_FILE_TYPE%"==".aup" (
rem    call .\aup.bat
rem    call :temp_264_check
rem    call .\create_mp4.bat
rem    exit /b
rem )
if /i "%INPUT_FILE_TYPE%"==".swf" (
    echo ^>^>%SWF_ALERT%
    call .\quit.bat
rem    call .\swf.bat
rem    call :temp_264_check
rem    call .\create_mp4.bat
rem  exit /b
)
call .\movie.bat

if not "%ENC_MODE%"=="SEQUENCE" (
	call :temp_264_check
	call .\create_mp4.bat
	exit /b
)
if "%DECODE_FAILED%"=="false" call :temp_264_check
if "%DECODE_FAILED%"=="false" call .\create_mp4.bat

exit /b

:temp_264_check
if not exist %TEMP_264% set /a FAILED_MOVIES=%FAILED_MOVIES% + 1

if not exist %TEMP_264% (
	echo ^>^>%VIDEO_ENC_ERROR%
	echo;
	if not "%ENC_MODE%"=="SEQUENCE" (
		if not "%PAIR_MODE%"=="true" (
			echo ^>^>%PAUSE_MESSAGE1%
			pause>nul
			goto :eof
		)
	)
	set /a FAILED_MOVIES=%FAILED_MOVIES% + 1
	set DECODE_FAILED=true
	set ENC_FAILED=true
)
exit /b

:file_drop_mode
echo;
echo ^>^>%FILE_DROP1%
echo ^>^>%FILE_DROP5%
echo ^>^>%FILE_DROP4%
set /P INPUT_VIDEO=
if not defined INPUT_VIDEO goto file_drop_mode
:file_drop_mode2
echo;
echo ^>^>%FILE_DROP2%
echo ^>^>%FILE_DROP3%
echo ^>^>%FILE_DROP5%
echo ^>^>%FILE_DROP4%
set /P INPUT_AUDIO=
if not defined INPUT_AUDIO goto file_drop_mode2

if /i not "%INPUT_VIDEO%"=="%INPUT_AUDIO%" goto mux_mode_setup
if not defined INPUT_VIDEO goto file_drop_mode
set INPUT_FILE_PATH="%INPUT_VIDEO%"
echo %INPUT_FILE_PATH%> %TEMP_INFO%
for /f "tokens=*" %%I in (%TEMP_INFO%) do set INPUT_FILE_TYPE=%%~xI
for /f "tokens=*" %%I in (%TEMP_INFO%) do set FINAL_FILE=%%~nI
for /f "tokens=*" %%I in (%TEMP_INFO%) do set ALL_ARGUMENTS_TXT=%%~fI
if not exist "%ALL_ARGUMENTS_TXT%" (
    echo ^<List1^>
    echo   "%INPUT_VIDEO%"
    echo ^<List2^>
    echo   "%ALL_ARGUMENTS_TXT%"
    echo;
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR2%
    echo;
    set FILENAME_ERROR_FOUND=y
    call .\quit.bat
)
set ORIGINAL_VIDEO="%INPUT_VIDEO%"
set ORIGINAL_AUDIO="%INPUT_VIDEO%"
goto one_movie_mode_main

:mux_mode_setup
echo ^>^>%MUX_ANNOUNCE%
set INPUT_VIDEO="%INPUT_VIDEO%"
echo %INPUT_VIDEO%> %TEMP_INFO%
for /f "delims= tokens=*" %%I in (%TEMP_INFO%) do set INPUT_FILE_TYPE=%%~xI
for /f "delims= tokens=*" %%I in (%TEMP_INFO%) do set FINAL_FILE=%%~nI
for /f "tokens=*" %%I in (%TEMP_INFO%) do set ALL_ARGUMENTS_TXT=%%~fI
if not exist "%ALL_ARGUMENTS_TXT%" (
    echo ^<List1^>
    echo   "%INPUT_VIDEO%"
    echo ^<List2^>
    echo   "%ALL_ARGUMENTS_TXT%"
    echo;
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR2%
    echo;
    set FILENAME_ERROR_FOUND=y
    call .\quit.bat
)
set INPUT_AUDIO="%INPUT_AUDIO%"
echo %INPUT_AUDIO%> %TEMP_INFO%
for /f "delims= tokens=*" %%I in (%TEMP_INFO%) do set INPUT_AUDIO_TYPE=%%~xI
for /f "delims= tokens=*" %%I in (%TEMP_INFO%) do set ALL_ARGUMENTS_TXT=%%~fI
if not exist "%ALL_ARGUMENTS_TXT%" (
    echo ^<List1^>
    echo   "%INPUT_AUDIO%"
    echo ^<List2^>
    echo   "%ALL_ARGUMENTS_TXT%"
    echo;
    echo ^>^>%FILENAME_ERROR1%
    echo ^>^>%FILENAME_ERROR2%
    echo;
    set FILENAME_ERROR_FOUND=y
    call .\quit.bat
)
set ORIGINAL_VIDEO=%INPUT_VIDEO%
set ORIGINAL_AUDIO=%INPUT_AUDIO%
echo ^>^>%MOVIE_FILE_ANNOUNCE% %INPUT_VIDEO% %PROCESS_ANNOUNCE%
echo ^>^>%AUDIO_FILE_ANNOUNCE% %INPUT_AUDIO% %PROCESS_ANNOUNCE%
goto mux_encode_start

exit /b

rem ################つんでれんこ終了..._φ(ﾟ∀ﾟ )ｱﾋｬ################
