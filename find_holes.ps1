Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Find dark hole centers in upper half (y < 200)
Write-Host "Dark pixels (holes) in upper half:"
for ($y = 50; $y -le 200; $y += 5) {
    for ($x = 200; $x -le 700; $x += 5) {
        $p = $b.GetPixel($x, $y)
        # Holes in transparent PNG might be transparent (A < 50) or very dark
        if ($p.A -lt 50) {
            # Check if surrounded by metal (metal above, below, left, right)
            $leftM = ($b.GetPixel($x - 40, $y).A -gt 200)
            $rightM = ($b.GetPixel($x + 40, $y).A -gt 200)
            if ($leftM -and $rightM) {
                Write-Host "Hole candidate at ($x, $y)"
            }
        }
    }
}
$b.Dispose()
