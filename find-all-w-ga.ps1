param ([Parameter(Mandatory)]$Path)

Get-ChildItem -Path $Path -Recurse -Include index.html  | 
Select-String -Pattern "<!--Google Analytics Start-->" | 
ForEach-Object Path
