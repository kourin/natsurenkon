@echo off
if exist %TEMP_INFO% del %TEMP_INFO%

:loop_main
if "%~1"=="" goto loop_end
if not exist "%~1" (
  echo;
  echo "%~1" is missing!
  echo %FILENAME_ERROR1%
  echo %FILENAME_ERROR3%
  echo file_NOT_found> %TEMP_INFO%
  pause
  exit
)
shift
goto loop_main

:loop_end
echo file_found> %TEMP_INFO%
exit
