# This Python file uses the following encoding: utf-8
from PySide6 import QtCore
import numpy as np
from scipy.signal import find_peaks, peak_widths
import math

class Calibration(QtCore.QObject):
    def __init__(self):
        super().__init__()

    def compute_moving_average(self, target, length):
        new_data = [0] * len(target)
        half = length // 2

        for i in range(len(new_data)):
            if i >= half and i <= len(target) - half - 1:
                remainder_index_factor = length % 2
                add_val = target[i + half - remainder_index_factor]
                remove_val = target[i - half]
                new_data[i] = new_data[i - 1] + (add_val - remove_val) / length
                continue

            val = 0
            divider = 0

            for j in range(length):
                if j < half:
                    if (i - j) >= 0:
                        val += target[i - j]
                        divider += 1
                else:
                    if (i - half + 1 + j) < len(new_data):
                        val += target[i - half + 1 + j]
                        divider += 1

            new_data[i] = val / divider

        return new_data

    def compute_gauss_values(self, index, x_min, x_max):
        gauss_values = []

        if x_min == x_max:  # Проверка на случай x_min и x_max, равных друг другу
            gauss_values.append(1.0)  # Если x_min и x_max равны, то значение гауссовой функции равно 1.0
        else:
            for k in range(x_min, x_max):
                gauss_values.append(math.exp(-k * k / (2 * index)))

            avg = sum(gauss_values) / len(gauss_values)
            squared_sum = sum((value - avg) ** 2 for value in gauss_values)

            for i in range(len(gauss_values)):
                gauss_values[i] = (gauss_values[i] - avg) / squared_sum

        return gauss_values

    def gaussian_correl(self, data, sigma=2):
        gauss_values = {'dataArray': [], 'sigma': 2}

        correl_values = [0] * len(data)
        compute_new = False

        # Only compute values once, until other factors change
        if len(data) != len(gauss_values['dataArray']) or sigma != gauss_values['sigma']:
            gauss_values['dataArray'] = [0] * len(data)
            gauss_values['sigma'] = sigma
            compute_new = True

        for index in range(len(data)):
            std = index ** 0.5
            x_min = -round(sigma * std)
            x_max = round(sigma * std)

            if compute_new:
                gauss_values['dataArray'][index] = self.compute_gauss_values(index, x_min, x_max)

            gauss_values_data = gauss_values['dataArray'][index]

            result_val = 0

            for k in range(x_min, x_max):
                if 0 <= index + k < len(data):
                    result_val += data[index + k] * gauss_values_data[k - x_min]

            value = result_val if result_val > 0 else 0
            correl_values[index] = value

        max_data = max(data)
        max_correl_values = max(correl_values)
        scaling_factor = 0.8 * max_data / max_correl_values

        for index in range(len(correl_values)):
            correl_values[index] = correl_values[index] * scaling_factor

        return correl_values

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
