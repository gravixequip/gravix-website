Add-Type -AssemblyName System.Drawing
$b2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

for ($y = 100; $y -le 160; $y += 20) {
    for ($x = 320; $x -le 380; $x += 20) {
        $p = $b2.GetPixel($x, $y)
        $msg = "Pixel at ($x, $y): A=" + $p.A + " RGB=(" + $p.R + "," + $p.G + "," + $p.B + ")"
        Write-Host $msg
    }
}

$b2.Dispose()
