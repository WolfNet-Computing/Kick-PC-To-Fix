@echo off
set t=%tmp%\dougtmp.bat
:loop
%cddrv%\bin\dougmenu.exe %cddrv%\bin\mainmenu.txt
if errorlevel==2 %t%
if errorlevel==1 goto quit
call %t%
goto loop
:quit
set t=
