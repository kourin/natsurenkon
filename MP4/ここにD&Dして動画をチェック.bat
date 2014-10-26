@echo off
cd /d "%~d0" 1>nul 2>&1
cd "%~p0..\tool\" 1>nul 2>&1

set PRETYPEY=%PRETYPE%y
set ACTYPEY=%ACTYPE%y
set YTTYPEY=%YTTYPE%y
set ENCTYPEY=%ENCTYPE%y
set PRETYPES_TEST=%PRETYPES_TEST%
set S_V_BITRATE=%S_V_BITRATE%
set KEEPWAVY=%KEEPWAV%
if defined S_V_BITRATE (
  set /a S_V_BITRATE_L=%S_V_BITRATE% * 105 / 100
) else (
  set /a S_V_BITRATE_L=0
)

call ..\setting\template\default_setting.bat
call ..\setting\user_setting.bat
call ..\setting\enc_setting.bat

set TEMP_DIR=TEMP\MOVIE_CHECK
if not exist %TEMP_DIR% (
  mkdir %TEMP_DIR%
)

set TEMP_INFO=%TEMP_DIR%\temp.txt
set INFO_AVS=%TEMP_DIR%\information.avs
set HTML_FILE1=Large_player.html
set HTML_FILE2=Middle_player.html
set HTML_FILE3=Movie_Info.html
set MOVIE_FILE=%~dp1%~nx1
set SIZE_JS=size.js
set BR_JS=br.js
set ECO_JS=eco.js

if defined MOVIE_FILE goto body
:file_drop_mode
echo;
echo ^>^>����t�@�C�����h���b�v���āA�G���^�[�L�[�������Ă�������
echo ^>^>�L����󔒂�����Ƃ��܂������Ȃ����Ƃ�����܂��B
set /P MOVIE_FILE=

if not defined MOVIE_FILE goto file_drop_mode

:body
echo "%MOVIE_FILE%" >%TEMP_INFO%
for /f "delims=" %%i in (%TEMP_INFO%) do set MOVIE_DIR=%%~dpi
for /f "delims=" %%i in (%TEMP_INFO%) do set MOVIE_NAME=%%~ni
for /f "delims=" %%i in (%TEMP_INFO%) do set MOVIE_TYPE=%%~xi
echo %MOVIE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "mp4 flv">nul
if not ERRORLEVEL 1 goto info_check
echo;
echo ^>^>mp4�Aflv�ȊO�̓���̍Đ��͂ł��܂���
echo ^>^>����ɓ���̏���\�����܂��B
pause
.\MediaInfo.exe --Output=HTML --LogFile=%TEMP_DIR%\%HTML_FILE3% "%MOVIE_FILE%">nul
start rundll32 url.dll,FileProtocolHandler "%TEMP_DIR%\%HTML_FILE3%"
exit

:info_check
echo;
echo ^>^>HTML %PROCESS_ANNOUNCE%
echo;
.\MediaInfo.exe --Inform=Video;%%Width%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set /a IN_WIDTH=%%i
.\MediaInfo.exe --Inform=Video;%%Height%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set /a IN_HEIGHT=%%i
.\MediaInfo.exe --Inform=Video;%%DisplayAspectRatio/String%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set ASPECT=%%i
.\MediaInfo.exe --Inform=Video;%%Duration/String3%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set DURATION=%%i
.\MediaInfo.exe --Inform=General;%%Duration%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f "delims=." %%i in (%TEMP_INFO%) do set TOTAL_TIME=%%i
.\MediaInfo.exe --Inform=Video;%%FrameRate/String%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set FPS=%%i
.\MediaInfo.exe --Inform=Video;%%BitRate%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set /a V_BITRATE=(%%i+500)/1000
.\MediaInfo.exe --Inform=Audio;%%BitRate%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set /a A_BITRATE=(%%i+500)/1000
.\MediaInfo.exe --Inform=General;%%FileSize%% --LogFile=%TEMP_INFO% "%MOVIE_FILE%">nul
for /f %%i in (%TEMP_INFO%) do set SIZE=%%i

(
    echo BlankClip^(length=1, width=32, height=32^)
    echo;
    echo _file_size_MB = String^(Ceil^(%SIZE% / 1024 / 1024 ^)^) 
    echo _effective_bitrate = String^(Floor^(Float^(%SIZE%^) * 8 / Floor^(%TOTAL_TIME% / 1000^) / 1000 ^)^)
    echo WriteFileStart^("file_size_MB.txt","_file_size_MB",append = false^)
    echo WriteFileStart^("effective_bitrate.txt","_effective_bitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS%
.\avs2pipemod.exe -info %INFO_AVS% 1>nul 2>&1
for /f "delims=" %%i in (%TEMP_DIR%\file_size_MB.txt) do set /a FILE_SIZE_MB=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\effective_bitrate.txt) do set /a T_BITRATE=%%i>nul

(
  echo var n = %SIZE%/1024.0/1024.0;
  echo n = n * 100;
  echo n = Math.floor^(n^);
  echo n = n / 100;
  echo document.write^(n^);
)> %TEMP_DIR%\%SIZE_JS%
(
  echo var n = Math.ceil^(%SIZE% * 8 / Math.floor^(%TOTAL_TIME% / 1000.0^) / 1000^);
  echo document.write^(n^);
)> %TEMP_DIR%\%BR_JS%
(
  echo var n = %SIZE% * 8 / Math.floor^(%TOTAL_TIME% / 1000.0^) / 1000.0;
  echo var Success = "�i�G�R�m�~�[����ł��Ă��܂��j";
  echo var Fail1 = "�i���ƁA";
  echo var Fail2 = "kbps�Ƃ�����Ɖ�����ƃG�R�m�~�[����ł��܂��j";
  echo var m = Math.ceil^(n - 445.0^);
  echo if ^( n ^<= 445.0 ^) {
  echo    document.write^(Success^); 
  echo }else{
  echo   if ^( n ^< 500.0 ^) {
  echo      document.write^(Fail1 + m + Fail2^); 
  echo   }
  echo }
)> %TEMP_DIR%\%ECO_JS%

(set /p ECOMESSAGE=)<%TEMP_DIR%\%ECO_JS%
if defined ECOMESSAGE (
  set ECOTEST=y
) else (
  set ECOTEST=n
)

.\MediaInfo.exe --Output=HTML --LogFile=%TEMP_DIR%\%HTML_FILE3% "%MOVIE_FILE%">nul

:Zero
set /a PLAYER_HEIGHT=480+24
set /a PLAYER_WIDTH=854
set /a TABLE_WIDTH=908

(
  echo ^<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"^>
  echo ^<html lang="ja"^>
  echo ^<head^>
  echo ^<meta http-equiv="Content-type" content="text/html; charset=Shift_JIS"^>
  echo ^<meta http-equiv="Pragma" content="no-cache"^>
  echo ^<meta http-equiv="Cache-Control" content="no-cache"^>
  echo ^<meta http-equiv="Expires" content="0"^>
  echo ^<title^>"%MOVIE_NAME%%MOVIE_TYPE%"^</title^>
  echo ^<meta http-equiv="Content-Style-Type" content="text/css"^>
  echo ^</head^>
  echo;
  echo ^<center^>
  echo ^<body bgcolor="#000000" text="#FFFFFF" link="#0F9FDB" vlink="#0F9FDB" alink="#0F88AA"^>
  echo ^<table border^>
  echo ^<tr^>^<td width="%TABLE_WIDTH%px"^>
  echo ^<center^>
  echo ^<font size="5" color="#F5C92E"^>"%MOVIE_NAME%%MOVIE_TYPE%"^</font^>^<br /^>
  echo ^����̃`�F�b�N�͑��̃v���C���[����Ȃ����̃v���C���[�Ń`�F�b�N���Ă�ˁI
  echo ^<script type="text/javascript"^>
  echo ^<!--
  echo if^(navigator.userAgent.indexOf^("Chrome"^) != -1^){ 
  echo	document.write^('^<br^>�u���悪���t����܂���v�ƕ\�����ꂽ�ꍇ�̑΍��^<a href="http://bit.ly/St2hMX" title="�g���u���V���[�e�B���O - ��ł�� �܂Ƃ�wiki" target="_blank" class="new"^>������^</a^>^<br^>'^);
  echo }
  echo // --^>
  echo ^</script^>
  echo ^<script type='text/javascript' src='../../swfobject.js'^>^</script^>
  echo ^<div id='mediaspace'^>�v���C���[���\������Ȃ��ꍇ�͏��o�[���N���b�N���ăv���O�����������Ă�^</div^>
  echo;
  echo ^<script type='text/javascript'^>
  echo   var so = new SWFObject^('../../player.swf','mpl','%PLAYER_WIDTH%','%PLAYER_HEIGHT%','9'^);
  echo   so.addParam^('allowfullscreen','true'^);
  echo   so.addParam^('allowscriptaccess','always'^);
  echo   so.addParam^('wmode','opaque'^);
  echo   so.addVariable^('file',"file:///%MOVIE_FILE:\=/%"^);
  echo   so.addVariable^('volume','50'^);
  echo   so.addVariable^('stretching','uniform'^);
rem  echo   so.addVariable^('autostart','true'^);
  echo   so.write^('mediaspace'^);
  echo ^</script^>
  echo;
  echo ^<h6^>Powered by ^<a href="http://www.longtailvideo.com/players/jw-flv-player/" target="_blank" class="new"^>JW Player^</a^>^</h6^>
  echo;
  echo ^<hr^>
  echo;
  echo ^<div class="table"^>
  echo ^<table border=2 summary="������"^>
  echo   ^<caption^>^<h3^>������^</h3^>^</caption^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t�@�C����^</td^>
  echo  ^<td^>"%MOVIE_NAME%%MOVIE_TYPE%"^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo   ^<td^>�t�H���_^</td^>
  echo   ^<td^>"%MOVIE_DIR%"^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�𑜓x^</td^>
  echo   ^<td^>%IN_WIDTH%x%IN_HEIGHT%
  if /i not "%PRETYPEY%"=="yy" (
     if /i not "%ACTYPEY%"=="yy" (
        if %IN_WIDTH% GTR %I_MAX_WIDTH% (
           echo ^<br^>^(^<font color="red"^>%RETURN_MESSAGE10%^</font^>^)
        ) else if %IN_HEIGHT% GTR %I_MAX_HEIGHT% (
           echo ^<br^>^(^<font color="red"^>%RETURN_MESSAGE10%^</font^>^)
        )
     )
  )
  if %IN_HEIGHT% LSS 480 echo ^<br /^>^(���悪�������΂���ĕ\������Ă��邽�ߍr���Ȃ��Ă��܂�^)
  echo ^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�A�X�y�N�g��^</td^>
  echo  ^<td^>%ASPECT%^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�Đ�����^</td^>
  echo  ^<td^>%DURATION%^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t���[�����[�g^</td^>
  echo  ^<td^>%FPS%fps^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�r�b�g���[�g^</td^>
  echo  ^<td^>^<script type="text/javascript" src="%BR_JS%"^>^</script^>kbps ^(�f��%V_BITRATE%kbps�A����%A_BITRATE%kbps^)
  if "%PRETYPES_TEST%"=="y" (
    if %V_BITRATE% GTR %S_V_BITRATE_L% (
      echo ^<br^>^(%PRETYPES4%^)
      echo ^<br^>^(%PRETYPES3%^)
    )
  )
  if /i not "%ACTYPEY%"=="yy" (
     if /i not "%PRETYPEY%"=="yy" (
        if %T_BITRATE% GTR %I_MAX_BITRATE% (
           echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK2% %RETURN_MESSAGE3%^</font^>^)
        )
     )
  )
  if /i "%ECOTEST%"=="y" (
    echo ^<br^>^<script type="text/javascript" src="%ECO_JS%"^>^</script^>
  )
  echo ^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t�@�C���e��^</td^>
  echo  ^<td^>^<script type="text/javascript" src="%SIZE_JS%"^>^</script^>MB
  if /i not "%PRETYPEY%"=="yy" (
     if /i "%ACTYPEY%"=="yy" (
         if %FILE_SIZE_MB% GTR 100 (
             echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT2%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
         ) else (
             echo ^<br^>^(%CONFIRM_ACCOUNT2%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^</td^>
         )
     ) else if /i "%ACTYPEY%"=="ny" (
         if %FILE_SIZE_MB% GTR 40 (
             echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
         ) else (
             echo ^<br^>^(%CONFIRM_ACCOUNT2%, %CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^</td^>
         )
     ) else (
        if %FILE_SIZE_MB% GTR 100 (
            echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT2%, %CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
        ) else if %FILE_SIZE_MB% GTR 40 (
            echo ^<br^>^(^%CONFIRM_ACCOUNT2%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^<br^>
            echo ^(^<font color="red"^>%CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
        ) else (
            echo ^<br^>^(%CONFIRM_ACCOUNT2%, %CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^</td^>
        )
     )
  ) else if /i "%PRETYPEY%"=="yy" (
     if /i "%YTTYPEY%"=="yy" (
        if %FILE_SIZE_MB% LEQ 20480 (
            echo ^<br^>^(^YouTube%UP_CHECK1%: %SIZE_SUCCESS2%^)^<br^>
        ) else (
            echo ^(^<font color="red"^>YouTube%UP_CHECK2%: %SIZE_ERROR1%^</font^>^)^</td^>
        )
     ) else (
        if %FILE_SIZE_MB% LEQ 2048 (
            echo ^<br^>^(^YouTube%UP_CHECK1%: %SIZE_SUCCESS2%^)^<br^>
        ) else (
            echo ^(^<font color="red"^>YouTube%UP_CHECK2%: %SIZE_ERROR1%^</font^>^)^</td^>
        )
     )
  ) else (
    echo ^</td^>
  )
  echo   ^</tr^>
  echo ^<tr^>^<td colspan="2"^>^<center^>^<a href="%HTML_FILE3%" target="_blank" class="new"^>����̂��ڍׂȏ��^</a^>^</center^>^</td^>^</tr^>
  echo ^</table^>
  echo ^</div^>
  if /i "%KEEPWAVY%"=="y" (
     echo ���������Y�����Ă���ꍇ�́AMP4�t�H���_����wav�t�@�C�����o���Ă���͂�������A^<br^>
     echo ����wav������G���R�[�h���Ăł���mp4�ƈꏏ�Ɂy�����ɓ����D^&amp^;D�z.bat�Ƀh���b�v���āA^<br^>
     echo �v���Z�b�g��s��I�����āA���Y���C����y�Ƃ�n�Ƃ��蓮�Ƃ��A���낢��ς��Ă݂ĂˁB^<br^>
     echo �f���G���R�Ȃ��ŉ����G���R�݂̂�����A����ȂɎ��Ԃ͂�����Ȃ��Ǝv����B^<br^>
  )
  echo ^<hr^>
  echo ^</center^>
  echo;
  echo ^</td^>
  echo ^<td class="menu" valign="top" width="220"^>
  echo ^<p^>^<a href="%HTML_FILE2%"^>����ʁi640x360�j�ɕύX^</a^>^</p^>
  echo ���̃v���C���[�͎኱�J�N�J�N���邯�ǃj�R�j�R�Ɓu�قځv������������I^<br^>
  echo �i��Ԃ����m�F���@�͂���ς�j�R�j�R�ւ̉��A�b�v���[�h�Ȃ񂾂��ǂˁj^<br^>
  echo �� �㉺���E�ɍ����̈悪����ꍇ�����邯�ǃv���C���[�̎d�l������C�ɂ��Ȃ��ł�
  echo ^<hr^>
  echo ^<center^>�Q�l�����N�W^</center^>
  echo ^<ul style="layout-grid-line: 0.5em;"^>
  echo ^<li^>^<a href="http://www43.atwiki.jp/tdenc/" target="_blank" class="new"^>��ł�񂱂܂Ƃ�wiki^</a^>^</li^>
  echo ^<li^>^<a href="http://www43.atwiki.jp/tdenc/pages/27.html" title="�p��W - ��ł�񂱂܂Ƃ�wiki" target="_blank" class="new"^>�G���R�[�h�֘A�p��W^</a^>^</li^>
  echo ^<li^>^<a href="http://nicowiki.com/" target="_blank" class="new"^>�j�R�j�R����܂Ƃ�wiki^</a^>^</li^>
  echo ^<li^>^<a href="http://help.nicovideo.jp/cat22/" title="���擊�e�ɂ��� - �j�R�j�R���� �w���v" target="_blank" class="new"^>�j�R�j�R���� ���e�w���v^</a^>^</li^>
  echo ^<li^>^<a href="http://ch.nicovideo.jp/natsurenkon/blomaga/ar32203" title="�j�R�j�R��������G���R�[�h�ɂ���" target="_blank" class="new"^>�j�R�j�R��������G���R�[�h�ɂ���^</a^>^</li^>
  echo ^<li^>^<a href="http://bit.ly/1cfGB6I" title="YouTube :���������r�b�g���[�g�A�R�[�f�b�N�A�𑜓x�Ȃ�" target="_blank" class="new"^>YouTube �����𑜓x ^</a^>^</li^>
  echo ^<li^>^<a href="http://nikokara.web.fc2.com/encode2.html" title="�ԐF�̗򉻂ɂ��� - �ۂՂ̎�����" target="_blank" class="new"^>MP4�̐ԐF�򉻖��^</a^>^</li^>
  echo ^<li^>^<a href="http://chround30.blog.fc2.com/blog-entry-22.html" title="�Ę@�����g�p�����̂��Ă݂�����쐬�菇 - �p���_�C�X���P���W" target="_blank" class="new"^>�Ę@�����g�p�����̂��Ă݂�����쐬�菇^</a^>^</li^>
  echo ^</ul^>
  echo ^</td^>
  echo ^</table^>
  echo ^</center^>
  echo;
  echo ^<center^>
  echo ^<FORM^>^<TEXTAREA rows="2" cols="120" onmouseover="this.select()"^>"%MOVIE_FILE%"^</TEXTAREA^>^</FORM^>
if /i not "%PRETYPEY%"=="yy" (
  echo ^<p^>^<a href="http://www.upload.nicovideo.jp/upload" target="_blank"^>�j�R�j�R����ɓ��e^</a^>^</p^>
) else (
  echo ^<p^>^<a href="http://www.youTube.com/my_videos_upload" target="_blank"^>YouTube�ɓ��e^</a^>^</p^>
)
  echo ^</center^>
  echo;
  echo ^</body^>
  echo ^</html^>
)> %TEMP_DIR%\%HTML_FILE1%

:OLD
set /a PLAYER_HEIGHT=384+24
set /a PLAYER_WIDTH=640
set /a TABLE_WIDTH=640+10

(
  echo ^<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"^>
  echo ^<html lang="ja"^>
  echo ^<head^>
  echo ^<meta http-equiv="Content-type" content="text/html; charset=Shift_JIS"^>
  echo ^<meta http-equiv="Pragma" content="no-cache"^>
  echo ^<meta http-equiv="Cache-Control" content="no-cache"^>
  echo ^<meta http-equiv="Expires" content="0"^>
  echo ^<title^>"%MOVIE_NAME%%MOVIE_TYPE%"^</title^>
  echo ^<meta http-equiv="Content-Style-Type" content="text/css"^>
  echo ^</head^>
  echo;
  echo ^<center^>
  echo ^<body bgcolor="#ffeaea" text="#000000" link="#0000ff" vlink="#800080" alink="#ff0000"^>
  echo ^<table border^>
  echo ^<tr^>^<td width="%TABLE_WIDTH%px"^>
  echo ^<center^>
  echo ^<font size="5"^>"%MOVIE_NAME%%MOVIE_TYPE%"^</font^>^<br /^>
  echo ^����̃`�F�b�N�͑��̃v���C���[����Ȃ����̃v���C���[�Ń`�F�b�N���Ă�ˁI
  echo ^<script type="text/javascript"^>
  echo ^<!--
  echo if^(navigator.userAgent.indexOf^("Chrome"^) != -1^){ 
  echo	document.write^('^<br^>�u���悪���t����܂���v�ƕ\�����ꂽ�ꍇ�̑΍��^<a href="http://bit.ly/St2hMX" title="�g���u���V���[�e�B���O - ��ł�� �܂Ƃ�wiki" target="_blank" class="new"^>������^</a^>^<br^>'^);
  echo }
  echo // --^>
  echo ^</script^>
  echo ^<script type='text/javascript' src='../../swfobject.js'^>^</script^>
  echo ^<div id='mediaspace'^>�v���C���[���\������Ȃ��ꍇ�͏��o�[���N���b�N���ăv���O�����������Ă�^</div^>
  echo;
  echo ^<script type='text/javascript'^>
  echo   var so = new SWFObject^('../../player.swf','mpl','%PLAYER_WIDTH%','%PLAYER_HEIGHT%','9'^);
  echo   so.addParam^('allowfullscreen','true'^);
  echo   so.addParam^('allowscriptaccess','always'^);
  echo   so.addParam^('wmode','opaque'^);
  echo   so.addVariable^('file',"file:///%MOVIE_FILE:\=/%"^);
  echo   so.addVariable^('volume','50'^);
  echo   so.addVariable^('stretching','uniform'^);
rem  echo   so.addVariable^('autostart','true'^);
  echo   so.write^('mediaspace'^);
  echo ^</script^>
  echo;
  echo ^<h6^>Powered by ^<a href="http://www.longtailvideo.com/players/jw-flv-player/" target="_blank"^>JW Player^</a^>^</h6^>
  echo;
  echo ^<hr^>
  echo;
  echo ^<div class="table"^>
  echo ^<table border=2 summary="������"^>
  echo   ^<caption^>^<h3^>������^</h3^>^</caption^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t�@�C����^</td^>
  echo  ^<td^>"%MOVIE_NAME%%MOVIE_TYPE%"^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo   ^<td^>�t�H���_^</td^>
  echo   ^<td^>"%MOVIE_DIR%"^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�𑜓x^</td^>
  echo   ^<td^>%IN_WIDTH%x%IN_HEIGHT%
  if /i not "%ACTYPEY%"=="yy" (
     if /i not "%PRETYPEY%"=="yy" (
        if %IN_WIDTH% GTR %I_MAX_WIDTH% (
           echo ^<br^>^(^<font color="red"^>%RETURN_MESSAGE10%^</font^>^)
        )  else if %IN_HEIGHT% GTR %I_MAX_HEIGHT% (
           echo ^<br^>^(^<font color="red"^>%RETURN_MESSAGE10%^</font^>^)
        )
     )
  )
  if %IN_HEIGHT% LSS 360 echo ^<br /^>(���悪�������΂���ĕ\������Ă��邽�ߍr���Ȃ��Ă��܂�^)
  echo ^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�A�X�y�N�g��^</td^>
  echo  ^<td^>%ASPECT%^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�Đ�����^</td^>
  echo  ^<td^>%DURATION%^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t���[�����[�g^</td^>
  echo  ^<td^>%FPS%fps^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�r�b�g���[�g^</td^>
  echo  ^<td^>^<script type="text/javascript" src="%BR_JS%"^>^</script^>kbps ^(�f��%V_BITRATE%kbps�A����%A_BITRATE%kbps^)
  if "%PRETYPES_TEST%"=="y" (
    if %V_BITRATE% GTR %S_V_BITRATE_L% (
      echo ^<br^>^(%PRETYPES4%^)
      echo ^<br^>^(%PRETYPES3%^)
    )
  )
  if /i not "%ACTYPEY%"=="yy" (
     if /i not "%PRETYPEY%"=="yy" (
        if %T_BITRATE% GTR %I_MAX_BITRATE% (
           echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT1% %RETURN_MESSAGE3%^</font^>^)
        )
     )
  )
  if "%ECOTEST%"=="y" (
    echo ^<br^>^<script type="text/javascript" src="%ECO_JS%"^>^</script^>
  )
  echo ^</td^>
  echo   ^</tr^>
  echo   ^<tr align=center^>
  echo  ^<td^>�t�@�C���e��^</td^>
  echo  ^<td^>^<script type="text/javascript" src="%SIZE_JS%"^>^</script^>MB
  if /i not "%PRETYPEY%"=="yy" (
     if /i "%ACTYPEY%"=="yy" (
         if %FILE_SIZE_MB% GTR 100 (
             echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT2%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
         ) else (
             echo ^<br^>^(%CONFIRM_ACCOUNT2%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^</td^>
         )
     ) else if /i "%ACTYPEY%"=="ny" (
         if %FILE_SIZE_MB% GTR 40 (
             echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
         ) else (
             echo ^<br^>^(%CONFIRM_ACCOUNT2%, %CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^</td^>
         )
     ) else (
        if %FILE_SIZE_MB% GTR 100 (
            echo ^<br^>^(^<font color="red"^>%CONFIRM_ACCOUNT2%, %CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
        ) else if %FILE_SIZE_MB% GTR 40 (
            echo ^<br^>^(^%CONFIRM_ACCOUNT2%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^<br^>
            echo ^(^<font color="red"^>%CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK2% %SIZE_ERROR1%^</font^>^)^</td^>
        ) else (
            echo ^<br^>^(%CONFIRM_ACCOUNT2%, %CONFIRM_ACCOUNT3%%CONFIRM_ACCOUNT11%%UP_CHECK1% %SIZE_SUCCESS2%^)^</td^>
        )
     )
  ) else if /i "%PRETYPEY%"=="yy" (
     if /i "%YTTYPEY%"=="yy" (
        if %FILE_SIZE_MB% LEQ 20480 (
            echo ^<br^>^(^YouTube%UP_CHECK1%: %SIZE_SUCCESS2%^)^<br^>
        ) else (
            echo ^(^<font color="red"^>YouTube%UP_CHECK2%: %SIZE_ERROR1%^</font^>^)^</td^>
        )
     ) else (
        if %FILE_SIZE_MB% LEQ 2048 (
            echo ^<br^>^(^YouTube%UP_CHECK1%: %SIZE_SUCCESS2%^)^<br^>
        ) else (
            echo ^(^<font color="red"^>YouTube%UP_CHECK2%: %SIZE_ERROR1%^</font^>^)^</td^>
        )
     )
  ) else (
    echo ^</td^>
  )
  echo   ^</tr^>
  echo ^<tr^>^<td colspan="2"^>^<center^>^<a href="%HTML_FILE3%" target="_blank" class="new"^>����̂��ڍׂȏ��^</a^>^</center^>^</td^>^</tr^>
  echo ^</table^>
  echo ^</div^>
  if /i "%KEEPWAVY%"=="y" (
     echo ���������Y�����Ă���ꍇ�́AMP4�t�H���_����wav�t�@�C�����o���Ă���͂�������A^<br^>
     echo ����wav������G���R�[�h���Ăł���mp4�ƈꏏ�Ɂy�����ɓ����D^&amp^;D�z.bat�Ƀh���b�v���āA^<br^>
     echo �v���Z�b�g��s��I�����āA���Y���C����y�Ƃ�n�Ƃ��蓮�Ƃ��A���낢��ς��Ă݂ĂˁB^<br^>
     echo �f���G���R�Ȃ��ŉ����G���R�݂̂�����A����ȂɎ��Ԃ͂�����Ȃ��Ǝv����B^<br^>
  )
  echo ^<hr^>
  echo ^</center^>
  echo;
  echo ^</td^>
  echo ^<td class="menu" valign="top" width="220"^>
  echo ^<p^>^<a href="%HTML_FILE1%"^>���ʁi854x480�j�ɕύX^</a^>^</p^>
  echo ���̃v���C���[�͎኱�J�N�J�N���邯�ǃj�R�j�R�Ɓu�قځv������������I^<br^>
  echo �i��Ԃ����m�F���@�͂���ς�j�R�j�R�ւ̉��A�b�v���[�h�Ȃ񂾂��ǂˁj^<br^>
  echo �� �㉺���E�ɍ����̈悪����ꍇ�����邯�ǃv���C���[�̎d�l������C�ɂ��Ȃ��ł�
  echo ^<hr^>
  echo ^<center^>�Q�l�����N�W^</center^>
  echo ^<ul style="layout-grid-line: 0.5em;"^>
  echo ^<li^>^<a href="http://www43.atwiki.jp/tdenc/" target="_blank" class="new"^>��ł�񂱂܂Ƃ�wiki^</a^>^</li^>
  echo ^<li^>^<a href="http://www43.atwiki.jp/tdenc/pages/27.html" title="�p��W - ��ł�񂱂܂Ƃ�wiki" target="_blank" class="new"^>�G���R�[�h�֘A�p��W^</a^>^</li^>
  echo ^<li^>^<a href="http://nicowiki.com/" target="_blank" class="new"^>�j�R�j�R����܂Ƃ�wiki^</a^>^</li^>
  echo ^<li^>^<a href="http://help.nicovideo.jp/cat22/" title="���擊�e�ɂ��� - �j�R�j�R���� �w���v" target="_blank" class="new"^>�j�R�j�R���� ���e�w���v^</a^>^</li^>
  echo ^<li^>^<a href="http://ch.nicovideo.jp/natsurenkon/blomaga/ar32203" title="�j�R�j�R��������G���R�[�h�ɂ��� - �Ę@�������e�i�̃u���}�K" target="_blank" class="new"^>�j�R�j�R��������G���R�[�h�ɂ���^</a^>^</li^>
  echo ^<li^>^<a href="http://bit.ly/1cfGB6I" title="YouTube :���������r�b�g���[�g�A�R�[�f�b�N�A�𑜓x�Ȃ�" target="_blank" class="new"^>YouTube �����𑜓x ^</a^>^</li^>
  echo ^<li^>^<a href="http://nikokara.web.fc2.com/encode2.html" title="�ԐF�̗򉻂ɂ��� - �ۂՂ̎�����" target="_blank" class="new"^>MP4�̐ԐF�򉻖��^</a^>^</li^>
  echo ^<li^>^<a href="http://chround30.blog.fc2.com/blog-entry-22.html" title="�Ę@�����g�p�����̂��Ă݂�����쐬�菇 - �p���_�C�X���P���W" target="_blank" class="new"^>�Ę@�����g�p�����̂��Ă݂�����쐬�菇^</a^>^</li^>
  echo ^</ul^>
  echo ^</td^>
  echo ^</table^>
  echo ^</center^>
  echo;
  echo ^<center^>
  echo ^<FORM^>^<TEXTAREA rows="2" cols="120" onmouseover="this.select()"^>"%MOVIE_FILE%"^</TEXTAREA^>^</FORM^>
if /i not "%PRETYPEY%"=="yy" (
  echo ^<p^>^<a href="http://www.upload.nicovideo.jp/upload" target="_blank"^>�j�R�j�R����ɓ��e^</a^>^</p^>
) else (
  echo ^<p^>^<a href="http://www.youTube.com/my_videos_upload" target="_blank"^>YouTube�ɓ��e^</a^>^</p^>
)
  echo ^</center^>
  echo;
  echo ^</body^>
  echo ^</html^>
)> %TEMP_DIR%\%HTML_FILE2%

if /i "%PLAYER_MODE%"=="NEW" (
  set HTML_FILE=%HTML_FILE1% 
) else (
  set HTML_FILE=%HTML_FILE2% 
)
echo;

if not defined CBROWSER (
  start rundll32 url.dll,FileProtocolHandler "%TEMP_DIR%\%HTML_FILE%"
  goto :eof
)

echo %CBROWSER% | "%WINDIR%\system32\findstr.exe" /i "iexplore.exe">nul
if not ERRORLEVEL 1 (
  start %CBROWSER% "%~d0%~p0..\tool\%TEMP_DIR%\%HTML_FILE%"
) else (
  start "" %CBROWSER% "%~d0%~p0..\tool\%TEMP_DIR%\%HTML_FILE%"
)