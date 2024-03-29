@echo off
if "%1" == "" goto _usage
set run_file=
if "%run_file%" == "" if exist %1 set run_file=%1
if "%run_file%" == "" if exist %1.cab set run_file=%1.cab
if "%run_file%" == "" if exist %cddrv%\lib\%1 set run_file=%cddrv%\lib\%1
if "%run_file%" == "" if exist %cddrv%\lib\%1.cab set run_file=%cddrv%\lib\%1.cab
if "%run_file%" == "" if exist %cddrv%\level1\%1 set run_file=%cddrv%\level1\%1
if "%run_file%" == "" if exist %cddrv%\level1\%1.cab set run_file=%cddrv%\level1\%1.cab
if "%run_file%" == "" if exist %cddrv%\level2\%1 set run_file=%cddrv%\level2\%1
if "%run_file%" == "" if exist %cddrv%\level2\%1.cab set run_file=%cddrv%\level2\%1.cab
if "%run_file%" == "" if exist %cddrv%\level3\%1 set run_file=%cddrv%\level3\%1
if "%run_file%" == "" if exist %cddrv%\level3\%1.cab set run_file=%cddrv%\level3\%1.cab
if not "%run_file%" == "" goto _unpack
echo RUN: "%1" not found in curdir, %cddrv%\level[123] or %cddrv%\lib
goto _end
:_usage
echo RUN: Missing first parameter (module name)
echo RUN: Listing available modules...
for %%i in (*.cab %cddrv%\lib\*.cab %cddrv%\level1\*.cab %cddrv%\level2\*.cab %cddrv%\level3\*.cab) do echo %%i
goto _end
:_unpack
call unpack %run_file% -x %2 %3 %4 %5 %6 %7 %8 %9
:_end
set run_file=
