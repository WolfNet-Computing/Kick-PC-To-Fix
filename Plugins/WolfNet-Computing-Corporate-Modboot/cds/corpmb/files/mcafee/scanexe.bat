@echo.
@echo *** Scanning executable files on all local drives
scan.exe /adl /noexpire /report %temp%\scan.txt
@echo Complete scan report is in %temp%\scan.txt
@echo.
@pause