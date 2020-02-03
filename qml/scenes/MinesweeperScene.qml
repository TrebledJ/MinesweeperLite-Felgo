import Felgo 3.0
import QtQuick 2.0

import "../common"
import "components"
import "../settings"
import "../js/MSEnum.js" as MSEnum

Scene {
    id: scene

    property alias minesweeperBoard: minesweeperBoard

    signal gotoSettings()

    // the "logical size" - the scene content is auto-scaled to match the GameWindow size
    width: 320
    height: 480

    visible: opacity !== 0
    opacity: 0


    function newGame() {
        minesweeperBoard.generate();
        clock.stop();
        clock.timeTaken = 0;
    }


    Component.onCompleted: {
        newGame();
        minesweeperBoard.debug();
    }


    // background rectangle matching the logical scene size (= safe zone available on all devices)
    // see here for more details on content scaling and safe zone: https://felgo.com/doc/felgo-different-screen-sizes/
    Rectangle {
        id: background
        anchors.fill: parent
        color: "grey"

        Column {
            anchors.fill: parent

//            /*
            Rectangle {
                id: topBar
                anchors.left: parent.left
                anchors.right: parent.right
                height: 60
                z: 2

                color: "goldenrod"
//                color: "transparent"

//                MouseArea {
//                    anchors.fill: parent
//                    onClicked: scene.gotoSettings()
//                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Column {
                        width: 140
                        spacing: 4

                        BubbleButton {
                            //  modifies the difficulty
                            width: parent.width
                            height: 18
                            text: "Difficulty: " + MSSettings.difficulty()
                            font.pointSize: 10
                            onClicked: {
                                MSSettings.incrementDifficultyIndex();
                            }
                        }

                        BubbleButton {
                            //  modifies the mode
                            width: parent.width
                            height: 18
                            text: "Mode: " + MSSettings.mode()
                            font.pointSize: 10
                            onClicked: {
                                MSSettings.incrementModeIndex();
                            }
                        }
                    }

                    BubbleButton {
                        width: 140
                        height: 40
                        text: "New Game"
                        font.pointSize: 12
                        onClicked: {
                            newGame();
                        }
                    }
                }
            }   //  Rectangle: topBar
//            */

//            MinesweeperTopBar {
//                id: topBar
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 60
//            }

            Rectangle {
                id: stage
                width: parent.width
                height: background.height - topBar.height - bottomBar.height
                color: "transparent"

                Item {
                    id: staticWrapper
                    anchors.centerIn: parent
                    width: wrapper.width
                    height: wrapper.height

                    Item {
                        id: wrapper

                        x: (parent.width - width) / 2
                        y: (parent.height - height) / 2
                        width: minesweeperBoard.width
                        height: minesweeperBoard.height

                        function snapToView() {
                            let realX = staticWrapper.x + wrapper.x;
                            let realY = staticWrapper.y + wrapper.y;
                            let wrapperRealWidth = wrapper.width * tform.xScale;
                            let wrapperRealHeight = wrapper.height * tform.yScale;

                            let leftMargin = realX;
                            let rightMargin = stage.width - (realX + wrapperRealWidth);
                            let topMargin = realY;
                            let bottomMargin = stage.height - (realY + wrapperRealHeight);

                            //  modify this value to change the size of the margin
                            let threshold = 20;

                            //console.log('leftMargin=%1, rightMargin=%2'.arg(leftMargin).arg(rightMargin));
                            //console.log('topMargin=%1, bottomMargin=%2'.arg(topMargin).arg(bottomMargin));

                            //  snap wrapper.x and wrapper.y against the background
                            if (leftMargin < 0 && rightMargin > threshold) {
                                if (wrapperRealWidth < stage.width - 2*threshold) {
                                    //  wrapper fits within left + right thresholds
                                    wrapper.x = (staticWrapper.width - wrapperRealWidth) / 2;
                                    console.log('wrapper fits within 2 x thresholds');
                                } else {
                                    wrapper.x = stage.width - threshold - wrapperRealWidth - staticWrapper.x;
                                    console.log('wrapper does not fit within 2 x thresholds');
                                }
                                console.log('readjusting wrapper.x:', wrapper.x);
                            }
                            if (rightMargin < 0 && leftMargin > threshold) {
                                if (wrapperRealWidth < stage.width - 2*threshold) {
                                    wrapper.x = (staticWrapper.width - wrapperRealWidth) / 2;
                                    console.log('wrapper fits within 2 x thresholds');
                                } else {
                                    wrapper.x = threshold - staticWrapper.x;
                                    console.log('wrapper does not fit within 2 x thresholds');
                                }
                                console.log('readjusting wrapper.x:', wrapper.x);
                            }
                            if (topMargin < 0 && bottomMargin > threshold) {
                                if (wrapperRealHeight < stage.height - 2*threshold) {
                                    //  wrapper fits within top + bottom thresholds
                                    wrapper.y = (staticWrapper.height - wrapperRealHeight) / 2;
                                    console.log('wrapper fits within 2 y thresholds');
                                } else {
                                    wrapper.y = stage.height- threshold - wrapperRealHeight - staticWrapper.y;
                                    console.log('wrapper does not fit within 2 y thresholds');
                                }
                                console.log('readjusting wrapper.y:', wrapper.y);
                            }
                            if (bottomMargin < 0 && topMargin > threshold) {
                                if (wrapperRealHeight < stage.height - 2*threshold) {
                                    wrapper.y = (staticWrapper.height - wrapperRealHeight) / 2;
                                    console.log('wrapper fits within 2 y thresholds');
                                } else {
                                    wrapper.y = threshold - staticWrapper.y;
                                    console.log('wrapper does not fit within 2 y thresholds');
                                }
                                console.log('readjusting wrapper.y:', wrapper.y);
                            }
                        }

                        MinesweeperBoard {
                            id: minesweeperBoard

                            enabled: true
                            opacity: enabled ? 1 : 0.8

                            defaultWidth: stage.width * 7/8
                            defaultHeight: stage.height * 7/8
//                            difficulty: MSEnum.Difficulty.index(difficultyIndex)
//                            mode: MSEnum.Mode.index(modeIndex)
                            difficulty: MSEnum.Difficulty.index(MSSettings.difficultyIndex)
                            mode: MSEnum.Mode.index(MSSettings.modeIndex)
                            onClicked: clock.start();
                        }

                        Item {
                            id: proxy
                            //  used as a dummy for the pinchArea to take effect but propagates scaling to wrapper

                            onScaleChanged: {
                                let zoomFactor = pinchArea.scale / pinchArea.previousScale;
                                let realX = pinchArea.center.x * tform.xScale;
                                let realY = pinchArea.center.y * tform.yScale;
                                wrapper.x += (1 - zoomFactor) * realX;
                                wrapper.y += (1 - zoomFactor) * realY;
                                tform.xScale *= zoomFactor;
                                tform.yScale *= zoomFactor;
                            }
                        }

                        PinchArea {
                            id: pinchArea
                            property point center
                            property double previousScale: 1.0
                            property double scale: 1.0

                            anchors.fill: parent
                            pinch.target: proxy
                            pinch.minimumScale: 1
                            pinch.maximumScale: 10
                            onPinchStarted: {
                                center = pinch.center;
                                previousScale = pinch.previousScale;
                                scale = pinch.scale;
                            }
                            onPinchUpdated: {
                                center = pinch.center;
                                previousScale = pinch.previousScale;
                                scale = pinch.scale;
                            }
                            onPinchFinished: {
                                previousScale = 1.0;
                                scale = 1.0;

                                wrapper.snapToView();
                            }
                        }   //  PinchArea

                        transform: Scale {
                            id: tform
                        }
                    }   //  Item: wrapper
                }   //  Item: staticWrapper

                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true
                    drag.target: wrapper
                    drag.axis: Drag.XAndYAxis
                    onReleased: {
                        wrapper.snapToView();
                    }
                }   //  MouseArea

//                PauseOverlay {
//                    id: pauseOverlay
//                    anchors.fill: parent
//                }

            }   //  Rectangle: stage

            Rectangle {
                id: bottomBar
                anchors.left: parent.left
                anchors.right: parent.right
                height: 60
                z: 2

                color: "goldenrod"

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.RightButton) {
                            minesweeperBoard.minesweeperModel.debug()
//                        } else {
//                            minesweeperBoard.generate()
                        }
                    }
                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    Rectangle {
                        width: 140
                        height: 40
                        color: "yellow"
                        TextBase {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            text: "Time: " + clock.timeTaken
                        }
                    }

                    Rectangle {
                        width: 140
                        height: 40
                        color: "yellow"
                        TextBase {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            text: "Flags Left: " + minesweeperBoard.flagsLeft
                        }
                    }
                }

            }   //  Rectangle: bottomBar
        }   //  Column
    }   //  Rectangle: background

    Timer {
        id: clock
        property int timeTaken: 0
        interval: 1000
        repeat: true
        onTriggered: timeTaken++
    }

}   //  Scene: scene
