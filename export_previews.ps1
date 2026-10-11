Add-Type -AssemblyName System.Drawing

# 1. EX 200 text crops
$b1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left crop: x=340..430, y=410..530
$c1Left = [System.Drawing.Bitmap]::new(120, 140)
$g = [System.Drawing.Graphics]::FromImage($c1Left)
$g.DrawImage($b1, [System.Drawing.Rectangle]::new(0,0,120,140), [System.Drawing.Rectangle]::new(330,400,120,140), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$c1Left.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\crop_ex200_left.png", [System.Drawing.Imaging.ImageFormat]::Png)
$c1Left.Dispose()

# Right crop: x=580..680, y=410..530
$c1Right = [System.Drawing.Bitmap]::new(120, 140)
$g = [System.Drawing.Graphics]::FromImage($c1Right)
$g.DrawImage($b1, [System.Drawing.Rectangle]::new(0,0,120,140), [System.Drawing.Rectangle]::new(580,410,120,140), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$c1Right.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\crop_ex200_right.png", [System.Drawing.Imaging.ImageFormat]::Png)
$c1Right.Dispose()
$b1.Dispose()

# 2. JCB DF crops
$b2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left crop: x=310..400, y=80..220
$c2Left = [System.Drawing.Bitmap]::new(120, 160)
$g = [System.Drawing.Graphics]::FromImage($c2Left)
$g.DrawImage($b2, [System.Drawing.Rectangle]::new(0,0,120,160), [System.Drawing.Rectangle]::new(300,75,120,160), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$c2Left.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\crop_jcbdf_left.png", [System.Drawing.Imaging.ImageFormat]::Png)
$c2Left.Dispose()

# Right crop: x=520..630, y=90..230
$c2Right = [System.Drawing.Bitmap]::new(130, 160)
$g = [System.Drawing.Graphics]::FromImage($c2Right)
$g.DrawImage($b2, [System.Drawing.Rectangle]::new(0,0,130,160), [System.Drawing.Rectangle]::new(520,85,130,160), [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$c2Right.Save("C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\crop_jcbdf_right.png", [System.Drawing.Imaging.ImageFormat]::Png)
$c2Right.Dispose()
$b2.Dispose()

Write-Host "Crops saved successfully!"
