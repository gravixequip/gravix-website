Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Find where the holes are on left piece:
# Holes are transparent (A < 50) or white (R>240, G>240, B>240)
Write-Host "--- Scanning Left Piece Holes ---"
for ($y = 300; $y -lt 550; $y += 20) {
    $line = ""
    for ($x = 250; $x -lt 500; $x += 10) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -lt 50 -or ($p.R -gt 240 -and $p.G -gt 240 -and $p.B -gt 240)) {
            $line += "O"
        } elseif ($p.R -gt 150 -and $p.G -gt 100) {
            $line += "."
        } else {
            $line += "X"
        }
    }
    Write-Host ("y={0:D3}: {1}" -f $y, $line)
}

$bmp.Dispose()
