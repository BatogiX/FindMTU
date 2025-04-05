$hostName = "youtube.com"
$minMTU = 1280
$maxMTU = 1440


function Test-MTU {
    param (
        [int]$mtu
    )
    $payloadSize = $mtu - 28  # 20 (IPv4) + 8 (UDP)
    $pingCmd = "ping -4 -f -n 1 -l $payloadSize $hostName"
    $result = cmd /c $pingCmd
    return ($result -match "Reply from")
}

for ($mtu = $maxMTU; $mtu -ge $minMTU; $mtu--) {
    Write-Host "Testing MTU $mtu..."
    if (Test-MTU -mtu $mtu) {
        Write-Host "✅ MTU found: $mtu"
        break
    }
}
