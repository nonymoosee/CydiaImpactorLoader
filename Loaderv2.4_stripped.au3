Global Const $GUI_EVENT_CLOSE = -3
Global Const $UBOUND_DIMENSIONS = 0
Global Const $UBOUND_ROWS = 1
Global Const $UBOUND_COLUMNS = 2
Global Const $STR_ENTIRESPLIT = 1
Global Const $STR_NOCOUNT = 2
Global Enum $ARRAYFILL_FORCE_DEFAULT, $ARRAYFILL_FORCE_SINGLEITEM, $ARRAYFILL_FORCE_INT, $ARRAYFILL_FORCE_NUMBER, $ARRAYFILL_FORCE_PTR, $ARRAYFILL_FORCE_HWND, $ARRAYFILL_FORCE_STRING
Func _ArrayAdd(ByRef $aArray, $vValue, $iStart = 0, $sDelim_Item = "|", $sDelim_Row = @CRLF, $iForce = $ARRAYFILL_FORCE_DEFAULT)
	If $iStart = Default Then $iStart = 0
	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If $iForce = Default Then $iForce = $ARRAYFILL_FORCE_DEFAULT
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS)
	Local $hDataType = 0
	Switch $iForce
		Case $ARRAYFILL_FORCE_INT
			$hDataType = Int
		Case $ARRAYFILL_FORCE_NUMBER
			$hDataType = Number
		Case $ARRAYFILL_FORCE_PTR
			$hDataType = Ptr
		Case $ARRAYFILL_FORCE_HWND
			$hDataType = Hwnd
		Case $ARRAYFILL_FORCE_STRING
			$hDataType = String
	EndSwitch
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			If $iForce = $ARRAYFILL_FORCE_SINGLEITEM Then
				ReDim $aArray[$iDim_1 + 1]
				$aArray[$iDim_1] = $vValue
				Return $iDim_1
			EndIf
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 1 Then Return SetError(5, 0, -1)
				$hDataType = 0
			Else
				Local $aTmp = StringSplit($vValue, $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				If UBound($aTmp, $UBOUND_ROWS) = 1 Then
					$aTmp[0] = $vValue
				EndIf
				$vValue = $aTmp
			EndIf
			Local $iAdd = UBound($vValue, $UBOUND_ROWS)
			ReDim $aArray[$iDim_1 + $iAdd]
			For $i = 0 To $iAdd - 1
				If IsFunc($hDataType) Then
					$aArray[$iDim_1 + $i] = $hDataType($vValue[$i])
				Else
					$aArray[$iDim_1 + $i] = $vValue[$i]
				EndIf
			Next
			Return $iDim_1 + $iAdd - 1
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS)
			If $iStart < 0 Or $iStart > $iDim_2 - 1 Then Return SetError(4, 0, -1)
			Local $iValDim_1, $iValDim_2 = 0, $iColCount
			If IsArray($vValue) Then
				If UBound($vValue, $UBOUND_DIMENSIONS) <> 2 Then Return SetError(5, 0, -1)
				$iValDim_1 = UBound($vValue, $UBOUND_ROWS)
				$iValDim_2 = UBound($vValue, $UBOUND_COLUMNS)
				$hDataType = 0
			Else
				Local $aSplit_1 = StringSplit($vValue, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
				$iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
				Local $aTmp[$iValDim_1][0], $aSplit_2
				For $i = 0 To $iValDim_1 - 1
					$aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
					$iColCount = UBound($aSplit_2)
					If $iColCount > $iValDim_2 Then
						$iValDim_2 = $iColCount
						ReDim $aTmp[$iValDim_1][$iValDim_2]
					EndIf
					For $j = 0 To $iColCount - 1
						$aTmp[$i][$j] = $aSplit_2[$j]
					Next
				Next
				$vValue = $aTmp
			EndIf
			If UBound($vValue, $UBOUND_COLUMNS) + $iStart > UBound($aArray, $UBOUND_COLUMNS) Then Return SetError(3, 0, -1)
			ReDim $aArray[$iDim_1 + $iValDim_1][$iDim_2]
			For $iWriteTo_Index = 0 To $iValDim_1 - 1
				For $j = 0 To $iDim_2 - 1
					If $j < $iStart Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					ElseIf $j - $iStart > $iValDim_2 - 1 Then
						$aArray[$iWriteTo_Index + $iDim_1][$j] = ""
					Else
						If IsFunc($hDataType) Then
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $hDataType($vValue[$iWriteTo_Index][$j - $iStart])
						Else
							$aArray[$iWriteTo_Index + $iDim_1][$j] = $vValue[$iWriteTo_Index][$j - $iStart]
						EndIf
					EndIf
				Next
			Next
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch
	Return UBound($aArray, $UBOUND_ROWS) - 1
EndFunc   ;==>_ArrayAdd
Func _ArrayDelete(ByRef $aArray, $vRange)
	If Not IsArray($aArray) Then Return SetError(1, 0, -1)
	Local $iDim_1 = UBound($aArray, $UBOUND_ROWS) - 1
	If IsArray($vRange) Then
		If UBound($vRange, $UBOUND_DIMENSIONS) <> 1 Or UBound($vRange, $UBOUND_ROWS) < 2 Then Return SetError(4, 0, -1)
	Else
		Local $iNumber, $aSplit_1, $aSplit_2
		$vRange = StringStripWS($vRange, 8)
		$aSplit_1 = StringSplit($vRange, ";")
		$vRange = ""
		For $i = 1 To $aSplit_1[0]
			If Not StringRegExp($aSplit_1[$i], "^\d+(-\d+)?$") Then Return SetError(3, 0, -1)
			$aSplit_2 = StringSplit($aSplit_1[$i], "-")
			Switch $aSplit_2[0]
				Case 1
					$vRange &= $aSplit_2[1] & ";"
				Case 2
					If Number($aSplit_2[2]) >= Number($aSplit_2[1]) Then
						$iNumber = $aSplit_2[1] - 1
						Do
							$iNumber += 1
							$vRange &= $iNumber & ";"
						Until $iNumber = $aSplit_2[2]
					EndIf
			EndSwitch
		Next
		$vRange = StringSplit(StringTrimRight($vRange, 1), ";")
	EndIf
	If $vRange[1] < 0 Or $vRange[$vRange[0]] > $iDim_1 Then Return SetError(5, 0, -1)
	Local $iCopyTo_Index = 0
	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]] = ChrW(0xFAB1)
			Next
			For $iReadFrom_Index = 0 To $iDim_1
				If $aArray[$iReadFrom_Index] == ChrW(0xFAB1) Then
					ContinueLoop
				Else
					If $iReadFrom_Index <> $iCopyTo_Index Then
						$aArray[$iCopyTo_Index] = $aArray[$iReadFrom_Index]
					EndIf
					$iCopyTo_Index += 1
				EndIf
			Next
			ReDim $aArray[$iDim_1 - $vRange[0] + 1]
		Case 2
			Local $iDim_2 = UBound($aArray, $UBOUND_COLUMNS) - 1
			For $i = 1 To $vRange[0]
				$aArray[$vRange[$i]][0] = ChrW(0xFAB1)
			Next
			For $iReadFrom_Index = 0 To $iDim_1
				If $aArray[$iReadFrom_Index][0] == ChrW(0xFAB1) Then
					ContinueLoop
				Else
					If $iReadFrom_Index <> $iCopyTo_Index Then
						For $j = 0 To $iDim_2
							$aArray[$iCopyTo_Index][$j] = $aArray[$iReadFrom_Index][$j]
						Next
					EndIf
					$iCopyTo_Index += 1
				EndIf
			Next
			ReDim $aArray[$iDim_1 - $vRange[0] + 1][$iDim_2 + 1]
		Case Else
			Return SetError(2, 0, False)
	EndSwitch
	Return UBound($aArray, $UBOUND_ROWS)
EndFunc   ;==>_ArrayDelete
Global Const $FLTA_FILESFOLDERS = 0
Func _FileListToArray($sFilePath, $sFilter = "*", $iFlag = $FLTA_FILESFOLDERS, $bReturnPath = False)
	Local $sDelimiter = "|", $sFileList = "", $sFileName = "", $sFullPath = ""
	$sFilePath = StringRegExpReplace($sFilePath, "[\\/]+$", "") & "\"
	If $iFlag = Default Then $iFlag = $FLTA_FILESFOLDERS
	If $bReturnPath Then $sFullPath = $sFilePath
	If $sFilter = Default Then $sFilter = "*"
	If Not FileExists($sFilePath) Then Return SetError(1, 0, 0)
	If StringRegExp($sFilter, "[\\/:><\|]|(?s)^\s*$") Then Return SetError(2, 0, 0)
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 0, 0)
	Local $hSearch = FileFindFirstFile($sFilePath & $sFilter)
	If @error Then Return SetError(4, 0, 0)
	While 1
		$sFileName = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If ($iFlag + @extended = 2) Then ContinueLoop
		$sFileList &= $sDelimiter & $sFullPath & $sFileName
	WEnd
	FileClose($hSearch)
	If $sFileList = "" Then Return SetError(4, 0, 0)
	Return StringSplit(StringTrimLeft($sFileList, 1), $sDelimiter)
EndFunc   ;==>_FileListToArray
Global Const $PROV_RSA_AES = 24
Global Const $CRYPT_VERIFYCONTEXT = 0xF0000000
Global Const $CRYPT_EXPORTABLE = 0x00000001
Global Const $CRYPT_USERDATA = 1
Global Const $CALG_MD5 = 0x00008003
Global Const $CALG_RC4 = 0x00006801
Global Const $CALG_USERKEY = 0
Global Const $KP_ALGID = 0x00000007
Global $__g_aCryptInternalData[3]
Func _Crypt_Startup()
	If __Crypt_RefCount() = 0 Then
		Local $hAdvapi32 = DllOpen("Advapi32.dll")
		If $hAdvapi32 = -1 Then Return SetError(1, 0, False)
		__Crypt_DllHandleSet($hAdvapi32)
		Local $iProviderID = $PROV_RSA_AES
		Local $aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptAcquireContext", "handle*", 0, "ptr", 0, "ptr", 0, "dword", $iProviderID, "dword", $CRYPT_VERIFYCONTEXT)
		If @error Or Not $aRet[0] Then
			Local $iError = @error + 10, $iExtended = @extended
			DllClose(__Crypt_DllHandle())
			Return SetError($iError, $iExtended, False)
		Else
			__Crypt_ContextSet($aRet[1])
		EndIf
	EndIf
	__Crypt_RefCountInc()
	Return True
EndFunc   ;==>_Crypt_Startup
Func _Crypt_Shutdown()
	__Crypt_RefCountDec()
	If __Crypt_RefCount() = 0 Then
		DllCall(__Crypt_DllHandle(), "bool", "CryptReleaseContext", "handle", __Crypt_Context(), "dword", 0)
		DllClose(__Crypt_DllHandle())
	EndIf
EndFunc   ;==>_Crypt_Shutdown
Func _Crypt_DeriveKey($vPassword, $iAlgID, $iHashAlgID = $CALG_MD5)
	Local $aRet = 0, $hBuff = 0, $hCryptHash = 0, $iError = 0, $iExtended = 0, $vReturn = 0
	_Crypt_Startup()
	Do
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptCreateHash", "handle", __Crypt_Context(), "uint", $iHashAlgID, "ptr", 0, "dword", 0, "handle*", 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 10
			$iExtended = @extended
			$vReturn = -1
			ExitLoop
		EndIf
		$hCryptHash = $aRet[5]
		$hBuff = DllStructCreate("byte[" & BinaryLen($vPassword) & "]")
		DllStructSetData($hBuff, 1, $vPassword)
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptHashData", "handle", $hCryptHash, "struct*", $hBuff, "dword", DllStructGetSize($hBuff), "dword", $CRYPT_USERDATA)
		If @error Or Not $aRet[0] Then
			$iError = @error + 20
			$iExtended = @extended
			$vReturn = -1
			ExitLoop
		EndIf
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptDeriveKey", "handle", __Crypt_Context(), "uint", $iAlgID, "handle", $hCryptHash, "dword", $CRYPT_EXPORTABLE, "handle*", 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			$iExtended = @extended
			$vReturn = -1
			ExitLoop
		EndIf
		$vReturn = $aRet[5]
	Until True
	If $hCryptHash <> 0 Then DllCall(__Crypt_DllHandle(), "bool", "CryptDestroyHash", "handle", $hCryptHash)
	Return SetError($iError, $iExtended, $vReturn)
EndFunc   ;==>_Crypt_DeriveKey
Func _Crypt_DestroyKey($hCryptKey)
	Local $aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptDestroyKey", "handle", $hCryptKey)
	Local $iError = @error, $iExtended = @extended
	_Crypt_Shutdown()
	If $iError Or Not $aRet[0] Then
		Return SetError($iError + 10, $iExtended, False)
	Else
		Return True
	EndIf
EndFunc   ;==>_Crypt_DestroyKey
Func _Crypt_EncryptData($vData, $vCryptKey, $iAlgID, $bFinal = True)
	Switch $iAlgID
		Case $CALG_USERKEY
			Local $iCalgUsed = __Crypt_GetCalgFromCryptKey($vCryptKey)
			If @error Then Return SetError(@error, -1, @extended)
			If $iCalgUsed = $CALG_RC4 Then ContinueCase
		Case $CALG_RC4
			If BinaryLen($vData) = 0 Then Return SetError(0, 0, Binary(''))
	EndSwitch
	Local $iReqBuffSize = 0, $aRet = 0, $hBuff = 0, $iError = 0, $iExtended = 0, $vReturn = 0
	_Crypt_Startup()
	Do
		If $iAlgID <> $CALG_USERKEY Then
			$vCryptKey = _Crypt_DeriveKey($vCryptKey, $iAlgID)
			If @error Then
				$iError = @error + 100
				$iExtended = @extended
				$vReturn = -1
				ExitLoop
			EndIf
		EndIf
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptEncrypt", "handle", $vCryptKey, "handle", 0, "bool", $bFinal, "dword", 0, "ptr", 0, "dword*", BinaryLen($vData), "dword", 0)
		If @error Or Not $aRet[0] Then
			$iError = @error + 20
			$iExtended = @extended
			$vReturn = -1
			ExitLoop
		EndIf
		$iReqBuffSize = $aRet[6]
		$hBuff = DllStructCreate("byte[" & $iReqBuffSize + 1 & "]")
		DllStructSetData($hBuff, 1, $vData)
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptEncrypt", "handle", $vCryptKey, "handle", 0, "bool", $bFinal, "dword", 0, "struct*", $hBuff, "dword*", BinaryLen($vData), "dword", DllStructGetSize($hBuff) - 1)
		If @error Or Not $aRet[0] Then
			$iError = @error + 30
			$iExtended = @extended
			$vReturn = -1
			ExitLoop
		EndIf
		$vReturn = BinaryMid(DllStructGetData($hBuff, 1), 1, $iReqBuffSize)
	Until True
	If $iAlgID <> $CALG_USERKEY Then _Crypt_DestroyKey($vCryptKey)
	_Crypt_Shutdown()
	Return SetError($iError, $iExtended, $vReturn)
EndFunc   ;==>_Crypt_EncryptData
Func _Crypt_DecryptData($vData, $vCryptKey, $iAlgID, $bFinal = True)
	Switch $iAlgID
		Case $CALG_USERKEY
			Local $iCalgUsed = __Crypt_GetCalgFromCryptKey($vCryptKey)
			If @error Then Return SetError(@error, -1, @extended)
			If $iCalgUsed = $CALG_RC4 Then ContinueCase
		Case $CALG_RC4
			If BinaryLen($vData) = 0 Then Return SetError(0, 0, Binary(''))
	EndSwitch
	Local $aRet = 0, $hBuff = 0, $hTempStruct = 0, $iError = 0, $iExtended = 0, $iPlainTextSize = 0, $vReturn = 0
	_Crypt_Startup()
	Do
		If $iAlgID <> $CALG_USERKEY Then
			$vCryptKey = _Crypt_DeriveKey($vCryptKey, $iAlgID)
			If @error Then
				$iError = @error + 100
				$iExtended = @extended
				$vReturn = -1
				ExitLoop
			EndIf
		EndIf
		$hBuff = DllStructCreate("byte[" & BinaryLen($vData) + 1000 & "]")
		If BinaryLen($vData) > 0 Then DllStructSetData($hBuff, 1, $vData)
		$aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptDecrypt", "handle", $vCryptKey, "handle", 0, "bool", $bFinal, "dword", 0, "struct*", $hBuff, "dword*", BinaryLen($vData))
		If @error Or Not $aRet[0] Then
			$iError = @error + 20
			$iExtended = @extended
			$vReturn = -1
			ExitLoop
		EndIf
		$iPlainTextSize = $aRet[6]
		$hTempStruct = DllStructCreate("byte[" & $iPlainTextSize + 1 & "]", DllStructGetPtr($hBuff))
		$vReturn = BinaryMid(DllStructGetData($hTempStruct, 1), 1, $iPlainTextSize)
	Until True
	If $iAlgID <> $CALG_USERKEY Then _Crypt_DestroyKey($vCryptKey)
	_Crypt_Shutdown()
	Return SetError($iError, $iExtended, $vReturn)
EndFunc   ;==>_Crypt_DecryptData
Func __Crypt_RefCount()
	Return $__g_aCryptInternalData[0]
EndFunc   ;==>__Crypt_RefCount
Func __Crypt_RefCountInc()
	$__g_aCryptInternalData[0] += 1
EndFunc   ;==>__Crypt_RefCountInc
Func __Crypt_RefCountDec()
	If $__g_aCryptInternalData[0] > 0 Then $__g_aCryptInternalData[0] -= 1
EndFunc   ;==>__Crypt_RefCountDec
Func __Crypt_DllHandle()
	Return $__g_aCryptInternalData[1]
EndFunc   ;==>__Crypt_DllHandle
Func __Crypt_DllHandleSet($hAdvapi32)
	$__g_aCryptInternalData[1] = $hAdvapi32
EndFunc   ;==>__Crypt_DllHandleSet
Func __Crypt_Context()
	Return $__g_aCryptInternalData[2]
EndFunc   ;==>__Crypt_Context
Func __Crypt_ContextSet($hCryptContext)
	$__g_aCryptInternalData[2] = $hCryptContext
EndFunc   ;==>__Crypt_ContextSet
Func __Crypt_GetCalgFromCryptKey($vCryptKey)
	Local $tAlgId = DllStructCreate("uint;dword")
	DllStructSetData($tAlgId, 2, 4)
	Local $aRet = DllCall(__Crypt_DllHandle(), "bool", "CryptGetKeyParam", "handle", $vCryptKey, "dword", $KP_ALGID, "ptr", DllStructGetPtr($tAlgId, 1), "dword*", DllStructGetPtr($tAlgId, 2), "dword", 0)
	If @error Or Not $aRet[0] Then
		Return SetError(@error, @extended, $CRYPT_USERDATA)
	Else
		Return DllStructGetData($tAlgId, 1)
	EndIf
EndFunc   ;==>__Crypt_GetCalgFromCryptKey
Global Const $LBS_NOTIFY = 0x00000001
Global Const $LBS_SORT = 0x00000002
Global Const $LBS_EXTENDEDSEL = 0x00000800
Global Const $LB_ERR = -1
Global Const $LB_ADDSTRING = 0x0180
Global Const $LB_RESETCONTENT = 0x0184
Global Const $LB_SETSEL = 0x0185
Global Const $LB_GETSEL = 0x0187
Global Const $LB_GETCOUNT = 0x018B
Global Const $LB_GETSELCOUNT = 0x0190
Global Const $LB_GETSELITEMS = 0x0191
Global Const $LB_GETCARETINDEX = 0x019F
Global Const $LB_INITSTORAGE = 0x01A8
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = "wparam", $lParamType = "lparam", $sReturnType = "lresult")
	Local $aResult = DllCall("user32.dll", $sReturnType, "SendMessageW", "hwnd", $hWnd, "uint", $iMsg, $wParamType, $wParam, $lParamType, $lParam)
	If @error Then Return SetError(@error, @extended, "")
	If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
	Return $aResult
EndFunc   ;==>_SendMessage
Global Const $tagRECT = "struct;long Left;long Top;long Right;long Bottom;endstruct"
Global Const $tagREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;handle hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;lparam lParam;uint cxHeader" & ((@OSVersion = "WIN_XP") ? "" : ";" & $tagRECT & ";uint uChevronState")
Global Const $HGDI_ERROR = Ptr(-1)
Global Const $INVALID_HANDLE_VALUE = Ptr(-1)
Global Const $KF_EXTENDED = 0x0100
Global Const $KF_ALTDOWN = 0x2000
Global Const $KF_UP = 0x8000
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $__WINAPICONSTANT_WM_SETFONT = 0x0030
Func _WinAPI_CreateWindowEx($iExStyle, $sClass, $sName, $iStyle, $iX, $iY, $iWidth, $iHeight, $hParent, $hMenu = 0, $hInstance = 0, $pParam = 0)
	If $hInstance = 0 Then $hInstance = _WinAPI_GetModuleHandle("")
	Local $aResult = DllCall("user32.dll", "hwnd", "CreateWindowExW", "dword", $iExStyle, "wstr", $sClass, "wstr", $sName, "dword", $iStyle, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "hwnd", $hParent, "handle", $hMenu, "handle", $hInstance, "struct*", $pParam)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_CreateWindowEx
Func _WinAPI_GetModuleHandle($sModuleName)
	Local $sModuleNameType = "wstr"
	If $sModuleName = "" Then
		$sModuleName = 0
		$sModuleNameType = "ptr"
	EndIf
	Local $aResult = DllCall("kernel32.dll", "handle", "GetModuleHandleW", $sModuleNameType, $sModuleName)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetModuleHandle
Func _WinAPI_GetStockObject($iObject)
	Local $aResult = DllCall("gdi32.dll", "handle", "GetStockObject", "int", $iObject)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_GetStockObject
Func _WinAPI_SetFont($hWnd, $hFont, $bRedraw = True)
	_SendMessage($hWnd, $__WINAPICONSTANT_WM_SETFONT, $hFont, $bRedraw, 0, "hwnd")
EndFunc   ;==>_WinAPI_SetFont
Global Const $_UDF_GlobalIDs_OFFSET = 2
Global Const $_UDF_GlobalID_MAX_WIN = 16
Global Const $_UDF_STARTID = 10000
Global Const $_UDF_GlobalID_MAX_IDS = 55535
Global Const $__UDFGUICONSTANT_WS_TABSTOP = 0x00010000
Global Const $__UDFGUICONSTANT_WS_VISIBLE = 0x10000000
Global Const $__UDFGUICONSTANT_WS_CHILD = 0x40000000
Global $__g_aUDF_GlobalIDs_Used[$_UDF_GlobalID_MAX_WIN][$_UDF_GlobalID_MAX_IDS + $_UDF_GlobalIDs_OFFSET + 1]
Func __UDF_GetNextGlobalID($hWnd)
	Local $nCtrlID, $iUsedIndex = -1, $bAllUsed = True
	If Not WinExists($hWnd) Then Return SetError(-1, -1, 0)
	For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
		If $__g_aUDF_GlobalIDs_Used[$iIndex][0] <> 0 Then
			If Not WinExists($__g_aUDF_GlobalIDs_Used[$iIndex][0]) Then
				For $x = 0 To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
					$__g_aUDF_GlobalIDs_Used[$iIndex][$x] = 0
				Next
				$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
				$bAllUsed = False
			EndIf
		EndIf
	Next
	For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
		If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd Then
			$iUsedIndex = $iIndex
			ExitLoop
		EndIf
	Next
	If $iUsedIndex = -1 Then
		For $iIndex = 0 To $_UDF_GlobalID_MAX_WIN - 1
			If $__g_aUDF_GlobalIDs_Used[$iIndex][0] = 0 Then
				$__g_aUDF_GlobalIDs_Used[$iIndex][0] = $hWnd
				$__g_aUDF_GlobalIDs_Used[$iIndex][1] = $_UDF_STARTID
				$bAllUsed = False
				$iUsedIndex = $iIndex
				ExitLoop
			EndIf
		Next
	EndIf
	If $iUsedIndex = -1 And $bAllUsed Then Return SetError(16, 0, 0)
	If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] = $_UDF_STARTID + $_UDF_GlobalID_MAX_IDS Then
		For $iIDIndex = $_UDF_GlobalIDs_OFFSET To UBound($__g_aUDF_GlobalIDs_Used, $UBOUND_COLUMNS) - 1
			If $__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = 0 Then
				$nCtrlID = ($iIDIndex - $_UDF_GlobalIDs_OFFSET) + 10000
				$__g_aUDF_GlobalIDs_Used[$iUsedIndex][$iIDIndex] = $nCtrlID
				Return $nCtrlID
			EndIf
		Next
		Return SetError(-1, $_UDF_GlobalID_MAX_IDS, 0)
	EndIf
	$nCtrlID = $__g_aUDF_GlobalIDs_Used[$iUsedIndex][1]
	$__g_aUDF_GlobalIDs_Used[$iUsedIndex][1] += 1
	$__g_aUDF_GlobalIDs_Used[$iUsedIndex][($nCtrlID - 10000) + $_UDF_GlobalIDs_OFFSET] = $nCtrlID
	Return $nCtrlID
EndFunc   ;==>__UDF_GetNextGlobalID
Global Const $__LISTBOXCONSTANT_ClassName = "ListBox"
Global Const $__LISTBOXCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__LISTBOXCONSTANT_WM_SETREDRAW = 0x000B
Func _GUICtrlListBox_AddString($hWnd, $sText)
	If Not IsString($sText) Then $sText = String($sText)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_ADDSTRING, 0, $sText, 0, "wparam", "wstr")
	Else
		Return GUICtrlSendMsg($hWnd, $LB_ADDSTRING, 0, $sText)
	EndIf
EndFunc   ;==>_GUICtrlListBox_AddString
Func _GUICtrlListBox_BeginUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $__LISTBOXCONSTANT_WM_SETREDRAW, False) = 0
EndFunc   ;==>_GUICtrlListBox_BeginUpdate
Func _GUICtrlListBox_Create($hWnd, $sText, $iX, $iY, $iWidth = 100, $iHeight = 200, $iStyle = 0x00B00002, $iExStyle = 0x00000200)
	If Not IsHWnd($hWnd) Then
		Return SetError(1, 0, 0)
	EndIf
	If Not IsString($sText) Then
		Return SetError(2, 0, 0)
	EndIf
	If $iWidth = -1 Then $iWidth = 100
	If $iHeight = -1 Then $iHeight = 200
	Local Const $WS_VSCROLL = 0x00200000, $WS_HSCROLL = 0x00100000, $WS_BORDER = 0x00800000
	If $iStyle = -1 Then $iStyle = BitOR($WS_BORDER, $WS_VSCROLL, $WS_HSCROLL, $LBS_SORT)
	If $iExStyle = -1 Then $iExStyle = 0x00000200
	$iStyle = BitOR($iStyle, $__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_TABSTOP, $__UDFGUICONSTANT_WS_CHILD, $LBS_NOTIFY)
	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Local $hList = _WinAPI_CreateWindowEx($iExStyle, $__LISTBOXCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_WinAPI_SetFont($hList, _WinAPI_GetStockObject($__LISTBOXCONSTANT_DEFAULT_GUI_FONT))
	If StringLen($sText) Then _GUICtrlListBox_AddString($hList, $sText)
	Return $hList
EndFunc   ;==>_GUICtrlListBox_Create
Func _GUICtrlListBox_EndUpdate($hWnd)
	If Not IsHWnd($hWnd) Then $hWnd = GUICtrlGetHandle($hWnd)
	Return _SendMessage($hWnd, $__LISTBOXCONSTANT_WM_SETREDRAW, True) = 0
EndFunc   ;==>_GUICtrlListBox_EndUpdate
Func _GUICtrlListBox_GetCaretIndex($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETCARETINDEX)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETCARETINDEX, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetCaretIndex
Func _GUICtrlListBox_GetCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetCount
Func _GUICtrlListBox_GetSel($hWnd, $iIndex)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETSEL, $iIndex) <> 0
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETSEL, $iIndex, 0) <> 0
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetSel
Func _GUICtrlListBox_GetSelCount($hWnd)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_GETSELCOUNT)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_GETSELCOUNT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_GetSelCount
Func _GUICtrlListBox_GetSelItems($hWnd)
	Local $aArray[1] = [0]
	Local $iCount = _GUICtrlListBox_GetSelCount($hWnd)
	If $iCount > 0 Then
		ReDim $aArray[$iCount + 1]
		Local $tArray = DllStructCreate("int[" & $iCount & "]")
		If IsHWnd($hWnd) Then
			_SendMessage($hWnd, $LB_GETSELITEMS, $iCount, $tArray, 0, "wparam", "struct*")
		Else
			GUICtrlSendMsg($hWnd, $LB_GETSELITEMS, $iCount, DllStructGetPtr($tArray))
		EndIf
		$aArray[0] = $iCount
		For $iI = 1 To $iCount
			$aArray[$iI] = DllStructGetData($tArray, 1, $iI)
		Next
	EndIf
	Return $aArray
EndFunc   ;==>_GUICtrlListBox_GetSelItems
Func _GUICtrlListBox_InitStorage($hWnd, $iItems, $iBytes)
	If IsHWnd($hWnd) Then
		Return _SendMessage($hWnd, $LB_INITSTORAGE, $iItems, $iBytes)
	Else
		Return GUICtrlSendMsg($hWnd, $LB_INITSTORAGE, $iItems, $iBytes)
	EndIf
EndFunc   ;==>_GUICtrlListBox_InitStorage
Func _GUICtrlListBox_ResetContent($hWnd)
	If IsHWnd($hWnd) Then
		_SendMessage($hWnd, $LB_RESETCONTENT)
	Else
		GUICtrlSendMsg($hWnd, $LB_RESETCONTENT, 0, 0)
	EndIf
EndFunc   ;==>_GUICtrlListBox_ResetContent
Func _GUICtrlListBox_SetSel($hWnd, $iIndex = -1, $iSelect = -1)
	Local $i_Ret = 1
	If IsHWnd($hWnd) Then
		If $iIndex == -1 Then
			For $iIndex = 0 To _GUICtrlListBox_GetCount($hWnd) - 1
				$i_Ret = _GUICtrlListBox_GetSel($hWnd, $iIndex)
				If ($i_Ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, False)
				If ($i_Ret > 0) Then
					$i_Ret = _SendMessage($hWnd, $LB_SETSEL, False, $iIndex) <> -1
				Else
					$i_Ret = _SendMessage($hWnd, $LB_SETSEL, True, $iIndex) <> -1
				EndIf
				If ($i_Ret == False) Then Return SetError($LB_ERR, $LB_ERR, False)
			Next
		ElseIf $iSelect == -1 Then
			If _GUICtrlListBox_GetSel($hWnd, $iIndex) Then
				Return _SendMessage($hWnd, $LB_SETSEL, False, $iIndex) <> -1
			Else
				Return _SendMessage($hWnd, $LB_SETSEL, True, $iIndex) <> -1
			EndIf
		Else
			Return _SendMessage($hWnd, $LB_SETSEL, $iSelect, $iIndex) <> -1
		EndIf
	Else
		If $iIndex == -1 Then
			For $iIndex = 0 To _GUICtrlListBox_GetCount($hWnd) - 1
				$i_Ret = _GUICtrlListBox_GetSel($hWnd, $iIndex)
				If ($i_Ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, False)
				If ($i_Ret > 0) Then
					$i_Ret = GUICtrlSendMsg($hWnd, $LB_SETSEL, False, $iIndex) <> -1
				Else
					$i_Ret = GUICtrlSendMsg($hWnd, $LB_SETSEL, True, $iIndex) <> -1
				EndIf
				If ($i_Ret == 0) Then Return SetError($LB_ERR, $LB_ERR, False)
			Next
		ElseIf $iSelect == -1 Then
			If _GUICtrlListBox_GetSel($hWnd, $iIndex) Then
				Return GUICtrlSendMsg($hWnd, $LB_SETSEL, False, $iIndex) <> -1
			Else
				Return GUICtrlSendMsg($hWnd, $LB_SETSEL, True, $iIndex) <> -1
			EndIf
		Else
			Return GUICtrlSendMsg($hWnd, $LB_SETSEL, $iSelect, $iIndex) <> -1
		EndIf
	EndIf
	Return $i_Ret <> 0
EndFunc   ;==>_GUICtrlListBox_SetSel
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
If $CmdLine[0] <> 0 Then
	Local $exists = WinExists("Cydia Impactor")
	If $exists = 0 Then ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	Sleep(800)
	WinMenuSelectItem("Cydia Impactor", "", "&Device", "&Install Package...")
	Sleep(100)
	ControlSetText("Select package.", "", "Edit1", $draggedfile)
	ControlClick("Select package.", "", "Button1", "primary", 1)
	Sleep(100)
	Upass()
	Exit
EndIf
$ImpactorLoader = GUICreate("CydiaLoader", 827, 481, -1, -1)
$Label1 = GUICtrlCreateLabel("IPA FILES IN CURRENT FOLDER AVAILABLE FOR INSTALLATION: ", 368, 8, 340, 17)
Global $FileList = _FileListToArray(@ScriptDir & $requesteddirectory, '*.ipa', 1)
_ArrayDelete($FileList, 0)
Global $FileListLocal = _FileListToArray(@ScriptDir, '*.ipa', 1)
_ArrayDelete($FileListLocal, 0)
$cRemote = IsArray($FileList)
$cLocal = IsArray($FileListLocal)
If $cRemote = 1 And $cLocal = 1 Then
	_ArrayAdd($FileList, $FileListLocal)
EndIf
If $cRemote = 0 And $cLocal = 1 Then
	$FileList = $FileListLocal
EndIf
If $cRemote = 1 And $cLocal = 0 Then
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
					LoadIPA(@ScriptDir & $requesteddirectory & $FileList[$aSelected[$i]])
				EndIf
				If FileExists(@ScriptDir & "\" & $FileList[$aSelected[$i]]) Then
					LoadIPA(@ScriptDir & "\" & $FileList[$aSelected[$i]])
				EndIf
				Finishedyet()
				Sleep(10000)
			Next
			MsgBox(0, "Batch loading complete", "Success!")
			Exit
		Case $LaunchImp
			ManLaunch()
	EndSwitch
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
	Local $exists = WinExists("Cydia Impactor")
	If $exists = 0 Then ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
	Sleep(800)
	WinMenuSelectItem("Cydia Impactor", "", "&Device", "&Install Package...")
	Sleep(200)
	ControlSetText("Select package.", "", "Edit1", $Selectedwhat)
	Sleep(200)
	ControlClick("Select package.", "", "Button1", "primary", 1)
	Sleep(100)
	Upass()
EndFunc   ;==>LoadIPA
Func RevokeCerts()
	Local $exists = WinExists("Cydia Impactor")
	If $exists = 0 Then ShellExecute(@ScriptDir & "\Impactor.exe")
	WinWait("Cydia Impactor")
	WinActivate("Cydia Impactor")
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
	Do
		Sleep(5000)
		$finished = ControlGetText("Cydia Impactor", "", "Static1")
	Until $finished = "Complete" Or $finished = "VerifyingApplication"
	If $finished = "VerifyingApplication" Then
		Sleep(10000)
		$finished = ControlGetText("Cydia Impactor", "", "Static1")
		If $finished = "VerifyingApplication" Then
			Sleep(10000)
			ProcessClose("Impactor.exe")
		EndIf
	EndIf
EndFunc   ;==>Finishedyet
Func StringEncrypt($bEncrypt, $sData, $sPassword)
	_Crypt_Startup()
	Local $sReturn = ''
	If $bEncrypt Then
		$sReturn = _Crypt_EncryptData($sData, $sPassword, $CALG_RC4)
	Else
		$sReturn = BinaryToString(_Crypt_DecryptData($sData, $sPassword, $CALG_RC4))
	EndIf
	_Crypt_Shutdown()
	Return $sReturn
EndFunc   ;==>StringEncrypt
