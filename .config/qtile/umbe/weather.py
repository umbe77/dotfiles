import os
import subprocess

from .widgets import ShellScript


class Weather(ShellScript):
    def __init__(self, **config):
        ShellScript.__init__(self,
                             script='~/.scripts/polybar_weather', **config)
