ScreenWidth := 1920
ScreenHeight := 1080
EdgeForgiveness := 50

RightMonitorX := ScreenWidth
RightMonitorY := 0
RightMonitorWidth := ScreenHeight
RightMonitorHeight := ScreenWidth
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

FarRightMonitorX := ScreenWidth + ScreenHeight
FarRightMonitorY := 0
FarRightMonitorWidth := ScreenHeight
FarRightMonitorHeight := ScreenWidth
FarRightCenterX := FarRightMonitorX + FarRightMonitorWidth / 2
FarRightCenterY := FarRightMonitorY + FarRightMonitorHeight / 2
FarRightEdgeForgivenessX := FarRightMonitorX - EdgeForgiveness
FarRightEdgeForgivenessY := FarRightMonitorY - EdgeForgiveness

LeftMonitorX := 0 - ScreenHeight
LeftMonitorY := 0
LeftMonitorWidth := ScreenHeight
LeftMonitorHeight := ScreenWidth
LeftCenterX := LeftMonitorX + LeftMonitorWidth / 2
LeftCenterY := LeftMonitorY + LeftMonitorHeight / 2
LeftEdgeForgivenessX := LeftMonitorX - EdgeForgiveness
LeftEdgeForgivenessY := LeftMonitorY - EdgeForgiveness

FarLeftMonitorX := 0 - ScreenHeight * 2
FarLeftMonitorY := 0
FarLeftMonitorWidth := ScreenHeight
FarLeftMonitorHeight := ScreenWidth
FarLeftCenterX := FarLeftMonitorX + FarLeftMonitorWidth / 2
FarLeftCenterY := FarLeftMonitorY + FarLeftMonitorHeight / 2
FarLeftEdgeForgivenessX := FarLeftMonitorX - EdgeForgiveness
FarLeftEdgeForgivenessY := FarLeftMonitorY - EdgeForgiveness

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

ReadingMonitorX := 0
ReadingMonitorY := 0 - ScreenHeight
ReadingMonitorWidth := ScreenWidth
ReadingMonitorHeight := 3 * ScreenHeight
ReadingCenterX := ReadingMonitorX + ReadingMonitorWidth / 2
ReadingCenterY := ReadingMonitorY + ReadingMonitorHeight / 2
ReadingEdgeForgivenessX := ReadingMonitorX - EdgeForgiveness
ReadingEdgeForgivenessY := ReadingMonitorY - EdgeForgiveness

FullMonitorX := 0 - ScreenWidth
FullMonitorY := 0 - ScreenHeight
FullMonitorWidth := 3 * ScreenWidth
FullMonitorHeight := ScreenHeight + ScreenWidth
FullCenterX := FullMonitorX + FullMonitorWidth / 2
FullCenterY := FullMonitorY + FullMonitorHeight / 2
FullEdgeForgivenessX := FullMonitorX - EdgeForgiveness
FullEdgeForgivenessY := FullMonitorY - EdgeForgiveness

; specifically for tiktok... this is no longer used and needs to be removed
TokMonitorX := 0
TokMonitorY := 0 - 500
TokMonitorWidth := ScreenWidth
TokMonitorHeight := 2 * ScreenHeight
TokCenterX := TokMonitorX + TokMonitorWidth / 2
TokCenterY := TokMonitorY + TokMonitorHeight / 2
TokEdgeForgivenessX := TokMonitorX - EdgeForgiveness
TokEdgeForgivenessY := TokMonitorY - EdgeForgiveness

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

        case "FarRight":
        global FarRightEdgeForgivenessX, FarRightEdgeForgivenessY, FarRightMonitorWidth, FarRightMonitorHeight
        MonitorX := FarRightEdgeForgivenessX
        MonitorY := FarRightEdgeForgivenessY
        MonitorWidth := FarRightMonitorWidth
        MonitorHeight := FarRightMonitorHeight

        case "Left":
        global LeftEdgeForgivenessX, LeftEdgeForgivenessY, LeftMonitorWidth, LeftMonitorHeight
        MonitorX := LeftEdgeForgivenessX
        MonitorY := LeftEdgeForgivenessY
        MonitorWidth := LeftMonitorWidth
        MonitorHeight := LeftMonitorHeight

        case "FarLeft":
        global FarLeftEdgeForgivenessX, FarLeftEdgeForgivenessY, FarLeftMonitorWidth, FarLeftMonitorHeight
        MonitorX := FarLeftEdgeForgivenessX
        MonitorY := FarLeftEdgeForgivenessY
        MonitorWidth := FarLeftMonitorWidth
        MonitorHeight := FarLeftMonitorHeight

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

        case "Reading":
        global ReadingEdgeForgivenessX, ReadingEdgeForgivenessY, ReadingMonitorWidth, ReadingMonitorHeight
        MonitorX := ReadingEdgeForgivenessX
        MonitorY := ReadingEdgeForgivenessY
        MonitorWidth := ReadingMonitorWidth
        MonitorHeight := ReadingMonitorHeight

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

        case "FarRight":
        global FarRightMonitorX, FarRightMonitorY, FarRightMonitorWidth, FarRightMonitorHeight
        MonitorX := FarRightMonitorX
        MonitorY := FarRightMonitorY
        MonitorWidth := FarRightMonitorWidth
        MonitorHeight := FarRightMonitorHeight

        case "Left":
        global LeftMonitorX, LeftMonitorY, LeftMonitorWidth, LeftMonitorHeight
        MonitorX := LeftMonitorX
        MonitorY := LeftMonitorY
        MonitorWidth := LeftMonitorWidth
        MonitorHeight := LeftMonitorHeight

        case "FarLeft":
        global FarLeftMonitorX, FarLeftMonitorY, FarLeftMonitorWidth, FarLeftMonitorHeight
        MonitorX := FarLeftMonitorX
        MonitorY := FarLeftMonitorY
        MonitorWidth := FarLeftMonitorWidth
        MonitorHeight := FarLeftMonitorHeight

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

        case "Reading":
        global ReadingMonitorX, ReadingMonitorY, ReadingMonitorWidth, ReadingMonitorHeight
        MonitorX := ReadingMonitorX
        MonitorY := ReadingMonitorY
        MonitorWidth := ReadingMonitorWidth
        MonitorHeight := ReadingMonitorHeight

        case "Full":
        global FullMonitorX, FullMonitorY, FullMonitorWidth, FullMonitorHeight
        MonitorX := FullMonitorX
        MonitorY := FullMonitorY
        MonitorWidth := FullMonitorWidth
        MonitorHeight := FullMonitorHeight

        case "Tok":
        global TokMonitorX, TokMonitorY, TokMonitorWidth, TokMonitorHeight
        MonitorX := TokMonitorX
        MonitorY := TokMonitorY
        MonitorWidth := TokMonitorWidth
        MonitorHeight := TokMonitorHeight

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

        case "FarRight":
        Activate("FarRight")

        case "Left":
        Activate("Left")

        case "FarLeft":
        Activate("FarLeft")

        case "Bottom":
        Activate("Bottom")

        case "UpLeft":
        Activate("UpLeft")

        case "UpRight":
        Activate("UpRight")

        case "UpCenter":
        Activate("UpCenter")

        case "Reading":
        Activate("Reading")
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

        case "FarRight":
        Activate("FarRight")

        case "Left":
        Activate("Left")

        case "FarLeft":
        Activate("FarLeft")

        case "Bottom":
        Activate("Bottom")

        case "UpLeft":
        Activate("UpLeft")

        case "UpRight":
        Activate("UpRight")

        case "UpCenter":
        Activate("UpCenter")

        case "Reading":
        Activate("Reading")
    }
}