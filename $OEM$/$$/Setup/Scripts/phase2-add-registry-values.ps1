# inserted into Scripts to run in the system context, before user accounts are created

# Settings Pass specialize / Component Microsoft-Windows-Deployment
# --> calls C:\Windows\Setup\Scripts\Specialize.ps1
# ------> calls C:\Windows\Setup\Scripts\unattend-01.ps1
# --------> calls C:\Windows\Setup\Scripts\begin-phase1-install.ps1
# ------------> calls C:\Windows\Setup\Scripts\phase1-*.ps1 scripts
# ------------> calls C:\Windows\Setup\Scripts\phase2-*.ps1 scripts

# *** Chained VIA base-install.ps1
# Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\phase2-add-registry-values.ps1' -Raw | Invoke-Expression;

# Copied From Brett's Universal PS1 Launcher

$strScriptName = $env:SystemRoot+'\Setup\Scripts\phase2-add-registry-values.ps1';
$logfile = $env:SystemRoot+'\Setup\Scripts\phase2-add-registry-values.log';
$message = 'Adding Registry Data. Do not close this window.';
$scripts = @(
    {
        $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        Write-Output $output;
        $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
    };
    {
        reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOwner" /t REG_SZ /d "Ferguson Police Department" /f;
    };
    {
        reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOrganization" /t REG_SZ /d "City of Ferguson" /f;
    };
    {
        reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "ScreenSaverGracePeriod" /t REG_DWORD /d 300 /f;
    };
    {
        reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /f;
    };
    {
        $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" END "+$strScriptName;
        Write-Output $output;
    };
);

<# ************************************************************************ #>
<# **************** DO NOT MODIFY ANYTHING BELOW THIS LINE **************** #>
<# ************************************************************************ #>
$strVer = "v2.3";
$strVerDate = "2025 January 1";
$strAuthor = "Brett A. Farnam (brett_farnam@yahoo.com)";

& {
    [float] $complete = 0;
    [float] $increment = 100 / $scripts.Count;
    foreach( $script in $scripts ) {
        Write-Progress -Activity $message -PercentComplete $complete;
        & $script;
        $complete += $increment;
    }
} *>&1 >> $logfile;

# ENCODING IS UTF-8
# ENSURE ENCODING IS NOT CHANGED OR "&" will be replaced with "&amp;", etc.