Add-Type -AssemblyName System.Drawing

$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Crop left neck
$cL = [System.Drawing.Bitmap]::new(150, 200)
$g = [System.Drawing.Graphics]::FromImage($cL)
$g.DrawImage($b, [System.Drawing.Rectangle]::new(0,0,150,200), [System.Drawing.Rectangle]::new(300,70,150,200), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$cL.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\zoom_jcb_left_neck.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cL.Dispose()

# Crop right neck
$cR = [System.Drawing.Bitmap]::new(150, 200)
$g = [System.Drawing.Graphics]::FromImage($cR)
$g.DrawImage($b, [System.Drawing.Rectangle]::new(0,0,150,200), [System.Drawing.Rectangle]::new(560,70,150,200), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$cR.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\zoom_jcb_right_neck.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cR.Dispose()

$b.Dispose()
Write-Host "JCB necks saved!"
