Function Get-Session()
{
    $user = $env:USERNAME;
    $computerName = [System.Net.Dns]::GetHostName();
    $output = $user + '@' + $computerName;

    return $output
}

Function Get-OS()
{
    if ($IsLinux -or $IsMacOS)
    {
        return [System.Environment]::OSVersion.Platform
    }
    else 
    {
        return (Get-WmiObject Win32_OperatingSystem).Caption + 
        " " + (Get-WmiObject Win32_OperatingSystem).OSArchitecture;
    }
}

Function Get-Kernel()
{
    return (Get-WmiObject Win32_OperatingSystem).Version;
}

Function Get-UptimeStats()
{
    $Uptime = Get-Uptime

    $FormattedUptime =  $Uptime.Days.ToString() + "d " + $Uptime.Hours.ToString() + "h " + $Uptime.Minutes.ToString() + "m " + $Uptime.Seconds.ToString() + "s ";
    return $FormattedUptime;
}

Function Get-Mobo()
{
    if ($IsWindows)
    {
        $Motherboard = Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer, Product;
        return $Motherboard.Manufacturer + " " + $Motherboard.Product;
    }
}