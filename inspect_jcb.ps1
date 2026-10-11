Add-Type -AssemblyName System.Drawing

$src = "knd_sc_images/JCB-DF-SIDE-CUTTER.png"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $src).Path)
Write-Host "Width: $($bmp.Width), Height: $($bmp.Height)"

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
if (!(Test-Path $cropDir)) {
    New-Item -ItemType Directory -Path $cropDir -Force | Out-Null
}

# Crop left piece top neck
$cropLeft = [System.Drawing.Bitmap]::new(200, 250)
$gL = [System.Drawing.Graphics]::FromImage($cropLeft)
$gL.Clear([System.Drawing.Color]::White)
$gL.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 200, 250), [System.Drawing.Rectangle]::new(250, 50, 200, 250), [System.Drawing.GraphicsUnit]::Pixel)
$gL.Dispose()
$cropLeft.Save("$cropDir/jcb_orig_left_neck.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropLeft.Dispose()

# Crop right piece top neck
$cropRight = [System.Drawing.Bitmap]::new(200, 250)
$gR = [System.Drawing.Graphics]::FromImage($cropRight)
$gR.Clear([System.Drawing.Color]::White)
$gR.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 200, 250), [System.Drawing.Rectangle]::new(500, 50, 200, 250), [System.Drawing.GraphicsUnit]::Pixel)
$gR.Dispose()
$cropRight.Save("$cropDir/jcb_orig_right_neck.png", [System.Drawing.Imaging.ImageFormat]::Png)
$cropRight.Dispose()

# Grid on Left Neck (250,50 to 450,300)
$gridL = [System.Drawing.Bitmap]::new(300, 300)
$gGL = [System.Drawing.Graphics]::FromImage($gridL)
$gGL.Clear([System.Drawing.Color]::White)
$gGL.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 300, 300), [System.Drawing.Rectangle]::new(250, 50, 300, 300), [System.Drawing.GraphicsUnit]::Pixel)
$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$penRed = [System.Drawing.Pen]::new([System.Drawing.Color]::Red, 1)
$penBlue = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

for ($x = 250; $x -le 550; $x += 20) {
    $drawX = $x - 250
    $gGL.DrawLine($penBlue, $drawX, 0, $drawX, 300)
    $gGL.DrawString("$x", $font, $brush, $drawX, 5)
}
for ($y = 50; $y -le 350; $y += 20) {
    $drawY = $y - 50
    $gGL.DrawLine($penBlue, 0, $drawY, 300, $drawY)
    $gGL.DrawString("$y", $font, $brush, 5, $drawY)
}
$gGL.Dispose()
$gridL.Save("$cropDir/jcb_grid_left.png", [System.Drawing.Imaging.ImageFormat]::Png)
$gridL.Dispose()

# Grid on Right Neck (500,50 to 750,300)
$gridR = [System.Drawing.Bitmap]::new(300, 300)
$gGR = [System.Drawing.Graphics]::FromImage($gridR)
$gGR.Clear([System.Drawing.Color]::White)
$gGR.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, 300, 300), [System.Drawing.Rectangle]::new(500, 50, 300, 300), [System.Drawing.GraphicsUnit]::Pixel)
for ($x = 500; $x -le 800; $x += 20) {
    $drawX = $x - 500
    $gGR.DrawLine($penBlue, $drawX, 0, $drawX, 300)
    $gGR.DrawString("$x", $font, $brush, $drawX, 5)
}
for ($y = 50; $y -le 350; $y += 20) {
    $drawY = $y - 50
    $gGR.DrawLine($penBlue, 0, $drawY, 300, $drawY)
    $gGR.DrawString("$y", $font, $brush, 5, $drawY)
}
$gGR.Dispose()
$gridR.Save("$cropDir/jcb_grid_right.png", [System.Drawing.Imaging.ImageFormat]::Png)
$gridR.Dispose()

$bmp.Dispose()
Write-Host "Inspection images generated."
