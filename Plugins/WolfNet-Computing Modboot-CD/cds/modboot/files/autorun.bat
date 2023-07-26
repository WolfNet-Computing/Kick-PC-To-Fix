@echo on
rem Process levels
echo @echo off> %tmp%\_modboot.bat
rem if not exist %srcdrv%\level0\*.cab goto _no0
for %%i in (%cddrv%\level0\*.cab) do call bin\modboot.bat : _unpack %%i
for %%i in (%cddrv%\level1\*.cab %cddrv%\level2\*.cab %cddrv%\level3\*.cab) do call bin\modboot.bat : _unpack %%i -x
:_no0
rem if not exist %cddrv%\level1\*.cab goto _no1
rem for %%i in (%cddrv%\level1\*.cab) do call %cddrv%\bin\modboot.bat : _unpack %%i -x
rem :_no1
rem if not exist %cddrv%\level2\*.cab goto _no2
rem for %%i in (%cddrv%\level2\*.cab) do call %cddrv%\bin\modboot.bat : _unpack %%i -x
rem :_no2
rem if not exist %cddrv%\level3\*.cab goto _no3
rem for %%i in (%cddrv%\level3\*.cab) do call %cddrv%\bin\modboot.bat : _unpack %%i -x
rem :_no3
echo goto _end>> %tmp%\_modboot.bat
echo :_shift>> %tmp%\_modboot.bat
echo echo MODBOOT: Exiting (shift pressed)...>> %tmp%\_modboot.bat
echo goto _end>> %tmp%\_modboot.bat
echo :_abort>> %tmp%\_modboot.bat
echo echo.>> %tmp%\_modboot.bat
echo echo MODBOOT: Aborted...>> %tmp%\_modboot.bat
echo echo.>> %tmp%\_modboot.bat
echo pause>> %tmp%\_modboot.bat
echo :_end>> %tmp%\_modboot.bat
echo set path=%path%;%cddrv%\bin;%cddrv%\>> %tmp%\_modboot.bat
call %tmp%\_modboot.bat
if exist %tmp%\_modboot.bat del %tmp%\_modboot.bat
:_eof