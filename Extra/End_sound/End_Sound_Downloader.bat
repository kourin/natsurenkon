@echo off

cd /d "%~d0" 1>nul 2>&1
cd "%~p0" 1>nul 2>&1
cd "..\..\tool\" 1>nul 2>&1

set SDL_URL2="https://dl.dropbox.com/u/9397178/Encode_end_kiriya720mp3.7z"
set SDL_PATH="..\Archives\Encode_end_kiriya720.7z"
set ENDSOUND_INFO=..\setting\End_sound.txt

set SDL_TITLE=夏蓮根 エンコード終了ボイスのダウンロード
set SDL_ANNOUNCE1=夏蓮根 エンコード終了ボイスのダウンロードをする？ （y/n）
set SDL_ANNOUNCE2=ダウンロード終了
set ENDSOUND_SELECT1=どれを聞いてみますか（1-7）
set ENDSOUND_SELECT2=試聴を終了し設定へ
set ENDSOUND_SELECT3=エンコード終了時の音声はどれにしますか（1-7）
set ENDSOUND_SELECT4=無音
set ENDSOUND_SELECT5=自分で設定したい時は、settingフォルダにある、End_Sound.txt にフルパスで記入よ！
set ENDSOUND_SETFIN=設定を保存したわよ？これで終了するから、Enter キーを押しなさいよね！！

title %SDL_TITLE%

call ..\setting\template\default_setting.bat

set SOUND0=無音
set SOUND1=デフォルト音
set SOUND1_MP3=%WINDIR%\Media\tada.wav
set SOUND2=女性
set SOUND2_MP3=..\Extra\End_sound\Encode_end_kiriya720\女性.mp3
set SOUND3=男性
set SOUND3_MP3=..\Extra\End_sound\Encode_end_kiriya720\男性.mp3
set SOUND4=ロリ
set SOUND4_MP3=..\Extra\End_sound\Encode_end_kiriya720\ロリ.mp3
set SOUND5=ツンデレ
set SOUND5_MP3=..\Extra\End_sound\Encode_end_kiriya720\ツンデレ.mp3
set SOUND6=ヘタレ
set SOUND6_MP3=..\Extra\End_sound\Encode_end_kiriya720\ヘタレ.mp3
set SOUND7=ヤンデレ（軽度）
set SOUND7_MP3=..\Extra\End_sound\Encode_end_kiriya720\ヤンデレ.mp3


title %SDL_TITLE%

if defined PROXY set PROXY=--proxy %PROXY%

if exist %SDL_PATH% goto sound_select 

echo;
echo ^>^>%SDL_ANNOUNCE1%
echo;

set /p SDL_DL=^>^>

if /i not "%SDL_DL%"=="y" call .\quit.bat

.\curl.exe %PROXY% --connect-timeout 5 -f -o %SDL_PATH% -L %SDL_URL2%

.\7z.exe x -r -bd -y -o..\Extra\End_sound\ %SDL_PATH% 1>nul 2>&1


echo;
echo ^>^>%SDL_ANNOUNCE2%
echo;

:sound_select 
echo;
echo ^>^>%ENDSOUND_SELECT1%
echo ^>^> 1: %SOUND1%
echo ^>^> 2: %SOUND2%
echo ^>^> 3: %SOUND3%
echo ^>^> 4: %SOUND4%
echo ^>^> 5: %SOUND5%
echo ^>^> 6: %SOUND6%
echo ^>^> 7: %SOUND7%
echo ^>^> s: %ENDSOUND_SELECT2%
set /p SOUND_TEST=^>^>

if /i "%SOUND_TEST%"=="s" goto save_sound_setting
if "%SOUND_TEST%"=="1" .\mdsplayc.exe "%SOUND1_MP3%"
if "%SOUND_TEST%"=="2" .\mdsplayc.exe "%SOUND2_MP3%"
if "%SOUND_TEST%"=="3" .\mdsplayc.exe "%SOUND3_MP3%"
if "%SOUND_TEST%"=="4" .\mdsplayc.exe "%SOUND4_MP3%"
if "%SOUND_TEST%"=="5" .\mdsplayc.exe "%SOUND5_MP3%"
if "%SOUND_TEST%"=="6" .\mdsplayc.exe "%SOUND6_MP3%"
if "%SOUND_TEST%"=="7" .\mdsplayc.exe "%SOUND7_MP3%"
echo;
goto sound_select

:save_sound_setting
echo ^>^>%ENDSOUND_SELECT3%
echo ^>^> 0: %ENDSOUND_SELECT4%
echo ^>^> 1: %SOUND1%
echo ^>^> 2: %SOUND2%
echo ^>^> 3: %SOUND3%
echo ^>^> 4: %SOUND4%
echo ^>^> 5: %SOUND5%
echo ^>^> 6: %SOUND6%
echo ^>^> 7: %SOUND7%
echo ^>^> %ENDSOUND_SELECT5%
set /p SOUND_SET=^>^>

if "%SOUND_SET%"=="0" set ENDSOUND=
if "%SOUND_SET%"=="1" set ENDSOUND=%SOUND1_MP3%
if "%SOUND_SET%"=="2" set ENDSOUND=%SOUND2_MP3%
if "%SOUND_SET%"=="3" set ENDSOUND=%SOUND3_MP3%
if "%SOUND_SET%"=="4" set ENDSOUND=%SOUND4_MP3%
if "%SOUND_SET%"=="5" set ENDSOUND=%SOUND5_MP3%
if "%SOUND_SET%"=="6" set ENDSOUND=%SOUND6_MP3%
if "%SOUND_SET%"=="7" set ENDSOUND=%SOUND7_MP3%

echo %SOUND_SET% | "%WINDIR%\system32\findstr.exe" /i [8-9a-z()\-\[\]]>nul
if not ERRORLEVEL 1 (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    echo;
    goto save_sound_setting
)
:setfin
(echo "%ENDSOUND%")>%ENDSOUND_INFO%
echo %ENDSOUND_SETFIN%
pause>nul
exit
