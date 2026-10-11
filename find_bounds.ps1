Add-Type -AssemblyName System.Drawing

function Find-MetalBounds {
    param([string]$fileName)
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path ("knd_sc_images/" + $fileName)).Path)
    $w = $bmp.Width
    $h = $bmp.Height
    
    # Left half vs Right half
    $midX = [int]($w / 2)
    
    $minLx = $w; $maxLx = 0; $minLy = $h; $maxLy = 0
    $minRx = $w; $maxRx = 0; $minRy = $h; $maxRy = 0
    
    for ($y = 0; $y -lt $h; $y++) {
        for ($x = 0; $x -lt $w; $x++) {
            $p = $bmp.GetPixel($x, $y)
            if ($p.A -gt 100 -and $p.R -gt 100) {
                if ($x -lt $midX) {
                    if ($x -lt $minLx) { $minLx = $x }
                    if ($x -gt $maxLx) { $maxLx = $x }
                    if ($y -lt $minLy) { $minLy = $y }
                    if ($y -gt $maxLy) { $maxLy = $y }
                } else {
                    if ($x -lt $minRx) { $minRx = $x }
                    if ($x -gt $maxRx) { $maxRx = $x }
                    if ($y -lt $minRy) { $minRy = $y }
                    if ($y -gt $maxRy) { $maxRy = $y }
                }
            }
        }
    }
    $bmp.Dispose()
    Write-Host "$fileName :"
    Write-Host "  Left piece bounds:  X=[$minLx..$maxLx], Y=[$minLy..$maxLy], Width=$($maxLx-$minLx), Height=$($maxLy-$minLy)"
    Write-Host "  Right piece bounds: X=[$minRx..$maxRx], Y=[$minRy..$maxRy], Width=$($maxRx-$minRx), Height=$($maxRy-$minRy)"
}

$files = @(
    'CAT_424-SIDE-CUTTER.png',
    'EX_100-SIDE-CUTTER.png',
    'EX_200-SIDE-CUTTER.png',
    'EX_60-SIDE-CUTTER.png',
    'HM_3036-SIDE-CUTTER.png',
    'JCB-DF-SIDE-CUTTER.png',
    'PC_200-SIDE-CUTTER.png',
    'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png'
)

foreach ($f in $files) {
    Find-MetalBounds -fileName $f
}
