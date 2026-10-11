Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"

# 1. PROCESS JCB DF
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece: y from 68 to 180
for ($y = 68; $y -le 180; $y++) {
    $t = ($y - 68) / 112.0
    # xc goes from 322 at y=68 down to 275 at y=180
    $xc = 322.0 - 47.0 * $t
    
    # Try sampling from right (+22), if not valid metal try left (-20)
    $srcX = [int]($xc + 22)
    $srcCol = $bmpJcb.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) {
        $srcX = [int]($xc - 20)
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
    # xc goes from 505 at y=85 to 530 at y=190
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

# Render JCB DF onto 1254x1254
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

$fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
$fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))
$sf = [System.Drawing.StringFormat]::new()
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center
$g2.DrawString("JCB DF", $fontTitle, $brush, 627, 1070, $sf)
$g2.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)
$g2.Dispose()
$bmpJcb.Dispose()
$c2.Save("$cropDir/test_jcb_final.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c2.Dispose()

# 2. PROCESS EX 200
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: y from 415 to 515, xc = 388, clean metal at x = 368
for ($y = 415; $y -le 515; $y++) {
    $srcCol = $bmpEx.GetPixel(368, $y)
    if ($srcCol.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int](388 + $dx)
        if ($x -lt 0 -or $x -ge $bmpEx.Width) { continue }
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Right piece: y from 425 to 525, xc = 633, clean metal at x = 610
for ($y = 425; $y -le 525; $y++) {
    $srcCol = $bmpEx.GetPixel(610, $y)
    if ($srcCol.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int](633 + $dx)
        if ($x -lt 0 -or $x -ge $bmpEx.Width) { continue }
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Render EX 200 onto 1254x1254
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

$g1.DrawString("EX 200", $fontTitle, $brush, 627, 1070, $sf)
$g1.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)
$g1.Dispose()
$bmpEx.Dispose()
$c1.Save("$cropDir/test_ex200_final.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c1.Dispose()

Write-Host "Both test final images saved successfully."
