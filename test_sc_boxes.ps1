Add-Type -AssemblyName System.Drawing

$testBoxes = @{
    'CAT_424-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(170, 95, 105, 155),
        [System.Drawing.Rectangle]::new(665, 125, 120, 155)
    )
    'EX_100-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(40, 115, 60, 95),
        [System.Drawing.Rectangle]::new(480, 135, 65, 95)
    )
    'EX_200-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(360, 390, 70, 100),
        [System.Drawing.Rectangle]::new(595, 415, 75, 100)
    )
    'EX_60-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(115, 105, 95, 100),
        [System.Drawing.Rectangle]::new(550, 115, 105, 100)
    )
    'HM_3036-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(265, 315, 80, 80),
        [System.Drawing.Rectangle]::new(550, 315, 80, 80)
    )
    'JCB-DF-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(260, 90, 80, 105),
        [System.Drawing.Rectangle]::new(475, 105, 85, 105)
    )
    'PC_200-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(135, 115, 95, 75),
        [System.Drawing.Rectangle]::new(395, 130, 100, 75)
    )
    'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png' = @(
        [System.Drawing.Rectangle]::new(220, 150, 60, 85),
        [System.Drawing.Rectangle]::new(505, 170, 60, 85)
    )
}

$destDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage"

foreach ($k in $testBoxes.Keys) {
    $src = "knd_sc_images/" + $k
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $src).Path)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Red, 3)
    foreach ($rect in $testBoxes[$k]) {
        $g.DrawRectangle($pen, $rect)
    }
    $pen.Dispose()
    $g.Dispose()
    $out = Join-Path $destDir ("box_" + $k.Replace('.png', '.jpg'))
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $bmp.Dispose()
    Write-Host "Saved: $out"
}
