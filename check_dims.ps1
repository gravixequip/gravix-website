Add-Type -AssemblyName System.Drawing

$items = @(
    'EX_100-SIDE-CUTTER.png',
    'EX_200-SIDE-CUTTER.png',
    'EX_60-SIDE-CUTTER.png',
    'HM_3036-SIDE-CUTTER.png',
    'JCB-DF-SIDE-CUTTER.png',
    'PC_200-SIDE-CUTTER.png',
    'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png'
)

foreach ($f in $items) {
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path ("knd_sc_images/" + $f)).Path)
    Write-Host "$($f) -> $($bmp.Width) x $($bmp.Height)"
    $bmp.Dispose()
}
