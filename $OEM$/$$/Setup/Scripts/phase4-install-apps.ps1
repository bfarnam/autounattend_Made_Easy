# Scripts to run when the first user logs on after Windows has been installed

# Settings Pass oobeSystem / Component Microsoft-Windows-Deployment
# --> calls C:\Windows\Setup\Scripts\FirstLogon.ps1
# ------> calls C:\Windows\Setup\Scripts\unattend-02.ps1
# --------> calls C:\Windows\Setup\Scripts\begin-phase3-install.ps1
# ------------> calls C:\Windows\Setup\Scripts\phase3-*.ps1 scripts
# ------------> calls C:\Windows\Setup\Scripts\phase4-*.ps1 scripts

# *** Chained VIA begin-phase3-install.ps1
# Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\phase4-install-apps.ps1' -Raw | Invoke-Expression;

# Adapted From Brett's Universal PS1 Launcher

$strScriptName = $env:SystemRoot+'\Setup\Scripts\phase4-install-apps.ps1';
$logfile = $env:SystemRoot+'\Setup\Scripts\phase4-install-apps.log';
$message = "Installing Applications. Do not close this window.";
$scripts = @(
    {
        $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        Write-Output $output;
        $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
    };
    {
        $sourcePath = $env:SystemDrive+'\software\autoinstall\*';
        $filesToInstall = Get-ChildItem -Path $sourcePath -File -Include *.install;
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