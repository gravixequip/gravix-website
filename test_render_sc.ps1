Add-Type -AssemblyName System.Drawing

function Remove-TextFromRegion {
    param(
        [System.Drawing.Bitmap]$bmp,
        [System.Drawing.Rectangle]$rect,
        [int]$radius = 16
    )
    $w = $bmp.Width
    $h = $bmp.Height
    $x1 = [Math]::Max(0, $rect.X)
    $y1 = [Math]::Max(0, $rect.Y)
    $x2 = [Math]::Min($w - 1, $rect.X + $rect.Width)
    $y2 = [Math]::Min($h - 1, $rect.Y + $rect.Height)

    # Multi-pass color smoothing within the bounding box
    for ($pass = 0; $pass -lt 4; $pass++) {
        $temp = [System.Drawing.Bitmap]::new($bmp)
        for ($y = $y1; $y -le $y2; $y++) {
            for ($x = $x1; $x -le $x2; $x++) {
                $cur = $temp.GetPixel($x, $y)
                if ($cur.A -lt 50) { continue } # skip transparent
                
                $rSum = 0; $gSum = 0; $bSum = 0; $count = 0
                for ($dy = -$radius; $dy -le $radius; $dy += 2) {
                    $ny = $y + $dy
                    if ($ny -lt 0 -or $ny -ge $h) { continue }
                    for ($dx = -$radius; $dx -le $radius; $dx += 2) {
                        $nx = $x + $dx
                        if ($nx -lt 0 -or $nx -ge $w) { continue }
                        $np = $temp.GetPixel($nx, $ny)
                        if ($np.A -gt 100) {
                            $rSum += $np.R
                            $gSum += $np.G
                            $bSum += $np.B
                            $count++
                        }
                    }
                }
                if ($count -gt 0) {
                    $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($cur.A, [int]($rSum/$count), [int]($gSum/$count), [int]($bSum/$count)))
                }
            }
        }
        $temp.Dispose()
    }
}

$srcPath = "knd_sc_images/CAT_424-SIDE-CUTTER.png"
$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

# Erase KND INDIA on both wings
Remove-TextFromRegion -bmp $src -rect ([System.Drawing.Rectangle]::new(210, 155, 110, 150)) -radius 16
Remove-TextFromRegion -bmp $src -rect ([System.Drawing.Rectangle]::new(660, 210, 115, 145)) -radius 16

# Render onto 1254x1254 white canvas
$canvas = [System.Drawing.Bitmap]::new(1254, 1254)
$g = [System.Drawing.Graphics]::FromImage($canvas)
$g.Clear([System.Drawing.Color]::White)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

# Compute product fit
$targetW = 1000
$targetH = 800
$scale = [Math]::Min($targetW / $src.Width, $targetH / $src.Height)
$drawW = [int]($src.Width * $scale)
$drawH = [int]($src.Height * $scale)
$posX = [int]((1254 - $drawW) / 2)
$posY = 140

$g.DrawImage($src, $posX, $posY, $drawW, $drawH)

# Text at bottom
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

$testOut = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_cat424_final.jpg"
$canvas.Save($testOut, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$canvas.Dispose()
Write-Host "Saved: $testOut"
