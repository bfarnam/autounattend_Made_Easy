# autounattend_Made_Easy
A code base for reusing generic autounattend.xml files with sample scripts and <span>$</span>OEM<span>$</span> folders.

This reusabliity is feasable becuase of the autounattend.xml generator by Christoph Schneegans and is available both as a webpage (https://schneegans.de/windows/unattend-generator/) and as a repository (https://github.com/cschneegans/unattend-generator).

Christoph's novel use of Extracting Scripts from the XML itself and placing them in the `C:\Windows\Setup\Scripts` directory and firing them off during different settings passes of the Windows setup process is what makes what I have here work.

The frustrating part was that every time I wanted to modify something, I had to re-create the xml file.  So instead of re-creating the xml file every time I wanted to change something, I decided to use a "launcher" in each phase which then scans the `C:\Windows\Setup\Scripts` directory for certain script names to accomplish the various tasks.  This way I can have a generic Windows 11 autounattend.xml file which does different things depending on what scripts I include.

The trick to making this work is the usage of the <span>$</span>OEM<span>$</span> fodlers.  WindowsPE copies this over during the initial file copy (although files copied do not assume the "trusted installer" as owner - more on that later).  I simply place the scripts I want to run in the `$OEM$\$$\Setup\Scripts` directory and let the installation do the rest.

If you decide to create your own autounattend.xml file or use one of the other online generators, then you will have to place the code snipets that fire off these tasks into your xml file.

# PROCESS OUTLINED
## Step 1
Using Christoph's generator, add what ever options you want but include the following:
    
### Setup Settings: 
#### Use a distribution share / configuration set
Ensure this is checked.

**NOTE:**  
This is what copies the <span>$</span>OEM<span>$</span> directories from the root of the installation media to the new Windows installation.  If you forget to check this box, WinPE will look for the <span>$</span>OEM<span>$</span> directories under \\sources.

### Run custom scripts:
#### Scripts to run in the system context, before user accounts are created
Run
```
Get-Content -LiteralPath 'C:\Windows\Setup\scripts\begin-phase1-install.ps1' -Raw | Invoke-Expression;
```
as a "**.ps1**" file.

**NOTES:**  
1. Begin-phase1-install.ps1 scans the `C:\Windows\Setup\Scripts` directory for scripts that begin with "phase1-\*" and "phase2-\*"
2. You can control the order they run by naming your scripts:
 - phase1-0-myName.ps1
 - phase1-1-myname.ps1
 - etc.

#### Scripts to modify the default user's registry hive
Run
```
Get-Content -LiteralPath 'C:\Windows\Setup\scripts\begin-def-hive-mod.ps1' -Raw | Invoke-Expression;
```
as a "**.ps1**" file.

#### Scripts to run when the first user logs on after Windows has been installed
Run
```
Get-Content -LiteralPath 'C:\Windows\Setup\scripts\begin-phase3-install.ps1' -Raw | Invoke-Expression;
```
as a "**.ps1**" file.

**NOTES:** 
1. Begin-phase3-install.ps1 scans the `C:\Windows\Setup\Scripts` directory for scripts that begin with "phase3-\*" and "phase4-\*"
2. You can control the order they run by naming your scripts:
 - phase3-0-myName.ps1
 - phase3-1-myname.ps1
 - etc.

### Save your autoattend.xml file
Save you `autoattend.xml` file to the path of your choice.

## Step 2
### Modify <span>$</span>OEM<span>$</span> to include the items you wish to copy over to the system during the setup process
+ Add, Change, Delete the appropriate "phase" scripts which are in the `$OEM$\$$\Setup\Scripts` folder.
+ Add drivers that you wish to load into `$OEM$\$1\Drivers` and create the ".install" files.  Refer to the samples.
+ Add software that you wish to auto install to eithier `$OEM$\$1\Software` or `$OEM$\$1\Software\autoinstall` and create the ".install" files.  Refer to the samples.
+ Add software that you wish to have the option of installing later to `$OEM$\$1\Software`.
+ Add any "all users" custom shortcuts to `$OEM$\$1\users\public\desktop` or the appropriate path for you OS.
+ Add any other directories that you wish to pre-populate.

## Step 3
### Make your install media
#### Booting from a USB drive
+ Use a utility, such as Rufus to burn the OS to a USB drive
+ Copy the saved `autoattend.xml` and the `$OEM$` folders to the root of you install media
#### Booting from an ISO file
+ Modify the ISO file of your OS using a utility such as AnyBurn and copy the `autoattend.xml` and the `$OEM$` folders to the root of the ISO
+ Then burn the ISO to a DVD or use a utility such as VenToy to load the ISO on boot

## Step 4
Test and enjoy!








