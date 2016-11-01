#### Screenfetch for powershell
#### Author Julian Chow

Add-Type -AssemblyName System.Windows.Forms

####### Functions ########
Function Get-PrimaryResolution{ Param ($monitorArray)
    foreach ($monitor in $monitorArray){
        if($monitor.Primary){       
            $primaryResolution = [System.Tuple]::Create($monitor.Bounds.Width, $monitor.Bounds.Height);
            return $primaryResolution;
        }
    }
}

####### Information Collection #########

## Resolution Information
$PrimaryResolution = Get-PrimaryResolution([System.Windows.Forms.Screen]::AllScreens);
$Horizontal = $PrimaryResolution.Item1;
$Vertical = $PrimaryResolution.Item2;

## Uptime Information
$uptime = ((gwmi Win32_OperatingSystem).ConvertToDateTime((gwmi Win32_OperatingSystem).LocalDateTime) - 
           (gwmi Win32_OperatingSystem).ConvertToDateTime((gwmi Win32_OperatingSystem).LastBootUpTime));

## Disk Information
# Available Space
$FreeDiskSize = (gwmi Win32_LogicalDisk).FreeSpace | select -f 1;
$FreeDiskSizeGB = $FreeDiskSize / 1073741824;
$FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;
# Total Space
$DiskSize = (gwmi Win32_LogicalDisk).size | select -f 1;
$DiskSizeGB = $DiskSize / 1073741824;
$DiskSizeGB = "{0:N0}" -f $DiskSizeGB;
$DiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
$DiskPercent = "{0:N0}" -f $DiskPercent;

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
$RamPercent = ($FreeRam / $TotalRam) * 100;
$RamPercent = "{0:N0}" -f $RamPercent;


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
Write-Host $Motherboard.Product;

# Line 6 - Shell (Hardcoded since it is unlikely anybody can run this without powershell)
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Shell: " -f Red -nonewline; 
Write-Host "Powershell 3.0"

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
Write-Host $FreeRam "MB / $TotalRam MB" -NoNewline;
Write-Host " (" -NoNewline
Write-Host $RamPercent"%" -f Green -NoNewline;
Write-Host ")";

# Line 13 - Disk Usage
Write-Host "'''':::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Disk: " -f Red -NoNewline;
Write-Host $FreeDiskSizeGB"GB" " / " $DiskSizeGB"GB" -NoNewline;
Write-Host " (" -NoNewline; 
Write-Host $DiskPercent"%" -f Green -NoNewline;
Write-Host ")"; 

# Empty Lines
Write-Host "        '''':::: ::::::::::::::::       " -f Cyan;
Write-Host "                 ''''::::::::::::       " -f Cyan;
Write-Host "                         ''''::::       " -f Cyan;

