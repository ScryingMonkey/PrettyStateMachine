cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_192.168.20.90 -h 192.168.20.90 -o raw -n 9100; 
rundll32 printui.dll,PrintUIEntry /if /b "Agawam - TOSHIBA Universal Printer 2" /f C:\Push\Toshiba\64bit\eSf6u.inf /r "IP_192.168.20.90" /m "TOSHIBA Universal Printer 2" /Z; 

