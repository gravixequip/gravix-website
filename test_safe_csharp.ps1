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

        int modifiedCount = 0;
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
                    modifiedCount++;
                }
            }
        }
        Console.WriteLine(string.Format("CleanEmbossed [{0}, {1}, {2}, {3}] -> Modified {4} pixels", rx, ry, rw, rh, modifiedCount));
        patch.Dispose();
    }
}
"@

Add-Type -TypeDefinition $csharpCode -ReferencedAssemblies System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/CAT_424-SIDE-CUTTER.png").Path)

$sw = [System.Diagnostics.Stopwatch]::StartNew()

# Left piece: x=170..310, y=120..300
[FastCleaner]::CleanEmbossed($bmp, 170, 120, 140, 180, 8)
[FastCleaner]::CleanEmbossed($bmp, 170, 120, 140, 180, 8)

# Right piece: x=520..660, y=130..360
[FastCleaner]::CleanEmbossed($bmp, 520, 130, 140, 230, 8)
[FastCleaner]::CleanEmbossed($bmp, 520, 130, 140, 230, 8)

$sw.Stop()
Write-Host "Processed in $($sw.ElapsedMilliseconds) ms!"

$dest = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\cat424_clean_final.jpg"
$bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
Write-Host "Saved: $dest"
