import Felgo 3.0
import QtQuick 2.0

Scene {
    id: scene

    property alias minesweeperBoard: minesweeperBoard

    signal gotoSettings()

    // the "logical size" - the scene content is auto-scaled to match the GameWindow size
    width: 320
    height: 480

    visible: opacity != 0
    opacity: 0

    Component.onCompleted: {
        minesweeperBoard.generate();
    }

    // background rectangle matching the logical scene size (= safe zone available on all devices)
    // see here for more details on content scaling and safe zone: https://felgo.com/doc/felgo-different-screen-sizes/
    Rectangle {
        id: background
        anchors.fill: parent
        color: "grey"

        Column {
            anchors.fill: parent

            Rectangle {
                id: topBar
                anchors.left: parent.left
                anchors.right: parent.right
                height: 40
                z: 2

                color: "goldenrod"

                MouseArea {
                    anchors.fill: parent
                    onClicked: scene.gotoSettings()
                }
            }   //  Rectangle: topBar

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
                            let threshold = 10;

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

                        x: (parent.width - width) / 2
                        y: (parent.height - height) / 2
                        width: minesweeperBoard.width
                        height: minesweeperBoard.height

                        MinesweeperBoard {
                            id: minesweeperBoard

                            function generate() {
                                minesweeperModel.generateBombs();
                                updateGrid();
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

            }   //  Rectangle: stage

            Rectangle {
                id: bottomBar
                anchors.left: parent.left
                anchors.right: parent.right
                height: 40
                z: 2

                color: 'goldenrod'

                MouseArea {
                    anchors.fill: parent
                    onClicked: minesweeperBoard.generate()
                }
            }   //  Rectangle: bottomBar
        }   //  Column
    }   //  Rectangle: background

}   //  Scene: scene
