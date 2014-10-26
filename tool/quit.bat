rem ‚Â‚ñ‚Å‚ê‚ñ‚±‚ÌI—¹

if not defined INPUT_FILE_PATH goto quit
if "%FILENAME_ERROR_FOUND%"=="y" goto quit

(
   echo;
   echo %TEMP_DIR%
)>> %ERROR_REPORT%
for /f "usebackq" %%i in (`dir /b /ON %TEMP_DIR%`) do (echo %%i)>> %ERROR_REPORT%

:quit
echo ^>^>%PAUSE_MESSAGE2%
pause>nul
exit
