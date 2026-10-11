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
    if ($refCol.A -lt 100) {
        Write-Warning "Sample pixel at ($sampleX, $sampleY) is transparent!"
        return
    }

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

# 1. EX 200
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
Paint-SmoothSweepLine -bmp $bmp1 -x1 325 -y1 420 -x2 325 -y2 525 -radius 26 -sampleX 380 -sampleY 470
Paint-SmoothSweepLine -bmp $bmp1 -x1 620 -y1 450 -x2 625 -y2 545 -radius 28 -sampleX 560 -sampleY 480
$dest1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\bullseye_ex200.jpg"
$bmp1.Save($dest1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp1.Dispose()
Write-Host "Saved EX 200 bullseye: $dest1"

# 2. JCB DF
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
Paint-SmoothSweepLine -bmp $bmp2 -x1 330 -y1 95 -x2 345 -y2 210 -radius 28 -sampleX 280 -sampleY 160
Paint-SmoothSweepLine -bmp $bmp2 -x1 515 -y1 95 -x2 500 -y2 210 -radius 26 -sampleX 565 -sampleY 160
$dest2 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\bullseye_jcbdf.jpg"
$bmp2.Save($dest2, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp2.Dispose()
Write-Host "Saved JCB DF bullseye: $dest2"
