Add-Type -AssemblyName System.Drawing

# ==============================================================================
# 1. EX 200: Feathered patch mirror
# ==============================================================================
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Clean left piece (verified flawless):
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

# Crop clean patch from left piece: (285, 420, 65, 115)
$patch1 = new-object System.Drawing.Bitmap(65, 115)
$gP1 = [System.Drawing.Graphics]::FromImage($patch1)
$gP1.DrawImage($bmp1, [System.Drawing.Rectangle]::new(0, 0, 65, 115), [System.Drawing.Rectangle]::new(285, 420, 65, 115), [System.Drawing.GraphicsUnit]::Pixel)
$gP1.Dispose()

# Flip patch horizontally
$patch1.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

# Blend flipped clean patch onto right piece text zone at (590, 420)
for ($y = 0; $y -lt 115; $y++) {
    for ($x = 0; $x -lt 65; $x++) {
        $destX = 590 + $x
        $destY = 420 + $y
        $pOrig = $bmp1.GetPixel($destX, $destY)
        $pClean = $patch1.GetPixel($x, $y)

        if ($pOrig.A -gt 100 -and $pClean.A -gt 100) {
            $u = $x / 65.0
            $v = $y / 115.0
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

$dest1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_patch_ex200.jpg"
$bmp1.Save($dest1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp1.Dispose()
Write-Host "Patch EX 200 saved: $dest1"

# ==============================================================================
# 2. JCB DF: Feathered patch mirror
# ==============================================================================
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Clean right piece neck (verified 100% spotless):
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

# Crop clean right neck patch: (480, 70, 85, 140)
$patch2 = new-object System.Drawing.Bitmap(85, 140)
$gP2 = [System.Drawing.Graphics]::FromImage($patch2)
$gP2.DrawImage($bmp2, [System.Drawing.Rectangle]::new(0, 0, 85, 140), [System.Drawing.Rectangle]::new(480, 70, 85, 140), [System.Drawing.GraphicsUnit]::Pixel)
$gP2.Dispose()

# Flip patch horizontally
$patch2.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)

# Blend flipped clean patch onto left piece neck at (290, 70)
for ($y = 0; $y -lt 140; $y++) {
    for ($x = 0; $x -lt 85; $x++) {
        $destX = 290 + $x
        $destY = 70 + $y
        $pOrig = $bmp2.GetPixel($destX, $destY)
        $pClean = $patch2.GetPixel($x, $y)

        if ($pOrig.A -gt 100 -and $pClean.A -gt 100) {
            $u = $x / 85.0
            $v = $y / 140.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.15
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($pOrig.R * (1.0 - $blend) + $pClean.R * $blend)
            $g = [int]($pOrig.G * (1.0 - $blend) + $pClean.G * $blend)
            $b = [int]($pOrig.B * (1.0 - $blend) + $pClean.B * $blend)
            $bmp2.SetPixel($destX, $destY, [System.Drawing.Color]::FromArgb($pOrig.A, $r, $g, $b))
        }
    }
}
$patch2.Dispose()

$dest2 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_patch_jcbdf.jpg"
$bmp2.Save($dest2, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp2.Dispose()
Write-Host "Patch JCB DF saved: $dest2"
