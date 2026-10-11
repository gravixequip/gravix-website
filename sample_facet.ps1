Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/CAT_424-SIDE-CUTTER.png").Path)

Write-Host "Sampling Left Facet Colors:"
for ($x = 200; $x -le 300; $x += 20) {
    for ($y = 160; $y -le 320; $y += 30) {
        $c = $bmp.GetPixel($x, $y)
        Write-Host "($x, $y): R=$($c.R), G=$($c.G), B=$($c.B)"
    }
}
$bmp.Dispose()
