# autounattend_Made_Easy
A code base for reusing generic autounattend.xml files with sample scripts and $OEM$ folders.

You can either create your own autounattend.xml file or use one of the online generators.  My preferred online generator is from Christoph Schneegans and is available both as a webpage (https://schneegans.de/windows/unattend-generator/) and as a repository (https://github.com/cschneegans/unattend-generator).  If you don't use Christophs generator, then you will have to place the code snipets that fire off these tasks into your xml file.

Christoph's novel use of Extracting Scripts from the XML itself and placing them in the C:\Windows\Setup\Scripts directory is what make what I have here work.

Instead of re-creating the xml file every time I wanted to change something, I decided to use a "launcher" in each phase which then scans the C:\Windows\Setup\Scripts directory for certain script names to accomplish the various tasks.  This way I can have a generic Windows 11 xml file which does different things depending on what scripts I include.

The "trick" to making this work is the usage of the $OEM$ directories.  WindowsPE copies this over during the initial file copy (although files copied do not assume the "trusted installer" as owner - more on that later).  I simply place the scripts I want to run in the $OEM$\$$\Setup\Scripts path and let the installation do the rest.


