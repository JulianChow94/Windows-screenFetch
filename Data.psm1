
Function Get-SystemSpecifications() 
{

    $UserInfo = Get-UserInformation;
    $OS = Get-OS;
    $Kernel = Get-Kernel;
    $Uptime = Get-SystemUptime;
    $Motherboard = Get-Mobo;
    $Shell = Get-Shell;
    $Displays = Get-Displays;
    $WM = Get-WM;
    $Font = Get-Font;
    $CPU = Get-CPU;
    $GPU = Get-GPU;
    $RAM = Get-RAM;
    $Disks = Get-Disks;


    [System.Collections.ArrayList] $SystemInfoCollection = 
        $UserInfo, 
        $OS, 
        $Kernel,
        $Uptime,
        $Motherboard,
        $Shell,
        $Displays,
        $WM,
        $Font,
        $CPU,
        $GPU,
        $RAM;

    foreach ($Disk in $Disks)
    {
        [void]$SystemInfoCollection.Add($Disk);
    }
    
    return $SystemInfoCollection;
}

Function Get-LineToTitleMappings() 
{ 
    $TitleMappings = @{
        0 = "";
        1 = "OS: "; 
        2 = "Kernel: ";
        3 = "Uptime: ";
        4 = "Motherboard: ";
        5 = "Shell: ";
        6 = "Resolution: ";
        7 = "Window Manager: ";
        8 = "Font: ";
        9 = "CPU: ";
        10 = "GPU ";
        11 = "RAM: ";
    };

    return $TitleMappings;
}

Function Get-UserInformation()
{
    return $env:USERNAME + "@" + [System.Net.Dns]::GetHostName();
}

Function Get-OS()
{
    return (Get-CimInstance Win32_OperatingSystem).Caption + " " + 
        (Get-CimInstance Win32_OperatingSystem).OSArchitecture;
}

Function Get-Kernel()
{
    return (Get-CimInstance  Win32_OperatingSystem).Version;
}

Function Get-SystemUptime()
{
    $Uptime = (([DateTime](Get-CimInstance Win32_OperatingSystem).LocalDateTime) -
            ([DateTime](Get-CimInstance Win32_OperatingSystem).LastBootUpTime));

    $FormattedUptime =  $Uptime.Days.ToString() + "d " + $Uptime.Hours.ToString() + "h " + $Uptime.Minutes.ToString() + "m " + $Uptime.Seconds.ToString() + "s ";
    return $FormattedUptime;
}

Function Get-Mobo()
{
    $Motherboard = Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer, Product;
    return $Motherboard.Manufacturer + " " + $Motherboard.Product;

}

Function Get-Shell()
{
    return "PowerShell $($PSVersionTable.PSVersion.ToString())";
}

Function Get-Displays()
{
    $Displays = New-Object System.Collections.Generic.List[System.Object];
    
    $Monitors = Get-CimInstance -ClassName Win32_VideoController | Select-Object CurrentHorizontalResolution, CurrentVerticalResolution, CurrentRefreshRate;

    $NumMonitors = ($Monitors | Measure-Object).Count;

    for ($i=0; $i -lt $NumMonitors; $i++) {
        $HorizontalResolution = $Monitors[$i].CurrentHorizontalResolution;
        $VerticalResolution = $Monitors[$i].CurrentVerticalResolution;
        $RefreshRate = $Monitors[$i].CurrentRefreshRate;

        if ($HorizontalResolution -And $VerticalResolution -And $RefreshRate) {
            $Display = $HorizontalResolution.ToString() + " x " + $VerticalResolution.ToString() + " @ " + $RefreshRate.ToString() + "Hz";

            if (!$Displays) {
                $Displays = $Display;
            }
            else {
                $Displays = ($Displays, $Display) -join("; ");
            }
        }
    }

    if ($Displays) {
        return $Displays;
    }
    else {
        return "NONE";
    }
}

Function Get-WM() 
{
    return "DWM";
}

Function Get-Font() 
{
    return "Segoe UI";
}

Function Get-CPU() 
{
    return (((Get-CimInstance Win32_Processor).Name) -replace '\s+', ' ');
}

Function Get-GPU() 
{
    return (Get-CimInstance -ClassName Win32_VideoController | ForEach-Object {$_.Name}) -join("; ");
}

Function Get-RAM() 
{
    $FreeRam = ([math]::Truncate((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB)); 
    $TotalRam = ([math]::Truncate((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB));
    $UsedRam = $TotalRam - $FreeRam;
    $FreeRamPercent = ($FreeRam / $TotalRam) * 100;
    $FreeRamPercent = "{0:N0}" -f $FreeRamPercent;
    $UsedRamPercent = ($UsedRam / $TotalRam) * 100;
    $UsedRamPercent = "{0:N0}" -f $UsedRamPercent;

    return $UsedRam.ToString() + "MB / " + $TotalRam.ToString() + " MB " + "(" + $UsedRamPercent.ToString() + "%" + ")";
}

Function Get-Disks() 
{     
    $FormattedDisks = New-Object System.Collections.Generic.List[System.Object];

    $NumDisks = (Get-CimInstance Win32_LogicalDisk).Count;

    if ($NumDisks) {
        for ($i=0; $i -lt ($NumDisks); $i++) {
            $DiskID = (Get-CimInstance Win32_LogicalDisk)[$i].DeviceId;

            $DiskSize = (Get-CimInstance Win32_LogicalDisk)[$i].Size;

            if ($DiskSize -gt 0) {
                $FreeDiskSize = (Get-CimInstance Win32_LogicalDisk)[$i].FreeSpace
                $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
                $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;

                $DiskSizeGB = $DiskSize / 1073741824;
                $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;

                if ($DiskSizeGB -gt 0 -And $FreeDiskSizeGB -gt 0) {
                    $FreeDiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
                    $FreeDiskPercent = "{0:N0}" -f $FreeDiskPercent;

                    $UsedDiskSizeGB = $DiskSizeGB - $FreeDiskSizeGB;
                    $UsedDiskPercent = ($UsedDiskSizeGB / $DiskSizeGB) * 100;
                    $UsedDiskPercent = "{0:N0}" -f $UsedDiskPercent;
                }
                else {
                    $FreeDiskPercent = 0;
                    $UsedDiskSizeGB = 0;
                    $UsedDiskPercent = 0;
                }
            }
            else {
                $DiskSizeGB = 0;
                $FreeDiskSizeGB = 0;
                $FreeDiskPercent = 0;
                $UsedDiskSizeGB = 0;
                $UsedDiskPercent = 100;
            }

            $FormattedDisk = "Disk " + $DiskID.ToString() + " " + 
                $UsedDiskSizeGB.ToString() + "GB" + " / " + $DiskSizeGB.ToString() + "GB " + 
                "(" + $UsedDiskPercent.ToString() + "%" + ")";
            $FormattedDisks.Add($FormattedDisk);
        }
    }
    else {
        $DiskID = (Get-CimInstance Win32_LogicalDisk).DeviceId;

        $FreeDiskSize = (Get-CimInstance Win32_LogicalDisk).FreeSpace
        $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
        $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;

        $DiskSize = (Get-CimInstance Win32_LogicalDisk).Size;
        $DiskSizeGB = $DiskSize / 1073741824;
        $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;

        if ($DiskSize -gt 0 -And $FreeDiskSize -gt 0 ) {
            $FreeDiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
            $FreeDiskPercent = "{0:N0}" -f $FreeDiskPercent;

            $UsedDiskSizeGB = $DiskSizeGB - $FreeDiskSizeGB;
            $UsedDiskPercent = ($UsedDiskSizeGB / $DiskSizeGB) * 100;
            $UsedDiskPercent = "{0:N0}" -f $UsedDiskPercent;

            $FormattedDisk = "Disk " + $DiskID.ToString() + " " +
                $UsedDiskSizeGB.ToString() + "GB" + " / " + $DiskSizeGB.ToString() + "GB " +
                "(" + $UsedDiskPercent.ToString() + "%" + ")";
            $FormattedDisks.Add($FormattedDisk);
        } 
        else {
            $FormattedDisk = "Disk " + $DiskID.ToString() + " Empty";
            $FormattedDisks.Add($FormattedDisk);
        }
    }

    return $FormattedDisks;
}
