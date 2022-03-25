$Path = "C:\Lee\repos\primary\tornado-dashboard"
$TextFile_Files_With_GA = "..\data\files-w-ga.txt"
$TextFile_Files_Without_Adobe = "..\data\files-wo-adobe.txt"
$CreateBackup = $false

#***********************************************************
#********** Search for files w/ Google Analytics ***********
#***********************************************************

Write-Host("Searching for files that contain Google Analytics...")

.\find-all-w-ga.ps1 -Path $Path > $TextFile_Files_With_GA

#remove mysteriously occuring blank lines
(Get-Content $TextFile_Files_With_GA) | 
Where-Object {$_.trim() -ne "" } | 
Set-Content $TextFile_Files_With_GA

$measure = Get-Content $TextFile_Files_With_GA | Measure-Object -Line

Write-Host("Found "+$measure.Lines+" files that contain Google Analytics.")

#***********************************************************
#********************* Back up files  **********************
#***********************************************************

if ($CreateBackup) {
    Write-Host("Creating backup files...")
    .\create-backups.ps1 -Input_File $TextFile_Files_With_GA    
}

#***********************************************************
#**** Filter for files that don't have Adobe Analytics *****
#***********************************************************

Write-Host("Filtering for files that don't have Adobe Analytics...")

.\select-all-wo-adobe.ps1 `
    -Input_File $TextFile_Files_With_GA `
    -Output_File $TextFile_Files_Without_Adobe 

#remove mysteriously occuring blank lines
(Get-Content $TextFile_Files_Without_Adobe) | 
Where-Object {$_.trim() -ne "" } | 
Set-Content $TextFile_Files_Without_Adobe

$measure = Get-Content $TextFile_Files_Without_Adobe | Measure-Object -Line 

Write-Host("Found "+$measure.Lines+" files that DON'T contain Adobe Analytics.")

foreach($line in (Get-Content $TextFile_Files_Without_Adobe)) {
    Write-Host($line)
}

#***********************************************************
#************ For non Adobe files, insert Adobe ************
#***********************************************************


