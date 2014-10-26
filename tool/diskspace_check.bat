@echo off

chcp 437
dir /-c "%~d0"> %TEMP_INFO%
"%WINDIR%\system32\findstr.exe" /R /C:"bytes free$" %TEMP_INFO%> %TEMP_INFO2%

exit
