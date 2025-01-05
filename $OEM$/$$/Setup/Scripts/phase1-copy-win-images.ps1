# inserted into Scripts to run in the system context, before user accounts are created

# Settings Pass specialize / Component Microsoft-Windows-Deployment
# --> calls C:\Windows\Setup\Scripts\Specialize.ps1
# ------> calls C:\Windows\Setup\Scripts\unattend-01.ps1
# --------> calls C:\Windows\Setup\Scripts\begin-phase1-install.ps1
# ------------> calls C:\Windows\Setup\Scripts\phase1-*.ps1 scripts
# ------------> calls C:\Windows\Setup\Scripts\phase2-*.ps1 scripts

# *** Chained VIA base-install.ps1
# Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\phase1-copy-win-images.ps1' -Raw | Invoke-Expression;

# Copied From Brett's Universal PS1 Launcher

$strScriptName = $env:SystemRoot+'\Setup\Scripts\phase1-copy-win-images.ps1';
$logfile = $env:SystemRoot+'\Setup\Scripts\phase1-copy-win-images.log';
$message = 'Copying default Windows images. Do not close this window.';
$scripts = @(
    {
        $output = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        Write-Output $output;
        $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
    };
    {
        $sourcePath = "D:\custom\Web";
        $destinationPath = $env:SystemRoot+'\Web';

        $filesToCopy = Get-ChildItem -Path $sourcePath -Recurse -File;

        # Copy the files to the destination folder, overwriting any existing files
        $filesToCopy | ForEach-Object {
            $destination = Join-Path $destinationPath ($_.FullName.Substring($sourcePath.Length + 1));
            
            if (!(Test-Path (Split-Path $destination))) {
                # Destination Directory Does Not Exist, so lets create it and apply the ACL from \Windows
                $acl = Get-Acl -Path "$env:SystemRoot" -ErrorAction Continue;
                New-Item -ItemType Directory -Path (Split-Path $destination) -Force -Verbose;
                Set-Acl -Path (Split-Path $destination) -AclObject $acl -Verbose -ErrorAction Continue;;
            };
            
            if (Test-Path $destination) {
                $acl = Get-Acl -Path $destination -ErrorAction Continue;
                start-process -FilePath "$env:SystemRoot\System32\takeown.exe" -ArgumentList "/F $destination" -PassThru -Wait;
                $user = $Env:UserName+':F';
                start-process -FilePath "$env:SystemRoot\System32\icacls.exe"  -ArgumentList "$destination /grant $user" -PassThru -Wait;
            } else {
                # Destination File Does Not Exist, so lets save the ACL from \Windows
                $acl = Get-Acl -Path "$env:SystemRoot" -ErrorAction Continue;
            };
            Copy-Item -Path $_.FullName -Destination $destination -Force -Verbose;
            Set-Acl -Path $destination -AclObject $acl -Verbose -ErrorAction Continue;;
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