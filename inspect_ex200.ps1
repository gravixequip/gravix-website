Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
Write-Host "EX 200 Left piece text area:"
for ($y = 430; $y -le 510; $y += 10) {
    $line = "$($y): "
    for ($x = 370; $x -le 430; $x += 5) {
        $p = $bmp.GetPixel($x, $y)
        $line += "$($p.R),$($p.G) "
    }
    Write-Host $line
}
$bmp.Dispose()
