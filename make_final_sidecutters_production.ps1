Add-Type -AssemblyName System.Drawing

# ==============================================================================
# 1. EX 200
# ==============================================================================
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Clean left piece main text area
for ($y = 420; $y -le 540; $y++) {
    for ($x = 285; $x -le 350; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcP = $bmp1.GetPixel($x + 55, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 285) / 65.0
            $v = ($y - 420) / 120.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Clean left piece residual mark at (380..405, 460..500)
for ($y = 460; $y -le 500; $y++) {
    for ($x = 380; $x -le 405; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcP = $bmp1.GetPixel($x - 35, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 380) / 25.0
            $v = ($y - 460) / 40.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.20
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Crop clean patch from left piece: (280, 420, 80, 145)
$patch1 = new-object System.Drawing.Bitmap(80, 145)
$gP1 = [System.Drawing.Graphics]::FromImage($patch1)
$gP1.DrawImage($bmp1, [System.Drawing.Rectangle]::new(0, 0, 80, 145), [System.Drawing.Rectangle]::new(280, 420, 80, 145), [System.Drawing.GraphicsUnit]::Pixel)
$gP1.Dispose()

# Flip patch horizontally
$patch1.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

# Blend flipped clean patch onto right piece text zone at (580, 450)
for ($y = 0; $y -lt 145; $y++) {
    for ($x = 0; $x -lt 80; $x++) {
        $destX = 580 + $x
        $destY = 450 + $y
        $pOrig = $bmp1.GetPixel($destX, $destY)
        $pClean = $patch1.GetPixel($x, $y)

        if ($pOrig.A -gt 100 -and $pClean.A -gt 100) {
            $u = $x / 80.0
            $v = $y / 145.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($pOrig.R * (1.0 - $blend) + $pClean.R * $blend)
            $g = [int]($pOrig.G * (1.0 - $blend) + $pClean.G * $blend)
            $b = [int]($pOrig.B * (1.0 - $blend) + $pClean.B * $blend)
            $bmp1.SetPixel($destX, $destY, [System.Drawing.Color]::FromArgb($pOrig.A, $r, $g, $b))
        }
    }
}
$patch1.Dispose()

# Render EX 200 onto 1254x1254 pure white canvas
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
$canvas1.Save("assets/products/ex-200-side-cutter.jpeg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas1.Dispose()
Write-Host "Generated: assets/products/ex-200-side-cutter.jpeg"

# ==============================================================================
# 2. JCB DF
# ==============================================================================
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Clean right neck: (490..565, 70..210) from x+42, y+25
for ($y = 70; $y -le 210; $y++) {
    for ($x = 490; $x -le 565; $x++) {
        $orig = $bmp2.GetPixel($x, $y)
        $srcP = $bmp2.GetPixel($x + 42, $y + 25)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 490) / 75.0
            $v = ($y - 70) / 140.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp2.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Crop clean right neck patch: (480, 70, 85, 140)
$patch2 = new-object System.Drawing.Bitmap(85, 140)
$gP2 = [System.Drawing.Graphics]::FromImage($patch2)
$gP2.DrawImage($bmp2, [System.Drawing.Rectangle]::new(0, 0, 85, 140), [System.Drawing.Rectangle]::new(480, 70, 85, 140), [System.Drawing.GraphicsUnit]::Pixel)
$gP2.Dispose()

# Flip patch horizontally
$patch2.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

# Blend flipped clean patch onto left piece neck at (290, 70)
for ($y = 0; $y -lt 140; $y++) {
    for ($x = 0; $x -lt 85; $x++) {
        $destX = 290 + $x
        $destY = 70 + $y
        $pOrig = $bmp2.GetPixel($destX, $destY)
        $pClean = $patch2.GetPixel($x, $y)

        if ($pOrig.A -gt 100 -and $pClean.A -gt 100) {
            $u = $x / 85.0
            $v = $y / 140.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($pOrig.R * (1.0 - $blend) + $pClean.R * $blend)
            $g = [int]($pOrig.G * (1.0 - $blend) + $pClean.G * $blend)
            $b = [int]($pOrig.B * (1.0 - $blend) + $pClean.B * $blend)
            $bmp2.SetPixel($destX, $destY, [System.Drawing.Color]::FromArgb($pOrig.A, $r, $g, $b))
        }
    }
}
$patch2.Dispose()

# Render JCB DF onto 1254x1254 pure white canvas
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
$canvas2.Save("assets/products/jcb-df-side-cutter.jpeg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas2.Dispose()
Write-Host "Generated: assets/products/jcb-df-side-cutter.jpeg"
