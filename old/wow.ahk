#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Coordmode, Mouse, Screen

^+!#F1::
    MouseGetPos, xPos, yPos
    xPos += 200
    Click, Down Right
    MouseMove, %xPos%, %yPos%, 0
    Sleep, 500
    Click, Up Right
    xPos -= 200
    MouseMove, %xPos%, %yPos%, 0