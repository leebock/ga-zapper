param ([Parameter(Mandatory)]$Input_File, [Parameter(Mandatory)]$Output_File)

Get-Content $Input_File | 
Where-Object {(Select-String -Path $_ -Pattern "mtags.esri.com" -Quiet) -eq $false} > $Output_File