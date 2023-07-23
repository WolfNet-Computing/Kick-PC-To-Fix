@echo off

if not exist MODBOOT-CD.VERSION (
	echo VERSION file doesn't exist!
	echo Unknown version error.
	goto _abort
) else (
	set /p mb_version=<MODBOOT-CD.VERSION
)

echo.
echo Modular Boot CD Builder.
echo Version: %mb_version%
echo Copyright (c) 2022-2023 WolfNet Computing. All rights reserved.
echo.

verify other 2>nul
setlocal enableextensions
if errorlevel 1 goto _noext
if not "%_4VER%" == "" goto _4nt

if "%1" == "" goto _usage
echo mb: Checking for required files...
for %%i in (bin\bfi.exe bin\bchoice.exe bin\cabarc.exe) do if not exist %%i (
	echo mb: File "%%i" not found
	goto _abort
)

set mb_cname=
set mb_target=
set mb_os=
set mb_img=
set mb_type=
set mb_nop=
set mb_la=
set mb_bi=
set mb_ok=
set mb_or=

:_arg
if "%1" == "" goto _start
if "%1" == "-d" goto _deb

:_next
shift
goto _arg

:_deb
set mb_deb=1
goto _next

:_start


:_cfgredo
echo mb: Building "%mb_name%"
if exist modboot-cd.cfg goto _cfgok
	if exist mb.sam (
		echo mb: Renaming modboot-cd.sam into modboot-cd.cfg
		ren modboot-cd.sam modboot-cd.cfg
		goto _cfgredo)
	echo mb: Could not find modboot-cd.cfg

:_cfgok
if "%mb_img%" == "" goto _noimg
rem image mode
echo mb: Target image file "%mb_img%"
set mb_target=%temp%\$mb$
goto _pass1

:_noimg
rem no image
echo mb: Target drive "%mb_target%"

:_pass1
rem parsing any modboot-cd.cfg file(s) in the same dir as this file
for /D %%i in (%~dp0) do (
	echo mb: Calling ":_modcfg %%i"
	call :_cdscfg %%i
	if defined mb_err goto _abort
)
if "%mb_ok%" == "" goto _ndone
if "%mb_img%" == "" goto _done
goto _end

:_ndone
echo mb: "%mb_name%" is an invalid name!
echo mb: You must specify one of the following names:
rem listing any modboot-cd.cfg file(s) in the same dir as this file
for /D %%i in (%~dp0) do (
	echo mb: Calling ":_modcfg2 %%i"
	call :_modcfg2 %%i
)
goto _abort

:_modcfg2
if defined mb_err goto :eof
if not exist %1\modboot-cd.cfg goto :eof
echo mb: Additional names from "%1\modboot-cd.cfg"
for /F "eol=# tokens=1,2,3,4" %%j in (%1\modboot-cd.cfg) do call :_bline3 %%j %%k %%l %%m
goto :eof

:_done
if not "%mb_img%" == "" echo mb: Image "%mb_img%" created.
echo mb: Done!
goto _end

:_modcfg
if defined mb_err goto :eof
if not exist %1\modboot-cd.cfg goto :eof
echo mb: Including config file "%1\modboot-cd.cfg"
for /F "eol=# tokens=1,2,3,4" %%j in (%1\modboot-cd.cfg) do call :_bline %%j %%k %%l %%m
goto :eof

:_bline3
if defined mb_deb echo debug: line=[%1] [%2] [%3]
if defined mb_err goto :eof
if "%1" == "n" goto _cmd3n
if "%1" == "N" goto _cmd3n
goto :eof

:_cmd3n
echo %2
goto :eof

:_bline
if defined mb_deb echo debug: line=[%1] [%2] [%3]
if defined mb_err goto :eof
if "%1" == "n" goto _cmd_n
if "%1" == "N" goto _cmd_n
if not "%mb_cname%" == "%mb_name%" goto :eof
set mb_ok=1
if "%1" == "c" goto _cmd_c
if "%1" == "C" goto _cmd_c
if "%1" == "t" goto _cmd_t
if "%1" == "T" goto _cmd_t
if "%1" == "x" goto _cmd_x
if "%1" == "X" goto _cmd_x
if "%1" == "m" goto _cmd_m
if "%1" == "M" goto _cmd_m
if "%1" == "d" goto _cmd_d
if "%1" == "D" goto _cmd_d
if "%1" == "i" goto _cmd_i
if "%1" == "I" goto _cmd_i
echo mb: Unknown command "%1"
set mb_err=1
goto :eof

:_cmd_i
if not exist %2 (
	echo mb: Include file "%2" not found
	set mb_err=1
	goto :eof)
for /F "eol=# tokens=1,2,3,4" %%i in (%2) do call :_bline %%i %%j %%k %%l
goto :eof

:_cmd_c
echo mb: Copying "%2" to "%mb_target%\%3"
copy %2 %mb_target%\%3 >nul
if not errorlevel 1 goto :eof
echo mb: Copy returned an error
set mb_err=1
goto :eof

rem t - try to copy (if exists)
:_cmd_t
if not exist %2 goto :eof
echo mb: Copying "%2" to "%mb_target%\%3"
copy %2 %mb_target%\%3 >nul
if not errorlevel 1 goto :eof
echo mb: Copy returned an error
set mb_err=1
goto :eof

:_cmd_d
echo mb: Copy driver file(s) "%2" to "%mb_target%\%3"
for %%i in (%2) do call :_cmd_dd %%i %3 %4
goto :eof

:_cmd_dd
echo mb: Copying file "%1" to "%mb_target%\%2"
copy %1 %mb_target%\%2 >nul
if not errorlevel 1 goto _cmd_da
echo mb: Copy returned an error
set mb_err=1
goto :eof

:_cmd_da
echo mb: Adding driver info to index "%mb_target%\%3"
if exist %temp%\ndis.* del %temp%\ndis.*
bin\cabarc.exe -o x %1 ndis.* %temp%\
rem goto :eof
rem :_cmd_dok
if exist %mb_target%\%3.nic goto _cmd_pn
echo ; This file is used to manual> %mb_target%\%3.nic
echo ; select a network driver>> %mb_target%\%3.nic
echo :_ndis "Select Network driver..." [x]>> %mb_target%\%3.nic

:_cmd_pn
if exist %mb_target%\%3.pci goto _cmd_pp
echo ; PCI map file (created by mb.cmd)> %mb_target%\%3.pci
:_cmd_pp
if not exist %temp%\ndis.txt (
	echo mb: Driver "%1" does not have a ndis.txt file
	set mb_err=1
	goto :eof)
if exist %temp%\ndis.pci type %temp%\ndis.pci >> %mb_target%\%3.pci
if exist %temp%\ndis.txt type %temp%\ndis.txt >> %mb_target%\%3.nic
if exist %temp%\ndis.* del %temp%\ndis.*
goto :eof

:_cmd_n
set mb_cname=%2
if defined mb_deb echo debug: name set to "%mb_cname%"
goto :eof

:_cmd_m
echo mb: Attempt to make directory "%mb_target%\%2"
if not exist %mb_target%\%2\nul (
	mkdir "%mb_target%\%2"
) else (
	echo mb: Directory "%mb_target%\%2" already exists
)
if not errorlevel 1 goto :eof
echo mb: mkdir returned an error
set mb_err=1
goto :eof

:_cmd_x
echo mb: XCopying "%2" to "%mb_target%\%3"
xcopy %2\*.* %mb_target%\%3\ /S /E /I
if not errorlevel 1 goto :eof
echo mb: XCopy returned an error
set mb_err=1
goto :eof

:_4nt
echo mb: Cannot run with 4NT! Use the normal command interperter (cmd.exe)
goto _abort
rem flow into _abort

:_noext
echo mb: Unable to enable extensions.
rem flow into _abort

:_abort
if "%mb_img%" == "" goto _abort1
if exist %mb_img% (
	echo mb: Removing "%mb_img%"
	del %mb_img%
)

:_abort1
echo mb: Aborted...
echo.
rem set errorlevel to 1
endlocal
set rv=1
pause
goto _end2

:_end
rem set errorlevel to 0
endlocal
set rv=0

:_end2
echo mb: Exiting with return value %rv%
