rem ################変数設定################
set /a TOTAL_TIME_LIM=15 * 60
set CONFIRM=
set DECODERI=%DECODER%
set AUTOECOI=%AUTOECO%
rem ################エンコ設定選択開始################
echo %HORIZON%
echo %QUESTION_START1%
echo %QUESTION_START2%
echo %QUESTION_START3%
echo %HORIZON%
echo;
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\QUESTION_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\QUESTION_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\QUESTION_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\QUESTION_START1.wav"
      )
    )
  )
)

if not "%ENC_MODE%"=="SEQUENCE" (
  if not "%PAIR_MODE%"=="true" goto mode_select
)
if not "%RELOAD_SETTINGS%"=="true" goto mode_select

set PRETYPEI=
set T_BITRATEI=
call "..\setting\enc_setting.bat"
set DECODER=%DECODERI%

:mode_select
if "%HARUMODE%"=="false" goto mode_select2

if not defined DECTYPE set DECTYPE=n
if not defined RESIZE  set RESIZE=y
if not defined A_SYNC  set A_SYNC=a
if not defined A_GAIN  set A_GAIN=n
set SKIP_MODE=true

echo %PRETYPE% | "%WINDIR%\system32\findstr.exe" "[1-9]">nul
if not ERRORLEVEL 1 set PRETYPE=

if "%HARUTYPE%"=="youtube" (
  set PRETYPE=y
  set YTTYPE=y
  set YTCONFIRM=y
) else if "%HARUTYPE%"=="normalmovie" (
  if not defined PRETYPE set PRETYPE=m
  set ACTYPE=n
  if not defined ENCTYPE set ENCTYPE=n
  if not defined TEMP_BITRATE set /a TEMP_BITRATE=96
) else if "%HARUTYPE%"=="normalaudio" (
  if not defined PRETYPE set PRETYPE=m
  set ACTYPE=n
  if not defined ENCTYPE set ENCTYPE=n
  if not defined TEMP_BITRATE set /a TEMP_BITRATE=256
) else if "%HARUTYPE%"=="economymovie" (
  if not defined PRETYPE set PRETYPE=m
  set ACTYPE=n
  set ENCTYPE=y
  if not defined TEMP_BITRATE set /a TEMP_BITRATE=96
) else if "%HARUTYPE%"=="economyaudio" (
  if not defined PRETYPE set PRETYPE=m
  set ACTYPE=n
  set ENCTYPE=y
  if not defined TEMP_BITRATE set /a TEMP_BITRATE=256
) else if "%HARUTYPE%"=="premiummovie" (
  if not defined PRETYPE (
    if P_TEMP_BITRATE GTR 1000 
      set PRETYPE=m
    ) else (
      set PRETYPE=n
    )
  )
  set ACTYPE=y
  if not defined ENCTYPE set ENCTYPE=n
  if not defined T_BITRATE set /a T_BITRATE=1500
  if not defined TEMP_BITRATE set /a TEMP_BITRATE=96
  set BEGINNER=true
) else (
  if not defined PRETYPE set PRETYPE=a
  set ACTYPE=y
  if not defined TEMP_BITRATE set /a TEMP_BITRATE=128
)
if not "%PRESET_S_ENABLE%"=="true" goto mode_select2
if not defined REFVALUE goto mode_select2
if not defined BFRAMEVALUE goto mode_select2
if /i "%ACTYPE%"=="y" (
    if %REFVALUE% LEQ 8 (
      if %BFRAMEVALUE% LEQ 4 (
        if %EA_BITRATE% GEQ 240 (
         set ENCTYPE=y
         set PRETYPE=s
         set /a TEMP_BITRATE=%E_MAX_BITRATE% - %S_V_BITRATE% - 5
        )
      )
    )
) else if /i "%ACTYPE%"=="n" (
  if "%PRESET_SI_ENABLE%"=="true" (
    if %REFVALUE% LEQ 8 (
      if %BFRAMEVALUE% LEQ 4 (
        if %EA_BITRATE% GEQ 240 (
           set ENCTYPE=y
           set PRETYPE=s
           set /a TEMP_BITRATE=%E_MAX_BITRATE% - %S_V_BITRATE% - 5
         )
      )
    )
  )
)

if %EA_BITRATE% LEQ 0 goto mode_select2
if %TEMP_BITRATE% GTR %AUTO_A_BITRATE% set /a TEMP_BITRATE=%AUTO_A_BITRATE% 

:mode_select2
if "%ENC_MODE%"=="IMAGEMUX" (
    set DECTYPE=n
    set A_SYNC=n
    set A_GAIN=0
)
if "%ENC_MODE%"=="AVSENC" set RESIZE=n
if "%SILENT%"=="true" set /a TEMP_BITRATE=0

set /a MP3_SIZE_PREMIUMB=%MP3_SIZE_PREMIUM%*1024*1024
set /a MP3_SIZE_NORMALB=%MP3_SIZE_NORMAL%*1024*1024

if %IN_WIDTH% GTR %I_MAX_WIDTH% set FORCERESIZE=y
if %IN_HEIGHT% GTR %I_MAX_HEIGHT% set FORCERESIZE=y

if not exist %ENC_RECORD% goto preset
for /f "delims=" %%i in (%ENC_RECORD%) do set /a MAX_BR_RECORD=%%i
if %MAX_BR_RECORD% LEQ 2000 (
  set /a AUTO_ENC_LIMIT=2000 
) else (
  set /a AUTO_ENC_LIMIT=2500 
)
set /a AUTO_ENC_LIMIT2=3000

rem プリセット選択
:preset
date /t>nul
echo %PRETYPEI% | "%WINDIR%\system32\findstr.exe" "[1-9]">nul
if ERRORLEVEL 1 (
  if defined PRETYPEI set PRETYPE=%PRETYPEI%
)
if defined PRETYPE goto preset_main

:preset_question
echo;
echo ^>^>%PRESET_START1%
echo ^>^>%PRESET_START2%
echo ^>^>%QUESTION_START3%
echo %HORIZON%
echo   a:%PRESET_LIST0%
echo   l:%PRESET_LIST1%
echo   m:%PRESET_LIST2%
echo   n:%PRESET_LIST3%
echo   o:%PRESET_LIST4%
echo   p:%PRESET_LIST5%
echo   q:%PRESET_LIST6%
echo   t:%PRESET_LIST10%
if "%PRESET_S_ENABLE%"=="true" (
        echo   s:%PRESET_LIST7%
)
echo   x:%PRESET_LIST8%
echo;
echo   y:%PRESET_LIST9%
if "%PRESET_S_ENABLE%"=="pending" (
        echo;
        echo   s:%PRESET_LIST11%
        echo     %PRESET_MESSAGE2%
)
dir /n /b ..\setting\custom_enc_settings\*.bat 1> %TEMP_INFO% 2>nul
for %%i IN (%TEMP_INFO%) do set CESS=%%~zi
if %CESS% LEQ 1 goto preset_question_close
set DECODERI=%DECODER%
echo;
set N=0
SETLOCAL ENABLEDELAYEDEXPANSION
for /f "delims=" %%i in (%TEMP_INFO%) do (
     set /a N=!N!+1
     call "..\setting\custom_enc_settings\%%i" 2>nul
     echo   !N!:!TITLE!
)
ENDLOCAL
call "..\setting\enc_setting.bat"
set DECODER=%DECODERI%
:preset_question_close
echo %HORIZON%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\PRESET_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PRESET_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\PRESET_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PRESET_START1.wav"
      )
    )
  )
)
set /p PRETYPEI=^>^>

if not defined PRETYPEI (
  echo ^>^>%RETURN_MESSAGE1%
  if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
  )
  goto preset_question
)

if "%PRESET_S_ENABLE%"=="false" (
   if /i "%PRETYPEI%"=="s" (
      echo ^>^>%RETURN_MESSAGE1%
      if not "%HARUMODE%"=="true" (
          if /i "%VOICE%"=="true" (
            if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
            ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
            )
          )
      )
      echo;
      goto preset_question
   )
   if /i "%PRETYPEI%"=="s s" (
      echo ^>^>%RETURN_MESSAGE1%
      if not "%HARUMODE%"=="true" (
          if /i "%VOICE%"=="true" (
            if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
            ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
            )
          )
      )
      echo;
      goto preset_question
   )
)

if /i "%PRETYPEI%"=="s" (
    if /i not "%INPUT_FILE_TYPE%"==".mp4" (
        echo ^>^>%PRESET_MESSAGE1%
        echo ^>^>%PAUSE_MESSAGE2%
        pause>nul
        goto preset_question
    )
    set PRETYPE=s
    goto preset_main
)

if /i "%PRETYPEI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%PRETYPEI%") do set PRETYPE=%%A
  set PRETYPES=y
) else (
  set PRETYPE=%PRETYPEI%
  set PRETYPES=n
)
if not defined PRETYPE (
  echo ^>^>%RETURN_MESSAGE1%
  if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
  )
  goto preset_question
)

:preset_main
set PRETYPEI=%PRETYPE%
date /t>nul
echo %PRETYPE% | "%WINDIR%\system32\findstr.exe" "[1-9]">nul
if not ERRORLEVEL 1 set /a CUSTOM_SETTING_N=%PRETYPE% - 1
if defined CUSTOM_SETTING_N (
   if "%CUSTOM_SETTING_N%"=="0" (
      for /f "delims=" %%i in (%TEMP_INFO%) do (
        set CUSTOM_SETTING_BAT=..\setting\custom_enc_settings\%%i
        goto set_custom_parameters
      )
   ) else (   
      for /f "skip=%CUSTOM_SETTING_N% delims=" %%i in (%TEMP_INFO%) do (
        set CUSTOM_SETTING_BAT=..\setting\custom_enc_settings\%%i
        goto set_custom_parameters
      )
   )
)
:set_custom_parameters
if defined CUSTOM_SETTING_N call "%CUSTOM_SETTING_BAT%" 2>nul
if not defined PRETYPE (
    set CUSTOM_SETTING_N=
    goto preset_question
) else if /i "%PRETYPE%"=="s" (
    if not "%ENC_MODE%"=="MOVIEMUX" (
      set CUSTOM_SETTING_N=
      goto preset_question
    )
    if /i not "%INPUT_FILE_TYPE%"==".mp4" (
       echo ^>^>%PRESET_MESSAGE%
       echo ^>^>%PAUSE_MESSAGE2%
       pause>nul
       set CUSTOM_SETTING_N=
       goto preset_question
    )
    set DECTYPE=n
    set DEINT=n
    set RESIZE=n
    set CRF_TEST=n
    set /a T_BITRATE=%P_TEMP_BITRATE%
    if %CURRENT_BITRATE% LSS %E_MAX_BITRATE% (
      set /a ME_BITRATE = %E_MAX_BITRATE% - %S_V_BITRATE% - 5
      set /a E_TARGET_BITRATE= %E_MAX_BITRATE% - 5
    ) else (
      set ENCTYPE=n
    )
    set /a TEMP_264_BITRATE=%S_V_BITRATE%
    goto account
) else if /i "%PRETYPE%"=="a" (
    set BEGINNER=true
    set PRETYPE=m
    if "%DECTYPE%"=="" set DECTYPE=n
    if "%RESIZE%"==""  set RESIZE=y
    if "%ENCTYPE%"=="" set ENCTYPE=n
    if "%TEMP_BITRATE%"=="" set /a TEMP_BITRATE=128
    if "%T_BITRATE%"=="" set /a T_BITRATE=1500
    if "%A_SYNC%"=="" set A_SYNC=a
    if "%A_GAIN%"=="" set /a A_GAIN=0
    goto account
) else if /i "%PRETYPE%"=="y" (
    set CRFMODE=y
    call ..\setting\y\high.bat
    set ENCTYPE=n
    set DECTYPE=n
    set RESIZE=n
    set FORCERESIZE=n
    if not "%SILENT%"=="true" (
      if "%AUDIO_CODEC%"=="40" (
         set TEMP_BITRATE=%INPUT_A_BITRATE%
      ) else (
         set TEMP_BITRATE=%Y_A_BITRATE2%
      )
    ) else (
      set TEMP_BITRATE=0
    )
    set COLORMATRIX_ORIGNAL=%COLORMATRIX%
    set COLORMATRIX=BT.709
    set AUTOECO=n
    goto youtube_filesize_check
) else if /i "%PRETYPE%"=="t" (
    set CRFMODE=y
    set ENCTYPE=n
    goto crfenc
) 

if /i "%PRETYPE%"=="c" goto account
if /i "%PRETYPE%"=="l" goto account
if /i "%PRETYPE%"=="m" goto account
if /i "%PRETYPE%"=="n" goto account
if /i "%PRETYPE%"=="o" goto account
if /i "%PRETYPE%"=="p" goto account
if /i "%PRETYPE%"=="q" goto account
if /i "%PRETYPE%"=="t" goto account
if /i "%PRETYPE%"=="y" goto account
if /i "%PRETYPE%"=="x" goto pretype_x_crf_test
if not "%PRESET_S_ENABLE%"=="false" (
  if /i "%PRETYPE%"=="s" goto account
)
echo;
echo ^>^>%RETURN_MESSAGE1%
if not "%HARUMODE%"=="true" (
  if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
  )
)
echo;
set CUSTOM_SETTING_N=
goto preset_question

:pretype_x_crf_test
set ENCTYPE=n
set DECTYPE=n
call ..\setting\x\high.bat
if defined CRF (
        set CRFTYPE=%CRF%
        set CRFMODE=y
        goto crfenc
)
set CRFMODE=n
goto account

rem CRF指定エンコモード
:crfenc
if defined CRFTYPE goto crfenc_main

:crfenc_question
echo;
echo ^>^>%PREMIUM_START5%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
echo %HORIZON%
echo   k:%CRF_LIST1%
echo   m:%CRF_LIST2%
echo   q:%CRF_LIST3%
echo %HORIZON%
echo ^>^>%PREMIUM_START7%
echo ^>^>%PREMIUM_START8%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i  "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START5.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START5.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START5.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START5.wav"
      )
    )
  )
)
set /p CRFTYPEI=^>^>

if /i "%CRFTYPEI:~-1%"=="s" (
   for /f "tokens=1" %%A in ("%CRFTYPEI%") do set CRFTYPE=%%A
   set CRFTYPES=y
) else (
   set CRFTYPE=%CRFTYPEI%
   set CRFTYPES=n
)

:crfenc_main
if /i "%CRFTYPE%"=="a" set CRFTYPE=m
if /i "%CRFTYPE%"=="k" (
  set CRF=26
  goto premium
) else if /i "%CRFTYPE%"=="m" (
  set CRF=23
  goto premium
) else if /i "%CRFTYPE%"=="q" (
  set CRF=20
  goto premium
)

if /i "%QP_ENC%"=="y" (
  .\%X264EXE% --qp %CRFTYPE% 2>%TEMP_INFO%
) else (
  .\%X264EXE% --crf %CRFTYPE% 2>%TEMP_INFO%
)
for /f "tokens=3" %%i in (%TEMP_INFO%) do set X264_CRF_ERROR=%%i
if "%X264_CRF_ERROR%"=="No" (
    set CRF=%CRFTYPE%
    goto premium
) else (
  echo;
  echo ^>^>%RETURN_MESSAGE1%
  if not "%HARUMODE%"=="true" (
      if /i  "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
        )
      )
  )
  echo;
  set CRF=
  set CRFTYPE=
  goto crfenc_question
)
goto premium

rem YouTube ファイルサイズチェック
:youtube_filesize_check
if defined YTCONFIRM goto youtube_filesize_main

if "%ENC_MODE%"=="AVSENC" (
    goto account
) else if "%ENC_MODE%"=="CATENC" (
    goto account
) else if "%ENC_MODE%"=="MOVIEMUX" (
    goto account
) else if "%ENC_MODE%"=="IMAGEMUX" (
    goto account
)

if %INPUT_FILESIZE_MB1% GEQ 1024 goto account

:youtube_filesize_question
if /i "%DECODER%"=="avi" goto account
if /i "%DECODER%"=="qt" goto account
if /i "%DECODER%"=="ds_input" goto account
if "%FFPROBE%"=="true" goto account

date /t>nul
if /i "%INPUT_FILE_TYPE%"==".avi" goto account

echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i ".mp4 .flv .wmv .mpeg .mpg .mov .m4v .3g2 .3gp">nul
if ERRORLEVEL 1 goto account
if %INPUT_FILESIZE_MB1% LSS 1024 (
  echo ^>^>%YOUTUBE_SIZE1%
  echo ^>^>%YOUTUBE_SIZE2%
  if not "%HARUMODE%"=="true" (
    if /i not "%SKIP_MODE%"=="true" (
      if /i "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\YOUTUBE_SIZE1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\YOUTUBE_SIZE1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\YOUTUBE_SIZE1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\YOUTUBE_SIZE1.wav"
        )
      )
    )
  )
)
set /p YTCONFIRMI=^>^>
if /i "%YTCONFIRMI:~-1%"=="s" (
   for /f "tokens=1" %%A in ("%YTCONFIRMI%") do set YTCONFIRM=%%A
   set YTCONFIRMS=y
) else (
   set YTCONFIRM=%YTCONFIRMI%
)

:youtube_filesize_main
if /i "%YTCONFIRM%"=="a" goto account
if /i "%YTCONFIRM%"=="y" goto account
if /i "%YTCONFIRM%"=="n" call .\quit.bat

echo;
echo ^>^>%RETURN_MESSAGE1%
if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
)
echo;
set YTCONFIRMI=
goto youtube_filesize_question

rem アカウント分岐
:account
set /a TOTAL_TIME_SEC=%TOTAL_TIME:~0,-3% 2>nul
if defined TOTAL_TIME (
  if not defined TOTAL_TIME_SEC set /a TOTAL_TIME_SEC=1
)
if /i not "%PRETYPE%"=="y" (
    if defined ACTYPE goto account_main
)
if defined YTTYPE goto account_main

if /i "%PRETYPE%"=="y" (
  if %TOTAL_TIME_SEC% LEQ %TOTAL_TIME_LIM% (
    set YTTYPE=n
    goto account_main
  )
)
:account_question
echo;
if /i "%PRETYPE%"=="y" (
    echo ^>^>%PREMIUM_START3%
    echo ^>^>%PREMIUM_START4%
    if not "%HARUMODE%"=="true" (
      if /i not "%SKIP_MODE%"=="true" (
        if /i "%VOICE%"=="true" (
          if exist "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START3.mp3" (
            %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START3.mp3"
          ) else if exist "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START3.wav" (
            %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START3.wav"
          )
        )
      )
    )
    set /p YTTYPEI=^>^>
) else (
    echo ^>^>%PREMIUM_START1%
    echo ^>^>%PREMIUM_START2%
    if not "%HARUMODE%"=="true" (
      if /i not "%SKIP_MODE%"=="true" (
        if /i "%VOICE%"=="true" (
          if exist "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START1.mp3" (
            %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START1.mp3"
          ) else if exist "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START1.wav" (
            %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\PREMIUM_START1.wav"
          )
        )
      )
    )
    set YTTYPE=
    set /p ACTYPEI=^>^>
) 

if /i not "%PRETYPE%"=="y" (
  if /i "%ACTYPEI:~-1%"=="s" (
     for /f "tokens=1" %%A in ("%ACTYPEI%") do set ACTYPE=%%A
     set ACTYPES=y
  ) else (
     set ACTYPE=%ACTYPEI%
     set ACTYPES=n
  )
) else (
  if /i "%YTTYPEI:~-1%"=="s" (
     for /f "tokens=1" %%A in ("%YTTYPEI%") do set YTTYPE=%%A
     set YTTYPES=y
  ) else (
     set YTTYPE=%YTTYPEI%
     set YTTYPES=n
  )
)

:account_main
if /i "%PRETYPE%"=="y" set ACTYPE=%YTTYPE%
if /i "%YTTYPE%"=="n" (
    if %TOTAL_TIME_SEC% GEQ %TOTAL_TIME_LIM% (
        echo ^>^>%YOUTUBE_ERROR1%
        echo ^>^>%YOUTUBE_ERROR2%
        set YTTYPE=
        goto account_question
    )
)
if /i "%ACTYPE%"=="y" goto premium
if /i "%ACTYPE%"=="n" (
    if /i "%PRETYPE%"=="y" (
        goto premium
    ) else (
        if not defined CRF_TEST set CRF_TEST=n
        goto normal
    )
)
echo;
echo ^>^>%RETURN_MESSAGE1%
if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
)
echo;
set YTTYPE=
goto account_question

:premium
if "%ENC_MODE%"=="IMAGEMUX" (
  if /i "%INPUT_AUDIO_TYPE%"==".mp3" ( 
     if "%AUDIO_SIZE%" LEQ "%MP3_SIZE_PREMIUM%" (
       set MP3_SIZE=t
       if "%VP6VFW_CHECK%"=="t" (
           if "%A_RATE_MP3%"=="t" set MAKEFLV=y
       )
     )
  )
)
if "%BEGINNER%"=="true" (
	if "%VFR%"=="false" (
		if %KEYINT% LEQ 300 (
			if %P_TEMP_BITRATE% GTR %AUTO_ENC_LIMIT% (
				set PRETYPE=a
				if not defined CRF set CRF=23
				if not "%AUTOBITRATEOFF%"=="y" set TEMP_BITRATE=a
				if not defined CRF_TEST set CRF_TEST=y
			) else (
			    if not defined CRF_TEST set CRF_TEST=n
			)
		) else (
			if %P_TEMP_BITRATE% GTR %AUTO_ENC_LIMIT2% (
				set PRETYPE=a
				if not defined CRF set CRF=23
				if not "%AUTOBITRATEOFF%"=="y" set TEMP_BITRATE=a
				if not defined CRF_TEST set CRF_TEST=y
			) else (
			    if not defined CRF_TEST set CRF_TEST=n
			)
		)
	)
)
set /a MAX_FILESIZE=%P_MAX_FILESIZE%
call :economy
call :decode
call :interlace
call :premium_bitrate
call :resize
call :audio_bitrate
call :audio_sync
if not "%MAKEFLV%"=="y" call :audio_gain
if not "%CRFMODE%"=="y" call :crf_test_check
if "%DECODER%"=="" call :decoder_reselect
call :confirm
exit /b

:normal
if "%ENC_MODE%"=="IMAGEMUX" (
  if /i "%INPUT_AUDIO_TYPE%"==".mp3" ( 
     if "%AUDIO_SIZE%" LEQ "%MP3_SIZE_NORMALB%" (
       set MP3_SIZE=t
       if "%VP6VFW_CHECK%"=="t" (
           if "%A_RATE_MP3%"=="t" (
              set MAKEFLV=y
           )
       )
     )
  )
)
set /a MAX_FILESIZE=%I_MAX_FILESIZE%
call :normal_bitrate
call :economy
call :interlace
call :resize
call :resize_check
call :audio_bitrate
call :audio_sync
if not "%MAKEFLV%"=="y"  call :audio_gain
if "%DECODER%"=="" call :decoder_reselect
call :confirm
exit /b

rem エコ回避分岐
:economy
if /i "%PRETYPE%"=="s" (
  if %S_V_BITRATE% GEQ %E_TARGET_BITRATE% (
      set ENCTYPE=n
  )
)

if defined ENCTYPE goto economy_main
:economy_question
echo;
echo ^>^>%ECONOMY_START1%
echo ^>^>%ECONOMY_START2%
echo ^>^>%ECONOMY_START3%
echo ^>^>%ECONOMY_START4%
echo ^>^>%ECONOMY_START5%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\ECONOMY_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ECONOMY_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\ECONOMY_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\ECONOMY_START1.wav"
      )
    )
  )
)
set /p ENCTYPEI=^>^>

if /i "%ENCTYPEI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%ENCTYPEI%") do set ENCTYPE=%%A
  set ENCTYPES=y
) else (
  set ENCTYPE=%ENCTYPEI%
  set ENCTYPES=n
)

:economy_main
if /i "%ENCTYPE%"=="a" set ENCTYPE=n
if /i "%ENCTYPE%"=="y" (
    set SETTING1=low
    set AUTOBITRATEOFF=y
    goto low
)
if /i "%ENCTYPE%"=="n" (
    set SETTING1=high
    call :premium_bitrate
    exit /b
)
echo;
echo ^>^>%RETURN_MESSAGE1%
if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
)
echo;
goto economy_question

:low
set DECTYPE=n
if /i "%ACTYPE%"=="n"  goto normal_bitrate_setting

if %P_TEMP_BITRATE% LSS %E_TARGET_BITRATE% (
    set /a T_BITRATE=%P_TEMP_BITRATE%
) else (
    set /a T_BITRATE=%E_TARGET_BITRATE%
)

exit /b

rem 低再生負荷分岐
:decode
if defined DECTYPE goto decode_main
:decode_question
echo;
echo ^>^>%DECODE_START1%
echo ^>^>%DECODE_START2%
echo ^>^>%DECODE_START3%
echo ^>^>%DECODE_START4%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\DECODE_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DECODE_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\DECODE_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DECODE_START1.wav"
      )
    )
  )
)
set /p DECTYPEI=^>^>

if /i "%DECTYPEI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%DECTYPEI%") do set DECTYPE=%%A
  set DECTYPES=y
) else (
  set DECTYPE=%DECTYPEI%
  set DECTYPES=n
)

:decode_main
if /i "%DECTYPE%"=="a" set DECTYPE=n
if /i "%DECTYPE%"=="y" goto fast_dec
if /i "%DECTYPE%"=="n" goto high_dec
echo;
echo ^>^>%RETURN_MESSAGE1%
if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
)
echo;
goto decode_question
:fast_dec
if /i not "%ENCTYPE%"=="y" (
  set SETTING1=fast_decode
 exit /b
)
:high_dec
set SETTING1=high
if /i "%ENCTYPE%"=="y" set SETTING1=low
exit /b

:normal_bitrate_setting
if %I_TEMP_BITRATE% LSS %E_TARGET_BITRATE% (
    set /a T_BITRATE=%I_TEMP_BITRATE%
) else (
    set /a T_BITRATE=%E_TARGET_BITRATE%
)
exit /b

rem デインターレース
:interlace
if "%ENC_MODE%"=="IMAGEMUX"  set DEINT=n
if defined DEINT goto interlace_main
:interlace_question
echo;
echo ^>^>%DEINT_START1%
echo ^>^>%DEINT_START2%
echo ^>^>%DEINT_START3%
echo ^>^>%DEINT_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\DEINT_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DEINT_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\DEINT_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\DEINT_START1.wav"
      )
    )
  )
)
set /p DEINTI=^>^>

if /i "%DEINTI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%DEINTI%") do set DEINT=%%A
  set DEINTS=y
) else (
  set DEINT=%DEINTI%
  set DEINTS=n
)

:interlace_main
if /i "%DEINT%"=="a" (
    set DEINTI=n
    if "%SCAN_TYPE%"=="Interlaced" set DEINTI=y
    if "%SCAN_TYPE%"=="MBAFF" set DEINTI=y
    exit /b
)
if /i "%DEINT%"=="b" (
    set DEINTI=n
    if "%SCAN_TYPE%"=="Interlaced" (
      set DEINTI=y
      set BOB=true 
    )
    if "%SCAN_TYPE%"=="MBAFF" set DEINTI=y
    exit /b
)
if /i "%DEINT%"=="d" (
   set DEINTI=y
   exit /b
)
if /i "%DEINT%"=="y" (
   set DEINTI=y
   exit /b
)
if /i "%DEINT%"=="n" (
   set DEINTI=n
   exit /b
)
echo;
echo ^>^>%RETURN_MESSAGE1%
if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
)
goto interlace_question
exit /b

rem プレアカビットレート質問
:premium_bitrate
if /i "%PRETYPE%"=="y" (
    if /i "%ACTYPE%"=="y" (
        set /a T_BITRATE=%Y_P_TEMP_BITRATE%
        set /a TP_TEMP_BITRATE=%Y_P_TEMP_BITRATE%
    ) else (
        set /a T_BITRATE=%Y_I_TEMP_BITRATE%
        set /a TP_TEMP_BITRATE=%Y_I_TEMP_BITRATE%
    )
) else if /i "%PRETYPE%"=="a" (
        if "%T_BITRATE%"=="" set /a T_BITRATE=%P_TEMP_BITRATE%
        exit /b
) else if /i "%CRFMODE%"=="y" (
        set /a T_BITRATE=%Y_P_TEMP_BITRATE%
        exit /b
) else (
        set /a TP_TEMP_BITRATE=%P_TEMP_BITRATE%
)
if defined T_BITRATEI set T_BITRATE=%T_BITRATEI%
if defined T_BITRATE goto premium_bitrate_main

:premium_bitrate_question
echo;
echo ^>^>%BITRATE_START1%
echo ^>^>%BITRATE_START2% %TP_TEMP_BITRATE%kbps
echo ^>^>%BITRATE_START3%
if %P_TEMP_BITRATE% GEQ 2000 echo ^>^>%BITRATE_START4%
echo ^>^>%BITRATE_START7%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\BITRATE_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\BITRATE_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\BITRATE_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\BITRATE_START1.wav"
      )
    )
  )
)
set /p T_BITRATEI=^>^>

if /i not "%T_BITRATEI:~-1%"=="s" (
  set T_BITRATE=%T_BITRATEI%
  set T_BITRATES=n
  goto premium_bitrate_main
)
set T_BITRATES=y

:premium_bitrate_main
for /f "tokens=1" %%A in ("%T_BITRATEI%") do set T_BITRATE=%%A
for /f "tokens=2" %%A in ("%T_BITRATEI%") do if /i "%%A"=="mb" set T_BITRATE=%T_BITRATE%MB
set T_BITRATEI=%T_BITRATE%

if /i not "%T_BITRATE:~-2%"=="MB" goto premium_bitrate_main2
set AUTOECO=n
set DEFAULT_SIZE_PREMIUM_TEMP=%T_BITRATE:~0,-2%
(
    echo BlankClip^(length=1, width=32, height=32^)
    echo;
    echo _premium_bitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_TEMP% * %DEFAULT_SIZE_PERCENT% ^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo _premium_maxbitrate = String^(Floor^(Float^(%DEFAULT_SIZE_PREMIUM_TEMP% ^) / 100 * 1024 * 1024 * 8 / %TOTAL_TIME%^)^)
    echo WriteFileStart^("premium_bitrate.txt","_premium_bitrate",append = false^)
    echo WriteFileStart^("premium_maxbitrate.txt","_premium_maxbitrate",append = false^)
    echo;
    echo return last
)> %INFO_AVS3%

.\avs2pipemod.exe -info %INFO_AVS3% 1>nul 2>&1
for /f "delims=" %%i in (%TEMP_DIR%\premium_bitrate.txt) do set /a T_BITRATE=%%i>nul
for /f "delims=" %%i in (%TEMP_DIR%\premium_maxbitrate.txt) do set /a P_TEMP_BITRATE2=%%i>nul

echo ^>^> %BITRATE_START5% %DEFAULT_SIZE_PREMIUM_TEMP% %BITRATE_START6% %T_BITRATE% kbps
echo;

:premium_bitrate_main2
if "%T_BITRATE%"=="0" set T_BITRATE=%TP_TEMP_BITRATE%
if /i "%T_BITRATE%"=="a" (
  set T_BITRATEI=a
  set T_BITRATE=%TP_TEMP_BITRATE%
  if defined CRF_TEST exit /b
  set CRF_TEST=y
  if %TP_TEMP_BITRATE% LEQ 2000 (
     set CRF_TEST=n
  ) else (
     if %KEYINT% GTR 300 (
       if %TP_TEMP_BITRATE% LEQ 3000 (
          set CRF_TEST=n
       )
     )
  )
  If /i "%PRETYPE%"=="l" (
    if %TP_TEMP_BITRATE% GTR 1500 set T_BITRATE=1500
  ) else if /i "%PRETYPE%"=="o" (
    if %TP_TEMP_BITRATE% GTR 1500 set T_BITRATE=1500
  )
  exit /b
)

date /t>nul
echo %T_BITRATE%| "%WINDIR%\system32\findstr.exe" /i /R /C:"[^0-9]">nul
if not ERRORLEVEL 1 (
    set T_BITRATE=
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    if not "%HARUMODE%"=="true" (
      if /i "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav"
        )
      )
    )
    echo;
    set T_BITRATE=
    set T_BITRATEI=
    goto premium_bitrate_question
)

if defined DEFAULT_SIZE_PREMIUM_TEMP exit /b

if %TP_TEMP_BITRATE% LSS %T_BITRATE% (
    if "%BEGINNER%"=="true" (
        set T_BITRATE=%TP_TEMP_BITRATE%
    ) else (
        echo;
        echo ^>^>%RETURN_MESSAGE3%
        echo ^>^>%RETURN_MESSAGE4%
        echo;
        set T_BITRATE=
        set T_BITRATEI=
        if not "%HARUMODE%"=="true" (
          if /i "%VOICE%"=="true" (
            if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.mp3" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.mp3"
            ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.wav" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.wav"
            )
          )
        )
        goto premium_bitrate_question
    )
)

if not defined CRF_TEST (
  if %T_BITRATE% LEQ 2000 (
     set CRF_TEST=n
  ) else (
     if %KEYINT% GTR 300 (
       if %T_BITRATE% LEQ 3000 (
          set CRF_TEST=n
       )
     )
  )
)

exit /b

rem 一般アカビットレート質問
:normal_bitrate
if %I_TEMP_BITRATE% LSS %I_TARGET_BITRATE% (
    set /a T_BITRATE=%I_TEMP_BITRATE%
) else (
    set /a T_BITRATE=%I_TARGET_BITRATE%
)
if %I_TEMP_BITRATE% LSS %I_MAX_BITRATE% (
    set /a I_TMAX_BITRATE=%I_TEMP_BITRATE%
) else (
    set /a I_TMAX_BITRATE=%I_MAX_BITRATE%
)
exit /b

rem リサイズ分岐
:resize
if "%ENC_MODE%"=="AVSENC" set RESIZE=n

if defined RESIZE goto resize_main

:resize_question1
echo;
echo ^>^>%RESIZE_START1%
echo ^>^>%RESIZE_START2%
if /i "%ACTYPE%"=="n" goto resize_question2
if /i "%ENCTYPE%"=="y" goto resize_question2
echo %HORIZON%
echo %RESIZE_START3%
echo %RESIZE_START4%
echo %RESIZE_START5%
echo %HORIZON%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
:resize_question2
if /i "%ACTYPE%"=="n" (
  if "%FORCERESIZE%"=="y" (
     echo ^>^>%RESIZE_START6%
  )
)
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RESIZE_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RESIZE_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RESIZE_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RESIZE_START1.wav"
      )
    )
  )
)
set /p RESIZEI=^>^>

if /i "%RESIZEI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%RESIZEI%") do set RESIZE=%%A
  set RESIZES=y
) else (
  set RESIZE=%RESIZEI%
  set RESIZES=n
)

:resize_main
if not defined RESIZE goto resize_question_error

if /i "%RESIZE%"=="a" set RESIZE=y
if /i "%RESIZE%"=="n" (
  if /i "%ACTYPE%"=="n" (
   if "%FORCERESIZE%"=="y" (
      echo;
      echo ^>^>%RETURN_MESSAGE1%
      if not "%HARUMODE%"=="true" (
          if /i "%VOICE%"=="true" (
            if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
            ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
            )
          )
      )
      echo ^>^>%RESIZE_START5%
      echo;
      set RESIZE=
      goto resize_question1
   )
  )
)

if /i "%RESIZE%"=="y" goto autoconvert
if /i "%RESIZE%"=="n" goto noconvert

date /t>nul
echo %RESIZE% | "%WINDIR%\system32\findstr.exe" /i ": x">nul
if not ERRORLEVEL 1 goto convert

date /t>nul
echo %RESIZE%| "%WINDIR%\system32\findstr.exe" /i /R /C:"[^0-9]">nul
if not ERRORLEVEL 1 goto resize_question_error

set /a WIDTH=%RESIZE% 2>nul
set /a HEIGHT=%WIDTH% * %IN_HEIGHT% / %IN_WIDTH_MOD%
set /a WIDTH=%WIDTH% - %WIDTH% %% 2
set /a HEIGHT=%HEIGHT% - %HEIGHT% %% 2
set /a NEWRATIO=%HEIGHT% * 10000 / %WIDTH% 2>nul
if not defined NEWRATIO (
   echo;
   echo ^>^>%RETURN_MESSAGE1%
   if not "%HARUMODE%"=="true" (
       if /i "%VOICE%"=="true" (
         if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
           %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
         ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
           %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
         )
       )
   )
   echo ^>^>%RESIZE_START5%
   echo;
   set RESIZE=
   goto resize_question1
)
if %NEWRATIO% LEQ %CONST_WIDERATIO% set WIDTHW=y

set RESIZED=y
goto convert2

:resize_question_error
echo;
echo ^>^>%RETURN_MESSAGE1%
if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
    )
  )
)
echo;
goto resize_question2

:convert
echo %RESIZE%> %TEMP_INFO%
for /f "delims=:xX tokens=1" %%i in (%TEMP_INFO%) do set WIDTH=%%i
date /t>nul
echo %WIDTH%| "%WINDIR%\system32\findstr.exe" /i /R /C:"[^0-9]">nul
if not ERRORLEVEL 1 goto resize_question_error
set /a WIDTH=%WIDTH% - %WIDTH% %% 2
for /f "delims=:xX tokens=2" %%i in (%TEMP_INFO%) do set HEIGHT=%%i
date /t>nul
echo %HEIGHT%| "%WINDIR%\system32\findstr.exe" /i /R /C:"[^0-9]">nul
if not ERRORLEVEL 1 goto resize_question_error
set /a HEIGHT=%HEIGHT% - %HEIGHT% %% 2

set /a NEWRATIO=%HEIGHT% * 10000 / %WIDTH%
if not defined NEWRATIO (
   echo;
   echo ^>^>%RETURN_MESSAGE1%
   if not "%HARUMODE%"=="true" (
       if /i "%VOICE%"=="true" (
         if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
           %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
         ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
           %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
         )
       )
   )
   echo ^>^>%RESIZE_START5%
   echo;
   set RESIZE=
   goto resize_question1
)
if %NEWRATIO% LEQ %CONST_WIDERATIO%  set WIDTHW=y

set RESIZED=y
goto convert2

:autoconvert
set /a WIDTH=%OUT_WIDTH% - %OUT_WIDTH% %% 2
set /a HEIGHT=%OUT_HEIGHT% - %OUT_HEIGHT% %% 2
if %IN_HEIGHT% LSS %HEIGHT% (
    goto noconvert
)
if %IN_HEIGHT% GTR %HEIGHT% (
    set SETTING2=down_convert
    set RESIZER=Spline16Resize
    exit /b
)
goto convert2

:noconvert
set SETTING2=noresize
set RESIZED=n
set /a WIDTH=%IN_WIDTH_MOD% - %IN_WIDTH_MOD% %% 2
set /a HEIGHT=%IN_HEIGHT% - %IN_HEIGHT% %% 2

:convert2
if %IN_WIDTH_MOD% LSS %WIDTH% (
    if not defined SETTING2 set SETTING2=up_convert
    set RESIZER=BlackmanResize
    exit /b
) else if %IN_WIDTH_MOD% GTR %WIDTH% (
    if not defined SETTING2 set SETTING2=down_convert
    set RESIZER=Spline16Resize
    exit /b
) else if %IN_HEIGHT% LSS %HEIGHT% (
    if not defined SETTING2 set SETTING2=up_convert
    set RESIZER=BlackmanResize
    exit /b
) else if %IN_HEIGHT% GTR %HEIGHT% (
    if not defined SETTING2 set SETTING2=down_convert
    set RESIZER=Spline16Resize
    exit /b
) else if %IN_WIDTH% LSS %WIDTH% (
    set SETTING2=noresize
    set RESIZER=BlackmanResize
    exit /b
) else if %IN_WIDTH% GTR %WIDTH% (
    set SETTING2=noresize
    set RESIZER=Spline16Resize
    exit /b
)
set SETTING2=noresize
set RESIZED=n
exit /b

:resize_check
if %WIDTH% LEQ %I_MAX_WIDTH% (
    if %HEIGHT% LEQ %I_MAX_HEIGHT% (
        exit /b
    )
)
echo;
if /i "%PRETYPE%"=="s" (
    echo ^>^>%RETURN_MESSAGE8%
    echo ^>^>%RETURN_MESSAGE9%
    echo;
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
    set PRETYPE=
    set ENCTYPE=
    set DECTYPE=
    set RESIZE=
    set PRESET_S_ENABLE=false
) else (
    echo ^>^>%RETURN_MESSAGE10%
    echo ^>^>%RETURN_MESSAGE11%
    echo;
    echo ^>^>%PAUSE_MESSAGE2%
    pause>nul
    set RESIZE=
)

set CUSTOM_SETTING_N=
goto preset
exit /b

rem 音声ビットレート決定
:audio_bitrate
if /i "%AAC_ENCODER%"=="qt" goto qt_check

if exist neroAacEnc.exe goto audio_pre_check

echo;
echo ^>^>%MUTE_ALERT1%
echo ^>^>%MUTE_ALERT2%

:qt_check
if exist "%ProgramFiles(x86)%" (
  if not exist "%ProgramFiles(x86)%\QuickTime" (
     echo ^>^>%MUTE_ALERT3% 
  )
) else (
  if not exist "%ProgramFiles%\QuickTime" (
     echo ^>^>%MUTE_ALERT3% 
  )
)

:audio_pre_check
if /i "%PRETYPE%"=="s" (
   if not "%PRESET_S_ENABLE%"=="pending" (
      set /a M_BITRATE=%T_BITRATE% - %S_V_BITRATE%
      set /a MS_BITRATE=%T_BITRATE% - %S_V_BITRATE%
   ) else (
      set /a M_BITRATE=512
      set /a MS_BITRATE=512
   )
) else if "%ENC_MODE%"=="%IMAGEMUX%" (
    set /a M_BITRATE=%T_BITRATE% - 10
) else (
    set /a M_BITRATE=%T_BITRATE% - 20
)
if /i "%PRETYPE%"=="s" (
  if %M_BITRATE% LSS 0 (
     if /i "%ENCTYPE%"=="y" (
        echo ^>^>%RETURN_MESSAGE12%
        echo ^>^>%RETURN_MESSAGE13%
        echo ^>^>%PAUSE_MESSAGE2%
     ) else (
        echo ^>^>%RETURN_MESSAGE8%
        echo ^>^>%PAUSE_MESSAGE2%
     )
     pause>nul
     set PRETYPE=
     set BEGINNER=
     set ACTYPE=
     set T_BITRATE=
     set ENCTYPE=
     set CUSTOM_SETTING_N=
     goto preset_question
  )
)
if %M_BITRATE% LSS %AUTO_A_BITRATE% (
   if /i "%TEMP_BITRATE%"=="a" set TEMP_BITRATE=%M_BITRATE%
)
rem if /i "%AUTOBITRATEOFF%"=="y" (
rem  if "%TEMP_BITRATE%"=="a" goto audio_bitrate_question
rem )
if "%SILENT%"=="true" set /a TEMP_BITRATE=0
if defined TEMP_BITRATE goto audio_bitrate_main

:audio_bitrate_question
echo;
echo ^>^>%AUDIO_START1%
echo ^>^>%AUDIO_START2%
echo ^>^>%AUDIO_START3%
rem echo ^>^>%AUDIO_START4%
if %M_BITRATE% LSS %AUTO_A_BITRATE% echo ^>^>%AUDIO_START5%
if %M_BITRATE% LSS 320 (
	echo ^>^>%AUDIO_START6% %M_BITRATE%kbps
) else if %AUTO_A_BITRATE% EQU 320 (
	echo ^>^>%AUDIO_START8% 320 kbps
	echo ^>^>%AUDIO_START9%
) else (
	echo ^>^>%AUDIO_START6% %M_BITRATE%kbps
)
if /i "%PRETYPE%"=="s" (
    if %ME_BITRATE% GTR 0 echo ^>^>%AUDIO_START7% %ME_BITRATE%kbps
)

echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\AUDIO_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\AUDIO_START1.wav"
      )
    )
  )
)
set /p TEMP_BITRATEI=^>^>

if /i "%TEMP_BITRATEI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%TEMP_BITRATEI%") do set TEMP_BITRATE=%%A
  set TEMP_BITRATES=y
) else (
  set TEMP_BITRATE=%TEMP_BITRATEI%
  set TEMP_BITRATES=n
)

:audio_bitrate_main
set TEMP_BITRATEI=%TEMP_BITRATE%
if "%INPUT_A_BITRATE%"=="" (
	if "%SILENT%"=="true" (
		set INPUT_A_BITRATE=0
	) else (
		set INPUT_A_BITRATE=1441
	)
)

if /i "%AUDIO_CODEC%"=="40" (
	if "%ENC_MODE%"=="AVSENC" (
		set SKIP_A_ENC=false
	) else if "%ENC_MODE%"=="CATENC" (
		set SKIP_A_ENC=false
	) else if /i "%TEMP_BITRATE%"=="a" (
		if %M_BITRATE% GEQ %INPUT_A_BITRATE% (
			set SKIP_A_ENC=true
		) else (
			set SKIP_A_ENC=false
		)
	) else if "%TEMP_BITRATE%"=="%INPUT_A_BITRATE%" (
		set SKIP_A_ENC=true
	) else (
		set SKIP_A_ENC=false
	)
) else (
	set SKIP_A_ENC=false
)
if /i "%TEMP_BITRATE%"=="a" (
    if not defined INPUT_A_BITRATE (
      set A_BITRATE=0
      goto A_BIT_SET_fin
    ) else if "%INPUT_A_BITRATE%"=="0" (
      set /a A_BITRATE=0
      goto A_BIT_SET_fin
    ) else (
     if /i "%ACTYPE%"=="y" (
       if %M_BITRATE% LSS %INPUT_A_BITRATE% (
         if %M_BITRATE% GTR %AUTO_A_BITRATE% (
            set A_BITRATE=%AUTO_A_BITRATE%
         ) else (
            set A_BITRATE=%M_BITRATE%
         )
       ) else (
         if %INPUT_A_BITRATE% GTR %AUTO_A_BITRATE% (
            set A_BITRATE=%AUTO_A_BITRATE%
         ) else (
            set A_BITRATE=%INPUT_A_BITRATE%
         )
       )
     ) else (
       if %M_BITRATE% LSS %INPUT_A_BITRATE% (
         if %M_BITRATE% GTR %AUTO_IA_BITRATE% (
            set A_BITRATE=%AUTO_IA_BITRATE%
         ) else (
            set A_BITRATE=%M_BITRATE%
         )
       ) else (
         if %INPUT_A_BITRATE% GTR %AUTO_IA_BITRATE% (
            set A_BITRATE=%AUTO_IA_BITRATE%
         ) else (
            set A_BITRATE=%INPUT_A_BITRATE%
         )
       )
     )
   )
   goto A_BIT_SET_fin
)

if /i "%TEMP_BITRATE%"=="t" (
  if /i "%ACTYPE%"=="n" (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    if not "%HARUMODE%"=="true" (
      if /i "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav"
        )
      )
    )
    echo;
    goto audio_bitrate_question  
  )
  if %T_BITRATE% LEQ 512 (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    if not "%HARUMODE%"=="true" (
      if /i "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav"
        )
      )
    )
    echo;
    goto audio_bitrate_question  
  )
  set TEMP_BITRATE=512
  set TVBR=true
)

date /t>nul
echo %TEMP_BITRATE%| "%WINDIR%\system32\findstr.exe" /i /R /C:"[^0-9]">nul
if ERRORLEVEL 1 (
    set /a A_BITRATE=%TEMP_BITRATE%
) else (
    echo;
    echo ^>^>%RETURN_MESSAGE2%
    if not "%HARUMODE%"=="true" (
      if /i "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE2.wav"
        )
      )
    )
    echo;
    goto audio_bitrate_question
)

if /i "%PRETYPE%"=="s" (
    if %A_BITRATE% GTR %MS_BITRATE% (
        echo;
        echo ^>^>%RETURN_MESSAGE3%
        echo ^>^>%RETURN_MESSAGE4%
        echo;
        if not "%HARUMODE%"=="true" (
          if /i "%VOICE%"=="true" (
            if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.mp3" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.mp3"
            ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.wav" (
              %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE3.wav"
            )
          )
        )
        goto audio_bitrate_question
    )
)

:A_BIT_SET_fin
if "%SILENT%"=="true" (
  set A_SYNC=n
  set A_GAIN=0
  set WAV_FAIL=n
)

if /i "%PRETYPE%"=="s" (
  set /a V_BITRATE=%S_V_BITRATE%
  set /a T_BITRATE=%S_V_BITRATE% + %A_BITRATE%
) else if /i "%PRETYPE%"=="a" (
  set /a V_BITRATE=%T_BITRATE% - %A_BITRATE%
) else if /i "%PRETYPE%"=="y" (
  set /a V_BITRATE=%T_BITRATE% - %A_BITRATE%
) else if /i "%CRFMODE%"=="y" (
  set /a V_BITRATE=%Y_P_TEMP_BITRATE%
  exit /b
) else (
  set /a V_BITRATE=%T_BITRATE% - %A_BITRATE%
)

if %V_BITRATE% LEQ 0 (
    echo;
    echo ^>^>%RETURN_MESSAGE5%
    echo ^>^>%RETURN_MESSAGE%
    echo;
    if not "%HARUMODE%"=="true" (
      if /i "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE5.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE5.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE5.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE5.wav"
        )
      )
    )
     goto audio_bitrate_question
)
exit /b

:audio_sync
if "%TEMP_BITRATE%"=="0" (
  set A_SYNC=n
  set A_GAIN=0
)
if defined A_SYNC goto audio_sync_main
:audio_sync_question
echo;
echo ^>^>%SYNC_START1%
echo ^>^>%SYNC_START2%
echo ^>^>%SYNC_START3%
echo ^>^>%SYNC_START7%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\SYNC_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SYNC_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\SYNC_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\SYNC_START1.wav"
      )
    )
  )
)
set /p A_SYNCI=^>^>

if /i "%A_SYNCI:~-1%"=="s" (
   for /f "tokens=1" %%A in ("%A_SYNCI%") do set A_SYNC=%%A
   set A_SYNCS=y
) else (
   set A_SYNC=%A_SYNCI%
   set A_SYNCS=n
)

:audio_sync_main
set A_SYNCI=%A_SYNC%
if /i "%A_SYNC%"=="a" (
  if not "%ENC_MODE%"=="MOVIEMUX" (
    if /i "%INPUT_FILE_TYPE%"==".mp4" set A_SYNC=n
  )
)
if /i "%A_SYNC%"=="a" set A_SYNC=y

if not exist neroAacEnc.exe (
  if /i "%A_SYNC%"=="y" ( 
     echo;
     echo ^>^>%RETURN_MESSAGE7%
     echo;
     if not "%HARUMODE%"=="true" (
       if /i "%VOICE%"=="true" (
         if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.mp3" (
           %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.mp3"
         ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.wav" (
           %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.wav"
         )
       )
     )
     goto audio_sync_question
     exit /b
  )
)

if /i not "%A_SYNC%"=="y" set KEEPWAV=n

if /i "%A_SYNC%"=="y" exit /b
if /i "%A_SYNC%"=="n" exit /b

date /t>nul
echo %A_SYNC%| "%WINDIR%\system32\findstr.exe" /i /R /C:"[^0-9+-]">nul
if ERRORLEVEL 1 exit /b
echo;
echo ^>^>%RETURN_MESSAGE7%
echo;
if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.wav"
    )
  )
)
goto audio_sync_question
exit /b

:audio_gain
if defined A_GAIN goto audio_gain_main
:audio_gain_question
echo;
echo ^>^>%GAIN_START1%
echo ^>^>%GAIN_START2%
echo ^>^>%GAIN_START3%
echo ^>^>%GAIN_START4%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\GAIN_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\GAIN_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\GAIN_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\GAIN_START1.wav"
      )
    )
  )
)
set /p A_GAINI=^>^>

if /i "%A_GAINI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%A_GAINI%") do set A_GAIN=%%A
  set A_GAINS=y
) else (
  set A_GAIN=%A_GAINI%
  set A_GAINS=n
)

:audio_gain_main
if /i "%A_GAIN%"=="a" set A_GAIN=0
if /i "%A_GAIN%"=="n" set A_GAIN=0

date /t>nul
echo %A_GAIN%| "%WINDIR%\system32\findstr.exe" /i /R /C:"[^0-9+-]">nul
if ERRORLEVEL 1 exit /b
echo;
echo ^>^>%RETURN_MESSAGE7%
if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE7.wav"
    )
  )
)
echo;
goto audio_gain_question
exit /b

rem 品質基準エンコ
:crf_test_check
if defined CRF_TEST goto crf_test_main
if /i "%PRETYPE%"=="l" (
  set CRF_TEST=n
  exit /b
)
if /i "%PRETYPE%"=="o" (
  set CRF_TEST=n
  exit /b
)

if %KEYINT% GTR 600 (
   set CRF_TEST=n
   exit /b
)

if %HEIGHT% GTR 480 (
  if %KEYINT% GTR 300 (
     if %V_BITRATE% LSS 5000 (
        set CRF_TEST=n
        exit /b
      )
  ) else (
     if %V_BITRATE% LSS 3000 (
        set CRF_TEST=n
        exit /b
     )
  )
)

if %KEYINT% GTR 300 (
  if %V_BITRATE% LEQ 3000 (
     set CRF_TEST=n
     exit /b
  )
) else (
  if %V_BITRATE% LEQ 2000 (
     set CRF_TEST=n
     exit /b
  )
)

:crf_test_question
echo;
echo ^>^>%BR_MODE_START1%
echo ^>^>%BR_MODE_START2%
echo ^>^>%BR_MODE_START3%
echo ^>^>%BR_MODE_START4%
echo ^>^>%BR_MODE_START5%
echo ^>^>%QUESTION_START4%
echo ^>^>%QUESTION_START3%
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\BR_MODE_START1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\BR_MODE_START1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\BR_MODE_START1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\BR_MODE_START1.wav"
      )
    )
  )
)
set /p CRF_TESTI=^>^>

if /i "%CRF_TESTI:~-1%"=="s" (
  for /f "tokens=1" %%A in ("%CRF_TESTI%") do set CRF_TEST=%%A
  set CRF_TESTS=y
) else (
  set CRF_TEST=%CRF_TESTI%
  set CRF_TESTS=n
)
set CRF_TESTI=%CRF_TEST%

:crf_test_main
if not defined CRF_TEST (
  echo;
  echo ^>^>%RETURN_MESSAGE1%
  if not "%HARUMODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
      )
    )
  )
  set CRF_TESTI=
  goto crf_test_question
)

if /i "%CRF_TEST%"=="a" set CRF_TEST=y

if /i "%CRF_TEST%"=="n" exit /b

if /i "%CRF_TEST%"=="y" (
  if defined CRF (
    set CRF_TEST_CRF=%CRF%
  ) else if %V_BITRATE% GEQ 5000 (
     if /i "%T_BITRATEI%"=="a" (
       set CRF_TEST_CRF=23
     ) else (
       set CRF_TEST_CRF=20
     )
  ) else (
     set CRF_TEST_CRF=23
  )
  exit /b
)
.\%X264EXE% --crf %CRF_TEST% 2>%TEMP_INFO%
for /f "tokens=3" %%i in (%TEMP_INFO%) do set X264_CRF_ERROR=%%i
if "%X264_CRF_ERROR%"=="No" (
    set CRF_TEST_CRF=%CRF_TEST%
    set CRF_TEST=y
    exit /b
) else (
    set CRF_TEST=
    set CRF_TESTI=
    echo;
    echo ^>^>%RETURN_MESSAGE1%
    if not "%HARUMODE%"=="true" (
      if /i "%VOICE%"=="true" (
        if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
        ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
          %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
        )
      )
    )
    goto crf_test_question
)
exit /b

:decoder_reselect
if not "%DECODER%"=="" exit /b

echo;
echo ^>^>%DECODER_START1%
echo ^>^>%DECODER_START2%
echo;
echo ^>^>%DECODER_START3%
if not "%AVI_INFO%"=="f" echo ^>^>1: avisource
if not "%DIRECTSHOW_INFO%"=="f" echo ^>^>2: directshow
if not "%FFMS_INFO%"=="f" echo ^>^>3: ffmpegsource
if not "%LSMASH_INFO%"=="f" echo ^>^>4: L-SMASH
if not "%LWLIBAV_INFO%"=="f" echo ^>^>5: LWLibav
if not "%QT_INFO%"=="f" echo ^>^>6: quicktime
if not "%FFMS_INFO%"=="f" echo ^>^>7: ffmpeg pipe

rem 設定最終確認
:confirm
if "%SKIP_A_ENC%"=="true" (
	if /i not "%A_SYNCI%"=="a" (
		if /i not "%A_SYNCI%"=="n" (
			set SKIP_A_ENC=false
		)
	)
)
if "%SKIP_A_ENC%"=="true" (
	if /i not "%A_GAIN%"=="0" (
		set SKIP_A_ENC=false
	)
)
if "%SKIP_A_ENC%"=="true" (
	set TEMP_M4A_BITRATE=%INPUT_A_BITRATE%
	set A_BITRATE=%INPUT_A_BITRATE%
)

if /i "%CONFIRM%"=="y" exit /b
echo;
echo %HORIZON%
if "%FINAL_FILE%"=="%FILENAME_ERROR_MP4%" (
  echo %CONFIRM_FILENAME%:"%FINAL_FILE%.mp4"
  echo              %FILENAME_ERROR1%
) else (
  echo %CONFIRM_FILENAME%:"%FINAL_FILE%.mp4"
)
if %BEGINNER%"=="true" (
  echo %CONFIRM_PRETYPE%:%PRESET_LIST0%
  if P_TEMPLEQ 900 (
  
  ) else set PRETYPE=m
  goto enc_type_confirm
)
if /i "%PRETYPE%"=="l" echo %CONFIRM_PRETYPE%:%PRESET_LIST1%
if /i "%PRETYPE%"=="m" echo %CONFIRM_PRETYPE%:%PRESET_LIST2%
if /i "%PRETYPE%"=="n" echo %CONFIRM_PRETYPE%:%PRESET_LIST3%
if /i "%PRETYPE%"=="o" echo %CONFIRM_PRETYPE%:%PRESET_LIST4%
if /i "%PRETYPE%"=="p" echo %CONFIRM_PRETYPE%:%PRESET_LIST5%
if /i "%PRETYPE%"=="q" echo %CONFIRM_PRETYPE%:%PRESET_LIST6%
if /i "%PRETYPE%"=="s" echo %CONFIRM_PRETYPE%:%PRESET_LIST7%
if /i "%PRETYPE%"=="x" echo %CONFIRM_PRETYPE%:%PRESET_LIST8%
if /i "%PRETYPE%"=="t" (
    echo %CONFIRM_PRETYPE%:%PRESET_LIST10%
    if /i "%CRFTYPE%"=="k" (
        echo %CONFIRM_CRFTYPE%:%CRF_LIST1%
    ) else if /i "%CRFTYPE%"=="m" (
        echo %CONFIRM_CRFTYPE%:%CRF_LIST2%
    ) else if /i "%CRFTYPE%"=="q" (
        echo %CONFIRM_CRFTYPE%:%CRF_LIST3%
    ) else (
        echo %CONFIRM_CRFTYPE%:CRF=%CRF%
    )
)
if /i "%PRETYPE%"=="y" (
    echo %CONFIRM_PRETYPE%:%PRESET_LIST9%
    if /i "%ACTYPE%"=="y" (
        echo %CONFIRM_ACCOUNT1%:%CONFIRM_ACCOUNT4%
    ) else (
        echo %CONFIRM_ACCOUNT1%:%CONFIRM_ACCOUNT5%
    )
) else if not "%CRFMODE%"=="y" (
   if /i "%ACTYPE%"=="y" (
      echo %CONFIRM_ACCOUNT1%:%CONFIRM_ACCOUNT2%
   ) else (
      echo %CONFIRM_ACCOUNT1%:%CONFIRM_ACCOUNT3%
   )
)
:enc_type_confirm
if /i not "%PRETYPE%"=="s" (
  if /i not "%PRETYPE%"=="y" (
      if /i "%ENCTYPE%"=="y" (
          echo %CONFIRM_ENCTYPE%:%CONFIRM_ON%
      ) else (
          echo %CONFIRM_ENCTYPE%:%CONFIRM_OFF%
      )
      if /i "%DECTYPE%"=="y" (
          echo %CONFIRM_DECTYPE%:%CONFIRM_ON%
      ) else (
          echo %CONFIRM_DECTYPE%:%CONFIRM_OFF%
      )
  )
  if /i "%DEINT%"=="a" (
      if /i "%DEINTI%"=="y" (
        echo %CONFIRM_DEINT1%:%CONFIRM_DEINT2% %CONFIRM_DEINT3%
      ) else (
        echo %CONFIRM_DEINT1%:%CONFIRM_DEINT2% %CONFIRM_DEINT4%
      )
  ) else if /i "%DEINT%"=="b" (
      if /i "%DEINTI%"=="y" (
        echo %CONFIRM_DEINT1%:%CONFIRM_DEINT2% %CONFIRM_DEINT3% ^(%FPS2% fps^)
      ) else (
        echo %CONFIRM_DEINT1%:%CONFIRM_DEINT2% %CONFIRM_DEINT4%
      )
  ) else if /i "%DEINT%"=="y" (
        echo %CONFIRM_DEINT1%:%CONFIRM_DEINT3%
  ) else if /i "%DEINT%"=="d" (
        echo %CONFIRM_DEINT1%:%CONFIRM_DEINT3% ^(%FPS2% fps^)
  ) else (
      echo %CONFIRM_DEINT1%:%CONFIRM_DEINT4%
  )
  if "%SETTING2%"=="up_convert" (
      echo %CONFIRM_RESIZE1%:%CONFIRM_RESIZE2%^(%WIDTH%x%HEIGHT%^)
  ) else if "%SETTING2%"=="down_convert" (
      echo %CONFIRM_RESIZE1%:%CONFIRM_RESIZE3%^(%WIDTH%x%HEIGHT%^)
  ) else (
      echo %CONFIRM_RESIZE1%:%CONFIRM_OFF%^(%WIDTH%x%HEIGHT%^)
  )
)
if /i "%A_SYNC%"=="y" (
      echo %CONFIRM_SYNC1%:%CONFIRM_SYNC2%
) else if /i "%A_SYNC%"=="n" (
    echo %CONFIRM_SYNC1%:%CONFIRM_OFF%
) else (
    echo %CONFIRM_SYNC1%:%CONFIRM_SYNC3%^(%A_SYNC%ms^)
)
if not "%MAKEFLV%"=="y" (
  if "%A_GAIN%"=="0" (
      echo %CONFIRM_GAIN1%:%CONFIRM_GAIN2%
  ) else (
      echo %CONFIRM_GAIN1%:%A_GAIN%dB
  )
)
if /i "%CRF_TEST%"=="y" (
    echo %CONFIRM_VIDEO%:%CONFIRM_CRF% ^(CRF=%CRF_TEST_CRF%^)
) else (
  if /i "%CRFMODE%"=="y" (
    echo %CONFIRM_VIDEO%:%CONFIRM_CRF% ^(CRF=%CRF%^)
  ) else if /i "%PRETYPE%"=="s" (
    echo %CONFIRM_VIDEO%:%CONFIRM_PRESET_S%
  ) else (
    echo %CONFIRM_VIDEO%:%CONFIRM_BR%
  )
)
if %A_BITRATE% LEQ %Y_A_BITRATE2% set Y_A_BITRATE2=%A_BITRATE%
if %A_BITRATE% LEQ %Y_A_BITRATE1% set Y_A_BITRATE1=%A_BITRATE%

if /i "%PRETYPE%"=="y" (
    echo %YTUPLOAD_BITRATE%
  if %IN_HEIGHT% LEQ 360 (
    echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=1000kbps %CONFIRM_BITRATE3%=%Y_A_BITRATE1%kbps %CONFIRM_BITRATE4%=1128kbps
  ) else if %IN_HEIGHT% LEQ 480 (
    echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=2500kbps %CONFIRM_BITRATE3%=%Y_A_BITRATE1%kbps %CONFIRM_BITRATE4%=2628kbps
  ) else if %IN_HEIGHT% LEQ 720 (
    echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=5000kbps %CONFIRM_BITRATE3%=%Y_A_BITRATE2%kbps %CONFIRM_BITRATE4%=5384kbps
  ) else (
    echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=8000kbps %CONFIRM_BITRATE3%=%Y_A_BITRATE2%kbps %CONFIRM_BITRATE4%=8384kbps
  )
) else if /i not "%CRFMODE%"=="y" ( 
  if /i "%CRF_TEST%"=="y" (
     echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=%V_BITRATE%? kbps %CONFIRM_BITRATE3%=%A_BITRATE% kbps %CONFIRM_BITRATE4%=%T_BITRATE%? kbps
  ) else (
     echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=%V_BITRATE% kbps %CONFIRM_BITRATE3%=%A_BITRATE% kbps %CONFIRM_BITRATE4%=%T_BITRATE% kbps
  )
) else (
  echo %CONFIRM_BITRATE1%:%CONFIRM_BITRATE2%=%UNKNOWN%  %CONFIRM_BITRATE3%=%A_BITRATE%kbps %CONFIRM_BITRATE4%= %UNKNOWN%
)

date /t>nul
echo %INPUT_FILE_TYPE% | "%WINDIR%\system32\findstr.exe" /i "m2ts mts m2t ts">nul
if not ERRORLEVEL 1 (
   echo %HORIZON%
   echo %INPUT_FILE_TYPE% %M2TS_ALERT1%
   if /i "%MAKE_MKV%"=="y" (
      echo %M2TS_ALERT2%
      echo %M2TS_ALERT3%
   )
   goto confirm_question
)

if "%V_CODEC%"=="Microsoft Video 1" (
    echo %HORIZON%
    echo %MV1_ALERT1%
    echo %MV1_ALERT2%
    goto confirm_question
)

if "%MAKEFLV%"=="n" (
  echo %HORIZON%
    if not"%SETTING2%"=="noresize" (
      if "%IMAGE_SIZE_ERROR%"=="t" (
        echo %SIZE_ALERT%
      )
    )
  goto confirm_question
)

if "%MAKEFLV%"=="y" (
   echo %CONFIRM_OUTTYPE%:FLV
   echo %HORIZON%
   echo %MAKE_FLV_ANNOUNCE%
   if "%IMAGE_SIZE_ERROR%"=="t" (
      echo %SIZE_ALERT%
   )
   goto confirm_question
) else (
   echo %CONFIRM_OUTTYPE%:MP4
   echo %HORIZON%
)

rem FLV or MP4
if not "%VP6VFW_CHECK%"=="t" (
   echo %VP6VFW_ERROR%
) 

if not "%A_RATE_MP3%"=="t" (
   echo %ARATE_ERROR1%
   echo (%ARATE_ERROR2%:%SAMPLERATE% Hz)
)

if not "%MP3_SIZE%"=="t" (
   echo %MP3_SIZE_ERROR%
)

echo %NOT_FLV_ANNOUNCE%

if not"%SETTING2%"=="noresize" (
  if "%IMAGE_SIZE_ERROR%"=="t" (
     echo %SIZE_ALERT%
  )
)

:confirm_question
if "%PRESET_S_ENABLE%"=="false" goto confirm_question2
if not defined REFVALUE goto confirm_question2
if not defined BFRAMEVALUE goto confirm_question2
if not defined KEYINTVALUE goto confirm_question2
if "%HARUMODE%"=="true" goto confirm_question2
if /i "%PRETYPE%"=="s" (
  if %REFVALUE% GEQ 9 (
    if %BFRAMEVALUE% GEQ 5 (
      echo %PRETYPES1%
      echo;
    )
  ) else if %V_BITRATE% GEQ 2000 (
    echo %PRETYPES2%
    echo;
  )
) else if "%SETTING2%"=="noresize" (
   if %T_BITRATE% GEQ %CURRENT_BITRATE% (
      if %S_V_BITRATE% LEQ 2000 (
         if /i "%DECTYPE%"=="n" (
            if %REFVALUE% LEQ 8 (
              if %BFRAMEVALUE% LEQ 4 (
                if %KEYINTVALUE% LEQ %KEYINT_HIGH_LIMIT% (
                  set PRETYPES_TEST=y
                  echo %PRETYPES3%
                  echo;
                )
              )
            )
         )
      )
   )
)

:confirm_question2
if /i "%SKIP_MODE%"=="true" (
   if "%HARUMODE%"=="false" (
     if "%BEGINNER%"=="false" exit /b
   )
   if "%VFR%"=="true" exit /b
   if %V_BITRATE% LSS 400 (
    if %KEYINT% GTR 300 (
      set FPS=30
      set KEYINT=300
      set CHANGE_FPS=true
      set CONVERT_FPS=-r 30
    )
   )
   goto error_report_write
)
echo;
echo ^>^>%CONFIRM_LAST1%

if "%ENC_MODE%"=="SEQUENCE" (
  echo ^>^>%CONFIRM_LAST3%
)
if not "%HARUMODE%"=="true" (
  if /i not "%SKIP_MODE%"=="true" (
    if /i "%VOICE%"=="true" (
      if exist "..\Extra\Voice\%VOICE_DIR%\CONFIRM_LAST1.mp3" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\CONFIRM_LAST1.mp3"
      ) else if exist "..\Extra\Voice\%VOICE_DIR%\CONFIRM_LAST1.wav" (
        %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\CONFIRM_LAST1.wav"
      )
    )
  )
)
set /p CONFIRM=^>^>

if /i "%CONFIRM%"=="a" (
  if "%ENC_MODE%"=="SEQUENCE" (
     set RELOAD_SETTINGS=false
     set SKIP_MODE=true
     set CONFIRM=y
  ) else if "%PAIR_MODE%"=="true" (
     set RELOAD_SETTINGS=false
     set SKIP_MODE=true
     set CONFIRM=y
  ) else (
     set CONFIRM=y
  )
) else if "%ENC_MODE%"=="SEQUENCE" (
     set RELOAD_SETTINGS=true
) else if "%PAIR_MODE%"=="true" (
     set RELOAD_SETTINGS=true
)

if /i "%CONFIRM%"=="n" (
    echo;
    echo ^>^>%CONFIRM_LAST2%
    set RELOAD_SETTINGS=
    set PRETYPEI=
    set PRETYPE=
    set PRETYPES=
    set CUSTOM_SETTING_N=
    set YTCONFIRMI=
    set YTCONFIRM=
    set YTCONFIRMS=
    set CRFTYPEI=
    set CRFTYPE=
    set CRFTYPES=
    set CRFMODE=
    set CRF=
    set BEGINNER=
    set YTTYPEI=
    set YTTYPE=
    set YTTYPES=
    set ACTYPEI=
    set ACTYPE=
    set ACTYPES=
    set T_BITRATEI=
    set T_BITRATE=
    set T_BITRATES=
    set P_TEMP_BITRATE2=
    set DEFAULT_SIZE_PREMIUM_TEMP=
    set CRF_TESTI=
    set CRF_TEST=
    set CRF_TESTS=
    set ENCTYPEI=
    set ENCTYPE=
    set ENCTYPES=
    set DECTYPEI=
    set DECTYPE=
    set DECTYPES=
    set DEINTI=
    set DEINT=
    set DEINTS=
    set RESIZEI=
    set RESIZE=
    set RESIZED=
    set RESIZES=
    set WIDTHW=
    set TEMP_BITRATEI=
    set TEMP_BITRATE=
    set TEMP_BITRATES=
    set A_SYNCI=
    set A_SYNC=
    set A_SYNCS=
    set A_GAINI=
    set A_GAIN=
    set A_GAINS=
    set SKIP_MODE=
    set AUTOBITRATEOFF=
    set AUTOECO=%AUTOECOI%
    set COLORMATRIX=%COLORMATRIX_ORIGNAL%
rem    set DECODER=
    set SKIP_A_ENC=false
    echo;
    goto mode_select
)

if /i "%CONFIRM%"=="y" goto confirm_y

if /i not "%CONFIRM%"=="p" (
   echo ^>^>%RETURN_MESSAGE1%
   if not "%HARUMODE%"=="true" (
     if /i "%VOICE%"=="true" (
       if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
         %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
       ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
         %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
       )
     )
   )
   echo;
   goto confirm_question
)
rem シャットダウンオプション
:shutset
echo;
echo ^>^>%PWCONF_START2%
echo %HORIZON%
echo   o:%PWCONF_LIST1%
echo   r:%PWCONF_LIST2%
echo   l:%PWCONF_LIST3%
echo   s:%PWCONF_LIST4%
echo   h:%PWCONF_LIST5%
echo   n:%PWCONF_LIST6%
echo %HORIZON%
set /p SHUTYPE=^>^>

:pweset_main
echo %SHUTYPE% | "%WINDIR%\system32\findstr.exe" /i "o r l s h">nul
if not ERRORLEVEL 1 (
  if /i "%SHUTYPE%"=="o" echo %SHUT_CONFIRM%%PWCONF_LIST1%
  if /i "%SHUTYPE%"=="r" echo %SHUT_CONFIRM%%PWCONF_LIST2%
  if /i "%SHUTYPE%"=="l" echo %SHUT_CONFIRM%%PWCONF_LIST3%
  if /i "%SHUTYPE%"=="s" echo %SHUT_CONFIRM%%PWCONF_LIST4%
  if /i "%SHUTYPE%"=="h" echo %SHUT_CONFIRM%%PWCONF_LIST5%
  set SHUTDOWN=y
  goto confirm_question
)
echo;
echo ^>^>%PWCONF_LIST6%
echo;
set SHUTYPE=
set SHUTDOWN=n
goto confirm_question

:confirm_y
if not "%VFR%"=="true" (
	if "%BEGINNER%"=="false" (
	  if %V_BITRATE% LSS 400 (
	    if %KEYINT% GTR 300 (
	      set FPS=30
	      set KEYINT=300
	      set CHANGE_FPS=true
	      set CONVERT_FPS=-r 30
	    )
	  )
	)
)

if defined DEFAULT_SIZE_PREMIUM_TEMP set DEFAULT_SIZE_PREMIUM=%DEFAULT_SIZE_PREMIUM_TEMP%
if defined P_TEMP_BITRATE2 set P_TEMP_BITRATE=%P_TEMP_BITRATE2%

if /i not "%CONFIRM%"=="y" goto return_to_confirm

:error_report_write
(
if "%BEGINNER%"=="true" echo HARUTYPE     : %HARUTYPE%
echo PRETYPE      : %PRETYPE%
if /i "%PRETYPE%"=="t" echo CRFTYPE      : %CRFTYPE%
if /i "%PRETYPE%"=="y" echo YTTYPE       : %YTTYPE%
echo ACTYPE       : %ACTYPE%
echo ENCTYPE      : %ENCTYPE%
echo T_BITRATE    : %T_BITRATE%
echo DECTYPE      : %DECTYPE%
echo DEINT        : %DEINT%
echo RESIZE       : %RESIZED% ^(%WIDTH%x%HEIGHT%^)
echo AUDIO_BITRATE: %TEMP_BITRATE%
echo A_SYNC       : %A_SYNC%
echo A_GAINS      : %A_GAIN%dB
)>> %ERROR_REPORT%

cd %TEMP_DIR%
   if "%PRETYPES%"=="y" (
     ..\..\sed.exe -i -e "s/^set PRETYPE=[0-9a-zA-Z]\{,9\}/set PRETYPE=%PRETYPEI%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%CRFTYPES%"=="y" (
     ..\..\sed.exe -i -e "s/^set CRFTYPE=[0-9a-zA-Z\.]\{,9\}/set CRFTYPE=%CRFTYPE%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%YTCONFIRMS%"=="y" (
     ..\..\sed.exe -i -e "s/^set YTCONFIRM=[0-9a-zA-Z]\{,9\}/set YTCONFIRM=%YTCONFIRM%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%YTTYPES%"=="y" (
     ..\..\sed.exe -i -e "s/^set YTTYPE=[0-9a-zA-Z]\{,9\}/set YTTYPE=%YTTYPE%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%ACTYPES%"=="y" (
     ..\..\sed.exe -i -e "s/^set ACTYPE=[0-9a-zA-Z]\{,9\}/set ACTYPE=%ACTYPE%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%T_BITRATES%"=="y" (
     ..\..\sed.exe -i -e "s/^set T_BITRATE=[0-9a-zA-Z\.]\{,9\}/set T_BITRATE=%T_BITRATEI%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%CRF_TESTS%"=="y" (
     ..\..\sed.exe -i -e "s/^set CRF_TEST=[0-9a-zA-Z\.]\{,9\}/set CRF_TEST=%CRF_TESTI%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%ENCTYPES%"=="y" (
     ..\..\sed.exe -i -e "s/^set ENCTYPE=[0-9a-zA-Z]\{,9\}/set ENCTYPE=%ENCTYPE%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%DECTYPES%"=="y" (
     ..\..\sed.exe -i -e "s/^set DECTYPE=[0-9a-zA-Z]\{,9\}/set DECTYPE=%DECTYPE%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%DEINTS%"=="y" (
     ..\..\sed.exe -i -e "s/^set DEINT=[0-9a-zA-Z]\{,9\}/set DEINT=%DEINT%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%RESIZES%"=="y" (
     ..\..\sed.exe -i -e "s/^set RESIZE=[0-9a-zA-Z:\.]\{,9\}/set RESIZE=%RESIZE%/" "..\..\..\setting\enc_setting.bat"
     if "%RESIZED%"=="y" (
        if "%WIDTHW%"=="y" (
          ..\..\sed.exe -i -e "s/^set DEFAULT_WIDTHW=[0-9a-zA-Z\.]\{,9\}/set DEFAULT_WIDTHW=%WIDTH%/" "..\..\..\setting\enc_setting.bat"
rem          ..\..\sed.exe -i -e "s/^set DEFAULT_HEIGHTW=[0-9]\{,9\}/set DEFAULT_HEIGHTW=%HEIGHT%/" "..\..\..\setting\enc_setting.bat"
        ) else (
rem          ..\..\sed.exe -i -e "s/^set DEFAULT_WIDTH=[0-9]\{,9\}/set DEFAULT_WIDTH=%WIDTH%/" "..\..\..\setting\enc_setting.bat"
          ..\..\sed.exe -i -e "s/^set DEFAULT_HEIGHT=[0-9a-zA-Z\.]\{,9\}/set DEFAULT_HEIGHT=%HEIGHT%/" "..\..\..\setting\enc_setting.bat"
        )
     )
   )
   if "%TEMP_BITRATES%"=="y" (
     ..\..\sed.exe -i -e "s/^set TEMP_BITRATE=[0-9a-zA-Z\.]\{,9\}/set TEMP_BITRATE=%TEMP_BITRATE%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%A_SYNCS%"=="y" (
     ..\..\sed.exe -i -e "s/^set A_SYNC=[-\+0-9a-zA-Z\.]\{,9\}/set A_SYNC=%A_SYNC%/" "..\..\..\setting\enc_setting.bat"
   )
   if "%A_GAINS%"=="y" (
       ..\..\sed.exe -i -e "s/^set A_GAIN=[-\+0-9a-zA-Z\.]\{,9\}/set A_GAIN=%A_GAIN%/" "..\..\..\setting\enc_setting.bat"
   )
cd ..\..
exit /b

:return_to_confirm
echo ^>^>%RETURN_MESSAGE1%
echo;
if not "%HARUMODE%"=="true" (
  if /i "%VOICE%"=="true" (
    if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.mp3"
    ) else if exist "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav" (
      %PLAY_CMD1% "..\Extra\Voice\%VOICE_DIR%\RETURN_MESSAGE1.wav"
    )
  )
)
goto confirm_question
exit /b
