Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece text is at x=300..345, y=425..520! Source clean metal is at x-35 (265..310)
for ($y = 425; $y -le 520; $y++) {
    for ($x = 295; $x -le 345; $x++) {
        $orig = $bmp.GetPixel($x, $y)
        $srcP = $bmp.GetPixel($x - 30, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 295) / 50.0
            $v = ($y - 425) / 95.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.20
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Right piece text is at x=530..580, y=425..520! Source clean metal is at x-35 (495..545)
for ($y = 425; $y -le 520; $y++) {
    for ($x = 530; $x -le 580; $x++) {
        $orig = $bmp.GetPixel($x, $y)
        $srcP = $bmp.GetPixel($x - 30, $y)
        if ($orig.A -gt 150 -and $srcP.A -gt 150) {
            $u = ($x - 530) / 50.0
            $v = ($y - 425) / 95.0
            $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.20
            $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

$dest = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\clean_ex200_v3.jpg"
$bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
Write-Host "Saved: $dest"
