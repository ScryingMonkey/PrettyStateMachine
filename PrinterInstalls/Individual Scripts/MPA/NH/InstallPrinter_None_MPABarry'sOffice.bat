:: MPA Barry's Office 
:: Define variables
	set location=MPA Barry's Office
	set IP=10.10.2.48
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
