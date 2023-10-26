# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path


from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


from classes.SpectraManager import SpectraManager


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    qml_file = Path(__file__).resolve().parent / "assets/qml/main.qml"
    engine.load(qml_file)

    sm = SpectraManager()

    # Add connections to QML
    engine.rootContext().setContextProperty("spectraManagerContext", sm)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
