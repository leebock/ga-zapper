$Path = "C:\Lee\repos\primary\tornado-dashboard"
$TextFile_Files_With_GA = "..\data\files-w-ga.txt"
$TextFile_Files_Without_Adobe = "..\data\files-wo-adobe.txt"
$CreateBackup = $false

#***********************************************************
#********** Search for files w/ Google Analytics ***********
#***********************************************************

Write-Host("Searching for files that contain Google Analytics...")

.\Find-Files-With-Content-Pattern `
    -Path $Path `
    -FileName "index.html" `
    -Pattern "<!--Google Analytics Start-->" > $TextFile_Files_With_GA

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

.\Filter-Files-by-Content-Pattern `
    -Input_File $TextFile_Files_With_GA `
    -Pattern "mtags.esri.com" > $TextFile_Files_Without_Adobe 

#remove mysteriously occuring blank lines
(Get-Content $TextFile_Files_Without_Adobe) | 
Where-Object {$_.trim() -ne "" } | 
Set-Content $TextFile_Files_Without_Adobe

$measure = Get-Content $TextFile_Files_Without_Adobe | Measure-Object -Line 

Write-Host("Found "+$measure.Lines+" files that DON'T contain Adobe Analytics.")

#***********************************************************
#************ For non Adobe files, insert Adobe ************
#***********************************************************

foreach($line in (Get-Content $TextFile_Files_Without_Adobe)) {
    $content = Get-Content -path $line -Raw
    $replacement = '<!--Google Analytics End-->'+"`r`n"+"`r`n"+ 
    '<!-- Adobe Analytics Start-->'+"`r`n"+
    '<script src="'+"//mtags.esri.com/tags.js"+'"></script>'+"`r`n"+
    '<!-- Adobe Analytics End-->'
    $content = $content -replace "<!--Google Analytics End-->", $replacement
    Set-Content -Path $line -Value $content
}

#***********************************************************
#************** Zap Google Analytics section ***************
#***********************************************************

foreach($line in (Get-Content $TextFile_Files_With_GA)) {
    $content = Get-Content -path $line -Raw
    $Pattern = '(?s)(?<=<!--Google Analytics Start-->\r?\n).*?(?=<!--Google Analytics End-->)'
    $content = $content -replace $Pattern, ""
    Set-Content -Path $line -Value $content
}