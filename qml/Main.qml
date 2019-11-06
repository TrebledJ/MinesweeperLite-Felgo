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
            id: background
            anchors.fill: parent
            color: "grey"

            Item {
                id: staticWrapper
                anchors.centerIn: parent
                width: wrapper.width
                height: wrapper.height

                Rectangle {
                    anchors.fill: parent
                    color: 'blue'
                    opacity: 0.25
                }

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
                        let rightMargin = background.width - (realX + wrapperRealWidth);
                        let topMargin = realY;
                        let bottomMargin = background.height - (realY + wrapperRealHeight);

                        //  modify this value to change the size of the margin
                        let threshold = 10;

                        //console.log('leftMargin=%1, rightMargin=%2'.arg(leftMargin).arg(rightMargin));
                        //console.log('topMargin=%1, bottomMargin=%2'.arg(topMargin).arg(bottomMargin));

                        //  snap wrapper.x and wrapper.y against the background
                        if (leftMargin < 0 && rightMargin > threshold) {
                            if (wrapperRealWidth < background.width - 2*threshold) {
                                //  wrapper fits within left + right thresholds
                                wrapper.x = (staticWrapper.width - wrapperRealWidth) / 2;
                                console.log('wrapper fits within 2 x thresholds');
                            } else {
                                wrapper.x = background.width - threshold - wrapperRealWidth - staticWrapper.x;
                                console.log('wrapper does not fit within 2 x thresholds');
                            }
                            console.log('readjusting wrapper.x:', wrapper.x);
                        }
                        if (rightMargin < 0 && leftMargin > threshold) {
                            if (wrapperRealWidth < background.width - 2*threshold) {
                                wrapper.x = (staticWrapper.width - wrapperRealWidth) / 2;
                                console.log('wrapper fits within 2 x thresholds');
                            } else {
                                wrapper.x = threshold - staticWrapper.x;
                                console.log('wrapper does not fit within 2 x thresholds');
                            }
                            console.log('readjusting wrapper.x:', wrapper.x);
                        }
                        if (topMargin < 0 && bottomMargin > threshold) {
                            if (wrapperRealHeight < background.height - 2*threshold) {
                                //  wrapper fits within top + bottom thresholds
                                wrapper.y = (staticWrapper.height - wrapperRealHeight) / 2;
                                console.log('wrapper fits within 2 y thresholds');
                            } else {
                                wrapper.y = background.height- threshold - wrapperRealHeight - staticWrapper.y;
                                console.log('wrapper does not fit within 2 y thresholds');
                            }
                            console.log('readjusting wrapper.y:', wrapper.y);
                        }
                        if (bottomMargin < 0 && topMargin > threshold) {
                            if (wrapperRealHeight < background.height - 2*threshold) {
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

                        function generate() {
                            minesweeperModel.generateBombs();
                            updateGrid();
                        }
                    }

                    Item {
                        id: proxy
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
            }

        }   //  Rectangle: background
    }   //  Scene: scene

    Component.onCompleted: {
        minesweeperBoard.generate();
    }
}



//GameWindow {
//    visible: true
//    width: 640
//    height: 480

//    Rectangle {
//        id: rect
//        x: 100
//        y: 100
//        width: 300
//        height: 300

//        Rectangle {
//            x: 50
//            y: 50
//            width: 50
//            height: 50
//            color: "blue"
//        }

//        Rectangle {
//            x: 100
//            y: 100
//            width: 50
//            height: 50
//            color: "red"
//        }


//        transform: Scale {
//            id: tform
//        }

//        Item {
//            id: proxy
//            onScaleChanged: {
//                let zoomFactor = pinchArea.scale / pinchArea.previousScale;

//                var realX = pinchArea.center.x * tform.xScale;
//                var realY = pinchArea.center.y * tform.yScale;
//                rect.x += (1 - zoomFactor) * realX;
//                rect.y += (1 - zoomFactor) * realY;
//                tform.xScale *= zoomFactor;
//                tform.yScale *= zoomFactor;
//            }
//        }

//        PinchArea {
//            id: pinchArea
//            property var center
//            property double previousScale
//            property double scale

//            anchors.fill: parent
//            pinch.target: proxy
//            pinch.minimumScale: 0.1
//            pinch.maximumScale: 10
//            onPinchStarted: {
//                center = pinch.center;
//                previousScale = pinch.previousScale;
//                scale = pinch.scale;
//            }
//            onPinchUpdated: {
//                center = pinch.center;
//                previousScale = pinch.previousScale;
//                scale = pinch.scale;
//            }
//            onPinchFinished: {
//                previousScale = 1;
//                scale = 1;
//            }
//        }

////        MouseArea {
////            anchors.fill: parent
////            property double factor: 1.01
////            onWheel:
////            {
////                console.log('rect.x=%1, rect.y=%2'.arg(rect.x).arg(rect.y))
////                if(wheel.angleDelta.y > 0)  // zoom in
////                    var zoomFactor = factor
////                else                        // zoom out
////                    zoomFactor = 1/factor

////                var realX = wheel.x * tform.xScale
////                var realY = wheel.y * tform.yScale
////                rect.x += (1-zoomFactor)*realX
////                rect.y += (1-zoomFactor)*realY
////                tform.xScale *=zoomFactor
////                tform.yScale *=zoomFactor

////            }
////        }
//    }
//}
