Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"

# 1. Coordinate Grid for EX 200
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$gridEx = [System.Drawing.Bitmap]::new(800, 600)
$g = [System.Drawing.Graphics]::FromImage($gridEx)
$g.Clear([System.Drawing.Color]::White)
$g.DrawImage($bmpEx, 0, 0, 800, 600)
$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$penRed = [System.Drawing.Pen]::new([System.Drawing.Color]::Red, 1)
$penBlue = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

for ($x = 200; $x -le 700; $x += 20) {
    $pen = if ($x % 100 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, $x, 300, $x, 600)
    $g.DrawString("$x", $font, $brush, $x, 300)
}
for ($y = 300; $y -le 600; $y += 20) {
    $pen = if ($y % 100 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, 200, $y, 700, $y)
    $g.DrawString("$y", $font, $brush, 200, $y)
}
$g.Dispose()
$bmpEx.Dispose()
$gridEx.Save("$cropDir/ex200_grid.png", [System.Drawing.Imaging.ImageFormat]::Png)
$gridEx.Dispose()

# 2. Coordinate Grid for JCB DF
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
$gridJcb = [System.Drawing.Bitmap]::new(800, 600)
$g2 = [System.Drawing.Graphics]::FromImage($gridJcb)
$g2.Clear([System.Drawing.Color]::White)
$g2.DrawImage($bmpJcb, 0, 0, 800, 600)
for ($x = 100; $x -le 700; $x += 20) {
    $pen = if ($x % 100 -eq 0) { $penRed } else { $penBlue }
    $g2.DrawLine($pen, $x, 50, $x, 400)
    $g2.DrawString("$x", $font, $brush, $x, 50)
}
for ($y = 50; $y -le 400; $y += 20) {
    $pen = if ($y % 100 -eq 0) { $penRed } else { $penBlue }
    $g2.DrawLine($pen, 100, $y, 700, $y)
    $g2.DrawString("$y", $font, $brush, 100, $y)
}
$g2.Dispose()
$bmpJcb.Dispose()
$gridJcb.Save("$cropDir/jcb_full_grid.png", [System.Drawing.Imaging.ImageFormat]::Png)
$gridJcb.Dispose()

Write-Host "Grid images saved."
