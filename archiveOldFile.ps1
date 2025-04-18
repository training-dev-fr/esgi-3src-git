param (
    [Parameter(Mandatory = $true)]
    [string]$Path
)

if (-Not (Test-Path -Path $Path)) {
    Write-Host "Le dossier est introuvable"
    exit 1
}

$tempFolder = Join-Path $Path "tmp-" (Get-Date --format "dd-MM-YYY")
if (-Not (Test-Path -Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder | Out-Null
}

$thresholdDate = (Get-Date).AddDays(-7)

Get-ChildItem -Path $Path -File | Where-Object {
    $_.LastWriteTime -lt $thresholdDate
} | ForEach-Object {
    $destination = Join-Path $tempFolder $_.Name
    Move-Item -Path $_.FullName -Destination $destination
    Write-Host "Fichier déplacé : $($_.Name)"
}