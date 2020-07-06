import os
import subprocess

from libqtile.widget import base


class ShellScript(base.ThreadedPollText):
    orientations = base.ORIENTATION_HORIZONTAL

    def __init__(self, **config):
        base.ThreadedPollText.__init__(self, **config)
        self.script = config['script']

    def poll(self):
        return self._run_script()

    def _run_script(self):
        script_path = os.path.expanduser(self.script)

        result = subprocess.run(script_path, stdout=subprocess.PIPE)
        return result.stdout.decode()
