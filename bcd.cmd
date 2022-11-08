@echo off
echo.
echo BCD, Build CD-Rom, v1.1.3
echo Copyright (c) 2022 John Wolfe. All rights reserved.
echo.
verify other 2>nul
setlocal enableextensions
if errorlevel 1 goto _noext
if not "%_4VER%" == "" goto _4nt
rem to current drive and path
%~d0
cd "%~dp0"
if "%1" == "" goto _usage
if "%1" == "-all" for /D %%G in (".\cds\*") do call %0 -b %%~nG
if "%1" == "-all" goto _end2
echo BCD: Checking for required files:
for %%i in (bin\bchoice.exe bin\cdrecord.exe bin\cygwin1.dll bin\mkisofs.exe) do if not exist %%i (
	echo BCD: File "%%i" not found.
	goto _abort)
set bcd_name=
set bcd_deb=
set bcd_noburn=
set bcd_spd=
set bcd_cmd=
set bcd_arg=
set bcd_boot=
set bcd_volid=
set bcd_vset=
set bcd_prep=
set bcd_publ=
set bcd_appid=
set bcd_sysid=
set bcd_isofs=
set bcd_cdr=
set bcd_isofs=
set bcd_tmp=
set bcd_dev=
set bcd_call=
set bcd_src=
set bcd_err=
if exist %temp%\$bcd$.tm? del %temp%\$bcd$.tm?
:_arg
if "%1" == "" goto _start
if "%1" == "-d" goto _deb
if "%1" == "-b" goto _noburn
if "%1" == "-s" goto _speed
if "%1" == "-bab" goto _bldall
if "%bcd_name%" == "" goto _name
:_next
shift
goto _arg
:_deb
set bcd_deb=1
goto _next
:_noburn
set bcd_noburn=1
goto _next
:_speed
shift
set bcd_spd=%1
if "%bcd_spd%" GTR "50" (
	echo BCD: Ignoring invalid speed argument "%bcd_spd%", must be between 1-50.
	set bcd_spd=
	goto _next)
if "%bcd_spd%" LSS "1" (
	echo BCD: Ignoring invalid speed argument "%bcd_spd%", must be between 1-50.
	set bcd_spd=)
echo BCD: Speed set to "%bcd_spd%"
goto _next
:_name
set bcd_name=%1
goto _next
:_start
if not exist cds\%bcd_name%\nul goto _nodir
:_cfgredo
if exist bcd.cfg goto _cfgok
	if exist bcd.sam (
		echo BCD: Renaming bcd.sam into bcd.cfg
		ren bcd.sam bcd.cfg
		goto _cfgredo)
	echo BCD: Could not find bcd.cfg
:_cfgok
echo BCD: Processing (main) config file "bcd.cfg"
for /f "eol=# tokens=1*" %%i in (bcd.cfg) do (
	set bcd_cmd=%%i
	set bcd_arg=%%j
	call :_bline)
if not "%bcd_err%" == "" goto _abort
if not exist cds\%bcd_name%\bcd.cfg goto _nocfg
echo BCD: Processing (CD) config file "cds\%bcd_name%\bcd.cfg"
for /f "eol=# tokens=1*" %%i in (cds\%bcd_name%\bcd.cfg) do (
	set bcd_cmd=%%i
	set bcd_arg=%%j
	call :_bline)
if not "%bcd_err%" == "" goto _abort
:_nocfg
rem
if "%bcd_isofs%" == "" (
	echo BCD: No mkisofs options, adding "-J -N"
	set bcd_isofs=-J -N)
if not "%bcd_volid%" == "" set bcd_isofs=%bcd_isofs% -volid "%bcd_volid%"
if not "%bcd_prep%" == "" set bcd_isofs=%bcd_isofs% -p "%bcd_prep%"
if not "%bcd_publ%" == "" set bcd_isofs=%bcd_isofs% -P "%bcd_publ%"
if not "%bcd_appid%" == "" set bcd_isofs=%bcd_isofs% -A %bcd_appid%
if not "%bcd_sysid%" == "" set bcd_isofs=%bcd_isofs% -sysid "%bcd_sysid%"
if not "%bcd_vset%" == "" set bcd_isofs=%bcd_isofs% -volset "%bcd_vset%"

rem process bootdisk.cfg file
if not exist cds\%bcd_name%\bootdisk.cfg goto _bdcfg
echo BCD: Processing bootdisk config file "cds\%bcd_name%\bootdisk.cfg"
set rv=
for /f "eol=# tokens=1,2" %%i in (cds\%bcd_name%\bootdisk.cfg) do call :_bflop %%i %%j
if not "%bcd_err%" == "" goto _abort
:_bdcfg

rem call some "custom" script
if "%bcd_call%" == "" goto _norun0
if not exist cds\%bcd_name%\%bcd_call% goto _norun0
echo BCD: Calling custom batchfile "cds\%bcd_name%\%bcd_call%"
call cds\%bcd_name%\%bcd_call%
if "%rv%" == "1" goto _abort
:_norun0

if "%bcd_boot%" == "" goto _noboot
rem replace bootfile '\' with '/'
set bcd_boot=%bcd_boot:\=/%
echo BCD: Bootfile is "%bcd_boot%"
set bcd_tmp=cds\%bcd_name%\files\%bcd_boot%
if not exist %bcd_tmp% (
	echo BCD: Bootfile "%bcd_tmp%" not found
	goto _abort)
set bcd_isofs=%bcd_isofs% -b %bcd_boot%
for %%i in (%bcd_tmp%) do if "%%~xi" == ".bin" (
	echo BCD: Bootfile type is ".bin" adding "-no-emul-boot -boot-load-size 4"
	set bcd_isofs=%bcd_isofs% -no-emul-boot -boot-load-size 4)
for %%i in (%bcd_tmp%) do if "%%~nxi" == "isolinux.bin" (
	echo BCD: Bootfile is ISOLINUX adding "-boot-info-table"
	set bcd_isofs=%bcd_isofs% -boot-info-table)
for %%i in (%bcd_tmp%) do if not "%%~xi" == ".bin" goto _nont
findstr /I "setupldr.bin" %bcd_tmp% > %temp%\$bcd$.tmp 2>&1
for /f %%j in (%temp%\$bcd$.tmp) do goto _nont
	echo BCD: Bootfile is NT adding "-no-iso-translate -relaxed-filenames"
	set bcd_isofs=%bcd_isofs% -no-iso-translate -relaxed-filenames
:_nont
for %%i in (%bcd_tmp%) do (
	set bcd_isofs=%bcd_isofs% -hide %%~nxi
	echo BCD: Hidding boot image in ISO9660 adding "-hide %%~nxi")
echo BCD: Hidding boot catalog in ISO9660 adding "-hide boot.catalog"
set bcd_isofs=%bcd_isofs% -hide boot.catalog
echo %bcd_isofs% > %temp%\$bcd$.tm2
findstr "/C:-J " %temp%\$bcd$.tm2 > %temp%\$bcd$.tmp 2>&1
for /f %%i in (%temp%\$bcd$.tmp) do goto _joliet
goto _nojol
:_joliet
	for %%i in (%bcd_tmp%) do (
		echo BCD: Hidding boot image in Joliet adding "-hide-joliet %%~nxi"
		set bcd_isofs=%bcd_isofs% -hide-joliet %%~nxi)
	echo BCD: Hidding boot catalog in Joliet adding "-hide-joliet boot.catalog"
	set bcd_isofs=%bcd_isofs% -hide-joliet boot.catalog
:_nojol
:_noboot
:_norun1
echo BCD: Creating ISO image file (running mkisofs.exe)
echo BCD: Arguments; %bcd_isofs% -v -o %temp%\%bcd_name%.iso cds\%bcd_name%\files %bcd_pth%
bin\mkisofs.exe %bcd_isofs% -v -o %temp%\%bcd_name%.iso cds\%bcd_name%\files %bcd_pth%
if errorlevel 1 (
	echo BCD: mkisofs.exe returned an error...
	goto _abort)
echo BCD: ISO file "%temp%\bcd.iso" created.
if not "%bcd_noburn%" == "" goto _end
if exist bin\wnaspi32.dll goto _wnaspok
echo BCD: File "bin\wnaspi32.dll" is missing, please download it from
echo BCD: http://www.nero.com/en/download.htm and put it in the "bin" folder.
echo BCD: This file is required to access your CD-writer.
set bcd_noburn=1
goto _end
:_wnaspok
set bcd_dev=
echo BCD: Looking for devices, running "cdrecord -scanbus":
bin\cdrecord.exe -scanbus > %temp%\$bcd$.tmp 2>&1
if errorlevel 1 (
	echo BCD: "cdrecord -scanbus" returned an error! Burning not possible!
	set bcd_noburn=1
	goto _end)
findstr /I "/C:cd-rom" %temp%\$bcd$.tmp > %temp%\$bcd$.tm2
for /f %%i in (%temp%\$bcd$.tm2) do goto _devfnd
echo BCD: No CD-Rom type devices found! Burning not possible!
set bcd_noburn=1
goto _end
:_devfnd
echo BCD: Found CD-Rom devices:
type %temp%\$bcd$.tm2
set bcd_dev=
echo BCD: Looking for a CD-RW drive:
for /f "delims=	" %%i in (%temp%\$bcd$.tm2) do (
	set bcd_tmp=%%i
	call :_chkdev Does write CD-RW media)
if not "%bcd_dev%" == "" goto _devok
echo BCD: Looking for a CD-R drive:
for /f "delims=	" %%i in (%temp%\$bcd$.tm2) do (
	set bcd_tmp=%%i
	call :_chkdev Does write CD-R media)
if not "%bcd_dev%" == "" goto _devok
echo BCD: Looking for a DVD-RAM drive:
for /f "delims=	" %%i in (%temp%\$bcd$.tm2) do (
	set bcd_tmp=%%i
	call :_chkdev Does write DVD-R media)
if not "%bcd_dev%" == "" goto _devok
echo BCD: Looking for a DVD-R drive:
for /f "delims=	" %%i in (%temp%\$bcd$.tm2) do (
	set bcd_tmp=%%i
	call :_chkdev Does write DVD-RAM media)
if not "%bcd_dev%" == "" goto _devok
if "%bcd_dev%" == "" (
	echo BCD: No CD writer device found! Burning not possible!
	set bcd_noburn=1
	goto _end)
:_devok
echo BCD: Found writer device at "%bcd_dev%".
if "%bcd_cdr%" == "" (
	echo BCD: No cdrecord options, adding "-data -eject"
	set bcd_cdr=-data -eject)
echo BCD: Checking driver specific options
echo BCD: Running "cdrecord.exe dev=%bcd_dev% -checkdrive driveropts=help"
bin\cdrecord.exe dev=%bcd_dev% -checkdrive driveropts=help >%temp%\$bcd$.tmp 2>&1
if errorlevel 1 goto _media
findstr /I /B "burnfree " %temp%\$bcd$.tmp >%temp%\$bcd$.tm2
for /f %%i in (%temp%\$bcd$.tm2) do goto _burnfree
goto _media
:_burnfree
echo BCD: Drive supports burnfree, adding "driveropts=burnfree"
set bcd_cdr=%bcd_cdr% driveropts=burnfree
:_media
echo BCD: Loading media
bin\cdrecord.exe dev=%bcd_dev% -load >nul 2>&1
if errorlevel 1 goto _nomedia
echo BCD: Checking media type
bin\cdrecord.exe dev=%bcd_dev% -atip >%temp%\$bcd$.tmp 2>&1
if errorlevel 1 (
	echo BCD: cdrecord returned an error:
	type %temp%\$bcd$.tmp
	goto _abort)
findstr /I "/C:No disk / Wrong disk!" %temp%\$bcd$.tmp >%temp%\$bcd$.tm3
for /f %%j in (%temp%\$bcd$.tm3) do goto _nomedia
rem got media, check if media is erasable
findstr /I "/C:Is erasable" %temp%\$bcd$.tmp >%temp%\$bcd$.tm3
for /f %%j in (%temp%\$bcd$.tm3) do goto _iscdrw
rem Some cdr medias do not report "is not erasable" so assuming cdr media
rem if atip "is erasable" is missing...
rem findstr /I "/C:Is not erasable" %temp%\$bcd$.tmp >%temp%\$bcd$.tm3
rem for /f %%j in (%temp%\$bcd$.tm3) do goto _iscdr
rem goto _end
goto _iscdr

:_iscdrw
echo BCD: Media is CD-RW, checking if erase is needed
bin\cdrecord.exe dev=%bcd_dev% -toc >%temp%\$bcd$.tmp 2>&1
if errorlevel 1 (
	echo BCD: cdrecord returned an error:
	type %temp%\$bcd$.tmp
	goto _abort)
findstr /I "/C:Cannot read TOC header" %temp%\$bcd$.tmp >%temp%\$bcd$.tm3
for /f %%j in (%temp%\$bcd$.tm3) do goto _isblank
echo BCD: Erasing CD-RW
set bcd_tmp=
if not "%bcd_spd%" == "" set bcd_tmp=speed=%bcd_spd%
bin\cdrecord.exe dev=%bcd_dev% %bcd_tmp% -v blank=fast
if errorlevel 1 (
	echo BCD: cdrecord returned an error:
	goto _abort)
goto _record
set bcd_tmp=
:_isblank
echo BCD: Media is blank, so we're ready to record.
goto _record
:_iscdr
echo BCD: Media is CD-R, checking blank
bin\cdrecord.exe dev=%bcd_dev% -toc >%temp%\$bcd$.tmp 2>&1
if errorlevel 1 (
	echo BCD: cdrecord returned an error:
	type %temp%\$bcd$.tmp
	goto _abort)
findstr /I "/C:Cannot read TOC header" %temp%\$bcd$.tmp >%temp%\$bcd$.tm3
for /f %%j in (%temp%\$bcd$.tm3) do goto _isblank
echo BCD: Media not blank, insert other media for "%bcd_name%"...
bin\cdrecord.exe dev=%bcd_dev% -eject >nul 2>&1
if errorlevel 1 (
	echo BCD: cdrecord returned an error:
	type %temp%\$bcd$.tmp
	goto _abort)
bin\bchoice /c:ca /d:c Press C or Enter to continue or A to Abort?
if errorlevel 1 goto _end
goto _media

:_record
set bcd_tmp=
if not "%bcd_spd%" == "" set bcd_tmp=speed=%bcd_spd%
echo BCD: Burning CD-Rom (running cdrecord.exe)
echo BCD: Arguments; dev=%bcd_dev% %bcd_tmp% -v %bcd_cdr% %temp%\%bcd_name%.iso
bin\cdrecord.exe dev=%bcd_dev% %bcd_tmp% -v %bcd_cdr% %temp%\%bcd_name%.iso
if errorlevel 1 (
	echo BCD: cdrecord returned an error:
	goto _abort)
set bcd_tmp=
echo BCD: Recording "%bcd_name%" done.
goto _end

:_nomedia
echo BCD: Insert media for "%bcd_name%"...
bin\cdrecord.exe dev=%bcd_dev% -eject >nul 2>&1
if errorlevel 1 (
	echo BCD: cdrecord returned an error:
	type %temp%\$bcd$.tmp
	goto _abort)
bin\bchoice /c:ca /d:c Press C or Enter to continue or A to Abort?
if errorlevel 1 goto _end
goto _media

:_chkdev
if not "%bcd_dev%" == "" goto :eof
if exist %temp%\$bcd$.tm3 del %temp%\$bcd$.tm3
echo BCD: Get drive capabilities for device %bcd_tmp%
bin\cdrecord.exe dev=%bcd_tmp% -prcap > %temp%\$bcd$.tmp 2>&1
if errorlevel 1 goto :eof
if "%bcd_deb%" == "" goto _chkdev1
echo debug: drive capabilities output from device %bcd_tmp%
type %temp%\$bcd$.tmp
echo debug: End of drive capabilities output
echo debug: Looking for "%*"
:_chkdev1
findstr /L "/C:%*" %temp%\$bcd$.tmp >%temp%\$bcd$.tm3
for /f %%j in (%temp%\$bcd$.tm3) do set bcd_dev=%bcd_tmp%
goto :eof
:_bline
if not "%bcd_deb%" == "" echo debug: cmd=[%bcd_cmd%] arg=[%bcd_arg%] err=[%bcd_err%]
if not "%bcd_err%" == "" goto :eof
if /I "%bcd_cmd%" == "bootfile" (
	set bcd_boot=%bcd_arg%
	echo BCD: Bootfile set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "volumeid" (
	set bcd_volid=%bcd_arg%
	echo BCD: Volumeid set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "volumeset" (
	set bcd_vset=%bcd_arg%
	echo BCD: Volumeset set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "preparer" (
	set bcd_prep=%bcd_arg%
	echo BCD: Preparer set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "publisher" (
	set bcd_publ=%bcd_arg%
	echo BCD: Publisher set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "application" (
	set bcd_appid=%bcd_arg%
	echo BCD: Application set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "system" (
	set bcd_sysid=%bcd_arg%
	echo BCD: System set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "mkisofsargs" (
	set bcd_isofs=%bcd_arg%
	echo BCD: Mkisofsargs set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "cdrecordargs" (
	set bcd_cdr=%bcd_arg%
	echo BCD: Cdrecordargs set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "call" (
	set bcd_call=%bcd_arg%
	echo BCD: Call set to "%bcd_arg%"
	goto :eof)
if /I "%bcd_cmd%" == "addpath" (
	set bcd_pth=%bcd_arg%
	echo BCD: Add path set to "%bcd_arg%"
	goto :eof)
echo BCD: unknown keyword "%bcd_cmd%"
set bcd_err=1
goto :eof
:_bldall
echo BCD: Build all bootimages!
set bcd_cnt=0
for /d %%i in (cds\*.*) do call :_ball %%i
echo BCD: %bcd_cnt% boot disk(s) were built.
goto _end
:_ball
if not "%bcd_err%" == "" goto :eof
echo BCD: Processing CD "%1"
rem process bootdisk.cfg file
if not exist %1\bootdisk.cfg goto _bdcfg2
echo BCD: Processing bootdisk config file "%1\bootdisk.cfg"
set rv=
for /f "eol=# tokens=1,2" %%j in (%1\bootdisk.cfg) do call :_bflopo %1 %%j %%k
if not "%bcd_err%" == "" goto _abort
:_bdcfg2
goto :eof
:_bflopo
if "%bcd_err%" == "1" goto :eof
echo BCD: Creating bootimage "%3"
call bfd.cmd %2 -i %1\files\%3 -t 288
if "%rv%" == "1" (
	set bcd_err=1
	goto :eof)
set /a bcd_cnt=%bcd_cnt%+1
goto :eof
:_bflop
if "%bcd_err%" == "1" goto :eof
if exist cds\%bcd_name%\files\%2 goto _biext
echo BCD: Bootimage "%2" does not exist, let's create it now!
call bfd.cmd %1 -i cds\%bcd_name%\files\%2
if "%rv%" == "1" set bcd_err=1
goto :eof
:_biext
echo BCD: Bootimage "%2" already exists, skip creation
goto :eof
:_nodir
echo BCD: CD "%bcd_name%" does not exist...
echo BCD: You must specify one of the following names:
for /d %%i in (cds\*.*) do echo %%~ni
goto _end4
:_usage
echo Usage: bcd [-d] [-b] [-s nn] name
echo        bcd -bab
echo.
echo   name    : name of the CD to build
echo   -a      : build all ISO9660 image files
echo   -d      : print debug messages
echo   -b      : burning disabled (only create ISO image)
echo   -s nn   : set burning speed
echo   -bab    : build all bootimages for all CD's
echo             (using CD's bootdisk.cfg)
echo.
echo Returns environment variable "rv", 0 if succesfull, 1 if error
echo.
echo This program uses the following files (located in the "bin" directory):
echo - Mkisofs and Cdrecord by Joerg Schilling (GNU-GPL license). 
echo - Nero Aspi Library (wnaspi32.dll) by Ahead Software AG (abandonware)
goto _end4
:_4nt
echo BFD: Cannot run with 4NT! Use the normal command interperter (cmd.exe)
goto _abort
:_noext
echo BCD: Unable to enable extensions.
rem flow into _abort
:_abort
if exist %temp%\%bcd_name%.iso (
	echo BCD: Aborting, removing ISO file "%temp%\%bcd_name%.iso"
	del %temp%\%bcd_name%.iso)
echo BCD: Aborted...
echo.
rem set return value to 1
endlocal
set rv=1
pause
goto _end3
:_end
if not exist %temp%\%bcd_name%.iso goto _end2
if not "%bcd_noburn%" == "" (
	echo BCD: Burning disabled, so moving ISO file "%temp%\%bcd_name%.iso" to working directory.
	echo BCD: You can use this ISO file to record with your favorite recording program.
	xcopy %temp%\%bcd_name%.iso %cd%\ /-I /Y /Q /J /Z
	goto _end2)
if exist %temp%\%bcd_name%.iso (
	echo BCD: Removing ISO file "%temp%\%bcd_name%.iso"
	del %temp%\%bcd_name%.iso)
:_end2
rem set return value to 0
endlocal
set rv=0
:_end3
if exist %temp%\$bcd$.tm? del %temp%\$bcd$.tm?
:_end4
echo BCD: Exiting with return value %rv%
