This program is designed to make Cydia Impactor a little easier and allow for you to save your password to make things quicker. Just to be clear. My program is a joke compared to Cydia Impactor and it's not mean as an attack on Saurik or anything like that, just made for lazy people like myself, I respect the work of real programmers like the tweak dev's and Saurik immensely. This is written in Autoit and the source code is available on github, PLEASE SEE the .au3 file for the SOURCE!

To run...

1) Download Loaderv2.4.exe from

https://github.com/nonymoosee/CydiaImpactorLoader

2) Drop the Loaderv2.4.exe into your cydia impactor folder

3) Launch Loaderv2.4.exe, if it's your first time you will be prompted to enter your username/password which will be encrypted and written to a .ini file!

4) Put your IPA's into the Cydia Impactor folder OR create a folder Called "IPA Files" inside the Cydia folder and put your IPA's in there and just launch the program and choose whatever option you want to use. There will be a list of all your IPA's listed in a select box, shift or control click whatever IPA's you want to install then basically... leave it alone. It will check every couple of seconds to see if CydiaImpactor is finished, once it is, it will install the next IPA :) If CydiaImpactor gets stuck on 'VerifyingApplication', then a timer is triggered for 10seconds, then another 10 seconds, and then the next IPA will be installed. 

NOTE: If Loader ever gets stuck/freezes: Right click on the tray icon on the bottom right and stop its execution.

5) Also if you have a previous version installed, please delete the plaintext settingsforloader.ini file as there's no reason for it to exist anymore.

I ENCOURAGE YOU TO Compile the Script yourself! go to https://www.autoitscript.com/ and download their program then just right click the script to compile it! The code is VERY simple so it’s obvious that it doesn’t even connect to the internet.

Also change the $Salt value by changing Global $sSalt = @ComputerName & @DocumentsCommonDir to Global $sSalt = "Whateveryouwant" if you want to have your own internal value for the CryptKey in the compiled exe!

Sidenote: To make the 'Salt' value more secure, it's based off of your ComputerName and TheDocumentsCommonDir, this means that the software is NOT mobile, and cannot be 'tossed' onto a USB. If you want to do that you need to compile it yourself and define the $sSalt value to something static aka "123456789whatever"


ChangeLog: 
1) Selection issues fixed - Now the right IPA's should always be installed. 
2) Combined different branches of the software 
3) You can drop your IPA's in the Cydia folder OR the /IPA Files folder, the software should find either location and install, be caseful you name the folder correctly. 
4) Other minor fixes.
5) Non-accessible Variable Error replaced with friendlier error that no IPA's found. 

 Version 2.3 - Batch Loading of IPA's! Waits for completed message from CydiaImpactor before loading the next IPA

Version 2.2 - Release saves encrypted username and password.

Essentially what the program does is:

1) Asked for username and password or pulls from .ini file if existing

2) Launch Impactor if it's not open already

3) Click the the "Install Package" option from CydiaImpactor menus

4) Type the IPA name that the user chose or dragged onto exe into CydiaImpactor then hit ok

5) Type username into CydiaImpactor then hit ok

6) Type password into CydiaImpactor then hit ok
