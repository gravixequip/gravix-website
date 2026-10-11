Add-Type -AssemblyName System.Drawing

function Smooth-EmbossedTextSeamless {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$rx, [int]$ry, [int]$rw, [int]$rh,
        [int]$blurRadius = 12
    )
    $w = $bmp.Width
    $h = $bmp.Height
    $cx = $rx + $rw / 2.0
    $cy = $ry + $rh / 2.0
    $hw = $rw / 2.0
    $hh = $rh / 2.0

    # 1. Compute average smoothed color map for the region
    $smoothed = [System.Drawing.Bitmap]::new($rw, $rh)
    for ($y = 0; $y -lt $rh; $y++) {
        $srcY = [int]($ry + $y)
        for ($x = 0; $x -lt $rw; $x++) {
            $srcX = [int]($rx + $x)
            
            $rSum = 0; $gSum = 0; $bSum = 0; $count = 0
            for ($dy = -$blurRadius; $dy -le $blurRadius; $dy += 2) {
                $ny = $srcY + $dy
                if ($ny -lt 0 -or $ny -ge $h) { continue }
                for ($dx = -$blurRadius; $dx -le $blurRadius; $dx += 2) {
                    $nx = $srcX + $dx
                    if ($nx -lt 0 -or $nx -ge $w) { continue }
                    $p = $bmp.GetPixel($nx, $ny)
                    if ($p.A -gt 150) {
                        $rSum += $p.R
                        $gSum += $p.G
                        $bSum += $p.B
                        $count++
                    }
                }
            }
            if ($count -gt 0) {
                $smoothed.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, [int]($rSum/$count), [int]($gSum/$count), [int]($bSum/$count)))
            } else {
                $smoothed.SetPixel($x, $y, $bmp.GetPixel($srcX, $srcY))
            }
        }
    }

    # 2. Blend back into original bitmap with radial cosine falloff
    for ($y = 0; $y -lt $rh; $y++) {
        $srcY = [int]($ry + $y)
        if ($srcY -lt 0 -or $srcY -ge $h) { continue }
        $normY = [Math]::Abs(($srcY - $cy) / $hh)
        if ($normY -ge 1.0) { continue }

        for ($x = 0; $x -lt $rw; $x++) {
            $srcX = [int]($rx + $x)
            if ($srcX -lt 0 -or $srcX -ge $w) { continue }
            $normX = [Math]::Abs(($srcX - $cx) / $hw)
            if ($normX -ge 1.0) { continue }

            # Elliptical distance from center (0 at center, 1 at boundary)
            $dist = [Math]::Sqrt($normX * $normX + $normY * $normY)
            if ($dist -ge 1.0) { continue }

            # Smooth cosine falloff weight: 1.0 at center, 0.0 at edge
            $alpha = 0.5 * (1.0 + [Math]::Cos($dist * [Math]::PI))
            # Boost alpha slightly in center to fully erase embossed shadows
            $alpha = [Math]::Min(1.0, $alpha * 1.35)

            $orig = $bmp.GetPixel($srcX, $srcY)
            if ($orig.A -lt 100) { continue }
            $smooth = $smoothed.GetPixel($x, $y)

            $finalR = [int]($orig.R * (1.0 - $alpha) + $smooth.R * $alpha)
            $finalG = [int]($orig.G * (1.0 - $alpha) + $smooth.G * $alpha)
            $finalB = [int]($orig.B * (1.0 - $alpha) + $smooth.B * $alpha)

            $bmp.SetPixel($srcX, $srcY, [System.Drawing.Color]::FromArgb($orig.A, $finalR, $finalG, $finalB))
        }
    }
    $smoothed.Dispose()
}

$srcPath = "knd_sc_images/CAT_424-SIDE-CUTTER.png"
$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

Smooth-EmbossedTextSeamless -bmp $src -rx 195 -ry 135 -rw 95 -rh 135 -blurRadius 14
Smooth-EmbossedTextSeamless -bmp $src -rx 545 -ry 175 -rw 95 -rh 135 -blurRadius 14

# Composite to 1254x1254 pure white canvas
$canvas = [System.Drawing.Bitmap]::new(1254, 1254)
$g = [System.Drawing.Graphics]::FromImage($canvas)
$g.Clear([System.Drawing.Color]::White)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

$targetW = 1000
$targetH = 800
$scale = [Math]::Min($targetW / $src.Width, $targetH / $src.Height)
$drawW = [int]($src.Width * $scale)
$drawH = [int]($src.Height * $scale)
$posX = [int]((1254 - $drawW) / 2)
$posY = 140

$g.DrawImage($src, $posX, $posY, $drawW, $drawH)

$fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
$fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))

$sf = [System.Drawing.StringFormat]::new()
$sf.Alignment = [System.Drawing.StringAlignment]::Center
$sf.LineAlignment = [System.Drawing.StringAlignment]::Center

$g.DrawString("CAT 424", $fontTitle, $brush, 627, 1070, $sf)
$g.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)

$g.Dispose()
$src.Dispose()

$testOut = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_seamless.jpg"
$canvas.Save($testOut, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas.Dispose()
Write-Host "Saved: $testOut"
