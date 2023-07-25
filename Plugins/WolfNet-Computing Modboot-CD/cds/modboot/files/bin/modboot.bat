@echo off
:_unpack
echo kbfl>> %tmp%\_modboot.bat
echo if errorlevel 1 goto _shift>> %tmp%\_modboot.bat
echo call %cddrv%\bin\unpack.bat %3 %4>> %tmp%\_modboot.bat
echo if not "%%unpackerr%%" == "" goto _abort>> %tmp%\_modboot.bat
goto _eof

:_shift
echo MODBOOT: Exiting (shift pressed)...
goto _end
:_abort
echo.
echo MODBOOT: Aborted...
echo.
pause
rem flow into "_end"
:_end
if exist %tmp%\_modboot.bat del %tmp%\_modboot.bat
:_eof
