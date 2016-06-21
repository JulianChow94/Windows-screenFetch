# Screenfetch for powershell
# Author Julian Chow


# Some important Variables for convenience
$Horizontal = (gwmi -Class Win32_VideoController).CurrentHorizontalResolution | select -f 2;
$Vertical = (gwmi -Class Win32_VideoController).CurrentVerticalResolution | select -f 1;
$uptime = ((gwmi Win32_OperatingSystem).ConvertToDateTime((gwmi Win32_OperatingSystem).LocalDateTime) - 
           (gwmi Win32_OperatingSystem).ConvertToDateTime((gwmi Win32_OperatingSystem).LastBootUpTime));
$FreeDiskSize = (gwmi Win32_LogicalDisk).FreeSpace | select -f 1;
$FreeDiskSizeGB = $FreeDiskSize / 1073741824;
$FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;
$DiskSize = (gwmi Win32_LogicalDisk).size | select -f 1;
$DiskSizeGB = $DiskSize / 1073741824;
$DiskSizeGB = "{0:N0}" -f $DiskSizeGB;
$DiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
$DiskPercent = "{0:N0}" -f $DiskPercent;

# Line 1 - HostName
Write-Host "                         ....::::       " -f Cyan -NoNewline;
Write-Host $env:username -f red -nonewline; 
Write-Host "@" -f gray -nonewline; 
Write-Host (gwmi Win32_OperatingSystem).CSName -f red;

#Line 2 - OS
Write-Host "                 ....::::::::::::       " -f Cyan -NoNewline;
Write-Host "OS: " -f Red -NoNewline;
Write-Host (gwmi Win32_OperatingSystem).Caption (gwmi Win32_OperatingSystem).OSArchitecture;

#Line 3 - Kernel
Write-Host "        ....:::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Kernel: " -f Red -nonewline;
Write-Host (gwmi Win32_OperatingSystem).Version;

#Line 4 - Uptime
Write-Host "....:::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Uptime: " -f Red  -nonewline;
Write-Host $uptime.Days"d " $uptime.Hours"h " $uptime.Minutes"m " $uptime.Seconds"s " -separator "";

#Line 5 - Packages
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Packages: " -f Red -nonewline; 
Write-Host (gwmi Win32_Product).Count;

#Line 6 - Shell
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Shell: " -f Red -nonewline; 
Write-Host "Powershell 3.0"

#Line 7 - Resolution
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Resolution: " -f Red -NoNewline; 
Write-Host $Horizontal "x" $Vertical;

#Line 8 - Windows Manager (HARDCODED)
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Window Manager: " -f Red -nonewline; 
Write-Host "DWM";

#Line 10 - Font (HARDCODED)
Write-Host "................ ................       " -f Cyan -NoNewline;
Write-Host "Font: " -f Red -nonewline; 
Write-Host "Segoe UI";

#Line 11 - CPU
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "CPU: " -f Red -nonewline; 
Write-Host (((gwmi Win32_Processor).Name) -replace '\s+', ' ');

#Line 12 - GPU
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "GPU: " -f Red -nonewline; 
Write-Host (gwmi Win32_DisplayConfiguration).DeviceName;

#Line 13 - Ram
Write-Host ":::::::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "RAM: " -f Red -nonewline;
$FreeRam = ([math]::Truncate((gwmi Win32_OperatingSystem).FreePhysicalMemory / 1KB)); 
Write-Host $FreeRam -NoNewline;
Write-Host "MB / " -NoNewline;
$TotalRam = ([math]::Truncate((gwmi Win32_ComputerSystem).TotalPhysicalMemory / 1MB));
Write-Host $TotalRam -NoNewline;
$RamPercent = ($FreeRam / $TotalRam) * 100;
$RamPercent = "{0:N0}" -f $RamPercent;
Write-Host "MB" -NoNewline;
Write-Host " (" -NoNewline
Write-Host $RamPercent"%" -f Green -NoNewline;
Write-Host ")";

#Line 13 - Disk Usage
Write-Host "'''':::::::::::: ::::::::::::::::       " -f Cyan -NoNewline;
Write-Host "Disk: " -f Red -NoNewline;
Write-Host $FreeDiskSizeGB"GB" " / " $DiskSizeGB"GB" -NoNewline;
Write-Host " (" -NoNewline; 
Write-Host $DiskPercent"%" -f Green -NoNewline;
Write-Host ")"; 

Write-Host "        '''':::: ::::::::::::::::       " -f Cyan #-NoNewline;
Write-Host "                 ''''::::::::::::       " -f Cyan #-NoNewline;
Write-Host "                         ''''::::       " -f Cyan #-NoNewline;


