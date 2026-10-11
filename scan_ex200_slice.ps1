Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

Write-Host "EX 200 Left Piece scan at y=460:"
for ($x = 330; $x -le 460; $x += 10) {
    $p = $b.GetPixel($x, 460)
    Write-Host ("x={0}: A={1}, RGB=({2},{3},{4})" -f $x, $p.A, $p.R, $p.G, $p.B)
}

Write-Host "`nEX 200 Right Piece scan at y=460:"
for ($x = 540; $x -le 670; $x += 10) {
    $p = $b.GetPixel($x, 460)
    Write-Host ("x={0}: A={1}, RGB=({2},{3},{4})" -f $x, $p.A, $p.R, $p.G, $p.B)
}

$b.Dispose()
