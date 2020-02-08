/**
  This scene allows the user to modify minesweeper settings.
**/
import Felgo 3.0
import QtQuick 2.12

import "../common"
import "../settings"

Scene {
    id: scene

    width: 320
    height: 480
    visible: opacity != 0
    opacity: 0

    Rectangle {
        id: background
        anchors.fill: parent
        color: "grey"

        Column {
            anchors.fill: parent

            Rectangle {
                id: topBar
                width: parent.width
                height: 40
                z: 2
                color: "goldenrod"

                MouseArea {
                    anchors.fill: parent
                    onClicked: backButtonPressed()
                }
            }

            Grid {
                width: parent.width
                padding: 20

                columns: 2
                spacing: 20

                TextBase {
                    text: "Difficulty"
                    font.pointSize: 10
                }

                BubbleButton {
                    //  modifies the difficulty
                    width: 130
                    height: 40
                    text: MSSettings.difficulty()
                    font.pointSize: 10
                    onClicked: {
                        MSSettings.incrementDifficultyIndex();
                    }
                }

                TextBase {
                    text: "Mode"
                    font.pointSize: 10
                }

                BubbleButton {
                    //  modifies the mode
                    width: 130
                    height: 40
                    text: MSSettings.mode()
                    font.pointSize: 10
                    onClicked: {
                        MSSettings.incrementModeIndex();
                    }
                }
            }
        }
    }

}
