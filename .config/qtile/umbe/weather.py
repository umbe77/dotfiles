import os
import subprocess

from .widgets import ShellScript

class Weather(ShellScript):
    def __init__(self, **config):
        ShellScript.__init__(self, btn_func=None, script='~/.scripts/polybar_weather', **config)

    def refresh_weather(self, x, y, btn):
        script_path = os.path.expanduser('~/.scripts/polybar_weather_click')
        subprocess.run(script_path, stdout=subprocess.PIPE)
