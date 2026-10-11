Add-Type -AssemblyName System.Drawing
$b2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

Write-Host "JCB DF Right Piece scan at y=170:"
for ($x = 550; $x -le 720; $x += 10) {
    $p = $b2.GetPixel($x, 170)
    Write-Host ("x={0}: A={1}, RGB=({2},{3},{4})" -f $x, $p.A, $p.R, $p.G, $p.B)
}

Write-Host "`nJCB DF Right Piece scan at y=210:"
for ($x = 550; $x -le 720; $x += 10) {
    $p = $b2.GetPixel($x, 210)
    Write-Host ("x={0}: A={1}, RGB=({2},{3},{4})" -f $x, $p.A, $p.R, $p.G, $p.B)
}

$b2.Dispose()
