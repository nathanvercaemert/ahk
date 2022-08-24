#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force ; skips the startup (on re-run) dialog box and replaces the old instance automatically


; didn't have comments for these things, so I don't know why they're here, so I commented them out
; #InstallKeybdHook

; #HotkeyInterval 5000
; #MaxHotkeysPerInterval 500

; SetTitleMatchMode, 2


; makes sure the script is being run as admin
; If not A_IsAdmin
; {
; Run *RunAs "boot.ahk"
; ExitApp
; }


KeepWinZRunning := true


; window management

#Include window-manager.ahk


; let me relax without teams going idle
#MaxThreadsPerHotkey 3
#z::  
#MaxThreadsPerHotkey 1
if KeepWinZRunning  
{
    KeepWinZRunning := false  
    return  
} else
{
    KeepWinZRunning := true
}
Loop
{
    Sleep 1000
    Send {F19}
    Sleep 1000
    Send {F19}
    if not KeepWinZRunning  
        break  
}
KeepWinZRunning := false   
return


#F9::
RunWait, %comspec% /c "C:\cygwin64\bin\mintty.exe -o FormatOtherKeys=1 -o FontSize=24 wsl -d Ubuntu --user nathanvercaemert emacs --no-desktop -nw"
Return

#F10::
RunWait, %comspec% /c "C:\cygwin64\bin\mintty.exe -o FormatOtherKeys=1 -o FontSize=24 wsl -d Ubuntu --user nathanvercaemert emacsclient"
Return


#Up::
WinMaximize, A, , ,
Return

^!#I::
MouseToActiveWindow()
Return

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

; ^!#X::
; Activate("Reading")
; Return

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

#+q::
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

#IfWinActive ahk_class ApplicationFrameWindow

PgUp::
MouseToActiveWindow()
Loop 7 {
    Click, WheelUp
}
Return

PgDn::
MouseToActiveWindow()
Loop 7 {
    Click, WheelDown
}
Return

#If

#IfWinActive ahk_class Window Class

; Emacs Escape->Quit
Esc::
Send ^g
Return

; Emacs terminal !Enter->C-m
!Enter::
Send !^m
Return

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

; Vimium scroll up a bit
PgUp::
Send ^q
Send e
Return

; Vimium scroll down a bit
PgDn::
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
Send ^q
Send c
Return

v::
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