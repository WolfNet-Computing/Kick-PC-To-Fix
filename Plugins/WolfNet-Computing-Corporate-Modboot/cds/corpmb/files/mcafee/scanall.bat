@echo.
@echo *** Scanning *all* files on all local drives
scan.exe /adl /all /noexpire /report %temp%\scan.txt
@echo Complete scan report is in %temp%\scan.txt
@echo.
@pause
