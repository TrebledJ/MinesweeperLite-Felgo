import QtQuick 2.0
import Felgo 3.0

import "../../common"

Item {
    id: item

    Rectangle {
        id: background
        anchors.fill: parent
        color: "darkgrey"
        opacity: 0.98
    }

    TextBase {
        anchors.centerIn: background
        text: "Game Paused"
        font.pointSize: 24
    }

    Behavior on opacity {
        NumberAnimation {}
    }
}
