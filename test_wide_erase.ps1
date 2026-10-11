Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: x = 370 to 404, y = 425 to 505.
# Source clean metal: x = 355 to 365 (offset dx = -24)
for ($y = 425; $y -le 505; $y++) {
    for ($x = 370; $x -le 404; $x++) {
        $srcX = [Math]::Max(0, $x - 24)
        $srcP = $bmpEx.GetPixel($srcX, $y)
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            # Smooth blend at left edge (x=370..375) and right edge (x=400..404)
            $u = ($x - 370) / 34.0
            $edge = [Math]::Min($u, 1.0 - $u) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $finR = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $finG = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $finB = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
        }
    }
}

# Right piece: x = 608 to 642, y = 425 to 505.
# Source clean metal: x = 585 to 600 (offset dx = -32)
for ($y = 425; $y -le 505; $y++) {
    for ($x = 608; $x -le 642; $x++) {
        $srcX = [Math]::Max(0, $x - 30)
        $srcP = $bmpEx.GetPixel($srcX, $y)
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 608) / 34.0
            $edge = [Math]::Min($u, 1.0 - $u) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $finR = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $finG = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $finB = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
        }
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

$c1.Save("$cropDir/test_ex200_wide.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$c1.Dispose()
Write-Host "test_ex200_wide.jpg saved!"
