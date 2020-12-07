Add-Type -AssemblyName System.Windows.Forms

Function Get-SystemSpecifications() 
{

    $UserInfo = Get-UserInformation;
    $OS = Get-OS;
    $Kernel = Get-Kernel;
    $Uptime = Get-Uptime;
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
    return $env:USERNAME + "@" + (Get-WmiObject Win32_OperatingSystem).CSName;
}

Function Get-OS()
{
    return (Get-WmiObject Win32_OperatingSystem).Caption + " " + 
        (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
}

Function Get-Kernel()
{
    return (Get-WmiObject  Win32_OperatingSystem).Version;
}

Function Get-Uptime()
{
    $Uptime = ((Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
        (Get-WmiObject Win32_OperatingSystem).LocalDateTime) - 
        (Get-WmiObject Win32_OperatingSystem).ConvertToDateTime(
            (Get-WmiObject Win32_OperatingSystem).LastBootUpTime));

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

    # This gives the available resolutions
    $monitors = Get-WmiObject -N "root\wmi" -Class WmiMonitorListedSupportedSourceModes

    foreach($monitor in $monitors) 
    {
        # Sort the available modes by display area (width*height)
        $sortedResolutions = $monitor.MonitorSourceModes | sort -property {$_.HorizontalActivePixels * $_.VerticalActivePixels}
        $maxResolutions = $sortedResolutions | select @{N="MaxRes";E={"$($_.HorizontalActivePixels) x $($_.VerticalActivePixels) "}}

        $Displays.Add(($maxResolutions | select -last 1).MaxRes);
    }

    return $Displays;
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
    return (((Get-WmiObject Win32_Processor).Name) -replace '\s+', ' ');
}

Function Get-GPU() 
{
    return (Get-WmiObject Win32_DisplayConfiguration).DeviceName;
}

Function Get-RAM() 
{
    $FreeRam = ([math]::Truncate((Get-WmiObject Win32_OperatingSystem).FreePhysicalMemory / 1KB)); 
    $TotalRam = ([math]::Truncate((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory / 1MB));
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

    $NumDisks = (Get-WmiObject Win32_LogicalDisk).Count;

    if ($NumDisks) 
    {
        for ($i=0; $i -lt ($NumDisks); $i++) 
        {
            $DiskID = (Get-WmiObject Win32_LogicalDisk)[$i].DeviceId;

            $FreeDiskSize = (Get-WmiObject Win32_LogicalDisk)[$i].FreeSpace
            $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
            $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;


            $DiskSize = (Get-WmiObject Win32_LogicalDisk)[$i].Size;
            $DiskSizeGB = $DiskSize / 1073741824;
            $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;
            if($DiskSizeGB -ne 0){
                $FreeDiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
            
            
            $FreeDiskPercent = "{0:N0}" -f $FreeDiskPercent;
        }


            $UsedDiskSizeGB = $DiskSizeGB - $FreeDiskSizeGB;
            if($DiskSizeGB -ne 0){
            $UsedDiskPercent = ($UsedDiskSizeGB / $DiskSizeGB) * 100;
            $UsedDiskPercent = "{0:N0}" -f $UsedDiskPercent;
            }


            $FormattedDisk = "Disk " + $DiskID.ToString() + " " + 
                $UsedDiskSizeGB.ToString() + "GB" + " / " + $DiskSizeGB.ToString() + "GB " + 
                "(" + $UsedDiskPercent.ToString() + "%" + ")";
            $FormattedDisks.Add($FormattedDisk);
        }
    }
    else 
    {
        $DiskID = (Get-WmiObject Win32_LogicalDisk).DeviceId;

        $FreeDiskSize = (Get-WmiObject Win32_LogicalDisk).FreeSpace
        
        $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
        $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;

        $DiskSize = (Get-WmiObject Win32_LogicalDisk).Size;
        $DiskSizeGB = $DiskSize / 1073741824;
        $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;

        if ($DiskSize -gt 0) 
        {

            $FreeDiskPercent = ($FreeDiskSizeGB / $DiskSizeGB) * 100;
            $FreeDiskPercent = "{0:N0}" -f $FreeDiskPercent;

            $UsedDiskSizeGB = $DiskSizeGB - $FreeDiskSizeGB;
            if($DiskSizeGB -ne 0){
            $UsedDiskPercent = ($UsedDiskSizeGB / $DiskSizeGB) * 100;
            $UsedDiskPercent = "{0:N0}" -f $UsedDiskPercent;
            }
            
            $FormattedDisk = "Disk " + $DiskID.ToString() + " " +
                $UsedDiskSizeGB.ToString() + "GB" + " / " + $DiskSizeGB.ToString() + "GB " +
                "(" + $UsedDiskPercent.ToString() + "%" + ")";
            $FormattedDisks.Add($FormattedDisk);
        } 
        else 
        {
            $FormattedDisk = "Disk " + $DiskID.ToString() + " Empty";
            $FormattedDisks.Add($FormattedDisk);
        }
    }

    return $FormattedDisks;
}
