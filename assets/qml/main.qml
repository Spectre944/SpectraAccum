import QtQuick
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtCharts 6.3
import Qt.labs.qmlmodels 1.0
import QtQuick.Dialogs

import "../qml/windows"
import "../qml/modules"

ApplicationWindow {
    width: 1280
    height: 720
    visible: true
    title: qsTr("Hello World")

    Connections {
        target: smContext
    }

    Connections {
        target: fmContext

        function onSpectrumChangedUsl(spectrum, name) {
            // Clear the existing series data
            spectrumSeries.clear();
            spectrumSeries.name = name


            // Add the updated spectrum data to the series
            //for (var i = 0; i < spectrum.length; i++) {
            for (var i = 0; i < 2048; i++) {
                var dataPoint = spectrum[i];
                spectrumSeries.append(i, dataPoint);
            }

            // Update the axis range based on the new data
            valueAxisX.min = 0;
            valueAxisX.max = spectrum.length - 1;

            valueAxisY.min = 0;
            valueAxisY.max = Math.max(...spectrum);
        }

        function onGausChangedUsl(spectrum, name) {
            // Clear the existing series data
            gausSeries.clear();
            gausSeries.name = name


            // Add the updated spectrum data to the series
            //for (var i = 0; i < spectrum.length; i++) {
            for (var i = 0; i < 2048; i++) {
                var dataPoint = spectrum[i];
                gausSeries.append(i, dataPoint);
            }

        }

        function onGetParamFromSettingsUsi(){
            param = []
            param.append(parseInt(averFactor.text))
            param.append(parseInt(sigmaFactor.text))
            fmContext.getParamFromSettingsUsi(param)
            console.log(param)
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&Файл")
            Action { text: qsTr("Відкрити спектр")
                onTriggered: { fileDialog.open()  }
            }
            Action { text: qsTr("Зберегти спектр") }
            Action { text: qsTr("Зберегти CSV") }
        }
        Menu {
            title: qsTr("&Управління")
            Action { text: qsTr("Пошук девайсів")
                onTriggered: { smContext.initDevicesUsi(1)  }
            }

        }
        Menu {
            title: qsTr("&Калібровка")
            Action { text: qsTr("Усереднети спектр")
                onTriggered: { fmContext.processSpectrumUsi()  }
            }

        }

    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            console.log("You chose: " + fileDialog.currentFile)
            fmContext.loadSpectrumUsi(fileDialog.currentFile)
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    Rectangle {
        id: background
        color: "#ffffff"
        anchors.fill: parent

        Rectangle {
            id: appContent
            color: "transparent"
            anchors.fill: parent
            clip: true

            SwipeView {
                id: swipeView
                anchors.fill: parent
                interactive: false

                Page {
                    id: pageDevices

                    Rectangle {
                        id: rectangleDevices
                        color: "#dbdcdc"
                        anchors.fill: parent
                        anchors.margins: 0

                        ScrollView {
                            id: scrollViewDevices
                            anchors.fill: parent
                            padding: 10


                            WinDevlist {
                                id: devListRect
                                width: parent.width * 0.2
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                            }

                            WinSpectr {
                                id: devSpectrRect
                                anchors.left: devListRect.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                width: parent.width * 0.8 - 20
                            }



                            /*
                            Rectangle {
                                id: rectangleDevListContent
                                color: "#fafafa"
                                radius: 10
                                border.width: 0
                                anchors.fill: parent
                                anchors.margins: 10
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    color: "#a3676767"
                                    transparentBorder: true
                                    horizontalOffset: 2
                                    verticalOffset: 4
                                    radius: 4

                                }

                                Rectangle {
                                    id: devListRect
                                    width: parent.width * 0.2
                                    height: parent.height
                                    anchors.left: parent.left
                                    color: "blue"
                                    radius: 10


                                    ListView {
                                        id: devList
                                        anchors.fill: parent

                                        model: 5
                                        delegate:
                                            Rectangle {

                                            color: "green"
                                        }



                                    }
                                }

                                Rectangle {
                                    id: devSpectrRect
                                    width: parent.width * 0.8
                                    height: parent.height
                                    anchors.left: devListRect.right
                                    color: "red"
                                    radius: 10

                                    ChartView {
                                        anchors.fill: parent
                                        antialiasing: true
                                        anchors.margins: -5

                                        ValueAxis {
                                            id: valueAxisX
                                            labelFormat: "%.0f"
                                            min: 0
                                            max: 2048
                                        }

                                        ValueAxis {
                                            id: valueAxisY
                                            labelFormat: "%.0f"

                                        }

                                        LineSeries {
                                            id: spectrumSeries
                                            name: "Spectrum"
                                            axisX: valueAxisX
                                            axisY: valueAxisY
                                        }

                                        LineSeries {
                                            id: gausSeries
                                            name: "Spectrum"
                                            axisX: valueAxisX
                                            axisY: valueAxisY
                                        }
                                    }
                                }
                            }
                            */
                        }
                    }

                }

                Page {
                    id: pageSettings

                    WinSettings {
                         anchors.fill: parent
                    }
                }

                Page {
                    id: pageTest

                    Rectangle {
                        id: rectangleTest
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewTest
                            anchors.fill: parent

                            Rectangle {
                                id: rectangleTestContent
                                color: "#fafafa"
                                radius: 10
                                border.width: 0
                                anchors.fill: parent
                                anchors.rightMargin: 20
                                anchors.leftMargin: 20
                                anchors.bottomMargin: 20
                                anchors.topMargin: 20
                                layer.enabled: true
                                layer.effect: DropShadow {
                                    color: "#a3676767"
                                    transparentBorder: true
                                    horizontalOffset: 2
                                    verticalOffset: 4
                                    radius: 4



                                }
                            }
                        }
                    }

                }

            }

            PageIndicator {
                id: indicator

                count: swipeView.count
                currentIndex: swipeView.currentIndex
                anchors.bottom: swipeView.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

    }

}
