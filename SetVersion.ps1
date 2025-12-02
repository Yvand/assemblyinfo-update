$directory = $Env:DIRECTORY
$fileName = $Env:FILENAME
$assemblyVersion = $Env:ASSEMBLY_VERSION
$assemblyFileVersion = $Env:ASSEMBLY_FILE_VERSION
$copyright = $Env:COPYRIGHT
$recursive = ([String]::IsNullOrEmpty($Env:RECURSIVE)) ? $false : [System.Convert]::ToBoolean($Env:RECURSIVE)
$githubOutput = $Env:GITHUB_OUTPUT

function SetVersion($file)
{
	$contents = [System.IO.File]::ReadAllText($file.FullName)
	$contents = [Regex]::Replace($contents, '(AssemblyVersion\(").*("\)])', "`${1}$assemblyVersion`${2}", [System.Text.RegularExpressions.RegexOptions] "Multiline, IgnoreCase")
	$contents = [Regex]::Replace($contents, '(AssemblyFileVersion\(").*("\)])', "`${1}$assemblyFileVersion`${2}", [System.Text.RegularExpressions.RegexOptions] "Multiline, IgnoreCase")
	if ($false -eq [String]::IsNullOrEmpty($copyright)) {
		$contents = [Regex]::Replace($contents, '(AssemblyCopyright\(").*("\)])', "`${1}$copyright`${2}", [System.Text.RegularExpressions.RegexOptions] "Multiline, IgnoreCase")
	}

	$streamWriter = New-Object System.IO.StreamWriter($file.FullName, $false, [System.Text.Encoding]::GetEncoding("utf-8"))
	$streamWriter.Write($contents)
	$streamWriter.Close()

	Write-Output "assemblyVersion=$assemblyVersion" >> $githubOutput
	Write-Output "assemblyFileVersion=$assemblyFileVersion" >> $githubOutput
	Write-Host "$file updated with assemblyVersion '$assemblyVersion' and assemblyFileVersion '$assemblyFileVersion'"
}

if ($recursive)
{
	$assemblyInfoFiles = Get-ChildItem $directory -Recurse -Include $fileName
	foreach($file in $assemblyInfoFiles)
	{	
		SetVersion($file)
	}
}
else
{
	$file = Get-ChildItem $directory -Filter $fileName | Select-Object -First 1
	SetVersion($file)
}
