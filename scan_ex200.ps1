Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

Write-Host "EX 200 Scanning Left Piece (350..430, y=420..500):"
for ($y = 430; $y -le 500; $y += 10) {
    $line = "$($y): "
    for ($x = 360; $x -le 430; $x += 3) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 100) { $line += " " }
        else {
            $b = [int]($p.R * 0.3 + $p.G * 0.59 + $p.B * 0.11)
            if ($b -gt 160) { $line += "#" }
            elseif ($b -lt 110) { $line += "." }
            else { $line += "-" }
        }
    }
    Write-Host $line
}

Write-Host "EX 200 Scanning Right Piece (580..660, y=420..500):"
for ($y = 430; $y -le 500; $y += 10) {
    $line = "$($y): "
    for ($x = 590; $x -le 660; $x += 3) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 100) { $line += " " }
        else {
            $b = [int]($p.R * 0.3 + $p.G * 0.59 + $p.B * 0.11)
            if ($b -gt 160) { $line += "#" }
            elseif ($b -lt 110) { $line += "." }
            else { $line += "-" }
        }
    }
    Write-Host $line
}

$bmp.Dispose()
