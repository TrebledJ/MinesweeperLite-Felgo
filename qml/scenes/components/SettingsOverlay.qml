import QtQuick 2.0
import Felgo 3.0

import "../../common"
import "../../settings"

Item {
    id: item

    Rectangle {
        id: background
        anchors.fill: parent
        color: "darkgrey"
        opacity: 0.98
    }

    Column {
        anchors.centerIn: background
        width: parent.width
//        padding: 20

//                columns: 2
        spacing: 20

//                Item {
//                    width: 130
//                    height: 40
//                    TextBase {
//                        anchors.centerIn: parent
//                        text: "Difficulty"
//                        font.pointSize: 16
//                    }
//                }




//                Item {
//                    width: 130
//                    height: 40
//                    TextBase {
//                        anchors.centerIn: parent
//                        text: "Mode"
//                        font.pointSize: 16
//                    }
//                }


        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 40
            spacing: 20

            Image {
                width: 40
                height: 40
                source: "qrc:/assets/placeholder"
            }

            BubbleButton {
                //  modifies the difficulty
                width: 100
                height: 40
                color: "transparent"
                text: MSSettings.difficulty()
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 12
                bubble: false
                onClicked: {
                    MSSettings.incrementDifficultyIndex();
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            height: 40
            spacing: 20

            Image {
                width: 40
                height: 40
                source: "qrc:/assets/placeholder"
            }

            BubbleButton {
                //  modifies the mode
                width: 100
                height: 40
                color: "transparent"
                text: MSSettings.mode()
                horizontalAlignment: Text.AlignLeft
                font.pointSize: 12
                bubble: false
                onClicked: {
                    MSSettings.incrementModeIndex();
                }

            }
        }
    }

    Behavior on opacity {
        NumberAnimation {}
    }
}
