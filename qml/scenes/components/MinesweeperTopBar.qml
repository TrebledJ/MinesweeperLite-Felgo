import QtQuick 2.13
import QtQuick.Layouts 1.3
import Felgo 3.0

import "../../common"
import "../../settings"

Rectangle {
    id: topBar

    property int timeTaken
    property int flagsLeft

    signal newGameClicked()
    signal settingsClicked()
    signal pauseClicked()

    color: "goldenrod"

    function animateNewButton() {
        newButton.animateOver();
    }


    BubbleButton {
        id: pauseButton
        anchors { top: parent.top; left: parent.left; margins: 5 }
        width: 15
        height: 15
        background.color: "transparent"
        image.source: "qrc:/assets/placeholder"
        image.anchors.margins: 0

        onClicked: topBar.pauseClicked()
    }

    BubbleButton {
        id: settingsButton
        anchors { top: parent.top; right: parent.right; margins: 5 }
        width: 15
        height: 15
        background.color: "transparent"
        image.source: "qrc:/assets/placeholder"
        image.anchors.margins: 0

        onClicked: topBar.settingsClicked()
    }


    RowLayout {
        anchors.fill: parent
        spacing: 15

        Item { Layout.fillWidth: true }

        Row {
            Image {
                //  flags left img
                width: 40
                height: 40
                source: "qrc:/assets/placeholder"
            }
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 40
                height: 30
                color: "yellow"
                TextBase {
                    anchors.centerIn: parent
                    text: flagsLeft
                    font.pointSize: 11
                }
            }
        }

        BubbleButton {
            id: newButton
            width: 60
            height: 40
            text: "New"
            font.pointSize: 14
            onClicked: topBar.newGameClicked()
        }

        Row {
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 40
                height: 30
                color: "yellow"

                TextBase {
                    anchors.centerIn: parent
                    text: timeTaken
                    font.pointSize: 11
                }
            }
            Image {
                //  time taken img
                width: 40
                height: 40
                source: "qrc:/assets/placeholder"
            }
        }

        Item { Layout.fillWidth: true }
    }

}   //  Rectangle: topBar
