Add-Type -AssemblyName System.Drawing

# 1. EX 200
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: text is at x=285..350, y=425..535. Clone from x+55 (340..405)
for ($y = 425; $y -le 535; $y++) {
    for ($x = 285; $x -le 350; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcP = $bmp1.GetPixel($x + 55, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 285) / 65.0
            $v = ($y - 425) / 110.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Right piece: text is at x=515..580, y=425..535. Clone from x-55 (460..525)
for ($y = 425; $y -le 535; $y++) {
    for ($x = 515; $x -le 580; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcP = $bmp1.GetPixel($x - 55, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 515) / 65.0
            $v = ($y - 425) / 110.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Render EX 200 to 1254x1254 canvas
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
$out1 = "assets/products/ex-200-side-cutter.jpeg"
$canvas1.Save($out1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas1.Dispose()
Write-Host "Generated: $out1"

# 2. JCB DF
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece neck: text at x=290..375, y=70..210. Clone from clean bevel at x-42, y+25
for ($y = 70; $y -le 210; $y++) {
    for ($x = 290; $x -le 375; $x++) {
        $orig = $bmp2.GetPixel($x, $y)
        $srcP = $bmp2.GetPixel($x - 42, $y + 25)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 290) / 85.0
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

# Right piece neck: text at x=490..565, y=70..210. Clone from clean bevel at x+42, y+25
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

# Render JCB DF to 1254x1254 canvas
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
$out2 = "assets/products/jcb-df-side-cutter.jpeg"
$canvas2.Save($out2, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas2.Dispose()
Write-Host "Generated: $out2"
