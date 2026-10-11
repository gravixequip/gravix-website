Add-Type -AssemblyName System.Drawing

# ==========================================
# 1. EX 200 SIDE CUTTER
# ==========================================
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: x = 295..330, y = 415..502 (Erase KND)
for ($y = 415; $y -le 502; $y++) {
    for ($x = 295; $x -le 330; $x++) {
        $srcX = [Math]::Max(0, $x - 24)
        $srcP = $bmp1.GetPixel($srcX, $y)
        $orig = $bmp1.GetPixel($x, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 295) / 35.0
            $v = ($y - 415) / 87.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.12
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $finR = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $finG = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $finB = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
        }
    }
}

# Right piece: x = 485..520, y = 415..502 (Erase KND)
for ($y = 415; $y -le 502; $y++) {
    for ($x = 485; $x -le 520; $x++) {
        $srcX = [Math]::Max(0, $x - 24)
        $srcP = $bmp1.GetPixel($srcX, $y)
        $orig = $bmp1.GetPixel($x, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 485) / 35.0
            $v = ($y - 415) / 87.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.12
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $finR = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $finG = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $finB = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
        }
    }
}

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

$outEx200 = "assets/products/ex-200-side-cutter.jpeg"
$c1.Save($outEx200, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c1.Dispose()
Write-Host "Updated: $outEx200"

# ==========================================
# 2. JCB DF SIDE CUTTER
# ==========================================
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece complete seamless erase
for ($y = 62; $y -le 180; $y++) {
    $t = ($y - 62) / 118.0
    $leftX = [int](300.0 - 32.0 * $t)
    $rightX = [int](326.0 - 32.0 * $t)

    $srcCol = if ($y -le 95) {
        $bmp2.GetPixel(312, 58)
    } else {
        $bmp2.GetPixel([int]($rightX + 10), $y)
    }

    for ($x = $leftX; $x -le $rightX; $x++) {
        $orig = $bmp2.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $distFromEdge = [Math]::Min($x - $leftX, $rightX - $x)
        $blend = if ($distFromEdge -ge 4) { 1.0 } else { $distFromEdge / 4.0 }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmp2.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Right piece complete seamless erase
for ($y = 85; $y -le 185; $y++) {
    $t = ($y - 85) / 100.0
    $leftX = [int](495.0 + 26.0 * $t)
    $rightX = [int](526.0 + 26.0 * $t)

    $srcX = [int]($leftX - 12)
    $srcCol = $bmp2.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) { continue }

    for ($x = $leftX; $x -le $rightX; $x++) {
        $orig = $bmp2.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $distFromEdge = [Math]::Min($x - $leftX, $rightX - $x)
        $blend = if ($distFromEdge -ge 4) { 1.0 } else { $distFromEdge / 4.0 }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmp2.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

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

$outJcbdf = "assets/products/jcb-df-side-cutter.jpeg"
$c2.Save($outJcbdf, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c2.Dispose()
Write-Host "Updated: $outJcbdf"
