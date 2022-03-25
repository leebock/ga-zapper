param ([Parameter(Mandatory)]$Input_File)

foreach($line in Get-Content $Input_File) {
	$dir = Split-Path $line
	$name = Split-Path $line -Leaf
	$base = $name.Split(".")[0]
	$extension = $name.Split(".")[1]
	$full = Join-Path -Path $dir $base"-pre-ga-removal-3-2022."$extension
	Copy-Item $line $full
}