$content = Get-Content -Path "index.html" -Raw
$matches = [regex]::Matches($content, '<img[^>]+src="([^">]+)"')
$missing = @()
$found = 0
foreach ($m in $matches) {
    $src = $m.Groups[1].Value
    if ($src -match '^http') { continue }
    if (Test-Path $src) {
        $found++
    } else {
        $missing += $src
    }
}
Write-Host "Found local images: $found"
if ($missing.Count -gt 0) {
    Write-Host "MISSING IMAGES: $($missing.Count)"
    $missing | ForEach-Object { Write-Host " - $_" }
} else {
    Write-Host "ALL $found LOCAL IMAGES EXIST AND RESOLVE PERFECTLY!"
}
