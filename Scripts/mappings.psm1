$Functions = @( Get-ChildItem -Path Scripts\*.psm1 -ErrorAction SilentlyContinue )

# Import source the files
foreach ($import in @($Functions)) {
    Try {
        Write-Host $import.fullname 
        Import-Module $import.fullname -Force -Verbose
    }
    Catch {
        Write_error -Message "Failed to import function $($import.fullname): $_"
    }
}

Function Get-ArtMappings()
{
    return Get-WindowsArt
}

Function Get-Sections() 
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

function Get-Functions()
{
    $DataMapping = @{
        0 = Get-Session;
        1 = Get-OS; 
        2 = Get-Kernel;
        3 = Get-UptimeStats;
        4 = Get-Mobo;
        5 = Get-Terminal;
        6 = Get-Displays;
        7 = Get-WM;
        8 = Get-Font;
        9 = Get-CPU;
        10 = Get-GPU;
        11 = Get-RAM;        
    }

    return $DataMapping
}