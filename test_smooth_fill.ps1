Add-Type -AssemblyName System.Drawing

# 1. EX 200 test
$bmp200 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

function SmoothFill {
    param($bmp, $rx, $ry, $rw, $rh, $refX, $refY)
    $ref = $bmp.GetPixel($refX, $refY)
    for ($y = 0; $y -lt $rh; $y++) {
        $py = $ry + $y
        for ($x = 0; $x -lt $rw; $x++) {
            $px = $rx + $x
            $orig = $bmp.GetPixel($px, $py)
            if ($orig.A -lt 120 -or ($orig.R -lt 80 -and $orig.G -lt 80)) { continue }

            $distX = [Math]::Min($x, $rw - 1 - $x) / [double][Math]::Max(1, $rw * 0.25)
            $distY = [Math]::Min($y, $rh - 1 - $y) / [double][Math]::Max(1, $rh * 0.25)
            $factor = [Math]::Min(1.0, [Math]::Min($distX, $distY))
            $blend = 0.5 * (1.0 - [Math]::Cos($factor * [Math]::PI))

            $r = [int]($orig.R * (1.0 - $blend) + $ref.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $ref.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $ref.B * $blend)

            $bmp.SetPixel($px, $py, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# EX 200 left & right
SmoothFill -bmp $bmp200 -rx 375 -ry 425 -rw 55 -rh 95 -refX 370 -refY 390
SmoothFill -bmp $bmp200 -rx 605 -ry 425 -rw 55 -rh 95 -refX 635 -refY 390

$dest200 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\smooth_ex200.jpg"
$bmp200.Save($dest200, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp200.Dispose()

# JCB DF right piece: letters at x=610..670, y=150..290
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
# Left piece clean
SmoothFill -bmp $bmpJcb -rx 330 -ry 130 -rw 90 -rh 170 -refX 280 -refY 230
# Right piece clean
SmoothFill -bmp $bmpJcb -rx 610 -ry 150 -rw 75 -rh 145 -refX 680 -refY 320

$destJcb = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\smooth_jcbdf.jpg"
$bmpJcb.Save($destJcb, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmpJcb.Dispose()

Write-Host "Saved smooth_ex200.jpg and smooth_jcbdf.jpg"
