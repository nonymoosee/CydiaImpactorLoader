This program is designed to make Cydia Impactor a little easier and allow for you to save your password to make things quicker. Just to be clear. My program is a joke compared to Cydia Impactor and it's not mean as an attack on Saurik or anything like that, just made for lazy people like myself, I respect the work of real programmers like the tweak dev's and Saurik immensely. This is written in Autoit and the source code is available on github, PLEASE SEE the .au3 file for the SOURCE! 

I ENCOURAGE YOU TO Compile the Script yourself! go to https://www.autoitscript.com/ and download their program then just right click the script to compile it! The code is VERY simple so it’s obvious that it doesn’t even connect to the internet.

Also change the $Salt value by changing Global $sSalt = @ComputerName & @DocumentsCommonDir to Global $sSalt = "Whateveryouwant" if you want to have your own internal value for the CryptKey in the compiled exe!


To run...

1) Download Loaderv2.2withGUI.exe 

2) Drop the Loaderv2.2withGUI.exe into your cydia impactor folder

3) Launch Loaderv2.2withGUI.exe, if it's your first time you will be prompted to enter your username/password which will be encrypted and written to a .ini file!

4) Put your IPA's into the Cydia Impactor folder and just launch the program and choose whatever option you want to use, there will be a list of all your IPA's listed in a drop down menu OR drag the whatever .ipa file you want to install onto Loaderv2.2withGUI.exe, not impactor.exe and it will install that IPA without ever launching the GUI.

Preview of new GUI: https://i.imgur.com/9e4CtmM.jpg

Edit: Version 2.2 released which saves encrypted username and password.

Essentially what the program does is: 1) Asked for username and password or pulls from .ini file if xisting 2) Launch Impactor if it's not open already 3) Click the the "Install Package" option from CydiaImpactor menus 4) Type the IPA name that the user chose or dragged onto exe into CydiaImpactor then hit ok 5) Type username into CydiaImpactor then hit ok 6) Type password into CydiaImpactor then hit ok
