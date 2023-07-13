@echo.
@echo *** Scanning/cleaning *all* files on all local drives
scan.exe /clean /adl /all /noexpire /report %temp%\scan.txt
@echo Complete scan report is in %temp%\scan.txt
@echo.
@pause
