import Felgo 3.0
import QtQuick 2.0

Rectangle {
    id: square

    signal clicked()
    signal rightClicked()
    signal entered()
    signal exited()

    property bool isOpen: false
    property bool isFlagged: false
    property int value: 0
    property string debugData
    property alias mouseArea: mouseArea

    color: {
        if (isOpen) {
            if (value === -1)
                return 'darkgrey';
            else
                return 'darkturquoise';
        } else if (isFlagged) {
            return 'darkviolet';
        } else {
            return 'lightgrey';
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true
        propagateComposedEvents: false
        onClicked: {
            if (mouse.button === Qt.LeftButton)
                square.clicked();
            else if (mouse.button === Qt.RightButton)    //  won't work on mobile
                square.rightClicked();
        }

        onEntered: square.entered()
        onExited: square.exited()
    }

//    Image {
//        anchors.fill: parent
//        visible: hasFlag
//    }

    Text {
        anchors.centerIn: parent
        color: 'black'
        font.pointSize: 16
        text: isOpen ? (value > 0) ? value : '' : ''
//        text: value
    }

    onValueChanged: {
//        console.log('value changed:', value)
    }

    onEntered: {
        rectangle.setDebugText(debugData);
    }
}
