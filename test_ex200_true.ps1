Add-Type -AssemblyName System.Drawing

function Paint-SmoothSweepLine {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$x1, [int]$y1,
        [int]$x2, [int]$y2,
        [int]$radius,
        [int]$sampleX, [int]$sampleY
    )
    $w = $bmp.Width
    $h = $bmp.Height
    $refCol = $bmp.GetPixel([Math]::Min($w-1, [Math]::Max(0, $sampleX)), [Math]::Min($h-1, [Math]::Max(0, $sampleY)))

    $dist = [Math]::Sqrt([Math]::Pow($x2 - $x1, 2) + [Math]::Pow($y2 - $y1, 2))
    $steps = [Math]::Max(1, [int]($dist / 2))

    for ($i = 0; $i -le $steps; $i++) {
        $t = $i / [double]$steps
        $cx = [int]($x1 + ($x2 - $x1) * $t)
        $cy = [int]($y1 + ($y2 - $y1) * $t)

        for ($dy = -$radius; $dy -le $radius; $dy++) {
            $y = $cy + $dy
            if ($y -lt 0 -or $y -ge $h) { continue }
            $normY = $dy / [double]$radius

            for ($dx = -$radius; $dx -le $radius; $dx++) {
                $x = $cx + $dx
                if ($x -lt 0 -or $x -ge $w) { continue }
                $normX = $dx / [double]$radius

                $d = [Math]::Sqrt($normX * $normX + $normY * $normY)
                if ($d -ge 1.0) { continue }

                if ($d -le 0.40) {
                    $alpha = 1.0
                } else {
                    $u = ($d - 0.40) / 0.60
                    $alpha = 0.5 * (1.0 + [Math]::Cos($u * [Math]::PI))
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
}

$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
# Left piece text is at x = 370..405, y = 430..500
Paint-SmoothSweepLine -bmp $bmp1 -x1 385 -y1 430 -x2 390 -y2 505 -radius 22 -sampleX 360 -sampleY 420
# Right piece text is at x = 445..495, y = 430..500
Paint-SmoothSweepLine -bmp $bmp1 -x1 465 -y1 430 -x2 475 -y2 505 -radius 25 -sampleX 520 -sampleY 450

$out1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_true_ex200.jpg"
$bmp1.Save($out1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp1.Dispose()
Write-Host "Saved EX 200: $out1"
