# Universal PSM file
# Requires -Version 6.0

# Get functions files.
# $Functions = @( Get-ChildItem -Path Scripts\*.psm1 -ErrorAction SilentlyContinue )
# Write-Host $Functions

# Import source the files
# foreach ($import in @($Functions)) {
#     Try {
#         Write-Host $import.fullname 
#         Import-Module $import.fullname -Force -Verbose
#     }
#     Catch {
#         Write_error -Message "Failed to import function $($import.fullname): $_"
#     }
# } 

Import-Module .\Scripts\mappings.psm1 -Force -Verbose


function Screenfetch {
    $art = Get-ArtMappings
    $mappings = Get-Sections
    $functions = Get-Functions

    for ($row = 0; $row -lt $art.Count; $row++) 
    {
        Write-Host $art[$row] -f Cyan -NoNewline;
        Write-Host $mappings[$row] -f Red -NoNewline;    
        Write-Host $functions[$row]
    }

    
}

# return Screenfetch