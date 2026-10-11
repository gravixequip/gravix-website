Add-Type -AssemblyName System.Drawing

$srcPath = "knd_sc_images/CAT_424-SIDE-CUTTER.png"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

$g = [System.Drawing.Graphics]::FromImage($bmp)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Magenta, 3)

$g.DrawRectangle($pen, 225, 170, 115, 220)
$g.DrawRectangle($pen, 665, 215, 110, 225)

$pen.Dispose()
$g.Dispose()

$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_diag.jpg"
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
Write-Host "Saved: $out"
