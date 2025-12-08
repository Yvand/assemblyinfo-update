# AssemblyInfo Update

## Overview

This Github action updates _AssemblyInfo.cs_ files in .NET projects with the specified version numbers for both the **AssemblyVersion** and the **AssemblyFileVersion**.

### Input arguments

* `assembly_version`: The to set in AssemblyVersion, in SemVer format
* `assembly_file_version`: The to set in AssemblyFileVersion
* `copyright`: The copyright to set
* `directory`: the directory where the assembly info file is located (or the top-most directory to search if `recursive` is `true`).  Defaults to '.\\'
* `filename`: the file name of the assembly info file.  Defaults to 'AssemblyInfo.cs'
* `recursive`: if `true`, updates all assembly info files matching the `filename` argument, in all subdirectories.  Defaults to `true`

### Output arguments

* `assembly_version`: Version set in AssemblyVersion
* `assembly_file_version`: Version set in AssemblyFileVersion

### Example Usage

```yml
- name: Set version in all AssemblyInfo.cs files
  uses: Yvand/assemblyinfo-update@v3
  with:
    assembly_version: '2.0.0'
    assembly_file_version: '2.0.0-preview.1'

- name: Display the versions set
  run: |
    echo "assembly_version: {{steps.set-assembly-version.outputs.assembly_version}}"
    echo "assembly_file_version: {{steps.set-assembly-version.outputs.assembly_file_version}}"
```
