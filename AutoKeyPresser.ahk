#Requires AutoHotkey v2.0
#SingleInstance Force

; Global variables
toggle := false
settingsFile := A_ScriptDir "\settings.ini"
interval := 1
keyToPress := "e"

; Load saved settings if available
if FileExist(settingsFile) {
    keyToPress := IniRead(settingsFile, "Settings", "Key", "e")
    interval := IniRead(settingsFile, "Settings", "Interval", "1")
}

; GUI
myGui := Gui()
myGui.Title := "KeyPresser"  ; <- Updated window title

myGui.Add("Text",, "Key to press:")
keyInput := myGui.Add("Edit", "w150", keyToPress)

myGui.Add("Text",, "Interval (ms):")
intervalInput := myGui.Add("Edit", "w150", interval)

startBtn := myGui.Add("Button", "w70", "F6")
stopBtn := myGui.Add("Button", "w70", "F7")
exitBtn := myGui.Add("Button", "w70", "F8")

startBtn.OnEvent("Click", StartPressing)
stopBtn.OnEvent("Click", StopPressing)
exitBtn.OnEvent("Click", (*) => ExitApp())

myGui.Show()

; Timer function
PressKey() {
    global keyToPress
    Send("{" keyToPress "}")
}

StartPressing(*) {
    global toggle, interval, keyToPress, keyInput, intervalInput, settingsFile

    keyToPress := keyInput.Value
    interval := intervalInput.Value

    if (!RegExMatch(interval, "^\d+$")) {
        MsgBox("Please enter a valid number for interval.")
        return
    }

    ; Save settings
    IniWrite(keyToPress, settingsFile, "Settings", "Key")
    IniWrite(interval, settingsFile, "Settings", "Interval")

    toggle := true
    SetTimer(PressKey, interval)
}

StopPressing(*) {
    global toggle
    toggle := false
    SetTimer(PressKey, 0)
}

; Hotkeys
F6::StartPressing()
F7::StopPressing()
F8::ExitApp
