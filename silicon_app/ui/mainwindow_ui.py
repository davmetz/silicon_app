# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'designer/mainwindow.ui'
#
# Created by: PyQt5 UI code generator 5.12.3
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(800, 600)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.horizontalLayout = QtWidgets.QHBoxLayout(self.centralwidget)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.formLayout = QtWidgets.QFormLayout()
        self.formLayout.setObjectName("formLayout")
        self.uvw = QtWidgets.QLineEdit(self.centralwidget)
        self.uvw.setObjectName("uvw")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.FieldRole, self.uvw)
        self.label_uvw = QtWidgets.QLabel(self.centralwidget)
        self.label_uvw.setObjectName("label_uvw")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.label_uvw)
        self.label_hkl = QtWidgets.QLabel(self.centralwidget)
        self.label_hkl.setObjectName("label_hkl")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.LabelRole, self.label_hkl)
        self.hkl = QtWidgets.QLineEdit(self.centralwidget)
        self.hkl.setObjectName("hkl")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.FieldRole, self.hkl)
        self.pB_compute = QtWidgets.QPushButton(self.centralwidget)
        self.pB_compute.setObjectName("pB_compute")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.SpanningRole, self.pB_compute)
        self.horizontalLayout.addLayout(self.formLayout)
        self.plotLayout = QtWidgets.QVBoxLayout()
        self.plotLayout.setObjectName("plotLayout")
        self.horizontalLayout.addLayout(self.plotLayout)
        self.horizontalLayout.setStretch(0, 1)
        self.horizontalLayout.setStretch(1, 3)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 21))
        self.menubar.setObjectName("menubar")
        self.menuMain = QtWidgets.QMenu(self.menubar)
        self.menuMain.setObjectName("menuMain")
        self.menuHelp = QtWidgets.QMenu(self.menubar)
        self.menuHelp.setObjectName("menuHelp")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)
        self.actionAbout = QtWidgets.QAction(MainWindow)
        self.actionAbout.setObjectName("actionAbout")
        self.action_exit = QtWidgets.QAction(MainWindow)
        self.action_exit.setObjectName("action_exit")
        self.menuMain.addAction(self.action_exit)
        self.menuHelp.addAction(self.actionAbout)
        self.menubar.addAction(self.menuMain.menuAction())
        self.menubar.addAction(self.menuHelp.menuAction())

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.uvw.setText(_translate("MainWindow", "1,1,0"))
        self.label_uvw.setText(_translate("MainWindow", "uvw"))
        self.label_hkl.setText(_translate("MainWindow", "hkl"))
        self.hkl.setText(_translate("MainWindow", "0,0,1"))
        self.pB_compute.setText(_translate("MainWindow", "compute"))
        self.menuMain.setTitle(_translate("MainWindow", "Main"))
        self.menuHelp.setTitle(_translate("MainWindow", "Help"))
        self.actionAbout.setText(_translate("MainWindow", "About"))
        self.action_exit.setText(_translate("MainWindow", "Exit"))
        self.action_exit.setShortcut(_translate("MainWindow", "Ctrl+Q"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())
