# download_catsolo.ps1

$RepoUrl = "https://github.com/dima3000999301-rgb/image/archive/refs/heads/main.zip"
$TempZip = "$env:TEMP\image-repo.zip"
$TempExtract = "$env:TEMP\image-extract"
$TargetDir = "C:\Cat Solo"

Write-Host "=== Downloading repository ===" -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $RepoUrl -OutFile $TempZip -UseBasicParsing
    Write-Host "Repository downloaded" -ForegroundColor Green
}
catch {
    Write-Host "Download error: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "`n=== Extracting archive ===" -ForegroundColor Cyan
try {
    Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force
    Write-Host "Archive extracted" -ForegroundColor Green
}
catch {
    Write-Host "Extract error: $_" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

$ExtractedFolder = Get-ChildItem -Path $TempExtract -Directory | Select-Object -First 1
$SourceFolder = Join-Path $ExtractedFolder.FullName "Cat Solo"

Write-Host "`n=== Looking for 'Cat Solo' folder ===" -ForegroundColor Cyan
if (Test-Path $SourceFolder) {
    Write-Host "Folder found: $SourceFolder" -ForegroundColor Green
    
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    }
    
    Write-Host "`n=== Copying to $TargetDir ===" -ForegroundColor Cyan
    Copy-Item -Path "$SourceFolder\*" -Destination $TargetDir -Recurse -Force
    Write-Host "Folder 'Cat Solo' copied to $TargetDir" -ForegroundColor Green
}
else {
    Write-Host "Folder 'Cat Solo' not found!" -ForegroundColor Red
    Write-Host "`nAvailable folders in extracted archive:" -ForegroundColor Yellow
    Get-ChildItem -Path $ExtractedFolder.FullName -Directory | ForEach-Object { Write-Host "  - $($_.Name)" }
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "`n=== Cleaning up ===" -ForegroundColor Cyan
Remove-Item -Path $TempZip -Force -ErrorAction SilentlyContinue
Remove-Item -Path $TempExtract -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Temporary files removed" -ForegroundColor Green

Write-Host "`n=== Done! ===" -ForegroundColor Green
Write-Host "Folder 'Cat Solo' installed to: $TargetDir" -ForegroundColor Yellow
Read-Host "Press Enter to finish"