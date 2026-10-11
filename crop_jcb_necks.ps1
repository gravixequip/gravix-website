Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left Neck Detailed: x=260..350 (w=90), y=60..220 (h=160), scale 4x
$scale = 4
$wL = 90; $hL = 160
$xL0 = 260; $yL0 = 60
$bmpL = [System.Drawing.Bitmap]::new($wL * $scale, $hL * $scale)
$gL = [System.Drawing.Graphics]::FromImage($bmpL)
$gL.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$gL.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $wL * $scale, $hL * $scale), [System.Drawing.Rectangle]::new($xL0, $yL0, $wL, $hL), [System.Drawing.GraphicsUnit]::Pixel)

$font = [System.Drawing.Font]::new("Arial", 9)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

for ($x = 260; $x -le 350; $x += 10) {
    $dx = ($x - $xL0) * $scale
    $gL.DrawLine($pen, $dx, 0, $dx, $hL * $scale)
    $gL.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 60; $y -le 220; $y += 20) {
    $dy = ($y - $yL0) * $scale
    $gL.DrawLine($pen, 0, $dy, $wL * $scale, $dy)
    $gL.DrawString("$y", $font, $brush, 5, $dy)
}
$gL.Dispose()
$bmpL.Save("$cropDir/jcb_left_neck_detail.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpL.Dispose()

# Right Neck Detailed: x=460..550 (w=90), y=60..220 (h=160), scale 4x
$wR = 90; $hR = 160
$xR0 = 460; $yR0 = 60
$bmpR = [System.Drawing.Bitmap]::new($wR * $scale, $hR * $scale)
$gR = [System.Drawing.Graphics]::FromImage($bmpR)
$gR.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$gR.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $wR * $scale, $hR * $scale), [System.Drawing.Rectangle]::new($xR0, $yR0, $wR, $hR), [System.Drawing.GraphicsUnit]::Pixel)

for ($x = 460; $x -le 550; $x += 10) {
    $dx = ($x - $xR0) * $scale
    $gR.DrawLine($pen, $dx, 0, $dx, $hR * $scale)
    $gR.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 60; $y -le 220; $y += 20) {
    $dy = ($y - $yR0) * $scale
    $gR.DrawLine($pen, 0, $dy, $wR * $scale, $dy)
    $gR.DrawString("$y", $font, $brush, 5, $dy)
}
$gR.Dispose()
$bmpR.Save("$cropDir/jcb_right_neck_detail.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpR.Dispose()

$bmp.Dispose()
Write-Host "Detailed neck crops saved."
