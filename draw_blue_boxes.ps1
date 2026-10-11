Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($bmpEx)
$brushBlue = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(180, 0, 100, 255))

$g.FillRectangle($brushBlue, 295, 425, 35, 80)
$g.FillRectangle($brushBlue, 530, 425, 35, 80)

$g.Dispose()
$bmpEx.Save("$cropDir/ex200_blue_boxes.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpEx.Dispose()

Write-Host "Blue boxes image saved."
