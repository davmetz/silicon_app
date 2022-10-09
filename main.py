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
        print(f'{path=}')
        p_src= path / 'designer/mainwindow.ui'
        p_out= path / 'silicon_app/ui/mainwindow_ui.py'
        print(f'{p_src=}')
        bashCommand = "E:"
        process = subprocess.Popen(bashCommand.split(), cwd=path)
        bashCommand = f"pyuic5 -x {p_src} -o {p_out}"
        process = subprocess.Popen(bashCommand.split(), cwd=path)


if __name__ == '__main__':
    # update_in_dev()
    sys.exit(app.run())