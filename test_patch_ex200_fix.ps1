Add-Type -AssemblyName System.Drawing

$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Clean left piece (verified flawless):
for ($y = 420; $y -le 540; $y++) {
    for ($x = 285; $x -le 350; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcP = $bmp1.GetPixel($x + 55, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 285) / 65.0
            $v = ($y - 420) / 120.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Crop clean patch from left piece: (285, 420, 70, 130)
$patch1 = new-object System.Drawing.Bitmap(70, 130)
$gP1 = [System.Drawing.Graphics]::FromImage($patch1)
$gP1.DrawImage($bmp1, [System.Drawing.Rectangle]::new(0, 0, 70, 130), [System.Drawing.Rectangle]::new(285, 420, 70, 130), [System.Drawing.GraphicsUnit]::Pixel)
$gP1.Dispose()

# Flip patch horizontally
$patch1.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

# Blend flipped clean patch onto right piece text zone at (590, 455)
for ($y = 0; $y -lt 130; $y++) {
    for ($x = 0; $x -lt 70; $x++) {
        $destX = 590 + $x
        $destY = 455 + $y
        $pOrig = $bmp1.GetPixel($destX, $destY)
        $pClean = $patch1.GetPixel($x, $y)

        if ($pOrig.A -gt 100 -and $pClean.A -gt 100) {
            $u = $x / 70.0
            $v = $y / 130.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($pOrig.R * (1.0 - $blend) + $pClean.R * $blend)
            $g = [int]($pOrig.G * (1.0 - $blend) + $pClean.G * $blend)
            $b = [int]($pOrig.B * (1.0 - $blend) + $pClean.B * $blend)
            $bmp1.SetPixel($destX, $destY, [System.Drawing.Color]::FromArgb($pOrig.A, $r, $g, $b))
        }
    }
}
$patch1.Dispose()

$dest1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_patch_ex200_fix.jpg"
$bmp1.Save($dest1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp1.Dispose()
Write-Host "Patch EX 200 fix saved: $dest1"
