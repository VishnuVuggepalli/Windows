oh-my-posh init pwsh | Invoke-Expression
Set-PSReadLineOption -PredictionSource None

# Navigation
function sys32 { Set-Location "C:\Windows\System32" }
function desk  { Set-Location "C:\Users\vishn\Desktop" }
function home  { Set-Location "C:\Users\vishn" }

# DNS
function Set-WifiDns {
    param(
        [string[]]$DNS = @("8.8.8.8", "8.8.4.4"),
        [switch]$Append
    )
    if ($Append) {
        $current = (Get-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -AddressFamily IPv4).ServerAddresses
        $DNS = @($current) + @($DNS) | Select-Object -Unique
    }
    Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses $DNS
    Clear-DnsClientCache
    Write-Host "DNS set to: $($DNS -join ', ')" -ForegroundColor Green
}
function Get-WifiDns   { Get-DnsClientServerAddress -InterfaceAlias "Wi-Fi" | Select-Object ServerAddresses }
function Reset-WifiDns { Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ResetServerAddresses; Write-Host "DNS reset to automatic" -ForegroundColor Yellow }

# Search Domain
function Set-SearchDomain {
    param(
        [string[]]$Suffixes,
        [switch]$Append
    )
    if ($Append) {
        $current = (Get-DnsClientGlobalSetting).SuffixSearchList
        $Suffixes = @($current) + @($Suffixes) | Select-Object -Unique
    }
    Set-DnsClientGlobalSetting -SuffixSearchList $Suffixes
    Write-Host "Search domains set to: $($Suffixes -join ', ')" -ForegroundColor Green
}
function Get-SearchDomain { (Get-DnsClientGlobalSetting).SuffixSearchList }
function Reset-SearchDomain { Set-DnsClientGlobalSetting -SuffixSearchList @(); Write-Host "Search domains cleared" -ForegroundColor Yellow }

# Hosts file
function hosts { Start-Process notepad "$env:SystemRoot\System32\drivers\etc\hosts" -Verb RunAs }

function Add-HostEntry {
    param(
        [Parameter(Mandatory)][string]$IP,
        [Parameter(Mandatory)][string]$Hostname
    )
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    $entry = "$IP`t$Hostname"
    
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if ($isAdmin) {
        Add-Content -Path $hostsPath -Value $entry -Encoding ASCII
        Clear-DnsClientCache
        Write-Host "Added: $IP -> $Hostname" -ForegroundColor Green
    }
    else {
        $tempScript = Join-Path $env:TEMP "add-host-$(Get-Random).ps1"
        @"
Add-Content -Path '$hostsPath' -Value '$entry' -Encoding ASCII
Clear-DnsClientCache
Write-Host 'Added: $IP -> $Hostname' -ForegroundColor Green
Start-Sleep -Seconds 1
Remove-Item -Path '$tempScript' -Force
"@ | Set-Content -Path $tempScript -Encoding ASCII
        
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tempScript`"" -Verb RunAs
        Write-Host "UAC prompt opened - check for confirmation" -ForegroundColor Yellow
    }
}

function Remove-HostEntry {
    param(
        [Parameter(Mandatory)][string]$Hostname
    )
    $hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
    
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if ($isAdmin) {
        $content = Get-Content $hostsPath | Where-Object { $_ -notmatch "\s+$([regex]::Escape($Hostname))\s*$" }
        $content | Set-Content $hostsPath -Encoding ASCII
        Clear-DnsClientCache
        Write-Host "Removed entries for: $Hostname" -ForegroundColor Green
    }
    else {
        $tempScript = Join-Path $env:TEMP "remove-host-$(Get-Random).ps1"
        @"
`$content = Get-Content '$hostsPath' | Where-Object { `$_ -notmatch '\s+$([regex]::Escape($Hostname))\s*`$' }
`$content | Set-Content '$hostsPath' -Encoding ASCII
Clear-DnsClientCache
Write-Host 'Removed entries for: $Hostname' -ForegroundColor Green
Start-Sleep -Seconds 1
Remove-Item -Path '$tempScript' -Force
"@ | Set-Content -Path $tempScript -Encoding ASCII
        
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tempScript`"" -Verb RunAs
        Write-Host "UAC prompt opened - check for confirmation" -ForegroundColor Yellow
    }
}

# General utils
function flushdns { Clear-DnsClientCache; Write-Host "DNS flushed!" -ForegroundColor Green }
function adapters { Get-NetAdapter | Select-Object Name, ifIndex, Status, LinkSpeed }
function nmap { & "C:\Program Files (x86)\Nmap\nmap.exe" @args }

function shortcuts {
    Write-Host ""
    Write-Host "=== Navigation ===" -ForegroundColor Cyan
    Write-Host "  sys32       -> C:\Windows\System32"
    Write-Host "  desk        -> C:\Users\vishn\Desktop"
    Write-Host "  home        -> C:\Users\vishn"
    Write-Host ""
    Write-Host "=== DNS ===" -ForegroundColor Cyan
    Write-Host "  Set-WifiDns [-DNS '1.1.1.1','1.0.0.1'] [-Append]"
    Write-Host "  Get-WifiDns                              -> view current DNS"
    Write-Host "  Reset-WifiDns                            -> reset to automatic"
    Write-Host "  flushdns                                 -> flush DNS cache"
    Write-Host ""
    Write-Host "=== Search Domain ===" -ForegroundColor Cyan
    Write-Host "  Set-SearchDomain -Suffixes 'corp.local','dev.local' [-Append]"
    Write-Host "  Get-SearchDomain                         -> view search suffixes"
    Write-Host "  Reset-SearchDomain                       -> clear search suffixes"
    Write-Host ""
    Write-Host "=== Hosts File ===" -ForegroundColor Cyan
    Write-Host "  hosts                                    -> open hosts file (admin)"
    Write-Host "  Add-HostEntry -IP '127.0.0.1' -Hostname 'myapp.local'"
    Write-Host "  Remove-HostEntry -Hostname 'myapp.local'"
    Write-Host ""
    Write-Host "=== Network ===" -ForegroundColor Cyan
    Write-Host "  adapters                                 -> list all adapters"
    Write-Host "  nmap [args]                              -> run nmap scan"
    Write-Host ""
}
