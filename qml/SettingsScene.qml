import Felgo 3.0
import QtQuick 2.12

import "MSEnum.js" as MSEnum

Scene {
    id: scene

    property int difficultyIndex
    property int modeIndex

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

                BubbleButton {
                    width: 130
                    height: 40
                    text: "Difficulty: " + MSEnum.Difficulty.index(difficultyIndex)
                    font.pointSize: 12
                    onClicked: {
                        difficultyIndex = (difficultyIndex + 1) % MSEnum.Difficulty.count;
                    }
                }

                BubbleButton {
                    width: 130
                    height: 40
                    text: "Mode: " + MSEnum.Mode.index(modeIndex)
                    font.pointSize: 12
                    onClicked: {
                        modeIndex = (modeIndex + 1) % MSEnum.Mode.count;
                    }
                }
            }
        }
    }

}
