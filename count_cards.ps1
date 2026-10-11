$content = Get-Content -Path "index.html" -Raw
$matches = [regex]::Matches($content, '<div class="product-card[^>]*data-category="([^"]+)"')
Write-Host "Matched Cards: $($matches.Count)"
$catCounts = @{}
foreach ($m in $matches) {
    $cat = $m.Groups[1].Value
    $catCounts[$cat] = $catCounts[$cat] + 1
}
$catCounts.GetEnumerator() | Format-Table -AutoSize
