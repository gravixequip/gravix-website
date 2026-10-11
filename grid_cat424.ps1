Add-Type -AssemblyName System.Drawing

$srcPath = "knd_sc_images/CAT_424-SIDE-CUTTER.png"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)
$g = [System.Drawing.Graphics]::FromImage($bmp)

$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(100, 255, 255, 255), 1)
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

$pen.Dispose()
$font.Dispose()
$brush.Dispose()
$g.Dispose()

$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_grid.jpg"
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
Write-Host "Saved: $out"
