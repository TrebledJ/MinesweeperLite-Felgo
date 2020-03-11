import QtQuick 2.0
import Felgo 3.0

import "../../common"

Item {
    id: item

    signal overlayClicked()

    MouseArea {
        anchors.fill: parent
        onClicked: item.overlayClicked()
    }
}
