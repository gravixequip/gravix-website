Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($bmpEx)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(180, 255, 0, 255))

$g.FillRectangle($brush, 295, 410, 35, 85)
$g.FillRectangle($brush, 485, 410, 35, 85)

$g.Dispose()
$bmpEx.Save("$cropDir/ex200_target_check.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpEx.Dispose()

Write-Host "Target check saved."
