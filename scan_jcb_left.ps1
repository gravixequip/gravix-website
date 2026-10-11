Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

Write-Host "--- Scanning JCB Left Neck (y=65 to 110) ---"
for ($y = 65; $y -le 110; $y += 5) {
    # Scan across x=280 to 350
    $line = ""
    for ($x = 280; $x -le 350; $x += 5) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 50) { $line += "  . " }
        else { $line += ("{0:D2} " -f ($p.R / 10)) }
    }
    Write-Host ("y={0:D3}: {1}" -f $y, $line)
}

$bmp.Dispose()
