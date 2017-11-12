#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


$username = IniRead(@ScriptDir & '\settingsforloader.ini', 'section', 'username', "NotFound")
$password = IniRead(@ScriptDir & '\settingsforloader.ini', 'section', 'password', "NotFound")
Global $draggedfile, $locationcheck, $impactorfolder=@DesktopDir & "\Impactor\", $impactorlocation=@DesktopDir &"\Impactor\Impactor.exe"
If $CmdLine[0] = 0 Then
	MsgBox(0, "ERROR", "DRAG AND DROP THE IPA FILE YOU WANT TO INSTALL ON ME!")
	Break
EndIf

If $CmdLine[0] <> 0 Then $draggedfile=$CmdLine[1]
$locationcheck = FileExists($impactorlocation)
If $locationcheck=0 Then
        MsgBox(0, "", "The file doesn't exist." & @CRLF & "FileExist returned: " & $locationcheck)
		Break
EndIf

ShellExecute(@DesktopDir &"\Impactor\Impactor.exe")
WinWait("Cydia Impactor")
WinActivate("Cydia Impactor")
Sleep(100)
Send("{ALTDOWN}")
Send("DI")
Sleep(1000)
Send("N")
Sleep(100)
Send("{ALTUP}")
Send($draggedfile, 1)
Send("{ALTDOWN}")
Send("O")
Send("{ALTUP}")
Sleep("100")
WinWait("Apple")
WinActivate("Apple")
Send($username, 1)
Send("{ENTER}")
WinWait("Apple ID Password")
WinActivate("Apple ID Password")
Send($password, 1)
Send("{ENTER}")