Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
$g = [System.Drawing.Graphics]::FromImage($bmpJcb)
$brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(180, 255, 0, 255))

# Left neck sweep box
for ($y = 65; $y -le 185; $y++) {
    $t = ($y - 65) / 120.0
    $xc = 322.0 - 47.0 * $t
    $g.FillRectangle($brush, [int]($xc - 15), $y, 30, 1)
}

# Right neck sweep box
for ($y = 85; $y -le 190; $y++) {
    $t = ($y - 85) / 105.0
    $xc = 505.0 + 25.0 * $t
    $g.FillRectangle($brush, [int]($xc - 15), $y, 30, 1)
}

$g.Dispose()
$bmpJcb.Save("$cropDir/jcb_target_check.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpJcb.Dispose()

Write-Host "JCB Target check saved."
