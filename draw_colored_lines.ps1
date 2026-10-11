Add-Type -AssemblyName System.Drawing

# 1. EX 200
$b1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "assets/products/ex-200-side-cutter.jpeg").Path)
$g1 = [System.Drawing.Graphics]::FromImage($b1)
$font = [System.Drawing.Font]::new("Arial", 12)

# Since assets/products is 1254x1254, scale was 1020/800 = 1.275, posX = (1254-1020)/2 = 117, posY = 130
# Let's draw directly on the raw PNG knd_sc_images/EX_200-SIDE-CUTTER.png
$g1.Dispose()
$b1.Dispose()

$raw1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$gr1 = [System.Drawing.Graphics]::FromImage($raw1)

$colors = @([System.Drawing.Color]::Red, [System.Drawing.Color]::Lime, [System.Drawing.Color]::Blue, [System.Drawing.Color]::Yellow, [System.Drawing.Color]::Cyan, [System.Drawing.Color]::Magenta)
$xs = @(580, 600, 620, 640, 660, 680)

for ($i = 0; $i -lt $xs.Count; $i++) {
    $x = $xs[$i]
    $pen = [System.Drawing.Pen]::new($colors[$i], 2)
    $gr1.DrawLine($pen, $x, 380, $x, 560)
    $brush = [System.Drawing.SolidBrush]::new($colors[$i])
    $gr1.DrawString("$x", $font, $brush, $x - 10, 360)
}
$gr1.Dispose()
$dest1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\lines_ex200.jpg"
$raw1.Save($dest1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$raw1.Dispose()
Write-Host "EX 200 lines: $dest1"

# 2. JCB DF
$raw2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
$gr2 = [System.Drawing.Graphics]::FromImage($raw2)
$xs2 = @(280, 300, 320, 340, 360, 380)

for ($i = 0; $i -lt $xs2.Count; $i++) {
    $x = $xs2[$i]
    $pen = [System.Drawing.Pen]::new($colors[$i], 2)
    $gr2.DrawLine($pen, $x, 50, $x, 220)
    $brush = [System.Drawing.SolidBrush]::new($colors[$i])
    $gr2.DrawString("$x", $font, $brush, $x - 10, 30)
}
$gr2.Dispose()
$dest2 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\lines_jcbdf.jpg"
$raw2.Save($dest2, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$raw2.Dispose()
Write-Host "JCB DF lines: $dest2"
