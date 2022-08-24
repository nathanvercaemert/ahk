#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance, Force ; This skips the dialog box and replaces the old instance automatically.

; The program starts here.

; These are naively where desktop centers should be (not accounting for taskbars.)
d1X := 0 - (1920 / 2)
d1Y := 1080 + (1080 / 2)
d1 := Object()
d1.Insert("x", d1X)
d1.Insert("y", d1Y)
d2X := (1920 / 2)
d2Y := 1080 + (1080 / 2)
d2 := Object()
d2.Insert("x", d2X)
d2.Insert("y", d2Y)
d3X := 1920 + (1920 / 2)
d3Y := 1080 + (1080 / 2)
d3 := Object()
d3.Insert("x", d3X)
d3.Insert("y", d3Y)
d4X := 0 - (1920 / 2)
d4Y := (1080 / 2)
d4 := Object()
d4.Insert("x", d4X)
d4.Insert("y", d4Y)
d5X := (1920 / 2)
d5Y := (1080 / 2)
d5 := Object()
d5.Insert("x", d5X)
d5.Insert("y", d5Y)
d6X := 1920 + (1920 / 2)
d6Y := (1080 / 2)
d6 := Object()
d6.Insert("x", d6X)
d6.Insert("y", d6Y)
d7X := 0 - (1920 / 2)
d7Y := 0 - (1080 / 2)
d7 := Object()
d7.Insert("x", d7X)
d7.Insert("y", d7Y)
d8X := (1920 / 2)
d8Y := 0 - (1080 / 2)
d8 := Object()
d8.Insert("x", d8X)
d8.Insert("y", d8Y)
d9X := 1920 + (1920 / 2)
d9Y := 0 - (1080 / 2)
d9 := Object()
d9.Insert("x", d9X)
d9.Insert("y", d9Y)
emptyArray := []
desktopCenters := Object()
desktopCenters.Insert(0, emptyArray)
desktopCenters.Insert(1, d1)
desktopCenters.Insert(2, d2)
desktopCenters.Insert(4, d4)
desktopCenters.Insert(5, d5)
desktopCenters.Insert(6, d6)
desktopCenters.Insert(7, d7)
desktopCenters.Insert(8, d8)
desktopCenters.Insert(9, d9)

isWindowVisible(ahkId) {
    WinGet, styleVar, Style, ahk_id %ahkId%
    Transform, isVisible, BitAnd, %styleVar%, 0x10000000 ; 0x10000000 is WS_VISIBLE.
    return %isVisible%
}

processNameHelper(ahkId) {
    WinGet, processNameVar, ProcessName, ahk_id %ahkId%
    return %processNameVar%
}

posHelper(ahkId) {
    WinGetPos, x, y, w, h, ahk_id %ahkId%
    return [x, y, w, h]
}

; ^+!#0::
;     ; the first 9 are taskbars, and the last two have the dimensions of the whole space
;     ; ipoint.exe doesn't take  up any space
;     WinGet, windows, List
;     Loop, %windows% {
;         if (IsWindowVisible(windows%A_Index%)) {
;             nameVar := processNameHelper(windows%A_Index%)
;             FileAppend, %nameVar%`r, %A_Desktop%\output.txt
;             posArray := posHelper(windows%A_Index%)
;             for index, element in posArray {
;                 if (A_index == 1) {
;                     x := element
;                 } else if (A_index == 2) {
;                     y := element
;                 } else if (A_index == 3) {
;                     w := element
;                 } else if (A_index == 4) {
;                     h := element
;                 }
;             }
;             FileAppend, %x% %y% %w% %h%`r, %A_Desktop%\output.txt
;         }
;     }

^+!#0::
    FileDelete, %A_Desktop%\output.txt
    SysGet, MonitorCount, MonitorCount
    SysGet, MonitorPrimary, MonitorPrimary
    FileAppend, Monitor Count: %MonitorCount%`nPrimary Monitor: %MonitorPrimary%`r, %A_Desktop%\output.txt
    Loop, %MonitorCount%
    {
        SysGet, MonitorName, MonitorName, %A_Index%
        SysGet, Monitor, Monitor, %A_Index%
        SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
        string =
(
    Monitor: #%A_Index%
    Name: %MonitorName%
    Left: %MonitorLeft% (%MonitorWorkAreaLeft% work)
    Top: %MonitorTop% (%MonitorWorkAreaTop% work)
    Right: %MonitorRight% (%MonitorWorkAreaRight% work)
    Bottom: %MonitorBottom% (%MonitorWorkAreaBottom% work)`r
)
        FileAppend, %string%, %A_Desktop%\output.txt
    }