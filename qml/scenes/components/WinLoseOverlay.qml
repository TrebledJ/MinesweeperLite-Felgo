import QtQuick 2.0
import Felgo 3.0

import "../../common"
import "../../js/MSLogic.js" as MSLogic

Item {
    id: item

    signal overlayClicked()

    property var state: MSLogic.State.Active


    function reset() {
        state = MSLogic.State.Active;
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: {
            switch (item.state) {
            case MSLogic.State.Win:
                return "green";
            case MSLogic.State.Lose:
                return "navy";
            default:
                return "darkgrey";
            }
        }

        opacity: 0.75

        Behavior on color {
            ColorAnimation {
                duration: 600
            }
        }
    }

    TextBase {
        anchors.centerIn: background
        text: {
            switch (item.state) {
            case MSLogic.State.Win:
                return "You win!";
            case MSLogic.State.Lose:
                return "Try again!";
            default:
                return "";
            }
        }
        color: {
            switch (item.state) {
            case MSLogic.State.Lose:
                return "goldenrod";
            default:
                return "navy";
            }
        }

        font.pointSize: 24
    }

    Behavior on y {
        NumberAnimation {}
    }

    MouseArea {
        anchors.fill: background
        onClicked: overlayClicked()
    }
}
