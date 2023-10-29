# This Python file uses the following encoding: utf-8
from PySide6 import QtCore
import numpy as np
from scipy.signal import find_peaks, peak_widths

class Calibration(QtCore.QObject):
    def __init__(self):
        super().__init__()

    def averageSpectrum(self, spectra):
        # Усреднение спектров
        K_stab = 0.15

        averaged_spectrum = np.mean(spectra, axis=0)
        return averaged_spectrum

    def findPeaks(self, spectrum, threshold, min_distance):
        # Нахождение пиков в спектре
        peaks, _ = find_peaks(spectrum, height=threshold, distance=min_distance)
        return peaks

    def checkPeakWidth(self, spectrum, peaks, min_width, max_width):
        # Проверка ширины пиков
        widths, _, _, _ = peak_widths(spectrum, peaks, rel_height=0.5)
        valid_peaks = [peak for peak, width in zip(peaks, widths) if min_width <= width <= max_width]
        return valid_peaks
