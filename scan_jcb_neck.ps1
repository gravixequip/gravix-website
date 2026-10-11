Add-Type -AssemblyName System.Drawing
$b2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

for ($x = 250; $x -le 350; $x += 10) {
    $p = $b2.GetPixel($x, 140)
    Write-Host ("x={0}: A={1}, RGB=({2},{3},{4})" -f $x, $p.A, $p.R, $p.G, $p.B)
}

$b2.Dispose()
