#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <Crypt.au3>
#include <String.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

Global $sSalt = @ComputerName & @DocumentsCommonDir
Global $requesteddirectory = "\IPA Files\"
Global $appleloginpass
Global $2FAP1, $2FAP2, $2FAP3, $2FAP4, $2FAP5, $2FAP6
Global $aSelected[0]

; Check  to See is  value is already entered, if not, then set defaults

Local $hold = IniRead(@ScriptDir & "\settings.txt", "applepass", "01", "NFound")
If $hold = "NFound" Then
	$appleloginpass = "Apple Login Password"
Else
	$appleloginpass = DecMe("applepass")
EndIf

Local $hold = IniRead(@ScriptDir & "\settings.txt", "2fa1", "01", "NFound")
If $hold = "NFound" Then
	$2FAP1 = "2FA Password for IPA1"
	EncMe("2fa1", $2FAP1)
Else
	$2FAP1 = DecMe("2fa1")
EndIf

Local $hold = IniRead(@ScriptDir & "\settings.txt", "2fa2", "01", "NFound")
If $hold = "NFound" Then
	$2FAP2 = "2FA Password for IPA2"
	EncMe("2fa2", $2FAP2)
Else
	$2FAP2 = DecMe("2fa2")
EndIf

Local $hold = IniRead(@ScriptDir & "\settings.txt", "2fa3", "01", "NFound")
If $hold = "NFound" Then
	$2FAP3 = "2FA Password for IPA3"
	EncMe("2fa3", $2FAP3)
Else
	$2FAP3 = DecMe("2fa3")
EndIf

Local $hold = IniRead(@ScriptDir & "\settings.txt", "2fa4", "01", "NFound")
If $hold = "NFound" Then
	$2FAP4 = "2FA Password for IPA4"
	EncMe("2fa4", $2FAP4)
Else
	$2FAP4 = DecMe("2fa4")
EndIf

Local $hold = IniRead(@ScriptDir & "\settings.txt", "2fa5", "01", "NFound")
If $hold = "NFound" Then
	$2FAP5 = "2FA Password for IPA5"
	EncMe("2fa5", $2FAP5)
Else
	$2FAP5 = DecMe("2fa5")
EndIf

Local $hold = IniRead(@ScriptDir & "\settings.txt", "2fa6", "01", "NFound")
If $hold = "NFound" Then
	$2FAP6 = "2FA Password for IPA6"
	EncMe("2fa6", $2FAP6)
Else
	$2FAP6 = DecMe("2fa6")
EndIf


;~ username still needed
$username = IniRead(@ScriptDir & "\settings.txt", "username", "01", "NotFound")

If $username = "NotFound" Then
	Local $sAppleIDEncryptMe = InputBox("Apple ID not found in settings file!", "Please enter your Apple ID: ", "", "")
	EncMe("username", $sAppleIDEncryptMe)
EndIf

Func EncMe($whattocallit, $vartoenc)
	Local $sEncrypted = StringEncrypt(True, $vartoenc, $sSalt)
	IniWrite(@ScriptDir & "\settings.txt", $whattocallit, "01", $sEncrypted)
EndFunc   ;==>EncMe

Func DecMe($vartodec)
	Local $DecNeeded = IniRead(@ScriptDir & "\settings.txt", $vartodec, "01", "NotFound")
	Return (StringEncrypt(False, $DecNeeded, $sSalt))
EndFunc   ;==>DecMe

Global $sDecryptedUsername = DecMe("username")
Global $draggedfile, $locationcheck, $revoke = 0
Global $impactorfolder = @ScriptDir & "\Impactor\"
Global $impactorlocation = @ScriptDir & "\Impactor.exe"


;Check for Existance Of Impactor
$locationcheck = FileExists($impactorlocation)
If $locationcheck = 0 Then
	MsgBox(0, "Cydia Impactor not found! ", "Put this exe in the same folder as Cydia Impactor! Location Check Value: " & $locationcheck)
	Exit
EndIf




; Create a GUI
$ImpactorLoader = GUICreate("CydiaLoader", 827, 481, -1, -1)
$Label1 = GUICtrlCreateLabel("IPA FILES IN CURRENT FOLDER AVAILABLE FOR INSTALLATION: ", 368, 8, 340, 17)


;Check for files in the Directory and error out if not found
Global $FileList = _FileListToArray(@ScriptDir & $requesteddirectory, '*.ipa', 1)
_ArrayDelete($FileList, 0)
Global $FileListLocal = _FileListToArray(@ScriptDir, '*.ipa', 1)
_ArrayDelete($FileListLocal, 0)

$cRemote = IsArray($FileList)
$cLocal = IsArray($FileListLocal)
;~ MsgBox(0,0, "remote: " & $cRemote & " and Local: " & $cLocal)

If $cRemote = 1 And $cLocal = 1 Then
	_ArrayAdd($FileList, $FileListLocal)
;~ 	_ArrayDisplay($FileList)
EndIf

If $cRemote = 0 And $cLocal = 1 Then
	$FileList = $FileListLocal
;~ 	_ArrayDisplay($FileList)
EndIf

If $cRemote = 1 And $cLocal = 0 Then
;~ 	_ArrayDisplay($FileList) ; Basically do nothing right?
EndIf

If $cRemote = 0 And $cLocal = 0 Then
	MsgBox(0, "Error!", "No IPA's found in script directory or in \IPA Files\ folder!")
EndIf

;~ _ArrayDisplay($FileList)
If UBound($FileList) > 6 Then
	MsgBox(0, 0, "Only up to 6 IPA's supported, rest will be ignored!")
	$ipname1 = $FileList[0]
	$ipname2 = $FileList[1]
	$ipname3 = $FileList[2]
	$ipname4 = $FileList[3]
	$ipname5 = $FileList[4]
	$ipname6 = $FileList[5]
EndIf

If UBound($FileList) = 6 Then
	$ipname1 = $FileList[0]
	$ipname2 = $FileList[1]
	$ipname3 = $FileList[2]
	$ipname4 = $FileList[3]
	$ipname5 = $FileList[4]
	$ipname6 = $FileList[5]
EndIf

If UBound($FileList) = 5 Then
	$ipname1 = $FileList[0]
	$ipname2 = $FileList[1]
	$ipname3 = $FileList[2]
	$ipname4 = $FileList[3]
	$ipname5 = $FileList[4]
	$ipname6 = "*"
EndIf
If UBound($FileList) = 4 Then
	$ipname1 = $FileList[0]
	$ipname2 = $FileList[1]
	$ipname3 = $FileList[2]
	$ipname4 = $FileList[3]
	$ipname5 = "*"
	$ipname6 = "*"
EndIf
If UBound($FileList) = 3 Then
	$ipname1 = $FileList[0]
	$ipname2 = $FileList[1]
	$ipname3 = $FileList[2]
	$ipname4 = "*"
	$ipname5 = "*"
	$ipname6 = "*"
EndIf
If UBound($FileList) = 2 Then
	$ipname1 = $FileList[0]
	$ipname2 = $FileList[1]
	$ipname3 = "*"
	$ipname4 = "*"
	$ipname5 = "*"
	$ipname6 = "*"
EndIf
If UBound($FileList) = 1 Then
	$ipname1 = $FileList[0]
	$ipname2 = "*"
	$ipname3 = "*"
	$ipname4 = "*"
	$ipname5 = "*"
	$ipname6 = "*"
EndIf
If UBound($FileList) = 0 Then
	MsgBox(0, 0, "NO .IPA files found!")
EndIf




#Region ### START Koda GUI section ### Form=C:\Users\GodMode\Desktop\Impactor_0.9.51\ImpactorLoader2.kxf
$ImpactorLoader = GUICreate("CydiaLoader", 485, 375, -1, -1)
$Label = GUICtrlCreateLabel("IPA FILES IN CURRENT FOLDER AVAILABLE FOR INSTALLATION:", 8, 8, 476, 25)
GUICtrlSetFont(-1, 12, 400, 0, "Times New Roman")
$LaunchAndInstallTheChosenIPA = GUICtrlCreateButton("Launch Cydia Impactor And Install the Checked IPAs", 200, 328, 150, 41, $BS_MULTILINE)
$LaunchImp = GUICtrlCreateButton("Start Cydia Impactor For Me", 8, 328, 185, 41)
$Close = GUICtrlCreateButton("Close - Control S to force quit", 350, 328, 130, 41, $BS_MULTILINE)
$2FAPass1 = GUICtrlCreateInput($2FAP1, 8, 50, 473, 21)
$2FAPass2 = GUICtrlCreateInput($2FAP2, 8, 100, 473, 21)
$2FAPass3 = GUICtrlCreateInput($2FAP3, 8, 150, 473, 21)
$2FAPass4 = GUICtrlCreateInput($2FAP4, 8, 200, 473, 21)
$2FAPass5 = GUICtrlCreateInput($2FAP5, 8, 250, 473, 21)
$2FAPass6 = GUICtrlCreateInput($2FAP6, 8, 300, 473, 21)
;~ $iTunesPass = GUICtrlCreateInput($appleloginpass, 456, 32, 169, 21)
$Label1 = GUICtrlCreateLabel($ipname1, 8, 30, 444, 17, $SS_CENTER)
$Label2 = GUICtrlCreateLabel($ipname2, 8, 80, 444, 17, $SS_CENTER)
$Label3 = GUICtrlCreateLabel($ipname3, 8, 130, 444, 17, $SS_CENTER)
$Label4 = GUICtrlCreateLabel($ipname4, 8, 180, 444, 17, $SS_CENTER)
$Label5 = GUICtrlCreateLabel($ipname5, 8, 230, 444, 17, $SS_CENTER)
$Label6 = GUICtrlCreateLabel($ipname6, 8, 280, 444, 17, $SS_CENTER)
;~ $IPAName7 = GUICtrlCreateLabel("(OPTIONAL - Only for non - 2FA)", 272, 32, 169, 21, $ES_RIGHT)
$ButtonSaveApplePass = GUICtrlCreateButton("Save Passwords", 608, 0, 89, 25, BitOR($BS_CENTER, $BS_MULTILINE))
$Checkbox1 = GUICtrlCreateCheckbox("", 465, 30, 17, 17)
$Checkbox2 = GUICtrlCreateCheckbox("", 465, 80, 17, 17)
$Checkbox3 = GUICtrlCreateCheckbox("", 465, 130, 17, 17)
$Checkbox4 = GUICtrlCreateCheckbox("", 465, 180, 17, 17)
$Checkbox5 = GUICtrlCreateCheckbox("", 465, 230, 17, 17)
$Checkbox6 = GUICtrlCreateCheckbox("", 465, 280, 17, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUISetState()
;_Update_ListBox()
$hListBox = 0

While 1

	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			SaveEverything()
			Exit

		Case $Close
			SaveEverything()
			Exit

		Case $ButtonSaveApplePass
;~ 			Local $savetofile = GUICtrlRead($iTunesPass)
;~ 			EncMe("applepass", $savetofile)
			Local $savetofile = GUICtrlRead($2FAPass1)
			EncMe("2fa1", $savetofile)
			Local $savetofile = GUICtrlRead($2FAPass2)
			EncMe("2fa2", $savetofile)
			Local $savetofile = GUICtrlRead($2FAPass3)
			EncMe("2fa3", $savetofile)
			Local $savetofile = GUICtrlRead($2FAPass4)
			EncMe("2fa4", $savetofile)
			Local $savetofile = GUICtrlRead($2FAPass5)
			EncMe("2fa5", $savetofile)
			Local $savetofile = GUICtrlRead($2FAPass6)
			EncMe("2fa6", $savetofile)

		Case $LaunchAndInstallTheChosenIPA

			If GUICtrlRead($Checkbox1) = 1 Then
				If $ipname1 <> "*" Then
					If FileExists(@ScriptDir & $requesteddirectory & $ipname1) Then
						LoadIPA(@ScriptDir & $requesteddirectory & $ipname1, $2FAP1)
					EndIf

					If FileExists(@ScriptDir & "\" & $ipname1) Then
						LoadIPA(@ScriptDir & "\" & $ipname1, $2FAP1)
					EndIf
				EndIf

			EndIf

			If GUICtrlRead($Checkbox2) = 1 Then
				If $ipname2 <> "*" Then
					If FileExists(@ScriptDir & $requesteddirectory & $ipname2) Then
						LoadIPA(@ScriptDir & $requesteddirectory & $ipname2, $2FAP2)
					EndIf

					If FileExists(@ScriptDir & "\" & $ipname2) Then
						LoadIPA(@ScriptDir & "\" & $ipname2, $2FAP2)
					EndIf
				EndIf
			EndIf


			If GUICtrlRead($Checkbox3) = 1 Then
				If $ipname3 <> "*" Then
					If FileExists(@ScriptDir & $requesteddirectory & $ipname3) Then
						LoadIPA(@ScriptDir & $requesteddirectory & $ipname3, $2FAP3)
					EndIf

					If FileExists(@ScriptDir & "\" & $ipname3) Then
						LoadIPA(@ScriptDir & "\" & $ipname3, $2FAP3)
					EndIf
				EndIf
			EndIf


			If GUICtrlRead($Checkbox4) = 1 Then
				If $ipname4 <> "*" Then
					If FileExists(@ScriptDir & $requesteddirectory & $ipname4) Then
						LoadIPA(@ScriptDir & $requesteddirectory & $ipname4, $2FAP4)
					EndIf

					If FileExists(@ScriptDir & "\" & $ipname4) Then
						LoadIPA(@ScriptDir & "\" & $ipname4, $2FAP4)
					EndIf
				EndIf
			EndIf


			If GUICtrlRead($Checkbox5) = 1 Then
				If $ipname5 <> "*" Then
					If FileExists(@ScriptDir & $requesteddirectory & $ipname5) Then
						LoadIPA(@ScriptDir & $requesteddirectory & $ipname5, $2FAP5)
					EndIf

					If FileExists(@ScriptDir & "\" & $ipname5) Then
						LoadIPA(@ScriptDir & "\" & $ipname5, $2FAP5)
					EndIf
				EndIf
			EndIf

			If GUICtrlRead($Checkbox6) = 1 Then
				If $ipname6 <> "*" Then
					If FileExists(@ScriptDir & $requesteddirectory & $ipname6) Then
						LoadIPA(@ScriptDir & $requesteddirectory & $ipname6, $2FAP6)
					EndIf

					If FileExists(@ScriptDir & "\" & $ipname6) Then
						LoadIPA(@ScriptDir & "\" & $ipname6, $2FAP6)
					EndIf
				EndIf
			EndIf

			TrayTip("YAY!", "Your IPA has been loaded!", 3)
			Sleep(2000)

			MsgBox(0, "Batch loading complete", "Success!")
			SaveEverything()
			Exit


		Case $LaunchImp
			ManLaunch()
	EndSwitch

WEnd


Func ManLaunch()
	ShellExecute(@ScriptDir & "\Impactor.exe")
EndFunc   ;==>ManLaunch


Func LoadIPA($Selectedwhat, $ipapassword)
	Opt("WinTitleMatchMode", 4)
	Local $exists = WinExists("[TITLE:Cydia Impactor; CLASS:wxWindowNR]")
	If $exists = 0 Then ShellExecute(@ScriptDir & "\Impactor.exe")
	Sleep(500)
	WinWait("[TITLE:Cydia Impactor;CLASS:wxWindowNR]")
	WinActivate("[TITLE:Cydia Impactor; CLASS:wxWindowNR]")
	Sleep(800)
	WinMenuSelectItem("Cydia Impactor", "", "&Device", "&Install Package...")
	Sleep(200)
	ControlSetText("Select package.", "", "Edit1", $Selectedwhat)
	Sleep(200)
	ControlClick("Select package.", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(250)
	ControlSetText("Apple ID Username", "", "Edit1", $sDecryptedUsername)
	Sleep(100)
	ControlClick("Apple ID Username", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	ControlSetText("Apple ID Password", "", "Edit1", $ipapassword)
	Sleep(100)
	ControlClick("Apple ID Password", "", "Button1", "primary", 1)
	Finishedyet()
EndFunc   ;==>LoadIPA

Func Finishedyet()
	Local $flagforfinished = "0", $frozen = "0", $frozen2 = "0"

	Do
		Sleep(1000)
		$finished = ControlGetText("Cydia Impactor", "", "Static1")
		If $finished = "Complete" Then $flagforfinished = 1

		If $finished = "VerifyingApplication" Then
			Do
				$finished = ControlGetText("Cydia Impactor", "", "Static1")
				If $finished <> "VerifyingApplication" Then ExitLoop
				Sleep(1000)
				$frozen2 += 1
				ConsoleWrite("frozen2 is: " & $frozen2 & @CRLF)
			Until $frozen2 = 25
		EndIf

		If $finished = "GeneratingApplicationMap" Then
			Do
				$finished = ControlGetText("Cydia Impactor", "", "Static1")
				If $finished <> "GeneratingApplicationMap" Then ExitLoop
				Sleep(1000)
				$frozen += 1
				ConsoleWrite("frozen is: " & $frozen & @CRLF)
			Until $frozen = 25
		EndIf

		If $frozen = 25 Or $frozen2 = 25 Then
			$flagforfinished = 1
		EndIf

	Until $flagforfinished = 1 ; Check for finished flag

	$flagforfinished = 0
	$frozen = 0
	$frozen2 = 0

EndFunc   ;==>Finishedyet

Func SaveEverything()
;~ 	Local $savetofile = GUICtrlRead($iTunesPass)
;~ 	EncMe("applepass", $savetofile)
	Local $savetofile = GUICtrlRead($2FAPass1)
	EncMe("2fa1", $savetofile)
	Local $savetofile = GUICtrlRead($2FAPass2)
	EncMe("2fa2", $savetofile)
	Local $savetofile = GUICtrlRead($2FAPass3)
	EncMe("2fa3", $savetofile)
	Local $savetofile = GUICtrlRead($2FAPass4)
	EncMe("2fa4", $savetofile)
	Local $savetofile = GUICtrlRead($2FAPass5)
	EncMe("2fa5", $savetofile)
	Local $savetofile = GUICtrlRead($2FAPass6)
	EncMe("2fa6", $savetofile)
EndFunc   ;==>SaveEverything

Func StringEncrypt($bEncrypt, $sData, $sPassword)
	_Crypt_Startup() ; Start the Crypt library.
	Local $sReturn = ''
	If $bEncrypt Then ; If the flag is set to True then encrypt, otherwise decrypt.
		$sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_RC4)
	Else
		$sReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_RC4))
	EndIf
	_Crypt_Shutdown() ; Shutdown the Crypt library.
	Return $sReturn
EndFunc   ;==>StringEncrypt


