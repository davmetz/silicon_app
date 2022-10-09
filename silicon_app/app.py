import os
import sys
from typing import Any

from PyQt5 import QtCore, QtGui
from PyQt5.QtWidgets import QApplication,QMainWindow
from matplotlib import pyplot as plt
from matplotlib.figure import Figure
from silicon_app.eulerangle import MAIN_COORDINATE_SYSTEM, build_coordinate_system, plot_coordinatesystem

from silicon_app.utils.canvas import CanvasLayout, Plotter
from silicon_app.utils.input_gui import convert2vector
from .ui.mainwindow_ui import Ui_MainWindow

# class PlotterEITElemsData(Plotter):
#     """Plot the voltages in a Uplot graph"""

#     def _post_init_(self):
#         self._allowed_data_type = EITImage
#         self._plotting_func = [EITElemsDataPlot()]

#     def _build(self, fig: Figure, data: Any, labels: dict = None):
#         ax = fig.add_subplot(1, 1, 1)
#         lab = (
#             labels.get(self._plotting_func[0].type)
#             if isinstance(labels, dict)
#             else None
#         )
#         fig, ax = self._plotting_func[0].plot(fig, ax, data, lab)
#         fig.set_tight_layout(True)





class UiBackEnd(QMainWindow):
    def __init__(self) -> None:
        super().__init__()
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self._connect_actions()

        # self.canvas_plot = CanvasLayout(
        #     self, self.ui.plotLayout, PlotterEITElemsData
        # )

    def _connect_actions(self):
        self.ui.action_exit.triggered.connect(self.close)
        self.ui.pB_compute.clicked.connect(self.compute)
    
    def compute(self):
        x= convert2vector(self.ui.uvw.text())
        z= convert2vector(self.ui.hkl.text())
        cs= build_coordinate_system(x,z)
        ax = plt.figure().add_subplot(projection='3d')
        plot_coordinatesystem(ax, MAIN_COORDINATE_SYSTEM)
        plot_coordinatesystem(ax, cs, label= 'cs', color='r')
        plt.show()


def run():
    
    """Run the eit_app"""
    os.environ["QT_AUTO_SCREEN_SCALE_FACTOR"] = "1"
    app = QApplication(sys.argv)
    app.setStyle("Fusion")
    app.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)
    # TODO test icon dipslay on win
    app.setWindowIcon(QtGui.QIcon(":/icons/icons/EIT.png"))
    ui = UiBackEnd()
    ui.show()
    # exit(app.exec_())
    sys.exit(app.exec_())

if __name__ == '__main__':
    """"""