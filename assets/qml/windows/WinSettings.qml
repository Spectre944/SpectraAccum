import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

import "../modules"

Item {

    Item {
        id: f

        function sendParam(average, sigma) {
                let params = {
                    "settings": {
                        "calibrationParam": {
                            "averageFactor": average,
                            "sigmaFactor": sigma
                        }
                    }
                };

                let paramsJSON = JSON.stringify(params);

                fmContext.loadCalibParamUsi(paramsJSON);

                console.log(paramsJSON);
            }
    }

    Connections {
        target: fmContext


    }

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
                anchors.margins: 20
                layer.enabled: true
                layer.effect: DropShadow {
                    color: "#a3676767"
                    transparentBorder: true
                    horizontalOffset: 2
                    verticalOffset: 4
                    radius: 4

                    Column {
                        anchors.fill: parent
                        anchors.margins: 10

                        Rectangle {
                            id: gausParam
                            height: 100
                            width: parent.width
                            color: "#f0f0f0"
                            radius: 10

                            Row {

                                TextInput {
                                    id: averFactor
                                    height: 50
                                    width: 100
                                }
                                TextInput {
                                    id: sigmaFactor
                                    height: 50
                                    width: 100
                                }
                                Button {
                                    id: applyButton
                                    width: 100
                                    height: 25
                                    onClicked: f.sendParam(averFactor.text, sigmaFactor.text)
                                }
                            }
                        }

                    }





                }
            }
        }
    }

    Component.onCompleted: {
        console.log("Новая");
        // Переопределение onClicked для applyButton
        applyButton.onClicked = function() {
            console.log("Новая функция onClicked для applyButton");
            // Ваш код обработки события onClicked
        };
    }


}
