#### Screenfetch for powershell
#### Author Julian Chow


Function Screenfetch($distro)
{
    $AsciiArt = "";

    if (-not $distro) 
    {
        $AsciiArt = . Get-WindowsArt;
    }

    if (([string]::Compare($distro, "mac", $true) -eq 0) -or 
        ([string]::Compare($distro, "macOS", $true) -eq 0) -or 
        ([string]::Compare($distro, "osx", $true) -eq 0)) {
            
        $AsciiArt = . Get-MacArt;
    }
    else 
    {
        $AsciiArt = . Get-WindowsArt;
    }

    $SystemInfoCollection = . Get-SystemSpecifications;
    $LineToTitleMappings = . Get-LineToTitleMappings;

    # Iterate over all lines from the SystemInfoCollection to display all information
    $LineNumber = (($SystemInfoCollection.Count, $AsciiArt.Count) | Measure-Object -Maximum).Maximum;
    for ($line = 0; $line -lt $LineNumber; $line++)
    {
        if (($AsciiArt[$line].Length) -eq 0)
        {
            # Write some whitespaces to sync the left spacing with the asciiart.
            Write-Host "                                        " -f Cyan -NoNewline;
        }
        else
        {
            Write-Host $AsciiArt[$line] -f Cyan -NoNewline;
        }
        Write-Host $LineToTitleMappings[$line] -f Red -NoNewline;

        if ($line -eq 0) 
        {
            Write-Host $SystemInfoCollection[$line] -f Red;
        }

        elseif ($SystemInfoCollection[$line] -like '*:*') 
        {
            $Seperator = ":";
            $Splitted = $SystemInfoCollection[$line].Split($seperator);

            $Title = $Splitted[0] + $Seperator;
            $Content = $Splitted[1];

            Write-Host $Title -f Red -NoNewline;
            Write-Host $Content;
        }
        else 
        {
            Write-Host $SystemInfoCollection[$line];            
        }
    }
}

