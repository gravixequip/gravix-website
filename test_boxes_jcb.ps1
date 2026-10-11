Add-Type -AssemblyName System.Drawing
$b = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($b)
$g.FillRectangle([System.Drawing.Brushes]::Red, 260, 120, 60, 110)
$g.FillRectangle([System.Drawing.Brushes]::Blue, 560, 120, 60, 110)
$g.Dispose()

$out = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_color_boxes_jcb.jpg"
$b.Save($out, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$b.Dispose()
Write-Host "JCB boxes saved: $out"
