@echo on

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

echo MB-CD: Checking for required files...
for %%i in (bin\Wselect.exe bin\cabarc.exe) do if not exist %%i (
	echo MB-CD: File "%%i" not found
	goto _abort
)

set mb_cname=
set mb_ok=
set mb_deb=
set mb_img=
set mb_name=
set mb_cfg=%~n0.cfg

:_arg
	if "%1" == "" goto _chkcfg
	if "%1" == "-d" goto _deb
	goto _abort

:_next
	shift
	goto _arg

:_deb
	set mb_deb=1
	goto _next

:_chkcfg
	if exist cds\%bcd_name%\%mb_cfg% (goto _start)
	if exist cds\%bcd_name%\%~n0.sam (
		if defined mb_deb (echo DEBUG: Renaming "cds\%bcd_name%\%~n0.sam" into "cds\%bcd_name%\%mb_cfg%")
		xcopy cds\%bcd_name%\%~n0.sam cds\%bcd_name%\%mb_cfg%* /Y
		goto _chkcfg
	) else (
		echo MB-CD: Could not find "%mb_cfg%" OR "%~n0.sam" in the disk project!
		goto _abort1
	)

:_start
	set /a mb_count=1
	type nul>cds\%bcd_name%\menu.tmp
	for /F "eol=# tokens=1,2,3,4" %%i in (cds\%bcd_name%\%mb_cfg%) do (
		set "_entry_command=%%i"
		set "_entry_name=%%j"
		if "!_entry_command!" equ "n" (
			if defined mb_deb (echo DEBUG: line=[!_entry_command!] [!_entry_name!])
			echo !mb_count!^) !_entry_name!>> cds\%bcd_name%\menu.tmp
			set "_menu_item[!mb_count!]=!_entry_name!"
			set /a mb_count+=1
		)
		if "!_entry_command!" equ "N" (
			if defined mb_deb (echo DEBUG: line=[!_entry_command!] [!_entry_name!])
			echo !mb_count!^) !_entry_name!>> cds\%bcd_name%\menu.tmp
			set "_menu_item[!mb_count!]=!_entry_name!"
			set /a mb_count+=1
		)
	)
	echo. >> cds\%bcd_name%\menu.tmp
	echo %mb_count%) Quit >> cds\%bcd_name%\menu.tmp
	set _entry_quit=%mb_count%
	bin\Wselect.exe cds\%bcd_name%\menu.tmp "Modboot CD Builder" "" "Select Configuration:" /menu /hc=#CC0000 /cmdCenter /ontop
	if %errorlevel% equ 0 (
		echo Please make a selection!
		pause
		goto _start
	)
	if %errorlevel% gtr 0 (
		if %errorlevel% lss %_entry_quit% (
			set mb_name=!_menu_item[%errorlevel%]!
			call :_nuke_dir
		)
	)
	if %errorlevel% equ %_entry_quit% (
		goto _end
	)
	if %errorlevel% gtr %mb_count% (
		echo MB-CD: Menu selection doesn't match a menu entry.
		goto _abort1
	)
	echo MB-CD: Building "%mb_name%" from "cds\%bcd_name%\%mb_cfg%"
	echo MB-CD: Using config file cds\%bcd_name%\%mb_cfg%
	rem parsing %mb_cfg% file
	for /F "eol=# tokens=1,2,3,4" %%i in (cds\%bcd_name%\%mb_cfg%) do call :_bline %%i %%j %%k %%l
	if defined mb_err (goto _abort)
	if "%mb_ok%" == "" (goto _ndone)
	if not "%mb_img%" == "" (echo MB-CD: Image "%mb_img%" created.)
	echo MB-CD: Done!
	goto _end

:_ndone
	echo MB-CD: "%mb_name%" is an invalid name!
	echo MB-CD: You must specify one of the following names:
	rem listing %mb_cfg% file in the same dir as this file
	if not exist cds\%bcd_name%\%mb_cfg% (goto :eof)
	echo MB-CD: Additional names from cds\%bcd_name%\%mb_cfg%
	for /F "eol=# tokens=1,2,3,4" %%j in (cds\%bcd_name%\%mb_cfg%) do call :_bline2 %%j %%k %%l %%m
	call :_nuke_dir
	goto _abort

:_done
	if not "%mb_img%" == "" (echo MB-CD: Image "%mb_img%" created.)
	echo MB-CD: Done!
	goto _end

:_bline2
	if defined mb_deb (echo DEBUG: line=[%1] [%2] [%3])
	if defined mb_err (goto :eof)
	if "%1" == "n" (goto _cmd2n)
	if "%1" == "N" (goto _cmd2n)
	goto :eof

:_cmd2n
	echo %2
	goto :eof

:_bline
	if defined mb_deb (echo DEBUG: line=[%1] [%2] [%3])
	if defined mb_err (goto :eof)
	if "%1" == "n" (goto _cmd_n)
	if "%1" == "N" (goto _cmd_n)
	if not "%mb_cname%" == "%mb_name%" (goto :eof)
	set mb_ok=1
	if "%1" == "c" (goto _cmd_c)
	if "%1" == "C" (goto _cmd_c)
	if "%1" == "t" (goto _cmd_t)
	if "%1" == "T" (goto _cmd_t)
	if "%1" == "x" (goto _cmd_x)
	if "%1" == "X" (goto _cmd_x)
	if "%1" == "m" (goto _cmd_m)
	if "%1" == "M" (goto _cmd_m)
	if "%1" == "d" (goto _cmd_d)
	if "%1" == "D" (goto _cmd_d)
	if "%1" == "i" (goto _cmd_i)
	if "%1" == "I" (goto _cmd_i)
	echo MB-CD: Unknown command "%1"
	set mb_err=1
	goto :eof

:_cmd_i
	if not exist %2 (
		echo MB-CD: Include file "%2" not found
		set mb_err=1
		goto :eof)
	for /F "eol=# tokens=1,2,3,4" %%i in (%2) do call :_bline %%i %%j %%k %%l
	goto :eof

:_cmd_c
	if defined mb_deb (echo DEBUG: Copying "%2" to "cds\%bcd_name%\files\%3")
	copy %2 cds\%bcd_name%\files\%3 >nul
	if not errorlevel 1 (goto :eof)
	echo MB-CD: Copy returned an error
	set mb_err=1
	goto :eof

rem t - try to copy (if exists)
:_cmd_t
	if not exist %2 (goto :eof)
	if defined mb_deb (echo DEBUG: Copying "%2" to "cds\%bcd_name%\files\%3")
	copy "%2 cds\%bcd_name%\files\%3" >nul
	if not errorlevel 1 (goto :eof)
	echo MB-CD: Copy returned an error
	set mb_err=1
	goto :eof

:_cmd_d
	if defined mb_deb (echo DEBUG: Copy driver file(s) "%2" to "cds\%bcd_name%\files\%3")
	for %%i in (%2) do call :_cmd_dd %%i %3 %4
	goto :eof

:_cmd_dd
	if defined mb_deb (echo DEBUG: Copying file "%1" to "cds\%bcd_name%\files\%2")
	copy %1 "cds\%bcd_name%\files\%2" >nul
	if not errorlevel 1 (goto _cmd_da)
	echo MB-CD: Copy returned an error
	set mb_err=1
	goto :eof

:_cmd_da
	if defined mb_deb (echo DEBUG: Adding driver info to index "cds\%bcd_name%\files\%3")
	if exist %temp%\ndis.* (del %temp%\ndis.*)
	bin\cabarc.exe -o x %1 ndis.* %temp%\
	if exist "cds\%bcd_name%\files\%3.nic" (goto _cmd_pn)
	echo ; This file is used to manual> "cds\%bcd_name%\files\%3.nic"
	echo ; select a network driver>>  "cds\%bcd_name%\files\%3.nic"
	echo :_ndis "Select Network driver..." [x]>>  "cds\%bcd_name%\files\%3.nic"

:_cmd_pn
	if exist "cds\%bcd_name%\files\%3.pci" (goto _cmd_pp)
	echo ; PCI map file (created by mb.cmd)> "cds\%bcd_name%\files\%3.pci"
:_cmd_pp
	if not exist %temp%\ndis.txt (
		echo MB-CD: Driver "%1" does not have a ndis.txt file
		set mb_err=1
		goto :eof)
	if exist %temp%\ndis.pci (type %temp%\ndis.pci >>  "cds\%bcd_name%\files\%3.pci")
	if exist %temp%\ndis.txt (type %temp%\ndis.txt >>  "cds\%bcd_name%\files\%3.nic")
	if exist %temp%\ndis.* (del %temp%\ndis.*)
	goto :eof

:_cmd_n
	set mb_cname=%2
	if defined mb_deb (echo DEBUG: name set to "%mb_cname%")
	goto :eof

:_cmd_m
	if defined mb_deb (echo DEBUG: Attempt to make directory "cds\%bcd_name%\files\%2")
	if not exist cds\%bcd_name%\files\%2\nul (
		mkdir cds\%bcd_name%\files\%2
	) else (
		if defined mb_deb (echo DEBUG: Directory "cds\%bcd_name%\files\%2" already exists)
	)
	if not errorlevel 1 (goto :eof)
	echo MB-CD: mkdir returned an error
	set mb_err=1
	goto :eof

:_cmd_x
	if defined mb_deb (echo DEBUG: XCopying "%2" to "cds\%bcd_name%\files\%3")
	xcopy %2\*.* cds\%bcd_name%\files\%3\ /S /E /I
	if not errorlevel 1 (goto :eof)
	echo MB-CD: XCopy returned an error
	set mb_err=1
	goto :eof
	
:_nuke_dir
	if exist *.tmp (
		if defined mb_deb (echo DEBUG: Removing any and all ".tmp" files from "cds\%bcd_name%\files")
		del /F /Q cds\%bcd_name%\*.tmp
	)
	if exist cds\%bcd_name%\files\level0\nul (
		if defined mb_deb (echo DEBUG: Removing level0 directory from "cds\%bcd_name%\files")
		rmdir /S /Q cds\%bcd_name%\files\level0
	)
	if exist cds\%bcd_name%\files\level1\nul (
		if defined mb_deb (echo DEBUG: Removing level1 directory from "cds\%bcd_name%\files")
		rmdir /S /Q cds\%bcd_name%\files\level1
	)
	if exist cds\%bcd_name%\files\level2\nul (
		if defined mb_deb (echo DEBUG: Removing level2 directory from "cds\%bcd_name%\files")
		rmdir /S /Q cds\%bcd_name%\files\level2
	)
	if exist cds\%bcd_name%\files\level3\nul (
		if defined mb_deb (echo DEBUG: Removing level3 directory from "cds\%bcd_name%\files")
		rmdir /S /Q cds\%bcd_name%\files\level3
	)
	if exist cds\%bcd_name%\files\lib\nul (
		if defined mb_deb (echo DEBUG: Removing lib directory from "cds\%bcd_name%\files")
		rmdir /S /Q cds\%bcd_name%\files\lib
	)
	goto :eof

:_4nt
	echo MB-CD: Cannot run with 4NT! Use the normal command interperter (cmd.exe)
	goto _abort
	rem flow into _abort

:_noext
	echo MB-CD: Unable to enable extensions.
	rem flow into _abort

:_abort
	if "%mb_img%" == "" (goto _abort1)
	if exist %mb_img% (
		echo MB-CD: Removing "%mb_img%"
		del %mb_img%
	)

:_abort1
	echo MB-CD: Aborted...
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
	echo MB-CD: Exiting with return value %rv%
