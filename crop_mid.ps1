Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Crop x=380..470, y=420..520, scale 3x
$scale = 3
$w = 90; $h = 100
$bmpMid = [System.Drawing.Bitmap]::new($w * $scale, $h * $scale)
$g = [System.Drawing.Graphics]::FromImage($bmpMid)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $w * $scale, $h * $scale), [System.Drawing.Rectangle]::new(380, 420, $w, $h), [System.Drawing.GraphicsUnit]::Pixel)

$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

for ($x = 380; $x -le 470; $x += 10) {
    $dx = ($x - 380) * $scale
    $g.DrawLine($pen, $dx, 0, $dx, $h * $scale)
    $g.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 420; $y -le 520; $y += 10) {
    $dy = ($y - 420) * $scale
    $g.DrawLine($pen, 0, $dy, $w * $scale, $dy)
    $g.DrawString("$y", $font, $brush, 5, $dy)
}
$g.Dispose()
$bmpMid.Save("$cropDir/ex200_find_knd_mid.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpMid.Dispose()

$bmp.Dispose()
Write-Host "Mid crop saved."
