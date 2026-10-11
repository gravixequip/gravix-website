Add-Type -AssemblyName System.Drawing

function Erase-EmbossedTextPerfect {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$rx, [int]$ry, [int]$rw, [int]$rh,
        [int]$sampleX, [int]$sampleY
    )
    $w = $bmp.Width
    $h = $bmp.Height
    $cx = $rx + $rw / 2.0
    $cy = $ry + $rh / 2.0
    $hw = $rw / 2.0
    $hh = $rh / 2.0

    $baseCol = $bmp.GetPixel($sampleX, $sampleY)

    # First pass: replace letter shadow/highlight edges with local metal tone
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

            # Strong falloff weight
            $weight = [Math]::Pow([Math]::Cos($dist * [Math]::PI * 0.5), 1.5)

            $p = $bmp.GetPixel($srcX, $srcY)
            if ($p.A -lt 100) { continue }

            $newR = [int]($p.R * (1.0 - $weight) + $baseCol.R * $weight)
            $newG = [int]($p.G * (1.0 - $weight) + $baseCol.G * $weight)
            $newB = [int]($p.B * (1.0 - $weight) + $baseCol.B * $weight)

            $bmp.SetPixel($srcX, $srcY, [System.Drawing.Color]::FromArgb($p.A, $newR, $newG, $newB))
        }
    }
}

$srcPath = "knd_sc_images/CAT_424-SIDE-CUTTER.png"
$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

# Clean left piece: KND is around (240, 150) and INDIA is around (255, 205)
Erase-EmbossedTextPerfect -bmp $src -rx 205 -ry 115 -rw 95 -rh 85 -sampleX 220 -sampleY 280
Erase-EmbossedTextPerfect -bmp $src -rx 220 -ry 175 -rw 85 -rh 85 -sampleX 220 -sampleY 280

# Clean right piece: KND is around (690, 160) and INDIA is around (675, 215)
# Wait, let's verify right piece x coordinates:
# From cat424_correct.jpg: the red box at 545, 175 was shifted too far LEFT!
# The right piece's KND INDIA is at x=640 to 730!
Erase-EmbossedTextPerfect -bmp $src -rx 645 -ry 130 -rw 95 -rh 90 -sampleX 600 -sampleY 290
Erase-EmbossedTextPerfect -bmp $src -rx 635 -ry 185 -rw 95 -rh 90 -sampleX 600 -sampleY 290

$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_perfect.jpg"
$src.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$src.Dispose()
Write-Host "Saved: $out"
