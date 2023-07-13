@echo off
rem -------------------------------------------------------------------------
rem WHATNT, Ask user for what NT files to use
rem Copyright (c) 2002 Bart Lagerweij. All rights reserved.
rem This program is free software. Use and/or distribute it under the terms
rem of the NU2 License (see nu2lic.txt or http://www.nu2.nu/license/).
rem -------------------------------------------------------------------------
call w.bat box @%0:w_nt
if errorlevel 100 goto _none
echo WHATNT: Selected NT version is "%wbat%"
goto _end
:_none
set wbat=
goto _end
:w_nt "What is your NT version?" [x]

 [ NT4 ]  Microsoft Windows NT 4.0

 [ NT5 ]  Microsoft Windows 2000/XP

 Escape to abort...  
::
:_end
