@echo off
set prompt=$p$g
echo ModBoot - %~nx0, http://wolfnet-computing.com
echo Copyright (c) 2022 WolfNet Computing. All rights reserved.
echo.
if not exist \bin\smartdrv.exe goto _nosdrv
echo AUTOEXEC: Loading high smartdrv.exe
lh \bin\smartdrv.exe
:_nosdrv
if not exist \bin\fdcache.exe goto _nofdc
echo AUTOEXEC: Loading fdcache.exe
\bin\fdcache.exe
:_nofdc
rem Detect the source drive
set srcdrv=
if not exist \bin\bootdrv.com goto _nobdrv
\bin\bootdrv.com
rem bennylevel check? No! I think not supported by freedos
if errorlevel 0 set srcdrv=a:
if errorlevel 1 set srcdrv=b:
if errorlevel 2 set srcdrv=c:
if errorlevel 3 set srcdrv=d:
if errorlevel 4 set srcdrv=e:
if errorlevel 5 set srcdrv=f:
if errorlevel 6 set srcdrv=g:
if errorlevel 7 set srcdrv=h:
if errorlevel 8 set srcdrv=i:
if errorlevel 9 set srcdrv=j:
:_nobdrv
rem if empty assume "a:"
if "%srcdrv%" == "" set srcdrv=a:
echo AUTOEXEC: Booted drive is %srcdrv%
if exist \kernel.sys set os=fd
if not exist %srcdrv%\bin\extract.exe goto _abort
:_goram
rem The ramdisk drive
set ramdrv=q:
if exist %srcdrv%\diskid.txt type diskid.txt
rem
path=%srcdrv%\bin;%srcdrv%\
rem
if "%config%" == "CLEAN" goto _end
if "%config%" == "3" goto _end
rem
rem check if himem is loaded
if exist XMSXXXX0 goto _xmsok
echo.
echo AUTOEXEC: No XMS manager installed (himem.sys)
goto _abort
:_xmsok
rem check if extract.exe exists
if exist %srcdrv%\bin\extract.exe goto _extracok
echo.
echo AUTOEXEC: Missing file "%srcdrv%\bin\extract.exe"
goto _abort
:_extracok
rem Setup the ramdisk
if exist %ramdrv%\bin\extract.exe goto _skipcp
rem load a 8MB ramdisk
echo AUTOEXEC: Setting up Ramdisk at drive %ramdrv%
xmsdsk 16384 %ramdrv% /y /t
if errorlevel 1 goto _ramok
rem xmsdsk returns errorlevel 0 for error
goto _abort
:_ramok
rem
md %ramdrv%\bin
md %ramdrv%\tmp
set temp=%ramdrv%\tmp
set tmp=%ramdrv%\tmp
rem
if exist %ramdrv%\bin\extract.exe goto _skipcp
echo AUTOEXEC: Copying some files to ramdisk
rem copy command.com to ramdisk
copy %srcdrv%\command.com %ramdrv%\bin
if not exist %ramdrv%\bin\command.com goto _abort
set comspec=%ramdrv%\bin\command.com
copy %srcdrv%\bin\extract.exe %ramdrv%\bin
if not exist %ramdrv%\bin\extract.exe goto _abort
:_skipcp
set path=%ramdrv%\bin;%ramdrv%\
rem check for smartdrv.cab
if not exist %srcdrv%\bin\smartdrv.cab goto _nosdrv2
echo AUTOEXEC: Loading high smartdrv.exe from smartdrv.cab
rem extract /y /l %ramdrv%\ /e %srcdrv%\bin\smartdrv.cab > %tmp%\extract.out
extract /y /l %ramdrv%\ /e %srcdrv%\bin\smartdrv.cab
if errorlevel 1 goto _unpackerr
rem should be here
if exist %ramdrv%\bin\smartdrv.exe lh %ramdrv%\bin\smartdrv.exe
rem maybe some people put it here
if exist %ramdrv%\smartdrv.exe lh %ramdrv%\smartdrv.exe
:_nosdrv2
rem check if modboot.cab exists
if exist %srcdrv%\bin\modboot.cab goto _modbcabok
echo.
echo AUTOEXEC: Missing file "%srcdrv%\bin\modboot.cab"
goto _abort
:_modbcabok
extract /y /l %ramdrv%\ /e %srcdrv%\bin\modboot.cab > %tmp%\extract.out
if errorlevel 1 goto _unpackerr
if exist %tmp%\extract.out del %tmp%\extract.out
if exist %ramdrv%\bin\modboot.bat goto _modboot
echo.
echo AUTOEXEC: Missing file "%ramdrv%\bin\modboot.bat"
goto _abort
:_unpackerr
if exist %tmp%\extract.out type %tmp%\extract.out
if exist %tmp%\extract.out del %tmp%\extract.out
echo.
echo AUTOEXEC: Error while unpacking "%srcdrv%\bin\modboot.cab"
goto _abort
:_modboot
rem set CWD to ramdisk
%ramdrv%
cd \
%ramdrv%\bin\modboot.bat
rem should not get here
:_abort
echo AUTOEXEC: Aborted...
echo.
pause
rem flow into "_end"
:_end
