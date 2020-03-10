import Felgo 3.0
import QtQuick 2.0

import "../common"
import "components"
import "../settings"

Scene {
    id: scene

    signal settingsClicked()

    property bool started: false
    property alias minesweeperBoard: minesweeperBoard


    // the "logical size" - the scene content is auto-scaled to match the GameWindow size
    width: 320
    height: 480

    visible: opacity !== 0
    opacity: 0


    function newGame() {
        minesweeperBoard.generate();
//        minesweeperBoard.useDebugModel();
//        minesweeperBoard.debug();

        started = false;
        timer.reset();

        winLoseOverlay.reset();
        scene.state = "playing";
    }

    function start() {
        if (!started) {
            started = true;
        }
    }

    function end() {
        started = false;
        scene.state = "winLose";
    }

    function onPause() {
        state = (state !== "paused" ? "paused" : "playing");
    }


    Component.onCompleted: {
        newGame();
    }


    // background rectangle matching the logical scene size (= safe zone available on all devices)
    // see here for more details on content scaling and safe zone: https://felgo.com/doc/felgo-different-screen-sizes/
    Rectangle {
        id: background
        anchors.fill: parent
        color: "grey"

        Column {
            anchors.fill: parent

            MinesweeperTopBar {
                id: topBar
                anchors.left: parent.left
                anchors.right: parent.right
                height: 60

                flagsLeft: minesweeperBoard.flagsLeft
                timeTaken: timer.time

                onNewGameClicked: newGame()
                onPauseClicked: {
                    onPause();
                }
                onSettingsClicked: scene.settingsClicked()
            }

            Rectangle {
                id: stage
                width: parent.width
                height: background.height - topBar.height
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
                            difficulty: MSSettings.difficulty()
                            mode: MSSettings.mode()

                            onClicked: scene.start()
                            onWinLoseConditionMet: {
                                end();
                                winLoseOverlay.state = minesweeperModel.state;
                            }
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

                PauseOverlay {
                    id: pauseOverlay
                    anchors.fill: parent
                    enabled: false
                    opacity: enabled
                }

                SettingsOverlay {
                    id: settingsOverlay
                    anchors.fill: parent
                    enabled: false
                    opacity: enabled
                }

            }   //  Rectangle: stage

        }   //  Column

    }   //  Rectangle: background

    WinLoseOverlay {
        id: winLoseOverlay
        width: parent.width
        height: parent.height
        enabled: false
        y: enabled ? 0 : parent.height
        onOverlayClicked: {
            scene.state = "frozen";
        }
    }

    Timer {
        id: timer

        property int time: 0

        function reset() { time = 0; }

        interval: 1000
        repeat: true
        running: scene.state === "playing" && started
        onTriggered: time++
    }


    onSettingsClicked: {
        if (state !== "settings")
            state = "settings";
        else
            state = "playing";
    }


    states: [
        State {
            name: "playing"
        },
        State {
            name: "frozen"
            PropertyChanges { target: minesweeperBoard; enabled: false }
        },
        State {
            name: "paused"
            PropertyChanges { target: minesweeperBoard; enabled: false }
            PropertyChanges { target: pauseOverlay; enabled: true }
        },
        State {
            name: "winLose"
            PropertyChanges { target: background; enabled: false }
            PropertyChanges { target: winLoseOverlay; enabled: true }
        },
        State {
            name: "settings"
            PropertyChanges { target: minesweeperBoard; enabled: false }
            PropertyChanges { target: settingsOverlay; enabled: true }
        }
    ]

}   //  Scene: scene
