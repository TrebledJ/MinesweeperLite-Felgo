import QtQuick 2.0
import Felgo 3.0

import "../common"

Item {
    id: item

    Rectangle {
        anchors.fill: parent
        color: "darkgrey"
        opacity: 0.6
    }

    BubbleButton {
        x: parent.width / 2
        y: 10
        width: 140
        height: 40

        text: "Restart"
    }


}
