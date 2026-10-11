Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$penRed = [System.Drawing.Pen]::new([System.Drawing.Color]::Red, 2)
$penLime = [System.Drawing.Pen]::new([System.Drawing.Color]::Lime, 2)

$g.DrawRectangle($penRed, 360, 420, 40, 90)
$g.DrawRectangle($penLime, 390, 420, 40, 90)

$g.DrawRectangle($penRed, 590, 420, 40, 90)
$g.DrawRectangle($penLime, 620, 420, 40, 90)

$penRed.Dispose()
$penLime.Dispose()
$g.Dispose()

$dest = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\ex200_boxes_check.jpg"
$bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
Write-Host "Saved: $dest"
