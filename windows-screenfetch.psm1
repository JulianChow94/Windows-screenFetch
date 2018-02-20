#### Screenfetch for powershell
#### Author Julian Chow


Function Screenfetch($distro)
{

    # Import-Module $PSScriptRoot\AsciiArtGenerator.psm1;
    # Import-Module $PSScriptRoot\SystemInfoCollector.psm1;
    
    $AsciiArt = "";

    if (-not $distro) {
        $AsciiArt = . Get-WindowsArt;
    }

    if (([string]::Compare($distro, "mac", $true) -eq 0) -or 
        ([string]::Compare($distro, "macOS", $true) -eq 0) -or 
        ([string]::Compare($distro, "osx", $true) -eq 0)) {
            
        $AsciiArt = . Get-MacArt;
    }
    else {
        $AsciiArt = . Get-WindowsArt;
    }

    $SystemInfoCollection = . Get-SystemSpecifications;
    $LineToTitleMappings = . Get-LineToTitleMappings;

    if ($SystemInfoCollection.Count -gt $AsciiArt.Count) { 
        Write-Error "System Specs occupies more lines than the Ascii Art resource selected"
    }


    for ($line = 0; $line -lt $AsciiArt.Count; $line++) {
        Write-Host $AsciiArt[$line] -f Cyan -NoNewline;
        Write-Host $LineToTitleMappings[$line] -f Red -NoNewline;

        if ($line -eq 0) {
            Write-Host $SystemInfoCollection[$line] -f Red;
        }

        elseif ($SystemInfoCollection[$line] -like '*:*') {
            $Seperator = ":";
            $Splitted = $SystemInfoCollection[$line].Split($seperator);

            $Title = $Splitted[0] + $Seperator;
            $Content = $Splitted[1];

            Write-Host $Title -f Red -NoNewline;
            Write-Host $Content;
        }
        else {

            Write-Host $SystemInfoCollection[$line];
                
        }
    }
}

