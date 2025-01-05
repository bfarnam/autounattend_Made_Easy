# inserted into Scripts to run in the system context, before user accounts are created

# Settings Pass specialize / Component Microsoft-Windows-Shell-Setup
# --> calls C:\Windows\Setup\Scripts\Specialize.ps1
# ------> calls C:\Windows\Setup\Scripts\unattend-01.ps1
# --------> calls C:\Windows\Setup\Scripts\begin-phase1-install.ps1
# ------------> calls C:\Windows\Setup\Scripts\phase1-*.ps1 scripts
# ------------> calls C:\Windows\Setup\Scripts\phase2-*.ps1 scripts

# *** Chained VIA base-install.ps1
# Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\phase2-copy-desktop-shortcuts.ps1' -Raw | Invoke-Expression;

# Copied From Brett's Universal PS1 Launcher

$strScriptName = $env:SystemRoot+'\Setup\Scripts\phase2-copy-desktop-shortcuts.ps1';
$logfile = $env:SystemRoot+'\Setup\Scripts\phase2-copy-desktop-shortcuts.log';
$message = "Copying default desktop shortcuts to $env:PUBLIC\Desktop. Do not close this window.";
$scripts = @(
    {
        $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        Write-Output $output;
        $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
    };
    {
        $source = $env:SystemDrive+'\FergusonPD\*.url';
        $target = $env:PUBLIC+'\Desktop';
        Write-Output "Copying $source to $target";
        Copy-Item -Path $source -Destination $target -Force -Verbose -ErrorAction Continue;
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