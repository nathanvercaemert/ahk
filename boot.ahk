#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force ; skips the startup (on re-run) dialog box and replaces the old instance automatically


; makes sure the script is being run as admin
; If not A_IsAdmin
; {
; Run *RunAs "boot.ahk"
; ExitApp
; }

#Include window-manager.ahk

KeepWinZRunning := true
; ; let me relax without teams going idle
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


; toggle image dimmer
!q::
WinGetPos, X, Y, W, H, A
; multiple times to make sure the mouse actually gets there
; MouseMove, W - 162, 63, 0
; MouseMove, W - 162, 63, 0
; MouseMove, W - 162, 63, 0
; MouseMove, W - 162, 63, 0
MouseMove, W - 137, 63, 0
MouseMove, W - 137, 63, 0
MouseMove, W - 137, 63, 0
MouseMove, W - 137, 63, 0
MouseClick,, W - 137, 63,, 0
Sleep, 200
MouseMove, 70, 220, 0
MouseClick,, 70, 220,, 0
Sleep, 400
MouseMove, 240, 105, 0
MouseClick,, 240, 105,, 0
Sleep, 50
MouseClick,, 240, 105,, 0
Sleep, 500
Send {Esc}
Sleep, 400
MouseMove, 0, 0, 0
Return


; window management

; maximize active window
#Up::
WinMaximize, A, , ,
Return

^!#I::
MouseToActiveWindow()
Return

; resize frames

; top half
^!#A::
WinGetPos, X, Y, Width, Height, A
HalfHeight := Height / 2
WinMove, A, , X, Y, Width, HalfHeight
return

; left half
^!#B::
WinGetPos, X, Y, Width, Height, A
HalfWidth := Width / 2
WinMove, A, , X, Y, HalfWidth, Height
return

; bottom half
^!#C::
WinGetPos, X, Y, Width, Height, A
HalfHeight := Height / 2
NewY := Y + HalfHeight
WinMove, A, , X, NewY, Width, HalfHeight
return

; right half
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

^!#L::
Activate("FarRight")
Return

^!#M::
Activate("Left")
Return

^!#N::
Activate("FarLeft")
Return

^!#O::
Activate("Bottom")
Return

^!#P::
Activate("UpLeft")
Return

^!#Q::
Activate("UpRight")
Return

^!#X::
Activate("UpCenter")
Return

^!#8::
Activate("Reading")
Return

^!#F::
MoveTo("Middle")
Return

^!#E::
MoveTo("Right")
Return

^!#R::
MoveTo("FarRight")
Return

^!#S::
MoveTo("Left")
Return

^!#T::
MoveTo("FarLeft")
Return

^!#U::
MoveTo("Bottom")
Return

^!#V::
MoveTo("UpLeft")
Return

^!#W::
MoveTo("UpRight")
Return

^!#Y::
MoveTo("UpCenter")
Return

^!#7::
MoveTo("Full")
Return

^!#9::
MoveTo("Reading")
Return

^!#J::
SwapWith("Middle")
Return

^!#K::
SwapWith("Right")
Return

^!#Z::
SwapWith("FarRight")
Return

^!#1::
SwapWith("Left")
Return

^!#2::
SwapWith("FarLeft")
Return

^!#3::
SwapWith("Bottom")
Return

^!#4::
SwapWith("UpLeft")
Return

^!#5::
SwapWith("UpRight")
Return

^!#6::
SwapWith("UpCenter")
Return

; ::
; SwapWith("Reading")
; Return


; these make the hyper key do nothing
#^!Shift::
#^+Alt::
#!+Ctrl::
^!+LWin::
^!+RWin:: 
Send {Blind}{vk07}
Return


; how to run a program
; Run, C:\Windows\system32\notepad.exe "C:\Users\natha\OneDrive\Desktop\file name.txt"
; Return

#y::
; LWin gets stuck if I don't send {Blind}
Send  {Blind}
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "wsl -d Ubuntu --user nathanvercaemert emacsclient -nw"
Return


; hotkeys I accidentally press

#c::
Return

#i::
Return

^+i::
Return

#u::
Return


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

; pasting into alacritty
; clean up the clipboard to remove windows line endings
; this is a hack to fix the issue where pasting into alacritty
; (using the alacritty paste functionality bound to MEH(PgDn) (bound to lmd+rpu))
; causes windows line endings to be represented as two line feeds
^+!PgDn::
ClipboardBackup := Clipboard                        ; To restore clipboard contents after paste
FixString := StrReplace(Clipboard, "`r")            ; Change endings
Clipboard := FixString                              ; Set to clipboard
Send ^+!{PgDn}                                      ; Paste text
sleep 10                                            ; sleeping because if I replace to fast
                                                    ; then the wrong thing gets pasted
Clipboard := ClipboardBackup                        ; Restore clipboard that has windows endings
Return

; #IfWinActive ahk_class ApplicationFrameWindow

; PgUp::
; MouseToActiveWindow()
; Loop 3 {
;     Send Up
; }
; Return

; PgDn::

; #If A_PriorHotkey = "F5"

; w::
; Send Down
; Return

; v::
; Send Up
; Return

; #If

#IfWinActive ahk_class Window Class

; Emacs Escape->Quit
Esc::
Send ^g
Return

; Emacs terminal !Enter->C-m
!Enter::
Send !^m
Return

; ; pop new frame
; #If A_PriorHotkey = "^x"

; :*b0:52::
; Send  {Blind}
; Run %ComSpec% "alacritty --config-file C:\Users\nverc\AppData\Roaming\alacritty\alacritty.yml -e wsl -d Ubuntu --user vercaemert emacsclient -nw"
; Return

#If

; #IfWinNotActive ahk_class Emacs
; #IfWinNotActive ahk_class CASCADIA_HOSTING_WINDOW_CLASS
; #IfWinNotActive ahk_class mintty
; #IfWinNotActive ahk_class moba/x X rl
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

PgUp::
If WinActive("ahk_class ApplicationFrameWindow") ; scroll up a bit in xodo
{
    Loop 6 {
        Send {Up}
        Sleep 40
    }
    Return
}
If WinActive("ahk_class AcrobatSDIWindow") ; in adobe
{
    Loop 33 {
        Send {Up}
        Sleep 40
    }
    Return
}
; in Vimium
Send ^q
Send e
Return

PgDn::
If WinActive("ahk_class ApplicationFrameWindow") ; scroll down a bit in xodo
{
    Loop 6 {
        Send {Down}
        Sleep 40
    }
    Return
}
If WinActive("ahk_class AcrobatSDIWindow") ; in adobe
{
    Loop 33 {
        Send {Down}
        Sleep 40
    }
    Return
}
; in Vimium
Send ^q
Send f
Return

F5::
Return

^F5::
Return

#If A_PriorHotkey = "F5"

c::
Send ^w
Return

4::
Send ^z
Return

1::
Send ^q
Send a
Return

w::
If WinActive("ahk_class ApplicationFrameWindow")
{
    Send {Down}
    Return
}
If WinActive("ahk_class AcrobatSDIWindow")
{
    Loop 3 {
        Send {Down}
    }
    Return
}
Send ^q
Send c
Return

v::
If WinActive("ahk_class ApplicationFrameWindow")
{
    Send {Up}
    Return
}
If WinActive("ahk_class AcrobatSDIWindow")
{
    Loop 3 {
        Send {Up}
    }
    Return
}
Send ^q
Send d
Return

#If

#If A_PriorHotkey = "^F5"

^1::
Send ^q
Send b
Return

#If
; #IfWinNotActive ahk_class Emacs
; #IfWinNotActive ahk_class CASCADIA_HOSTING_WINDOW_CLASS
; #IfWinNotActive ahk_class mintty
; #IfWinNotActive ahk_class moba/x X rl
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
; #IfWinNotActive ahk_class Emacs
; #IfWinNotActive ahk_class CASCADIA_HOSTING_WINDOW_CLASS
; #IfWinNotActive ahk_class mintty
; #IfWinNotActive ahk_class moba/x X rl
#IfWinNotActive ahk_class Window Class


; put #If A_PriorHotkey = "^c" here (because of the reference to ^c in A_PriorHotkey = "^x")

; search
^s::
Send ^f
Return

; forward word
!f::
Send ^{Right}
Return

; shift forward word
+!f::
Send +^{Right}
Return

; backward word
!b::
Send ^{Left}
Return

; shift backward word
!+b::
Send ^+{Left}
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