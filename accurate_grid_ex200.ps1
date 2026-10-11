Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
Write-Host "EX 200 Size: $($bmp.Width) x $($bmp.Height)"

# Draw red circles where we think KND is and save full overlay
$bmpGrid = [System.Drawing.Bitmap]::new($bmp)
$g = [System.Drawing.Graphics]::FromImage($bmpGrid)
$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Black)
$pen = [System.Drawing.Pen]::new([System.Drawing.Color]::Magenta, 1)

for ($x = 0; $x -lt $bmp.Width; $x += 50) {
    $g.DrawLine($pen, $x, 0, $x, $bmp.Height)
    $g.DrawString("$x", $font, $brush, $x, 10)
}
for ($y = 0; $y -lt $bmp.Height; $y += 50) {
    $g.DrawLine($pen, 0, $y, $bmp.Width, $y)
    $g.DrawString("$y", $font, $brush, 10, $y)
}
$g.Dispose()
$bmpGrid.Save("$cropDir/ex200_accurate_grid.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpGrid.Dispose()
$bmp.Dispose()
Write-Host "Accurate grid saved."
