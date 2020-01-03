import Felgo 3.0
import QtQuick 2.13

Scene {
    id: scene

//    property alias minesweeperBoard: minesweeperBoard

    signal gotoSettings()

    // the "logical size" - the scene content is auto-scaled to match the GameWindow size
    width: 320
    height: 480

    visible: opacity != 0
    opacity: 0

    Component.onCompleted: {
//        minesweeperBoard.generate();
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
                color: "green"
                opacity: 0.5

                scale: 0.25



                Rectangle {
                    id: dragWrapper
                    x: -stage.width
                    y: -stage.height
                    width: 3 * stage.width
                    height: 3 * stage.height
//                    width: Math.max(wrapper.width * wrapper.scale, stage.width) + 2 * stage.width
//                    height: Math.max(wrapper.height * wrapper.scale, stage.height) + 2 * stage.height
                    color: 'blue'
                    opacity: 0.25

                    DragHandler {
    //                    xAxis.minimum: (wrapper.width * wrapper.scale >= stage.width) ? -stage.width - wrapper.width * wrapper.scale + 20 : -stage.width
    //                    xAxis.maximum: (wrapper.width * wrapper.scale >= stage.width) ? -20 : -stage.width
                        yAxis.enabled: false
//                        onActiveChanged: {
//                            console.warn('dragHandler.active=%1'.arg(active));
//                            if (active) {
//                                const initialX = wrapper.x;
////                                wrapper.x = Qt.binding(function() {
////                                    console.log('dragWrapper.x=%1'.arg(dragWrapper.x))
////                                    console.log('initialX=%1; translation.x=%2'.arg(initialX).arg(translation.x));
////                                    return initialX + translation.x;
////                                })
//                            } else {
//                                const finalX = wrapper.x;
//                                wrapper.x = finalX;
//                            }
//                        }
                    }   //  DragHandler

                    Item {
                        id: wrapper
//                        x: (dragWrapper.width - width)/2
//                        y: (dragWrapper.height - height)/2
                        width: rect.width
                        height: rect.height

//                        Component.onCompleted: {
//                            x = (dragWrapper.width - width) / 2;
//                            y = (dragWrapper.height - height) / 2;
//                        }

                        Rectangle {
                            id: rect
                            width: 100
                            height: 100
                            color: 'red'
                            opacity: 0.8

//                            Rectangle {
//                                x: 0
//                                y: 0
//                                width: 20
//                                height: 20
//                                color: 'black'
//                            }

//                            Rectangle {
//                                x: 20
//                                y: 20
//                                width: 20
//                                height: 20
//                                color: 'yellow'
//                            }
                        }

                    }   //  Item: wrapper




//                    Rectangle {
//                        x: pinchHandler.centroid.position.x - width/2
//                        y: pinchHandler.centroid.position.y - height/2
//                        width: 16
//                        height: 16
//                        radius: width/2
//                        color: 'black'
//                    }

                }   //  Rectangle: dragWrapper


                PinchHandler {
                    id: pinchHandler
                    target: wrapper
                    xAxis.enabled: false
                    yAxis.enabled: false
                    minimumRotation: 0
                    maximumRotation: 0

                    onActiveChanged: {
                        console.warn('pinchHandler.active=%1'.arg(active))
                        if (!active) {
                            //  resize dragWrapper

                            const relativeWrapperX = wrapper.x / wrapper.scale;
                            const relativeWrapperY = wrapper.y / wrapper.scale;

                            const absoluteWrapperX = relativeWrapperX + dragWrapper.x;
                            const absoluteWrapperY = relativeWrapperY + dragWrapper.y;

                            console.log('relative.x=%1; .y=%2'.arg(relativeWrapperX).arg(relativeWrapperY))
                            console.log('absolute.x=%1; .y=%2'.arg(absoluteWrapperX).arg(absoluteWrapperY))

                            //  reposition wrapper within dragWrapper
//                                wrapper.x = (dragWrapper.width - wrapper.width) / 2;
//                                wrapper.y = (dragWrapper.height - wrapper.height) / 2;
                        }
                    }

                    onScaleChanged: {
                        console.log('pinchHandler.scale=%1'.arg(pinchHandler.scale))
                    }

                    onActiveScaleChanged: {
                        console.log('pinchHandler.activeScale=%1'.arg(pinchHandler.activeScale))
                    }
                }   //  PinchHandler



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
