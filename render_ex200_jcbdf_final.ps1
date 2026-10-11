Add-Type -AssemblyName System.Drawing

function Build-EX200 {
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

    # Left piece text is at x=290..345, y=425..525. Clone from clean flat metal at x+65 (355..410)
    for ($y = 420; $y -le 525; $y++) {
        for ($x = 290; $x -le 345; $x++) {
            $orig = $bmp.GetPixel($x, $y)
            $srcP = $bmp.GetPixel($x + 65, $y)
            if ($orig.A -gt 120 -and $srcP.A -gt 120) {
                $u = ($x - 290) / 55.0
                $v = ($y - 420) / 105.0
                $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.18
                $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

                $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
                $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
                $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
            }
        }
    }

    # Right piece text is at x=605..665, y=420..530. Clone from clean flat metal at x-140 (465..525)
    for ($y = 420; $y -le 530; $y++) {
        for ($x = 605; $x -le 665; $x++) {
            $orig = $bmp.GetPixel($x, $y)
            $srcP = $bmp.GetPixel($x - 140, $y)
            if ($orig.A -gt 120 -and $srcP.A -gt 120) {
                $u = ($x - 605) / 60.0
                $v = ($y - 420) / 110.0
                $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.18
                $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

                $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
                $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
                $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
            }
        }
    }

    # Canvas 1254x1254 pure white
    $canvas = [System.Drawing.Bitmap]::new(1254, 1254)
    $g = [System.Drawing.Graphics]::FromImage($canvas)
    $g.Clear([System.Drawing.Color]::White)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $scale = [Math]::Min(1020 / $bmp.Width, 820 / $bmp.Height)
    $drawW = [int]($bmp.Width * $scale)
    $drawH = [int]($bmp.Height * $scale)
    $posX = [int]((1254 - $drawW) / 2)
    $posY = [int](130 + (820 - $drawH) / 2)
    $g.DrawImage($bmp, $posX, $posY, $drawW, $drawH)

    $fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
    $fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
    $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))
    $sf = [System.Drawing.StringFormat]::new()
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString("EX 200", $fontTitle, $brush, 627, 1070, $sf)
    $g.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)

    $g.Dispose()
    $bmp.Dispose()
    $outPath = "assets/products/ex-200-side-cutter.jpeg"
    $canvas.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $canvas.Dispose()
    Write-Host "Generated: $outPath"
}

function Build-JCBDF {
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

    # Left piece neck: text at x=320..375, y=90..210. Clone from clean neck metal at x-55, y+20
    for ($y = 90; $y -le 210; $y++) {
        for ($x = 320; $x -le 375; $x++) {
            $orig = $bmp.GetPixel($x, $y)
            $srcP = $bmp.GetPixel($x - 55, $y + 20)
            if ($orig.A -gt 120 -and $srcP.A -gt 120) {
                $u = ($x - 320) / 55.0
                $v = ($y - 90) / 120.0
                $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.18
                $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

                $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
                $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
                $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
            }
        }
    }

    # Right piece neck: text at x=495..560, y=80..185. Clone from clean neck metal at x+55, y+25
    for ($y = 80; $y -le 185; $y++) {
        for ($x = 495; $x -le 560; $x++) {
            $orig = $bmp.GetPixel($x, $y)
            $srcP = $bmp.GetPixel($x + 55, $y + 25)
            if ($orig.A -gt 120 -and $srcP.A -gt 120) {
                $u = ($x - 495) / 65.0
                $v = ($y - 80) / 105.0
                $edge = [Math]::Min([Math]::Min($u, 1.0 - $u), [Math]::Min($v, 1.0 - $v)) / 0.18
                $blend = if ($edge -ge 1.0) { 1.0 } else { 0.5 * (1.0 - [Math]::Cos($edge * [Math]::PI)) }

                $r = [int]($orig.R * (1.0 - $blend) + $srcP.R * $blend)
                $g = [int]($orig.G * (1.0 - $blend) + $srcP.G * $blend)
                $b = [int]($orig.B * (1.0 - $blend) + $srcP.B * $blend)
                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $r, $g, $b))
            }
        }
    }

    # Canvas 1254x1254 pure white
    $canvas = [System.Drawing.Bitmap]::new(1254, 1254)
    $g = [System.Drawing.Graphics]::FromImage($canvas)
    $g.Clear([System.Drawing.Color]::White)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $scale = [Math]::Min(1020 / $bmp.Width, 820 / $bmp.Height)
    $drawW = [int]($bmp.Width * $scale)
    $drawH = [int]($bmp.Height * $scale)
    $posX = [int]((1254 - $drawW) / 2)
    $posY = [int](130 + (820 - $drawH) / 2)
    $g.DrawImage($bmp, $posX, $posY, $drawW, $drawH)

    $fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
    $fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
    $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))
    $sf = [System.Drawing.StringFormat]::new()
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $g.DrawString("JCB DF", $fontTitle, $brush, 627, 1070, $sf)
    $g.DrawString("SIDE CUTTER", $fontSub, $brush, 627, 1140, $sf)

    $g.Dispose()
    $bmp.Dispose()
    $outPath = "assets/products/jcb-df-side-cutter.jpeg"
    $canvas.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $canvas.Dispose()
    Write-Host "Generated: $outPath"
}

Build-EX200
Build-JCBDF
