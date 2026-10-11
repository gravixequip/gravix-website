Add-Type -AssemblyName System.Drawing
Get-ChildItem "knd_sc_images/*.png" | ForEach-Object {
    $b = [System.Drawing.Bitmap]::FromFile($_.FullName)
    Write-Host "$($_.Name): Width=$($b.Width), Height=$($b.Height)"
    $b.Dispose()
}
