$OEM$ Folders made easy

NOTES ABOUT USAGE:
Generally, the Windows System Image Manager (Windows SIM) is used in order to generate images and autounattend.xml files.  However, there is a simple method to bypassing the Windows SIM.

By using a crafted autounattend.xml file in conjunction with the $OEM$ folders you are able to do almost everything that can be done using the Windows SIM.

REMEMBER:
The $OEM$ folder tree goes in different spots depending on the type of autounattend.xml file you are using:

IF the USE CONFIGURATION SET is TRUE:
```
<settings pass="windowsPE">
    <component name="Microsoft-Windows-Setup"....
        <UseConfigurationSet>true</UseConfigurationSet>
```
THEN the $OEM$ is on the root of the install media:
`\$OEM$`

IF the USE CONFIGURATION SET is FALSE:
```
<settings pass="windowsPE">
    <component name="Microsoft-Windows-Setup"....
        <UseConfigurationSet>false</UseConfigurationSet>
```
THEN the $OEM$ is in the sources folder on the install media:
`\sources\$OEM$`

All of the references to the Microsoft technical documents are at the end.

PURPOSE:
+ `$OEM$` folders organize supplemental files used to customize a Windows installation.
+ Subfolders created within the $OEM$ folder must coincide with the structure of a standard Windows installation.

### What are $OEM$ Folders?
`$OEM$` folders are a type of distribution share.

### What is a "distribution Share"?
A "distribution share" is an optional set of folders that contain files used to customize Windows through unattended answer files. When you add items in a distribution share to an answer file, the path to the item is included in the answer file. During installation, Windows Setup uses this path to install the additional applications and device drivers. For example, if you connect to a distribution share on a network, that network path will be referenced in the answer file.

You can use the `$OEM$` folder to copy scripts, binaries, and other files to Windows during installation. An answer file can reference files and folders stored in subfolders of `$OEM$`. 

When you create a distribution share by using Windows System Image Manager (Windows SIM), three folders are created automatically. The folders are named $OEM$ Folders, Out-of-Box Drivers, and Packages. If you create your own distribution share, it must contain at least one of the following folders to be recognized as a valid distribution share folder by Windows SIM:

+ $OEM$ Folders - See Table Below for $OEM$ Folders
+ Out-of-Box Drivers - See the Out-of-Box Drivers Folders Section Below
+ Packages - See Table Below for Packages

The `$OEM$` subfolders are organized in a specific structure.
For example, if you add files to `$OEM$\$1\Program Files\Application1`, Windows Setup will copy them to `C:\Program Files\Application1` on the Windows installation.

**NOTES:**
The `$OEM$` folder and subfolders can only be used when creating configuration sets. You can use `$OEM$` folders to include logos for branding and to add applications and other files that customize the unattended installation. `$OEM$` folders were used with previous versions of Windows, and, in some cases, are not supported in Windows Vista. 

IMPORTANT WARNING:
Do not overwrite existing files that are carried and serviced by the operating system. Using the `$OEM$` folder to update or overwrite these files can cause the operating system to behave unpredictably and cause serious issues.

USAGE NOTES: 
See the section titled IMPORTANT below for unused entries on Windows 10 and Windows Server 2019 and higher.

$OEM$ Folders Table
Folder                        Definition
$OEM$                         Contains supplemental folders and files for an automated or customized                               installation.

NOTES:
Contains all supplemental folders and files for an automated or customized installation.

$OEM$\$$                      Contains files that Windows Setup copies to the %WINDIR% folder (for example, C:\Windows) during installation.

NOTES:

$OEM$\$$\System32             Contains files that Windows Setup copies to the %WINDIR%\System32 folder during installation.

NOTES:

$OEM$\$1                      Represents the root of the drive on which you installed Windows (also called the boot partition), and contains files that Windows Setup copies to the boot partition during installation.

                              NOTES:
                              Windows Setup will COPY EVERYTHING here to the system boot drive.
                              It is no longer required to modify the install.wim to include these extra directories.

                              Theoretically any directory placed in $OEM$\$1 will be copied to C:\

                              USAGE:
                              See below under $OEM$\$1\subfolder


$OEM$\$1\subfolder            Represents subfolders of the root drive. Example: $OEM$\$1\MyDriver.

                              NOTES: Theoretically any directory placed in $OEM$\$1 will be copied to C:\

                              USAGE:
                              This is where we place the DELL directory wich might include drivers and update packs to launch in unattend.xml ($OEM$\$1\DELL), the software directory with software to load during setup from unattend.xml or for the admin/user to load as needed ($OEM$\$1\software), and the scripts directory where some scripts and logs are stored ($OEM$\$1\scripts).

                              USAGE NOTES:
                              The scripts will probabaly move to $OEM$\$$\Setup\Scripts

$OEM$\driveletter\subfolder   Represents other drive letters and subfolders. Multiple instances of this type of folder can exist under the $OEM$\driveletter folder.

Example: $OEM$\D\MyFolder.

*********************************************************************************************************
*********************************************************************************************************
****                                        IMPORTANT                                                ****
****                                                                                                 ****
****     THE FOLLOWING $OEM$ paths ARE NO LONGER SUPPORTED ON Windows 10/Server 2019 and higher!     ****
****                                                                                                 ****
*********************************************************************************************************
*   $OEM$\$$\Help                   Contains custom help files that Windows Setup copies to the         *
*                                   %WINDIR%\Help folder during installation.                           *
*                                                                                                       *
*********************************************************************************************************
*   $OEM$\$1\Pnpdrivers             Contains new or updated Plug-and-Play (PnP) drivers. The user       *
*                                   specifies the folder name in the Unattend.xml file for unattended   *
*                                   installations. For example, this folder might be named              *
*                                   \$OEM$\$1\Pnpdrvs.                                                  *
*                                                                                                       *
*********************************************************************************************************
*   $OEM$\$1\SysPrep                Contains files used for Sysprep-based installation.                 *
*                                                                                                       *
*********************************************************************************************************
*   $OEM$\$Docs                     Contains files that Windows Setup copies to                         *
*                                   %DOCUMENTS_AND_SETTINGS% during installation.                       *
*                                                                                                       *
*********************************************************************************************************
*   $OEM$\$Progs                    Contains programs that Windows Setup copies to the                  *
*                                   %PROGRAM_FILES% folder during installation.                         *
*                                                                                                       *
*********************************************************************************************************
*   $OEM$\$Progs\Internet Explorer  Contains the settings file to customize Internet Explorer.          *
*                                                                                                       *
*********************************************************************************************************
*   $OEM$\Textmode                  Contains updated mass-storage drivers and HAL files required        *
*                                   during the text-mode portion of Setup.                              *
*                                                                                                       *
*********************************************************************************************************
*********************************************************************************************************


*********************************************************************************************************
*                                       Out-of-Box Drivers Folder                                       *
*********************************************************************************************************

What are Drivers?
-----------------
Drivers are a type of software that enables hardware or devices to function.

Out-of-Box Drivers Folders Explained
------------------------------------
The Out-of-Box Drivers folder includes additional device drivers that you install during Windows
Setup by using Windows SIM. Windows Setup uses the following types of drivers:

    In-box drivers:
    Windows Setup handles in-box drivers the same way that it handles packages.

    Out-of-box drivers:
    By using Windows SIM, you can add out-of-box device drivers that are based on .inf files.
    Typically, these out-of-box drivers are processed during the auditSystem configuration pass.
    Your .inf-based out-of-box drivers must be in a distribution-share subfolder that is called
    Out-of-Box Drivers.

    In-box drivers installed using an .msi file:
    In-box drivers that require a .msi file are added the same way that applications are added.

NOTE:
By using the Microsoft-Windows-PnpCustomizationsWinPE component, you must add boot-critical device
drivers that are required for installation during the windowsPE configuration pass. You can also
add device drivers to an offline image by using Deployment Image Servicing and Management (DISM).

USAGE NOTES:
WE DO NOT USE THIS FOLDER

*********************************************************************************************************
*                                            Packages Folder                                            *
*********************************************************************************************************

The Packages folder is a location for Windows software updates. Package types include service packs,
security updates, language packs, and other packages that Microsoft issues. You must use Windows SIM to
import packages to a distribution share. After a package is imported and available in the Distribution
Share pane, you can add the package to the answer file.

USAGE NOTES:
WE DO NOT USE THIS FOLDER

EXTERNAL REFERENCES:

https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/manage-files-and-folders-in-a-distribution-share

https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/distribution-shares-and-configuration-sets-overview
