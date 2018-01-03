#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


$username = IniRead(@ScriptDir & '\settingsforloader.ini', 'section', 'username', "NotFound")
$password = IniRead(@ScriptDir & '\settingsforloader.ini', 'section', 'password', "NotFound")
Global $draggedfile, $locationcheck, $impactorfolder=@ScriptDir & "\Impactor\", $revoke=0,  $impactorlocation=@ScriptDir &"\Impactor.exe"

If $CmdLine[0] = 0 Then
	$revoke=MsgBox(4, "Revoke Certificate?", "You did not drag an IPA file onto loader.exe, do you want to revoke certificates instead? Yes to Revoke, No to close")
	If $revoke=6 Then
		ShellExecute(@ScriptDir &"\Impactor.exe")
		WinWait("Cydia Impactor")
		WinActivate("Cydia Impactor")
		Sleep(800)
		Send("{ALTDOWN}")
		Send("X")
		Sleep(400)
		Send("R")
		Send("{ALTUP}")
		WinWait("Apple")
		WinActivate("Apple")
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
	EndIf

	Exit
EndIf

If $CmdLine[0] <> 0 Then $draggedfile=$CmdLine[1]
$locationcheck = FileExists($impactorlocation)
If $locationcheck=0 Then
        MsgBox(0, "", "The file doesn't exist." & @CRLF & "FileExist returned: " & $locationcheck)
		Exit
EndIf

ShellExecute(@ScriptDir &"\Impactor.exe")
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
WinWait("Apple")
WinActivate("Apple")
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
