#### Screenfetch for powershell
#### Author Julian Chow

Add-Type -AssemblyName System.Windows.Forms
####### Globals #######
$global:Hackcounter = 0;

####### Functions ########
Function Get-PrimaryResolution{ Param ($monitorArray)
    foreach ($monitor in $monitorArray){
        if($monitor.Primary){       
            $primaryResolution = [System.Tuple]::Create($monitor.Bounds.Width, $monitor.Bounds.Height);
            return $primaryResolution;
        }
    }
}

Function DiskDataBuilder ($id, $name, $freespace, $totalspace){
    ## Disk Information
    # Available Space
    $FreeDiskSize = $freespace
    $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
    $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;
    # Total Space
    $DiskSize = $totalspace
    $DiskSizeGB = $DiskSize / 1073741824;
    $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;
    $FreeDiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
    $FreeDiskPercent = "{0:N0}" -f $FreeDiskPercent;
    # Used Space
    $UsedDiskSizeGB = $DiskSizeGB - $FreeDiskSizeGB;
    $UsedDiskPercent = ($UsedDiskSizeGB / $DiskSizeGB) * 100;
    $UsedDiskPercent = "{0:N0}" -f $UsedDiskPercent;

    If (-not $name){
        $name = "NO NAME";
    }


    If ($global:Hackcounter -eq 0){
        Write-Host "'''':::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
        Write-Host "Disk: " -f Red -NoNewline;
    }
    Elseif ($global:Hackcounter -eq 1){
        Write-Host "        '''':::: ::::::::::::::::             " -f Cyan -NoNewline;
    }
    Elseif ($global:Hackcounter -eq 2){
        Write-Host "                 ''''::::::::::::             " -f Cyan -NoNewline;
    }
    Elseif ($global:Hackcounter -eq 3){
        Write-Host "                         ''''::::             " -f Cyan -NoNewline;
    }
    Else{
        Write-Host "                                              " -NoNewline;
    }

    $global:Hackcounter++;

    Write-Host $id $name " "-NoNewline;
    Write-Host $UsedDiskSizeGB"GB" " / " $DiskSizeGB"GB" -NoNewline;
    Write-Host " (" -NoNewline;
    Write-Host $UsedDiskPercent"%" -f Green -NoNewline;
    Write-Host ")";
}

####### Information Collection #########

## Resolution Information
$PrimaryResolution = Get-PrimaryResolution([System.Windows.Forms.Screen]::AllScreens);
$Horizontal = $PrimaryResolution.Item1;
$Vertical = $PrimaryResolution.Item2;

## Uptime Information
$uptime = ((gwmi Win32_OperatingSystem).ConvertToDateTime((gwmi Win32_OperatingSystem).LocalDateTime) - 
           (gwmi Win32_OperatingSystem).ConvertToDateTime((gwmi Win32_OperatingSystem).LastBootUpTime));

## Environment Information
$Username = $env:username;
$Machine = (gwmi Win32_OperatingSystem).CSName;
$OS = (gwmi Win32_OperatingSystem).Caption;
$BitVer = (gwmi Win32_OperatingSystem).OSArchitecture;
$Kernel = (gwmi Win32_OperatingSystem).Version;

## Hardware Information
$Motherboard = Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer, Product;
$CPU = (((gwmi Win32_Processor).Name) -replace '\s+', ' ');
$GPU = (gwmi Win32_DisplayConfiguration).DeviceName;
$FreeRam = ([math]::Truncate((gwmi Win32_OperatingSystem).FreePhysicalMemory / 1KB)); 
$TotalRam = ([math]::Truncate((gwmi Win32_ComputerSystem).TotalPhysicalMemory / 1MB));
$UsedRam = $TotalRam - $FreeRam;
$FreeRamPercent = ($FreeRam / $TotalRam) * 100;
$FreeRamPercent = "{0:N0}" -f $FreeRamPercent;
$UsedRamPercent = ($UsedRam / $TotalRam) * 100;
$UsedRamPercent = "{0:N0}" -f $UsedRamPercent;

####### Printing Output #########

# Line 1 - HostName
Write-Host "                         ....::::       " -f Cyan -NoNewline;
Write-Host $Username -f red -nonewline; 
Write-Host "@" -f gray -nonewline; 
Write-Host $Machine -f red;

# Line 2 - OS
Write-Host "                 ....::::::::::::       " -f Cyan -NoNewline;
Write-Host "OS: " -f Red -NoNewline;
Write-Host $OS $BitVer;

# Line 3 - Kernel
Write-Host "        ....:::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Kernel: " -f Red -nonewline;
Write-Host $Kernel;

# Line 4 - Uptime
Write-Host "....:::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Uptime: " -f Red  -nonewline;
Write-Host $uptime.Days"d " $uptime.Hours"h " $uptime.Minutes"m " $uptime.Seconds"s " -separator "";

# Line 5 - Motherboard
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Motherboard: " -f Red -nonewline; 
Write-Host $Motherboard.Manufacturer $Motherboard.Product;

# Line 6 - Shell (Hardcoded since it is unlikely anybody can run this without powershell)
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Shell: " -f Red -nonewline; 
Write-Host "PowerShell $($PSVersionTable.PSVersion.ToString())"

# Line 7 - Resolution (for primary monitor only)
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Resolution: " -f Red -NoNewline; 
Write-Host $Horizontal "x" $Vertical;

# Line 8 - Windows Manager (HARDCODED, sorry bbzero users)
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Window Manager: " -f Red -nonewline; 
Write-Host "DWM";

# Line 10 - Font (HARDCODED)
Write-Host "................ ................       " -f Cyan -NoNewline;
Write-Host "Font: " -f Red -nonewline; 
Write-Host "Segoe UI";

# Line 11 - CPU
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "CPU: " -f Red -nonewline; 
Write-Host $CPU;

# Line 12 - GPU
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "GPU: " -f Red -nonewline; 
Write-Host $GPU;

# Line 13 - Ram
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "RAM: " -f Red -nonewline;
Write-Host $UsedRam "MB / $TotalRam MB" -NoNewline;
Write-Host " (" -NoNewline
Write-Host $UsedRamPercent"%" -f Green -NoNewline;
Write-Host ")";

# Line 14 - Disk Usage
Get-WmiObject Win32_LogicalDisk | ForEach-Object -Process {DiskDataBuilder $_.DeviceID $_.VolumeName $_.FreeSpace $_.Size}

# Empty Lines
if ($global:Hackcounter -le 1) {
    Write-Host "        '''':::: ::::::::::::::::       " -f Cyan;
}
If ($global:Hackcounter -le 2){
    Write-Host "                 ''''::::::::::::       " -f Cyan;
}
If ($global:Hackcounter -le 3){
    Write-Host "                         ''''::::       " -f Cyan;
}