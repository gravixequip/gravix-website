Add-Type -AssemblyName System.Drawing

$configs = @(
    @{
        File = 'CAT_424-SIDE-CUTTER.png'
        Samples = @( @(190, 260), @(760, 260), @(720, 160) )
    },
    @{
        File = 'EX_100-SIDE-CUTTER.png'
        Samples = @( @(90, 250), @(480, 250) )
    },
    @{
        File = 'EX_200-SIDE-CUTTER.png'
        Samples = @( @(400, 370), @(640, 370) )
    },
    @{
        File = 'EX_60-SIDE-CUTTER.png'
        Samples = @( @(200, 260), @(670, 260) )
    },
    @{
        File = 'HM_3036-SIDE-CUTTER.png'
        Samples = @( @(330, 440), @(620, 440) )
    },
    @{
        File = 'JCB-DF-SIDE-CUTTER.png'
        Samples = @( @(280, 240), @(720, 240) )
    },
    @{
        File = 'PC_200-SIDE-CUTTER.png'
        Samples = @( @(220, 260), @(460, 270) )
    },
    @{
        File = 'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png'
        Samples = @( @(220, 270), @(720, 270) )
    }
)

foreach ($c in $configs) {
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path ("knd_sc_images/" + $c.File)).Path)
    Write-Host "=== $($c.File) ($($bmp.Width)x$($bmp.Height)) ==="
    foreach ($s in $c.Samples) {
        $x = $s[0]
        $y = $s[1]
        $col = $bmp.GetPixel($x, $y)
        Write-Host "  Sample ($x, $y): A=$($col.A), R=$($col.R), G=$($col.G), B=$($col.B)"
    }
    $bmp.Dispose()
}
