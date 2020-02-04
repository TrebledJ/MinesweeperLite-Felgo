import Felgo 3.0
import QtQuick 2.0

import "../js/MSLogic.js" as MSLogic
import "../js/MSTarget.js" as MSTarget
import "../js/MSEnum.js" as MSEnum

Item {
    id: minesweeperBoard

    signal clicked()

    property var minesweeperModel: new MSLogic.MSModel(8, 8, MSTarget.target["Normal"], 0.12)
    property alias grid: grid
    property int flagsLeft: minesweeperModel.flagsLeft()
    property var difficulty: MSEnum.Difficulty.Beginner
    property var mode: MSEnum.Mode.Normal

    property real defaultWidth: width
    property real defaultHeight: height

    width: grid.width
    height: grid.height

    function generate() {
        updateModel();
        minesweeperModel.generateBombs();
        updateGrid();
    }

    function updateModel() {
        if (difficulty === MSEnum.Difficulty.Beginner) {
            minesweeperModel.setDimensions(8, 8);
            minesweeperModel.mineDensity = 0.16;
        } else if (difficulty === MSEnum.Difficulty.Intermediate) {
            minesweeperModel.setDimensions(16, 16);
            minesweeperModel.mineDensity = 0.16;
        } else if (difficulty === MSEnum.Difficulty.Advanced) {
            minesweeperModel.setDimensions(16, 30);
            minesweeperModel.mineDensity = 0.21;
        } else if (difficulty === MSEnum.Difficulty.Custom) {
            //  TODO add custom dimensions/density
            console.warn("'Difficulty: Custom' has not yet been implemented.");
        }
        minesweeperModel.targets = MSTarget.target[mode];
        if (mode === MSEnum.Mode.Swath) {
            console.log('Swath detected')
            minesweeperModel.mineDensity /= 2;
        }
    }

    function updateGrid() {
        grid.rows = minesweeperModel.height;
        grid.columns = minesweeperModel.width;
        flagsLeft = minesweeperModel.flagsLeft();

        for (let i = 0; i < grid.rows; ++i)
            for (let j = 0; j < grid.columns; ++j) {
                gridRepeater.itemAt(i*grid.columns + j).isOpen = minesweeperModel.model[i][j].isOpen;
                gridRepeater.itemAt(i*grid.columns + j).isFlagged = minesweeperModel.model[i][j].isFlagged;
                gridRepeater.itemAt(i*grid.columns + j).value = minesweeperModel.model[i][j].value;
            }
    }

    function useDebugModel() {
        minesweeperModel = MSLogic.MSModel.useDebugModel();
    }

    function debug() {
        minesweeperModel.debug();
    }

    Component.onCompleted: {
        console.log('from MSBoard.qml:', MSEnum.Mode.Normal)
    }

    Grid {
        id: grid

        property real squareSize: Math.min((defaultWidth - (grid.columns-1)*grid.spacing)/grid.columns, (defaultHeight - (grid.rows-1)*grid.spacing)/grid.rows)

        rows: minesweeperModel.height
        columns: minesweeperModel.width
        spacing: 2 * (8 / Math.min(grid.columns, grid.rows))

        Repeater {
            id: gridRepeater
            model: grid.rows * grid.columns
            MinesweeperSquare {
                width: grid.squareSize
                height: grid.squareSize

                function open() {
                    minesweeperModel.open(index % grid.columns, Math.floor(index / grid.columns));
                    updateGrid();
                }

                function flag() {
                    if (flagsLeft > 0) {
                        minesweeperModel.flag(index % grid.columns, Math.floor(index / grid.columns));
                        updateGrid();
                    }
                }

                onClicked: {
                    if (!isFlagged)
                        open();

                    minesweeperBoard.clicked();
                }
                onRightClicked: {
                    flag();
                    minesweeperBoard.clicked();
                }
                onPressAndHold: {
                    flag();
                    minesweeperBoard.clicked();
                }

            }
        }
    }
}
