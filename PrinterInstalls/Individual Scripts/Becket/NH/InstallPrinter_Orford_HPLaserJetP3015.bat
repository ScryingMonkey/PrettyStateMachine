:: HP LaserJet P3015 
:: Define variables
	set location=HP LaserJet P3015
	set IP=192.168.123.104
	set port=IP_%IP%
	set driver=unknown
	set path=None
:: Install Port
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r %port% -h %IP% -o raw -n 9100
::take a breath
timeout /t 2 /nobreak
:: Install Printer
rundll32 printui.dll,PrintUIEntry /if /b "%location% - %driver%" /f %path% /r "%port%" /m "%driver%" /Z
timeout /t 2 /nobreak
