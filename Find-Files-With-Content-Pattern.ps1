param (
    [Parameter(Mandatory)]$Path, 
    [Parameter(Mandatory)]$FileName, 
    [Parameter(Mandatory)]$Pattern
    )

Get-ChildItem -Path $Path -Recurse -Include $FileName  | 
Select-String -Pattern $Pattern | 
ForEach-Object Path
