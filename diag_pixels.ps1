Add-Type -AssemblyName System.Drawing

$b1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
Write-Host "--- EX 200 Left Piece ---"
Write-Host "Hole at (330, 405): A=$($b1.GetPixel(330, 405).A)"
Write-Host "Text region center (385, 470): RGB=($($b1.GetPixel(385, 470).R),$($b1.GetPixel(385, 470).G),$($b1.GetPixel(385, 470).B))"
Write-Host "Clean metal at (420, 470): RGB=($($b1.GetPixel(420, 470).R),$($b1.GetPixel(420, 470).G),$($b1.GetPixel(420, 470).B))"
Write-Host "Hole at (450, 470): A=$($b1.GetPixel(450, 470).A)"

Write-Host "`n--- EX 200 Right Piece ---"
Write-Host "Hole at (570, 470): A=$($b1.GetPixel(570, 470).A)"
Write-Host "Text region center (630, 470): RGB=($($b1.GetPixel(630, 470).R),$($b1.GetPixel(630, 470).G),$($b1.GetPixel(630, 470).B))"
Write-Host "Clean metal at (500, 470): RGB=($($b1.GetPixel(500, 470).R),$($b1.GetPixel(500, 470).G),$($b1.GetPixel(500, 470).B))"

$b1.Dispose()

$b2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
Write-Host "`n--- JCB DF Left Piece ---"
Write-Host "Text region center (350, 150): RGB=($($b2.GetPixel(350, 150).R),$($b2.GetPixel(350, 150).G),$($b2.GetPixel(350, 150).B))"
Write-Host "Right neck metal (400, 150): RGB=($($b2.GetPixel(400, 150).R),$($b2.GetPixel(400, 150).G),$($b2.GetPixel(400, 150).B))"

Write-Host "`n--- JCB DF Right Piece ---"
Write-Host "Text region center (640, 190): RGB=($($b2.GetPixel(640, 190).R),$($b2.GetPixel(640, 190).G),$($b2.GetPixel(640, 190).B))"
Write-Host "Neck metal at (700, 190): RGB=($($b2.GetPixel(700, 190).R),$($b2.GetPixel(700, 190).G),$($b2.GetPixel(700, 190).B)), A=$($b2.GetPixel(700, 190).A)"

$b2.Dispose()
