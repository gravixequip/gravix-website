Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# 8x zoom of the top tip of left neck: x=290..335, y=55..95
$scale = 8
$w = 45; $h = 40
$bmpTip = [System.Drawing.Bitmap]::new($w * $scale, $h * $scale)
$g = [System.Drawing.Graphics]::FromImage($bmpTip)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$g.DrawImage($bmp, [System.Drawing.Rectangle]::new(0, 0, $w * $scale, $h * $scale), [System.Drawing.Rectangle]::new(290, 55, $w, $h), [System.Drawing.GraphicsUnit]::Pixel)

$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

for ($x = 290; $x -le 335; $x += 5) {
    $dx = ($x - 290) * $scale
    $g.DrawLine($pen, $dx, 0, $dx, $h * $scale)
    $g.DrawString("$x", $font, $brush, $dx, 5)
}
for ($y = 55; $y -le 95; $y += 5) {
    $dy = ($y - 55) * $scale
    $g.DrawLine($pen, 0, $dy, $w * $scale, $dy)
    $g.DrawString("$y", $font, $brush, 5, $dy)
}
$g.Dispose()
$bmpTip.Save("$cropDir/jcb_tip_zoom.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpTip.Dispose()
$bmp.Dispose()
Write-Host "Tip zoom saved."
