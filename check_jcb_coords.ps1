Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$penRed = [System.Drawing.Pen]::new([System.Drawing.Color]::Red, 1)
$penBlue = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

# Left piece neck
for ($x = 300; $x -le 400; $x += 10) {
    $pen = if ($x % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, $x, 70, $x, 220)
    $g.DrawString("$x", $font, $brush, $x, 60)
}
for ($y = 70; $y -le 220; $y += 10) {
    $pen = if ($y % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, 300, $y, 400, $y)
    $g.DrawString("$y", $font, $brush, 280, $y)
}

# Right piece neck
for ($x = 590; $x -le 700; $x += 10) {
    $pen = if ($x % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, $x, 100, $x, 260)
    $g.DrawString("$x", $font, $brush, $x, 90)
}
for ($y = 100; $y -le 260; $y += 10) {
    $pen = if ($y % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, 590, $y, 700, $y)
    $g.DrawString("$y", $font, $brush, 570, $y)
}

$g.Dispose()
$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\grid_jcb_both.png"
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Saved: $out"
