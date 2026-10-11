Add-Type -AssemblyName System.Drawing

function Paint-SmoothSweepLine {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$x1, [int]$y1,
        [int]$x2, [int]$y2,
        [int]$radius,
        [int]$sampleX, [int]$sampleY
    )
    $w = $bmp.Width
    $h = $bmp.Height
    $refCol = $bmp.GetPixel([Math]::Min($w-1, [Math]::Max(0, $sampleX)), [Math]::Min($h-1, [Math]::Max(0, $sampleY)))

    $dist = [Math]::Sqrt([Math]::Pow($x2 - $x1, 2) + [Math]::Pow($y2 - $y1, 2))
    $steps = [Math]::Max(1, [int]($dist / 5))

    for ($i = 0; $i -le $steps; $i++) {
        $t = $i / [double]$steps
        $cx = [int]($x1 + ($x2 - $x1) * $t)
        $cy = [int]($y1 + ($y2 - $y1) * $t)

        for ($dy = -$radius; $dy -le $radius; $dy++) {
            $y = $cy + $dy
            if ($y -lt 0 -or $y -ge $h) { continue }
            $normY = $dy / [double]$radius

            for ($dx = -$radius; $dx -le $radius; $dx++) {
                $x = $cx + $dx
                if ($x -lt 0 -or $x -ge $w) { continue }
                $normX = $dx / [double]$radius

                $d = [Math]::Sqrt($normX * $normX + $normY * $normY)
                if ($d -ge 1.0) { continue }

                if ($d -le 0.60) {
                    $alpha = 1.0
                } else {
                    $u = ($d - 0.60) / 0.40
                    $alpha = 0.5 * (1.0 + [Math]::Cos($u * [Math]::PI))
                }

                $p = $bmp.GetPixel($x, $y)
                if ($p.A -lt 80) { continue }

                $finalR = [int]($p.R * (1.0 - $alpha) + $refCol.R * $alpha)
                $finalG = [int]($p.G * (1.0 - $alpha) + $refCol.G * $alpha)
                $finalB = [int]($p.B * (1.0 - $alpha) + $refCol.B * $alpha)

                $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($p.A, $finalR, $finalG, $finalB))
            }
        }
    }
}

$items = @(
    @{
        File = 'CAT_424-SIDE-CUTTER.png'
        Out = 'cat-424-side-cutter.jpeg'
        Title = 'CAT 424'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(240, 140, 290, 250, 35, 220, 290),
            @(260, 240, 305, 350, 32, 220, 290),
            @(680, 180, 740, 300, 35, 620, 280),
            @(710, 280, 760, 390, 32, 620, 280)
        )
    },
    @{
        File = 'EX_100-SIDE-CUTTER.png'
        Out = 'ex-100-side-cutter.jpeg'
        Title = 'EX 100'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(90, 135, 140, 215, 26, 120, 240),
            @(445, 155, 490, 240, 26, 470, 260)
        )
    },
    @{
        File = 'EX_200-SIDE-CUTTER.png'
        Out = 'ex-200-side-cutter.jpeg'
        Title = 'EX 200'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(380, 420, 415, 515, 26, 400, 360),
            @(620, 430, 655, 530, 26, 640, 370)
        )
    },
    @{
        File = 'EX_60-SIDE-CUTTER.png'
        Out = 'ex-60-side-cutter.jpeg'
        Title = 'EX 60'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(150, 140, 245, 195, 30, 210, 250),
            @(705, 155, 795, 215, 30, 650, 250)
        )
    },
    @{
        File = 'HM_3036-SIDE-CUTTER.png'
        Out = 'hm-3036-side-cutter.jpeg'
        Title = 'HM 3036'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(280, 360, 385, 360, 30, 330, 430),
            @(565, 360, 670, 360, 30, 620, 430)
        )
    },
    @{
        File = 'JCB-DF-SIDE-CUTTER.png'
        Out = 'jcb-df-side-cutter.jpeg'
        Title = 'JCB DF'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(340, 140, 395, 275, 30, 290, 230),
            @(625, 160, 680, 295, 30, 675, 230)
        )
    },
    @{
        File = 'PC_200-SIDE-CUTTER.png'
        Out = 'pc-200-side-cutter.jpeg'
        Title = 'PC 200'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(145, 115, 275, 165, 30, 245, 115),
            @(395, 125, 520, 175, 30, 440, 105)
        )
    },
    @{
        File = 'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png'
        Out = 'terex-df-side-cutter.jpeg'
        Title = 'TEREX DF'
        Sub = 'SIDE CUTTER'
        Sweeps = @(
            @(285, 255, 340, 355, 26, 250, 310),
            @(640, 285, 690, 390, 26, 670, 340)
        )
    }
)

foreach ($item in $items) {
    $srcPath = "knd_sc_images/" + $item.File
    $src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

    # 1. Apply sweeps to erase KND completely
    foreach ($s in $item.Sweeps) {
        Paint-SmoothSweepLine -bmp $src -x1 $s[0] -y1 $s[1] -x2 $s[2] -y2 $s[3] -radius $s[4] -sampleX $s[5] -sampleY $s[6]
    }

    # 2. Render onto 1254x1254 solid white canvas
    $canvas = [System.Drawing.Bitmap]::new(1254, 1254)
    $g = [System.Drawing.Graphics]::FromImage($canvas)
    $g.Clear([System.Drawing.Color]::White)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $targetW = 1020
    $targetH = 820
    $scale = [Math]::Min($targetW / $src.Width, $targetH / $src.Height)
    $drawW = [int]($src.Width * $scale)
    $drawH = [int]($src.Height * $scale)
    $posX = [int]((1254 - $drawW) / 2)
    $posY = [int](130 + (820 - $drawH) / 2)

    $g.DrawImage($src, $posX, $posY, $drawW, $drawH)

    # 3. Two-line centered industrial typography
    $fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
    $fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
    $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))

    $sf = [System.Drawing.StringFormat]::new()
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    $g.DrawString($item.Title, $fontTitle, $brush, 627, 1070, $sf)
    $g.DrawString($item.Sub, $fontSub, $brush, 627, 1140, $sf)

    $g.Dispose()
    $src.Dispose()

    # Save to assets/products
    $outPath = Join-Path "assets/products" $item.Out
    $canvas.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $canvas.Dispose()
    Write-Host "Created: $outPath"
}
