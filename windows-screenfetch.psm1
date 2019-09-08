#### Screenfetch for powershell
#### Author Julian Chow


Function Screenfetch($distro)
{
    $AsciiArt = "";

    if (-not $distro) 
    {
        #$AsciiArt = . Get-WindowsArt;
        $AsciiArt = . Get-ArchArt;
    }

    if (([string]::Compare($distro, "mac", $true) -eq 0) -or 
        ([string]::Compare($distro, "macOS", $true) -eq 0) -or 
        ([string]::Compare($distro, "osx", $true) -eq 0)) {

        $AsciiArt = . Get-MacArt;
    }

    elseif (([string]::Compare($distro, "windows", $true) -eq 0)) {
                
           $AsciiArt = . Get-WindowsArt;
    }

    elseif (([string]::Compare($distro, "arch", $true) -eq 0)) {
                
           $AsciiArt = . Get-ArchArt;
    }

    elseif (([string]::Compare($distro, "lucasoe", $true) -eq 0)) {
              
           $AsciiArt = . Get-LucasOeArt;
    }   

    else 
    {
        #$AsciiArt = . Get-WindowsArt;
        $AsciiArt = . Get-ArchArt;
    }

    $SystemInfoCollection = . Get-SystemSpecifications;
    $LineToTitleMappings = . Get-LineToTitleMappings;

    if ($SystemInfoCollection.Count -gt $AsciiArt.Count) 
    { 
        Write-Error "System Specs occupies more lines than the Ascii Art resource selected"
    }

    Write-Host "";
    for ($line = 0; $line -lt $AsciiArt.Count; $line++) 
    {
        Write-Host $AsciiArt[$line] -f Cyan -NoNewline;
        Write-Host $LineToTitleMappings[$line] -f Cyan -NoNewline;

        if ($line -eq 0) 
        {
            Write-Host $SystemInfoCollection[$line] -f Cyan;
        }

        elseif ($SystemInfoCollection[$line] -like '*:*') 
        {
            $Seperator = ":";
            $Splitted = $SystemInfoCollection[$line].Split($seperator);

            $Title = $Splitted[0] + $Seperator;
            $Content = $Splitted[1];

            Write-Host $Title -f Cyan -NoNewline;
            Write-Host $Content;
        }
        else 
        {
            Write-Host $SystemInfoCollection[$line];            
        }
    }
}

