rundll32 printui.dll,PrintUIEntry /dl /n "Plainfield Clinical - TOSHIBA Universal Printer 2" /q
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_10.10.20.27 -h 10.10.20.27 -o raw -n 9100
rundll32 printui.dll,PrintUIEntry /if /b "Plainfield Clinical - TOSHIBA Universal Printer 2" /f C:\Push\Toshiba\64bit\eSf6u.inf /r "IP_10.10.20.27" /m "TOSHIBA Universal Printer 2" /Z