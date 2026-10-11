Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
for ($y = 52; $y -le 62; $y++) {
    $p = $bmp.GetPixel(312, $y)
    Write-Host ("y={0}: A={1} R={2} G={3} B={4}" -f $y, $p.A, $p.R, $p.G, $p.B)
}
$bmp.Dispose()
