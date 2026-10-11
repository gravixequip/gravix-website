Add-Type -AssemblyName System.Drawing

# 1. EX 200
$bmp200 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: letters at x=385..420, y=430..510. Source clean area is at x - 30 (x=355..390)
for ($y = 430; $y -le 510; $y++) {
    for ($x = 385; $x -le 420; $x++) {
        $srcP = $bmp200.GetPixel($x - 32, $y)
        $orig = $bmp200.GetPixel($x, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 385) / 35.0
            $blend = if ($u -lt 0.2) { $u / 0.2 } elseif ($u -gt 0.8) { (1.0 - $u) / 0.2 } else { 1.0 }
            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp200.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

# Right piece: letters at x=610..645, y=430..510. Source clean area is at x + 32 (x=642..677)
for ($y = 430; $y -le 510; $y++) {
    for ($x = 610; $x -le 645; $x++) {
        $srcP = $bmp200.GetPixel($x + 32, $y)
        $orig = $bmp200.GetPixel($x, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 610) / 35.0
            $blend = if ($u -lt 0.2) { $u / 0.2 } elseif ($u -gt 0.8) { (1.0 - $u) / 0.2 } else { 1.0 }
            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmp200.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

$dest200 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\clone_ex200.jpg"
$bmp200.Save($dest200, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp200.Dispose()

# 2. JCB DF Right piece: letters at x=610..670, y=140..270. Source clean area is at x - 35
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
# Left piece already cleaned via CleanEmbossed
# Right piece:
for ($y = 140; $y -le 270; $y++) {
    for ($x = 610; $x -le 670; $x++) {
        $srcP = $bmpJcb.GetPixel($x - 30, $y)
        $orig = $bmpJcb.GetPixel($x, $y)
        if ($orig.A -gt 100 -and $srcP.A -gt 100) {
            $u = ($x - 610) / 60.0
            $blend = if ($u -lt 0.2) { $u / 0.2 } elseif ($u -gt 0.8) { (1.0 - $u) / 0.2 } else { 1.0 }
            $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
            $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
            $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
            $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
        }
    }
}

$destJcb = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\clone_jcbdf.jpg"
$bmpJcb.Save($destJcb, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmpJcb.Dispose()

Write-Host "Saved clone tests!"
