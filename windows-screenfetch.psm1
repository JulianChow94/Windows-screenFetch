# Universal PSM file
# Requires -Version 6.0

Import-Module .\Scripts\mappings.psm1 -Force -Verbose

function Screenfetch {
    $art = Get-ArtMappings
    $mappings = Get-Sections
    $functions = Get-Functions

    for ($row = 0; $row -lt $art.Count; $row++) {
        Write-Host $art[$row] -f Cyan -NoNewline;
        Write-Host $mappings[$row] -f Red -NoNewline;    
        Write-Host $functions[$row]
    }
}
