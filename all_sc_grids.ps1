Add-Type -AssemblyName System.Drawing

$files = @(
    'CAT_424-SIDE-CUTTER.png',
    'EX_100-SIDE-CUTTER.png',
    'EX_200-SIDE-CUTTER.png',
    'EX_60-SIDE-CUTTER.png',
    'HM_3036-SIDE-CUTTER.png',
    'JCB-DF-SIDE-CUTTER.png',
    'PC_200-SIDE-CUTTER.png',
    'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png'
)

$destDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage"

foreach ($f in $files) {
    $src = "knd_sc_images/" + $f
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $src).Path)
    $g = [System.Drawing.Graphics]::FromImage($bmp)

    $pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(90, 255, 255, 255), 1)
    $font = [System.Drawing.Font]::new("Arial", 8)
    $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::White)

    for ($x = 0; $x -lt $bmp.Width; $x += 50) {
        $g.DrawLine($pen, $x, 0, $x, $bmp.Height)
        $g.DrawString($x.ToString(), $font, $brush, $x + 2, 5)
    }

    for ($y = 0; $y -lt $bmp.Height; $y += 50) {
        $g.DrawLine($pen, 0, $y, $bmp.Width, $y)
        $g.DrawString($y.ToString(), $font, $brush, 5, $y + 2)
    }

    $pen.Dispose(); $font.Dispose(); $brush.Dispose(); $g.Dispose()

    $out = Join-Path $destDir ("grid_" + $f.Replace('.png', '.jpg'))
    $bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $bmp.Dispose()
    Write-Host "Saved: $out"
}
