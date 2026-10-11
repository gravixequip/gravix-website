Add-Type -AssemblyName System.Drawing

# 1. Process EX 200
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: KND is at x=375..420, y=430..515.
# Source clean metal is at x=415..450 or from y-80 (350..420)
# Let's clone from x+30 (410..450) and blend:
for ($y = 425; $y -le 520; $y++) {
    for ($x = 375; $x -le 420; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        # Source pixel from adjacent smooth metal at x + 28
        $srcX = [Math]::Min($bmp1.Width - 1, $x + 28)
        $srcP = $bmp1.GetPixel($srcX, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 375) / 45.0
            $v = ($y - 425) / 95.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Right piece: KND is at x=595..645, y=425..520.
# Source clean metal is to the left at x - 45 (550..600)
for ($y = 420; $y -le 525; $y++) {
    for ($x = 595; $x -le 645; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcX = [Math]::Max(0, $x - 45)
        $srcP = $bmp1.GetPixel($srcX, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 595) / 50.0
            $v = ($y - 420) / 105.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Render EX 200 onto 1254x1254 white canvas
$canvas1 = [System.Drawing.Bitmap]::new(1254, 1254)
$g1 = [System.Drawing.Graphics]::FromImage($canvas1)
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
$outEx200 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\flawless_ex200.jpg"
$canvas1.Save($outEx200, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas1.Dispose()
Write-Host "Saved EX 200: $outEx200"

# 2. Process JCB DF
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece: KND is on neck at x=315..360, y=95..215.
# Source clean metal is on the right of the neck at x + 40 (355..400)
for ($y = 95; $y -le 215; $y++) {
    for ($x = 315; $x -le 360; $x++) {
        $orig = $bmp2.GetPixel($x, $y)
        $srcX = [Math]::Min($bmp2.Width - 1, $x + 42)
        $srcP = $bmp2.GetPixel($srcX, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 315) / 45.0
            $v = ($y - 95) / 120.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp2.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Render JCB DF onto 1254x1254 white canvas
$canvas2 = [System.Drawing.Bitmap]::new(1254, 1254)
$g2 = [System.Drawing.Graphics]::FromImage($canvas2)
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
$outJcbdf = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\flawless_jcbdf.jpg"
$canvas2.Save($outJcbdf, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas2.Dispose()
Write-Host "Saved JCB DF: $outJcbdf"
