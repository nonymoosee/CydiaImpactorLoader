Opt ("MustDeclareVars", 1)

;HotKeySet ("{ESC}","_Exit")

Global $latestname = "/Loaderv2.6FA.exe"

  While True
    While Not IsAppleConnected ()
      Sleep (100)
	  ConsoleWrite("Not Connected" & @CRLF)
    Wend
    Launcher ()
    While IsAppleConnected ()
      Sleep (100)
	  ConsoleWrite("Connected" & @CRLF)
    Wend
  Wend

Func _Exit ()
  Exit
EndFunc

Func IsAppleConnected ()

    Local $vObjWMI = ObjGet("winmgmts:\\" & @ComputerName & "\root\cimv2")
    Local $vObjItems = $vObjWMI.ExecQuery('SELECT * FROM Win32_USBHub')
    If not IsObj($vObjItems) Then Exit MsgBox (0,"Error","Not an object")
    For $vObjItem In $vObjItems
      If StringInStr($vObjItem.Description, "Apple") Then return True
    Next
    Return False

EndFunc

Func Launcher()
    If not WinExists("CydiaLoader") Then
        Local $c = Run(@ScriptDir & $latestname)
        If $c = 0 Then Exit MsgBox(0, 0, "failed to open cydia impactor, did you rename it?")
    EndIf
EndFunc   ;==>Launcher