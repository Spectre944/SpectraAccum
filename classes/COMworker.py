from PySide6 import QtCore

import serial.tools.list_ports

import serial
import threading
import time

class COMworker(QtCore.QObject):
    def __init__(self):
        super().__init__()
        self.techModeReq =  bytes([0x24, 0x24, 0x24, 0x0D, 0x0A])
        self.techModeEnd =  bytes([0x2D, 0x2D, 0x2D, 0x0D, 0x0A])
        #self.serialReq =    bytes([0x55, 0xAA, 0x11, 0x00, 0xFF, 0x5C, 0x3A, 0x1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x96])
        self.serialReq = bytes([0x55, 0xAA, 0x03, 0x00,	0x04, 0x00, 0x04])
        self.getSpectr =    bytes([0x55, 0xAA, 0x04, 0x00, 0x03, 0x00, 0x00, 0x03])
        self.newSpectr =    bytes([0x55, 0xAA, 0x04, 0x00, 0x03, 0x01, 0x00, 0x04])
        self.spectrOk =     bytes([0x55, 0xAA, 0x04, 0x00, 0x03, 0x02, 0x00, 0x05])
        self.spectrParam =  bytes([0x55, 0xAA, 0x04, 0x00, 0x03, 0x00, 0x01, 0x04])

        self.devList = []

        self.stop_threads = False  # Флаг для управления потоками
        self.regime = "param"



    def scanDevices(self):
        excluded_ports = [6, 7, 24, 26, 28, 30]  # Перечислите номера портов, которые нужно исключить

        com_ports = [port.device for port in serial.tools.list_ports.comports()]
        filtered_com_ports = [com_port for com_port in com_ports if int(com_port.replace("COM", "")) not in excluded_ports]

        print("d: available com`s", filtered_com_ports)

        for com_port in filtered_com_ports:
            try:
                with serial.Serial(com_port, baudrate=9600, timeout=1) as ser:

                    # Send the initialization package
                    ser.write(self.techModeReq)
                    print(f"d: Sent initialization package to {com_port}")

                    # Read and print the response
                    response = ser.read(100)  # Adjust the number of bytes to read as needed
                    print(f"d: Response from {com_port} after initialization: {response.decode('utf-8', 'ignore')}")

                    ser.write(self.serialReq)
                    print(f"d: Sent serial number request to {com_port}")

                    # Read and print the response to the serial number request
                    serial_response = ser.read(100)  # Adjust the number of bytes to read as needed
                    print(f"d: Response to serial number request from {com_port}: {serial_response.decode('utf-8', 'ignore')}")  # Assuming the response is in UTF-8
                    print("d: //---------------------//")
                    serialNumber = serial_response[5:12].decode('latin-1', errors='ignore')

                    if len(serialNumber) > 0 :
                        self.devList.append({"port": com_port, "serial_number": serialNumber})

                    ser.write(self.techModeEnd)

            except serial.SerialException:
                print(f"Failed to open {com_port}")

        print("d: devices - ", self.devList)


    def connectDevices(self):
        threads = []
        for device in self.devList:
            com_port = device["port"]
            thread = threading.Thread(target=self.runDeviceThread, args=(com_port,))
            thread.start()
            threads.append(thread)


    def runDeviceThread(self, com_port):
        while not self.stop_threads:
            try:
                with serial.Serial(com_port, baudrate=9600, timeout=2) as ser:
                    if self.regime == "idle":
                        pass
                    elif self.regime == "param":
                        ser.write(self.spectrParam)
                    elif self.regime == "newSpectr":
                        ser.write(self.newSpectr)
                    elif self.regime == "spectr":
                        ser.write(self.getSpectr)
                    elif self.regime == "stop":
                        ser.write(self.techModeEnd)

                    response = ser.read(100)  # Прочитайте ответ и обработайте его
                    if response:
                        print(response)

            except serial.SerialException:
                print(f"Failed to open {com_port}")


    def stopThreads(self):
            self.stop_threads = True  # Установите флаг для остановки потоков

    def acquireSpectra(self, com_port, interval=2):
        while True:
            response = self.sendData(self.serialReq, com_port)
            if response:
                # Обработка данных спектра
                pass
            time.sleep(interval)
