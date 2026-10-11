Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# 1. Left Piece Zoom 1: y=70..220, x=300..420
$zL1 = [System.Drawing.Bitmap]::new(400, 500)
$g1 = [System.Drawing.Graphics]::FromImage($zL1)
$g1.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g1.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 400, 500), [System.Drawing.Rectangle]::new(300, 70, 120, 150), [System.Drawing.GraphicsUnit]::Pixel)
$g1.Dispose()
$zL1.Save("$cropDir/jcb_zoom_left_top.png", [System.Drawing.Imaging.ImageFormat]::Png)
$zL1.Dispose()

# 2. Left Piece Zoom 2: y=180..320, x=300..420
$zL2 = [System.Drawing.Bitmap]::new(400, 500)
$g2 = [System.Drawing.Graphics]::FromImage($zL2)
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g2.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 400, 500), [System.Drawing.Rectangle]::new(300, 180, 120, 150), [System.Drawing.GraphicsUnit]::Pixel)
$g2.Dispose()
$zL2.Save("$cropDir/jcb_zoom_left_mid.png", [System.Drawing.Imaging.ImageFormat]::Png)
$zL2.Dispose()

# 3. Right Piece Zoom 1: y=70..220, x=580..700
$zR1 = [System.Drawing.Bitmap]::new(400, 500)
$g3 = [System.Drawing.Graphics]::FromImage($zR1)
$g3.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g3.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 400, 500), [System.Drawing.Rectangle]::new(580, 70, 120, 150), [System.Drawing.GraphicsUnit]::Pixel)
$g3.Dispose()
$zR1.Save("$cropDir/jcb_zoom_right_top.png", [System.Drawing.Imaging.ImageFormat]::Png)
$zR1.Dispose()

# 4. Right Piece Zoom 2: y=180..320, x=580..700
$zR2 = [System.Drawing.Bitmap]::new(400, 500)
$g4 = [System.Drawing.Graphics]::FromImage($zR2)
$g4.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g4.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 400, 500), [System.Drawing.Rectangle]::new(580, 180, 120, 150), [System.Drawing.GraphicsUnit]::Pixel)
$g4.Dispose()
$zR2.Save("$cropDir/jcb_zoom_right_mid.png", [System.Drawing.Imaging.ImageFormat]::Png)
$zR2.Dispose()

$bmp.Dispose()
Write-Host "JCB Zooms created"
