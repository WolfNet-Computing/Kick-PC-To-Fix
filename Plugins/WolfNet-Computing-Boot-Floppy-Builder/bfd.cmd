@echo off
set %bfd_deb%=1

if not exist VERSION (
	echo VERSION file doesn't exist!
	echo Unknown version error.
	goto _abort
) else (
	set /p bfd_version=<VERSION
)

echo.
echo Bootable Floppy Builder.
echo Version: %bfd_version%
echo Copyright (c) 2023 WolfNet Computing. All rights reserved.
echo.

verify other 2>nul
setlocal enableextensions
if errorlevel 1 goto _noext
if not "%_4VER%" == "" goto _4nt

rem to current drive and path
%~d0
cd "%~dp0"
if "%1" == "" goto _usage
echo BFD: Checking for required files...
for %%i in (bin\bfi.exe bin\cabarc.exe bin\mkbt.exe bin\Wbox.exe) do if not exist %%i (
	echo BFD: File "%%i" not found
	goto _abort
)
if exist bfd.ok goto _ok

:_notice
bin\Wbox.exe "* IMPORTANT NOTICE *"  "This program uses some files from Microsoft Windows 98 which are protected by ^copyright. You must have a valid Windows 98 license before using these files. ^When you do not have a valid license for Windows 98 but you do have one for ^Windows 95 or msdos 6 you should create an OS plugin with those licensed files or ^if you have no microsoft licenses then use FreeDOS. ^If you have read and understood the information above you can click ^continue." "Continue;Quit" /OT /DB=2 /TL=7 /FS=12 /BG=#444444
if %errorlevel% equ 0 goto _notice
if %errorlevel% equ 2 goto _abort
echo OK > bfd.ok

:_ok
set bfd_name=
set bfd_cname=
set bfd_target=
set bfd_os=
set bfd_img=
set bfd_type=
set bfd_nop=
set bfd_la=
set bfd_bi=
set bfd_ok=
set bfd_or=

:_arg
if "%1" == "" goto _start
rem if "%1" == "-o" goto _os
if "%1" == "-t" goto _type
if "%1" == "-d" goto _deb
if "%1" == "-n" goto _nop
if "%1" == "-i" goto _img
if "%bfd_name%" == "" goto _name
if "%bfd_target%" == "" goto _target

:_next
shift
goto _arg

:_img
shift
if "%1" == "" goto _usage
set bfd_img=%1
goto _next

:_deb
set bfd_deb=1
goto _next

:_nop
set bfd_nop=1
goto _next

:_name
if "%1" == "" goto _usage
set bfd_name=%1
goto _next

:_target
if "%1" == "" goto _usage
set bfd_target=%1
goto _next

:_os
shift
if "%1" == "" goto _usage
set bfd_os=%1
goto _next

:_type
shift
if "%1" == "" goto _usage
set bfd_type=%1
goto _next

:_start
if "%bfd_name%" == "" goto _usage
rem default values
rem if "%bfd_os%" == "" set bfd_os=md701
if "%bfd_type%" == "" set bfd_type=144
if "%bfd_img%" == "" if "%bfd_target%" == "" set bfd_target=a:
echo BFD: Building "%bfd_name%"

:_cfgredo
if exist bfd.cfg goto _cfgok
	if exist bfd.sam (
		echo BFD: Renaming bfd.sam into bfd.cfg
		ren bfd.sam bfd.cfg
		goto _cfgredo)
	echo BFD: Could not find bfd.cfg

:_cfgok
if "%bfd_img%" == "" goto _noimg
rem image mode
echo BFD: Target image file "%bfd_img%"
set bfd_target=%temp%\$bfd$
goto _pass1

:_noimg
rem no image
echo BFD: Target drive "%bfd_target%"

:_pass1
rem parsing bfd.cfg file
echo BFD: Parsing config file "bfd.cfg"
for /F "eol=# tokens=1,2,3,4" %%i in (bfd.cfg) do call :_bline %%i %%j %%k %%l
if defined bfd_err goto _abort
rem parsing any cds\*\bfd.cfg file(s)
for /D %%i in (cds\*.*) do (
	echo BFD: Calling ":_cdscfg %%i"
	call :_cdscfg %%i
	if defined bfd_err goto _abort
)
rem parsing any plugin\*.cfg file(s)
for %%i in (plugin\*.cfg) do (
	echo BFD: Calling ":_plugcfg %%i"
	call :_plugcfg %%i
	if defined bfd_err goto _abort
)
if "%bfd_ok%" == "" goto _ndone
if "%bfd_img%" == "" goto _done
rem create the image file
echo BFD: Creating image "%bfd_img%"
set bfd_tmp=
rem label goes first in the dir skip it for now...
rem if not "%bfd_la%" == "" set bfd_tmp="-l=%bfd_la%"
if not "%bfd_bi%" == "" set bfd_tmp=%bfd_tmp% -b=%bfd_bi%
if not "%bfd_or%" == "" set bfd_tmp=%bfd_tmp% -o=%bfd_or%
if not "%bfd_type%" == "" set bfd_tmp=%bfd_tmp% -t=%bfd_type%
echo BFD: Running bfi -f=%bfd_img% %bfd_tmp% %bfd_target%
bin\bfi.exe -f=%bfd_img% %bfd_tmp% %bfd_target%
if errorlevel 1 goto _abort
set bfd_tmp=
rem clean up temp target
if not exist %bfd_target%\nul goto _done
echo BFD: Remove directory "%bfd_target%"
rmdir /s /q %bfd_target%
if not exist %bfd_target%\nul goto _done
goto _end

:_ndone
echo BFD: "%bfd_name%" is an invalid name!
echo BFD: You must specify one of the following names:
for /F "eol=# tokens=1,2,3,4" %%i in (bfd.cfg) do call :_bline3 %%i %%j %%k %%l
rem listing any cds\*\bfd.cfg file(s)
for /D %%i in (cds\*.*) do (
	echo BFD: Calling ":_cdscfg2 %%i"
	call :_cdscfg2 %%i
)
rem listing any plugin '.cfg' file(s)
for %%i in (plugin\*.cfg) do (
	echo BFD: Calling ":_plugcfg2 %%i"
	call :_plugcfg2 %%i
)
goto _abort

:_cdscfg2
if defined bfd_err goto :eof
if not exist %1\bfd.cfg goto :eof
echo BFD: Additional names from "%1\bfd.cfg"
for /F "eol=# tokens=1,2,3,4" %%j in (%1\bfd.cfg) do call :_bline3 %%j %%k %%l %%m
goto :eof

:_plugcfg2
if defined bfd_err goto :eof
if not exist %1 goto :eof
echo BFD: Additional names from "%1"
for /F "eol=# tokens=1,2,3,4" %%j in (%1) do call :_bline3 %%j %%k %%l %%m
goto :eof

:_done
if not "%bfd_img%" == "" echo BFD: Image "%bfd_img%" created.
echo BFD: Done!
goto _end

:_cdscfg
if defined bfd_err goto :eof
if not exist %1\bfd.cfg goto :eof
echo BFD: Including config file "%1\bfd.cfg"
for /F "eol=# tokens=1,2,3,4" %%j in (%1\bfd.cfg) do call :_bline %%j %%k %%l %%m
goto :eof

:_plugcfg
if defined bfd_err goto :eof
if not exist %1 goto :eof
echo BFD: Including config file "%1"
for /F "eol=# tokens=1,2,3,4" %%j in (%1) do call :_bline %%j %%k %%l %%m
goto :eof

:_bline3
if defined bfd_deb echo debug: line=[%1] [%2] [%3]
if defined bfd_err goto :eof
if "%1" == "n" goto _cmd3n
if "%1" == "N" goto _cmd3n
goto :eof

:_cmd3n
echo %2
goto :eof

:_bline
if defined bfd_deb echo debug: line=[%1] [%2] [%3]
if defined bfd_err goto :eof
if "%1" == "n" goto _cmd_n
if "%1" == "N" goto _cmd_n
if not "%bfd_cname%" == "%bfd_name%" goto :eof
set bfd_ok=1
if "%1" == "c" goto _cmd_c
if "%1" == "C" goto _cmd_c
if "%1" == "t" goto _cmd_t
if "%1" == "T" goto _cmd_t
if "%1" == "x" goto _cmd_x
if "%1" == "X" goto _cmd_x
if "%1" == "f" goto _cmd_f
if "%1" == "F" goto _cmd_f
if "%1" == "m" goto _cmd_m
if "%1" == "M" goto _cmd_m
if "%1" == "b" goto _cmd_b
if "%1" == "B" goto _cmd_b
if "%1" == "d" goto _cmd_d
if "%1" == "D" goto _cmd_d
if "%1" == "o" goto _cmd_o
if "%1" == "O" goto _cmd_o
if "%1" == "i" goto _cmd_i
if "%1" == "I" goto _cmd_i
if "%1" == "it" goto _cmd_it
if "%1" == "IT" goto _cmd_it
echo BFD: Unknown command "%1"
set bfd_err=1
goto :eof

:_cmd_it
set bfd_type=%2
echo BFD: Image type set to "%bfd_type%"
goto :eof

:_cmd_i
if not exist %2 (
	echo BFD: Include file "%2" not found
	set bfd_err=1
	goto :eof)
for /F "eol=# tokens=1,2,3,4" %%i in (%2) do call :_bline %%i %%j %%k %%l
goto :eof

:_cmd_o
set bfd_os=%2
echo BFD: Operating system "%bfd_os%"
if not exist %2.cfg (
	echo BFD: OS include file "%2.cfg" not found
	set bfd_err=1
	goto :eof)
if not exist os\%2 (
	echo BFD: OS Folder "%2" not found
	set bfd_err=1
	goto :eof)
for /F "eol=# tokens=1,2,3,4" %%i in (%2.cfg) do call :_bline %%i %%j %%k %%l
if not "%bfd_bootable%" == "" (
	if not "%bfd_img%" == "" goto _cmd_bi
	echo BFD: Installing bootsector from "os\%bfd_os%\bootsect.bin"
	bin\mkbt.exe -x os\%bfd_os%\bootsect.bin %bfd_target%
	if errorlevel 1 (set bfd_err=1& goto :eof)
	goto _cmd_b2)
goto :eof

:_cmd_b
set bfd_bootable=1
goto :eof

:_cmd_bi
rem image
rem bin\mkbt.exe os\%bfd_os%\bootsect.bin %bfd_img%
rem if errorlevel 1 (set bfd_err=1& goto :eof)
set bfd_bi=os\%bfd_os%\bootsect.bin

:_cmd_b2
if exist os\%bfd_os%\io.sys goto _ms
if exist os\%bfd_os%\ibmbio.com goto _ibm
if exist os\%bfd_os%\kernel.sys goto _fd
rem any other "non-Dos" OS? Maybe NT? bail out
goto :eof

:_cmd_f
if not "%bfd_img%" == "" goto _cmd_fi
echo BFD: Formatting drive "%bfd_target%" extra arguments "%2"
rem type is disk
if "%bfd_nop%" == "1" goto _format

:_again
echo.
echo BFD: Insert floppy to format in drive %bfd_target%
echo BFD: Warning! All data on floppy will be destroyed!
echo.
bin\bchoice /c:ca /d:c Press C or Enter to continue or A to Abort?
if errorlevel 1 (
	set bfd_err=1
	goto :eof)
echo.

:_format
echo BFD: Formatting...
format %bfd_target% %2 /u /backup /v:
if errorlevel 1 goto _again
goto :eof

:_cmd_fi
rem image
rem zap temp target
if not exist %bfd_target%\nul goto _cmd_fi3
echo BFD: Remove directory "%bfd_target%"
rmdir /s /q %bfd_target%
if not exist %bfd_target%\nul goto _cmd_fi3
set bfd_err=1
goto :eof

:_cmd_fi3
echo BFD: Create directory "%bfd_target%"
mkdir %bfd_target%
if not exist %bfd_target%\nul set bfd_err=1
goto :eof

:_cmd_c
echo BFD: Copying "%2" to "%bfd_target%\%3"
copy %2 %bfd_target%\%3 >nul
if not errorlevel 1 goto :eof
echo BFD: Copy returned an error
set bfd_err=1
goto :eof

rem t - try to copy (if exists)
:_cmd_t
if not exist %2 goto :eof
echo BFD: Copying "%2" to "%bfd_target%\%3"
copy %2 %bfd_target%\%3 >nul
if not errorlevel 1 goto :eof
echo BFD: Copy returned an error
set bfd_err=1
goto :eof

:_cmd_d
echo BFD: Copy driver file(s) "%2" to "%bfd_target%\%3"
for %%i in (%2) do call :_cmd_dd %%i %3 %4
goto :eof

:_cmd_dd
echo BFD: Copying file "%1" to "%bfd_target%\%2"
copy %1 %bfd_target%\%2 >nul
if not errorlevel 1 goto _cmd_da
echo BFD: Copy returned an error
set bfd_err=1
goto :eof

:_cmd_da
echo BFD: Adding driver info to index "%bfd_target%\%3"
if exist %temp%\ndis.* del %temp%\ndis.*
bin\cabarc.exe -o x %1 ndis.* %temp%\
rem goto :eof
rem :_cmd_dok
if exist %bfd_target%\%3.nic goto _cmd_pn
echo ; This file is used to manual> %bfd_target%\%3.nic
echo ; select a network driver>> %bfd_target%\%3.nic
echo :_ndis "Select Network driver..." [x]>> %bfd_target%\%3.nic

:_cmd_pn
if exist %bfd_target%\%3.pci goto _cmd_pp
echo ; PCI map file (created by bfd.cmd)> %bfd_target%\%3.pci
:_cmd_pp
if not exist %temp%\ndis.txt (
	echo BFD: Driver "%1" does not have a ndis.txt file
	set bfd_err=1
	goto :eof)
if exist %temp%\ndis.pci type %temp%\ndis.pci >> %bfd_target%\%3.pci
if exist %temp%\ndis.txt type %temp%\ndis.txt >> %bfd_target%\%3.nic
if exist %temp%\ndis.* del %temp%\ndis.*
goto :eof

:_cmd_n
set bfd_cname=%2
if defined bfd_deb echo debug: name set to "%bfd_cname%"
goto :eof

:_cmd_m
echo BFD: Attempt to make directory "%bfd_target%\%2"
if not exist %bfd_target%\%2\nul (
	mkdir "%bfd_target%\%2"
) else (
	echo BFD: Directory "%bfd_target%\%2" already exists
)
if not errorlevel 1 goto :eof
echo BFD: mkdir returned an error
set bfd_err=1
goto :eof

:_ms
echo BFD: Copying MS-Dos boot files
call :_bline c os\%bfd_os%\io.sys
if defined bfd_err goto :eof
set bfd_or=io.sys
call :_bline c os\%bfd_os%\msdos.sys
if defined bfd_err goto :eof
call :_bline c os\%bfd_os%\command.com
if defined bfd_err goto :eof
goto _label

:_ibm
echo BFD: Copying Dr-DOS boot files
call :_bline c os\%bfd_os%\ibmbio.com
if defined bfd_err goto :eof
set bfd_or=ibmbio.sys
call :_bline c os\%bfd_os%\ibmdos.com
if defined bfd_err goto :eof
call :_bline c os\%bfd_os%\command.com
if defined bfd_err goto :eof
goto _label

:_fd
echo BFD: Copying FreeDos boot files
call :_bline c os\%bfd_os%\kernel.sys
if defined bfd_err goto :eof
set bfd_or=kernel.sys
call :_bline c os\%bfd_os%\command.com
if defined bfd_err goto :eof

:_label
if not "%bfd_img%" == "" goto _imglabel
echo BFD: Label
if not "%2" == "" label %bfd_target% %2
if "%2" == "" label %bfd_target% modboot
goto :eof

:_imglabel
if not "%2" == "" set bfd_la=%2
if "%2" == "" set bfd_la=modboot
bin\mkbt.exe -x os\%bfd_os%\bootsect.bin %bfd_target%
goto :eof

:_cmd_x
echo BFD: XCopying "%2" to "%bfd_target%\%3"
xcopy %2\*.* %bfd_target%\%3\ /S /E /I
if not errorlevel 1 goto :eof
echo BFD: XCopy returned an error
set bfd_err=1
goto :eof

:_usage
echo.
echo Usage: bfd [-d] [-i file] [-t type] name [target]
echo.
echo   name    : name of the disk or image to build (see bfd.cfg)
echo   target  : target drive or file (default is "a:")
echo   -d      : print debug messages
echo   -i file : create an image file (optional winimage!)
echo   -t type : image type (144 or 288)
echo   -n      : don't wait for the user to insert a diskette
echo.
echo Returns environment variable "rv", 0 if succesfull, 1 if error
echo.
echo This program uses the following files (located in the "bin" directory):
echo - Cabinet Tool (cabarc.exe) by Microsoft Corp.
goto _end

:_4nt
echo BFD: Cannot run with 4NT! Use the normal command interperter (cmd.exe)
goto _abort
rem flow into _abort

:_noext
echo BFD: Unable to enable extensions.
rem flow into _abort

:_abort
if "%bfd_img%" == "" goto _abort1
if exist %bfd_img% (
	echo BFD: Removing "%bfd_img%"
	del %bfd_img%
)

:_abort1
echo BFD: Aborted...
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
echo BFD: Exiting with return value %rv%
