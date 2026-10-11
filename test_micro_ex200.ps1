Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# 1. Left Piece: xc = 387, y = 430 to 496, radius = 10, sampleOffsetX = -22
$radius = 10.0
for ($y = 430; $y -le 496; $y++) {
    $srcX = 387 - 22
    $srcCol = $bmpEx.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) { continue }

    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int](387 + $dx)
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -lt 150) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.3) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.3) / 0.7) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# 2. Right Piece: xc = 622, y = 430 to 500, radius = 10, sampleOffsetX = -20
for ($y = 430; $y -le 500; $y++) {
    $srcX = 622 - 20
    $srcCol = $bmpEx.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) { continue }

    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int](622 + $dx)
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -lt 150) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.3) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.3) / 0.7) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Render EX 200 onto 1254x1254 canvas
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

$c1.Save("$cropDir/test_ex200_micro.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c1.Dispose()
Write-Host "test_ex200_micro.jpg saved!"
