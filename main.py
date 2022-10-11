import sys
from silicon_app import app

__status__= 'dev'

def update_in_dev():
    if __status__ == 'dev':
        import subprocess
        # This is our shell command, executed in subprocess.
        # pyuic5 -x /designer/mainwindow.ui -o /silicon_app/ui/mainwindow_ui.py
        import pathlib
        path= pathlib.Path(__file__).parent.resolve()
        # process = subprocess.Popen(bashCommand)
        bashCommand = f".\script.bat"
        process = subprocess.Popen(bashCommand.split())


if __name__ == '__main__':
    update_in_dev()
    sys.exit(app.run())