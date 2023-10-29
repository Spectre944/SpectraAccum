from PySide6 import QtCore

from classes.Calibration import Calibration

from urllib.parse import unquote
import csv
import os

class FileManager(QtCore.QObject):
    spectrumChangedUsl = QtCore.Signal(list, str)

    def __init__(self):
        super().__init__()
        self.spectrum = []
        self.calib = Calibration()



    @QtCore.Slot(str)
    def loadSpectrumUsi(self, url):
        self.spectrum = []

        local_path = url[8:]  # Преобразовать URL в локальный путь
        try:
            with open(local_path, 'r', newline='') as file:
                reader = csv.reader(file)
                for row in reader:
                    # Предположим, что каждое значение в CSV-файле находится в отдельной строке
                    for value in row:
                        try:
                            # Преобразуйте значение в int или float, в зависимости от формата
                            value = int(value)  # Если значения целочисленные
                            # value = float(value)  # Если значения с плавающей запятой
                            self.spectrum.append(value)

                        except (ValueError, TypeError):
                            print(f"Ошибка преобразования значения: {value}")

            # После обновления модели данных вызываем сигнал spectrumChanged
            nuclidName = os.path.basename(local_path)
            self.spectrumChangedUsl.emit(self.spectrum, nuclidName)

        except FileNotFoundError:
            print(f"Файл не найден: {local_path}")
        except Exception as e:
            print(f"Произошла ошибка при чтении файла: {str(e)}")

    @QtCore.Slot()
    def processSpectrumUsi(self):
        aver_spec = self.calib.averageSpectrum(self.spectrum)
        print(aver_spec)
        self.spectrumChangedUsl.emit(aver_spec, "Avr")
