$hosts = @(
    "youtube.com",
    "google.com",
    "cloudflare.com",
    "facebook.com",
    "twitter.com",
    "amazon.com",
    "bing.com",
    "apple.com",
    "speedtest.net",
    "netflix.com"
)
$minMTU = 1280
$maxMTU = 1440

function Get-RandomHost {
    return Get-Random -InputObject $hosts
}

function Test-MTU {
    param (
        [int]$mtu
    )
    $hostName = Get-RandomHost
    $payloadSize = $mtu - 28  # 20 (IPv4) + 8 (UDP)
    $pingCmd = "ping -4 -f -n 1 -l $payloadSize $hostName"
    $result = cmd /c $pingCmd

    $replyFrom = $result -match "Reply from"
    Write-Host "Testing MTU $mtu... $hostName → $replyFrom"
    $needsFragment = $result -match "Packet needs to be fragmented but DF set."
    return (-not $needsFragment)
}

for ($mtu = $maxMTU; $mtu -ge $minMTU; $mtu--) {
    if (Test-MTU -mtu $mtu) {
        Write-Host "✅ MTU found: $mtu"
        break
    }
}
