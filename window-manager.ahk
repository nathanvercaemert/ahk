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

LeftMonitorX := 0 - ScreenHeight
LeftMonitorY := 0
LeftMonitorWidth := ScreenHeight
LeftMonitorHeight := ScreenWidth
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
        WinGetTitle Title, ahk_id %Id%
        if (Title != "") && (Title != "ZPToolBarParentWnd") && (Title != "JamPostMessageWindow")
        {
            AllWindowIds.Push(Id)
        }
    }

    ; ; for finding names to blacklist:
    ; ;
    ; ; if something says it's there and it's not actually,
    ; ; add to blacklist above
    ; ;
    ; Output := ""
    ; for Index, WindowId in AllWindowIds
    ; {
    ;     Id := WindowId
    ;     WinGetTitle Title, ahk_id %Id%
    ;     WinGetClass Class, ahk_id %Id%
    ;     WinGetPos, Xpos, Ypos, W, H, ahk_id %Id%
    ;     Output = %Output%%Xpos%,%Ypos%,%Class%,%Title%`n
    ; }
    ; MsgBox, %Output%
    ; return []

    return AllWindowIds
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

    ; these are retrieved in the order in which they
    ; stack - index 0 is top
    WindowIdsInMonitor := GetWindowIdsInMonitor(AllWindowIds, MonitorX, MonitorY, MonitorWidth, MonitorHeight)
    TopWindowIdInMonitor := WindowIdsInMonitor[1]

    WinActivate, ahk_id %TopWindowIdInMonitor%
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