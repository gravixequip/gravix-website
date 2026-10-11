$content = Get-Content index.html -Raw

$scCards = [regex]::Matches($content, 'class="product-card[^"]*"[^>]*data-category="side-cutters"').Count
$tpCards = [regex]::Matches($content, 'class="product-card[^"]*"[^>]*data-category="tooth-points"').Count
$adCards = [regex]::Matches($content, 'class="product-card[^"]*"[^>]*data-category="adaptors"').Count
$totalCards = [regex]::Matches($content, 'class="product-card[^"]*"').Count

Write-Host "Product Card Counts:"
Write-Host "  Tooth Points: $tpCards (Badge says 17)"
Write-Host "  Adaptors:     $adCards (Badge says 13)"
Write-Host "  Side Cutters: $scCards (Badge says 11)"
Write-Host "  Total:        $totalCards (Badge says 41)"
