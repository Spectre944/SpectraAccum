import QtQuick

Item {

    width: 100
    height: 25

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 10
        color: "#2797ff"

        Text {
            id: btnText
            anchors.centerIn: parent
            text: qsTr("Button")
        }

    }

    MouseArea {
        id: btnMA
        anchors.fill: parent

    }


}
