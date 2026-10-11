Add-Type -AssemblyName System.Drawing

function Remove-EmbossedMedian {
    param(
        [System.Drawing.Bitmap]$bmp,
        [int]$rx, [int]$ry, [int]$rw, [int]$rh,
        [int]$radius = 7
    )
    $w = $bmp.Width
    $h = $bmp.Height

    # Make a copy of region
    $patch = [System.Drawing.Bitmap]::new($rw, $rh)
    for ($y = 0; $y -lt $rh; $y++) {
        for ($x = 0; $x -lt $rw; $x++) {
            $patch.SetPixel($x, $y, $bmp.GetPixel($rx + $x, $ry + $y))
        }
    }

    # For each pixel in the region, compute median R, G, B among valid metal neighbors
    for ($y = 0; $y -lt $rh; $y++) {
        $py = $ry + $y
        for ($x = 0; $x -lt $rw; $x++) {
            $px = $rx + $x
            $orig = $patch.GetPixel($x, $y)
            if ($orig.A -lt 120) { continue }

            $rList = [System.Collections.Generic.List[int]]::new()
            $gList = [System.Collections.Generic.List[int]]::new()
            $bList = [System.Collections.Generic.List[int]]::new()

            for ($dy = -$radius; $dy -le $radius; $dy++) {
                $ny = $y + $dy
                if ($ny -lt 0 -or $ny -ge $rh) { continue }
                for ($dx = -$radius; $dx -le $radius; $dx++) {
                    $nx = $x + $dx
                    if ($nx -lt 0 -or $nx -ge $rw) { continue }

                    $d = [Math]::Sqrt($dx * $dx + $dy * $dy)
                    if ($d -gt $radius) { continue }

                    $sample = $patch.GetPixel($nx, $ny)
                    if ($sample.A -ge 120 -and $sample.R -gt 100) {
                        $rList.Add($sample.R)
                        $gList.Add($sample.G)
                        $bList.Add($sample.B)
                    }
                }
            }

            if ($rList.Count -gt 5) {
                $rList.Sort()
                $gList.Sort()
                $bList.Sort()
                $mid = [int]($rList.Count / 2)
                $medR = $rList[$mid]
                $medG = $gList[$mid]
                $medB = $bList[$mid]

                # Soft blend toward boundaries
                $distEdgeX = [Math]::Min($x, $rw - 1 - $x) / [double][Math]::Max(1, $radius * 2)
                $distEdgeY = [Math]::Min($y, $rh - 1 - $y) / [double][Math]::Max(1, $radius * 2)
                $edgeFactor = [Math]::Min(1.0, [Math]::Min($distEdgeX, $distEdgeY))

                $finalR = [int]($orig.R * (1.0 - $edgeFactor) + $medR * $edgeFactor)
                $finalG = [int]($orig.G * (1.0 - $edgeFactor) + $medG * $edgeFactor)
                $finalB = [int]($orig.B * (1.0 - $edgeFactor) + $medB * $edgeFactor)

                $bmp.SetPixel($px, $py, [System.Drawing.Color]::FromArgb($orig.A, $finalR, $finalG, $finalB))
            }
        }
    }
    $patch.Dispose()
}

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/CAT_424-SIDE-CUTTER.png").Path)

# Repeat 2 passes with radius 8 for complete smoothness
Remove-EmbossedMedian -bmp $bmp -rx 170 -ry 120 -rw 140 -rh 180 -radius 8
Remove-EmbossedMedian -bmp $bmp -rx 170 -ry 120 -rw 140 -rh 180 -radius 8

Remove-EmbossedMedian -bmp $bmp -rx 600 -ry 140 -rw 120 -rh 160 -radius 8
Remove-EmbossedMedian -bmp $bmp -rx 600 -ry 140 -rw 120 -rh 160 -radius 8

$dest = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_median_test.jpg"
$bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
Write-Host "Saved: $dest"
