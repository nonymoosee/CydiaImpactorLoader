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
	ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	Sleep(800)
	Send("{ALTDOWN}")
	Send("DI")
	Sleep(500)
	Send("N")
	Sleep(100)
	Send("{ALTUP}")
	Send($draggedfile, 1)
	Send("{ALTDOWN}")
	Sleep(100)
	Send("O")
	Sleep(100)
	Send("{ALTUP}")
	Sleep("100")
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(250)
	Send($username, 1)
	Sleep(250)
	Send("{ENTER}")
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	Sleep(250)
	Send($password, 1)
	Sleep(250)
	Send("{ENTER}")
	Exit
EndIf



#Region ### START Koda GUI section ### Form=D:\GodModeAccount\Desktop\Impactorx2\Gui\ImpactorLoader.kxf
$ImpactorLoader = GUICreate("ImpactorLoader", 387, 205, -1, -1)
$UPass = GUICtrlCreateButton("Type Username and Password (will assume the username window is open)", 16, 40, 355, 25)
$RevokeCerts = GUICtrlCreateButton("Launch Cydia Impactor and Revoke My Certificates", 16, 72, 355, 25)
$Close = GUICtrlCreateButton("Close", 16, 168, 355, 25)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Combo1 = GUICtrlCreateCombo("Please Select IPA To Install", 16, 104, 353, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))

For $i = 1 To UBound($FileList) - 1
	GUICtrlSetData($Combo1, $FileList[$i])
Next

$Button1 = GUICtrlCreateButton("Launch Cydia Impactor And Install the Chosen IPA for me", 16, 136, 353, 25)
$LaunchImp = GUICtrlCreateButton("Start Cydia Impactor For Me", 16, 8, 355, 25)
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

		Case $Button1
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
	MsgBox(0, 0, $Selectedwhat)
	If $Selectedwhat = "Please Select IPA To Install" Then
		MsgBox(0, "Ooops", "Please restart and choose something to install next time")
		Exit
	EndIf
	ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	Sleep(800)
	Send("{ALTDOWN}")
	Send("DI")
	Sleep(500)
	Send("N")
	Sleep(100)
	Send("{ALTUP}")
	Send($Selectedwhat, 1)
	Send("{ALTDOWN}")
	Sleep(100)
	Send("O")
	Sleep(100)
	Send("{ALTUP}")
	Sleep("100")
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(250)
	Send($username, 1)
	Sleep(250)
	Send("{ENTER}")
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	Sleep(250)
	Send($password, 1)
	Sleep(250)
	Send("{ENTER}")
	Exit
EndFunc   ;==>LoadIPA


Func Upass()
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(400)
	Send($username, 1)
	Sleep(400)
	Send("{ENTER}")
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	Sleep(400)
	Send($password, 1)
	Sleep(400)
	Send("{ENTER}")
EndFunc   ;==>Upass

Func RevokeCerts()
	ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	Sleep(800)
	Send("{ALTDOWN}")
	Send("X")
	Sleep(400)
	Send("R")
	Send("{ALTUP}")
	WinWait("Apple ID Username")
	WinActivate("Apple ID Username")
	Sleep(400)
	Send($username, 1)
	Sleep(400)
	Send("{ENTER}")
	WinWait("Apple ID Password")
	WinActivate("Apple ID Password")
	Sleep(400)
	Send($password, 1)
	Sleep(400)
	Send("{ENTER}")
EndFunc   ;==>RevokeCerts
