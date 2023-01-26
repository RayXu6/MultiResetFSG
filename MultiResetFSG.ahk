; A Multi-Instance macro for Minecraft
; By Specnr, reworked by Ravalle
; v0.1.2

SetWorkingDir, %A_ScriptDir%
#NoEnv
#WinActivateForce
#SingleInstance Force
#Include Settings.ahk
#Include scripts/MultiFunctions.ahk

SetKeyDelay, 0
SetWinDelay, 1
SetTitleMatchMode, 2

global currentInstance := 0

if (performanceMethod == "F") {
    UnsuspendAll()
    Sleep, %restartDelay%
}
GetAllPIDs(McDirectories, PIDs, instances)

for i, mcdir in McDirectories {
    if (autoBop) {
        cmd := Format("python.exe " . A_ScriptDir . "\scripts\worldBopper9000.py {1}", mcdir)
        Run, %cmd%,, Hide
    }

    idle := mcdir . "idle.tmp"
    if (!FileExist(idle))
        FileAppend,,%idle%
    
    pid := PIDs[i]
    if (borderless) {
        WinSet, Style, -0xC40000, ahk_pid %pid%
        WinMaximize, ahk_pid %pid%
    }
    if (wideResets) {
        WinRestore, ahk_pid %pid%
        WinMove, ahk_pid %pid%,,0,0,%A_ScreenWidth%,%A_ScreenHeight%
        newHeight := Floor(A_ScreenHeight / 2.5)
        WinMove, ahk_pid %pid%,,0,0,%A_ScreenWidth%,%newHeight%
    }
    if (affinity) {
        SetAffinity(pid, highBitMask)
    }

    WinSet, AlwaysOnTop, Off, ahk_pid %pid%
}

NextInstance()
Sleep, 500
SetTitles()

if (!disableTTS)
    ComObjCreate("SAPI.SpVoice").Speak("Ready")

if (performanceMethod == "F")
    SetTimer, FreezeInstances, 20

Reset() {
    ExitWorld()
    NextInstance()
}

NextInstance() {
    idle := False
    while (idle == False) {
        ; increment
        currentInstance++
        if (currentInstance > instances)
            currentInstance := 1

        ; check if instance idle (fully reset)
        idleCheck := McDirectories[currentInstance] . "idle.tmp"
        if (FileExist(idleCheck))
            idle := True
    }
    
    SwitchInstance(currentInstance)
}

GoToActiveInstance() {
    pid := PIDs[currentInstance]
    WinSet, AlwaysOnTop, On, ahk_pid %pid%
    WinSet, AlwaysOnTop, Off, ahk_pid %pid%
}

BackgroundReset(idx) {
    ResetInstance(idx, True)
}

global next_seed := ""
global token := ""
global timestamp := 0

IfNotExist, fsg_tokens
    FileCreateDir, fsg_tokens

;UPDATE THIS TO YOUR MINECRAFT SAVES FOLDER
global SavesDirectory := "D:\MultiMC\instances\FSG\.minecraft\saves" ; Replace this with your minecraft saves
global titleScreenDelay := 0 ; 0 = GIGACHAD, increase if skips over title screen
global delay := 5 ; Fine tune for your PC/comfort level (Each screen needs to be visible for at least a frame)

getMostRecentFile()
{
    counter := 0
    Loop, Files, %SavesDirectory%\*.*, D
    {
        if (A_LoopFileShortName == "speedrunigt")
            continue
        counter += 1
        if (counter = 1)
        {
            maxTime := A_LoopFileTimeModified
            mostRecentFile := A_LoopFileLongPath
        }
        if (A_LoopFileTimeModified >= maxTime)
        {
            maxTime := A_LoopFileTimeModified
            mostRecentFile := A_LoopFileLongPath
        }
    }
   if (counter == 0) {
      return "NO_SAVE"
   }
   recentFile := mostRecentFile
   return (recentFile)
}

onTitleScreen()
{
  lastWorld := getMostRecentFile()
  if (lastWorld == "NO_SAVE") { ; empty saves folder
    return true
  }
  lockFile := lastWorld . "\session.lock"
  FileRead, sessionlockfile, %lockFile%
  if (ErrorLevel = 0)
  {
    return true
  }
  return false
}

GenerateSeed() {
    fsg_seed_token := RunHide("wsl.exe python3 ./findSeed.py")
    timestamp := A_NowUTC
    fsg_seed_token_array := StrSplit(fsg_seed_token, ["Seed Found", "Temp Token"])
    fsg_seed_array := StrSplit(fsg_seed_token_array[2], A_Space)
    fsg_seed := Trim(fsg_seed_array[2])
    return {seed: fsg_seed, token: fsg_seed_token}
}

FindSeed(resetFromWorld){
    if (next_seed = "" || (A_NowUTC - timestamp > 30 && !resetFromWorld)) {
        output := GenerateSeed()
        next_seed := output["seed"]
        token := output["token"]
        ComObjCreate("SAPI.SpVoice").Speak("Seed Found")
    }
    clipboard = %next_seed%

    WinActivate, Minecraft*
    FSGFastCreateWorld()
    if FileExist("fsg_seed_token.txt"){
        FileMoveDir, fsg_seed_token.txt, fsg_tokens\fsg_seed_token_%A_NowUTC%.txt, R
    }
    FileAppend, %token%, fsg_seed_token.txt
    output := GenerateSeed()
    next_seed := output["seed"]
    token := output["token"]
}

GetSeed() {
  WinGetActiveTitle, Title
  IfNotInString Title, -
    FindSeed(False)()
  else {
    ExitWorld()
    while (!onTitleScreen()) {
      Sleep, 1
    }
    FindSeed(True)
  }
}

FSGFastCreateWorld(){
    SetKeyDelay, 0
    send {Esc 3}
    send {Shift Down}{Tab}{Enter}{Shift Up}
    send ^a
    send ^v
    send {Tab 5}
    send {Enter}
    SetKeyDelay, delay
    send {Shift Down}{Tab}{Shift Up}{Enter}
}
#Include Hotkeys.ahk

return

FreezeInstances:
    Critical
        if (performanceMethod == "F") {
            Loop, %instances% {
                rIdx := A_Index
                idleCheck := McDirectories[rIdx] . "idle.tmp"
                if (rIdx != currentInstance && resetIdx[rIdx] && FileExist(idleCheck) && (A_TickCount - resetScriptTime[i]) > scriptBootDelay) {
                    SuspendInstance(PIDs[rIdx])
                    resetScriptTime[i] := 0
                    resetIdx[rIdx] := False
                }
            }
        }
return