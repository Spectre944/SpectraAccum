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
