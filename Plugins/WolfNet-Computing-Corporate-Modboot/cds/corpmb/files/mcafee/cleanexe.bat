@echo.
@echo *** Scanning executable files on all local drives
scan.exe /clean /adl /noexpire /report %temp%\scan.txt
@echo Complete scan report is in %temp%\scan.txt
@echo.
@pause
