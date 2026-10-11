Add-Type -AssemblyName System.Drawing

function Seamless-InpaintRect {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$rx, [int]$ry, [int]$rw, [int]$rh
    )
    $w = $bmp.Width
    $h = $bmp.Height

    # 1. Sample boundary colors along 4 edges
    # Top border (just above ry)
    $topColors = @()
    for ($x = $rx; $x -lt ($rx + $rw); $x++) {
        $c = [System.Drawing.Color]::Empty
        for ($step = 1; $step -le 25; $step++) {
            $sy = $ry - $step
            if ($sy -ge 0) {
                $p = $bmp.GetPixel($x, $sy)
                if ($p.A -gt 150 -and $p.R -gt 100) { $c = $p; break }
            }
        }
        $topColors += $c
    }

    # Bottom border (just below ry + rh)
    $bottomColors = @()
    for ($x = $rx; $x -lt ($rx + $rw); $x++) {
        $c = [System.Drawing.Color]::Empty
        for ($step = 1; $step -le 25; $step++) {
            $sy = $ry + $rh - 1 + $step
            if ($sy -lt $h) {
                $p = $bmp.GetPixel($x, $sy)
                if ($p.A -gt 150 -and $p.R -gt 100) { $c = $p; break }
            }
        }
        $bottomColors += $c
    }

    # Left border (just left of rx)
    $leftColors = @()
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $c = [System.Drawing.Color]::Empty
        for ($step = 1; $step -le 25; $step++) {
            $sx = $rx - $step
            if ($sx -ge 0) {
                $p = $bmp.GetPixel($sx, $y)
                if ($p.A -gt 150 -and $p.R -gt 100) { $c = $p; break }
            }
        }
        $leftColors += $c
    }

    # Right border (just right of rx + rw)
    $rightColors = @()
    for ($y = $ry; $y -lt ($ry + $rh); $y++) {
        $c = [System.Drawing.Color]::Empty
        for ($step = 1; $step -le 25; $step++) {
            $sx = $rx + $rw - 1 + $step
            if ($sx -lt $w) {
                $p = $bmp.GetPixel($sx, $y)
                if ($p.A -gt 150 -and $p.R -gt 100) { $c = $p; break }
            }
        }
        $rightColors += $c
    }

    # Fallback metal color if any border pixel is transparent/missing
    $validColors = @($topColors + $bottomColors + $leftColors + $rightColors) | Where-Object { $_.IsEmpty -eq $false -and $_.A -gt 150 -and $_.R -gt 100 }
    if ($validColors.Count -eq 0) { return }
    $avgR = ($validColors | Measure-Object -Property R -Average).Average
    $avgG = ($validColors | Measure-Object -Property G -Average).Average
    $avgB = ($validColors | Measure-Object -Property B -Average).Average
    $fallback = [System.Drawing.Color]::FromArgb(255, [int]$avgR, [int]$avgG, [int]$avgB)

    # 2. Fill the interior
    for ($y = 0; $y -lt $rh; $y++) {
        $targetY = $ry + $y
        if ($targetY -lt 0 -or $targetY -ge $h) { continue }
        $v = if ($rh -gt 1) { $y / ($rh - 1.0) } else { 0.5 }

        $colL = if ($leftColors[$y].IsEmpty) { $fallback } else { $leftColors[$y] }
        $colR = if ($rightColors[$y].IsEmpty) { $fallback } else { $rightColors[$y] }

        for ($x = 0; $x -lt $rw; $x++) {
            $targetX = $rx + $x
            if ($targetX -lt 0 -or $targetX -ge $w) { continue }
            $orig = $bmp.GetPixel($targetX, $targetY)
            if ($orig.A -lt 100) { continue } # do not paint outside metal

            $u = if ($rw -gt 1) { $x / ($rw - 1.0) } else { 0.5 }

            $colT = if ($topColors[$x].IsEmpty) { $fallback } else { $topColors[$x] }
            $colB = if ($bottomColors[$x].IsEmpty) { $fallback } else { $bottomColors[$x] }

            # Horizontal interpolation
            $hR = $colL.R * (1.0 - $u) + $colR.R * $u
            $hG = $colL.G * (1.0 - $u) + $colR.G * $u
            $hB = $colL.B * (1.0 - $u) + $colR.B * $u

            # Vertical interpolation
            $vR = $colT.R * (1.0 - $v) + $colB.R * $v
            $vG = $colT.G * (1.0 - $v) + $colB.G * $v
            $vB = $colT.B * (1.0 - $v) + $colB.B * $v

            # Combined bilinear inpaint
            $fillR = 0.5 * ($hR + $vR)
            $fillG = 0.5 * ($hG + $vG)
            $fillB = 0.5 * ($hB + $vB)

            # Smooth edge blend (cosine falloff)
            $edgeDistX = [Math]::Min($x, $rw - 1 - $x) / [double][Math]::Max(1, $rw * 0.18)
            $edgeDistY = [Math]::Min($y, $rh - 1 - $y) / [double][Math]::Max(1, $rh * 0.18)
            $edgeDist = [Math]::Min($edgeDistX, $edgeDistY)
            $blend = if ($edgeDist -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edgeDist * [Math]::PI)) }

            $finalR = [int]($orig.R * (1.0 - $blend) + $fillR * $blend)
            $finalG = [int]($orig.G * (1.0 - $blend) + $fillG * $blend)
            $finalB = [int]($orig.B * (1.0 - $blend) + $fillB * $blend)

            $bmp.SetPixel($targetX, $targetY, [System.Drawing.Color]::FromArgb($orig.A, $finalR, $finalG, $finalB))
        }
    }
}

# Test on CAT_424
$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/CAT_424-SIDE-CUTTER.png").Path)

# Left piece text region: KND INDIA is at x=120..230, y=140..320
Seamless-InpaintRect -bmp $src -rx 120 -ry 140 -rw 110 -rh 180

# Right piece text region: KND INDIA is at x=580..690, y=140..320
Seamless-InpaintRect -bmp $src -rx 580 -ry 140 -rw 110 -rh 180

$dest = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_bilinear_test.jpg"
$src.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$src.Dispose()
Write-Host "Saved: $dest"
