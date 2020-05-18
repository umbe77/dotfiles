import os
import subprocess

from libqtile.widget import base

class ShellScript(base.ThreadedPollText):
    orientations = base.ORIENTATION_HORIZONTAL
    def __init__(self, btn_func=None, **config):
        base.ThreadedPollText.__init__(self, **config)
        self.btn_func = btn_func
        self.script = config['script']

    def poll(self):
        return self._run_script()
    
    def _run_script(self):
        script_path = os.path.expanduser(self.script)

        result = subprocess.run(script_path, stdout=subprocess.PIPE)
        return result.stdout.decode()

    def button_press(self, x, y, btn):
        if self.btn_func is not None:
            self.btn_func(x, y, btn)