ScreenWidth := 1920
ScreenHeight := 1080
EdgeForgiveness := 50

RightMonitorX := ScreenWidth
RightMonitorY := 0
RightMonitorWidth := ScreenWidth
RightMonitorHeight := ScreenHeight
RightCenterX := RightMonitorX + RightMonitorWidth / 2
RightCenterY := RightMonitorY + RightMonitorHeight / 2
RightEdgeForgivenessX := RightMonitorX - EdgeForgiveness
RightEdgeForgivenessY := RightMonitorY - EdgeForgiveness

MiddleMonitorX := 0
MiddleMonitorY := 0
MiddleMonitorWidth := ScreenWidth
MiddleMonitorHeight := ScreenHeight
MiddleCenterX := MiddleMonitorX + MiddleMonitorWidth / 2
MiddleCenterY := MiddleMonitorY + MiddleMonitorHeight / 2
EdgeForgivenessX := MiddleMonitorX - EdgeForgiveness
EdgeForgivenessY := MiddleMonitorY - EdgeForgiveness

BottomRightMonitorX := ScreenWidth + ScreenWidth
BottomRightMonitorY := 0
BottomRightMonitorWidth := 2560
BottomRightMonitorHeight := 1600
BottomRightCenterX := BottomRightMonitorX + BottomRightMonitorWidth / 2
BottomRightCenterY := BottomRightMonitorY + BottomRightMonitorHeight / 2
BottomRightEdgeForgivenessX := BottomRightMonitorX - EdgeForgiveness
BottomRightEdgeForgivenessY := BottomRightMonitorY - EdgeForgiveness

LeftMonitorX := 0 - ScreenWidth
LeftMonitorY := 0
LeftMonitorWidth := ScreenWidth
LeftMonitorHeight := ScreenHeight
LeftCenterX := LeftMonitorX + LeftMonitorWidth / 2
LeftCenterY := LeftMonitorY + LeftMonitorHeight / 2
LeftEdgeForgivenessX := LeftMonitorX - EdgeForgiveness
LeftEdgeForgivenessY := LeftMonitorY - EdgeForgiveness

BottomLeftMonitorX := 0 - ScreenHeight * 2
BottomLeftMonitorY := 0
BottomLeftMonitorWidth := ScreenHeight
BottomLeftMonitorHeight := ScreenWidth
BottomLeftCenterX := BottomLeftMonitorX + BottomLeftMonitorWidth / 2
BottomLeftCenterY := BottomLeftMonitorY + BottomLeftMonitorHeight / 2
BottomLeftEdgeForgivenessX := BottomLeftMonitorX - EdgeForgiveness
BottomLeftEdgeForgivenessY := BottomLeftMonitorY - EdgeForgiveness

BottomMonitorX := 0
BottomMonitorY := ScreenHeight
BottomMonitorWidth := ScreenWidth
BottomMonitorHeight := ScreenHeight
BottomCenterX := BottomMonitorX + BottomMonitorWidth / 2
BottomCenterY := BottomMonitorY + BottomMonitorHeight / 2
BottomEdgeForgivenessX := BottomMonitorX - EdgeForgiveness
BottomEdgeForgivenessY := BottomMonitorY - EdgeForgiveness

UpLeftMonitorX := 0 - ScreenWidth
UpLeftMonitorY := 0 - ScreenHeight
UpLeftMonitorWidth := ScreenWidth
UpLeftMonitorHeight := ScreenHeight
UpLeftCenterX := UpLeftMonitorX + UpLeftMonitorWidth / 2
UpLeftCenterY := UpLeftMonitorY + UpLeftMonitorHeight / 2
UpLeftEdgeForgivenessX := UpLeftMonitorX - EdgeForgiveness
UpLeftEdgeForgivenessY := UpLeftMonitorY - EdgeForgiveness

UpRightMonitorX := ScreenWidth
UpRightMonitorY := 0 - ScreenHeight
UpRightMonitorWidth := ScreenWidth
UpRightMonitorHeight := ScreenHeight
UpRightCenterX := UpRightMonitorX + UpRightMonitorWidth / 2
UpRightCenterY := UpRightMonitorY + UpRightMonitorHeight / 2
UpRightEdgeForgivenessX := UpRightMonitorX - EdgeForgiveness
UpRightEdgeForgivenessY := UpRightMonitorY - EdgeForgiveness

UpCenterMonitorX := 0
UpCenterMonitorY := 0 - ScreenHeight
UpCenterMonitorWidth := ScreenWidth
UpCenterMonitorHeight := ScreenHeight
UpCenterCenterX := UpCenterMonitorX + UpCenterMonitorWidth / 2
UpCenterCenterY := UpCenterMonitorY + UpCenterMonitorHeight / 2
UpCenterEdgeForgivenessX := UpCenterMonitorX - EdgeForgiveness
UpCenterEdgeForgivenessY := UpCenterMonitorY - EdgeForgiveness

GetAllWindowIds()
{
    AllWindowIds := []
    WinGet Windows, List
    Loop %Windows%
    {
        Id := Windows%A_Index%
        AllWindowIds.Push(Id)
    }
    return AllWindowIds
}

Filter_WindowIds(All_WindowIds)
{

    ; ; for finding names to blacklist:
    ; ;
    ; ; if something says it's there and it's not actually,
    ; ; add to blacklist above
    ; ;
    ; Output := ""
    ; for Index, WindowId in All_WindowIds
    ; {
    ;     Id := WindowId
    ;     WinGetTitle Title, ahk_id %Id%
    ;     WinGetClass Class, ahk_id %Id%
    ;     WinGetPos, Xpos, Ypos, W, H, ahk_id %Id%
    ;     Output = %Output%%Xpos%,%Ypos%,%Class%,%Title%`n
    ; }
    ; MsgBox, %Output%
    ; ; return []

    CurrentActiveDesktop := VD.getCurrentDesktopNum()

    FilteredWindowIds := []
    for Index, WindowId in All_WindowIds
    {
        Id := WindowId
        WinGetTitle Title, ahk_id %Id%
        WinGetClass Class, ahk_id %Id%
        WinGetPos, Xpos, Ypos, W, H, ahk_id %Id%
        ; blacklist
        if (Title != "") && (Title != "ZPToolBarParentWnd") && (Title != "JamPostMessageWindow") && (Class != "Winit Thread Event Target") && (Class != "PsuedoConsoleWindow") && (Class != "Shell_TrayWnd") && (Class != "Shell_SecondaryTrayWnd") && (Class != "Progman") && (Class != "WindowsForms10.Window.8.app.0.3399f34_r6_ad1") {
            ; mobaxterm specific
            if (Class == "TApplication") {
                continue
            }
            ; current virtual desktop only
            WindowDesktop := VD._desktopNum_from_Hwnd(Id)
            if (CurrentActiveDesktop != WindowDesktop) {
                continue
            } 
            FilteredWindowIds.Push(WindowId)
        }
    }
    return FilteredWindowIds

}

GetWindowIdsInMonitor(AllWindowIds, MonitorX, MonitorY, MonitorWidth, MonitorHeight)
{
    WindowIdsInMonitor := []
    for Index, WindowId in AllWindowIds
    {
        Id := WindowId
        WinGetPos, Xpos, Ypos,,, ahk_id %Id%
        if (Xpos > MonitorX) && (Xpos < (MonitorX + MonitorWidth)) && (Ypos > MonitorY) && (Ypos < (MonitorY + MonitorHeight)) {
            WindowIdsInMonitor.Push(Id)
        }
    }
    return WindowIdsInMonitor
}

MouseToActiveWindow()
{
    WinGetPos, , , Width_Win, Height_Win, A
    ; for some reason you put the values relative
    ; to the corner of the window... maybe?
    ; not actually sure why this isn't "X + Width / 2"
    CenterX := Width_Win / 2
    CenterY := Height_Win / 2
    MouseMove, CenterX, CenterY, 0
    MouseMove, CenterX, CenterY, 0
    Sleep 10
    MouseMove, CenterX, CenterY, 0
    MouseMove, CenterX, CenterY, 0
    Sleep 10
    MouseMove, CenterX, CenterY, 0
    MouseMove, CenterX, CenterY, 0
    return
}

Cycle()
{
    CurrentMonitor := GetMonitor()
    CurrentMonitorName := CurrentMonitor[1]
    ; CurrentMonitorX := CurrentMonitor[2]
    ; CurrentMonitorY := CurrentMonitor[3]
    ; CurrentMonitorWidth := CurrentMonitor[4]
    ; CurrentMonitorHeight := CurrentMonitor[5]

    ; AllWindowIds := GetAllWindowIds()
    ; AllWindowIdsInMonitor := GetWindowIdsInMonitor(AllWindowIds, CurrentMonitorX, CurrentMonitorY, CurrentMonitorWidth, CurrentMonitorHeight)

    WinSet, Bottom, , A
    Activate(CurrentMonitorName)
    ; WinGetClass, ActiveMonitorClass, A
    ; MsgBox, %ActiveMonitorClass%
}

GetMonitor()
{
    WinGetPos, X_Win, Y_Win, , , A

    global MiddleMonitorX, MiddleMonitorWidth, MiddleMonitorY, MiddleMonitorHeight, EdgeForgiveness
    XBound := MiddleMonitorX + MiddleMonitorWidth - EdgeForgiveness
    YBound := MiddleMonitorY + MiddleMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("Middle")
ReturnArray.push(MiddleMonitorX)
ReturnArray.push(MiddleMonitorY)
ReturnArray.push(MiddleMonitorWidth)
ReturnArray.push(MiddleMonitorHeight)
    if X_Win between %MiddleMonitorX% and %XBound%
        if Y_Win between %MiddleMonitorY% and %YBound%
                Return ReturnArray

    global RightMonitorX, RightMonitorWidth, RightMonitorY, RightMonitorHeight, EdgeForgiveness
    XBound := RightMonitorX + RightMonitorWidth - EdgeForgiveness
    YBound := RightMonitorY + RightMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("Right")
ReturnArray.push(RightMonitorX)
ReturnArray.push(RightMonitorY)
ReturnArray.push(RightMonitorWidth)
ReturnArray.push(RightMonitorHeight)
    if X_Win between %RightMonitorX% and %XBound%
        if Y_Win between %RightMonitorY% and %YBound%
                Return ReturnArray

    global LeftMonitorX, LeftMonitorWidth, LeftMonitorY, LeftMonitorHeight, EdgeForgiveness
    XBound := LeftMonitorX + LeftMonitorWidth - EdgeForgiveness
    YBound := LeftMonitorY + LeftMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("Left")
ReturnArray.push(LeftMonitorX)
ReturnArray.push(LeftMonitorY)
ReturnArray.push(LeftMonitorWidth)
ReturnArray.push(LeftMonitorHeight)
    if X_Win between %LeftMonitorX% and %XBound%
        if Y_Win between %LeftMonitorY% and %YBound%
                Return ReturnArray

    global UpCenterMonitorX, UpCenterMonitorWidth, UpCenterMonitorY, UpCenterMonitorHeight, EdgeForgiveness
    XBound := UpCenterMonitorX + UpCenterMonitorWidth - EdgeForgiveness
    YBound := UpCenterMonitorY + UpCenterMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("UpCenter")
ReturnArray.push(UpCenterMonitorX)
ReturnArray.push(UpCenterMonitorY)
ReturnArray.push(UpCenterMonitorWidth)
ReturnArray.push(UpCenterMonitorHeight)
    if X_Win between %UpCenterMonitorX% and %XBound%
        if Y_Win between %UpCenterMonitorY% and %YBound%
                Return ReturnArray

    global UpRightMonitorX, UpRightMonitorWidth, UpRightMonitorY, UpRightMonitorHeight, EdgeForgiveness
    XBound := UpRightMonitorX + UpRightMonitorWidth - EdgeForgiveness
    YBound := UpRightMonitorY + UpRightMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("UpRight")
ReturnArray.push(UpRightMonitorX)
ReturnArray.push(UpRightMonitorY)
ReturnArray.push(UpRightMonitorWidth)
ReturnArray.push(UpRightMonitorHeight)
    if X_Win between %UpRightMonitorX% and %XBound%
        if Y_Win between %UpRightMonitorY% and %YBound%
                Return ReturnArray

    global UpLeftMonitorX, UpLeftMonitorWidth, UpLeftMonitorY, UpLeftMonitorHeight, EdgeForgiveness
    XBound := UpLeftMonitorX + UpLeftMonitorWidth - EdgeForgiveness
    YBound := UpLeftMonitorY + UpLeftMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("UpLeft")
ReturnArray.push(UpLeftMonitorX)
ReturnArray.push(UpLeftMonitorY)
ReturnArray.push(UpLeftMonitorWidth)
ReturnArray.push(UpLeftMonitorHeight)
    if X_Win between %UpLeftMonitorX% and %XBound%
        if Y_Win between %UpLeftMonitorY% and %YBound%
                Return ReturnArray

    global BottomCenterX, BottomMonitorWidth, BottomCenterY, BottomMonitorHeight, EdgeForgiveness
    XBound := BottomCenterX + BottomMonitorWidth - EdgeForgiveness
    YBound := BottomCenterY + BottomMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("Bottom")
ReturnArray.push(BottomCenterX)
ReturnArray.push(BottomCenterY)
ReturnArray.push(BottomMonitorWidth)
ReturnArray.push(BottomMonitorHeight)
    if X_Win between %BottomCenterX% and %XBound%
        if Y_Win between %BottomCenterY% and %YBound%
                Return ReturnArray

    global BottomRightMonitorX, BottomRightMonitorWidth, BottomRightMonitorY, BottomRightMonitorHeight, EdgeForgiveness
    XBound := BottomRightMonitorX + BottomRightMonitorWidth - EdgeForgiveness
    YBound := BottomRightMonitorY + BottomRightMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("BottomRight")
ReturnArray.push(BottomRightMonitorX)
ReturnArray.push(BottomRightMonitorY)
ReturnArray.push(BottomRightMonitorWidth)
ReturnArray.push(BottomRightMonitorHeight)
    if X_Win between %BottomRightMonitorX% and %XBound%
        if Y_Win between %BottomRightMonitorY% and %YBound%
                Return ReturnArray

    global BottomLeftMonitorX, BottomLeftMonitorWidth, BottomLeftMonitorY, BottomLeftMonitorHeight, EdgeForgiveness
    XBound := BottomLeftMonitorX + BottomLeftMonitorWidth - EdgeForgiveness
    YBound := BottomLeftMonitorY + BottomLeftMonitorHeight - EdgeForgiveness
    ReturnArray := []
ReturnArray.push("BottomLeft")
ReturnArray.push(BottomLeftMonitorX)
ReturnArray.push(BottomLeftMonitorY)
ReturnArray.push(BottomLeftMonitorWidth)
ReturnArray.push(BottomLeftMonitorHeight)
    if X_Win between %BottomLeftMonitorX% and %XBound%
        if Y_Win between %BottomLeftMonitorY% and %YBound%
                Return ReturnArray

}

Activate(Monitor)
{
    MonitorX := 0
    MonitorY := 0
    MonitorWidth := 0
    MonitorHeight := 0

    switch Monitor
    {
        case "Middle":
        global EdgeForgivenessX, EdgeForgivenessY, MiddleMonitorWidth, MiddleMonitorHeight
        MonitorX := EdgeForgivenessX
        MonitorY := EdgeForgivenessY
        MonitorWidth := MiddleMonitorWidth
        MonitorHeight := MiddleMonitorHeight

        case "Right":
        global RightEdgeForgivenessX, RightEdgeForgivenessY, RightMonitorWidth, RightMonitorHeight
        MonitorX := RightEdgeForgivenessX
        MonitorY := RightEdgeForgivenessY
        MonitorWidth := RightMonitorWidth
        MonitorHeight := RightMonitorHeight

        case "BottomRight":
        global BottomRightEdgeForgivenessX, BottomRightEdgeForgivenessY, BottomRightMonitorWidth, BottomRightMonitorHeight
        MonitorX := BottomRightEdgeForgivenessX
        MonitorY := BottomRightEdgeForgivenessY
        MonitorWidth := BottomRightMonitorWidth
        MonitorHeight := BottomRightMonitorHeight

        case "Left":
        global LeftEdgeForgivenessX, LeftEdgeForgivenessY, LeftMonitorWidth, LeftMonitorHeight
        MonitorX := LeftEdgeForgivenessX
        MonitorY := LeftEdgeForgivenessY
        MonitorWidth := LeftMonitorWidth
        MonitorHeight := LeftMonitorHeight

        case "BottomLeft":
        global BottomLeftEdgeForgivenessX, BottomLeftEdgeForgivenessY, BottomLeftMonitorWidth, BottomLeftMonitorHeight
        MonitorX := BottomLeftEdgeForgivenessX
        MonitorY := BottomLeftEdgeForgivenessY
        MonitorWidth := BottomLeftMonitorWidth
        MonitorHeight := BottomLeftMonitorHeight

        case "Bottom":
        global BottomEdgeForgivenessX, BottomEdgeForgivenessY, BottomMonitorWidth, BottomMonitorHeight
        MonitorX := BottomEdgeForgivenessX
        MonitorY := BottomEdgeForgivenessY
        MonitorWidth := BottomMonitorWidth
        MonitorHeight := BottomMonitorHeight

        case "UpLeft":
        global UpLeftEdgeForgivenessX, UpLeftEdgeForgivenessY, UpLeftMonitorWidth, UpLeftMonitorHeight
        MonitorX := UpLeftEdgeForgivenessX
        MonitorY := UpLeftEdgeForgivenessY
        MonitorWidth := UpLeftMonitorWidth
        MonitorHeight := UpLeftMonitorHeight

        case "UpRight":
        global UpRightEdgeForgivenessX, UpRightEdgeForgivenessY, UpRightMonitorWidth, UpRightMonitorHeight
        MonitorX := UpRightEdgeForgivenessX
        MonitorY := UpRightEdgeForgivenessY
        MonitorWidth := UpRightMonitorWidth
        MonitorHeight := UpRightMonitorHeight

        case "UpCenter":
        global UpCenterEdgeForgivenessX, UpCenterEdgeForgivenessY, UpCenterMonitorWidth, UpCenterMonitorHeight
        MonitorX := UpCenterEdgeForgivenessX
        MonitorY := UpCenterEdgeForgivenessY
        MonitorWidth := UpCenterMonitorWidth
        MonitorHeight := UpCenterMonitorHeight

    }

    AllWindowIds := GetAllWindowIds()

    FilteredWindowIds := Filter_WindowIds(AllWindowIds)

    ; these are retrieved in the order in which they
    ; stack - index 0 is top (and ahk is 1-indexed)
    WindowIdsInMonitor := GetWindowIdsInMonitor(FilteredWindowIds, MonitorX, MonitorY, MonitorWidth, MonitorHeight)
    TopWindowIdInMonitor := WindowIdsInMonitor[1]

    WinActivate, ahk_id %TopWindowIdInMonitor%

    ;*******
    ;*******
    ; Wiggle
    ;*******
    ;*******
    ; Get the original position of the window
    VarSetCapacity(rect, 16)
    DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect)
    originalX := NumGet(rect, 0, "Int")
    originalY := NumGet(rect, 4, "Int")
    ; Constants for the circle movement
    radius := 5
    step := 90  ; Degrees of each step, smaller = smoother
    steps := 360 / step  ; Number of steps for a full circle
    pi := 3.14159
    ; Perform the circular movement
    Loop % steps
    {
        ; make sure i didn't move the window while it was wiggling
        VarSetCapacity(rect_test, 16)
        DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect_test)
        test_X := NumGet(rect_test, 0, "Int")
        test_Y := NumGet(rect_test, 4, "Int")
        test_X := Abs(originalX - test_X)
        test_Y := Abs(originalY - test_Y)
        test_step := step * 4
        if (test_X > test_step || test_Y > test_step) {
            break
        }
        ; make sure i didn't switch windows while it was wiggling
        CurrentActiveTest := WinActive("A")
        if !(CurrentActiveTest = TopWindowIdInMonitor) {
            break
        }
        ; convert the step to radians
        rad := A_Index * step * pi / 180
        ; Calculate the new position
        new_X := originalX + radius * Cos(rad)
        new_Y := originalY + radius * Sin(rad)
        ; Set the new_ position
        DllCall("SetWindowPos", "Ptr", TopWindowIdInMonitor, "Ptr", 0, "Int", new_X, "Int", new_Y, "Int", 0, "Int", 0, "UInt", 0x15)  ; SWP_NOZORDER = 0x4 | SWP_NOSIZE = 0x1 | SWP_NOACTIVATE = 0x10
        ; Wait some time before the next move
        Sleep, 3
    }
    ; (this duplicate code should be collapsed)
    ; make sure i didn't move the window while it was wiggling
    VarSetCapacity(rect_test, 16)
    DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect_test)
    test_X := NumGet(rect_test, 0, "Int")
    test_Y := NumGet(rect_test, 4, "Int")
    test_X := Abs(originalX - test_X)
    test_Y := Abs(originalY - test_Y)
    test_step := step * 4
    if !(test_X > test_step || test_Y > test_step) {
        ; make sure i didn't switch windows while it was wiggling
        CurrentActiveTest := WinActive("A")
        if (CurrentActiveTest = TopWindowIdInMonitor) {
            ; Reset the window to the original position
            DllCall("SetWindowPos", "Ptr", TopWindowIdInMonitor, "Ptr", 0, "Int", originalX, "Int", originalY, "Int", 0, "Int", 0, "UInt", 0x15)  ; SWP_NOZORDER = 0x4 | SWP_NOSIZE = 0x1 | SWP_NOACTIVATE = 0x10
        }
    }

    ; ActiveWindow := WinActive("A")
    ; DllCall("FlashWindow", UInt, ActiveWindow, Int, True)
}

MoveTo(Monitor)
{
    MonitorX := 0
    MonitorY := 0
    MonitorWidth := 0
    MonitorHeight := 0

    switch Monitor
    {
        case "Middle":
        global MiddleMonitorX, MiddleMonitorY, MiddleMonitorWidth, MiddleMonitorHeight
        MonitorX := MiddleMonitorX
        MonitorY := MiddleMonitorY
        MonitorWidth := MiddleMonitorWidth
        MonitorHeight := MiddleMonitorHeight

        case "Right":
        global RightMonitorX, RightMonitorY, RightMonitorWidth, RightMonitorHeight
        MonitorX := RightMonitorX
        MonitorY := RightMonitorY
        MonitorWidth := RightMonitorWidth
        MonitorHeight := RightMonitorHeight

        case "BottomRight":
        global BottomRightMonitorX, BottomRightMonitorY, BottomRightMonitorWidth, BottomRightMonitorHeight
        MonitorX := BottomRightMonitorX
        MonitorY := BottomRightMonitorY
        MonitorWidth := BottomRightMonitorWidth
        MonitorHeight := BottomRightMonitorHeight

        case "Left":
        global LeftMonitorX, LeftMonitorY, LeftMonitorWidth, LeftMonitorHeight
        MonitorX := LeftMonitorX
        MonitorY := LeftMonitorY
        MonitorWidth := LeftMonitorWidth
        MonitorHeight := LeftMonitorHeight

        case "BottomLeft":
        global BottomLeftMonitorX, BottomLeftMonitorY, BottomLeftMonitorWidth, BottomLeftMonitorHeight
        MonitorX := BottomLeftMonitorX
        MonitorY := BottomLeftMonitorY
        MonitorWidth := BottomLeftMonitorWidth
        MonitorHeight := BottomLeftMonitorHeight

        case "Bottom":
        global BottomMonitorX, BottomMonitorY, BottomMonitorWidth, BottomMonitorHeight
        MonitorX := BottomMonitorX
        MonitorY := BottomMonitorY
        MonitorWidth := BottomMonitorWidth
        MonitorHeight := BottomMonitorHeight

        case "UpLeft":
        global UpLeftMonitorX, UpLeftMonitorY, UpLeftMonitorWidth, UpLeftMonitorHeight
        MonitorX := UpLeftMonitorX
        MonitorY := UpLeftMonitorY
        MonitorWidth := UpLeftMonitorWidth
        MonitorHeight := UpLeftMonitorHeight

        case "UpRight":
        global UpRightMonitorX, UpRightMonitorY, UpRightMonitorWidth, UpRightMonitorHeight
        MonitorX := UpRightMonitorX
        MonitorY := UpRightMonitorY
        MonitorWidth := UpRightMonitorWidth
        MonitorHeight := UpRightMonitorHeight

        case "UpCenter":
        global UpCenterMonitorX, UpCenterMonitorY, UpCenterMonitorWidth, UpCenterMonitorHeight
        MonitorX := UpCenterMonitorX
        MonitorY := UpCenterMonitorY
        MonitorWidth := UpCenterMonitorWidth
        MonitorHeight := UpCenterMonitorHeight

    }
    WinMove, A, , MonitorX, MonitorY, MonitorWidth, MonitorHeight
}

SwapWith(Monitor)
{

    WinGetPos, FromX, FromY, FromWidth, FromHeight, A
    MovingFrom := WinExist("A")

    switch Monitor
    {
        case "Middle":
        Activate("Middle")

        case "Right":
        Activate("Right")

        case "BottomRight":
        Activate("BottomRight")

        case "Left":
        Activate("Left")

        case "BottomLeft":
        Activate("BottomLeft")

        case "Bottom":
        Activate("Bottom")

        case "UpLeft":
        Activate("UpLeft")

        case "UpRight":
        Activate("UpRight")

        case "UpCenter":
        Activate("UpCenter")

    }

    WinGetPos, ToX, ToY, ToWidth, ToHeight, A
    MovingTo := WinExist("A")

    if (MovingFrom = MovingTo)
    {
MoveTo(Monitor)
    } else
    {

        WinMove, ahk_id %MovingTo%, , FromX, FromY, FromWidth, FromHeight
        WinMove, ahk_id %MovingFrom%, , ToX, ToY, ToWidth, ToHeight

        switch Monitor
        {
            case "Middle":
            Activate("Middle")

            case "Right":
            Activate("Right")

            case "BottomRight":
            Activate("BottomRight")

            case "Left":
            Activate("Left")

            case "BottomLeft":
            Activate("BottomLeft")

            case "Bottom":
            Activate("Bottom")

            case "UpLeft":
            Activate("UpLeft")

            case "UpRight":
            Activate("UpRight")

            case "UpCenter":
            Activate("UpCenter")

        }

    }
}

SubTopLeft()
{
    CurrentMonitor := GetMonitor()
    CurrentMonitorName := CurrentMonitor[1]
    CurrentMonitorX := CurrentMonitor[2]
    CurrentMonitorY := CurrentMonitor[3]
    CurrentMonitorWidth := CurrentMonitor[4]
    CurrentMonitorHeight := CurrentMonitor[5]

    global EdgeForgiveness
    SubTopLeftX := CurrentMonitorX - EdgeForgiveness
    SubTopLeftY := CurrentMonitorY - EdgeForgiveness
    SubTopLeftWidth := CurrentMonitorWidth / 2
    SubTopLeftHeight := CurrentMonitorHeight / 2

    ActivateSub(SubTopLeftX, SubTopLeftY, SubTopLeftWidth, SubTopLeftHeight)
}

SubTopRight()
{
    CurrentMonitor := GetMonitor()
    CurrentMonitorName := CurrentMonitor[1]
    CurrentMonitorX := CurrentMonitor[2]
    CurrentMonitorY := CurrentMonitor[3]
    CurrentMonitorWidth := CurrentMonitor[4]
    CurrentMonitorHeight := CurrentMonitor[5]

    global EdgeForgiveness
    SubTopRightWidth := CurrentMonitorWidth / 2
    SubTopRightHeight := CurrentMonitorHeight / 2
    SubTopRightX := CurrentMonitorX - EdgeForgiveness + SubTopRightWidth
    SubTopRightY := CurrentMonitorY - EdgeForgiveness

    ActivateSub(SubTopRightX, SubTopRightY, SubTopRightWidth, SubTopRightHeight)
}

SubBottomLeft()
{
    CurrentMonitor := GetMonitor()
    CurrentMonitorName := CurrentMonitor[1]
    CurrentMonitorX := CurrentMonitor[2]
    CurrentMonitorY := CurrentMonitor[3]
    CurrentMonitorWidth := CurrentMonitor[4]
    CurrentMonitorHeight := CurrentMonitor[5]

    global EdgeForgiveness
    SubBottomLeftWidth := CurrentMonitorWidth / 2
    SubBottomLeftHeight := CurrentMonitorHeight / 2
    SubBottomLeftX := CurrentMonitorX - EdgeForgiveness
    SubBottomLeftY := CurrentMonitorY - EdgeForgiveness + SubBottomLeftHeight

    ActivateSub(SubBottomLeftX, SubBottomLeftY, SubBottomLeftWidth, SubBottomLeftHeight)
}

SubBottomRight()
{
    CurrentMonitor := GetMonitor()
    CurrentMonitorName := CurrentMonitor[1]
    CurrentMonitorX := CurrentMonitor[2]
    CurrentMonitorY := CurrentMonitor[3]
    CurrentMonitorWidth := CurrentMonitor[4]
    CurrentMonitorHeight := CurrentMonitor[5]

    global EdgeForgiveness
    SubBottomRightWidth := CurrentMonitorWidth / 2
    SubBottomRightHeight := CurrentMonitorHeight / 2
    SubBottomRightX := CurrentMonitorX - EdgeForgiveness + SubBottomRightWidth
    SubBottomRightY := CurrentMonitorY - EdgeForgiveness + SubBottomRightHeight

    ActivateSub(SubBottomRightX, SubBottomRightY, SubBottomRightWidth, SubBottomRightHeight)
}

ActivateSub(MonitorX, MonitorY, MonitorWidth, MonitorHeight)
{
    ; *********************************************************************************
    ; *********************************************************************************
    ; this code was taken verbatim from Activate(Monitor) and should be modified there.
    ; *********************************************************************************
    ; *********************************************************************************

    AllWindowIds := GetAllWindowIds()

    FilteredWindowIds := Filter_WindowIds(AllWindowIds)

    ; these are retrieved in the order in which they stack - index 0 is top (and ahk is 1-indexed)
    WindowIdsInMonitor := GetWindowIdsInMonitor(FilteredWindowIds, MonitorX, MonitorY, MonitorWidth, MonitorHeight)
    TopWindowIdInMonitor := WindowIdsInMonitor[1]

    WinActivate, ahk_id %TopWindowIdInMonitor%

    ;*******
    ;*******
    ; Wiggle
    ;*******
    ;*******
    ; Get the original position of the window
    VarSetCapacity(rect, 16)
    DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect)
    originalX := NumGet(rect, 0, "Int")
    originalY := NumGet(rect, 4, "Int")
    ; Constants for the circle movement
    radius := 5
    step := 90  ; Degrees of each step, smaller = smoother
    steps := 360 / step  ; Number of steps for a full circle
    pi := 3.14159
    ; Perform the circular movement
    Loop % steps
    {
        ; make sure i didn't move the window while it was wiggling
        VarSetCapacity(rect_test, 16)
        DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect_test)
        test_X := NumGet(rect_test, 0, "Int")
        test_Y := NumGet(rect_test, 4, "Int")
        test_X := Abs(originalX - test_X)
        test_Y := Abs(originalY - test_Y)
        test_step := step * 4
        if (test_X > test_step || test_Y > test_step) {
            break
        }
        ; convert the step to radians
        rad := A_Index * step * pi / 180
        ; Calculate the new position
        new_X := originalX + radius * Cos(rad)
        new_Y := originalY + radius * Sin(rad)
        ; Set the new_ position
        DllCall("SetWindowPos", "Ptr", TopWindowIdInMonitor, "Ptr", 0, "Int", new_X, "Int", new_Y, "Int", 0, "Int", 0, "UInt", 0x15)  ; SWP_NOZORDER = 0x4 | SWP_NOSIZE = 0x1 | SWP_NOACTIVATE = 0x10
        ; Wait some time before the next move
        Sleep, 3
    }
    ; (this duplicate code should be collapsed)
    ; make sure i didn't move the window while it was wiggling
    VarSetCapacity(rect_test, 16)
    DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect_test)
    test_X := NumGet(rect_test, 0, "Int")
    test_Y := NumGet(rect_test, 4, "Int")
    test_X := Abs(originalX - test_X)
    test_Y := Abs(originalY - test_Y)
    test_step := step * 4
    if !(test_X > test_step || test_Y > test_step) {
        ; Reset the window to the original position
        DllCall("SetWindowPos", "Ptr", TopWindowIdInMonitor, "Ptr", 0, "Int", originalX, "Int", originalY, "Int", 0, "Int", 0, "UInt", 0x15)  ; SWP_NOZORDER = 0x4 | SWP_NOSIZE = 0x1 | SWP_NOACTIVATE = 0x10
    }

    ; this code was taken verbatim from ActivateSub(MonitorX, MonitorY, MonitorWidth, MonitorHeight)
    ;*******
    ;*******
    ; Wiggle
    ;*******
    ;*******
    ; Get the original position of the window
    VarSetCapacity(rect, 16)
    DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect)
    originalX := NumGet(rect, 0, "Int")
    originalY := NumGet(rect, 4, "Int")
    ; Constants for the circle movement
    radius := 5
    step := 90  ; Degrees of each step, smaller = smoother
    steps := 360 / step  ; Number of steps for a full circle
    pi := 3.14159
    ; Perform the circular movement
    Loop % steps
    {
        ; make sure i didn't move the window while it was wiggling
        VarSetCapacity(rect_test, 16)
        DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect_test)
        test_X := NumGet(rect_test, 0, "Int")
        test_Y := NumGet(rect_test, 4, "Int")
        test_X := Abs(originalX - test_X)
        test_Y := Abs(originalY - test_Y)
        test_step := step * 4
        if (test_X > test_step || test_Y > test_step) {
            break
        }
        ; make sure i didn't switch windows while it was wiggling
        CurrentActiveTest := WinActive("A")
        if !(CurrentActiveTest = TopWindowIdInMonitor) {
            break
        }
        ; convert the step to radians
        rad := A_Index * step * pi / 180
        ; Calculate the new position
        new_X := originalX + radius * Cos(rad)
        new_Y := originalY + radius * Sin(rad)
        ; Set the new_ position
        DllCall("SetWindowPos", "Ptr", TopWindowIdInMonitor, "Ptr", 0, "Int", new_X, "Int", new_Y, "Int", 0, "Int", 0, "UInt", 0x15)  ; SWP_NOZORDER = 0x4 | SWP_NOSIZE = 0x1 | SWP_NOACTIVATE = 0x10
        ; Wait some time before the next move
        Sleep, 3
    }
    ; (this duplicate code should be collapsed)
    ; make sure i didn't move the window while it was wiggling
    VarSetCapacity(rect_test, 16)
    DllCall("GetWindowRect", "Ptr", TopWindowIdInMonitor, "Ptr", &rect_test)
    test_X := NumGet(rect_test, 0, "Int")
    test_Y := NumGet(rect_test, 4, "Int")
    test_X := Abs(originalX - test_X)
    test_Y := Abs(originalY - test_Y)
    test_step := step * 4
    if !(test_X > test_step || test_Y > test_step) {
        ; make sure i didn't switch windows while it was wiggling
        CurrentActiveTest := WinActive("A")
        if (CurrentActiveTest = TopWindowIdInMonitor) {
            ; Reset the window to the original position
            DllCall("SetWindowPos", "Ptr", TopWindowIdInMonitor, "Ptr", 0, "Int", originalX, "Int", originalY, "Int", 0, "Int", 0, "UInt", 0x15)  ; SWP_NOZORDER = 0x4 | SWP_NOSIZE = 0x1 | SWP_NOACTIVATE = 0x10
        }
    }

}