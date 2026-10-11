Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

for ($x = 360; $x -le 430; $x += 5) {
    $p = $bmp.GetPixel($x, 450)
    Write-Host ("x={0}: A={1} R={2} G={3} B={4}" -f $x, $p.A, $p.R, $p.G, $p.B)
}

Write-Host "--- Right Piece (y=450) ---"
for ($x = 600; $x -le 660; $x += 5) {
    $p = $bmp.GetPixel($x, 450)
    Write-Host ("x={0}: A={1} R={2} G={3} B={4}" -f $x, $p.A, $p.R, $p.G, $p.B)
}

$bmp.Dispose()
