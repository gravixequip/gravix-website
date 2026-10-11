Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$font = [System.Drawing.Font]::new("Arial", 8)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::Red)
$penRed = [System.Drawing.Pen]::new([System.Drawing.Color]::Red, 1)
$penBlue = [System.Drawing.Pen]::new([System.Drawing.Color]::Blue, 1)

# Left piece: between holes around x=360..430, y=410..520
for ($x = 360; $x -le 430; $x += 10) {
    $pen = if ($x % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, $x, 410, $x, 520)
    $g.DrawString("$x", $font, $brush, $x, 400)
}
for ($y = 410; $y -le 520; $y += 10) {
    $pen = if ($y % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, 360, $y, 430, $y)
    $g.DrawString("$y", $font, $brush, 340, $y)
}

# Right piece: between holes around x=600..670, y=420..530
for ($x = 600; $x -le 670; $x += 10) {
    $pen = if ($x % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, $x, 420, $x, 530)
    $g.DrawString("$x", $font, $brush, $x, 410)
}
for ($y = 420; $y -le 530; $y += 10) {
    $pen = if ($y % 20 -eq 0) { $penRed } else { $penBlue }
    $g.DrawLine($pen, 600, $y, 670, $y)
    $g.DrawString("$y", $font, $brush, 580, $y)
}

$g.Dispose()
$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\zoom_ex200.png"
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Host "Saved: $out"
