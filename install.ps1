$ErrorActionPreference = "Stop"

$AppName = "Graphite Helper"
$Repo = "zahlio/graphite-helper-releases"

Write-Host "Installing $AppName..."

# Fetch latest release version
Write-Host "Fetching latest release..."
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Repo/releases/latest"
$version = $release.tag_name -replace '^v', ''

if (-not $version) {
    Write-Host "Error: Could not determine latest version."
    exit 1
}

Write-Host "Latest version: v$version"

# Download installer
$installerUrl = "https://github.com/$Repo/releases/download/v$version/Graphite-Helper-Setup-$version.exe"
$tempInstaller = Join-Path $env:TEMP "Graphite-Helper-Setup.exe"

Write-Host "Downloading $installerUrl..."
Invoke-WebRequest -Uri $installerUrl -OutFile $tempInstaller

# Run installer silently
Write-Host "Running installer..."
Start-Process -FilePath $tempInstaller -ArgumentList "/S" -Wait

# Clean up
Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue

Write-Host "Done! $AppName v$version installed successfully."
