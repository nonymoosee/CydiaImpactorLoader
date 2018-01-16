#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>
#include <Crypt.au3>
#include <String.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;~ #include "Toast.au3"
;~ Local $sMsg, $hProgress, $aRet[2]



Global $sSalt = @ComputerName & @DocumentsCommonDir
Global $requesteddirectory = "\IPA Files\"

$username = IniRead(@ScriptDir & "\settings.txt", "username", "01", "NotFound")
$password = IniRead(@ScriptDir & "\settings.txt", "userpass", "01", "NotFound")

If $username = "NotFound" Then
	Local $sAppleIDEncryptMe = InputBox("Apple ID not found in settings file!", "Please enter your Apple ID: ", "", "")
	Local $sEncrypted = StringEncrypt(True, $sAppleIDEncryptMe, $sSalt)
	IniWrite(@ScriptDir & "\settings.txt", "username", "01", $sEncrypted)
	$username = IniRead(@ScriptDir & "\settings.txt", "username", "01", "NotFound")
EndIf


If $password = "NotFound" Then
	Local $sApplePasswordEncryptMe = InputBox("Apple Password not found in settings file!", "Please enter your Apple Password: ", "", "*")
	Local $sEncrypted = StringEncrypt(True, $sApplePasswordEncryptMe, $sSalt)
	IniWrite(@ScriptDir & "\settings.txt", "userpass", "01", $sEncrypted)
	$password = IniRead(@ScriptDir & "\settings.txt", "userpass", "01", "NotFound")
EndIf

Global $sDecryptedUsername = StringEncrypt(False, $username, $sSalt)
Global $sDecryptedPassword = StringEncrypt(False, $password, $sSalt)


Global $draggedfile, $locationcheck, $impactorfolder = @ScriptDir & "\Impactor\", $revoke = 0, $impactorlocation = @ScriptDir & "\Impactor.exe"

If $CmdLine[0] <> 0 Then $draggedfile = $CmdLine[1]
$locationcheck = FileExists($impactorlocation)
If $locationcheck = 0 Then
	MsgBox(0, "Cydia Impactor not found! ", "Put this exe in the same folder as Cydia Impactor! Location Check Value: " & $locationcheck)
	Exit
EndIf

;If you dragged a file then we just install without a GUI
If $CmdLine[0] <> 0 Then
	Opt("WinTitleMatchMode", 4)
	Local $exists = WinExists("[TITLE:Cydia Impactor; CLASS:wxWindowNR]")
	If $exists = 0 Then ShellExecute(@ScriptDir & "\Impactor.exe")
	Sleep(500)
	WinWait("[TITLE:Cydia Impactor;CLASS:wxWindowNR]")
	WinActivate("[TITLE:Cydia Impactor; CLASS:wxWindowNR]")
	Sleep(800)
	WinMenuSelectItem("Cydia Impactor", "", "&Device", "&Install Package...")
	Sleep(100)
	ControlSetText("Select package.", "", "Edit1", $draggedfile)
	ControlClick("Select package.", "", "Button1", "primary", 1)
	Sleep(100)
	Upass()
	Exit
EndIf


; Create a GUI
$ImpactorLoader = GUICreate("CydiaLoader", 827, 481, -1, -1)
$Label1 = GUICtrlCreateLabel("IPA FILES IN CURRENT FOLDER AVAILABLE FOR INSTALLATION: ", 368, 8, 340, 17)

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

$hListBox = _GUICtrlListBox_Create($ImpactorLoader, "", 357, 70, 450, 400, $LBS_EXTENDEDSEL)
$UPass = GUICtrlCreateButton("Type Username/Password (will wait for username window)", 16, 10, 289, 49)
$RevokeCerts = GUICtrlCreateButton("Launch Cydia Impactor and Revoke My Certificates", 16, 88, 289, 57)
$LaunchAndInstallTheChosenIPA = GUICtrlCreateButton("Launch Cydia Impactor And Install the Chosen IPA(s) for me", 16, 384, 289, 57)
$LaunchImp = GUICtrlCreateButton("Start Cydia Impactor For Me", 16, 288, 289, 57)
$Close = GUICtrlCreateButton("Close", 16, 184, 289, 57)

GUISetState()
_Update_ListBox()


While 1

	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Close
			Exit

		Case $UPass
			Upass()

		Case $RevokeCerts
			RevokeCerts()

		Case $LaunchAndInstallTheChosenIPA

			$aSelected = _GUICtrlListBox_GetSelItems($hListBox)
			For $i = 1 To $aSelected[0]
				ConsoleWrite("Item " & $aSelected[$i] & " selected" & @CRLF)

				If FileExists(@ScriptDir & $requesteddirectory & $FileList[$aSelected[$i]]) Then
;~ 					MsgBox(0, 0, @ScriptDir & $requesteddirectory & $FileList[$aSelected[$i]])
					LoadIPA(@ScriptDir & $requesteddirectory & $FileList[$aSelected[$i]])
				EndIf

				If FileExists(@ScriptDir & "\" & $FileList[$aSelected[$i]]) Then
;~ 					MsgBox(0, 0, @ScriptDir & "\" & $FileList[$aSelected[$i]])
					LoadIPA(@ScriptDir & "\" & $FileList[$aSelected[$i]])
				EndIf


				Finishedyet()
				TrayTip("YAY!", "Your IPA " & $FileList[$aSelected[$i]] & " has been loaded!", 3)
				Sleep(2000)
			Next
			MsgBox(0, "Batch loading complete", "Success!")
			Exit

		Case $LaunchImp
			ManLaunch()

	EndSwitch

	; Set item to Selected when given focus by a mouse click - if not already done
	$iIndex = _GUICtrlListBox_GetCaretIndex($hListBox)
	If _GUICtrlListBox_GetSel($hListBox, $iIndex) = False Then _GUICtrlListBox_SetSel($hListBox, $iIndex)

WEnd

Func _Update_ListBox()

	_GUICtrlListBox_BeginUpdate($hListBox)
	_GUICtrlListBox_ResetContent($hListBox)
	_GUICtrlListBox_InitStorage($hListBox, 100, 4096)
	For $i = 0 To UBound($FileList) - 1
		_GUICtrlListBox_AddString($hListBox, $FileList[$i])
	Next
	_GUICtrlListBox_EndUpdate($hListBox)

EndFunc   ;==>_Update_ListBox


Func ManLaunch()
	ShellExecute(@ScriptDir & "\Impactor.exe")
EndFunc   ;==>ManLaunch


Func LoadIPA($Selectedwhat)
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
	Upass()
EndFunc   ;==>LoadIPA



Func RevokeCerts() ; needs to be updated
	Opt("WinTitleMatchMode", 4)
	Local $exists = WinExists("[TITLE:Cydia Impactor; CLASS:wxWindowNR]")
	If $exists = 0 Then ShellExecute(@ScriptDir & "\Impactor.exe")
	Sleep(500)
	WinWait("[TITLE:Cydia Impactor;CLASS:wxWindowNR]")
	WinActivate("[TITLE:Cydia Impactor; CLASS:wxWindowNR]")
	WinMenuSelectItem("Cydia Impactor", "", "&Xcode", "&Revoke Certificates")
	Sleep(100)
	Upass()
EndFunc   ;==>RevokeCerts


Func Upass()
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(250)
	ControlSetText("Apple ID Username", "", "Edit1", $sDecryptedUsername)
	Sleep(100)
	ControlClick("Apple ID Username", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	ControlSetText("Apple ID Password", "", "Edit1", $sDecryptedPassword)
	Sleep(100)
	ControlClick("Apple ID Password", "", "Button1", "primary", 1)
EndFunc   ;==>Upass

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


;~ #comments-end





