MZ� �   $ ��                                               [3[3ENU �NSCO    ��H V a l��z�������������*�<�M�i������������?�O�W�c�}�� ����:HS^	r
������9Pl|�����,Nq {!�"�#�$�%�&�'�(�)�*�+�,�-�.�/�0�1�2�3�4�5�6�7�8�9�:&	;4	<4	=@	>H	?Y	@�	A�	B�	C�	D�	E
F
G-
HF
Is
J�
K�
M�
L�
O�
P�
Q�
R	S>T�U�V!WGi�(�)�<,=�>�Pqx�y"z�{�|6}�~�������A���"�Z������9�����c���-g�*b�<c��� n,�@�A*B�T U` V� h&!iW!|�!�"�>"��"�<#��#�$�L$�$	�$Q%�%�%;&0�&D	'E`'F�'G(H�(I )J�)X�)Y_*Z�*[,+l�+��+�,��,�X-��-�V.��.�/�Z/�f/�w/��/��/�&�/Extended Error %1File not foundPath not foundInsufficient memoryParse Error %1$Duplicate file name or file in use
Invalid path or file name
Insufficient disk space
Return code (ERRORLEVEL): %1
)WARNING: Reloaded COMMAND.COM transient
Out of environment space
File creation error
Batch file missing

Insert disk with batch file
Bad command or file name
9Cannot find WIN.COM, unable to continue loading Windows
Locking operation failed
Access denied #File cannot be copied onto itself
)Content of destination lost before copy
$Invalid filename or file not found
%1 file(s) copied
%1 file(s) %1 bytes free
Invalid drive specification
&Code page %1 not prepared for system
+Code page %1 not prepared for all devices
Active code page: %1
NLSFUNC not installed
Invalid code page
 Current drive is no longer valid!Press any key to continue . . .
Label not found
Syntax error
Invalid date
Current date is %1 %2
SunMonTueWedThuFriSatEnter new date (%1): Invalid time
Current time is %1
Enter new time: ,    Delete (Y/N)?<All files in directory will be deleted!
Are you sure (Y/N)?Windows 98 [Version %1]!Volume in drive %1 has no label
Volume in drive %1 is %2
Volume Serial Number is %1-%2
Invalid directory
Unable to create directory
6Invalid path, not directory,
or directory not empty
Must specify ON or OFF
Directory of %1
	No Path
Invalid drive in search path
Invalid device
FOR cannot be nested
%Intermediate file error during pipe
&Cannot do binary reads from a device
BREAK is %1
VERIFY is %1
ECHO is %1
LFNFOR is %1
off on Error writing to device
Invalid path
%1%1%1%1	   <DIR>       
%1mm-dd-yydd-mm-yyyy-mm-dd%1 %2%1 %1Directory already exists

%1 bytes
Total files listed:
*(Error occurred in environment variable)
 [Enter=Y,Esc=N]?YNA(continuing %1)%1 dir(s)  %1 bytes allocated
:                   %1 bytes total disk space, %2% in use
MFile Name         Size        Allocated      Modified      Accessed  Attrib
 4,294,967,296Revision %1
DOS is in ROMDOS is in HMADOS is in low memoryCannot Loadhigh batch file
LoadHigh: Invalid filename
0Cannot open specified country information file
LoadHigh: Invalid argument
Required parameter missing
Unrecognized switch
%A bad UMB number has been specified
RHSVDAOverwrite %1 (Yes/No/All)?Invalid path
  %1.%2 to 1.08                %1.%2 to 1.0 average compression ratio
�
WARNING: The LOCK command enables direct disk access by programs
that can CORRUPT file names and/or DESTROY disk data, resulting in the
loss of files on your disk.

Are you sure (Y/N)?./S, /V & /C not supported with UNC style names) (Too many files, directory not sorted)
%Could not allocate memory for pipe.
�Sets or clears extended CTRL+C checking.

BREAK [ON | OFF]

Type BREAK without a parameter to display the current BREAK setting.
�Enables/Disables Long file names when processing FOR commands.

LFNFOR [ON | OFF]

Type LFNFOR without a parameter to display the current setting.

?Displays or sets the active code page number.

CHCP [nnn]

p  nnn   Specifies a code page number.

Type CHCP without a parameter to display the active code page number.
[Displays the name of or changes the current directory.

CHDIR [drive:][path]
CHDIR[..]
bCD [drive:][path]
CD[..]

  ..   Specifies that you want to change to the parent directory.

�Type CD drive: to display the current directory in the specified drive.
Type CD without parameters to display the current drive and directory.
Clears the screen.

CLS
�Copies one or more files to another location.

COPY [/A | /B] source [/A | /B] [+ source [/A | /B] [+ ...]] [destination
  [/A | /B]] [/V] [/Y | /-Y]

h  source       Specifies the file or files to be copied.
  /A           Indicates an ASCII text file.
v  /B           Indicates a binary file.
  destination  Specifies the directory and/or filename for the new file(s).
?  /V           Verifies that new files are written correctly.
t  /Y           Suppresses prompting to confirm you want to overwrite an
               existing destination file.
r  /-Y          Causes prompting to confirm you want to overwrite an
               existing destination file.

yThe switch /Y may be preset in the COPYCMD environment variable.
This may be overridden with /-Y on the command line

�To append files, specify a single file for destination, but multiple files
for source (using wildcards or file1+file2+file3 format).
�Changes the terminal device used to control your system.

CTTY device

  device   The terminal device you want to use, such as COM1.
-Displays or sets the date.

DATE [date]

�Type DATE without parameters to display the current date setting and
a prompt for a new one.  Press ENTER to keep the same date.
dDeletes one or more files.

DEL [drive:][path]filename [/P]
ERASE [drive:][path]filename [/P]

�  [drive:][path]filename  Specifies the file(s) to delete.  Specify multiple
                          files by using wildcards.
;  /P		Prompts for confirmation before deleting each file.
�Displays a list of files and subdirectories in a directory.

DIR [drive:][path][filename] [/P] [/W] [/A[[:]attributes]]
  [/O[[:]sortorder]] [/S] [/B] [/L] [/V] [/4]

�  [drive:][path][filename]
              Specifies drive, directory, and/or files to list.
              (Could be enhanced file specification or multiple filespecs.)
a  /P          Pauses after each screenful of information.
  /W          Uses wide list format.
z  /A          Displays files with specified attributes.
  attributes   D  Directories                R  Read-only files
�               H  Hidden files               A  Files ready for archiving
               S  System files               -  Prefix meaning not
  /O          List by files in sorted order.
�  sortorder    N  By name (alphabetic)       S  By size (smallest first)
               E  By extension (alphabetic)  D  By date & time (earliest first)
�               G  Group directories first    -  Prefix to reverse order
               A  By Last Access Date (earliest first)
  /S          Displays files in specified directory and all subdirectories.
�  /B          Uses bare format (no heading information or summary).
  /L          Uses lowercase.
  /V          Verbose mode.
  /4          Displays year with 4 digits (ignored if /V also given).

�Switches may be preset in the DIRCMD environment variable.  Override
preset switches by prefixing any switch with - (hyphen)--for example, /-W.
>Quits the COMMAND.COM program (command interpreter).

EXIT
=Creates a directory.

MKDIR [drive:]path
MD [drive:]path
]Displays or sets a search path for executable files.

PATH [[drive:]path[;...]]
PATH ;

lType PATH ; to clear all search-path settings and direct Windows to search
only in the current directory.
;Type PATH without parameters to display the current path.
8Changes the Windows command prompt.

PROMPT [text]

|  text    Specifies a new command prompt.

Prompt can be made up of normal characters and the following special codes:

/  $Q   = (equal sign)
  $$   $ (dollar sign)
*  $T   Current time
  $D   Current date
>  $P   Current drive and path
  $V   Windows version number
4  $N   Current drive
  $G   > (greater-than sign)
,  $L   < (less-than sign)
  $B   | (pipe)
y  $H   Backspace (erases previous character)
  $E   Escape code (ASCII code 27)
  $_   Carriage return and linefeed

LType PROMPT without parameters to reset the prompt to the default setting.
GRemoves (deletes) a directory.

RMDIR [drive:]path
RD [drive:]path
2Renames a file/directory or files/directories.

�RENAME [drive:][path][directoryname1 | filename1] [directoryname2 | filename2]
REN [drive:][path][directoryname1 | filename1] [directoryname2 | filename2]

HNote that you cannot specify a new drive or path for your destination.
XDisplays, sets, or removes Windows environment variables.

SET [variable=[string]]

�  variable  Specifies the environment-variable name.
  string    Specifies a series of characters to assign to the variable.

KType SET without parameters to display the current environment variables.
4Displays or sets the system time.

TIME [time]

�Type TIME with no parameters to display the current time setting and a prompt
for a new one.  Press ENTER to keep the same time.
GDisplays the contents of text files.

TYPE [drive:][path]filename

&Displays the Windows version.

VER
�Tells Windows whether to verify that your files are written correctly to a
disk.

VERIFY [ON | OFF]

Type VERIFY without a parameter to display the current VERIFY setting.
RDisplays the disk volume label and serial number, if they exist.

VOL [drive:]
[Calls one batch program from another.

CALL [drive:][path]filename [batch-parameters]

r  batch-parameters   Specifies any command-line information required by the
                     batch program.
LRecords comments (remarks) in a batch file or CONFIG.SYS.

REM [comment]
jSuspends processing of a batch program and displays the message:
Press any key to continue....

PAUSE
MDisplays messages, or turns command-echoing on or off.

  ECHO [ON | OFF]
W  ECHO [message]

Type ECHO without parameters to display the current echo setting.
SLocks a drive, enabling direct disk access for an application.

  LOCK [drive:]
XUnlocks a drive, disabling direct disk access for an application.

  UNLOCK [drive:]
HDirects Windows to a labelled line in a batch program.

GOTO label

�  label   Specifies a text string used in the batch program as a label.

You type a label on a line by itself, beginning with a colon.
JChanges the position of replaceable parameters in a batch file.

SHIFT
ZPerforms conditional processing in batch programs.

IF [NOT] ERRORLEVEL number command
FIF [NOT] string1==string2 command
IF [NOT] EXIST filename command

~  NOT               Specifies that Windows should carry out the command only
                    if the condition is false.
�  ERRORLEVEL number Specifies a true condition if the last program run returned
                    an exit code equal to or greater than the number specified.
f  command           Specifies the command to carry out if the condition is
                    met.
j  string1==string2  Specifies a true condition if the specified text strings
                    match.
g  EXIST filename    Specifies a true condition if the specified filename
                    exists.
wRuns a specified command for each file in a set of files.

FOR %variable IN (set) DO command [command-parameters]

}  %variable  Specifies a replaceable parameter.
  (set)      Specifies a set of one or more files.  Wildcards may be used.
V  command    Specifies the command to carry out for each file.
  command-parameters
�             Specifies parameters or switches for the specified command.

To use the FOR command in a batch program, specify %%variable instead of
%variable.
Reserved command name
/Loads a program into the upper memory area.

�LOADHIGH [drive:][path]filename [parameters]
LOADHIGH [/L:region1[,minsize1][;region2[,minsize2]...] [/S]]
         [drive:][path]filename [parameters]

�/L:region1[,minsize1][;region2[,minsize2]]...
            Specifies the region(s) of memory into which to load
            the program.  Region1 specifies the number of the first
�            memory region; minsize1 specifies the minimum size, if
            any, for region1.  Region2 and minsize2 specify the
            number and minimum size of the second region, if any.
            You can specify as many regions as you want.

\/S          Shrinks a UMB to its minimum size while the program
            is loading.

W[drive:][path]filename
            Specifies the location and name of the program.

Zparameters  Specifies any command-line information required by
            the program.
%1.%2 MB free
%1.%2 MB allocated
:                   %1.%2 MB total disk space, %3% in use

%1.%2 MB
Windows 98 [Version %1]4���               ?      
                        ��ENU �NSCO  T  k  �  �  �    V �  ] � � " Z � � " m � � 8Incorrect MS-DOS version
Out of environment space
H

Microsoft(R) Windows 98
   (C)Copyright Microsoft Corp 1981-1999.
(Specified COMMAND search directory bad
7Specified COMMAND search directory bad, access denied
9Starts a new copy of the Windows Command Interpreter.

�COMMAND [[drive:]path] [device] [/E:nnnnn] [/L:nnnn] [/U:nnn] [/P] [/MSG]
                       [/LOW] [/Y [/[C|K] command]]
C  [drive:]path    Specifies the directory containing COMMAND.COM.
M  device          Specifies the device to use for command input and output.
E  /E:nnnnn        Sets the initial environment size to nnnnn bytes.
=                  (nnnnn should be between 256 and 32,768).
L  /L:nnnn         Specifies internal buffers length (requires /P as well).
;                  (nnnn should be between 128 and 1,024).
L  /U:nnn          Specifies the input buffer length (requires /P as well).
8                  (nnn should be between 128 and 255).
M  /P              Makes the new Command Interpreter permanent (can't exit).
N  /MSG            Stores all error messages in memory (requires /P as well).
K  /LOW            Forces COMMAND to keep its resident data in low memory.
J  /Y              Steps through the batch program specified by /C or /K.
?  /C command      Executes the specified command and returns.
I  /K command      Executes the specified command and continues running.
         ��ENU �NSCO ]e tf rg ph ni lj jk hl jm nn so vp tq yr ~s �t �u �v �w �y +z D{ T| d} �~ � �� �� �� �� � :� T� S� c� l� r� �� �� �� �� �� �� �� �� �� � � $� 4� @� V� e� n-�.�/�0�1�2�3�4�56(76� P� ]� h� s� �� �� �� �� �� �� �� �� � � � .� N� Zdli����� �!�"�ARIFYNAbort, Retry, Ignore, Fail?reading writing  %1 drive %2
 %1 device %2
&Please insert volume %1 serial %2-%3
%File allocation table bad, drive %1
Invalid COMMAND.COM
BEnter correct name of Command Interpreter (eg, C:\COMMAND.COM)
>>
Terminate batch job (Y/N)?Cannot execute %1
Error in EXE file
"Program too big to fit in memory

No free file handlesBad command or file name
Access denied 
Memory allocation error&
Cannot load COMMAND, system halted
!
Cannot start COMMAND, exiting
.
Top level process aborted, cannot continue

Cannot find File DLL - %1

Write protect errorInvalid unit	Not readyInvalid device request
Data error!Invalid device request parameters
Seek errorInvalid media typeSector not foundPrinter out of paper errorWrite fault errorRead fault errorGeneral failureSharing violationLock violationInvalid disk changeFCB unavailableSystem resource exhaustedCode page mismatchOut of inputInsufficient disk spaceToo many parametersRequired parameter missingInvalid switchInvalid keyword $Parameter value not in allowed rangeParameter value not allowedParameter value not allowedParameter format not correctInvalid parameterInvalid parameter combinationInvalid functionFile not foundPath not foundToo many open filesAccess denied Invalid handleMemory control blocks destroyedInsufficient memoryInvalid memory block addressInvalid EnvironmentInvalid formatInvalid function parameterInvalid data Invalid drive specification#Attempt to remove current directoryNot same deviceNo more filesFile exists Cannot make directory entryFail on INT 24Too many redirectionsDuplicate redirectionInvalid passwordInvalid parameterNetwork data fault!Function not supported by network'Required system component not installed           z��������P�P���                                                                                                                                                                                                                                     ��������P�P����2!z�   �  �  �                                           �n .�.��c .�.#��X .�.'��M .�.+�C .�./�9 .�.3�/ .�.7�% .�.;� .�.?� .�.C� .�.K�.�>W t� s�> ���X  �   � ��QVW.�6�.�>�� ��_^YuSP�.�S�X[u����SP�.�S�tX[���P��
�uX��� �) &�� � X��2����X�!2����X�!�P�k r��� u�D &�  <Zt��& @����X�P&�> u"&� =HIu&�
 =DDu&� =ENu&� =  X�&�   �  &� &�
 &� &� �V�R�!&�� =��t���^øX�!
�u�X� �!�.�> u
R� .�Z�!������	���^�VQP.��h�3ҹ< � �����+�� XY^����Ѓ� ��� cox    aA  h         z��                 a  � �                                                                                            A:\COMMAND.COM /                      ��                                      ��&�= u����
�u�.�?�؋~7�6t7�6r7�ˎێ�;?t
�?�I�!�
�Ë|�J�!YQ�, ;�t��t9�H� �!�E��H��3��DCO�D
MM�DAN�DD �����3��� ���~��� �t��X�!�> t0�>� t)� �H�!r ��3������1 �������I�!��]Y��;?u;., u�C�, �J�!su�C�H�!s�� = �sG��;�r�u:�, ;�u2K��& CC;�tP�C�, �J�!Xr���I�!�, �$���I�!뙎���3�������;�t��� �, �E�X3��!�X�  �!����l�� Ȼ���H�!;�rG�H�!rAP�+£��.�E.�?��X�޻�C���������ދ�N��������I�!.�B �q���;, uPH��& @��X&�>  u���I�!Ëߪ���\��D��                                                                                                                                                                                                                            E�    �   \   l   �    /\   �           �               �U����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       � � �     �  Q	U	Y	]	a	e	i	m	q	u	y	}	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	�	
  	



Q	U	Y	]	a	e	i	m	q	u	y	}	�	�	�	�	�	�	�	�	�	                                                                                
  !
%
)
-
1
5
9
=
A
 CMD     �1	<t�)	<t�%	<t�5	<t�!	�����	�	rдM�!�i�Y�� �Bt�Bt���gt
=u�&g��Bt��r��w����� �B�X��uP��!X����tR�uN���s@�S���  &� �� t�ôI�!&� &� �I�!���%u�[��C ���3���!�"� 9t����&B�8u�Z��P3����t���I�!3��C
�t�.X�PSRW��4 �.��/�h��D6�|4�D@
Ƅ� $�DD  �DH
 �_Z[XÃ�
���3ɋѸ B�!� � ?����!s�X����=MZt(3�3҃��� �B�!� � ?����!r؁|NSuыD��D����D=? v � ������@ � r�X �3ɋ�QR� B�!� �?����!r;�u����D=NSu�ZY��%ZYS�\��� B+�[x����؎����?�!r������&���G&�Ǿh���D�D�D��&�ǌD�D�  S�h���&�ǉ@(�@*����u�[ô8� ����!r#V�h���GJ����GL��GN��GP��GR���GT^�Z�9	��> t�> u�=	�������A	���>� u>��� ���
 ��� � LP�r���t�.%�!&�v���t�/%�!X�L�!�  �e�I�!���P�!�i�> u3��3���P�6��X�������ؿ� �@ �Q�!&���P���!�� ����> u�� ����H�!�
 b ;�s'���l��l�>l� v� �l����ôH�!r�S�A ���дJ�![r�B�H�!r�P�´I�!X� �e% � r�e�;�v+Ё� s�e�W�e؉�~�+�;t.����l��ȝw3�������N����Î�������м���� 3�����=��t�.�!�>�u�O��;u�> t	�;t���1���&��U�� �S����p+��� W��؎��q�3��G� G���G�GG���G��G�� ��ףx�_�.��� �PS�ظD�!s��% ��[X���� ��3ۋ� :�t�>�!� C:�t�>�!�. ��� �>�!C���>;�u���9�/�; �SP�Q�!���4 �&��&� ���X[�SP�Q�!�����4 �X[�V�6�����F2��F��!�
�!����3�D���$^ú��? rt:���5 rt0�3�!�ʀ�A����� rt�	��	���� r�u�ÀgE� =�!s= ui�-	�}��غ 3ɸ B�!rL��� �?�!r@;�u<�������D3ɸ B�!r'����� �?�!r;�u� ;�u�������P�>�!X�þ �h�3�����Ѓ� ���3Ҿh��< ��������+����ú�� �
 �"%�!�m���!�x���!����n��?��t1KS[&� � &�σ��v&��x&�G�E�I�!�I�!ˋ	���!��>�:t	�>�:u������VQWQPR3Ҹ��/Z�݋D&�&��h� ��
��XY_���R�2Z�&A�a�Āt
���u��6���t�6	�>pUVRQS�Y�![YZ^]�>���2����s� �� ��t��u���>���vB��� �/<�u*S�߸�/[r���׹��2����E�$�	�!�E� ��� �>p�>�������>� t�q�-F���t�		�6c�b�]��	�6\�[�M�>� ue�>�uQ�6�W�z� ��_Y�	�q� ����t���� t���� �t���� ���� � �t�� ��!�� �n� � t
W�>�:_t5���t
W�>�:_t"��W�>�:_t���t
W�>�:_t�C��f�Bt�> t	�E	�r ����� ��L�!��t�	�C��
�t�> t����>� t�>�u�" �> t����ċ����Y^��ϋ	��� ���M	VPSQR�ދ�3Ɋ��� ZY[X^�R�ڃ��㋟[������Zì<%u���1��	s� FI��д�!���SQ���؊�_��t'��t+�� ��������P$0<9v�д�!X������!��
�t��!C��Y[�P��/DD�=.tD=u�� u�&g�= UtPPUP��F�F�x�F�v�FX]�X��?��t�O3����uS��2���ĿG[�PSQRV�,� ���t�� �Z ;�s� ȉ�H���;>zs&�=�t&�=�u�^ZY[Xˊ�ȸ X�!���ɀက�
ٸX�!����2��X�!����r�� �3��!��u� z���/���u����     [Options]
LoadTop=0
_.�� C�!rԋ�3ɸC�!rɸ=�!rM��3�3ҸB�!r<� �U�@�!�>�!��C���!��!+Ɏ�&�u��� �B���&�r4�  ���>�!��C���!�i�      ���P���!� � �>Q;����� � �>����C�E�$�0�!=
t�X;����&9 t�� �Q�!��&�, 3���OG&9u�GG&�=uG&8uG�������ج�
�u���C����£|7��	�C� ��/< t���/=��u���/�93۸��/���>z�(�>�C � U�/�u8&�6�C&��C�A&�A�n&�n�l&�l�C=� t	 ���+�&�C�&��C�e�������� �,�!� c�!���65�7� ���t�؃>  u�g$�
 ��� ���Y"������e% � s�e�W� �]�a�U�Y�P� �ہ� ��� �ð�s̃����S��C��شJ�!ZX�p7s �~7+£�, �E�t�>�C t��	�4����!���
�\ 
�t6�:�
@��>,7 t �>R7&�}:t��� ��� �� �&�E����6�7�>�C t.��/�u%�� t6�&g���� 6��!6��!��@��6g�B�>� u�, �t�&s���� ���2���3ɉ�8��7��83҉6�8�z7��8=��t�=  u� VP= u5���6�8;�t+�:l7t�<	t�:Yu���:m7uZZ� :n7uZZ� X^���U���딀g덀g놀> �u� �� ��r��>�7 t� 늀&g���7�7�U���8=�7t�=�7t%=�7t�=8tF=)8t:=58t�=A8t�=�7tX=8ti�|�> ug�������>7�u�7 ������ �&g��>�C t��6��7���7�jr�����C���>�7u� �����7��=M8t=t8t�?��7�3rމ�7����7�$rω�7�}��X�>�7 u���7�k��hu��h�\�=f8t�=�8t�V�6�8�ָ"=�!s�`�ظ D�!�u�>�!�N2����D�!r��&�>�Ct*Q� 3۴>�!C���ڴE�!�E�!�E�!�>�!Y^&��C���^� ������&�>�Ct�&��C���V3ɬA< u�6�l7N�Q� �6�>R7� ���t�����+�6�>R7�� �O�T7� �>R7Y^�I6:l7t����Q��6� &�E�:ZuFI�R7�@=�!r�ش>�!Y^�C��d;�wa=A u�h;�m���6�>R7� ��׎E�>�C tE�>�7 t��7�n�>�7 t1��7�l���l�� v�� � ����+~7~7)�> t&�P�ێ��!�
 ����ث�m��ث�x��ث� � ��� � ��I�M�Q���6R7�>,7 ����u�T7W�:��_s	�T7�� &�>�&�>��|:u&����<\u&�>�
�u�&�>�&��&�&
��@&�&��n�G��C����֎ھ �h����3ҭЃ� ����  �>7 u� �H�!r���E�r7�t7  ��3�����6�p7��������6�p7K3��?t7��t	+�sB����t�\;����C���;t7w�t7�>l� tl  ��C�>� u�� ����% ��3�� ���3�����������
 �>�6 u��!o7��6�7��6� 󥤺�6�@=�!r�ظ W�!S��&�O&�W[�>�!�uP��*7X�(7=A t6��7� 8�!r#��Ru.�  �7� 󥤺7�@=�!r�ش>�!�7�(7=A u�5	������I�!��  ��%  �> u�`;�����9�/�>�Ct-�&��C&�6�C� ������&�}� �r&�W����CP���=����X����۶�/�P�ێ��!�> t �
 ����ث�m��ث�x��ث� ����C
t�.5�!�r�t�b�.%�!� �I�M�Q�GP�> t� ��6�ؿ�C���ǎ����>l>n��W���������_I&�M�A���3ɬA
�u�á�>tS�˸�C���������[�R��K�㋟�����p�Z�� r-�@��( �E3�QVW��< G&:E�u��_^YtQ�" Y&�= u�����W� �W� Y+���ài7�2�� ��<�r,�S�-���[�:j7r:k7w, Ã�V���D ^�SPRW�Ȏ؎��> u�>�C t	�O�>z��>�7u� �9�_ZX[À> u�>�C t+P�/5�!�v�xX
�t������@�ظ/%�!��ú��"%�
 � �!�m���!�x���!þ� ��73�3��z7=��t8=  t���>�88t�>�88t!�>�8)8t�֍j;� ������Iu�� ��Ȏ��z3��>�CuSQ�3�!Y3���[u�Cȃ���������|��Ȏ���CP�3�!��u� �C�g uo�P����f3��f�f3���f�T�J�/3�f�P�  &9EtB&9Et	�u&f9t
&�}��u��f�T� &f9u���W�P����J�/����Wu3�W ��Cȃ���������|�>z�O;�u
��������P�C�W�_�>�C�����VW�E�>,7 t�'+��� �>�C th�t`��� +��tO� �-7�t� ���-7+��tO� �F7�t� ���F7�Rr�>R7+�� �I�t���O��� � �>  u�,7�˃���������H�!s� ���tQ�E+���+��Y+�W+��_�-78t?� �8,7t4��!A�37� �\�u�G�!� �37��;�!r���;�!O�W+��@ �_8,7t�F78t� �9R7u�� �R7�T7� ���E�,7_^��  ��P��3��K����C3۬�؋�&8tV���^tO� ����V��2��
�u�&�E�_�= t"+��< t��
�u���W� r6�>R7_2��X�+��tO� �T7�t� ���������2�< t��83�3��z7=��t=  u���S[�׿��C� �«�ë��ÿ� ����������� C�/<�u�C�/�S�U��R�!&�_&�_&�_�� &������PROTMAN$ �}0� =�!r�ش>�!Ì=�?�>�7u�Q�hu�g t}�g� uu�
�/��tl��sg�H����!� |�	��C���������C@  +�v:�H�!r4P�H�|��![�P�ôI�!X�r��>W u.��F��C� �X� �!s� �X��A �!r�H�|�!��s� �=WV�z3�������=W��H��&� ��H�ؾ �����_��|&� �>W u%�>�CuW�6�C�C�t���_S���P�[&�6 &�U&�]&�a&�Y�> t&��^_�ӴX��  �!���3�6��8��76��83�6�z76��8=��tV=  u�6��8=8tH=)8tC=�7t=M8t*=t8uÿ�7�= r�6��7봿�7�. r������6�C랿�7� r�6��7�2�6��76��76��7�&�= u&���8&�����6�z��Ou�����û�3�6��_����6��6��6��6��6��6���                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      /DEV/CON       \COMMAND.COM   :\AUTOEXEC.BAT  :\KAUTOEXE.BAT �    ,z  xE   PATH= C:\WINDOWS\COMMAND PROMPT=$P$G   COMSPEC=\COMMAND.COM =az CKA          Or                 �7  �7�7�7�7�7�7�788 8,888D8]8k8�8  �8�8    �8�8/P    �8�8/F    �8�8/D  �  �8�7/E     �       �8�8/C    �8�8/MSG    �8�8/?    �8�8/K    �8�8/Y    �8�8/Z  �  �8P8/L �           �8�8/LOW  �  �8w8/U �   �        �8�8/T              �8  �8    �8�8                               COMSPEC=                    MS-DOS Version 7 (C)Copyright 1981-1995 Microsoft Corp Licensed Material - Property of Microsoft All rights reserved PSW��8�>�8��8��8�Q�!3���9>�8u&�0 ��8&�2 ��8&�, �CrD�׸ =�!r��8��5 s�>��8�!��8� =�!r��8�� ��>��8�!���8��8_[X�� � ?��8�!s�a��8=MZt*3�3҃��� �B�!� � ?��8�!rف>�8NSuѡ�8���8�����8=? v � ������@ ��8��8  � r���3ɋ�QR� B�!� �?��8�!r+;�u'��8=NSu��8��8;�tZY�8�� ���� �����ZY��8ZY���� ��8��8S��8����8+�[x��8����8����8�?�!r���V3�&9tKWG&8u�G&8u�G&�=u
G&8uG^�?_�6�8� ��V�^t����&8t��6�8�<�����3��GG&�=u	G&8uG��^ûV;3ɊU;_�����                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         y
dB d6  ��
=�                                                                                                                                                                                                                                                                            ��!.�Ӹ���=��t�.�!.���%G3�>�u��4�����м ��������y��� �� ��t&�D��> t� ��д;�!�>D t
�>C u�G� �Ȏ�P� � 8�!X+
�S� ��[�t���= v% �= r% �1���t$�>��t�,��rx�����t�<��`x�&�����j��&g��t�oFr�C�u�"�u����u��:6�&���> uW����uO�t�/��F��6 �/�&��gt&�&g��Y��>�ެ��E�@�����!�$��[�&g����' �( ��!6�$��C�t��F�t��Er�"�u����u�t��-�"�t�6��� �� �< �! ����td����  6��ރ��/<�tA��� ��u� 6���
 6����5�+ ����u�)�� t
���)  � �> t6�����&���� �6�� w�6�>��3ɬ�A<u�IV�6�މL�^�K�	]�!�]��!����R�H�/�t�
�!�u�D�^�L2�>�މM�A����>93���79� �����ӣY����t��g t
6���6�����u��� �[�Y�6�ދL��s� ���C�t
�!�t��+=t�D� �(Hs�K���u���>�� t�>�� tߋ6�޿Ը)�!<t׋�ۀ:u���߀�A<�t�>�ۀ= u�r���:��0Ӱ �	 G�*��ԋ>�ۉ>'��~ �>�ۉ>+Ӌ>����#>�މ>-ӠԊ0�
�u���:�;������t�+�>�t�#��3�&�Ӿ��6l�l&�ӡn&� �&� �&�V����l&���&�6��^Ë6���u�6�޿\ �)�!�%Ӌ>�ۉ>)Ӌ6���u�6�޿l �)�!�&��U�6�޿l �)�!GV� ����2���^uL&�= uF��� 3���� ��� �z7��^r-��u(&�=%u"��׵&�E��4t	�ňC&�E:�u����]���5�< �s/��&�g�t!&�>(t�@t&����t&��&� �Ëֻ �@�!�!��t�;��u�A�YNr��\��!��u��!<?t<Xu�&�g@�<t<t$�:�u&�&g��:�u�����	����:�u���д�!���6��V�6��\
�T^�3�9�u8t�>�uBP���/��X�R3����Z�R� ����	rÃ�t
��t�5 �.��t��RD�!�E��q�Cs���H��7s���1s�. ����  �,>�����s��q��s���י��u��R�c�!R�c��!��!� �!�cZ�!Z���	�u&����>  t�LV&�6��&�^�5��;�&�>�ތ؎��6 �6
 ����<:YZt1����t8<@u� �-��� �
 � B�!&�I���3����������u����A�2tA&;�sc����;lsX�<u�&+>��O��V&�6��&�D�^��z&��� �8 �> t�ut��>+t�4�b(����5�4�I<t�b�룋6�ދ�>�3ɬ;�r�� 2t�G��GAA��<%t
�AG<t���! ��VWQ�6�ދ�6��YI�6�މL�_^�U�ي<%tt<0r	<9w� �W��MW�Ԭ�1t�����<ta<%t���=�V�������0^�  r9�Ƌ�_P.�.��..�ެ
�t;�t���^��.+��.+�]ì���V�\ ^s_���S r_�������9 t�_������. t&�,0�����&�ӎ��_���t
�<t�C��ð%����.�������W.�>�� t��F��׬�u��0t��u_��������u���<u����&�e�I�!��ӻ���H�!S�H�![S�A ���J�![��B�H�!P�I�!X&�e�Ӌ�%�u��% �u#��% � r&�e�;�r��;�r+؁� s&�e&�W�
Ӌ،�+�S� ��[�t���= v% ��1�ÎӺ��&��u(�ҋ6���23۬<"u�� �8\t<u�N����u�X�&�>(t�n9��&�>(t�=	�p@&�$P3�&����t&��&�>(t��&� P&�>(t�f&�( �ҿ��F8�����/�N�ֹ �!�$:�ك�?&lQ���S�H�![r7P�  ��&�l��&l��� �°�����;�r;�wX��� I�!�� X&���m�ZX&�%&��&�   &� ��3��"&� ���t�#�" &� 3��#�&� &�  &� &�
 H� �߹
 �.�Ӿ����.�6�޹
 �'1<t.�uS�	&�?��S3۬<"u�� ��Zt�<t��[����I��[2���]���J�!�>�u���X���ZXX���q��s��s� ��4PS.��.�ӡ��tJ���u� &� �&� �#&� �"&� �I�!�)&�%3���R������Z[X�SQ�	�t�� ����u� ��&�>  t� &� &�
  �Ȏ؋I���uC�K����f۴?�!s$�#�Ӌ�����mV�6����D ^���Z��� �k�3ۉIኇK�C;k�r����I�<ug��&��&�>  u&� ��&�. t&�> t��7�
�2������	��	 t	.�>��3���>�u�>% u���Y[�X���3�#� ��  � ���ۋt	�0/<tދ�� ���G�7�u�&�%G:�t�� :�����GG�u۬<t�� /u���.���#����V3ɬ<t���.tA��<=t<t(����<=u ��.<t_�tN�<t��<t��.u����g�U���.u�2��Z2Ҭ<t	<"u����N�
��u��.u� ߸���?�V��3Ɂ<\\u���:8��������8^��>�� t�r9��  �#��t��
�t���-.�ο�ۋ}	+ϋ>��&)M�&�M�������!����N��
2۬<t���-t,0����Æ����ӊ&i2�:�s���뒎ӡ��uÎ��ؿ �u�	 �=�t�5����<u��< tۉ5�����t
�?��-t�����VWPQ�6��V�-��_�Ӄ��YX_^���'�(�>D t��8Î�����t�3���� �
 �  ����] � � �uA����&����v�r<:t&��<
u	�f�r<:t����u��w �� ���+1�G�r��] &����Q��Y�W*t&:u�GI��Q�n�Y&:� &:u�, &:u�G���R�&�>��}< w�<t�?�<u��8���&�  � �.�fۃ�r�>�!� ����  � =�!r� �
 &�fۋظ B�!&�I���Ë��L�Њ,@���)�t6��&� �� t�ôI�!&� &� �I�!���%uԈ��  ���&�Ӂ> �u�>% u�����t����t�+���ơ#�؎��>� t����;��  �<�O�.�ӠA
�t���X5.����Gu�7�(8D�uA�:8Du��+ʃ>� t!�Gu�O�<Q3ɿ���5�.���  Y����.�����5.���  ���r�  ���t�_�V�7���^�>� u�< t�u�2��3���3�.�>�ފ��6�  ��;�w	F�F<%u84uFV����
���OA^��I<u���V&�6�މL�^&���t1�>+t�~*�+ W�_&�E� ��މ�׺X��g&�E����+ ���E�(����&�>" u�&�>D t�53��� r�<%uۋ�
�u��� r�%��=INuǬ
�u��� r�<(u��� t��)u����OF�� r�=) u������w���)8t� r����� =) tG� r�%��=DOuЬ
�u��q r�PSQRWVU�i�� � �&�#�k��]^_ZY[Xr<&�6#IO&��&�>�&��&������&�&&�"&�>�u&� ���q��s��s� �-B;��}�ڸ���`:�7������ӺЃ�> �u����Y-P.��&�#�t���I�!&�#  &�" X�SQRWVU��%��ӱ�� H�!rd������3������6�ދ��F�����3��6��6�F��I|$���9����+�&�����+�&�W����+�&�W	����������]^_ZY[��6���s�*������������� u%����>3�I�
�t���d t�<��`,��.8���^��մ�!�\ G�?� ��r|�,1��&�>'� ul�s���@ t
��s�&�׿����� �Ns� ��� t!���}'�3������0����G���%�rc��� unf���f�uf�>�� t���X����'� u�'� t0����;���L'� �q��s�s��kd�'� u	� �3���$��9�>s�u�s� �h+ø* �������� �������6��3ډ>�װ*������ ��� 3���ף��'Ӣ&������ףP���� ��� ��ӿ�ᾫ��0 �1ӣ����r)�����3�� � NrV���N s�c�q����c^�^���t�F����� �  C;��s"S����7�7�oQ�ˊ� Ys�tc�[��[����u��Ӏ>��v� ���S���.[�.��� s�����n	�
�t=H t��������ÿ$�� �H r� +���V.��5^rø ����c c c c c c c c c c c c c �c c \ � � c c �VW�=FG�= t�t�_��^����__��� � 8�!r��t�e���� �ӿ@��!s�@� ���� t
�&����&������	 t�&�׿�@ �ؠ� 
�u�2�����۸D� ���y��!��ۣ8��7���� t
�&����7��>4�:u
�3�$�,@�\ ���  u�&٬
�t
$<u������u�'��d�6������>�� t����g%^rt�6#��6��r-��;����u3�>!� t�'��%�|:u��<..u�| u�'���\ �)�!�����#5�!�E�G��2(�#%�!���/��� ��r8���fs= t��8S��[��� 2��S�����[��  P�..P���:XX�r���&= t= t�����t%�>��.t��Ջ��%v��Ջ��s
��Ջ�� �þ&�3��
�tFV������.��gr������Ї�^t��u�����
�������� ������	��	� �>@�u'US�A�/CC3�&�G;�s׋�&�;�s�;���[]��&�Ë������� ��&��Ë������� ��&��Ë������� ��&���&�G&�f%:��&�G&;F������� ��fQfSf�   f��f��f��f3�f��(  f��f��f;�rf@��f��drfC3�f��f[fY���� tF�"�����_����@ t��ӣ�Ӿ�ӿ�ӥ�f���f�~�f���f��Ӿ�ӿ<ӥ���� ���>I� t�S"�A�� �� f�\��f�tf�X���J�f�	؉غ���f�X��f�	غ���L_����  tOf�\��f�t��f�	؉ػ �f�	�3�f�\�f+X�f�d   f��f�\�f��Ӻ���t�����^�Ã>P� �� SQRW�L��E  �\ 
�u��!����@�:�H��J�\ �HӸs�, �!r�T��(�6�\ �!=��tI�\��^�  �X��Z�  �PӉT�2�����������s���ӊ\ �	D�!r��t����_ZY[������׋�>��2ۆ3ɴN�!�r���@t3��O�:���II�x����ø��+��� t�& �"��r�
�3��߸��>�� t���������Î
�3���p r���v r���s��� ����&��Ã��� P��* P�*.P�/P�Թ �N�!r,�e�� �O�!r�Y����n= u�~ �t������
�t��������&�<t<�t�Ã������j���� ��r���ج
������À>�� u3Q���N� �!r"��>�� u9Q�O�!r��Պ&��"�"&��:�u�Y�QWV��� ���Nq3��!r2����QWV���Oq���3��!s��*�����&��"�"&��:�u�^_Y�3��:ӣDӣ<ӣ>ӣ@ӣBӣ~ӣ�ӣFӣ�ӣ�ӣ�Ӣ؀>&� t� s�W��J�M�rE�������>� t�?��J\���� u
�>�� u��� �r���� u�1ӣ����= t= t��(�>D� t �+���  t���t��� t��	���
�3��&������rA���>�� t������r"���+�=!s������>�� t������&����� �À>�� tIWSW���u1����X'��� l�D �/ � �!r��W�!��>�!�r&�U����&�E_[_2������s ��ժ$��ի��իu
��ի��ի�3�����3����@ t8���u1��Ջ�վ�Պ\ 
�u�n����4��@�:��]��t�3���H���
�t<.t����W� � �_W�<.u�
�t���� ���
�t<.t���_W��� ���_���2���#��(������$�V�t�
^����«�t�d  �d" �D ��D"�V�t��	^�«�t,W��2�����A�ً>��+��>���_3����@ t<���u5�#��7(���\ 
�u�
����4��@�:��n
��t�����H���&� �À< u������ ���� t	�����!�������V��� �<:uF�< t3� �
�t.<-uJ��w�� �u�у�������� �����������^�VS�<:uF�< tK�&ي
�u�C�C�C�72Ҭ
�t0<-u����}�� �u�ك���u���@
ʈC��*�s����� �[^ÿ������
�u���մ;�!�W��2�������_���
��D�&�GuJ�:�f���&f�Gf<�f�@� f��f��� f�t*���  t"���uf3���f~�f���	�F�f���Ìَ
Ӏ.��t|��� tK�>�� u��Ῑ�W���
�u�_�������� t���O2������O&�}�\t�\ ���יԺX��X�
Ӌw�t�
�t6��� t����� ��.�
ӎ؎������ � ��A�ы����6��� t���� ������ � ��t!A�B�.� ���	��.��� t�� ������� u=��� u�A�9 ��� t���������@ t���>�� t�)�i�� ��B�v�\������K����� ��-K�@�P��
�t��2����6�.� �K��׺X���V�6�>� tW6�>���6�>�_��W6�>����
�u�6�>�_�W6�>�������� u+��� t�o�]�� �z����>�� t������V�@����  t"�����  t�˅�mV��r��dV���� ��
Ӌ����ӹ �� �� �2�������� tV�@^� �`���
Ӌw� 6���  t� � �����(��6�>D� t6�>6� ~�i���U���6�7�6�6�6�6��6�
Ӌ�&�Ft�l���U6���  tY� ��Q&�V6���&�V6��׺E��U6���  t06���u�6f���f3�f�t���6f���f�t�U���E��_U&�F�u� ��k�6���6���&�N������������6��ẃ�6��� t26���  u)S�ڃG�G�o
$�G
4� U�o�o�o
4�G
$[���T�����T6���  tg&�F�u�
 ��N� 6���6��ẃ�6��� t26���  u)S�ڃG�G�o
$�G
4�T�o�o�o
4�G
$[��}T�p �ۄ�tT���6�
�&�G=��t6��6�&����6�غ���ITË�% �Ћñ��$������2��P6��� t6���  u��l���dr��d���VW&�NQ�L��UY��׵� ���r�Ī��u�&�-_^�6��� t���6f�:�6f�F�3�6���@ t:fPfRS6����t(6���6����6��6�&����6�غ��~S�4[fZfXS6f��6f��׺p��dS6f�>@� t"6f�<�6f�@��-�6f�<�f��6f�@Ӻ������3S�� [6���  u6��� t�t�G��S6���  t>6���u6��6f�~��<f�t���6f�x�6�|Ӻg��6f�xӺW���R� � ��6�
��Gt�[�	����Gt�]�	� +��� �}	������ tSQ�I�7��>�� t��	�'��mRY[���H�8�à\ 
�u�$���@�:��q��s�6���u��s������ )8�@98�w����� t
�>�� t����� ÿ�ӹ" 3�󪣂ӣ���PSR� �Z[X.�.E�<Ar<Zw �W����
�t������_�VW2�6�6����}:u����
�u�
�u��!A�Ћ�N����6���  ���6������s�6���:��ª6�����6�>���_^�6�>I� uPVR2�6�>��:u6����߀�@���6�3��!
�u��!����@����D:\6�>�� t
���`q���!Z^�SWV�������
�t	<\u��]���� ^_[�R���6�1��!Z�6�>��:t	��!�����6����߀�@�6���f��f��f������f��f��6f�P�f��6����f��f�����fSf�f��6f�P�6f�T�f��f��f�� f�f���f3�6f�P�f��f[�S2۸�q�!s3ɋ�[�6��׀ u��6�1� ;6�3� G6�=� C2��6���6��ả��$P�\ �-�s� �\ 
�tJ��$ӸJ� �/�uw�Àtr��SR�J�ӻ �/ZY�u]����:�t�ـ>�� t�Ӵ6B�!=��t?�����ʋ؃��� ��Ӊ��#�#��u ��u��t����ӸCq��*��!r�����SQR���tN�����J r?f��f��f�f3���f��ӡ�����Ӌ�Ӌ�����������F ZY[�3���� ��W�>�� uV�$���Q��^�Cq����!��>�� uPR��ZX�_�VW������2�����< P���t#��3ҋ˻
 ����ыϋ������ыϋ�� [=
 rC3�����_^��%f��f��f��f��f+�f���f��f������3ҋ��S���ӊ�Ӏ�r��3Ҁ��������������[ú��@N�5����'�  ��� 3���� �K� �҉�)"rW�>��t;�|:u�| u� � �Kۀ>K�v� ���x�NV����^���I��붃>'� t� �i��S�'���t�Gø �T��>�>K�u���� �#s���=  u�>!� u�u��"��'� �q��s�s����� �P��t!s�tJ�NV��������������;� V�C� 
�t�;�Vq�C�, ^�P��4!s�t
���!� �� ���)�Gu�:8Du	�
 �����V���5 ����f^rIV���C�>���5���6C�<.u�| t%�|.t������;��!^rV����P^s�2��^���= u� P����t�X= u�#��= u������u�����
sË6��V�^���9�@ 3ɺ�3��!s����3��u��L�ظ D�!�t�o�����B3ҋ��!�m�o� B3��!�� �
�3�.�>� t�.�1�.�>o��t1.�>o� t.)m�.�o� �.;m�v.�m��c.�m�  �.)m�?�!s�g����H3�P��X�=  u�}�u
+�I&��S� �@�![r;�u�z�I;�uû � D�!�u���&��� &�K� ����Xr&�K�&�>K�v� �# �&�6�����t�A��&�>K��t�� � ��&�q�&�s�&�u� �s����� ���� s�tF��r?�� �{���W� ��/
�t#���/=��u���/�Ӊ9�;�3۸��/_�����h� �x�U ���3������G� �?󪺝մ�!�U ��!P�\ @<@u�$�A��X
�t�Q����Ӌ׾�չ �2���a�R�D2��\ �f����!Zr�.J� ��~��#J� �q��s�s���SQRVWU�Y3��!]_^ZY[ÿU���� ��s� �t�� �~����S��? �[
�t4�3�!��<v��A�غ΅�I���r	��r
����ޅ����I�]�A��I�	r&�= u
�c �>�U �8&�G
�t0<$t�D ��&�G�g�
�t����	:t�? u���W�W_��úo��5I�=���
�>��<��|R�д�!Zô�!A�����Ӏ6�t'2Ҿ�ԋ��$�AP���X�:��Ӫ���>�ס3��!s���
�t
���`q���!�X����� �H�� ��ԉ�׺X��HÊ\ ��@<@u$������P�:��ӪX�3P��ԡ3��!Xs�
�t��ԋ��`q���!����2���ΪO�u�� 2ۋ�3�<;uF� ���6gsbWVQ�YrU^V�<t0VW&�G��t"P��/����<tP��/��:�t�_^F��_^��؋�Y_PQ+ɬ��t�A��^�;�A�^_�<u�t �C<"u�� �tF�� u<;t
�P u��T ��O �Ѭ<t< t�<	t�s��s� �q����A��ξT��2�����t���`��� �(
��� u�9
�V2��D�P��W���<"t��
�u�_���|:\t2��,V��^
�t#WQ�h1Y_s2��2��+�Q3�I�Y�XP&�E�X^�D�t�����;�s�<"t�A�Iu�n��몬A����r!�T�2�+����"�����+��%��F�ǃ�F�� �/<�t/�D� ���y��!r��ۊ�ۊ��>� � D�!�t��u�R �,��<v
<t� ���@ �؋J �6� 
�u���� �����R�3��Z3��ȴ�2�����3��þe����2������!��������� �rV�3ڬ�< u��}�:u�E� ^�r�"�3ڸ l�B 3ɺ�!r�ظ D�!�u�>�!�̓�E�@R�r��S�QG�ָ @� �![Zr�2����D�!S� 3۴>�!C��[�E�!�E�!�E�!�>�!��� ���P���� ����hs�tr�m���=d rR=�wM�����sJ�� �/<�t����I��״f��!sP= u�Y3��!= u���(���#�Y3��!=A u����� ��� ���������f��!��׺Ђ��D���� �É��s�t�<��δ �.��5��΃u�|:uV���:.�� �^�V��< u�^�Jr�S� �����΋>�޴`�!s�I�������u��z��މ�׺X���>D��Ӏ> u�>� t��P˃>�t��ʸ.��>1�3�/���&��&� &��&�
 &��&� &�i���u� P&�> u?&�r���t�.%�!&�t�¸/5�!C&�?Xu(&9Wu"��&�v���t�/%�!�ӴI�!X�L�!���ӴI�!J��&� X�1�!�q��s�� �s�= t�6�׉6���u�Fú6��TC�9��NC�� ���x �
�!�
�t�� ��:< tT<uֹJ��jQ�CYu����|:u9�P��/DD,@r+< w'� P�ط�D�!s� �DR3��!ZXr@��u�Ä�u��Q���	��t����+��־Z��2�ǻ � �����>Ӏ v3QVW��ۋt	�p�������+ƺK����� FE��� 3��k _^Y���t�3�3�V�A<t<=u����À<u���^��t���^	������+ƳVP��%��=PAu�%��=THu�<=uX^����2�3����X^S��u3��� [��u��2������V����� �b�� �u�����^V�<t���3��^�>�� t���ӿ���3�&�
P��Xu�|:u��$,A����&�
@&�>�&����&�>���\t<t<\u
&�>�&�����2����� O&�>�ÎӎE3��< t���謪
�u��%��$A��RPVP��� � �  r	���o��+�X;�vY+�
�t4�>Ӏ v,P�L���� � ���  r���@+�X+��K��� @ PQ�YX�@Q���Y;�r
�؃�Q�cY^�� XZþU���[�V��� �6 r���� ��&�< uN�z+��^þU���� ��[���� � r�� ��W ��&�E3�QVW�� tN�GG&;E�u'I���"�� G�>�� tS��&�E�� :�[�&:E�u��_^Yt�Q�h Y&�= u�����W�S �W�Q Y+���À<t���J t������j �<=u�þ ���ۋt	���H
�t��<Î�&�E3�&�= t�� ���=�2����VP.���65�< tXP:rF:vF��3��3�@X^�<�r,�S���-���[�
<ar<zw, �PQS���[S���� �r�����Ȍ�;�w	˃� ;�s�J�!�������s�?��-[YX�P��H��&� �����X��Ӏ> t��С1��!2��!���� �É��s�t+=��u]�
 �V�t^�u�|:u�mr�v� �A��7����b�V��	�R^s����%�u�1��!s��h�= t
= t�� �����^>��@ r:�7��!s6�C�= t(= t�� �!��δ�!�N� �!r����t�������>���� �K� �5� :�7� 9����r7�Kۀ>K�w=��u3V�
^
�t�5�:q�7�9q���WV��< u�^_������t=��t���&�������� �M���>K��t� �����w�ru�5��!s�x�= t
= t�	 �����n=��q�����u��s�s�ÿ�Њ�@<@u$�����&Ӱ:���&�3��!r��R�r��q��)=Zì� t�N�< t�<=t�<,t�<;t�<	t�<
�S� �߬�< t�������.����< t������2��[æu��|� t���P�QW�������E� ��׺X��<�E�r_YX��Ӻ)�&�>C t��Ӄ�P�/8&�t</t<\X����  �>I� u	�\ ��rI����uB�%�u;�s&t�-r��u�(�1�= t = t= t���� �?�] � �2��� �6��N�D��>�� u�{�td�΋�R;�t��]�tF���d�u��J���Z;�tb�΋�;�t��� ��6�t�F�����P�.8Du	8Dt�| Xt�D�<:t-�>�� u��u��� �a s:t�u r��u.�B �x���Ê����u�3ۆ|�8 st��L r���tڈ|� F�6#ٜ���u�\ �)�!��= u�\�=��!�V���	
��u�1��!������g	�^á=�2��!Ó�3����:�u�� �F���<t�F���Q�� �u����I� ������̺�����

�t���t)�Ե ��������Ժ���Or���/�>� u� �v�3�3۾ԊG�:�u����t�C�� �㿮����"�G�GG��>�� u�L�'�-�% t&�"�t�>��u��  P��t	P���;:X��X����"�t�%�
&�<�u�<��T�"�u�9 t�q��s��s� ��6��������Ӏ>'�' t���j�P.����X���t���.�#� .�0�.�Կ�� ���t= }���� ����� �J��&�k�ӴI�!��&�&� �ҿ��y�\ ���R ���gt0�J�/� �����с��J�/R�0A� ��J�/Z�J�/�E� K����Ѽ��.�.� starting
��t�&���3�!��r�N���K���8飿3�2ҎӋ6�ދ��<"u����<u�R�����t��=  u��D�  ��<"u��t�<"u�����<u�Z������t�G��GAA��<"u��t�GA�<"u���<>ub8u�&�<�8�<<t<u�&��	 � W����2�Q��<t#<"u����
�u�	�t:�t<<t<>uN� Y�Z�����Y�M<<u%�����<>t<u����	 �YW����2�렊���|u9&�>C u&�&&�C��<t<|u�$��:+߃��t&8E�uO2��_�%G��tA��&�>C t'�H�A �!r4��3��Ӊ>����6���E���<u�V�6�މL�^��&�>C úB��e��� �6�ދD���ۋt	�P��X�Z �+Ƌ��{��r�~ ��G���<t���ρ� &�� Ë�޾Ժ��� ��/< à��
�t	VW�*!_^s
��VW�_^�PV3�3۬�_#t<t�� u:�t
A<"u�� ��^Xá�׋6���%� �!� �6�׋�׋��BQV[+�Yˋ���� �1I����tIF��������u�!�<?u�%�<*u�%�:�u�N2��F<u��6�׉��þ�ۋL�t	� �� <ì��u<;u�N�RPSQVW.�Ӏ>C u�!�u� �Y _^Y[XZ�.�>�� t�����.�9�@ � 3��!r�ذ��G� ��� =A t�t�B����.�q��s�.�s����>� u� ���H�>< tj.�9�" � � �!rP�ظ D�!�uh�B������!� ?� ���!r+;�u�>���u@�B������!�4.�Ӹ B3ɋ��!�$= �u�[���3�.�9�" �� �!s�B��ذ��G� �P3���A
�u�+�X�s��SQVWUPR�Y�!Y[�T�=A t�Ë�]_^Y[������VWQ�3�3ɋ�W�< t�A�����_��׉>��Y_^�V���O���Q�2��Y^V����^�G+����������������S��‿��\t����:tƇ��\C����������>�� uǇ��*.CC���Ǉ��* ���[�W�>�⬪
�u�_�W�>����S�����؀�\t�\C���[�VWQRU�6��V3��
�tE��^3ɋ�V�<.u��<*u��<?u��
�tA��^��� t�<.tG�>��u
�>��:u�4�]ZY_^Ã>��u�|:u������>�� t�� u��.*�D ������A��G����6���*�RQS
�u�RQS�(
�uX�|:�t��!A�:.���.���\ V����3۸�q3���!^rh�� @tb�.�1�;q.�3�Gq.�9�lq.�=�Cq�`W�|�<\\tGG�2������Ѱ\�|�  u�O2�&�P��3۸�q3���!X&�_�.�1� ;.�3� G.�9� l.�=� C2�[YZøNq.�>�� u�o � N3��!�u�r.���.�>�� t�u,��S�Oq.���.�>�� u�= � O3��!��u.�>�� t�u,��s.�>�� t�% �[ø\\9t�|:u9Dt2��R�״�!Z�S3�.����t��q�![þ��.6C�< u���.�Ӄ> t�>��ð�Ӣ�R.�ӺE�A�!���A�!Z��D ú���������PR�Ӄ����o1ZX�=A u���.����DWV�Z�&��� ���r���9�B�E� C�!r�� u�^_s	�. �E���E3ɴZ�!s눋ش>�!���Z�!s�v��ش>�!���6��>�u� ��3�&��6����<|t<|t�� �?� =�!s�1��ذ��G� &�>��3����<u���|��8t����<|t��������t���AA��<"uA����A<"u���<tEA<|t<|u�&�E�IW&�>��&�M�_N�6��AQ3ɸ <�!Ys�d��ذ��G� �?�A�W&�>��&�M�_N�6��Z�����@��> �u���駶������ ��s"�u<�����	�����/�� s�t����6����QR�aZYs	�+�!
�u��Y���/����t���3�3��'=��t=  uN�#�,�!���-��/��(��X/�=��t-=  u)�.����6����QR� 3��='<�ZYu	�-�!
�u����%��/뿎Ӏ&B�B�P.��3����t���I�!2��C
�t�.Xô,�!���.���.��������.ø 8�\ �!��.�u�Hx.�x�t.�{��¶�=0.�6����..��  �
.��ރ�V�����D ^� �U��!V.�6�ރ��L2�^3��=����x r���.���  �M�3ɺ8��6.�
�������D � �
��!3������迦�3�3��&���< t�<	t�Nù��2����W�_�ѿEWQ�Y_������PS��޻  �O [X�PSV���;��t;�6�������3���ۣ�ۢ��V�6�މ6�ۋ6���� F�6����� ^��� ^[X�QRWV��t���  �����3�� ������3���׋6�޹�+˿���󪣈��u��ދ���A�����I��ޢ���Ӏ>" u!�>�ދ���A�W2�W�>�ދM�_A�^��� �6��3���� ���.s	�t� ����� s��������6��^_ZY�SQRWV��n �>��@}W�������޸��� �G  ��t�o�O�w�6�މ76h�+��w�6�މw	���>���;>��}+��� ��>�ޝ��
� �� ��^_ZY[�PSQW���t'�>���t&��޸���# 	o	.���� t��������ޣ�ޝ�_Y[X�P�ó��[ÓË��;��s6�������O�W�7�� uh� t&�Et����6�ӌ�Ӣ��3����ø  �������t �uY�|:uS���,A��<wF��Ӱ���@t	�[ r�r.���t�W��}�t�E�?t�Ut����떸 �� ���뙸
 �����;��s�����PS��Ӹ���(��7[X�W�w	���3���ӣ�ӣ�ӣ����� � ���� rx�{ ���� rm�p ��ӊ< t<	t<t<
uU��Ӄ> � t����tD��ᡔӃ> �r���t����t+��ᡖӃ> �r���=d w=P sd l����L ��_�������3�Q�
 �<0r�<9w���� -0 F��Yì:+�t</t
<-t<.t�À<0r��<9w����PS��Ӹ���1�;w	w[X���Ӌ��;��s���VQR3ҹ
 �
�t,0<	w�������������ZY^ø	 ���V�
�t�;�tFF���\�F��^�SQRVWU����t�� �o��޸ �!�/��މ>�މ>�������r֋��߭����tx��ҋ6�ۋ��+΀>�� u[�:��r8dt�<\\tI�$�A������ �Ѐ�`��ު��r
�I:��tANV��� G�!��^��ހ= t	�= tG���8uFI��� ���u���+�ہ�ҷ;�� ���u�s�3�� �ҋ�ދ6�ހ>�� uI�6��&�|.u;&�|:u4Q&��&�D�E��ވEV&��� ��`����� G�!���N��^��Y+��6��������tI��I��w�������O���:E�t����3ɬ�
�u��ŝ]_^ZY[�P�/��t�\���Xâ��X�SQRWV�������6�މ6���6��2ɬ
�t:�t�l�t�����2ɪ���6�ފ�3�����t!���
�u:E�t���
�u������ʃ� 
�t�����^_ZY[�QRWV������k���⿘�
�t��� ��re���  ��� �>�� t�����R ;��~��޿�޹ ��<u�q����ހ>�� t��� ���s���ހ>x�t�xۣ���
���:'�  �^_ZY�WV�  ��� ��u?���e߁e�߾E��ǧu�u� �#���I��u�u� ����M��u�u� ��  �>x�t=  t�x۸ ^_�PSQRWV��x���ۋ>�ۀ= t@����+�A�.���	�x� � ��+ʃ�;�������>x�u
O��?���� ������^_ZY[X��{sÀ>'� u�>�� t���Aq3ɾ �!ri�c���  ���! �����s�QR���r���A�>�� t�Aq3��!Zs��ۣ�����违���sɃ>�� u�����>'� t�����������R���Z�>s�u�s� ���͉�� r��u�À&������ t������c�ӊ������"� �3ru��!�2��!À� u�2��!�ںك��
�u��R�ڭ���&���7Z�K%�  ��P �.r
u�!����!À� t�H�T�!�غ���+ r�Ӳ u��AÀ� t��&�ӊA�	�댿ȉ��� ���r/����  2�_�� G:�u
QVW�_^Yt�@�����|�s9���A��ۋt	2����g t�N�<t#�\ t	�% u��V�<t�H t�^t������q������< r+</t&<"t"<\t<:t<.t<[t<]t<+t
<,t<;t<=�:��< t<	�W� ��������~��$$_ÿ��*�!�QR������Ρ��W�%_� � �ZYÊ�2��#e�!À>'� ur�6��2Ҭ
�t&<*u��t�������<.uP��uK��tF���Հ�u	�>�� t5���u.�>��#�� ���x �
�!�
�t��a���r< t<��@�u����À>'� t(�/����׺X��Z#�;��T#��!�T�r
< t<u�����3��7۹ �:ۣ0ڢ/ӣ3ӣ+ӣhۣ#٢0Ӣ"٢/ڢ%٢2ڢ!٢.ڢ�Т#Ӣ�ۣ-Ӣ&ӣ:Ӣ%Ӣcۢdۣأ&٣3ڣ�֣�գV�H�*ڢ5Ӣ-ڢ!��� ���ۋt	�u��+���3��؉6������K��ǀt�J���u� ��w�� t�-� t�� @�� t�-� u�-� t�� @�b� �� t.�D�<yt
<Yt�� @��D� �-� u�-� t�� @�b�	.+�	.-����yt
�� ���,�r5�U��r/�ǀu�&�V�h۾�+ƿ&�ǣ#و"�A�>%��+�  ^�#��>J�u�>&�u�>K�u�W����Jۢ%�����C۠&�
�u�s��s� �q���<v�s��s� ��!�<u �$�A�:�F�&٫�+�  �F�F  �{�~u�:8'�u�N�(��F  �_�~�= u����:8E�u��F �N�B�&�������-ө t�T�!��2��.�!3�� ���ۋt	�+���E��u�	.+��� u�>%� t�I�V��������^�Y�D � �@�`��6:Ӊ6:�� �o��>%� uI�q��s��s� ���3��u����>%� u3��/ӣ3Ӣ0Ӊ6Aۿ�н.ڠ���a�0	�60�À>J� u�3�6A۳+���
r��ǀt���u����><�u�=��{��=� �g��!�t�i�2��5�
�t����
�u�2��Dۋ>0��
�u��>b� ts�h�3ڿ�Π���
��	u�>%� u�5�����W����>/� uB��r�>%� u6�>c� uF�-�>>� u�>%� t�0������ t��>d� t���0����>%� u�2�t	�5��]�"�� �>%� u
��r�/� �>%� t���>��t��o uI�0� �)��>>��t�6Aۉ6?��>��3�6A۳+���Y	�ǀt��u��p���߀>%� t�D� ������d3��/ӣ3Ӣ0Ӌ6?ۉ6A�� t�	�������d�  ú3ڹ% ����'�  þ3ڿ�Π�����#� �@�?�3ɺ�!s�� t!= u�@ ��؉7۸ W�!r
�LۉN��(�8����3��u��E�>7� t� �>/� t�{��{��7۸ D�!� 9�t�>E� t�փ�,�7ۋ1Ӌ3�+�u�I�P�X�Iۀ>H� uq�1��
Ӵ?�!r����]�>9� u�>I� t�ы>3Ӱ�
��u�#�A+ы�3Ӊ3�;1�r�I�P�\X�Iۀ>H� u�~��>9� t
�>#� u�m��7۴>�!À>0� u��+���t.�3��t��3��
�� �3��D� �F�3�r= t
��uփ>F� u� �*ڋNۋLۀ>C� t1�,�!������������
�Q�*�!����������������� 
֊�Y�� ~J�W�!r�B3ҋ��!М� D�!R�>�!Zs	��� �? �%�>J� tR�&ً��Vq�!Z�u� u� ��:��0��Ë*���� �:�  �� A�>�� t�Aq3��&��!�V�h۾�+ƿ3�ǣ0ڈ/�A�>2�^����-����?� l�A� l�>�� t�?�lq�>�� t�A�lq� �>�� t�0�>�� t�, �C���1�;q�3�Gq�=�Cq
�u�1� ;�3� G�=� CÀ>�� u�����&��u����c� �=�2ۺ&��!s�� �cۍ6U���D&ٌ\�D�D�D  �D
  �D �6U۸O� � �2��0���Y���N���A�;���r����謢�謢��3۸�!< t�<t;�؊и e�!:��t:��t:��u؊�S�e۴@� � �e��!�@�e��![븀� t��׸ e�!R�.� 3ɶ2��Z:��t:��t
�b� � �����b���&�E�6`�� �: r�! rG&�$�<Yu�b� Î�&�>Y t���&�= t&�=/tG������3�2�&�= tQV�^Yt	Q� ��Y�����à%�P� X:%���H� �>/� t� ��[u�>9� u�>%� �W�u�1�D��!�A�&�3ɺ�>D� u��!s!�� t
= u�! ��������&��u��� ��"A�J�*��/��ظ D�!�,��t3�+�$u	�I�
E�tz!�t�D2��� �,��!�� �I��C��>D� u$�>=�t�u�>9� u�Z��]�3�  �H�Ë*�3ɇ3����Fۀ>D� u53��
Ӵ@�!�)�s�D�+�t��,ڀt9�,� u
�>C� u�It����#3҇ѸB�!�PۉRۀ>#� t��@�!r[�T�����0Ӏ>/� tD�*ڃ� ~3�RۋPۋ��t!� B�!3ɴ@�!�>T� tA�T۴@�!�>�!����>�!���/� �����$zP$�E�X$�I�C۠I�
�À>!��u��н!٠���e��4�h�2��-�
�u� �6#ٿ�ᬪ
�u��&ـ�:t�@�I� ,`�VԠ%ي&2�%
�t:�u�>J� t�>�2��4"���
Jۢ%�����Cۀ>E� u$
�u �I�
�t�3���3��
��uO�>3����ހ>%� t��־��>#��Z �% �6E��t�.�D���G�� 2���G��t�G�.ì
�t,<*t <?t��t�? t�C���t�? t݊�C���t�����VR� �E��� �G�Z^�3Ҭ
�t<.u�������t�D� ��Fu\�Ճ��@��W�?��!�u�A�3ɺ�!_s%�� t
= u�@ �����= t#= t= t�cɋظ D�!�>�!�u3�Ft-�Ճ��~����u�v�:8\�u�F ��F N� ��u�F  á=�2��!r>��tK��3���I&�G
�t2����t�G����O���F 
�u:E�t��F �N�n ��>�= t
= t= uU�F  �~��t��F �v�< t@�.8t:�:8\�t�F N2ۆ;�sVQ�΋��e�t	�;�r�Y^�;�r�Y^:\�t���j��dȉ~�F�*.��* �þ&ٿ�Ϡ��� s���	��ο�����ô`
�t�`q� �!�3��>hۢkۢlۊ��W3Ɉ<۬�s�u< t�<	t�l�
�t��ǀt�<��`:�u�π��<u�K
�t�:�u�2<"u�� ���:8u�E��A�>h��j� � �>h��j� �>��u&��u!P���XtP�$�A��:�	X�>h��j� �X�t�� ��{<"u�� ��<.u	�k��j��<?u��<*u4���>�� u��%� ��>k� t��?*&j�r���	��� ��������u!���>�� t��u_�>h��h��j���k� �v �<"u�� ���� tR�� u
:�tG:�tC<:t<t;
�t7�J����t�? ����u�F� �3��&��Eۺ���?ۀ��� ��# s	N_��ð �N_���뒬�� 대���A�j��SV��֋�^;�[W�3ɠ�����uc<t_:�t[
�tW��+�t	�����������t<t:�t
�t:�t�0�����N&� +�VQ��F�^�� �& �t����Y^_�&� ��� @������ u�F��QQV&�G2��t&�}�*t�^Y��3�YÀ< u�^Y��Y+ȸ ���P���t��t<.t<t:�t:�t<"t��@X�.���  .���.�&��.�6���.���.���  .���  .���  .���[].���|<.���>+.���=;�	s���S&�&:s� [�#.�6��SWU���.��� uC��
r<�~	t7�	u.��� u�F	�&.���AtN�.�<=u.���C�
sŬ.�C�N.�6��.� .���&��6��.�</t6.�<"t.���uT&�G2�.9��s.�����CC�&�� �i.��� �`&�G2�@���&�2��tCS&��� [sACC��.��� �4&�G2�@���&�2���@�&�2��tCS&��] [sCC��.��� ]_[.���.���.�6��.���.�����P&�� u.���.�< u� u	.��� �P���� X��X���UQ&�O2��t�o	�s� ����.�.���Y]�&�~  tE��E�.������rJ.�&���P.���+�.��X.�6��.�< u&.�|�:u	.���	 �&�? t&� u.��� �	� ����
P���� X��W&�.�>��&�&�eP.���&�EX<u
&�U&�M�Z<u&�U�P<t�<t�<u&�U�><u.���@&�E&�]�+&�u&�MP&�Gt��	&�Gt��X&�Gt�� _�.��� P&��uPSRW.���	 ����[�_Z[X�0� t.���  �~.�>��	u� t.���  �.�>��	u��n� �t.���  �/.�>��	uW� @t.���  �� .�>��	u@� t.���  ��'.�>��	u&� t.���  �.�>��	u�  t
.���  ��.�>��u.�>�� u.���	 X�PV.�
�t<:u.�| u.� �	��sFF��^X�VR��.���r
�t� .��FF��Z^�<�s<arE<zwA$��=SW�>�΀�t�>��.8tPQR�e�»��� ����!ZYX.�].�ECC,�&�_[�P.��̀.�&���.�<+t
<-u.���F� X�PQRV3�3�S.�
�tB�� r92�������� r,�ڋ������� r����� r��� rՃ� � rF�[� [.���t
���҃��� &�w&�< u����sF&�< t`F.��̀u&;Lr6w&;Tr.&;Lw(r:&;Tw �2&;L|&;T|&;L
|&;T���	��u�.��� �����&�$�.���	 ������^ZYXÜ.���u�Ýp����<0r<9w,0����PSRW&�&�
�u���L<u?G&��	��@�&����@�&�GG&�-�2 s����u�.��� ���&�e��&��.���	 ����p�_Z[X�PURV�.���r<��.���t<=u&�~ uq�.���t<:u
&�~  u\F�\&:F u
�tRFE�&:F uEF.�E&:F u:FE�.���@t&�G  t&�~  t"&� t<:u	&�~  u�< u&�~ :t��.�6���^Z]X�PQRVSV� ^.���  .���  .���  � r.���
�t� rw.���
�t� rj.���
�ub.��΃�t".���
�uP��.���
�uF��.��΃�u���.���.���
�u)��.���
�u���ds��l���s��d[^����"��[^�����.���	 ZYXÍ6��.�<�t�RP� 8���!XZ�QR3�.�
�t<.�>�� t��u<:t0<.t,�<-t&</t"<.t���r� ��
 ���u�r�F뽊���F�����ZY�PQRVSV��.�D^u�.���  .���  .���  .���  .�����o�r].���
�t_�b�rP.���
�tR��S�rA.���
�u6.���u;.�6�̀|�,u0�D�..���  .���.���.�&��.�6�������r_.���
�uW.���
�uO.���t<wCu2�.���t<tr/<w+��.���
�u!��.���
�u��.���
�u��[^������[^�����.���	 .��� ZYX�PV.�F
�u�.�D� <pt<at<mu$N.�D� <pt<at
�.����.���.�D� ^X�PWV.�>��.�
�t�_ u$.���^.� _�?^.� _&� u2.��� �)XV.�
�t�- t�hsGFGF��.���.� G.�>��^_X� t	P������X�SQ��ι	 .:tC��AY[�PR.�
�t8�r,.�|:t&� t.�| u <ar<zw,`�д�����.���	 ZXì�" t�O u.��� t�.���At	N����N���SQ<t)< t%&�}r3�&�]��&�9 t3�&�	C&:t��<Y[�SQ.��� .�&���< t6<	t2<,t1< u�< u� F:��&�}r3�&�M�t� C&:t��< Y[�.���.���u.��� :���.��;�t</u�P.�G����r����X���</u.���@��VS.�>�� u'PQRWU3��޸ c�!���]_ZYXt).�6��.���.�6��.��̓< t:r:Dw��FF���[^���������PQW��3�&��&��&��&���&���� ��� ���_YX�PSQR�O �frA��3ҋ�B&�  &� �u&� ��&�  & ��&� ��&� ��& C��<Zu�� ZY[XøX�!��&���X� �!�3��ӊ��X�!�W��� t�</tN��*�$�<Su� ��&����<Lu� s�N�� NN�_ì<:uJ�*rK���� rA�F �<;t��a t:�Q t4</t0<,u!�r�j� �! �<;t��< t�, t</t� N�ø ��N��P�Ӡ�����&��X�< t<t<
�< t<=t<	�PSW��2��&Ƈ� &8�u&�� _[X�<r��SWV�ӎӀ>��u��
�t��2�� &���
�t�^_[�SW�ӊٷ ��&���_[�  �>Itu��ar	��fw ��WÀ�Ar	��Fw��7À�0r	��9w��0���SQ�3�3�3�3��It
 &���r0
�u&�L��xt��Xu�It FF&�F��r� r��r����N�Y[�P���&Itr��X���&It���3��X�Q��蒱���Y�V�R�!&�� =��t���^�P&� = t=	 t�&� =SCX�QR�����r/��3Ɍ�;�s(���uA&�  <Zt��& @������& ;�s3�I��ZYÃ>Itu	��=��u@�PS�\�� X�!��&��% P� ��[
ظX�![X��Ӡ�<�u���
�t���PQ�r9������&���) <�t 3�A��s���� r����� 
�u�
YX��Ӡ��SV�Ӡ�2仟��Ë�^[�SV��2仟��Ë�^[���&���R�ӊ����t���Z�P�| r!��t�* u�, &�  <Zt��& @����X�P�Ӡ�
�X�&�  �&�  &� HI&�
 DD&� EN&�   �P&�   �  &� &�
 &� &� X�PQR2������3�;�t��uA&�  <Zt��& @�����ZYX�SQ���r93�3����t'�t�u&; ��&� &�  <Zt��& @���ԎË��u�Y[�P2����ӊ��
�X�SQ�،�&� �� ;�wE&�  &� &� &�  M�@����+�H&�  &�   &� �  &� &�
 &� &� ���Y[�SR����t+���>�r$P���M�[�t;�v��������t	�t�r���	���V�u3Ҋ��X��t����Z[�P���r��� u��&�  <Zt��& @����X�P&� = u"&� =FRu&�
 =OZu&� =ENu&� =  X�&�  &� FR&�
 OZ&� EN&�   �PQR�o�2���Z���3��k�uA;�t���u��&�  <Zt��& @����ZYX�PS�
��
 ����[X�PS�R�!&�G���&�  <Zt��& C�����=��[X�2��ӊ��X�!2��ӊ��X�!�� r� � r���Z��ȋ6����ì���u�N�����s= u����ú��= t������ ÿҹ  �<*t(<?t$<t:�t
�t< t
�t�A��2���tN�ú��ú��ÿ� 2��ɬ���
�t<u�&�� ��q��s�s�á��H� ���ӊ����IPQ�ȿ�ۋ��������- YX���_��t= |�ú��� ����� �� ������� ���� PSQWVR���  ��P���2�X�a���WQQ�޹ ��Gt
�G  �G  Y��YP�>q�t����s�3���X_����Q� u	�Gu�O����Y�ށ��u��׉W��Ίr�6q��r� �q��%s���3��s�Z^_Y[X�>�� u��>��u����ێ�&�C�t�#кӃ��q��s�s��1�PSRW3Ɏ�3��.� �/�n��>l���/�r��>p��.��/�z��>x��.��/����>�������G�ǣh��j����������ǌ~��|��  ���ǉ�����������u�.��/����>�����
���$���  ���
 _Z[XÃ�
���Q� Y�PWU�'r��3�]_Xø����SQUPWR�������u�) ��Xr	Z�� _X�Z_���r]Y[�������  �PSR������u�z ��( s�Y�  �!2�����t;�t�' � �����Z[X�3��H.�>� tV��.�>��Q�Y��.�>��^�"�@�׃�u�!��!r;�tW�&�=_�u���.�>� tV��.�>���.�>�^���u	�&��!���&��!G���À�t�ƀu�>��� �$�Ï��3ۓ��6����6����	v��7���0RA�u�t&��uP�D$<Xw�6��A�
��t��t�3��3�3��6��É.���u� 3�&�<%t�GBIGB������W+���_s� ����&�E<%t�,02�;��w��u�MV��t����UWQ3Ƀ>�� u;�Du�|�b�(�Dt�Dt�Du�|�e��Du����k�d ��2 Y_]^�>�� |G���I�g�r�tM���+Ź ����  ���  �3ҡ�����
 ���X����C��@u�� ��u�
����CC� �3ۀ| uǇ�� -CCƇ�� C� ]3�3҉���D
;�v+����D�t�D����C��@u�r Ju�| t9Ls�L�  �#�Du�Dt&�G�X����C��@u�< Iu��D�u�t�D����C��@u� Ju��Du�Du�t���Ju�� U�QW��3ۍ>���
�r_Y�����]�D0u&�PA�&�
�tGA��+�U�]3�3���� 3��D u&��DuK��tC$���
 �<�Du&��Du-�ĀtC�����
 �&�&�U�Du�ƀtC�����
 �Du���
 �H��t3Ҳ-RU�]���
 3�3��>��ruP�D�^ �6��A�D�S �6��A�9 �2�4 �C �6��A3��>��t�D�/ �6��A�D��D� �6��A�D� UËD�Du=c v�c Ï�������I;��u�0 PAA�6���]���
 �Dt�>�� u�D<|<~�aPA��pPA3�3��D t�D�H �6��A�D u�Dt�D�1 �6��A�D�& �6��A�D�Dt�>�� u<|,< u��)�UÏ�������I;��u�0 PAA�6���VS3�3����  �� u�m��u�( ���t� = r=' w� ��h��<�Ã��u.��u��9=��t4��u�/ �u'�>�� u!������� 3��릃� t�B ��㼀�t��[^�RUQWP� �/<�XuP�ظ�/XrWP���2����IX_���_Y]ZÃ�u�>���t=��Pu������X�3ɀ�u&85u&�M���s��&;tIt����&}2�&�G���  ����� � � � �  �   � � � � � � � � � � � � � :�  �	 	  � �  �
 
  � 	�  �   � 	�  �    �  �  0� � ��  �   � ��  �     ��  �           ��          4
 
  	 
              �       �  �     �   �    �   �    ��     ��  �  0 ��  �  0     ��      ��                �         �   !         "         # $ % & ' ��       ( 3�     ) ��  �   A * ��        + , - . 0 1 2 3 ��          4
   4     �   4     �
 
  5     �   4 ��      4 ��  �   6 7 <�  �   � <�  �    @�  �  08 9 : ; < ��     < ��     = ��  �
 
  > x�  �   � x�  �    |�  �  0? 	�  �    ��  �   � 	�  �    �  �  0 ��  �   @ B �      C D E F G H I J K M Q �  �    �     R �  �    �     S T U V W FILE CMDLINE=PATH=PROMPT=COMSPEC=DIRCMD=    ()  <=>  P  xyz{|}~  �  ��  ���  ���������  �  �       ,  @AB  TUV  hi  |  �  �  �  ��  �  �  	        0  DEFGHIJ  XYZ[  l  �������  [2JB1DVE1G1H1L1N%1P/1Q
1TbKV�0_=$1 NOT(
ERRORLEVELEXIST ������4y��,��,�,��,���-��W���+�]J���J��C0�A/�b;�b;��;ǆ�;ǆ�<��<��Tq��T	��7�p7ӆ�1ˆ �5Æ14��zT��6%�7)��-�G3��7��G� �3��n5Q�0yU�0yU�Uu�DIRCALLCHCPRENAMERENERASEDELTYPEREMCOPYPAUSEDATETIMEVERVOLCDCHDIRMDMKDIRRDRMDIRBREAKVERIFYSETPROMPTPATHEXITCTTYECHOLOCKUNLOCKGOTOSHIFTIFFORCLSTRUENAMELOADHIGHLHLFNFOR .COM.EXE.BAT?VBAPWY-WIN?VBA*PWRSO*Y-*RHSvDANEDSGAC         �ሉ ONOFF �    @    ��  ��     �ሉ          !    !   !��     /A /O /C /-A /-O /S /-S /B /-B /W /-W /P /-P /L /-L /V /-V /-C /-Z /Z /-4 /4 ���� ������������݉���ډ��׉�!�       @  TEMP= COPYCMD=            ����        ����        ����        ��������        
      
   , . - : $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               MS-DOS Version 7 (C)Copyright 1981-1995 Microsoft Corp Licensed Material - Property of Microsoft All rights reserved                                                                                                                                                                                                                                                                                                     ��                                        �    �    []|<>+=;"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            4.10.2222                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    �U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U�U                                                                                      ��    �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            A:\                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             ���� � 