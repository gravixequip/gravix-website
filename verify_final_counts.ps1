$content = Get-Content -Path "index.html" -Raw
$allCards = ([regex]::Matches($content, 'class="product-card ')).Count
$sideCutters = ([regex]::Matches($content, 'data-category="side-cutters"')).Count
$adapters = ([regex]::Matches($content, 'data-category="adapters"')).Count
$toothPoints = ([regex]::Matches($content, 'data-category="tooth-points"')).Count

Write-Host "=============================="
Write-Host "Total Product Cards : $allCards"
Write-Host "Side Cutters        : $sideCutters"
Write-Host "Tooth Points        : $toothPoints"
Write-Host "Adapters            : $adapters"
Write-Host "Sum of categories   : $($sideCutters + $toothPoints + $adapters)"
Write-Host "=============================="
