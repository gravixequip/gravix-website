$csharpCode = @"
using System;
using System.Drawing;
using System.Collections.Generic;

public class FastCleaner {
    public static void CleanEmbossed(Bitmap bmp, int rx, int ry, int rw, int rh, int radius) {
        int w = bmp.Width;
        int h = bmp.Height;

        rx = Math.Max(0, rx);
        ry = Math.Max(0, ry);
        if (rx >= w || ry >= h) return;
        rw = Math.Min(w - rx, rw);
        rh = Math.Min(h - ry, rh);
        if (rw <= 0 || rh <= 0) return;

        Bitmap patch = new Bitmap(rw, rh);
        using (Graphics g = Graphics.FromImage(patch)) {
            g.DrawImage(bmp, new Rectangle(0, 0, rw, rh), new Rectangle(rx, ry, rw, rh), GraphicsUnit.Pixel);
        }

        for (int y = 0; y < rh; y++) {
            int py = ry + y;
            for (int x = 0; x < rw; x++) {
                int px = rx + x;
                Color orig = patch.GetPixel(x, y);
                if (orig.A < 120 || (orig.R < 80 && orig.G < 80)) continue;

                List<int> rList = new List<int>(128);
                List<int> gList = new List<int>(128);
                List<int> bList = new List<int>(128);

                for (int dy = -radius; dy <= radius; dy++) {
                    int ny = y + dy;
                    if (ny < 0 || ny >= rh) continue;
                    for (int dx = -radius; dx <= radius; dx++) {
                        int nx = x + dx;
                        if (nx < 0 || nx >= rw) continue;
                        if (dx * dx + dy * dy > radius * radius) continue;

                        Color s = patch.GetPixel(nx, ny);
                        if (s.A >= 120 && (s.R > 100 || s.G > 100)) {
                            rList.Add(s.R);
                            gList.Add(s.G);
                            bList.Add(s.B);
                        }
                    }
                }

                if (rList.Count > 8) {
                    rList.Sort();
                    gList.Sort();
                    bList.Sort();
                    int mid = rList.Count / 2;
                    int medR = rList[mid];
                    int medG = gList[mid];
                    int medB = bList[mid];

                    double distEdgeX = Math.Min(x, rw - 1 - x) / Math.Max(1.0, radius * 1.5);
                    double distEdgeY = Math.Min(y, rh - 1 - y) / Math.Max(1.0, radius * 1.5);
                    double edgeFactor = Math.Min(1.0, Math.Min(distEdgeX, distEdgeY));
                    double blend = 0.5 * (1.0 - Math.Cos(edgeFactor * Math.PI));

                    int finalR = (int)(orig.R * (1.0 - blend) + medR * blend);
                    int finalG = (int)(orig.G * (1.0 - blend) + medG * blend);
                    int finalB = (int)(orig.B * (1.0 - blend) + medB * blend);

                    bmp.SetPixel(px, py, Color.FromArgb(orig.A, finalR, finalG, finalB));
                }
            }
        }
        patch.Dispose();
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies System.Drawing

$items = @(
    @{
        File = 'CAT_424-SIDE-CUTTER.png'
        Out = 'cat-424-side-cutter.jpeg'
        Title = 'CAT 424'
        Sub = 'SIDE CUTTER'
        LeftBox = @(170, 120, 140, 180)
        RightBox = @(520, 130, 140, 230)
    },
    @{
        File = 'EX_100-SIDE-CUTTER.png'
        Out = 'ex-100-side-cutter.jpeg'
        Title = 'EX 100'
        Sub = 'SIDE CUTTER'
        LeftBox = @(35, 130, 55, 100)
        RightBox = @(485, 135, 55, 105)
    },
    @{
        File = 'EX_200-SIDE-CUTTER.png'
        Out = 'ex-200-side-cutter.jpeg'
        Title = 'EX 200'
        Sub = 'SIDE CUTTER'
        LeftBox = @(365, 420, 70, 105)
        RightBox = @(600, 420, 70, 105)
    },
    @{
        File = 'EX_60-SIDE-CUTTER.png'
        Out = 'ex-60-side-cutter.jpeg'
        Title = 'EX 60'
        Sub = 'SIDE CUTTER'
        LeftBox = @(115, 115, 135, 115)
        RightBox = @(555, 115, 135, 115)
    },
    @{
        File = 'HM_3036-SIDE-CUTTER.png'
        Out = 'hm-3036-side-cutter.jpeg'
        Title = 'HM 3036'
        Sub = 'SIDE CUTTER'
        LeftBox = @(195, 310, 130, 75)
        RightBox = @(475, 310, 130, 75)
    },
    @{
        File = 'JCB-DF-SIDE-CUTTER.png'
        Out = 'jcb-df-side-cutter.jpeg'
        Title = 'JCB DF'
        Sub = 'SIDE CUTTER'
        LeftBox = @(255, 80, 120, 210)
        RightBox = @(515, 80, 120, 210)
    },
    @{
        File = 'PC_200-SIDE-CUTTER.png'
        Out = 'pc-200-side-cutter.jpeg'
        Title = 'PC 200'
        Sub = 'SIDE CUTTER'
        LeftBox = @(125, 130, 130, 90)
        RightBox = @(390, 155, 130, 90)
    },
    @{
        File = 'TEREX-DOUBLE-FLANGE-SIDE-CUTTER.png'
        Out = 'terex-df-side-cutter.jpeg'
        Title = 'TEREX DF'
        Sub = 'SIDE CUTTER'
        LeftBox = @(215, 125, 90, 130)
        RightBox = @(500, 140, 90, 130)
    }
)

foreach ($item in $items) {
    $srcPath = "knd_sc_images/" + $item.File
    $bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $srcPath).Path)

    # Clean left & right embossed lettering (2 passes for smooth metallic texture)
    $lb = $item.LeftBox
    [FastCleaner]::CleanEmbossed($bmp, $lb[0], $lb[1], $lb[2], $lb[3], 8)
    [FastCleaner]::CleanEmbossed($bmp, $lb[0], $lb[1], $lb[2], $lb[3], 8)

    $rb = $item.RightBox
    [FastCleaner]::CleanEmbossed($bmp, $rb[0], $rb[1], $rb[2], $rb[3], 8)
    [FastCleaner]::CleanEmbossed($bmp, $rb[0], $rb[1], $rb[2], $rb[3], 8)

    # 1254x1254 pure white canvas
    $canvas = [System.Drawing.Bitmap]::new(1254, 1254)
    $g = [System.Drawing.Graphics]::FromImage($canvas)
    $g.Clear([System.Drawing.Color]::White)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $targetW = 1020
    $targetH = 820
    $scale = [Math]::Min($targetW / $bmp.Width, $targetH / $bmp.Height)
    $drawW = [int]($bmp.Width * $scale)
    $drawH = [int]($bmp.Height * $scale)
    $posX = [int]((1254 - $drawW) / 2)
    $posY = [int](130 + (820 - $drawH) / 2)

    $g.DrawImage($bmp, $posX, $posY, $drawW, $drawH)

    # Centered bold typography
    $fontTitle = [System.Drawing.Font]::new("Arial", 46, [System.Drawing.FontStyle]::Bold)
    $fontSub = [System.Drawing.Font]::new("Arial", 38, [System.Drawing.FontStyle]::Bold)
    $brush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(15, 23, 42))

    $sf = [System.Drawing.StringFormat]::new()
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    $g.DrawString($item.Title, $fontTitle, $brush, 627, 1070, $sf)
    $g.DrawString($item.Sub, $fontSub, $brush, 627, 1140, $sf)

    $g.Dispose()
    $bmp.Dispose()

    $outPath = Join-Path "assets/products" $item.Out
    $canvas.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $canvas.Dispose()
    Write-Host "Generated: $outPath"
}
