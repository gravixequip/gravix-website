Add-Type -AssemblyName System.Drawing

# 1. EX 200: Clone from flat metal with cosine falloff
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: text at x=295..345, y=425..520 -> source at x + 60 (355..405)
for ($y = 425; $y -le 520; $y++) {
    for ($x = 295; $x -le 345; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcP = $bmp1.GetPixel($x + 60, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 295) / 50.0
            $v = ($y - 425) / 95.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.20
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Right piece: text at x=515..565, y=425..520 -> source at x - 60 (455..505)
for ($y = 425; $y -le 520; $y++) {
    for ($x = 515; $x -le 565; $x++) {
        $orig = $bmp1.GetPixel($x, $y)
        $srcP = $bmp1.GetPixel($x - 60, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 515) / 50.0
            $v = ($y - 425) / 95.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.20
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp1.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

$out1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\perfect_ex200.jpg"
$bmp1.Save($out1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp1.Dispose()
Write-Host "Saved EX 200 perfect: $out1"

# 2. JCB DF: text at x=295..355, y=80..180 (Left) and x=495..560, y=80..180 (Right)
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece: source from x-35, y+40 (clean neck metal)
for ($y = 80; $y -le 180; $y++) {
    for ($x = 295; $x -le 355; $x++) {
        $orig = $bmp2.GetPixel($x, $y)
        $srcP = $bmp2.GetPixel($x - 30, $y + 45)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 295) / 60.0
            $v = ($y - 80) / 100.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.20
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp2.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Right piece: source from x+30, y+45
for ($y = 80; $y -le 180; $y++) {
    for ($x = 495; $x -le 560; $x++) {
        $orig = $bmp2.GetPixel($x, $y)
        $srcP = $bmp2.GetPixel($x + 30, $y + 45)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 495) / 65.0
            $v = ($y - 80) / 100.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.20
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp2.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

$out2 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\perfect_jcbdf.jpg"
$bmp2.Save($out2, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp2.Dispose()
Write-Host "Saved JCB DF perfect: $out2"
