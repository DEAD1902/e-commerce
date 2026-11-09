# Read-Only SQL Schema vs PHP Code Drift Extractor
param(
    [string]$SqlFile = "ecommerce (1).sql"
)

if (-not (Test-Path $SqlFile)) {
    Write-Error "SQL dump file not found: $SqlFile"
    exit 1
}

Write-Host "=== TABLES DEFINED IN SQL DUMP ===" -ForegroundColor Cyan
Select-String -Path $SqlFile -Pattern 'CREATE TABLE `([^`]+)`' | ForEach-Object {
    $_.Matches[0].Groups[1].Value
}

Write-Host "`n=== RELATIONS QUERIED IN WEB/ ===" -ForegroundColor Cyan
Get-ChildItem -Path "web" -Recurse -Include *.php,*.js |
    Where-Object { $_.FullName -notmatch 'vendor|plugins' } |
    Select-String -Pattern 'relations\?rel=[^"''&\s]+' |
    ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Matches[0].Value)" }

