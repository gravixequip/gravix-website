Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: copy from clean patch (x-40, y-30)
for ($y = 430; $y -le 510; $y++) {
    for ($x = 380; $x -le 420; $x++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 150) {
            $srcP = $bmp.GetPixel($x - 30, $y)
            if ($srcP.A -gt 150) {
                # Smooth edge blend
                $u = ($x - 380) / 40.0
                $v = ($y - 430) / 80.0
                $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.25
                $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }
                
                $r = [int]($p.R * (1.0 - $blend) + $srcP.R * $blend)
                $g = [int]($p.G * (1.0 - $blend) + $srcP.G * $blend)
                $b = [int]($p.B * (1.0 - $blend) + $srcP.B * $blend)
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $r, $g, $b))
            }
        }
    }
}

# Right piece: copy from clean patch (x+35, y)
for ($y = 430; $y -le 510; $y++) {
    for ($x = 610; $x -le 650; $x++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 150) {
            $srcP = $bmp.GetPixel($x + 35, $y)
            if ($srcP.A -gt 150) {
                $u = ($x - 610) / 40.0
                $v = ($y - 430) / 80.0
                $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.25
                $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }
                
                $r = [int]($p.R * (1.0 - $blend) + $srcP.R * $blend)
                $g = [int]($p.G * (1.0 - $blend) + $srcP.G * $blend)
                $b = [int]($p.B * (1.0 - $blend) + $srcP.B * $blend)
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $r, $g, $b))
            }
        }
    }
}

$dest = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_clean_ex200_v2.jpg"
$bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
Write-Host "Saved: $dest"
