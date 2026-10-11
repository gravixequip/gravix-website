Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/CAT_424-SIDE-CUTTER.png").Path)

Write-Host "Right piece letter search (CAT 424):"
for ($y = 120; $y -le 350; $y += 10) {
    $line = "$($y.ToString('D3')): "
    for ($x = 550; $x -le 720; $x += 4) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 100) {
            $line += " "
        } else {
            $b = [int]($p.R * 0.3 + $p.G * 0.59 + $p.B * 0.11)
            if ($b -gt 160) { $line += "#" }
            elseif ($b -lt 110) { $line += "." }
            else { $line += "-" }
        }
    }
    Write-Host $line
}

$bmp.Dispose()
