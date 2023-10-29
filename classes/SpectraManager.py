# This Python file uses the following encoding: utf-8
from PySide6 import QtCore
from PySide6.QtCore import QObject, Signal, Slot

from classes.COMworker import COMworker

class SpectraManager(QObject):
    def __init__(self):
        super().__init__()
        self.comWorker = COMworker()

    @Slot(str)
    def initDevicesUsi(self, status):
        self.comWorker.scanDevices()
        self.comWorker.connectDevices()

    def getSpectrum(self, com):
        buffer = self.comWorker.get_spectra_buffer(com)

    def startAccumulation(self, status):
        pass
