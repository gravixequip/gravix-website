Add-Type -AssemblyName System.Drawing

# 1. Grid on EX 200
$bmp1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$g1 = [System.Drawing.Graphics]::FromImage($bmp1)
$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$penRed = [System.Drawing.Pen]::new([System.Drawing.Color]::Red, 1)
$penBlue = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

# Draw vertical lines every 25 px between 250 and 700
for ($x = 250; $x -le 700; $x += 25) {
    $pen = if ($x % 50 -eq 0) { $penRed } else { $penBlue }
    $g1.DrawLine($pen, $x, 380, $x, 600)
    $g1.DrawString("$x", $font, $brush, $x, 370)
}
# Draw horizontal lines every 25 px between 380 and 600
for ($y = 380; $y -le 600; $y += 25) {
    $pen = if ($y % 50 -eq 0) { $penRed } else { $penBlue }
    $g1.DrawLine($pen, 250, $y, 700, $y)
    $g1.DrawString("$y", $font, $brush, 230, $y)
}
$g1.Dispose()
$out1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\grid_ex200.png"
$bmp1.Save($out1, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp1.Dispose()
Write-Host "Saved EX 200 grid: $out1"

# 2. Grid on JCB DF
$bmp2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
$g2 = [System.Drawing.Graphics]::FromImage($bmp2)

# Left neck is roughly x=280..420, y=50..250
for ($x = 260; $x -le 440; $x += 20) {
    $pen = if ($x % 40 -eq 0) { $penRed } else { $penBlue }
    $g2.DrawLine($pen, $x, 50, $x, 260)
    $g2.DrawString("$x", $font, $brush, $x, 40)
}
for ($y = 50; $y -le 260; $y += 20) {
    $pen = if ($y % 40 -eq 0) { $penRed } else { $penBlue }
    $g2.DrawLine($pen, 260, $y, 440, $y)
    $g2.DrawString("$y", $font, $brush, 240, $y)
}
$g2.Dispose()
$out2 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\grid_jcbdf.png"
$bmp2.Save($out2, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp2.Dispose()
Write-Host "Saved JCB DF grid: $out2"
