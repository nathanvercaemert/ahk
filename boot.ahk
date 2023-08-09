﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force ; skips the startup (on re-run) dialog box and replaces the old instance automatically
#Include ./VD.ahk/VD.ahk ; virtual desktop submodule (has different header requirements if I ever use more funcitonality)
#Include window-manager.ahk

WasF8 := false

ResetWasF8:
    WasF8 = true
    Return

; ************
; ************
; Idle *******
; ************
; ************

; KeepWinZRunning := true
; #MaxThreadsPerHotkey 3
; #z::  
; #MaxThreadsPerHotkey 1
; if KeepWinZRunning  
; {
;     KeepWinZRunning := false  
;     return  
; } else
; {
;     KeepWinZRunning := true
; }
; Loop
; {
;     Sleep 1000
;     Send {F19}
;     Sleep 1000
;     Send {F19}
;     if not KeepWinZRunning  
;         break  
; }
; KeepWinZRunning := false   
; return


; ********************
; ********************
; GUI-key pass-through
; ********************
; ********************

; my kill lines
^#w::
Send {F6}4
Return

; my paste lines
^#y::
Send {F6}5
Return

; my copy lines
^#k::
Send {F6}6
Return

; my duplicate lines
^#d::
Send {F6}7
Return

; my spell check
^#0::
Send {F6}8
Return

; org store link
^#s::
Send {F6}i
Return

; org insert last stored link
^#i::
Send {F6}j
Return

; org toggle link display
^#t::
Send {F6}h
Return

; org follow link
^#l::
Send {F6}t
Return

; counsel find file
^#f::
Send {F6}9
Return

; org-back-to-indentation
^#m::
Send {F6}0
Return

; comment-eclipse
^#`;::
Send {F7}a
Return

; kill word
^#Delete::
Send {F7}b
Return

; counsel-M-x
^#x::
Send {F7}c
Return

; interaction log
^#h::
Send {F7}d
Return

; org-paste-subtree
^#o::
Send {F7}e
Return


; **********
; **********
; AHK Prefix
; **********
; **********

F19::
Return

#If A_PriorHotkey = "F19"

; basic emacs alacritty run command (Win+r)
w::
Send alacritty --config-file C:\\Users\\nverc\\AppData\\Roaming\\alacritty\\alacritty.yml -e wsl -d Ubuntu --user vercaemert emacsclient -nw
Return

; retart boot.ahk
b::
Run C:\\Users\nverc\OneDrive\Documents\etc\ahk\boot.ahk
Return

d::
Send alacritty --config-file C:\Users\nverc\AppData\Roaming\alacritty\alacritty.yml -e docker exec -it vercaemert env TERM=xterm-256color emacsclient -nw
Return

; test
t::
MsgBox test
Return

#If


; *****************
; *****************
; Window Management
; *****************
; *****************

; Maximize Active Window
#Up::
WinMaximize, A, , ,
Return

^!#I::
MouseToActiveWindow()
Return

; Resize Frames

; Top Half
^!#A::
WinGetPos, X, Y, Width, Height, A
HalfHeight := Height / 2
WinMove, A, , X, Y, Width, HalfHeight
return

; Left Half
^!#B::
WinGetPos, X, Y, Width, Height, A
HalfWidth := Width / 2
WinMove, A, , X, Y, HalfWidth, Height
return

; Bottom Half
^!#C::
WinGetPos, X, Y, Width, Height, A
HalfHeight := Height / 2
NewY := Y + HalfHeight
WinMove, A, , X, NewY, Width, HalfHeight
return

; Right Half
^!#D::
WinGetPos, X, Y, Width, Height, A
HalfWidth := Width / 2
NewX := X + HalfWidth
WinMove, A, , NewX, Y, HalfWidth, Height
return

^!#G::
Activate("Middle")
Return

^!#H::
Activate("Right")
Return

^!#M::
Activate("Left")
Return

^!#F::
MoveTo("Middle")
Return

^!#E::
MoveTo("Right")
Return

^!#S::
MoveTo("Left")
Return

^!#J::
SwapWith("Middle")
Return

^!#K::
SwapWith("Right")
Return

^!#1::
SwapWith("Left")
Return

^!#0::
Cycle()
Return


; *****************************
; *****************************
; Make The Hyper Key Do Nothing
; *****************************
; *****************************

#^!Shift::
#^+Alt::
#!+Ctrl::
^!+LWin::
^!+RWin:: 
Send {Blind}{vk07}
Return


; ****************************
; ****************************
; Hotkeys I Accidentally Press
; ****************************
; ****************************

#c::
Return

#i::
Return

^+i::
Return

#u::
Return


; ************
; ************
; Sticky Notes
; ************
; ************

; a new reasonably sized text note in a reasonable place
^+!#t::
Run,  notepad.exe
WinWait Untitled - Notepad
notepadId := WinExist("ahk_exe notepad.exe")   ; gets the unique ID of Notepad being used
WinMove, ahk_id %notepadId%, , A_ScreenWidth / 2, 250, 400, 400
Return

; save the most recent notepad to the desktop with the current timestamp as the filename
^+!#s::
if WinActive("ahk_exe notepad.exe") {
	notepadId := WinExist("ahk_exe notepad.exe")
} else {
	#IfWinActive ahk_class Emacs
	Send ^c^u ; up heading in org
	#IfWinActive
	Return
}
WinGetText, txt, ahk_id %notepadId%
FormatTime, Time, , yyyy-MM-dd H-m-s
FileAppend, %txt%, %A_Desktop%\%Time%.txt
WinGet, processId, PID, ahk_id %notepadId%
Process, close, %processId%
Return


; ***************
; ***************
; Alacritty *****
; ***************
; ***************

; pasting into alacritty
; clean up the clipboard to remove windows line endings
; this is a hack to fix the issue where pasting into alacritty
; (using the alacritty paste functionality bound to MEH(PgDn) (bound to lmd+rpu))
; causes windows line endings to be represented as two line feeds
F16::
ClipboardBackup := Clipboard                        ; To restore clipboard contents after paste
FixString := StrReplace(Clipboard, "`r")            ; Change endings
Clipboard := FixString                              ; Set to clipboard
Send ^+!{PgDn}                                      ; Paste text
sleep 10                                            ; sleeping because if I replace to fast
                                                    ; then the wrong thing gets pasted
Clipboard := ClipboardBackup                        ; Restore clipboard that has windows endings
Return


#IfWinActive ahk_class Window Class

; Emacs Escape->Quit (swap) Quit->Escape
Esc::
Send ^g
Return
^g::
Send {Esc}
Return

; Emacs terminal !Enter->C-m
!Enter::
Send !^m
Return

; Emacs up instead of ^p
; because having issues with docker
; docker doesn't process ^p correctly for some reason
^p::
Send {Up}
Return

#If

#IfWinNotActive ahk_class Window Class

; cut
^w::
Send ^x
Return

; copy
!w::
Send ^c
Return

; paste
^y::
Send ^v
Return

; up
^p::
Send {Up}
Return

; shift up
+^p::
Send +{Up}
Return

; down
^n::
Send {Down}
Return

; shift down
+^n::
Send +{Down}
Return

; right
^f::
Send {Right}
Return

; shift right
+^f::
Send +{Right}
Return

; left
^b::
Send {Left}
Return

; shift left
+^b::
Send +{Left}
Return

F5::
Return

^F5::
Return

#If A_PriorHotkey = "F5"

4::
Send ^z
Return

1::
Send ^q
Send a
Return

w::
If WinActive("ahk_class ApplicationFrameWindow") ; scroll down "1" in xodo
{
    Send {Down}
    Return
}
If WinActive("ahk_class AcrobatSDIWindow") ; in adobe
{
    Loop 3 {
        Send {Down}
    }
    Return
}
Send ^q ; in vimium
Send c
Return

v::
If WinActive("ahk_class ApplicationFrameWindow") ; scroll up "1" in xodo
{
    Send {Up}
    Return
}
If WinActive("ahk_class AcrobatSDIWindow") ; in adobe
{
    Loop 3 {
        Send {Up}
    }
    Return
}
Send ^q ; in vimium
Send d
Return

#If

#If A_PriorHotkey = "^F5"

^1::
Send ^q
Send b
Return

#If

#IfWinNotActive ahk_class Window Class

F7::
Return

#If A_PriorHotkey = "F7"

g::
If WinActive("ahk_class AcrobatSDIWindow") ; in adobe
{
    Loop 33 {
        Send {Up}
        Sleep 40
    }
    Return
}
Send ^q ; in vimium
Send e
Return

f::
If WinActive("ahk_class AcrobatSDIWindow") ; in adobe
{
    Loop 33 {
        Send {Down}
        Sleep 40
    }
    Return
}
Send ^q ; in vimium
Send f
Return



#If


#IfWinNotActive ahk_class Window Class

^x::
Return

#If A_PriorHotkey = "^x"

h::
Send ^a
Return

:*b0:52::
Send ^n
Return

^c::
Send !{F4}
Return

^s::
Send ^s
Return

#If

#IfWinNotActive ahk_class Window Class

; search
^s::
Send ^f
Return

; forward word
!f::
Send ^{Right}
Send ^{Right}
Send ^{Left}
Return

; shift forward word
+!f::
Send +^{Right}
Send +^{Right}
Send ^+{Left}
Return

; backward word
!b::
Send ^{Left}
Send ^{Left}
Send ^{Right}
Return

; shift backward word
!+b::
Send ^+{Left}
Send ^+{Left}
Send ^+{Right}
Return

; kill backward word
!$BACKSPACE::
Send ^{Backspace}
Return

; page up / page down

^v::
Send {PgDn}
Return

!v::
Send {PgUp}
Return

#If

F24::
SubTopLeft()
Return

F23::
SubTopRight()
Return

F22::
SubBottomLeft()
Return

F21::
SubBottomRight()
Return

#If

~F8::
Return

#If
#If A_PriorHotkey = "~F8"

a::
If ((!WinActive("ahk_class Chrome_WidgetWin_1")) and (!WinActive("ahk_class CabinetWClass"))) {
    Send a
}
SetTimer, ResetWasF8, 500
Return

#If
#If A_PriorHotkey = "a"

c::
If (WasF8 and (WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class CabinetWClass"))) {
    Send ^w
} Else {
    Send c
}
Return