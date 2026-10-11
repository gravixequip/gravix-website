Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($bmpEx)
$brushRed = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(180, 255, 0, 0))

# What test_wide_erase modified:
$g.FillRectangle($brushRed, 370, 425, 35, 80)
$g.FillRectangle($brushRed, 608, 425, 35, 80)

$g.Dispose()
$bmpEx.Save("$cropDir/ex200_red_boxes.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpEx.Dispose()

Write-Host "Red boxes image saved."
