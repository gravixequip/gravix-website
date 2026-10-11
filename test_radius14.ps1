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

                List<int> rList = new List<int>(256);
                List<int> gList = new List<int>(256);
                List<int> bList = new List<int>(256);

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

                if (rList.Count > 10) {
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

# Test on EX 200 with radius 14
$bmp200 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
[FastCleaner]::CleanEmbossed($bmp200, 365, 415, 80, 115, 14)
[FastCleaner]::CleanEmbossed($bmp200, 365, 415, 80, 115, 14)
[FastCleaner]::CleanEmbossed($bmp200, 600, 415, 80, 115, 14)
[FastCleaner]::CleanEmbossed($bmp200, 600, 415, 80, 115, 14)

$dest200 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\radius14_ex200.jpg"
$bmp200.Save($dest200, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp200.Dispose()

# Test on JCB DF right piece with exact box (600, 130, 90, 160)
$bmpJcb = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
[FastCleaner]::CleanEmbossed($bmpJcb, 255, 80, 120, 210, 12)
[FastCleaner]::CleanEmbossed($bmpJcb, 255, 80, 120, 210, 12)
[FastCleaner]::CleanEmbossed($bmpJcb, 600, 130, 90, 160, 12)
[FastCleaner]::CleanEmbossed($bmpJcb, 600, 130, 90, 160, 12)

$destJcb = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\radius14_jcbdf.jpg"
$bmpJcb.Save($destJcb, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmpJcb.Dispose()

Write-Host "Saved radius14 tests!"
