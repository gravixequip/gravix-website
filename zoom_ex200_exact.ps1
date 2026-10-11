Add-Type -AssemblyName System.Drawing

$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece crop
$cL = [System.Drawing.Bitmap]::new(120, 140)
$g = [System.Drawing.Graphics]::FromImage($cL)
$g.DrawImage($b, [System.Drawing.Rectangle]::new(0,0,120,140), [System.Drawing.Rectangle]::new(340,415,120,140), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$cL.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\exact_ex200_left.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cL.Dispose()

# Right piece crop
$cR = [System.Drawing.Bitmap]::new(120, 140)
$g = [System.Drawing.Graphics]::FromImage($cR)
$g.DrawImage($b, [System.Drawing.Rectangle]::new(0,0,120,140), [System.Drawing.Rectangle]::new(570,415,120,140), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$cR.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\exact_ex200_right.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cR.Dispose()

$b.Dispose()
Write-Host "EX 200 exact crops saved!"
