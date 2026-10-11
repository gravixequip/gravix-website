Add-Type -AssemblyName System.Drawing

$configs = @{
    'EX_100-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(80, 130, 65, 100),
        [System.Drawing.Rectangle]::new(440, 140, 65, 100)
    )
    'EX_200-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(375, 420, 60, 100),
        [System.Drawing.Rectangle]::new(610, 420, 60, 100)
    )
    'EX_60-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(135, 125, 120, 105),
        [System.Drawing.Rectangle]::new(550, 125, 120, 105)
    )
    'HM_3036-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(265, 335, 140, 70),
        [System.Drawing.Rectangle]::new(550, 335, 140, 70)
    )
    'JCB-DF-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(335, 130, 85, 160),
        [System.Drawing.Rectangle]::new(615, 140, 85, 160)
    )
    'PC_200-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(200, 135, 120, 80),
        [System.Drawing.Rectangle]::new(400, 160, 120, 80)
    )
    'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(260, 230, 70, 105),
        [System.Drawing.Rectangle]::new(625, 230, 70, 105)
    )
}

$destDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage"

foreach ($k in $configs.Keys) {
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path ("knd_sc_images/" + $k)).Path)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Lime, 3)
    foreach ($r in $configs[$k]) {
        $g.DrawRectangle($pen, $r)
    }
    $pen.Dispose()
    $g.Dispose()

    $out = Join-Path $destDir ("check_" + $k.Replace('.png', '.jpg'))
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $bmp.Dispose()
    Write-Host "Saved: $out"
}
