Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: letters at x=382..408, y=425..510. Reference column x=372
for ($y = 425; $y -le 510; $y++) {
    $refCol = $bmp.GetPixel(372, $y)
    for ($x = 382; $x -le 408; $x++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 100 -and ($p.R -gt 80 -or $p.G -gt 80)) {
            $u = ($x - 382) / 26.0
            $blend = if ($u -lt 0.2) { $u / 0.2 } elseif ($u -gt 0.8) { (1.0 - $u) / 0.2 } else { 1.0 }
            $finR = [int]($p.R * (1.0 - $blend) + $refCol.R * $blend)
            $finG = [int]($p.G * (1.0 - $blend) + $refCol.G * $blend)
            $finB = [int]($p.B * (1.0 - $blend) + $refCol.B * $blend)
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $finR, $finG, $finB))
        }
    }
}

# Right piece: letters at x=590..620, y=425..510. Reference column x=630
for ($y = 425; $y -le 510; $y++) {
    $refCol = $bmp.GetPixel(630, $y)
    for ($x = 590; $x -le 620; $x++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 100 -and ($p.R -gt 80 -or $p.G -gt 80)) {
            $u = ($x - 590) / 30.0
            $blend = if ($u -lt 0.2) { $u / 0.2 } elseif ($u -gt 0.8) { (1.0 - $u) / 0.2 } else { 1.0 }
            $finR = [int]($p.R * (1.0 - $blend) + $refCol.R * $blend)
            $finG = [int]($p.G * (1.0 - $blend) + $refCol.G * $blend)
            $finB = [int]($p.B * (1.0 - $blend) + $refCol.B * $blend)
            $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $finR, $finG, $finB))
        }
    }
}

# Also JCB DF right piece: letters at neck x=580..630, y=100..260. Reference column x=650
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
for ($y = 100; $y -le 260; $y++) {
    $refCol = $bmpJcb.GetPixel(650, $y)
    for ($x = 575; $x -le 625; $x++) {
        $p = $bmpJcb.GetPixel($x, $y)
        if ($p.A -gt 100 -and ($p.R -gt 80 -or $p.G -gt 80)) {
            $u = ($x - 575) / 50.0
            $blend = if ($u -lt 0.2) { $u / 0.2 } elseif ($u -gt 0.8) { (1.0 - $u) / 0.2 } else { 1.0 }
            $finR = [int]($p.R * (1.0 - $blend) + $refCol.R * $blend)
            $finG = [int]($p.G * (1.0 - $blend) + $refCol.G * $blend)
            $finB = [int]($p.B * (1.0 - $blend) + $refCol.B * $blend)
            $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $finR, $finG, $finB))
        }
    }
}

# Save test
$dest = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_clean_ex200.jpg"
$bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()

$destJcb = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_clean_jcbdf.jpg"
$bmpJcb.Save($destJcb, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmpJcb.Dispose()

Write-Host "Saved test_clean_ex200.jpg and test_clean_jcbdf.jpg"
