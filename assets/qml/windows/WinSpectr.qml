import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import QtCharts 6.3

Item {
    visible: true
    width: 1200
    height: 500

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

    }

    Rectangle {
        id: rectangleChart
        x: 10
        y: 10
        color: "#fafafa"
        radius: 10
        anchors.fill: parent
        anchors.margins: 20
        layer.enabled: true
        layer.effect: DropShadow {
            color: "#a0676767"
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 4
            radius: 4
        }

        Rectangle{
            id: content
            x: 10
            y: 10
            anchors.fill: parent
            anchors.margins: 5

            Rectangle {
                id: rectangleSpectr
                color: "#ffffff"
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: rectangleTop.bottom
                anchors.bottom: parent.bottom
                anchors.topMargin: 0



                ChartView {
                    id: spectrumChart
                    anchors.fill: parent
                    backgroundColor: "#00000000"
                    anchors.margins: 0
                    antialiasing: true
                    legend.visible: false

                    ValueAxis {
                        id: valueAxisX
                        labelFormat: "%.0f"
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

                    TextEdit {
                        id: textEditSpectrumInfo
                        textFormat: Text.RichText
                        text: '<p> 0000 сек  </p>' +
                              '<p> 0000 (0000) cps  </p>' +
                              '<p> 00.00 мкЗв/год  </p>' +
                              '<p> 00.00 °C  </p>'
                        anchors.fill: parent
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignRight
                        anchors.margins: 50
                    }

                    Rectangle{
                        id: zoomAreaRec
                        color: "#00000000"
                        border.color: "#50ff0000"
                        border.width: 2
                        radius: 4
                        clip: true
                        visible: false
                    }

                    Rectangle {
                        id: linemarker
                        y: spectrumChart.plotArea.top
                        height: spectrumChart.plotArea.height
                        width: 1
                        visible: false
                        color: "#bbff0000"

                        Rectangle {
                            anchors.top: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 25
                            width: 40
                            color: "#bbff0000"
                            radius: 4

                            Text {
                                anchors.fill: parent
                                id: mcText
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                text: linemarker.channelMarker
                            }
                        }
                    }

                    MouseArea {
                        id: crosshairMouseArea
                        anchors.fill: spectrumChart
                        hoverEnabled: true

                        Rectangle {
                            id: verticalCrosshair
                            y: spectrumChart.plotArea.top
                            x: crosshairMouseArea.mouseX - width / 2
                            height: spectrumChart.plotArea.height
                            width: 1
                            visible: false
                            color: "#bbff0000"

                            Rectangle {
                                anchors.top: parent.bottom
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: 25
                                width: 40
                                color: "#bbff0000"
                                radius: 4

                                Text {
                                    id: vcText
                                    anchors.fill: parent
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: ""
                                }
                            }
                        }

                        Rectangle {
                            id: horizontalCrosshair
                            x: spectrumChart.plotArea.left
                            y: crosshairMouseArea.mouseY - height / 2
                            width: spectrumChart.plotArea.width
                            height: 1
                            visible: false
                            color: "#bbff0000"

                            Rectangle {
                                anchors.left: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                height: 25
                                width: 40
                                color: "#bbff0000"
                                radius: 4

                                Text {
                                    anchors.fill: parent
                                    id: hcText
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: ""
                                }
                            }
                        }

                        onEntered: {
                            verticalCrosshair.visible = true;
                            horizontalCrosshair.visible = true;
                        }

                        onExited: {
                            verticalCrosshair.visible = false;
                            horizontalCrosshair.visible = false;
                        }

                        onPositionChanged: {
                            // Update the position of the crosshair elements based on the mouse position
                            verticalCrosshair.x = mouseX - 1 / 2;
                            horizontalCrosshair.y = mouseY - 1 / 2;

                            // Calculate channel and cps values based on the mouse position
                            var plotPos = spectrumChart.mapToValue(Qt.point(mouseX, mouseY));

                            // Set the channel and cps values based on your calculation
                            vcText.text = Math.floor(plotPos.x);
                            hcText.text = Math.floor(plotPos.y); // Replace with your actual calculation
                        }
                    }


                    MouseArea {
                        id: zoomMouseArea
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        //zoom chart
                        property real startX
                        property real startY
                        property real endX
                        property real endY

                        //drag chart
                        property bool isMove
                        property bool isZoom
                        property bool isSelected
                        property point previous: Qt.point(mouseX, mouseY)
                        property point scrollPoint
                        property double scale: -1.0
                        function reset(){
                            scrollPoint = Qt.point(0,0);
                        }

                        onReleased: (mouse)=> {
                                        if(isZoom == true){
                                            endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                            endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                                            zoomChart();
                                            updateRectangle(0, 0, 0, 0, false);
                                            isZoom = false;
                                        }
                                        if(isMove == true){
                                            isMove = false;
                                            isSelected = false
                                        }
                                        if(startX == endX){
                                            //draw vertical line if isnt moving
                                            drawVertical(mapToItem(spectrumChart, mouse.x, mouse.y).x, isSelected)
                                        }

                                    }

                        onPressed: (mouse)=> {

                                       if(mouse.button == Qt.LeftButton){
                                           startX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                           startY = mapToItem(spectrumChart, mouse.x, mouse.y).y;

                                           // Calculate channel and cps values based on the mouse position
                                           var plotPos = spectrumChart.mapToValue(Qt.point(mouseX, mouseY));
                                           mcText.text = Math.floor(plotPos.x)

                                           isZoom = true
                                           isSelected = true
                                       }
                                       else if(mouse.button == Qt.RightButton){
                                           previous = Qt.point(mouse.x, mouse.y);
                                           isMove = true
                                       }

                                   }

                        onPositionChanged: (mouse)=> {
                                               if (isZoom == true){
                                                   endX = mapToItem(spectrumChart, mouse.x, mouse.y).x;
                                                   endY = mapToItem(spectrumChart, mouse.x, mouse.y).y;
                                                   updateRectangle(startX, startY, endX - startX, endY - startY, true);
                                                   linemarker.visible = false
                                               }

                                               else if(isMove == true){

                                                   if(spectrumChart.isZoomed()) {

                                                       linemarker.visible = false

                                                       scrollPoint.x = (previous.x - mouse.x)*scale;
                                                       scrollPoint.y = (previous.y - mouse.y)*scale;

                                                       if(scrollPoint.y > 0)
                                                       {
                                                           spectrumChart.scrollUp(scrollPoint.y);
                                                           spectrumChart.scrollDown(0);
                                                       }
                                                       else{
                                                           spectrumChart.scrollDown(-scrollPoint.y);
                                                           spectrumChart.scrollUp(0);
                                                       }
                                                       if(scrollPoint.x > 0)
                                                       {
                                                           spectrumChart.scrollLeft(scrollPoint.x);
                                                           spectrumChart.scrollRight(0);
                                                       }
                                                       else{
                                                           spectrumChart.scrollLeft(0);
                                                           spectrumChart.scrollRight(-scrollPoint.x);
                                                       }

                                                       previous = Qt.point(mouse.x, mouse.y);
                                                   }
                                               }
                                           }

                        function zoomChart() {
                            if (startX < endX) {
                                var r = Qt.rect(startX, startY, endX - startX, endY - startY);
                                spectrumChart.zoomIn(r);
                            }
                            if (startX > endX) {
                                spectrumChart.zoomReset();
                            }

                        }

                        function updateRectangle(x, y, w, h, draw) {
                            zoomAreaRec.visible = draw
                            zoomAreaRec.x = x
                            zoomAreaRec.y = y
                            zoomAreaRec.width = w
                            zoomAreaRec.height = h
                        }

                        function drawVertical(x, visibleState) {
                            linemarker.visible = visibleState
                            var theValue = x
                            linemarker.x = mouseX - linemarker.width/2
                        }
                    }
                }

            }

            Rectangle {
                id: rectangleTop
                height: 50
                color: "#f0f0f0"
                radius: 10
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0

                Switch {
                    id: switchStartStopSpectr
                    text: qsTr("Почати накопичення")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    font.pointSize: 12
                    font.family: "Arial"
                    anchors.leftMargin: 10
                }

                Switch {
                    id: switchLogarifmSpect
                    text: qsTr("Логарифмічна шкала")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: switchStartStopSpectr.right
                    font.pointSize: 12
                    font.family: "Arial"
                    anchors.leftMargin: 10
                }

                Button {
                    id: delayButtonClearSpectr
                    width: 100
                    height: 30
                    text: qsTr("Очистити")
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    font.pointSize: 12
                    layer.mipmap: false
                    font.bold: false
                    font.family: "Arial"
                    anchors.rightMargin: 10
                }
            }

        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}
}
##^##*/
