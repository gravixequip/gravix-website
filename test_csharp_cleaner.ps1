Add-Type -TypeDefinition @"
using System;
using System.Drawing;
using System.Drawing.Imaging;

public class SeamlessInpainter {
    public static void InpaintRegionMedian(Bitmap bmp, int rx1, int ry1, int rx2, int ry2, int radius, double feather) {
        int w = bmp.Width;
        int h = bmp.Height;
        rx1 = Math.Max(0, rx1);
        ry1 = Math.Max(0, ry1);
        rx2 = Math.Min(w - 1, rx2);
        ry2 = Math.Min(h - 1, ry2);

        Bitmap clone = (Bitmap)bmp.Clone();

        int rw = rx2 - rx1 + 1;
        int rh = ry2 - ry1 + 1;

        for (int y = ry1; y <= ry2; y++) {
            for (int x = rx1; x <= rx2; x++) {
                Color orig = clone.GetPixel(x, y);
                if (orig.A < 50) continue;

                // Compute feather factor (0 at borders, 1 at interior)
                double u = (double)(x - rx1) / rw;
                double v = (double)(y - ry1) / rh;
                double edgeDist = Math.Min(Math.Min(u, 1.0 - u), Math.Min(v, 1.0 - v));
                double blend = Math.Min(1.0, edgeDist / feather);
                blend = 0.5 * (1.0 - Math.Cos(blend * Math.PI)); // smooth S-curve

                // Median filter in neighborhood
                int[] rVals = new int[(2 * radius + 1) * (2 * radius + 1)];
                int[] gVals = new int[(2 * radius + 1) * (2 * radius + 1)];
                int[] bVals = new int[(2 * radius + 1) * (2 * radius + 1)];
                int count = 0;

                for (int dy = -radius; dy <= radius; dy++) {
                    int ny = y + dy;
                    if (ny < 0 || ny >= h) continue;
                    for (int dx = -radius; dx <= radius; dx++) {
                        int nx = x + dx;
                        if (nx < 0 || nx >= w) continue;
                        Color np = clone.GetPixel(nx, ny);
                        if (np.A > 100) {
                            rVals[count] = np.R;
                            gVals[count] = np.G;
                            bVals[count] = np.B;
                            count++;
                        }
                    }
                }

                if (count > 0) {
                    Array.Sort(rVals, 0, count);
                    Array.Sort(gVals, 0, count);
                    Array.Sort(bVals, 0, count);
                    int medR = rVals[count / 2];
                    int medG = gVals[count / 2];
                    int medB = bVals[count / 2];

                    int finalR = (int)(orig.R * (1.0 - blend) + medR * blend);
                    int finalG = (int)(orig.G * (1.0 - blend) + medG * blend);
                    int finalB = (int)(orig.B * (1.0 - blend) + medB * blend);

                    bmp.SetPixel(x, y, Color.FromArgb(orig.A, finalR, finalG, finalB));
                }
            }
        }
        clone.Dispose();
    }
}
"@ -ReferencedAssemblies System.Drawing

# Test on EX 200
$b1 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/EX_200-SIDE-CUTTER.png").Path)
# Left piece KND: x: 360..415, y: 430..515, radius 9, feather 0.15
[SeamlessInpainter]::InpaintRegionMedian($b1, 355, 425, 420, 520, 9, 0.18)
# Right piece KND: x: 595..645, y: 425..525, radius 9, feather 0.15
[SeamlessInpainter]::InpaintRegionMedian($b1, 590, 420, 650, 530, 9, 0.18)

$out1 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_ex200_median.jpg"
$b1.Save($out1, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$b1.Dispose()
Write-Host "Saved EX 200 median test: $out1"

# Test on JCB DF
$b2 = [System.Drawing.Bitmap]::FromFile((Resolve-Path "knd_sc_images/JCB-DF-SIDE-CUTTER.png").Path)
# Left piece neck KND: x: 325..385, y: 95..210, radius 9, feather 0.18
[SeamlessInpainter]::InpaintRegionMedian($b2, 320, 90, 390, 215, 9, 0.18)
# Right piece neck KND: x: 540..605, y: 100..210, radius 9, feather 0.18
[SeamlessInpainter]::InpaintRegionMedian($b2, 535, 95, 610, 215, 9, 0.18)

$out2 = "C:\Users\shahal\.gemini\antigravity-ide\brain\f78f5433-103e-461c-99a4-b6ad2fdce904\.tempmediaStorage\test_jcbdf_median.jpg"
$b2.Save($out2, [System.Drawing.Imaging.ImageFormat]::Jpeg)
$b2.Dispose()
Write-Host "Saved JCB DF median test: $out2"
