#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force ; skips the dialog box and replaces the old instance automatically if a new instance is run

OnMessage(0x218, "func_WM_POWERBROADCAST")
return

func_WM_POWERBROADCAST(wParam, lParam) {
	if (lParam = 0) {
		if (wParam = 7 OR wParam = 8) {
                        run boot.ahk
			run resume.ahk
		}
	}
	return
}