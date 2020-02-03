import QtQuick 2.0
import Felgo 3.0

import "../../common"
import "../../settings"

Rectangle {
    id: topBar

    property int timeTaken
    property int flagsLeft
    signal newGameClicked()

//    anchors.left: parent.left
//    anchors.right: parent.right
//    height: 60
//    z: 2

    color: "goldenrod"

    Row {
//        anchors.fill: parent
//        anchors.margins: 10
        anchors.horizontalCenter:parent.horizontalCenter
        spacing: 10

        Rectangle {
            width: 80
            height: 40
            color: "yellow"
            TextBase {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: timeTaken
                font.pointSize: 11
            }
        }

        BubbleButton {
            width: 60
            height: 40
            text: "New"
            font.pointSize: 12
            onClicked: newGameClicked()
        }

        Rectangle {
            width: 80
            height: 40
            color: "yellow"
            TextBase {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                text: flagsLeft
                font.pointSize: 11
            }
        }

//        Column {
//            width: 140
//            spacing: 4

//            BubbleButton {
//                //  modifies the difficulty
//                width: parent.width
//                height: 18
//                text: "Difficulty: " + MSSettings.difficulty()
//                font.pointSize: 10
//                onClicked: {
//                    MSSettings.incrementDifficultyIndex();
//                }
//            }

//            BubbleButton {
//                //  modifies the mode
//                width: parent.width
//                height: 18
//                text: "Mode: " + MSSettings.mode()
//                font.pointSize: 10
//                onClicked: {
//                    MSSettings.incrementModeIndex();
//                }
//            }
//        }



    }
}   //  Rectangle: topBar
