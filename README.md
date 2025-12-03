# AssemblyInfo Update

## set-version

This Github action updates _AssemblyInfo.cs_ files in .NET projects with the specified version number.  It sets both the **AssemblyVersion** and the **AssemblyFileVersion**.  
**AssemblyFileVersion** is always set using the input parameter `version` as-is.
**AssemblyVersion** is set using the input parameter `version`:
- If `version` is exactly a semVer: Used as-is
- If `version` is not a semVer: Try to extract a semver from `version`. For example: `1.2.3.4` if `version` is `1.2.3.4-preview.1`

### Input arguments

* `version` (required): The assembly version
* `copyright`: The copyright to set
* `directory`: the directory where the assembly info file is located (or the top-most directory to search if `recursive` is `true`).  Defaults to '.\\'
* `filename`: the file name of the assembly info file.  Defaults to 'AssemblyInfo.cs'
* `recursive`: if `true`, updates all assembly info files matching the `filename` argument, in all subdirectories.  Defaults to `true`

### Output arguments

* `assembly_version`: Version set in AssemblyVersion
* `assembly_file_version`: Version set in AssemblyFileVersion

### Example Usage

#### Minimal example

```yml
- name: Set version in all AssemblyInfo.cs files
  uses: Yvand/assemblyinfo-update@v3
  with:
    version: '1.0.8'
```

#### Complete example

```yml
- name: Set version in .\Properties\SharedAssemblyInfo.cs
  id: set-assembly-version
  uses: Yvand/assemblyinfo-update@v3
  with:
    version: '2.1.16-alpha'
    directory: '.\Properties'
    filename: 'SharedAssemblyInfo.cs'
    recursive: false

- name: Display the versions set
  run: |
    echo "assembly_version: {{steps.set-assembly-version.outputs.assembly_version}}"
    echo "assembly_file_version: {{steps.set-assembly-version.outputs.assembly_file_version}}"
```

## Development Testing

This repo includes a test workflow - _.github/workflows/test-actions.yml_ - that is configured to run on each commit to the `develop` (and `main`) branch.  This workflow runs the latest code as a test, saving the updated sample files as artifacts, should the output need to be checked.
