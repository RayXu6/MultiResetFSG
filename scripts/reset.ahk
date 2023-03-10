; v0.1.2
#Include ../FSG_Atum_Macro Faster.ahk 
#NoEnv
SetKeyDelay, 0
global 1

resetSounds = %7%
if (resetSounds)
    SoundPlay, A_ScriptDir\..\media\reset.wav

GetSeed()

Sleep, 1000
while (True) {
    WinGetTitle, title, ahk_pid %1%
    if (InStr(title, " - "))
        break
}

while (True) {
    numLines := 0
    Loop, Read, %2%
    {
        numLines += 1
    }
    saved := False
    Loop, Read, %2%
    {
        if ((numLines - A_Index) < 5) {
            if (InStr(A_LoopReadLine, "Loaded 0") || (InStr(A_LoopReadLine, "Saving chunks for level 'ServerLevel") && InStr(A_LoopReadLine, "minecraft:the_end"))) {
                saved := True
                break
            }
        }
    }
    if (saved || A_Index > %3%)
        break
}

Sleep, %6%
ControlSend, ahk_parent, {Blind}{F3 Down}{Esc}{F3 Up}, ahk_pid %1%
Sleep, %4%
FileAppend,, %5%
ExitApp