Add-Type -AssemblyName System.Drawing

function Paint-SeamlessGradientSweep {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$x1, [int]$y1,
        [int]$x2, [int]$y2,
        [int]$radius,
        [int]$sampleOffsetX # X offset relative to current X to sample clean metal
    )
    $w = $bmp.Width
    $h = $bmp.Height

    $dist = [Math]::Sqrt([Math]::Pow($x2 - $x1, 2) + [Math]::Pow($y2 - $y1, 2))
    $steps = [Math]::Max(1, [int]($dist / 2))

    for ($i = 0; $i -le $steps; $i++) {
        $t = $i / [double]$steps
        $cx = [int]($x1 + ($x2 - $x1) * $t)
        $cy = [int]($y1 + ($y2 - $y1) * $t)

        # Dynamic sample pixel at the SAME Y but offset X
        $sx = [Math]::Min($w - 1, [Math]::Max(0, $cx + $sampleOffsetX))
        $refCol = $bmp.GetPixel($sx, $cy)
        if ($refCol.A -lt 150) { continue }

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

                # Cosine soft feather
                $alpha = if ($d -le 0.40) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($d - 0.40) / 0.60) * [Math]::PI)) }

                $p = $bmp.GetPixel($x, $y)
                if ($p.A -lt 80) { continue }

                # Dynamic row color from the same horizontal slice
                $rowSample = $bmp.GetPixel($sx, $y)
                $targetR = if ($rowSample.A -gt 150) { $rowSample.R } else { $refCol.R }
                $targetG = if ($rowSample.A -gt 150) { $rowSample.G } else { $refCol.G }
                $targetB = if ($rowSample.A -gt 150) { $rowSample.B } else { $refCol.B }

                $finalR = [int]($p.R * (1.0 - $alpha) + $targetR * $alpha)
                $finalG = [int]($p.G * (1.0 - $alpha) + $targetG * $alpha)
                $finalB = [int]($p.B * (1.0 - $alpha) + $targetB * $alpha)

                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $finalR, $finalG, $finalB))
            }
        }
    }
}

# 1. EX 200
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
# Left piece: KND is at x=330..335, y=430..510. Sample offset: x - 40
Paint-SeamlessGradientSweep -bmp $bmp1 -x1 330 -y1 430 -x2 335 -y2 510 -radius 22 -sampleOffsetX -38
# Right piece: KND is at x=535..530, y=430..515. Sample offset: x - 45
Paint-SeamlessGradientSweep -bmp $bmp1 -x1 535 -y1 430 -x2 530 -y2 515 -radius 22 -sampleOffsetX -45

$c1 = [System.Drawing.Bitmap]::new(1254, 1254)
$g1 = [System.Drawing.Graphics]::FromImage($c1)
$g1.Clear([System.Drawing.Color]::White)
$g1.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$scale1 = [Math]::Min(1020 / $bmp1.Width, 820 / $bmp1.Height)
$drawW1 = [int]($bmp1.Width * $scale1)
$drawH1 = [int]($bmp1.Height * $scale1)
$posX1 = [int]((1254 - $drawW1) / 2)
$posY1 = [int](130 + (820 - $drawH1) / 2)
$g1.DrawImage($bmp1, $posX1, $posY1, $drawW1, $drawH1)

$fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
$fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))
$sf = [System.Drawing.StringFormat]::new()
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center
$g1.DrawString("EX 200", $fontTitle, $brush, 627, 1070, $sf)
$g1.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)
$g1.Dispose()
$bmp1.Dispose()
$outEx200 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\seamless_ex200.jpg"
$c1.Save($outEx200, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c1.Dispose()
Write-Host "Saved EX 200: $outEx200"

# 2. JCB DF
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
# Left piece neck: KND at x=295..290, y=105..205. Sample offset: x - 35
Paint-SeamlessGradientSweep -bmp $bmp2 -x1 295 -y1 105 -x2 290 -y2 205 -radius 22 -sampleOffsetX -35
# Right piece neck: KND at x=560..565, y=105..195. Sample offset: x - 30
Paint-SeamlessGradientSweep -bmp $bmp2 -x1 560 -y1 105 -x2 565 -y2 195 -radius 20 -sampleOffsetX -30

$c2 = [System.Drawing.Bitmap]::new(1254, 1254)
$g2 = [System.Drawing.Graphics]::FromImage($c2)
$g2.Clear([System.Drawing.Color]::White)
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$scale2 = [Math]::Min(1020 / $bmp2.Width, 820 / $bmp2.Height)
$drawW2 = [int]($bmp2.Width * $scale2)
$drawH2 = [int]($bmp2.Height * $scale2)
$posX2 = [int]((1254 - $drawW2) / 2)
$posY2 = [int](130 + (820 - $drawH2) / 2)
$g2.DrawImage($bmp2, $posX2, $posY2, $drawW2, $drawH2)

$g2.DrawString("JCB DF", $fontTitle, $brush, 627, 1070, $sf)
$g2.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)
$g2.Dispose()
$bmp2.Dispose()
$outJcbdf = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\seamless_jcbdf.jpg"
$c2.Save($outJcbdf, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c2.Dispose()
Write-Host "Saved JCB DF: $outJcbdf"
