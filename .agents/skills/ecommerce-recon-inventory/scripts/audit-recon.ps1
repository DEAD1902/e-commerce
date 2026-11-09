# Read-Only Reconnaissance & Hardcoded Config Scanner for E-Commerce Workspace
param(
    [string]$WorkspaceRoot = (Get-Location).Path
)

Write-Host "=== 1. TOP-LEVEL DIRECTORIES & FILES ===" -ForegroundColor Cyan
Get-ChildItem -Path $WorkspaceRoot -Force | Select-Object Name, Mode, Length

Write-Host "`n=== 2. ENTRY POINTS & ROUTING (.htaccess / index.php) ===" -ForegroundColor Cyan
Get-ChildItem -Path "$WorkspaceRoot\api","$WorkspaceRoot\web" -Recurse -Include *.php,.htaccess -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch 'vendor' } |
    Select-String -Pattern 'RewriteRule|REQUEST_URI|REQUEST_METHOD|session_start' |
    ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }

Write-Host "`n=== 3. HARDCODED URLS, PATHS & CONFIGS ===" -ForegroundColor Cyan
Get-ChildItem -Path "$WorkspaceRoot\api","$WorkspaceRoot\web" -Recurse -Include *.php,*.js -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch 'vendor|plugins' } |
    Select-String -Pattern 'http://api\.|https://api|error_log|infoDatabase|apikey\(' |
    ForEach-Object { "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }

