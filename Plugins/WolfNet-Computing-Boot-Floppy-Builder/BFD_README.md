# WolfNet-Boot-Floppy-Builder  
  
BFD is a Floppy disk builder for images and drives. It will format the image/drive, add a bootsector and an OS. Your choices for an OS are:  
 - MS-DOS 7 (License required to use.)  
 - FreeDOS 1.2  
 - (TBC) Windows for Workgroups 3.11 (License required to use.)  
  
Usage: bfd [-d] [-i file] [-t type] name [target]  
  
  name    : name of the disk or image to build (see bfd.cfg)  
  target  : target drive or file (default is "a:")  
  -d      : print debug messages  
  -i file : create an image file (optional winimage!)  
  -t type : image type (144 or 288)  
  -n      : don't wait for the user to insert a diskette  
  
Returns environment variable "rv", 0 if succesfull, 1 if error  
  
This program uses the following files (located in the "bin" directory):  
- Cabinet Tool (cabarc.exe) by Microsoft Corp.  
  
