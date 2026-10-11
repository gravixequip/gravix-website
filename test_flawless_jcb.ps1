Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# 1. Left piece complete seamless erase
for ($y = 65; $y -le 180; $y++) {
    $t = ($y - 65) / 115.0
    # Left and right bounds of the letter groove:
    $leftX = [int](298.0 - 32.0 * $t)
    $rightX = [int](324.0 - 32.0 * $t)

    # Reference column of clean metal to the right
    $srcX = [int]($rightX + 10)
    $srcCol = $bmpJcb.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) {
        $srcX = [int]($leftX - 8)
        $srcCol = $bmpJcb.GetPixel($srcX, $y)
    }
    if ($srcCol.A -lt 150) {
        # Fallback to y-5
        $srcCol = $bmpJcb.GetPixel([Math]::Min(322, $rightX), [Math]::Max(60, $y - 6))
    }

    $w = $rightX - $leftX
    for ($x = $leftX; $x -le $rightX; $x++) {
        $orig = $bmpJcb.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        # Taper 3 pixels at edges
        $distFromEdge = [Math]::Min($x - $leftX, $rightX - $x)
        $blend = if ($distFromEdge -ge 4) { 1.0 } else { $distFromEdge / 4.0 }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# 2. Right piece complete seamless erase
for ($y = 85; $y -le 185; $y++) {
    $t = ($y - 85) / 100.0
    $leftX = [int](495.0 + 26.0 * $t)
    $rightX = [int](526.0 + 26.0 * $t)

    # Reference column of clean metal to the left
    $srcX = [int]($leftX - 12)
    $srcCol = $bmpJcb.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) { continue }

    for ($x = $leftX; $x -le $rightX; $x++) {
        $orig = $bmpJcb.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $distFromEdge = [Math]::Min($x - $leftX, $rightX - $x)
        $blend = if ($distFromEdge -ge 4) { 1.0 } else { $distFromEdge / 4.0 }

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
