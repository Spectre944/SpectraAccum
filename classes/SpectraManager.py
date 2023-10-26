# This Python file uses the following encoding: utf-8
from PySide6 import QtCore

from classes.COMworker import COMworker

class SpectraManager(QtCore.QObject):
    def __init__(self):
        super().__init__()
        self.initDevices(1)


    def initDevices(self, status):
        self.comWorker = COMworker()
        self.comWorker.scanDevices()
        self.comWorker.connectDevices()

    def getSpectrum(self, com):
        buffer = self.comWorker.get_spectra_buffer(com)

    def startAccumulation(self, status):
        pass
