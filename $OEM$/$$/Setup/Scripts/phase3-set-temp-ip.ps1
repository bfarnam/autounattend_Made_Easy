# Scripts to run when the first user logs on after Windows has been installed

# Settings Pass oobeSystem / Component Microsoft-Windows-Deployment
# --> calls C:\Windows\Setup\Scripts\FirstLogon.ps1
# ------> calls C:\Windows\Setup\Scripts\unattend-02.ps1
# --------> calls C:\Windows\Setup\Scripts\begin-phase3-install.ps1
# ------------> calls C:\Windows\Setup\Scripts\phase3-*.ps1 scripts
# ------------> calls C:\Windows\Setup\Scripts\phase4-*.ps1 scripts

# Chained VIA begin-phase1-install.ps1

# Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\phase3-set-temp-ip.ps1' -Raw | Invoke-Expression;

$strScriptName = $env:SystemRoot+'\Setup\Scripts\phase3-set-temp-ip.ps1';
$logfile = $env:SystemRoot+'\Setup\Scripts\phase3-set-temp-ip.log';
$strVer = "v2.3";
$strVerDate = "2025 January 1";
$strAuthor = "Brett A. Farnam (brett_farnam@yahoo.com)";
[bool]$bInternet = $false;
[bool]$bContinue = $false;

& {
    $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
    Write-Output $output;
    $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
    Write-Output $output;
} *>&1 >> $logfile;

# Set the IP address, subnet mask, and default gateway
$ips2try = @("192.168.1.1","192.168.1.10","192.168.1.11");
$subnetMask = "255.255.255.0";
$prefixCIDR = 24;
$defaultGateway = "192.168.1.254";
$dnsServers = "192.168.1.254,8.8.8.8";

while (!$bInternet) {
    while (!$bContinue) {
        $vYesNo = Read-Host -Prompt "Is the Ethernet cable plugged in (Y/N)";
        switch ($vYesNo) {
            "Y" { $bContinue = $true; }
            "y" { $bContinue = $true; }
        };
    };
    if (!$bContinue) { $bInternet = $false; };

    # Get the network adapter you want to modify
    $adapterList = Get-NetAdapter | Where-Object { $_.Name -like "*Ethernet*" -and $_.Status -eq "Up" -and $_.LinkSpeed -notlike "0 bps" };
    if ($adapterList.count -gt 0) { 
        $adpater = $adapterList[0];
    } else {
        $adapter = $adapterList;
    };

    # foreach ($ipAddress in $ips2try) {
    $ipIndex = -1;
    while (!$bInternet) {
        $ipIndex ++;
        # Configure the IP address
        $ipAddress = $ips2try[$ipIndex];
        Write-Host "Trying the IP address of $ipAddress";

        & {
            if ($ipIndex -eq 1) {
                New-NetIPAddress -IPAddress $ipAddress -InterfaceAlias $adapter.Name -PrefixLength $prefixCIDR -DefaultGateway $defaultGateway;
            } else {
                Set-NetIPAddress -IPAddress $ipAddress -InterfaceAlias $adapter.Name -PrefixLength $prefixCIDR -DefaultGateway $defaultGateway;
            };
        } *>&1 >> $logfile;

        & {
            Set-DnsClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses $dnsServers;
        } *>&1 >> $logfile;
        Start-Sleep -Seconds 10;
    
        $bContinue = $false;
        <#
        while (!$bContinue) {
            $vYesNo = Read-Host -Prompt "Is the Ethernet Active (Y/N)";
            switch ($vYesNo) {
                "Y" { $bContinue = $true; }
                "y" { $bContinue = $true; }
            };
        };
        #>
        if (!$bContinue) { $bInternet = $false; };
        Start-Sleep -Seconds 10;
        Write-Host "Verifying the machine has an internet connection...";
        $bInternet = Test-Connection www.google.com -Quiet;
    };
}

& {
    $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" END "+$strScriptName;
    Write-Output $output;
} *>&1 >> $logfile;

if (!$bContinue) { exit; };
if (!$bInternet) { exit; };

# ENCODING IS UTF-8
# ENSURE ENCODING IS NOT CHANGED OR "&" will be replaced with "&amp;", etc.
