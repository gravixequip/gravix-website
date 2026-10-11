Add-Type -AssemblyName System.Drawing

$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

Write-Host "Finding embossed features on EX 200 RIGHT piece..."
# Search right piece region x: 550..690, y: 420..530
for ($y = 420; $y -le 530; $y += 5) {
    $line = ""
    for ($x = 560; $x -le 680; $x += 4) {
        $p = $b.GetPixel($x, $y)
        $pRight = $b.GetPixel($x + 2, $y)
        $diff = [Math]::Abs($p.R - $pRight.R) + [Math]::Abs($p.G - $pRight.G) + [Math]::Abs($p.B - $pRight.B)
        if ($p.A -lt 100) {
            $line += " "
        } elseif ($diff -gt 16) {
            $line += "#"
        } else {
            $line += "."
        }
    }
    Write-Host ("y={0:D3}: {1}" -f $y, $line)
}

$b.Dispose()
