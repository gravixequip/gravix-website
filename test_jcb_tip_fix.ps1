Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece: y from 62 to 185
for ($y = 62; $y -le 185; $y++) {
    if ($y -le 88) {
        # Top neck tip: center is x=311 at y=62 down to x=305 at y=88
        $t = ($y - 62) / 26.0
        $xc = 311.0 - 6.0 * $t
        $radius = 11.0
        # Sample from smooth metal just above (y=58) or right (xc + 12)
        for ($dx = -$radius; $dx -le $radius; $dx++) {
            $x = [int]($xc + $dx)
            $orig = $bmpJcb.GetPixel($x, $y)
            if ($orig.A -lt 150) { continue }

            # Reference pixel from y=58 at matching relative x position
            $refX = [Math]::Min(323, [Math]::Max(300, $x))
            $refP = $bmpJcb.GetPixel($refX, 58)

            $norm = [Math]::Abs($dx) / $radius
            $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

            $finR = [int]($orig.R * (1.0 - $blend) + $refP.R * $blend)
            $finG = [int]($orig.G * (1.0 - $blend) + $refP.G * $blend)
            $finB = [int]($orig.B * (1.0 - $blend) + $refP.B * $blend)
            $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
        }
    } else {
        # Lower neck: y from 89 to 185
        $t = ($y - 89) / 96.0
        $xc = 305.0 - 32.0 * $t
        $srcX = [int]($xc + 22)
        $srcCol = $bmpJcb.GetPixel($srcX, $y)
        if ($srcCol.A -lt 150) {
            $srcX = [int]($xc - 18)
            $srcCol = $bmpJcb.GetPixel($srcX, $y)
        }
        if ($srcCol.A -lt 150) { continue }

        $radius = 15.0
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

$outJcb = "assets/products/jcb-df-side-cutter.jpeg"
$c2.Save($outJcb, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c2.Dispose()
Write-Host "Updated: $outJcb"
