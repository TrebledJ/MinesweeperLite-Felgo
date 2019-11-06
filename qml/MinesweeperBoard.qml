import Felgo 3.0
import QtQuick 2.0

import "MSLogic.js" as MSLogic
import "MSTarget.js" as MSTarget

Item {
    id: item

    property var minesweeperModel: new MSLogic.MSModel(8, 8, MSTarget.Normal, 0.12)
    property alias grid: grid

    //  todo introduce pinch-zoom, drag-move gui features
    //  todo generalise with a settings scene

    width: grid.width
    height: grid.height


    Component.onCompleted: {

    }

    Grid {
        id: grid

        rows: 8
        columns: 8
        spacing: 2

        Repeater {
            id: gridRepeater
            model: grid.rows * grid.columns
            MinesweeperSquare {
                width: 30
                height: 30

                onClicked: {
                    minesweeperModel.open(index % grid.columns, Math.floor(index / grid.rows));
                    updateGrid();
                }
                onRightClicked: {
                    minesweeperModel.flag(index % grid.columns, Math.floor(index / grid.rows))
                    updateGrid();
                }
                onPressAndHold: {
                    minesweeperModel.flag(index % grid.columns, Math.floor(index / grid.rows))
                    updateGrid();
                }
            }
        }
    }

    function updateGrid() {
        var i, j;
        for (i = 0; i < grid.rows; ++i)
            for (j = 0; j < grid.columns; ++j) {
                gridRepeater.itemAt(i*grid.columns + j).isOpen = minesweeperModel.model[i][j].isOpen;
                gridRepeater.itemAt(i*grid.columns + j).isFlagged = minesweeperModel.model[i][j].isFlagged;
                gridRepeater.itemAt(i*grid.columns + j).value = minesweeperModel.model[i][j].value;
            }
    }
}
