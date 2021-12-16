Add-Type -AssemblyName System.Windows.Forms

Function Get-SystemSpecifications() 
{

    $UserInfo = Get-UserInformation;
    $OS = Get-OS;
    $Kernel = Get-Kernel;
    $Uptime = Get-FormattedUptime;
    $Motherboard = Get-Mobo;
    $Shell = Get-Shell;
    $Resolution = Get-Resolution;
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
        $Resolution,
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
        2 = "Kernel Version: ";
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
    return (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object UserName).UserName.Split('\')[1];
}

Function Get-OS()
{
    return (Get-CimInstance -Class CIM_OperatingSystem).Caption + ", " + (Get-CimInstance -Class CIM_OperatingSystem).OSArchitecture;
}

Function Get-Kernel()
{
    return [System.Environment]::OSVersion.Version;
}

Function Get-FormattedUptime()
{
    $Uptime = Get-Uptime

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

Function Get-Resolution()
{ 
    $Horizontal = Out-String -InputObject (Get-CimInstance Win32_VideoController).CurrentHorizontalResolution -NoNewline;
    $Vertical = Out-String -InputObject (Get-CimInstance Win32_VideoController).CurrentVerticalResolution -NoNewline;
    return $Horizontal + " x " + $Vertical;
}



Function Get-WM() 
{
    return "DWM";
}

# THIS USUALLY WILL OUTPUT INCORRECT RESULTS. STATICALLY SETTING THIS VALUE IS NO BUENO. NEED TO REMOVE BUT WANT TO GET THIS RELEASED FIRST.
Function Get-Font() 
{
    return "Segoe UI";
}


Function Get-CPU() 
{
    return (Get-CimInstance -Class CIM_Processor).Name;
}

Function Get-GPU() 
{
    return (Get-CimInstance -Class Win32_VideoController).Name;
}

Function Get-RAM() 
{
    $FreeRam = ([math]::Truncate((Get-CIMInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB)); 
    $TotalRam = ([math]::Truncate((Get-CIMInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB));
    $UsedRam = $TotalRam - $FreeRam;
    $FreeRamPercent = ($FreeRam / $TotalRam) * 100;
    $FreeRamPercent = "{0:N0}" -f $FreeRamPercent;
    $UsedRamPercent = ($UsedRam / $TotalRam) * 100;
    $UsedRamPercent = "{0:N0}" -f $UsedRamPercent;

    return $UsedRam.ToString() + "GB / " + $TotalRam.ToString() + "GB " + "(" + $UsedRamPercent.ToString() + "%" + ")";
}

Function Get-Disks() 
{     
    $FormattedDisks = New-Object System.Collections.Generic.List[System.Object];

    $NumDisks = (Get-CimInstance Win32_LogicalDisk).Count;

    if ($NumDisks) 
    {
        for ($i=0; $i -lt ($NumDisks); $i++) 
        {
            $DiskID = (Get-CimInstance Win32_LogicalDisk)[$i].DeviceId;

            $FreeDiskSize = (Get-CimInstance Win32_LogicalDisk)[$i].FreeSpace
            $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
            $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;

            $DiskSize = (Get-CimInstance Win32_LogicalDisk)[$i].Size;
            $DiskSizeGB = $DiskSize / 1073741824;
            $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;

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
    }
    else 
    {
        $DiskID = (Get-CimInstance Win32_LogicalDisk).DeviceId;

        $FreeDiskSize = (Get-CimInstance Win32_LogicalDisk).FreeSpace
        $FreeDiskSizeGB = $FreeDiskSize / 1073741824;
        $FreeDiskSizeGB = "{0:N0}" -f $FreeDiskSizeGB;

        $DiskSize = (Get-CimInstance Win32_LogicalDisk).Size;
        $DiskSizeGB = $DiskSize / 1073741824;
        $DiskSizeGB = "{0:N0}" -f $DiskSizeGB;

        if ($DiskSize -gt 0) 
        {
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
        else 
        {
            $FormattedDisk = "Disk " + $DiskID.ToString() + " Empty";
            $FormattedDisks.Add($FormattedDisk);
        }
    }

    return $FormattedDisks;
}
