# Kick PC to Fix - A set of cross-platform bootable media creation tools.
  
## Notices  
  
LEGAL DISCLAIMER: Read the really serious legal disclaimer [here](./REALLY\_SERIOUS\_DISCLAIMER.md) before you do anything else.
  
LICENSING: The apache license doesn't cover **anything** in the 'bin', 'cds/\*\/files', 'cabs' or 'os' directories. These have their own licenses. At the command line, type 'bcd -help' or 'bfd -help' to find out more about the external files used and their licensing conditions.  
  
DEVELOPER NOTICE: Please read the developer documentation [here](./DEVELOPER\_README.md) before doing **anything**.
  
IMPORTANT: The Apache License used is in the file "[LICENSE.md](./LICENSE.md)" instead of "LICENSE" and the Copyright Notice is in the file "[NOTICE.md](./NOTICE.md)" instead of "NOTICE". This is to make reading the files on GitHub easier.  
  
## Download and Installation  
  
Download and install the current version of the program [available here](https://github.com/WolfNet-Computing/Kick-PC-To-Fix/releases) to the suggested location and click either the shortcut on the desktop or in the start menu.  
  
When installing, the following applies to the options chosen:  
  
 - Core: Always selected and contains files required to run and common to all plugins.  
 - Boot CD/DVD Builder: Contains files for building bootable CDs/DVDs or images and also 2 example disc templates. These are stored in the 'cds' subdirectory of the installation directory.
 - Boot USB Builder: Contains files for building bootable USB drives or images and 1 example template. This is stored in the 'usbs' subdirectory of the installation directory.
 - Boot Floppy Builder: Contains files for building bootable Floppy Discs.  
 - Corporate ModBoot: The same as ModBoot except this is aimed more towards businesses, companies and organisations.  
 - NetBoot: A bigger boot disc based on the Boot USB Builder that uses ISOLINUX and iPXE to boot from either the local filesystem or a remote (TFTP or HTTP/HTTPS) server.  
  
## Usage  
  
The program is 4 powershell scripts. There's the main script that runs the powershell prompt, the BFD script for building floppy disks, the BCD script for building CDs or DVDs and the BUSBD script for building USB flash drives.  

The main script **must be run with administrator privileges**. You can do this by right-clicking the shortcut and clicking 'Run as Administrator'. This is for the BUSBD script, as it requires elevated privileges.  
**Alternative: Right-click the shortcut, then click 'Properties', click 'Advanced', click 'Run as Administrator', click 'OK' and then 'OK'. Now when you double-click the shortcut it automatically runs with elevated privileges**  
  
The main script is run whenever the shortcut is clicked and is used to run the other scripts.  
 - For BFD type `.\bfd [options] -p [name]`  
 - For BCD type `.\bcd [options] -p [name]`  
 - For BUSBD type `.\busbd [options] -p [name]`  
  
