Add-Type -AssemblyName System.Drawing

$cropDir = "C:\Users\shahal\.gemini\antigravity-ide\brain\f437a2aa-636d-47cc-9a8d-c1cd9b9fae39"

# 1. Process JCB DF
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)

# Left piece: y from 80 to 185, xc = 315 - 40 * ((y - 85)/90)
for ($y = 80; $y -le 185; $y++) {
    $t = ($y - 85) / 90.0
    $xc = 315.0 - 40.0 * $t
    $srcX = [int]($xc + 22)
    $srcCol = $bmpJcb.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int]($xc + $dx)
        if ($x -lt 0 -or $x -ge $bmpJcb.Width) { continue }
        $orig = $bmpJcb.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        # Smooth cosine blend edge
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Right piece: y from 85 to 190, xc = 505 + 25 * ((y - 90)/95)
for ($y = 85; $y -le 190; $y++) {
    $t = ($y - 90) / 95.0
    $xc = 505.0 + 25.0 * $t
    $srcX = [int]($xc - 22)
    $srcCol = $bmpJcb.GetPixel($srcX, $y)
    if ($srcCol.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int]($xc + $dx)
        if ($x -lt 0 -or $x -ge $bmpJcb.Width) { continue }
        $orig = $bmpJcb.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpJcb.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

$bmpJcb.Save("$cropDir/test_jcb_cleaned.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpJcb.Dispose()

# 2. Process EX 200
$bmpEx = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)

# Left piece: y from 415 to 515, xc = 390. Sample from clean flat metal at x = 368
for ($y = 415; $y -le 515; $y++) {
    $srcCol1 = $bmpEx.GetPixel(368, $y)
    $srcCol2 = $bmpEx.GetPixel(412, $y)
    if ($srcCol1.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int](390 + $dx)
        if ($x -lt 0 -or $x -ge $bmpEx.Width) { continue }
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        # interpolate reference between left and right clean metal
        $uRef = ($dx + $radius) / (2.0 * $radius)
        $refR = [int]($srcCol1.R * (1.0 - $uRef) + $srcCol2.R * $uRef)
        $refG = [int]($srcCol1.G * (1.0 - $uRef) + $srcCol2.G * $uRef)
        $refB = [int]($srcCol1.B * (1.0 - $uRef) + $srcCol2.B * $uRef)

        $finR = [int]($orig.R * (1.0 - $blend) + $refR * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $refG * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $refB * $blend)

        $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

# Right piece: y from 425 to 525, xc = 635. Sample from clean flat metal at x = 612
for ($y = 425; $y -le 525; $y++) {
    $srcCol = $bmpEx.GetPixel(612, $y)
    if ($srcCol.A -lt 150) { continue }

    $radius = 16.0
    for ($dx = -$radius; $dx -le $radius; $dx++) {
        $x = [int](635 + $dx)
        if ($x -lt 0 -or $x -ge $bmpEx.Width) { continue }
        $orig = $bmpEx.GetPixel($x, $y)
        if ($orig.A -lt 100) { continue }

        $norm = [Math]::Abs($dx) / $radius
        $blend = if ($norm -le 0.4) { 1.0 } else { 0.5 * (1.0 + [Math]::Cos((($norm - 0.4) / 0.6) * [Math]::PI)) }

        $finR = [int]($orig.R * (1.0 - $blend) + $srcCol.R * $blend)
        $finG = [int]($orig.G * (1.0 - $blend) + $srcCol.G * $blend)
        $finB = [int]($orig.B * (1.0 - $blend) + $srcCol.B * $blend)

        $bmpEx.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($orig.A, $finR, $finG, $finB))
    }
}

$bmpEx.Save("$cropDir/test_ex200_cleaned.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpEx.Dispose()

Write-Host "Both test cleaned images saved successfully."
