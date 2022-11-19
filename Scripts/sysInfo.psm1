Function Get-Session() {
    $user = $env:USERNAME;
    $computerName = [System.Net.Dns]::GetHostName();
    $output = $user + '@' + $computerName;

    return $output
}

Function Get-OS() {
    if ($IsLinux -or $IsMacOS) {
        return [System.Environment]::OSVersion.Platform
    }
    else {
        return (Get-WmiObject Win32_OperatingSystem).Caption + 
        " " + (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
    }
}

Function Get-Kernel() {
    return (Get-WmiObject Win32_OperatingSystem).Version;
}

Function Get-UptimeStats() {
    $Uptime = Get-Uptime

    $FormattedUptime = $Uptime.Days.ToString() + "d " + $Uptime.Hours.ToString() + "h " + $Uptime.Minutes.ToString() + "m " + $Uptime.Seconds.ToString() + "s ";
    return $FormattedUptime;
}

Function Get-Mobo() {
    if ($IsWindows) {
        $Motherboard = Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer, Product;
        return $Motherboard.Manufacturer + " " + $Motherboard.Product;
    }
}

Function Get-Terminal() {
    $IntermediateParents = @('powershell', 'pwsh', 'cmd', 'zsh', 'bash', 'fish', 'csh', 'tcsh')

    $hash = @{
        'WindowsTerminal'           = 'Windows Terminal'
        'Code'                      = 'Visual Studio Code'
        'Console'                   = 'Console2'
        'ConEmuC64'                 = 'ConEmu'
        'FluentTerminal.SystemTray' = 'Fluent Terminal'
    }

    $Context = (Get-Process -Id $PID).Parent

    $count = 0;
    while (-not $Context.ProcessName -in $IntermediateParents) {
        $count++;

        if ($count -gt 100) {
            break;
        }
    }

    try {
        return $hash[$Context.ProcessName]
    }
    catch {
        return 'Unknown';
    }
}

Function Get-Shell() {
    return "PowerShell $($PSVersionTable.PSVersion.ToString())";
}

Function Get-Packages() {
    return (winget list | measure-object -line).lines;
}

# These display values are scaled by the percentage of the user's system display settings
Function Get-Displays()
{ 
    $Displays = New-Object System.Collections.Generic.List[System.Object];

    # This gives the available resolutions (scaled)
    $monitors = [System.Windows.Forms.Screen]::AllScreens | Sort-Object -Property Primary -Descending

    foreach($monitor in $monitors) 
    {
        # Sort the available modes by display area (width*height)
        $maxResolutions = $monitor.WorkingArea | select @{N="MaxRes";E={"$($_.Width) x $($_.Height) "}}

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

#TODO: reformat this
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