import QtQuick 2.0
import QtQuick.Controls 2.12
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

    Grid {
        anchors.fill: background
        anchors.margins: 50
        spacing: 20
        columns: 2

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

        Item {
            width: 40
            height: 40
        }

        Row {
            TextField {
                id: widthTextField
                width: 50
                height: 30
                font.pointSize: 11
            }

            TextField {
                id: heightTextField
                width: 50
                height: 30
                font.pointSize: 11
                onTextEdited: {

                }
            }
        }



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

    Column {
        anchors.centerIn: background
        width: parent.width
        spacing: 20
        visible: false

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
