Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/CAT_424-SIDE-CUTTER.png").Path)

# Let's inspect rows y from 120 to 280, x from 140 to 320
Write-Host "Left piece letter search (CAT 424):"
for ($y = 120; $y -le 280; $y += 10) {
    $line = "$($y.ToString('D3')): "
    for ($x = 160; $x -le 320; $x += 4) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 100) {
            $line += " "
        } else {
            # Let's see brightness or difference from median yellow
            $b = [int]($p.R * 0.3 + $p.G * 0.59 + $p.B * 0.11)
            if ($b -gt 160) { $line += "#" }
            elseif ($b -lt 110) { $line += "." }
            else { $line += "-" }
        }
    }
    Write-Host $line
}

$bmp.Dispose()
