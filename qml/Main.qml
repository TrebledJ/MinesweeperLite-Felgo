import Felgo 3.0
import QtQuick 2.12

GameWindow {
    id: gameWindow

    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    activeScene: scene

    // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
    // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
    // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
    // this resolution is for iPhone 4 & iPhone 4S
    screenWidth: 640
    screenHeight: 960

    Scene {
        id: scene

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: 320
        height: 480

        // background rectangle matching the logical scene size (= safe zone available on all devices)
        // see here for more details on content scaling and safe zone: https://felgo.com/doc/felgo-different-screen-sizes/
        Rectangle {
            id: rectangle
            anchors.fill: parent
            color: "grey"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    minesweeperBoard.minesweeperModel.generateBombs();
                    minesweeperBoard.updateGrid();
                }
            }

            MinesweeperBoard {
                id: minesweeperBoard
                anchors.centerIn: parent
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 60
                color: 'lightgrey'

                Text {
                    id: debugText
                    width: parent.width
                    text: ''
                    font.pointSize: 10
                    color: 'black'
                    padding: 5
                    wrapMode: Text.WordWrap
                }
            }

            function setDebugText(text) {
                debugText.text = text;
            }

        } // Rectangle with size of logical scene
    }

    Component.onCompleted: {
        minesweeperBoard.minesweeperModel.generateBombs();
        minesweeperBoard.updateGrid();
    }
}
