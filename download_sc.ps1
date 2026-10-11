New-Item -ItemType Directory -Force -Path "knd_sc_images" | Out-Null
$files = @(
    'CAT_424-SIDE-CUTTER.png',
    'EX_100-SIDE-CUTTER.png',
    'EX_200-SIDE-CUTTER.png',
    'EX_60-SIDE-CUTTER.png',
    'HM_3036-SIDE-CUTTER.png',
    'JCB-DF-SIDE-CUTTER.png',
    'JCB-SF-SIDE-CUTTER.png',
    'LT_770-SIDE-CUTTER.png',
    'PC_200-SIDE-CUTTER.png',
    'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png',
    'TEREX-SIDE-CUTTER.png'
)
foreach ($f in $files) {
    $url = "https://www.kndtoothpoint.com/Product/Big/" + $f
    $dest = "knd_sc_images/" + $f
    & curl.exe -s -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" $url -o $dest
    $fi = Get-Item $dest
    Write-Host ($f + " -> " + $fi.Length + " bytes")
}
