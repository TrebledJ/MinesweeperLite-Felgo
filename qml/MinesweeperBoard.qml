import Felgo 3.0
import QtQuick 2.0

import "MinesweeperLogic.js" as MSLogic
import "MinesweeperTarget.js" as MSTarget

Item {
    id: item

    property var minesweeperModel: new MSLogic.MinesweeperModel(8, 8, MSTarget.Normal, 0.12)



    width: grid.width
    height: grid.height

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
            }
        }
    }

    function updateGrid() {
        for (let i = 0; i < grid.rows; ++i)
            for (let j = 0; j < grid.columns; ++j) {
                gridRepeater.itemAt(i*grid.columns + j).isOpen = minesweeperModel.model[i][j].isOpen;
                gridRepeater.itemAt(i*grid.columns + j).isFlagged = minesweeperModel.model[i][j].isFlagged;
                gridRepeater.itemAt(i*grid.columns + j).value = minesweeperModel.model[i][j].value;
            }
    }
}
