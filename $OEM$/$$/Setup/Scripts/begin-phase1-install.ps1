# inserted into Scripts to run in the system context, before user accounts are created

# Settings Pass specialize / Component Microsoft-Windows-Shell-Setup
# --> calls C:\Windows\Setup\Scripts\Specialize.ps1
# ------> calls C:\Windows\Setup\Scripts\unattend-01.ps1
# --------> calls C:\Windows\Setup\Scripts\begin-phase1-install.ps1
# ------------> calls C:\Windows\Setup\Scripts\phase1-*.ps1 scripts
# ------------> calls C:\Windows\Setup\Scripts\phase2-*.ps1 scripts

# Get-Content -LiteralPath 'C:\Windows\Setup\scripts\begin-phase1-install.ps1' -Raw | Invoke-Expression;

# Adapted From Brett's Universal PS1 Launcher

$strScriptName = $env:SystemRoot+'\Setup\Scripts\begin-phase1-install.ps1';
$logfile = $env:SystemRoot+'\Setup\Scripts\begin-phase1-install.log';
$message = 'Running Phase 1 and Phase 2 scripts to customize your Windows installation. Do not close this window.';
$scripts = @(
    {
        $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        Write-Output $output;
        $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
    };
    {
        # Set to Highperformance for installation
        powercfg /s 8C5E7FDA-E8BF-4A96-9A85-A6E23A8C635C
    };
    {
        $sourcePath = $env:SystemRoot+'\Setup\Scripts\*';
        $filesToInstall = Get-ChildItem -Path $sourcePath -File -Include phase1-*.ps1;
        $i = 0;
        $filesToInstall | ForEach-Object {
            $i ++; 
            $output = "Using Install File "+$i+" of "+$filesToInstall.count+" : "+$_.Fullname;
            Write-Output $output;
            Get-Content -LiteralPath $_.Fullname -Raw | Invoke-Expression;
            Start-Sleep -Seconds 30;
        };
    };
    {
        $sourcePath = $env:SystemRoot+'\Setup\Scripts\*';
        $filesToInstall = Get-ChildItem -Path $sourcePath -File -Include phase2-*.ps1;
        $i = 0;
        $filesToInstall | ForEach-Object {
            $i ++; 
            $output = "Using Install File "+$i+" of "+$filesToInstall.count+" : "+$_.Fullname;
            Write-Output $output;
            Get-Content -LiteralPath $_.Fullname -Raw | Invoke-Expression;
            Start-Sleep -Seconds 30;
        };
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