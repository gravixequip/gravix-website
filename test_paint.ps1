Add-Type -AssemblyName System.Drawing

function Paint-CleanMetalArea {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$rx, [int]$ry, [int]$rw, [int]$rh,
        [int]$sampleX, [int]$sampleY # nearby smooth point to copy base texture gradient from
    )
    $w = $bmp.Width
    $h = $bmp.Height
    $cx = $rx + $rw / 2.0
    $cy = $ry + $rh / 2.0
    $hw = $rw / 2.0
    $hh = $rh / 2.0

    # Get sample color
    $sc = $bmp.GetPixel($sampleX, $sampleY)

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

            $dist = [Math]::Sqrt($normX * $normX + $normY * $normY)
            if ($dist -ge 1.0) { continue }

            $alpha = 0.5 * (1.0 + [Math]::Cos($dist * [Math]::PI))

            $orig = $bmp.GetPixel($srcX, $srcY)
            if ($orig.A -lt 100) { continue }

            # Blend towards smooth sample color
            $finalR = [int]($orig.R * (1.0 - $alpha) + $sc.R * $alpha)
            $finalG = [int]($orig.G * (1.0 - $alpha) + $sc.G * $alpha)
            $finalB = [int]($orig.B * (1.0 - $alpha) + $sc.B * $alpha)

            $bmp.SetPixel($srcX, $srcY, [System.Drawing.Color]::FromArgb($orig.A, $finalR, $finalG, $finalB))
        }
    }
}

$srcPath = "knd_sc_images/CAT_424-SIDE-CUTTER.png"
$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

# Clean left wing
Paint-CleanMetalArea -bmp $src -rx 185 -ry 115 -rw 115 -rh 155 -sampleX 220 -sampleY 280
# Clean right wing
Paint-CleanMetalArea -bmp $src -rx 540 -ry 125 -rw 115 -rh 155 -sampleX 590 -sampleY 290

$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_clean_paint.jpg"
$src.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$src.Dispose()
Write-Host "Saved: $out"
