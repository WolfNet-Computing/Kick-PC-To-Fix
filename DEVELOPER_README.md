# Readme for Developers that aren't associated with WolfNet Computing.  
  
This is neccessary reading before making ANY EDITS TO OR RELEASES FROM the codebase.  
  
## FAQ  
  
 1. Why use the Apache 2.0 License instead if the less restrictive GPL Licenses?  
This is because the Apache Licenses protect the intellectual properties of non-profit organisations and companies better (IMHO) than the GPL Licenses do, the project CAN'T BE USED IN A GPL V2 project dues to incompatibilities. Also if you look at the legality of the license then the Apache AND GPL v2 licenses can be updated to the GPL v3 at a later date. This means that if we wish to later we can upgrade to the GPL v3 License instead.   
  
 2. Why don't the plugins have their own license and copyright notice files?  
 This is in part due to the fact that Apache v2.0 Licenses are incompatible with GPL v2 licences. (See above.) This ensures that the plugins are covered under the same license and copyright notice that the parent project is.  
  
 3. Can I contribute to the codebase or release my own version?  
 Sure, there's no restrictions as long as the license is followed. The requirements for a modified version to be released are as such:  
		- Include a file that lists ANY AND ALL modifications to the software.  
		- Include THE ORIGINAL copyright notice.  
		- Include a copy of the Apache Software Foundation 2.0 License file.  
		- Include a copy of the "NOTICE" (or in our case "NOTICE.md") file WITH ALL attribution notes.  
  
 4. So what CAN I do with the software?  
There's not much of a limit on what you can do with the software, the (non-exhaustive) list is here:  
		- Use the software commercially.  
		- Alter the code. (Bear in mind ALL modifications MUST be listed but not necessarily released as source.) 
		- Distribute copies or modifications of the code.  
		- Sublicense the code (Re-release it under a stronger licence).  
		- Use patent claims.  
		- Place a warranty on the software.  
  
## Making changes and releasing your own version  
  
As far as I can work out, there are 2 really easy ways to do this.  
 1. For releasing your own version of the codebase under a STRONGER license or making commercial modifications:  
		- Include the ORIGINAL source as an archive in your file and make a file called "CHANGES.md" and list ANY changes/modifications to the codebase in this file as well as the name of the archive.  
 2. For releasing changes under THE SAME license or making private changes:  
		- Make a file called "CHANGES.md", list your name and ANY changes to the original code there.
		- Add your name to the file "NOTICE.md" and add a brief description of your changes there too.
