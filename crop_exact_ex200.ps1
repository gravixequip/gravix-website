Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# 1. Left Piece: x=400..460, y=410..520 (w=60, h=110), scale 4x
$scale = 4
$w = 60; $h = 110
$bmpL = [System.Drawing.Bitmap]::new($w * $scale, $h * $scale)
$g = [System.Drawing.Graphics]::FromImage($bmpL)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $w * $scale, $h * $scale), [System.Drawing.Rectangle]::new(400, 410, $w, $h), [System.Drawing.GraphicsUnit]::Pixel)

$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

for ($x = 400; $x -le 460; $x += 10) {
    $dx = ($x - 400) * $scale
    $g.DrawLine($pen, $dx, 0, $dx, $h * $scale)
    $g.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 410; $y -le 520; $y += 10) {
    $dy = ($y - 410) * $scale
    $g.DrawLine($pen, 0, $dy, $w * $scale, $dy)
    $g.DrawString("$y", $font, $brush, 5, $dy)
}
$g.Dispose()
$bmpL.Save("$cropDir/ex200_left_knd_exact.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpL.Dispose()

# 2. Right Piece: x=580..650, y=410..520 (w=70, h=110), scale 4x
$w2 = 70
$bmpR = [System.Drawing.Bitmap]::new($w2 * $scale, $h * $scale)
$g2 = [System.Drawing.Graphics]::FromImage($bmpR)
$g2.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g2.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $w2 * $scale, $h * $scale), [System.Drawing.Rectangle]::new(580, 410, $w2, $h), [System.Drawing.GraphicsUnit]::Pixel)

for ($x = 580; $x -le 650; $x += 10) {
    $dx = ($x - 580) * $scale
    $g2.DrawLine($pen, $dx, 0, $dx, $h * $scale)
    $g2.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 410; $y -le 520; $y += 10) {
    $dy = ($y - 410) * $scale
    $g2.DrawLine($pen, 0, $dy, $w2 * $scale, $dy)
    $g2.DrawString("$y", $font, $brush, 5, $dy)
}
$g2.Dispose()
$bmpR.Save("$cropDir/ex200_right_knd_exact.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpR.Dispose()

$bmp.Dispose()
Write-Host "Exact KND crops saved."
