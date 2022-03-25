param ([Parameter(Mandatory)]$Input_File, [Parameter(Mandatory)]$Pattern)

Get-Content $Input_File | 
Where-Object {(Select-String -Path $_ -Pattern $Pattern -Quiet) -eq $false}