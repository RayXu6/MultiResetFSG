from obswebsocket import obsws, requests
import sys

host = "localhost"
port = 4444
password = "Multi"  # Edit this if you use a password (reccomended)
scene_name_format = "Instance "  # Edit this

ws = obsws(host, port, password)
ws.connect()
scenes = ws.call(requests.GetSceneList())
ws.call(requests.SetCurrentScene(f"{scene_name_format}{sys.argv[1]}"))
ws.disconnect()
