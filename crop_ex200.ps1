Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left Piece Detailed: x=360..440, y=420..530
$scale = 4
$wL = 80; $hL = 110
$xL0 = 360; $yL0 = 420
$bmpL = [System.Drawing.Bitmap]::new($wL * $scale, $hL * $scale)
$gL = [System.Drawing.Graphics]::FromImage($bmpL)
$gL.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$gL.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $wL * $scale, $hL * $scale), [System.Drawing.Rectangle]::new($xL0, $yL0, $wL, $hL), [System.Drawing.GraphicsUnit]::Pixel)

$font = [System.Drawing.Font]::new("Arial", 9)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

for ($x = 360; $x -le 440; $x += 10) {
    $dx = ($x - $xL0) * $scale
    $gL.DrawLine($pen, $dx, 0, $dx, $hL * $scale)
    $gL.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 420; $y -le 530; $y += 20) {
    $dy = ($y - $yL0) * $scale
    $gL.DrawLine($pen, 0, $dy, $wL * $scale, $dy)
    $gL.DrawString("$y", $font, $brush, 5, $dy)
}
$gL.Dispose()
$bmpL.Save("$cropDir/ex200_left_detail.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpL.Dispose()

# Right Piece Detailed: x=580..660, y=420..530
$wR = 80; $hR = 110
$xR0 = 580; $yR0 = 420
$bmpR = [System.Drawing.Bitmap]::new($wR * $scale, $hR * $scale)
$gR = [System.Drawing.Graphics]::FromImage($bmpR)
$gR.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$gR.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $wR * $scale, $hR * $scale), [System.Drawing.Rectangle]::new($xR0, $yR0, $wR, $hR), [System.Drawing.GraphicsUnit]::Pixel)

for ($x = 580; $x -le 660; $x += 10) {
    $dx = ($x - $xR0) * $scale
    $gR.DrawLine($pen, $dx, 0, $dx, $hR * $scale)
    $gR.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 420; $y -le 530; $y += 20) {
    $dy = ($y - $yR0) * $scale
    $gR.DrawLine($pen, 0, $dy, $wR * $scale, $dy)
    $gR.DrawString("$y", $font, $brush, 5, $dy)
}
$gR.Dispose()
$bmpR.Save("$cropDir/ex200_right_detail.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpR.Dispose()

$bmp.Dispose()
Write-Host "EX200 detail crops saved."
