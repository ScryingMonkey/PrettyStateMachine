:: Burlington
:: Define variables
	set location=Burlington
	set IP=192.168.164.60
	set port=IP_192.168.164.60
	set driver=TOSHIBA Universal Printer 2
	set path=C:\Push\Toshiba\64bit\eSf6u.inf
:: Install Port
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_192.168.164.60 -h 192.168.164.60 -o raw -n 9100
:: Install Printer
rundll32 printui.dll,PrintUIEntry /if /b "Burlington - TOSHIBA Universal Printer 2" /f C:\Push\Toshiba\64bit\eSf6u.inf /r "IP_192.168.164.60" /m "TOSHIBA Universal Printer 2" /Z
