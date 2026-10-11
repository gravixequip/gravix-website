Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

Write-Host "--- Scanning Left Piece Letter Relief (Brightness) ---"
# Letters are embossed shadows/highlights, so let's output character map of brightness
for ($y = 420; $y -le 520; $y += 4) {
    $line = ""
    for ($x = 360; $x -le 440; $x += 2) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 50) {
            $line += " "
        } else {
            # Brightness 0-255
            $b = [int]($p.R * 0.3 + $p.G * 0.59 + $p.B * 0.11)
            # Map into symbols: highlight (*), shadow (#), flat (.)
            if ($b -gt 150) { $line += "*" }
            elseif ($b -lt 115) { $line += "#" }
            else { $line += "." }
        }
    }
    Write-Host ("y={0:D3}: {1}" -f $y, $line)
}

Write-Host "`n--- Scanning Right Piece Letter Relief (Brightness) ---"
for ($y = 420; $y -le 520; $y += 4) {
    $line = ""
    for ($x = 600; $x -le 680; $x += 2) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 50) {
            $line += " "
        } else {
            $b = [int]($p.R * 0.3 + $p.G * 0.59 + $p.B * 0.11)
            if ($b -gt 160) { $line += "*" }
            elseif ($b -lt 120) { $line += "#" }
            else { $line += "." }
        }
    }
    Write-Host ("y={0:D3}: {1}" -f $y, $line)
}

$bmp.Dispose()
