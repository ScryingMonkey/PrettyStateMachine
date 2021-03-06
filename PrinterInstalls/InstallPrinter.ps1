﻿#param must be the first statement in your script
Param(
    [string]$location = $(throw ">> ERROR: Please include a valid location argument.  ex: -location 'Downstairs Copier' "),
    [string]$driver = $(throw ">> ERROR: Please include a valid location driver.  ex: -driver 'PCL6 V4 Driver for Universal Print' "),
    [string]$ip = $(throw ">> ERROR: Please include a valid ip argument.  ex: -ip '10.0.0.99' "),
    [string]$color = "Color",
    [int]$logLevel = 0,
    [string]$pushRoot = "c:\push\printerDrivers"
    )
$DRIVER_URL_MAP = @(
        @{"driver"="HP Universal Printing PCL 6"; "path"="\HP\HPUniversalPCL6\hpcu215u.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/HP.zip"},
        @{"driver"="KONICA MINOLTA 4750 Series PCL6"; "path"="\KonicaMinolta\bizhub4750Series_Win10_PCL_PS_XPS_FAX_v3.1.0.0\Drivers\Win_x64\KOBK1J__.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/KonicaMinolta.zip"},
        @{"driver"="KONICA MINOLTA C3110 PCL6"; "path"="\KonicaMinolta\C3110\bizhubC3110_Win10_PCL_PS_XPS_FAX_v1.2.1.0\bizhubC3110_Win10_PCL_PS_XPS_FAX_v1.2.1.0\Drivers\Win_x64\KOBK4J__.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/KonicaMinolta.zip"},
        @{"driver"="KONICA MINOLTA C3850 Series PCL6"; "path"="\KonicaMinolta\BizhubC3850fs_MFP_Win_x64\PCL\english\KOBJ_J__.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/KonicaMinolta.zip"},
        @{"driver"="KX DRIVER for Universal Printing"; "path"="\Kyocera\KXPrintDriverv7.3.1207\64bit\oemsetup.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/KXPrintDriverv7.3.1207.zip"},
        @{"driver"="Kyocera ECOSYS M2535dn KX"; "path"="\Kyocera\KXPrintDriverv7.3.1207\64bit\oemsetup.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/KXPrintDriverv7.3.1207.zip"},
        @{"driver"="Kyocera TASKalfa 5551ci KX"; "path"="\Kyocera\KyoceraTASKalfa_5551ci\oemsetup.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/KyoceraTASKalfa_5551ci.zip"},
        @{"driver"="Kyocera TASKalfa 4501i"; "path"="\Kyocera\xxx1i_xxx1ci_PCL_Uni\oemsetup.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Kyocera_xxx1i_xxx1ci_PCL_Uni.zip"},
        @{"driver"="Kyocera TASKalfa 3501i"; "path"="\Kyocera\xxx1i_xxx1ci_PCL_Uni\oemsetup.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Kyocera_xxx1i_xxx1ci_PCL_Uni.zip"},
        @{"driver"="Kyocera TASKalfa 3051ci"; "path"="\Kyocera\xxx1i_xxx1ci_PCL_Uni\oemsetup.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Kyocera_xxx1i_xxx1ci_PCL_Uni.zip"},
        @{"driver"="PCL6 V4 Driver for Universal Print"; "path"="\Savin\SavinUniversal\disk1\r4600.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Savin.zip"},
        @{"driver"="Savin Universal Printing PCL6"; "path"="\Savin\SavinUniversal\disk1\r4600.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Savin.zip"},     
        @{"driver"="TOSHIBA Universal Printer 2"; "path"="\Toshiba\64bit\eSf6u.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Toshiba_64bit.zip"},
        @{"driver"="Xerox Global Print Driver PCL6"; "path"="\Xerox\X-GPD_5.404.8.0_PCL6_x64_Driver.inf\x2UNIVX.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Xerox.zip"},
        @{"driver"="Xerox AltaLink B8055 PCL6"; "path"="\Xerox\ALB80XX_5.528.10.0_PCL6_x64_Driver.inf\x2ASNOX.inf"; "url" = "https://s3.amazonaws.com/aait/printerDrivers/Xerox.zip"}
        )

$driverMap = $DRIVER_URL_MAP


#################################
#EXAMPLE $printers array
#$printers = @(
#    @{"location"="Upstairs Copier"; "driverName"="PCL6 V4 Driver for Universal Print"; "ip"="10.0.0.99"; "color"="Color"},
#    @{"location"="Upstairs Copier"; "driverName"="PCL6 V4 Driver for Universal Print"; "ip"="10.0.0.99"; "color"="BW"},
#    @{"location"="Downstairs Copier"; "driverName"="PCL6 V4 Driver for Universal Print"; "ip"="10.0.0.25"; "color"="Color"},
#    @{"location"="Downstairs Copier"; "driverName"="PCL6 V4 Driver for Universal Print"; "ip"="10.0.0.25"; "color"="BW"},
#    @{"location"="HP Laserjet 4350"; "driverName"="HP Universal Printing PCL 6"; "ip"="10.0.0.19"; "color"="Color"},
#    @{"location"="TESTTOSH"; "driverName"="TOSHIBA Universal Printer 2"; "ip"="10.10.10.10"; "color"="Color"}
#    )
#
# Call using the following in cmd:
# > cd c:\path\to\script\
# > powershell.exe .\InstallPrinters.ps1 -logLevel -1 -printerCsv .\Printers_Grossman.csv
#
#################################

function log ($str, $fc="white"){
# fc can be any of these [Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White]
    $fc = $fc.ToLower()
    switch ($fc) {
        "red"      {$priority = 5}
        "yellow"   {$priority = 4}
        "green"    {$priority = 2} 
        "white"    {$priority = 1}
        "gray"     {$priority = 0; $str = "  "+$str;}
        "darkgray" {$priority = -1}
        }
    if ($priority -ge $logLevel) {
        write-host $str -ForegroundColor $fc
        }
    }

function buildPrinter($location, $driver, $ip, $color) {
    log "Calling buildPrinter(`n>>> -location `"$location`"`n>>> -driver $driver`n>>> -ip $ip`n>>> -color $color`n>>> )" "darkgray"
    $p = @{
        name = "$($location.Trim()) ($color) - $($driver.Trim())";
        loc = $location.Trim();
        driver = $driver.Trim();
        ip = $ip.Trim();
        color = $color.Trim();
    }
    log "...returning printer: [$($p.name)] $p" "gray"
    return $p
}

function convertDriverMap($pushRoot, $driverMap) {
# adds full driver path to driverMap.driverPath
    log "Calling convertDriverMap(`n>>> -pushRoot `"$pushRoot`"`n>>> -driverMap $driverMap`n>>> )" "darkgray"
    $newDriverMap = $driverMap.Clone()
    log "Converting ($($newDriverMap.Length)) driver paths" "Gray"
    foreach ($n in (0..($newDriverMap.Length-1))) {
        $newDriverMap[$n].path = $pushRoot+$driverMap[$n].path
        #log "...($n) Converted driver path for driver [$($newDriverMap[$n].driver)] to [$($newDriverMap[$n].path)]" "gray"
    }
    log "...returning newDriverMap: $newDriverMap" "gray"
    return $newDriverMap
}

function getDriverInfo($driverName, $driverMap) {
    log "Calling getDriverInfo(`n>>> -driverName $driverName`n>>> -driverUrlMap $driverUrlMap`n>>> )" "darkgray"
    $driver = @{}
    log "...Evaluating [$($driverName)]" "Gray"
    foreach ($d in $driverMap) {
        if ($d.driver -eq $driverName) {
            $driver = $d
            }
        }
    if (($driver.driver).length -gt 0) { 
            log "...Located [$driverName == $($driver.driver)] in driverUrlMap." "Gray"
            return $driver
        } else {
            log "...Failed to locate [$driverName] in driverMap." "Red"
            log "...driver = $driver"
            return $false
            }
}

function downloadZip($driverUrl, $downloadPath) {
    log " Calling downloadZip(`n>>> -driverUrl $driverUrl`n>>> -downloadPath $downloadPath`n>>> )" "darkgray"
    try {
        $wc = New-Object System.Net.WebClient
        $wc.DownloadFile($driverUrl, $downloadPath)
    } catch [System.Management.Automation.MethodInvocationException] {
        log ">> CAUGHT ERROR: <MethodInvocationException> Cannot access url [$driverUrl] ..." "Yellow"
        log ">> CAUGHT ERROR: $PSItem" "Yellow"
        return $false
    } catch {
        log "E!"
        log ">> UNCAUGHT ERROR: $PSItem" "red"
        log ">> UNCAUGHT ERROR: $($Error[0].Exception.GetType().fullname)" "red"
        return $false
        }
    return $true
}

function Unzip ($downloadPath, $extractPath) {
    log "Calling Unzip(`n>>> -downloadPath $downloadPath`n>>> -extractPath $extractPath`n>>> )" "darkgray"
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem;
        [System.IO.Compression.ZipFile]::ExtractToDirectory($downloadPath, $extractPath);
    } catch [System.Management.Automation.MethodInvocationException] {
        log ">> CAUGHT ERROR: <MethodInvocationException> Cannot locate path [$downloadPath] ..." "Yellow"
        log ">> CAUGHT ERROR: $PSItem" "Yellow"
        return $false
    } catch {
        log "E!"
        log ">> UNCAUGHT ERROR: $PSItem" "red"
        log ">> UNCAUGHT ERROR: $($Error[0].Exception.GetType().fullname)" "red"
        return $false
        }
    return $true
}

function isPrinterInstalled($name, $ip, $driver) {
    log "Calling isPrinterInstalled(`n>>> -name $name`n>>> -ip $ip`n>>> -driver $driver`n>>> )" "darkgray"
    $port = "IP_" + $ip;
    Get-Printer | foreach {
        if (($_.Name -eq $name) -and ($_.PortName -eq $port) -and ($_.DriverName -eq $driver)) { 
            $res = $true;
        } else {
            $res = $false;
            }
        }
    if ($res) {
        log "...Found printer [$name -and $port -and $driver]." "White"
    } else {
        log "...Did not find printer [$name -and $port -and $driver]." "Gray"
    }
    return $res
}

function waitForPrinterInstallToComplete($printerName) {
    log "Calling waitForPrinterInstallToComplete(`n>>> -printerName $printerName`n>>> )" "darkgray"
    $count = 0
    $chances = 12
    log "...Waiting for install of [$printerName]" "Gray"
    Do {
        try{
            log "..." "Gray"
            if (((get-printer $printerName -ErrorAction Stop).Name).Length -gt 0) {
                log "...[$printerName] successfully installed."
                return $true
            }
        } catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
            log "...Printer not found.  Continuing to wait..." "gray"
        } catch {
            log ">> UNCAUGHT ERROR: $PSItem" "red"
            log ">> UNCAUGHT ERROR: $($Error[0].Exception.GetType().fullname)" "red"
        } finally {
            Start-Sleep -Seconds 5
            $count += 1
            }
        } While ($count -lt $chances) {
            log "...Timed out after $($count*$chances) seconds.  Failed to install [$printerName]." "Red"
        }
    return $false
    }

function installPrinter($name, $loc, $ip, $driver, $driverPath) {
    log "Calling installPrinter(`n>>> -name $name`n>>> -loc $loc`n>>> -ip $ip`n>>> -driver $driver`n>>> -driverPath $driverPath`n>>> )" "darkgray"
    
    $port = "IP_" + $ip    
    log "...Creating port [$port] at ip [$ip]." "Gray"
    cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r $port -h $ip -o raw -n 9100

    try {
        log "...Installing printer [$name] with driver [$driver]" "gray"
        log "...from inf file [$driverPath]." "gray"
        rundll32 printui.dll,PrintUIEntry /if /b $name /f $driverPath /r $port /m $driver /Z
    } catch [System.Management.Automation.MethodInvocationException] {
        log ">> CAUGHT ERROR: Could not install [$driver] from: [$driverPath]" "red"
    } catch {
        log ">> UNCAUGHT ERROR: $PSItem" "red"
        log ">> UNCAUGHT ERROR: $($Error[0].Exception.GetType().fullname)" "red"
    }
    return $true
    }

function waitForPrinterRemovalToComplete($printerName) {
    log "Calling waitForPrinterRemovalToComplete(`n>>> -printerName $printerName`n>>> )" "darkgray"
    $count = 0
    $chances = 12
    log "...Waiting for removal of [$printerName]" "Gray"
    While ($count -lt $chances) {
        try{
            ((get-printer $printerName -ErrorAction Stop).Name).Length -gt 0

            log "..." "Gray"
            if ((((get-printer $printerName -ErrorAction Stop).Name).Length -gt 0)) {
                log "...Printer still exists.  Continuing to wait..." "gray"    
            } else {
                log "...[$printerName] successfully removed."
                return $true
            }
            Start-Sleep -Seconds 5
        } catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
            log "...Printer not found.  Continuing..." "gray"
            return $true
        } catch {
            log ">> UNCAUGHT ERROR: $PSItem" "red"
            log ">> UNCAUGHT ERROR: $($Error[0].Exception.GetType().fullname)" "red"
        } finally {
            $count += 1
            }
        }
    log "...Timed out after $($count*$chances) seconds.  Failed to remove [$printerName]." "Red"
    return $false
    }

function removePrinter($name) {
    log "Calling removePrinter(`n>>> -name `"$name`"`n>>> )" "darkgray"
    try {
        log "...removing printer [$name]" "gray"
        if ($name.Length -gt 0) {
            rundll32 printui.dll,PrintUIEntry /dl /n $name /q
            remove-printer -Name "$name*" -ErrorAction Stop
        } else {
            log ">> ERROR: `$name arg is blank.  [$name]" "red"
            return $false
        }
    } catch [Microsoft.PowerShell.Cmdletization.Cim.CimJobException] {
        log "...no printer matching name [$name*].  Continuing..." "gray"
        return $true
    } catch {
        log ">> UNCAUGHT ERROR: $PSItem" "red"
        log ">> UNCAUGHT ERROR: $($Error[0].Exception.GetType().fullname)" "red"
    }
    if(waitForPrinterRemovalToComplete $name) {
        return $true
    } else {
        return $false
        }
    }

function setPrinterColor($printerName, $color) {
    log "Calling setPrinterColor(`n>>> -printerName $printerName`n>>> -color $color`n>>> )" "darkgray"
    if ($color -eq "Color") {
        $b = $true
    } elseif ($color -eq "BW") {
        $b = $false
    } else {
        log "[ERROR: Invalid color input [$color] for printer $printerName]" "Red"
        }
    try {
        Set-PrintConfiguration -PrinterName $printerName -Color $b -ErrorAction Stop
        log "...Set `"$printerName`" to [$color]" "Gray"
    } catch [Microsoft.Management.Infrastructure.CimException] {
        log ">> CAUGHT ERROR: <CimException> Failed to configure printer color settings..." "Yellow"
        return $false
    } catch {
        log ">> UNCAUGHT ERROR: $PSItem" "red"
        log ">> UNCAUGHT ERROR: $($Error[0].Exception.GetType().fullname)" "red"
        return $false
        }
    return $true
    }

function downloadAndInstallPrinter($driverUrl, $downloadPath, $extractPath, $printer, $driverPath) {
    log "Calling downloadAndInstallPrinter( `n>>> -driverUrl $driverUrl`n>>> -downloadPath $downloadPath`n>>> -extractPath $extractPath`n>>> -printer $printer`n>>> -driverPath $driverPath`n>>> )" "darkgray"
    #install driver
    if (Test-Path $driverPath) {
        log "...Path [$driverPath] already exists.  Doing nothing." "gray"
    } else {
        log "...Path [$driverPath] does not exist.  Downloading and installing..." "gray"
        if (!(downloadZip $driverUrl $downloadPath)){
            log ">> FAIL: Could not download [$driverUrl]" "red"
            return $false
            }
        log "...Time taken for download: $((Get-Date).Subtract($start_time).Seconds) second(s)" "Gray"
        if(!(Unzip $downloadPath $extractPath)) {
            log ">> FAIL: Could not extract [$downloadPath]" "red"
            return $false
            }
        log "...Time taken for extraction: $((Get-Date).Subtract($start_time).Seconds) second(s)" "Gray"
        }
    #install printer
    if (isPrinterInstalled -name $printer.name -ip $printer.ip -driver $printer.driver) {
        log "...Printer already installed [$($printer.location)].  Doing nothing." "gray"
    } else {
        log "...Removing any duplicate printers of name [$($printer.name)]" "gray"
        if (!(removePrinter($printer.name))){
            log ">> WARNING: Could not remove duplicate printer [$($printer.name)]" "yellow"
        }
        if (!(installPrinter $printer.name $printer.location $printer.ip $printer.driver $driverPath)){
            log ">> FAIL: Could not install printer [$($printer.name)]" "red"
            return $false
            }
        waitForPrinterInstallToComplete $printer.name
        log "...Setting printer [$($printer.name)] color settings to [$($printer.color)]" "Gray"
        if (!(setPrinterColor $printer.name $printer.color)) {
            log ">> FAIL: Could not configure printer color settings for [$($printer.name)]." "red"
            return $false
            }
        }
    return $true
}

function main($pushRoot, $location, $driver, $ip, $color, $driverMap=$DRIVER_URL_MAP) {
    $start_time = Get-Date
    log "Calling main(`n>>> -pushRoot=$pushRoot`n>>> -location=$location`n>>> -driver=$driver`n>>> -ip=$ip`n>>> -color=$color`n>>> -driverMap=$driverMap`n>>> )" "darkgray"
    log "Starting [$(Get-Date)]" "white"
    $printerInstalledTally = 0
    $n = 1
    $downloadPath = "$pushRoot\printerTemp.zip"
    $extractPath = $pushRoot
    if(!(Test-Path $pushRoot)) { mkdir $pushRoot; }
    $p = buildPrinter $location $driver $ip $color
    $driverMap = convertDriverMap $pushRoot $driverMap

    log "($n) Installing printer [$($p.name)]" "white"
    $driver = (getDriverInfo $($p.driver) $driverMap)
    if ($driver) {
        $res = downloadAndInstallPrinter -driverUrl $driver.url -downloadPath $downloadPath -extractPath $extractPath -printer $p -driverPath $driver.path
    } else {          
        $res = $false
    }
    if($res){
        $rcolor = "white"
    } else {
        $rcolor = "Red"
        }
    log "...Is [ $($p.location) ($($p.color)) - $($p.driver) ] installed?: $res" $rcolor
    log "...Time taken for printer install [$($p.name)]: $((Get-Date).Subtract($start_time).TotalSeconds) second(s)" "gray"

    $delta = $((Get-Date).Subtract($start_time))
    $secondsElapsed = 0+(($delta.Minutes)*60)+($delta.Seconds)
    log "Stopping [$(Get-Date)]" "white"
    log "---------------------------------------------------------" "Gray"
    log "|"
    log "|   Successfully installed $($p.name) printer in $secondsElapsed seconds." "Green"
    log "|"
    log "---------------------------------------------------------" "Gray"
    }

clear
main $pushRoot $location $driver $ip $color $driverMap
#timeout /t -1