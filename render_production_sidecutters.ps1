Add-Type -AssemblyName System.Drawing

# ==========================================
# 1. PROCESS EX 200 SIDE CUTTER
# ==========================================
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: x = 295..330, y = 415..502
for ($y = 415; $y -le 502; $y++) {
    for ($x = 295; $x -le 330; $x++) {
        $srcX = [Math]::Max(0, $x - 24)
        $srcP = $bmpEx.GetPixel($srcX, $y)
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 295) / 35.0
            $v = ($y - 415) / 87.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.12
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $finR = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $finG = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $finB = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
        }
    }
}

# Right piece: x = 485..520, y = 415..502
for ($y = 415; $y -le 502; $y++) {
    for ($x = 485; $x -le 520; $x++) {
        $srcX = [Math]::Max(0, $x - 24)
        $srcP = $bmpEx.GetPixel($srcX, $y)
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 485) / 35.0
            $v = ($y - 415) / 87.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.12
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $finR = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $finG = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $finB = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
        }
    }
}

# Canvas 1254x1254
$c1 = [System.Drawing.Bitmap]::new(1254, 1254)
$g1 = [System.Drawing.Graphics]::FromImage($c1)
$g1.Clear([System.Drawing.Color]::White)
$g1.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$scale1 = [Math]::Min(1020 / $bmpEx.Width, 820 / $bmpEx.Height)
$drawW1 = [int]($bmpEx.Width * $scale1)
$drawH1 = [int]($bmpEx.Height * $scale1)
$posX1 = [int]((1254 - $drawW1) / 2)
$posY1 = [int](130 + (820 - $drawH1) / 2)
$g1.DrawImage($bmpEx, $posX1, $posY1, $drawW1, $drawH1)

$fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
$fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))
$sf = [System.Drawing.StringFormat]::new()
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center
$g1.DrawString("EX 200", $fontTitle, $brush, 627, 1070, $sf)
$g1.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)
$g1.Dispose()
$bmpEx.Dispose()

$outEx = "assets/products/ex-200-side-cutter.jpeg"
$c1.Save($outEx, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c1.Dispose()
Write-Host "Updated: $outEx"


# ==========================================
# 2. PROCESS JCB DF SIDE CUTTER
# ==========================================
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece: y from 65 to 185
for ($y = 65; $y -le 185; $y++) {
    $t = ($y - 65) / 120.0
    $xc = 322.0 - 47.0 * $t
    $srcX = [int]($xc + 22)
    $srcCol = $bmpJcb.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) {
        $srcX = [int]($xc - 18)
        $srcCol = $bmpJcb.GetPixel($srcX, $y)
    }
    if ($srcCol.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int]($xc + $dx)
        if ($x -lt 0 -or $x -ge $bmpJcb.Width) { continue }
        $orig = $bmpJcb.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)
        $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Right piece: y from 85 to 190
for ($y = 85; $y -le 190; $y++) {
    $t = ($y - 85) / 105.0
    $xc = 505.0 + 25.0 * $t
    $srcX = [int]($xc - 22)
    $srcCol = $bmpJcb.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int]($xc + $dx)
        if ($x -lt 0 -or $x -ge $bmpJcb.Width) { continue }
        $orig = $bmpJcb.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)
        $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Canvas 1254x1254
$c2 = [System.Drawing.Bitmap]::new(1254, 1254)
$g2 = [System.Drawing.Graphics]::FromImage($c2)
$g2.Clear([System.Drawing.Color]::White)
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g2.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g2.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$scale2 = [Math]::Min(1020 / $bmpJcb.Width, 820 / $bmpJcb.Height)
$drawW2 = [int]($bmpJcb.Width * $scale2)
$drawH2 = [int]($bmpJcb.Height * $scale2)
$posX2 = [int]((1254 - $drawW2) / 2)
$posY2 = [int](130 + (820 - $drawH2) / 2)
$g2.DrawImage($bmpJcb, $posX2, $posY2, $drawW2, $drawH2)

$g2.DrawString("JCB DF", $fontTitle, $brush, 627, 1070, $sf)
$g2.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)
$g2.Dispose()
$bmpJcb.Dispose()

$outJcb = "assets/products/jcb-df-side-cutter.jpeg"
$c2.Save($outJcb, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c2.Dispose()
Write-Host "Updated: $outJcb"
