Add-Type -AssemblyName System.Drawing

# 1. EX 200
# Load the currently cleaned EX 200 where left piece is 100% clean
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece cleaning (verified clean):
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

# Now crop the left piece (x: 20..410, y: 50..585)
$cropLeft = new-object System.Drawing.Bitmap(400, 550)
$gCrop = [System.Drawing.Graphics]::FromImage($cropLeft)
$gCrop.DrawImage($bmp1, [System.Drawing.Rectangle]::new(0, 0, 400, 550), [System.Drawing.Rectangle]::new(20, 40, 400, 550), [System.Drawing.GraphicsUnit]::Pixel)
$gCrop.Dispose()

# Flip left piece horizontally to make right piece
$cropLeft.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

# Clear right half of bmp1 and draw the mirrored clean left piece
$gBmp1 = [System.Drawing.Graphics]::FromImage($bmp1)
# Erase old right piece
$gBmp1.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
$eraseBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(0, 0, 0, 0))
$gBmp1.FillRectangle($eraseBrush, 410, 0, 390, 600)

# Draw mirrored right piece at matching position (x: 410, y: 40)
$gBmp1.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
$gBmp1.DrawImage($cropLeft, 400, 40)
$gBmp1.Dispose()
$cropLeft.Dispose()

$dest1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_mirror_ex200.jpg"
$bmp1.Save($dest1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp1.Dispose()
Write-Host "Mirrored EX 200 saved: $dest1"

# 2. JCB DF
# Load JCB DF and clean right neck (verified 100% clean)
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
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

# Crop the clean right piece (x: 430..770, y: 30..585)
$cropRight = new-object System.Drawing.Bitmap(350, 560)
$gCrop2 = [System.Drawing.Graphics]::FromImage($cropRight)
$gCrop2.DrawImage($bmp2, [System.Drawing.Rectangle]::new(0, 0, 350, 560), [System.Drawing.Rectangle]::new(440, 30, 350, 560), [System.Drawing.GraphicsUnit]::Pixel)
$gCrop2.Dispose()

# Flip right piece horizontally to make left piece
$cropRight.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

# Clear left half of bmp2 and draw mirrored right piece
$gBmp2 = [System.Drawing.Graphics]::FromImage($bmp2)
$gBmp2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
$gBmp2.FillRectangle($eraseBrush, 0, 0, 430, 600)

$gBmp2.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceOver
$gBmp2.DrawImage($cropRight, 30, 30)
$gBmp2.Dispose()
$cropRight.Dispose()

$dest2 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_mirror_jcbdf.jpg"
$bmp2.Save($dest2, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp2.Dispose()
Write-Host "Mirrored JCB DF saved: $dest2"
