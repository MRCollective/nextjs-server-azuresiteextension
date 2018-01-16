Write-Output "Installing next.js server site extension"
$wwwRoot = $env:WEBROOT_PATH
$deploymentFiles = Join-Path $PSScriptRoot files

Write-Output "Copying files from $deploymentFiles to $wwwRoot"
ls $deploymentFiles | Copy-Item -Destination $wwwRoot -Force

Write-Output "Running npm install in $wwwRoot"
cd $wwwRoot
npm install