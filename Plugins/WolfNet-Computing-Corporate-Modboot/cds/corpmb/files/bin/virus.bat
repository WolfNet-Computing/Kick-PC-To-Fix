@echo off
rem -------------------------------------------------------------------------
rem VIRUS, VirusScanner frontend 1.0
rem Copyright (c) 2002 Bart Lagerweij. All rights reserved.
rem This program is free software. Use and/or distribute it under the terms
rem of the NU2 License (see nu2lic.txt or http://www.nu2.nu/license/).
rem -------------------------------------------------------------------------
if not exist %tmp%\scan.txt goto _norpt
if exist %tmp%\scan.bak del %tmp%\scan.bak
ren %tmp%\scan.txt scan.bak
:_norpt
echo :w_opt "Select Virus Scanner">%tmp%\_virus.tmp
if not exist %cddrv%\mcafee\scan.exe goto _nmcaf
echo.>>%tmp%\_virus.tmp
echo  [ McAfee ]  McAfee VirusScan>>%tmp%\_virus.tmp
:_nmcaf
if not exist %cddrv%\f-prot\f-prot.exe goto _nfpr
echo.>>%tmp%\_virus.tmp
echo  [ F-Prot ]  F-Prot Antivirus for DOS>>%tmp%\_virus.tmp
:_nfpr
if not exist %cddrv%\nav\navdx.exe goto _nnav
echo.>>%tmp%\_virus.tmp
echo  [ Nav ]  Norton AntiVirus>>%tmp%\_virus.tmp
:_nnav
if not exist %cddrv%\pccillin\pcscan.exe goto _npcs
echo.>>%tmp%\_virus.tmp
echo  [ PcScan ]  TrendMicro PCcillin>>%tmp%\_virus.tmp
:_npcs

type %tmp%\_virus.tmp | lmod /L5 set wbat=[$1]> %tmp%\_virus.bat
set wbat=
call %tmp%\_virus.bat
if not "%wbat%" == "" goto _virlist
type %tmp%\_virus.tmp | lmod /L3 set wbat=[$2]> %tmp%\_virus.bat
call %tmp%\_virus.bat
echo VIRUS: Only one scan engine found (%wbat%), no need for user to select...
goto _virsel
:_virlist
call w.bat box @%tmp%\_virus.tmp:w_opt
if errorlevel 100 goto _end
:_virsel
if "%wbat%" == "McAfee" goto _mcafee
if "%wbat%" == "F-Prot" goto _fprot
if "%wbat%" == "Nav" goto _nav
if "%wbat%" == "PcScan" goto _pcscan
call w box @%0:w_err
goto _end

:_mcafee
echo :w_opt "McAfee VirusScan Settings">%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
echo  Drives / Folders to Scan :>>%tmp%\_virus.tmp
echo  [$ v_path,99,U                                        ]>>%tmp%\_virus.tmp
echo  Use space as Separator, wildcards are allowed>>%tmp%\_virus.tmp
echo  Leave empty to scan all local drives>>%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
echo  Ú When a virus is found Ä¿  Ú Options ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿>>%tmp%\_virus.tmp
echo  ³  [.] Auto Clean        ³  ³  [!] Scan zip files    ³>>%tmp%\_virus.tmp
echo  ³  [.] Auto Delete       ³  ³  [!] Scan non EXE/DOC  ³>>%tmp%\_virus.tmp
echo  ³  [.] Do nothing        ³  ³  [!] View Report       ³>>%tmp%\_virus.tmp
echo  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ>>%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
if not exist %cddrv%\ntfspro\ntfspro.exe goto _nntfs1
echo  [!]  Also scan NTFS filesystems>>%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
:_nntfs1
echo                                 [ Start ]   [? Cancel ]>>%tmp%\_virus.tmp
for %%i in (wcb1 wcb2 wcb4) do set %%i=
for %%i in (wcb3 wrb) do set %%i=1 
call w.bat box @%tmp%\_virus.tmp:w_opt
if errorlevel 2 goto _end
set v_opt=/noexpire /sub
if "%wrb%" == "1" set v_opt=/clean %v_opt%
if "%wrb%" == "2" set v_opt=/del %v_opt%
if "%wcb1%" == "1" set v_opt=/unzip %v_opt%
if "%wcb2%" == "1" set v_opt=/all %v_opt%
if "%wcb3%" == "1" set v_opt=/report %tmp%\scan.txt %v_opt%
if "%v_path%" == "" set v_opt=/adl %v_opt%
if not "%v_path%" == "" set v_opt=%v_path% %v_opt%
echo.
echo VIRUS: Copying Mcafee files to %temp%
copy %cddrv%\mcafee\scan.exe %tmp%
copy %cddrv%\mcafee\scanpm.exe %tmp%
copy %cddrv%\mcafee\scan.dat %tmp%
copy %cddrv%\mcafee\names.dat %tmp%
copy %cddrv%\mcafee\messages.dat %tmp%
copy %cddrv%\mcafee\license.dat %tmp%
copy %cddrv%\mcafee\clean.dat %tmp%
echo.
if not "%wcb4%" == "1" goto _nontfs1
call %cddrv%\bin\whatnt.bat
if "%wbat%" == "" goto _end
%cddrv%
cd \ntfspro
echo VIRUS: Running ntfspro.exe /P%cddrv%\ntfspro\%wbat% "/S%tmp%\scanpm.exe %v_opt%"
ntfspro.exe /P%cddrv%\ntfspro\%wbat% "/S%tmp%\scanpm.exe %v_opt%"
goto _next1
:_nontfs1
if "%wcb4%" == "1" goto _next1
echo VIRUS: Running %tmp%\scan.exe %v_opt%
echo.
%tmp%\scan.exe %v_opt%
:_next1
del %tmp%\*.exe
del %tmp%\*.dat
:_log1
if not "%wcb3%" == "1" goto _end
if exist %tmp%\scan.txt %cddrv%\bin\show.com %tmp%\scan.txt
goto _end
:_fprot
echo :w_opt "F-Prot Virus Scanning Settings">%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
echo  Drives / Folders to Scan :>>%tmp%\_virus.tmp
echo  [$ v_path,99,U                                        ] >>%tmp%\_virus.tmp
echo  Use space as Separator, wildcards are allowed>>%tmp%\_virus.tmp
echo  Leave empty to scan all local drives>>%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
echo  Ú Default Action ÄÄÄÄÄÄÄÄ¿  Ú Options ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿>>%tmp%\_virus.tmp
echo  ³  [.] Try to Disinfect  ³  ³  [!] Automatic Action  ³>>%tmp%\_virus.tmp
echo  ³  [.] Rename to VXE/VOM ³  ³  [!] Scan non EXE/DOC  ³>>%tmp%\_virus.tmp
echo  ³  [.] Delete infected   ³  ³  [!] View Report       ³>>%tmp%\_virus.tmp
echo  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ>>%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
if not exist %cddrv%\ntfspro\ntfspro.exe goto _nntfs2
echo  [!]  Also scan NTFS filesystems>>%tmp%\_virus.tmp
echo.>>%tmp%\_virus.tmp
:_nntfs2
echo                                 [ Start ]   [? Cancel ]>>%tmp%\_virus.tmp
for %%i in (wcb1 wcb2 wcb4) do set %%i=
for %%i in (wcb3 wrb) do set %%i=1 
call w.bat box @%tmp%\_virus.tmp:w_opt
if errorlevel 2 goto _end
set v_opt=/old /wrap
if "%wrb%" == "1" set v_opt=/disinf %v_opt%
if "%wrb%" == "2" set v_opt=/rename %v_opt%
if "%wrb%" == "3" set v_opt=/delete %v_opt%
if "%wcb1%" == "1" set v_opt=/auto %v_opt%
if "%wcb2%" == "1" set v_opt=/dumb %v_opt%
if "%v_path%" == "" set v_opt=/hard %v_opt%
if not "%v_path%" == "" set v_opt=%v_path% %v_opt%
echo.
if not "%wcb4%" == "1" goto _nontfs2
call %cddrv%\bin\whatnt.bat
if "%wbat%" == "" goto _end
%cddrv%
cd \ntfspro
echo VIRUS: Running ntfspro.exe /P%cddrv%\ntfspro\%wbat% "/S%cddrv%\f-prot\f-prot.exe %v_opt%"
if "%wcb3%" == "1" ntfspro.exe /P%cddrv%\ntfspro\%wbat% "/S%cddrv%\f-prot\f-prot.exe /report=%tmp%\scan.txt %v_opt%"
if not "%wcb3%" == "1" ntfspro.exe /P%cddrv%\ntfspro\%wbat% "/S%cddrv%\f-prot\f-prot.exe %v_opt%"
goto _next2
:_nontfs2
if "%wcb4%" == "1" goto _next2
echo VIRUS: Running %cddrv%\f-prot\f-prot.exe %v_opt%
if "%wcb3%" == "1" %cddrv%\f-prot\f-prot.exe /report=%tmp%\scan.txt %v_opt%
if not "%wcb3%" == "1" %cddrv%\f-prot\f-prot.exe %v_opt%
:_next2
goto _log1

:w_err "No Antivirus software found!"

No antivirus software found on
the default locations on the CD.

See the documentation on the
website how to include your
current antivirus or how to
download and install the free
F-PROT engine.

             [ OK ]
::
:_abort
echo.
echo VIRUS: aborted...
echo.
pause
rem flow into "_end"
:_end
if exist %tmp%\_virus.* del %tmp%\_virus.*
for %%i in (wcb1 wcb2 wcb3 wcb4 wrb) do set %%i=
set v_opt=
set w_drv=
