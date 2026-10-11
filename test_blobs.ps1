Add-Type -AssemblyName System.Drawing

function Paint-SmoothBlob {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$cx, [int]$cy, [int]$radiusX, [int]$radiusY,
        [int]$sampleX, [int]$sampleY
    )
    $w = $bmp.Width
    $h = $bmp.Height
    $refCol = $bmp.GetPixel([Math]::Min($w-1, [Math]::Max(0, $sampleX)), [Math]::Min($h-1, [Math]::Max(0, $sampleY)))

    for ($dy = -$radiusY; $dy -le $radiusY; $dy++) {
        $y = $cy + $dy
        if ($y -lt 0 -or $y -ge $h) { continue }
        $normY = $dy / [double]$radiusY

        for ($dx = -$radiusX; $dx -le $radiusX; $dx++) {
            $x = $cx + $dx
            if ($x -lt 0 -or $x -ge $w) { continue }
            $normX = $dx / [double]$radiusX

            $dist = [Math]::Sqrt($normX * $normX + $normY * $normY)
            if ($dist -ge 1.0) { continue }

            if ($dist -le 0.65) {
                $alpha = 1.0
            } else {
                $t = ($dist - 0.65) / 0.35
                $alpha = 0.5 * (1.0 + [Math]::Cos($t * [Math]::PI))
            }

            $p = $bmp.GetPixel($x, $y)
            if ($p.A -lt 80) { continue }

            $finalR = [int]($p.R * (1.0 - $alpha) + $refCol.R * $alpha)
            $finalG = [int]($p.G * (1.0 - $alpha) + $refCol.G * $alpha)
            $finalB = [int]($p.B * (1.0 - $alpha) + $refCol.B * $alpha)

            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $finalR, $finalG, $finalB))
        }
    }
}

$srcPath = "knd_sc_images/PC_200-SIDE-CUTTER.png"
$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

# Left piece: cover K, N, D
Paint-SmoothBlob -bmp $src -cx 140 -cy 135 -radiusX 40 -radiusY 35 -sampleX 245 -sampleY 135
Paint-SmoothBlob -bmp $src -cx 190 -cy 110 -radiusX 45 -radiusY 35 -sampleX 245 -sampleY 135

# Right piece: cover K, N, D
Paint-SmoothBlob -bmp $src -cx 420 -cy 130 -radiusX 45 -radiusY 35 -sampleX 365 -sampleY 150
Paint-SmoothBlob -bmp $src -cx 480 -cy 155 -radiusX 45 -radiusY 35 -sampleX 365 -sampleY 150

$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_pc200_blobs.jpg"
$src.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$src.Dispose()
Write-Host "Saved: $out"
