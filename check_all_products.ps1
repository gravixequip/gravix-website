$content = Get-Content "index.html" -Raw

$pattern = '<div class="product-card[^>]*data-category="([^"]+)"[^>]*>[\s\S]*?<img src="([^"]+)"[^>]*>[\s\S]*?<h3[^>]*>([^<]+)</h3>'
$matches = [regex]::Matches($content, $pattern)

Write-Host "Total products in index.html: $($matches.Count)"
foreach ($m in $matches) {
    Write-Host "- Category: $($m.Groups[1].Value) | Title: $($m.Groups[3].Value.Trim()) | Image: $($m.Groups[2].Value)"
}
