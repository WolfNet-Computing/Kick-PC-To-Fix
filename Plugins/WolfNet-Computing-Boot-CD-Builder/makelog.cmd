@echo off
echo %~nx0: Logging all output to file "%~n0.txt"
echo %~nx0: Executing "%*", please wait...
call %* > %~n0.txt 2>&1
echo %~nx0: Done, check "%~n0.txt"
