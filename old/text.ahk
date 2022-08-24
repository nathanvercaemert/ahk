#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force ; skips the dialog box and replaces the old instance automatically

; the function I used to use to make the text box without any menu, scrollbar, or frame
; ^+!#t::
;     run notepad
;     WinWait Untitled - Notepad
;     rcvrID := WinExist("ahk_exe notepad.exe")   ; rcvrID gets the unique ID of Notepad being used.
;     IfWinNotActive ahk_id %rcvrID%              ; If Notepad not active we activate it in next line.
;     WinActivate ahk_id %rcvrID%
;     Sleep, 100 ; need the sleep for Notepad to settle down
;     DllCall("SetMenu", uint, WinExist(), uint, 0)  ; Remove menu bar of "last found window".
;     ControlGet, v, Hwnd, , Edit1, A
;     WinSet, Style, ^0x200000, ahk_id %v% ; remove the scroll bar
;     WinSet, Style, -0xC00000, A
;     SysGet, workArea, MonitorWorkArea
;     WinMove, A, , A_ScreenWidth / 2, (workAreaBottom - workAreaTop) / 6, 300, 300
;     return