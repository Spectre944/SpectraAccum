# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path

from PySide6.QtWidgets import QApplication
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCharts import QChartView

from classes.SpectraManager import SpectraManager
from classes.FileManager import FileManager


if __name__ == "__main__":

    app = QApplication(sys.argv)
    #app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    sm = SpectraManager()
    fm = FileManager()

    # Add connections to QML
    engine.rootContext().setContextProperty("smContext", sm)
    engine.rootContext().setContextProperty("fmContext", fm)
    # Add model
    engine.rootContext().setContextProperty("spectrumData", fm.spectrum)



    qml_file = Path(__file__).resolve().parent / "assets/qml/main.qml"
    engine.load(qml_file)


    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
