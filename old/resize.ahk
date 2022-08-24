#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force ; skips the dialog box and replaces the old instance automatically

ScreenHeight() {
    SysGet, workArea, MonitorWorkArea
    return (workAreaBottom - workAreaTop)
}

WinGetX() {
    WinGetPos, x, y, w, h, a, , ,
    return x
}

^+!2::
    WinRestore, A
    WinMove, A, , 0, 0, A_ScreenWidth, ScreenHeight()
    return

^+!3::
    WinRestore, A
    WinMove, A, , 0, 0, A_ScreenWidth * 3 / 2, ScreenHeight()
    return

^+!4::
    WinRestore, A
    WinMove, A, , 0, 0, A_ScreenWidth * 2, ScreenHeight()
    return

^+!5::
    WinRestore, A
    WinMove, A, , 0, 0, A_ScreenWidth * 5 / 2, ScreenHeight()
    return

^+!6::
    WinRestore, A
    WinMove, A, , 0, 0, A_ScreenWidth * 3, ScreenHeight()
    return

^+!Right::
    WinRestore, A
    WinMove, A, , WinGetX() + A_ScreenWidth / 2, 0
    return

^+!Left::
    WinRestore, A
    WinMove, A, , WinGetX() - A_ScreenWidth / 2, 0
    return
