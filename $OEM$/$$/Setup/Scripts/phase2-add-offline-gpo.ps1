# inserted into Scripts to run in the system context, before user accounts are created

# Settings Pass specialize / Component Microsoft-Windows-Shell-Setup
# --> calls C:\Windows\Setup\Scripts\Specialize.ps1
# ------> calls C:\Windows\Setup\Scripts\unattend-01.ps1
# --------> calls C:\Windows\Setup\Scripts\begin-phase1-install.ps1
# ------------> calls C:\Windows\Setup\Scripts\phase1-*.ps1 scripts
# ------------> calls C:\Windows\Setup\Scripts\phase2-*.ps1 scripts

# *** Chained VIA base-install.ps1
# Get-Content -LiteralPath 'd:\custom\scripts\phase2-add-offline-gpo.ps1' -Raw | Invoke-Expression;

# Copied From Brett's Universal PS1 Launcher

$strScriptName = $env:SystemRoot+'\Setup\Scripts\phase2-add-offline-gpo.ps1';
$logfile = $env:SystemRoot+'\Setup\Scripts\phase2-add-offline-gpo.log';
$message = 'Adding Offline Group Policy Object (GPO) Entries. Do not close this window.';
$scripts = @(
    {
        $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        Write-Output $output;
        $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
    };
    {
        # D:\custom\lgpo.exe /m D:\custom\Machine\registry.pol /v
    };
    {
        # D:\custom\lgpo.exe /u D:\custom\User\registry.pol /v
    };
    {
        D:\custom\lgpo.exe /g D:\custom\LGPO /v
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