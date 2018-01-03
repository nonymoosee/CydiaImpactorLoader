#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <MsgBoxConstants.au3>

Global $FileList = _FileListToArray(@ScriptDir, '*.ipa', 1)
;~ _ArrayDisplay($FileList)

$username = IniRead(@ScriptDir & '\settingsforloader.ini', 'section', 'username', "NotFound")
$password = IniRead(@ScriptDir & '\settingsforloader.ini', 'section', 'password', "NotFound")
Global $draggedfile, $locationcheck, $impactorfolder = @ScriptDir & "\Impactor\", $revoke = 0, $impactorlocation = @ScriptDir & "\Impactor.exe"

If $CmdLine[0] <> 0 Then $draggedfile = $CmdLine[1]
$locationcheck = FileExists($impactorlocation)
If $locationcheck = 0 Then
	MsgBox(0, "", "The file doesn't exist." & @CRLF & "FileExist returned: " & $locationcheck)
	Exit
EndIf

;If you dragged a file then we just install without a GUI
If $CmdLine[0] <> 0 Then
	local $exists = WinExists("Cydia Impactor")
	If $exists = 0 then ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	Sleep(800)
	WinMenuSelectItem("Cydia Impactor", "", "&Device", "&Install Package...")
	Sleep(100)
	ControlSetText("Select package.", "" , "Edit1" , $draggedfile)
	ControlClick("Select package.", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(250)
	ControlSetText("Apple ID Username", "" , "Edit1" , $username)
	Sleep(100)
	ControlClick("Apple ID Username", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	ControlSetText("Apple ID Password", "" , "Edit1" , $password)
	Sleep(100)
	ControlClick("Apple ID Password", "", "Button1", "primary", 1)
	Exit
EndIf



#Region ### START Koda GUI section ### Form=D:\GodModeAccount\Desktop\Impactorx2\Gui\ImpactorLoader.kxf
$ImpactorLoader = GUICreate("ImpactorLoader", 387, 205, -1, -1)
GUICtrlSetFont(-1, 8, 800, 0, "Times New Roman")
$UPass = GUICtrlCreateButton("Type Username and Password (will assume the username window is open)", 16, 40, 355, 25)
GUICtrlSetFont(-1, 8, 800, 0, "Times New Roman")
$RevokeCerts = GUICtrlCreateButton("Launch Cydia Impactor and Revoke My Certificates", 16, 72, 355, 25)
GUICtrlSetFont(-1, 8, 800, 0, "Times New Roman")
$Close = GUICtrlCreateButton("Close", 16, 168, 355, 25)
GUICtrlSetFont(-1, 8, 800, 0, "Times New Roman")
$Combo1 = GUICtrlCreateCombo("Please Select IPA To Install", 16, 104, 353, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetFont(-1, 8, 800, 0, "Times New Roman")
For $i = 1 To UBound($FileList) - 1
	GUICtrlSetData($Combo1, $FileList[$i])
Next

$LaunchAndInstallTheChosenIPA = GUICtrlCreateButton("Launch Cydia Impactor And Install the Chosen IPA for me", 16, 136, 353, 25)
GUICtrlSetFont(-1, 8, 800, 0, "Times New Roman")
$LaunchImp = GUICtrlCreateButton("Start Cydia Impactor For Me", 16, 8, 355, 25)
GUICtrlSetFont(-1, 8, 800, 0, "Times New Roman")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Close
			Exit

		Case $UPass
			Upass()

		Case $RevokeCerts
			RevokeCerts()

		Case $LaunchAndInstallTheChosenIPA
			LoadIPA()

		Case $LaunchImp
			ManLaunch()

	EndSwitch
WEnd

Func ManLaunch()
	ShellExecute(@ScriptDir & "\Impactor.exe")
EndFunc


Func LoadIPA()
	$Selectedwhat = GUICtrlRead($Combo1)
	If $Selectedwhat = "Please Select IPA To Install" Then
		MsgBox(0, "Ooops", "Please restart and choose something to install next time")
		Exit
	EndIf
	local $exists = WinExists("Cydia Impactor")
	If $exists = 0 then ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	Sleep(800)
	WinMenuSelectItem("Cydia Impactor", "", "&Device", "&Install Package...")
	Sleep(100)
	ControlSetText("Select package.", "" , "Edit1" , $Selectedwhat)
	ControlClick("Select package.", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(250)
	ControlSetText("Apple ID Username", "" , "Edit1" , $username)
	Sleep(100)
	ControlClick("Apple ID Username", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	ControlSetText("Apple ID Password", "" , "Edit1" , $password)
	Sleep(100)
	ControlClick("Apple ID Password", "", "Button1", "primary", 1)
	Exit
EndFunc   ;==>LoadIPA


Func Upass()
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(250)
	ControlSetText("Apple ID Username", "" , "Edit1" , $username)
	Sleep(100)
	ControlClick("Apple ID Username", "", "Button1", "primary", 1)
	Sleep(100)
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	ControlSetText("Apple ID Password", "" , "Edit1" , $password)
	Sleep(100)
	ControlClick("Apple ID Password", "", "Button1", "primary", 1)
EndFunc   ;==>Upass

Func RevokeCerts() ; needs to be updated
	local $exists = WinExists("Cydia Impactor")
	If $exists = 0 then ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	WinMenuSelectItem("Cydia Impactor", "", "&Xcode", "&Revoke Certificates")
	Sleep(100)
	Upass()
EndFunc   ;==>RevokeCerts
