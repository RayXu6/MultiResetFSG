# MultiResetReborn (Rework of [Specnr's MultiResetRSG](https://gist.github.com/Specnr/c851a92a258dd1fdbe3eee588f3f14d8))
Support Specnr (original macro author)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/specnr)

## Setup Video

Watch the [NEW Multi Instance Setup Video](https://youtu.be/0xAHMW93MQw)

The setup for this macro is almost identical to Specnr's, as it uses a lot of his code. Any differences are mentioned in the details below!

## Better Settings & Hotkeys

The settings and hotkey binds are easily accessible in their own files, in the base folder of the macro download.

Edit the values in these files to change your settings and binds.

You can add new binds (e.g. if you have more than 4 instances) if you just follow the patterns of existing ones.

## Basic Usage

Start up the macro by running MultiResetReborn.ahk.

Wait for it to say ready, then click the AutoReset gold boots on your first instance. Reset using U or your set hotkey, repeat until all of your instances are resetting.

## Background Resetting

When in-game, you can reset other instances in the background. To do this, I'd advise:

- Right click on your verification scene in OBS scene list
- Open a windowed projector
- Make it small, put it somewhere convenient
- Right click it -> select stay on top

Alternatively:

- In each of your instance scenes, place small window captures for the rest of your instances in a corner or edge
- View your obs/stream/etc in some way (2nd monitor, phone, etc.)

## Other extra features

- Borderless: Like fullscreen, but less annoying and easier for OBS to capture. May have more input lag than fullscreen, but try it out.
- Coop resets: When enabled, the macro will open to lan (with cheats on) and type (but not send) "/time set 0" when you play an instance. I may fine tune the behaviour of this feature, let me know if you'd rather it do something slightly different.
- Unpause on switch: Unpause or don't unpause when you play an instance
- Auto-bop: Automatically deletes old worlds when you load up the macro. I intend to improve the safety of this feature in the future in regards to accidental activation.

No longer actively moves worlds, it slows down the macro a lot. Use [this world moving macro](https://gist.github.com/Specnr/f7a5450d932a1277fdcd6c141ad7bf6a).

## OBS Websocket

1) Download [Python](https://www.python.org/downloads/)
2) Install [OBS websocket](https://obsproject.com/forum/resources/obs-websocket-remote-control-obs-studio-from-websockets.466/)
3) Open up command prompt, and run this command in `pip install obs-websocket-py`
4) Now, open up obs.py in whatever text editor you want. 
5) For scene_name_format you want to put in whatever the prefix of all your scenes are. 
6) Now, for the password, you can put in a password if you want, and if you use it you can go to `Tools -> WebSockets Server Settings -> Enable Authentication` and then put in whatever password you want. Then you can put the same password in the password variable quotes.

After that it should be working. Ping @Tech Support in the [Discord](https://discord.gg/tXxwrYw) if you have any issues.

## Credit

- Specnr for originally authoring this macro
- Me (Ravalle/Joe) for this rework
- Algorythm for always backseating my code
- jojoe77777 for making the original multi instance macro
