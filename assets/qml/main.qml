import QtQuick
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import QtCharts 6.3
import Qt.labs.qmlmodels 1.0

import "../qml/windows"
import "../qml/modules"

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("&Файл")
            Action { text: qsTr("Відкрити спектр") }
            Action { text: qsTr("Зберегти спектр") }
            Action { text: qsTr("Зберегти CSV") }
        }
        Menu {
            title: qsTr("&Управління")
            Action { text: qsTr("Пічка")
                onTriggered: { manualHeater.show()  }
            }

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
                anchors.left: leftMenuFrame.right
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                interactive: false
                anchors.topMargin: 0
                anchors.leftMargin: 0
                currentIndex: 0
                onCurrentIndexChanged: {
                    buttonDevices.activeMenu = !currentIndex
                    buttonSettings.activeMenu = currentIndex
                }

                Page {
                    id: pageDevices

                    Rectangle {
                        id: rectangleDevices
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewDevices
                            anchors.fill: parent
                            padding: 0
                            rightPadding: 10
                            bottomPadding: 10
                            leftPadding: 10
                            topPadding: 10

                        }
                    }

                }

                Page {
                    id: pageSettings

                    Rectangle {
                        id: rectangleSettings
                        color: "#dbdcdc"
                        anchors.fill: parent

                        ScrollView {
                            id: scrollViewSettings
                            anchors.fill: parent

                            Rectangle {
                                id: rectangleSettingsContent
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

                                    Test{
                                        id: testWindow
                                        anchors.fill: parent
                                    }

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

            Rectangle {
                id: leftMenuFrame
                width: 30
                color: "#dbdcdb"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 0

                SceLeftMenuButton {
                    id: buttonDevices
                    width: 30
                    btnIcon: "qrc:/icons/house.svg"
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: swipeView.setCurrentIndex(0)

                }

                SceLeftMenuButton {
                    id: buttonSettings
                    width: 30
                    btnIcon: "qrc:/icons/gear.svg"
                    anchors.bottom: buttonTest.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 20
                    onClicked: swipeView.setCurrentIndex(1)

                }


                SceLeftMenuButton {
                    id: buttonTest
                    width: 30
                    btnIcon: "qrc:/icons/terminal.svg"
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 20
                    onClicked: swipeView.setCurrentIndex(2)

                }

            }
        }

    }

}
