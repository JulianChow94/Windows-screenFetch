# Universal PSM file
# Requires -Version 6.0

# Get functions files.
$Functions = @( Get-ChildItem -Path Scripts\*.psm1 -ErrorAction SilentlyContinue )
# Write-Host $Functions

# Import source the files
foreach($import in @($Functions))
{
    Try 
    {
        Write-Host $import.fullname 
        Import-Module $import.fullname -Force -Verbose
    }
    Catch 
    {
        Write_error -Message "Failed to import function $($import.fullname): $_"
    }
}

function Screenfetch 
{
    Get-Session
    Get-OS 
    Get-Kernel 
    Get-UptimeStats
    Get-Mobo
}

return Screenfetch