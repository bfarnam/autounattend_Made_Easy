# <span>$</span>OEM<span>$</span> Folders made easy

Generally, the Windows System Image Manager (Windows SIM) is used in order to generate images and autounattend.xml files.  However, there is a simple method to bypassing the Windows SIM.

By using a crafted autounattend.xml file in conjunction with the <span>$</span>OEM<span>$</span> folders you are able to do almost everything that can be done using the Windows SIM.

All of the references to the Microsoft technical documents on distribution sets and folders within are at the end of this document under [References](https://github.com/bfarnam/autounattend_Made_Easy/edit/main/%24OEM%24-Usage-Explained.md#references).

The <span>$</span>OEM<span>$</span> folder tree goes in different spots on the installation media depending on the UseConfigurationSet setting which is evaluated in the WindowsPE pass for the Micorosoft Windows Setup Component:

```
<settings pass="windowsPE">
    <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
```
**IF** `<UseConfigurationSet>true</UseConfigurationSet>` **THEN** the <span>$</span>OEM<span>$</span> folder tree is in the root of the install media at `\$OEM$`

**IF** `<UseConfigurationSet>false</UseConfigurationSet>` **THEN** the <span>$</span>OEM<span>$</span> folder tree is in the sources folder on the install media at `\sources\$OEM$`

Your WindowsPE Setting Pass *may* look like this:
```
<settings pass="windowsPE">
    <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
    <ImageInstall>
        **ImageInstall setting go here**
    </ImageInstall>
    <UserData>
        **UserData setting go here**
    </UserData>
    <UseConfigurationSet>true</UseConfigurationSet>
    <RunSynchronous>
        **The rest of your xml**
```

### Purpose of the <span>$</span>OEM<span>$</span> Folders
+ <span>$</span>OEM<span>$</span> folders organize supplemental files used to customize a Windows installation.
+ Subfolders created within the <span>$</span>OEM<span>$</span> folder must coincide with the structure of a standard Windows installation.

### What are <span>$</span>OEM<span>$</span>Folders?
<span>$</span>OEM<span>$</span> folders are a type of distribution share.

### What is a distribution share?
A distribution share is an optional set of folders that contain files used to customize Windows through unattended answer files. When you add items in a distribution share to an answer file, the path to the item is included in the answer file. During installation, Windows Setup uses this path to install the additional applications and device drivers. For example, if you connect to a distribution share on a network, that network path will be referenced in the answer file.

You can use the <span>$</span>OEM<span>$</span> folders to copy scripts, binaries, and other files to Windows during installation. An answer file can reference files and folders stored in subfolders of <span>$</span>OEM<span>$</span>. 

When you create a distribution share by using Windows System Image Manager (Windows SIM), three folders are created automatically. The folders are named <span>$</span>OEM<span>$</span> Folders, Out-of-Box Drivers, and Packages. If you create your own distribution share, it must contain at least one of the following folders to be recognized as a valid distribution share folder by Windows SIM:

+ <span>$</span>OEM<span>$</span> Folders - See [Table Below](#oem-table) for the <span>$</span>OEM<span>$</span> Folder Structure
+ Out-of-Box Drivers - See the [Out-of-Box Drivers Folders](#oob-drivers-folders) Section Below
+ Packages - See [Packages Folders](#packages-folder) Section Below

The <span>$</span>OEM<span>$</span> subfolders are organized in a specific structure and WindoesPE setup copies the folder structure verbatim.

For example, if you add files to `$OEM$\$1\Program Files\Application1`, Windows Setup will copy them to `C:\Program Files\Application1` on the Windows installation.

**NOTES:**

Microsoft states that the <span>$</span>OEM<span>$</span> folder and subfolders can _only_ be used when creating configuration sets. You can use <span>$</span>OEM<span>$</span> folders to include logos for branding and to add applications and other files that customize the unattended installation. <span>$</span>OEM<span>$</span> folders that were used with previous versions of Windows, in some cases, are not supported in Windows Vista and Windows 11.

We however will use the <span>$</span>OEM<span>$</span> folders to copy our scripts over to the C:\Windows\Setup\Scripts directory and create custom C:\drivers, C:\Software directories, C:\users\public\desktop (for custom shortcuts and links), and other folders as needed.

See the section titled [IMPORTANT](#not-supported) below for unused entries on Windows 10 and Windows Server 2019 and higher.

### WARNING
> Do not overwrite existing files that are carried and serviced by the operating system. Using the <span>$</span>OEM<span>$</span> folder to update or overwrite these files can cause the operating system to behave unpredictably and cause serious issues.

## <span>$</span>OEM<span>$</span> Folders Table 
<a name="oem-table"></a>
| Folder | Definition |
| ------------- | ------------- |
| `$OEM$` | Contains supplemental folders and files for an automated or customized installation.<br/><br/>NOTES:<br/>Contains all supplemental folders and files for an automated or customized installation.|
| `$OEM$\$$` | Contains files that Windows Setup copies to the %WINDIR% folder (for example, `C:\Windows`) during installation. |
| `$OEM$\$$\System32` | Contains files that Windows Setup copies to the %WINDIR%\System32 folder (for example, `C:\Windows\System32`) during installation. |
| `$OEM$\$1` | Represents the root of the drive on which you installed Windows (also called the boot partition), and contains files that Windows Setup copies to the boot partition during installation.<br /><br />NOTES:<br />Windows Setup will COPY EVERYTHING here to the system boot drive. It is no longer required to modify the install.wim to include these extra directories. |
| `$OEM$\$1\subfolder` | Represents subfolders of the root drive.<br /><br />Example: `$OEM$\$1\MyDriver`<br /><br />NOTES:<br /><br />Theoretically any directory placed in `$OEM$\$1` will be copied to `C:\`.<br /><br />EXAMPLE:<br />`$OEM$\$1\MyFolder` would be copied to `C:\MyFolder`<br /><br />USAGE:<br />This is where we place the drivers directory wich might include drivers and update packs to launch in unattend.xml (`$OEM$\$1\drivers`), the software directory with software to load during setup from unattend.xml or for the admin/user to load as needed (`$OEM$\$1\software`), and the scripts directory where some scripts and logs are stored (`$OEM$\$1\Ccripts` or `$OEM$\$$\Setups\Scripts`). |
| `$OEM$\driveletter\subfolder` | Represents other drive letters and subfolders. Multiple instances of this type of folder can exist under the `$OEM$\driveletter` folder.<br /><br />Example:<br />`$OEM$\D\MyFolder` would be copied to `D:\MyFolder` |

## IMPORTANT
<a name="not-supported"></a>
The following <span>$</span>OEM<span>$</span> paths are either not supported or unused in Windows 10/Server 2019 and higher.
| Folder | Definition |
| ------------- | ------------- |
| `$OEM$\$$\Help` | Contains custom help files that Windows Setup copies to the %WINDIR%\Help folder during installation. |
| `$OEM$\$1\Pnpdrivers` | Contains new or updated Plug-and-Play (PnP) drivers. The user specifies the folder name in the Unattend.xml file for unattended installations. For example, this folder might be named `$OEM$\$1\Pnpdrvs`. |
| `$OEM$\$1\SysPrep` | Contains files used for Sysprep-based installation. |
| `$OEM$\$Docs` | Contains files that Windows Setup copies to %DOCUMENTS_AND_SETTINGS% during installation. |
| `$OEM$\$Progs\Internet Explorer` | Contains the settings file to customize Internet Explorer. |
| `$OEM$\Textmode` | Contains updated mass-storage drivers and HAL files required during the text-mode portion of Setup. |


### Out-of-Box Drivers Folder
<a name="oob-drivers-folders"></a>
#### What are Drivers?
Drivers are a type of software that enables hardware or devices to function.

#### Out-of-Box Drivers Folders Explained
The Out-of-Box Drivers folder includes additional device drivers that you install during Windows
Setup by using Windows SIM. Windows Setup uses the following types of drivers:

+ In-box drivers:  
  Windows Setup handles in-box drivers the same way that it handles packages.

+ Out-of-box drivers:  
  By using Windows SIM, you can add out-of-box device drivers that are based on .inf files. Typically, these out-of-box drivers are processed during the auditSystem configuration pass. Your .inf-based out-of-box drivers must be in a distribution-share subfolder that is called Out-of-Box Drivers.

+ In-box drivers installed using an .msi file:  
  In-box drivers that require a .msi file are added the same way that applications are added.

**Please Note:**

By using the Microsoft-Windows-PnpCustomizationsWinPE component, you must add boot-critical device drivers that are required for installation during the windowsPE configuration pass. You can also add device drivers to an offline image by using Deployment Image Servicing and Management (DISM).

### Packages Folder
<a name="packages-folder"></a>
The Packages folder is a location for Windows software updates. Package types include service packs, security updates, language packs, and other packages that Microsoft issues. You must use Windows SIM to import packages to a distribution share. After a package is imported and available in the Distribution Share pane, you can add the package to the answer file.

## REFERENCES
https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/distribution-shares-and-configuration-sets-overview
https://learn.microsoft.com/en-us/windows-hardware/customize/desktop/wsim/manage-files-and-folders-in-a-distribution-share
