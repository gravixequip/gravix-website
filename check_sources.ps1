Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
Write-Host "EX 200: Right piece metal check at y=470:"
for ($x = 420; $x -le 720; $x += 20) {
    $p = $b.GetPixel($x, 470)
    Write-Host ("x={0}: A={1}, RGB=({2},{3},{4})" -f $x, $p.A, $p.R, $p.G, $p.B)
}
$b.Dispose()

$b2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
Write-Host "JCB DF: Left piece metal check at y=130:"
for ($x = 180; $x -le 350; $x += 15) {
    $p = $b2.GetPixel($x, 130)
    Write-Host ("x={0}: A={1}, RGB=({2},{3},{4})" -f $x, $p.A, $p.R, $p.G, $p.B)
}
$b2.Dispose()
