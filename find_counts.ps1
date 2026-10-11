$lines = Get-Content "index.html"
for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '\b(24|33)\b') {
        Write-Host "Line $($i+1): $($lines[$i].Trim())"
    }
}
