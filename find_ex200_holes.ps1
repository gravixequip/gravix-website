Add-Type -AssemblyName System.Drawing

$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

Write-Host "Finding hole centers in EX_200 (where alpha < 50):"
$holes = @()
for ($y = 200; $y -le 580; $y += 5) {
    for ($x = 200; $x -le 750; $x += 5) {
        if ($b.GetPixel($x, $y).A -lt 50) {
            # Check if surrounded by metal at distance 35 in 4 directions
            $top = ($b.GetPixel($x, [Math]::Max(0, $y - 30)).A -gt 150)
            $bot = ($b.GetPixel($x, [Math]::Min($b.Height - 1, $y + 30)).A -gt 150)
            $left = ($b.GetPixel([Math]::Max(0, $x - 30), $y).A -gt 150)
            $right = ($b.GetPixel([Math]::Min($b.Width - 1, $x + 30), $y).A -gt 150)
            if ($top -and $bot -and $left -and $right) {
                # Cluster with existing
                $found = $false
                foreach ($h in $holes) {
                    $d = [Math]::Sqrt([Math]::Pow($x - $h.X, 2) + [Math]::Pow($y - $h.Y, 2))
                    if ($d -lt 30) {
                        $found = $true
                        break
                    }
                }
                if (-not $found) {
                    $holes += @{ X = $x; Y = $y }
                    Write-Host "Hole at: ($x, $y)"
                }
            }
        }
    }
}
$b.Dispose()
