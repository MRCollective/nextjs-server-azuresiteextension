$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Invoke-Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

Write-Output "$(Get-Date -Format u) Installing next.js server site extension"

$wwwRoot = $env:WEBROOT_PATH
$deploymentFiles = Join-Path $PSScriptRoot files

if (Test-Path (Join-Path $deploymentFiles "node_modules")) {
    Write-Output "$(Get-Date -Format u) Removing existing unzipped node_modules"
    try {
        cmd /c "rd /s /q $(Join-Path $deploymentFiles "node_modules")"
    } catch {
        Write-Output "WARNING: Error removing files: $_"
    }
}

Write-Output "$(Get-Date -Format u) Unzipping node_modules cache"
Invoke-Unzip (Join-Path $PSScriptRoot "node_modules.zip") $deploymentFiles

Write-Output "$(Get-Date -Format u) Copying files from $deploymentFiles to $wwwRoot"
ls $deploymentFiles | Copy-Item -Destination $wwwRoot -Force -Recurse

#Write-Output "Running npm install in $wwwRoot"
#cd $wwwRoot
#npm install

Write-Output "$(Get-Date -Format u) Finished installing next.js server site extension"