title %SHUT_TITLE%
if /i "%SHUTDOWN%"=="y" goto shut


if "%HARUMODE%"=="true" ( 
  if "%ENDNOTICE%"=="false" goto nosound
)

:sound
if "%ENDNOTICE%"=="false" goto nosound
set SDL_SETTING=..\setting\End_sound.txt
for /f "delims= tokens=1" %%i in (%SDL_SETTING%) do set ENDSOUND=%%~i
for /f "delims= tokens=1" %%i in (%SDL_SETTING%) do set ENDSOUND_EXT=%%~xi
date /t>nul
if not defined ENDSOUND goto nosound
echo %ENDSOUND% | "%WINDIR%\system32\findstr.exe" /i "tada.wav">nul
if not ERRORLEVEL 1 set ENDSOUND=%WINDIR%\Media\tada.wav
rem echo %ENDSOUND_EXT% | "%WINDIR%\system32\findstr.exe" /i ".wav .mp3" 
rem if not ERRORLEVEL 1 (
  start /b .\mdsplayc.exe %ENDSOUND%
rem ) else if defined ENDSOUND (
rem "%ENDSOUND:"=%"
rem )
:nosound
if /i "%KEEPWAV%"=="y" (
 if exist %TEMP_WAV% (
     move /y %TEMP_WAV% "%MP4_DIR%\%FINAL_FILE%.wav" 1>nul 2>&1
 ) else (
     move /y %FINAL_WAV% "%MP4_DIR%\%FINAL_FILE%.wav" 1>nul 2>&1
 )
)
call :delete_dir

:open_mp4
echo;
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
start %MP4_DIR%
if "%MOVIE_CHECK%"=="y" call "..\MP4\ここにD&Dして動画をチェック.bat" "%MP4_DIR%\%FINAL_MP4%"
exit

:shut
call :delete_dir
echo;

if /i "%SHUTYPE%"=="o" (
  set SHUT_TYPE_DO=shutdown /s /f /t 120
  echo ^>^>%SHUT_ALERT%%PWCONF_LIST1%
  goto shut_f
)

if /i "%SHUTYPE%"=="r" (
  set SHUT_TYPE_DO=shutdown /s /f /t 120
  echo ^>^>%SHUT_ALERT%%PWCONF_LIST2%
  goto shut_f
)

if /i "%SHUTYPE%"=="l" (
  set SHUT_TYPE_DO=shutdown /s /f /t 120
  echo ^>^>%SHUT_ALERT%%PWCONF_LIST3%
  goto shut_f
)

if /i "%SHUTYPE%"=="s" (
  set SHUT_TYPE_DO=%windir%\System32\rundll32.exe powrprof.dll,SetSuspendState
)

if /i "%SHUTYPE%"=="s" (
  echo ^>^>%SHUT_ALERT%%PWCONF_LIST4%
  echo ^>^>%SHUT_CANCEL2%
  ping localhost -n 120 > nul
  %SHUT_TYPE_DO%
  exit
)

if /i "%SHUTYPE%"=="h" (
  set SHUT_TYPE_DO=%windir%\System32\rundll32.exe powrprof.dll,SetSuspendState Hibernate
)

if /i "%SHUTYPE%"=="h" (
  echo ^>^>%SHUT_ALERT%%PWCONF_LIST4%
  echo ^>^>%SHUT_CANCEL2%
  ping localhost -n 120 > nul
  %SHUT_TYPE_DO%
  exit
)

:shut_f
echo ^>^>%SHUT_CANCEL%
echo;
%SHUT_TYPE_DO%
pause>nul
shutdown /a
echo ^>^>%CANCEL_MESSAGE%
echo;
goto open_mp4
exit

rem 一時ディレクトリの削除
:delete_dir
if "%DEBUG_MODE%"=="true" exit /b
if exist %TEMP_DIR% rmdir /s /q %TEMP_DIR%
exit /b
