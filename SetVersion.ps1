$directory = $Env:DIRECTORY
$fileName = $Env:FILENAME
$version = $Env:VERSION
$copyright = $Env:COPYRIGHT
$recursive = ([String]::IsNullOrEmpty($Env:RECURSIVE)) ? $false : [System.Convert]::ToBoolean($Env:RECURSIVE)
$githubOutput = $Env:GITHUB_OUTPUT
$assemblyFileVersion = $version

function SetVersion($file) {
	$contents = [System.IO.File]::ReadAllText($file.FullName)
	$contents = [Regex]::Replace($contents, '(AssemblyVersion\(").*("\)])', "`${1}$version`${2}", [System.Text.RegularExpressions.RegexOptions] "Multiline, IgnoreCase")
	$contents = [Regex]::Replace($contents, '(AssemblyFileVersion\(").*("\)])', "`${1}$assemblyFileVersion`${2}", [System.Text.RegularExpressions.RegexOptions] "Multiline, IgnoreCase")
	if ($false -eq [String]::IsNullOrEmpty($copyright)) {
		$contents = [Regex]::Replace($contents, '(AssemblyCopyright\(").*("\)])', "`${1}$copyright`${2}", [System.Text.RegularExpressions.RegexOptions] "Multiline, IgnoreCase")
	}

	$streamWriter = New-Object System.IO.StreamWriter($file.FullName, $false, [System.Text.Encoding]::GetEncoding("utf-8"))
	$streamWriter.Write($contents)
	$streamWriter.Close()

	Write-Output "assemblyVersion=$version" >> $githubOutput
	Write-Output "assemblyFileVersion=$assemblyFileVersion" >> $githubOutput
	Write-Host "$file updated with assemblyVersion '$version' and assemblyFileVersion '$assemblyFileVersion'"
}

$patternExactSemver = '^\d+\.\d+(\.\d+)*$'
$patternStartsWithSemver = '^\d+\.\d+(\.\d+)*'
$isSemVer = [Regex]::Match($version, $patternExactSemver)
if ($false -eq $isSemVer.success) {
	$startsWithSemVer = [Regex]::Match($version, $patternStartsWithSemver)
	if ($startsWithSemVer.success) {
		$version = $startsWithSemVer.Value
	} else {
		Write-Host "Version number '$version' is invalid for use in assembly info versions"
	}
}

if ($recursive) {
	$assemblyInfoFiles = Get-ChildItem $directory -Recurse -Include $fileName
	foreach ($file in $assemblyInfoFiles) {	
		SetVersion($file)
	}
}
else {
	$file = Get-ChildItem $directory -Filter $fileName | Select-Object -First 1
	SetVersion($file)
}
