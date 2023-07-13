# WolfNet-Computing-Boot-Tools
CURRENT VERSION = v1.2.3

Download and install the current version of the program [available here](https://github.com/WolfNet-Computing/WolfNet-Computing-Boot-Tools/releases) to the "Program Files (x86)" and click either the shortcut on the desktop or in the start menu and call bcd with your arguments. Examples are included as subfolders. cdrommi is a multiboot cd image and cdromsi is a single boot image. If you don't know which type you need then remember, for one OS it's single boot. If you want multiple bootable entries it's multiboot.  
  
Usage: bcd [-d] [-b] [-s nn] name  
       bcd -bab  
  
  name    : name of the CD to build  
  -a      : build all ISO9660 image files  
  -d      : print debug messages  
  -b      : burning disabled (only create ISO image)  
  -s nn   : set burning speed  
  -bab    : build all bootimages for all CD's  
            (using CD's bootdisk.cfg)  
  
Returns environment variable "rv", 0 if succesfull, 1 if error  
  
This program uses the following files (located in the "bin" directory):  
- Mkisofs and Cdrecord by Joerg Schilling (GNU-GPL license).   
- Nero Aspi Library (wnaspi32.dll) by Ahead Software AG (abandonware)  
