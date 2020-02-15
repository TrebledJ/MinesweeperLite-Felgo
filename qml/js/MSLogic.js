.pragma library

.import "MSTarget.js" as MSTarget

class MSCell {
    constructor(isOpen=false, isFlagged=false, value=0) {
        this.isOpen = isOpen;
        this.isFlagged = isFlagged;
        this.value = value;
    }

    get isBomb() {
        return this.value === -1;
    }
}


const State = {
    Win: "win",
    Lose: "lose",
    Active: "active",
};


/**
  @brief    Generates a random integer in the range [low, high).
**/
function randomInt(low, high) {
    return Math.floor(low + (high - low) * Math.random());
}

/**
  @brief    Inserts an element into a sorted array in-place, maintaining the sorted property. No insertion occurs if the element is a duplicate.
  @param    array: Array[<T>]: A sorted array.
  @param    e: <T>: The element to be inserted. Note that the element must be comparable.
**/
function sortedSetInsertion(array, e) {
    for (var i = 0; i < array.length; ++i) {
        if (array[i] === e)
            return;

        if (array[i] > e) {
            break;
        }
    }
    array.splice(i, 0, e);
}


class MSModel {
    constructor(width, height, targets, mineDensity) {
        this.width = width;
        this.height = height;
        this.model = new Array(height);
        for (let i = 0; i < height; ++i) {
            this.model[i] = new Array(width);
            for (let j = 0; j < width; ++j)
                this.model[i][j] = new MSCell();
        }
        this.targets = targets;
        this.mineDensity = mineDensity;

        this.countOpened = 0;
        this.firstClick = true;
        this.state = State.Active;
    }

    setDimensions(width, height) {
        this.width = width;
        this.height = height;
        this.model = new Array(height);
        for (let i = 0; i < height; ++i) {
            this.model[i] = new Array(width);
            for (let j = 0; j < width; ++j)
                this.model[i][j] = new MSCell();
        }
    }

    index(x, y) {
        return y * this.width + x;
    }

    unindex(idx) {
        return Qt.point(idx % this.width, Math.floor(idx / this.width));
    }

    numBombs() {
        return Math.floor(this.mineDensity * this.width * this.height);
    }

    flagsLeft() {
        let flags = this.numBombs();
        for (let i = 0; i < this.height; ++i) {
            for (let j = 0; j < this.width; ++j) {
                if (this.model[i][j].isFlagged && !this.model[i][j].isOpen)
                    flags--;
                if (this.model[i][j].isOpen && this.model[i][j].isBomb)
                    flags--;
            }
        }
        return flags;
    }

    __filterTargetsOnPoint(x, y) {
        return this.targets.filter(t => (0 <= x+t.x && x+t.x < this.width && 0 <= y+t.y && y+t.y < this.height));
    }

    __calculateValue(x, y) {
        const filteredTargets = this.__filterTargetsOnPoint(x, y);
        return filteredTargets.reduce((acc, t) => acc + this.model[y + t.y][x + t.x].isBomb * t.weight, 0);
    }

    /**
      @brief    Opens the cell at the coordinates (x, y), where (0, 0) is the top-left corner of the board.
      @param    x: Number
      @param    y: Number
    **/
    __openRecursive(x, y) {
        let cell = this.model[y][x];
        const filteredTargets = this.__filterTargetsOnPoint(x, y);

        if (cell.isOpen)
            return;

        if (!cell.isFlagged) {
            cell.isOpen = true;

            if (cell.isBomb)
                this.state = State.Lose;
            else
                this.countOpened++;

            //  cascade
            if (cell.value === 0) {
                filteredTargets.map(t => this.__openRecursive(x + t.x, y + t.y));
            }
        }
    }

    /**
      @brief    Manages the opening of cells. Opens closed cells. Chords on opened non-zero/non-bomb cells
      @param    x: Number
      @param    y: Number
    **/
    open(x, y) {
        if (this.firstClick) {
            this.firstClick = false;
            this.__handleFirstClick(x, y);
        }

        const cell = this.model[y][x];
        const filteredTargets = this.__filterTargetsOnPoint(x, y);
        if (cell.isOpen) {
            if (cell.value === 0)
                return;

            //  check adjacent flags and open adjacent closed
            const valueOpenBombs = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isOpen && this.model[y + t.y][x + t.x].isBomb) * t.weight, 0);
            const valueClosedFlagged = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isFlagged && !this.model[y+t.y][x+t.x].isOpen) * t.weight, 0);
            if (valueClosedFlagged + valueOpenBombs === cell.value) {
                //  chord
                filteredTargets.filter(t => !(this.model[y + t.y][x + t.x].isFlagged || this.model[y + t.y][x + t.x].isOpen)).map(t => this.__openRecursive(x + t.x, y + t.y));
            }

            this.__checkWinCondition();
            return;
        }

        this.__openRecursive(x, y);
        this.__checkWinCondition();
    }

    /**
      @brief    Flags or chord-flags the cell at the coordinates (x, y), where (0, 0) is the top-left corner of the board.
      @param    x: Number
      @param    y: Number
    **/
    flag(x, y) {
        if (this.model[y][x].isOpen) {
            const filteredTargets = this.__filterTargetsOnPoint(x, y);
            const filteredClosedTargets = filteredTargets.filter(t => !this.model[y + t.y][x + t.x].isOpen);
            const valueOpenBombs = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isOpen && this.model[y + t.y][x + t.x].isBomb) * t.weight, 0);
            const valueClosed = filteredClosedTargets.reduce((acc, t) => acc + t.weight, 0);

            //  execute flagging if value of closed cells and value of open bombs add up to clicked cell's value
            if (valueClosed + valueOpenBombs === this.model[y][x].value) {
                const valueClosedFlagged = filteredClosedTargets.reduce((acc, t) => acc + this.model[y + t.y][x + t.x].isFlagged * t.weight, 0);
                //  none are flagged or all are flagged
                if (valueClosedFlagged === 0 || valueOpenBombs + valueClosedFlagged === this.model[y][x].value) {
                    //  flag all or unflag all
                    filteredClosedTargets.map(t => this.flag(x + t.x, y + t.y));
                } else {
                    //  flag the unflagged
                    filteredClosedTargets.map(t => !(this.model[y + t.y][x + t.x].isFlagged) && this.flag(x + t.x, y + t.y));
                }

            }

            return;
        }

        this.model[y][x].isFlagged = !this.model[y][x].isFlagged;
    }


    /**
      @brief    Resets grid and generates bombs, whitelisted indices will never have bombs
      @param    whitelist: Array[Number]: Indices of the grid (row-major) to exclude when generating bombs
    **/
    generateBombs(whitelist=[]) {
        //  reset squares
        this.reset();

        let array = new Array(this.width * this.height);
        for (let i = 0; i < this.width * this.height; ++i) {
            if (!whitelist.includes(i))
                array[i] = this.unindex(i);
        }

        //  set bombs
        for (let i = 0; i < this.numBombs(); ++i) {
            const randomIndex = randomInt(0, array.length);
            this.model[array[randomIndex].y][array[randomIndex].x].value = -1;
            array.splice(randomIndex, 1);
        }
    }

    fillLeftovers() {
        for (let i = 0; i < this.height; ++i)
            for (let j = 0; j < this.width; ++j)
                if (!this.model[i][j].isBomb)
                    this.model[i][j].value = this.__calculateValue(j, i);
    }

    /**
      @brief    Handles a first click at the coordinates (x, y).
      @param    x: Number
      @param    y: Number
    **/
    __handleFirstClick(x, y) {
        let cell = this.model[y][x];
        const filteredTargets = this.__filterTargetsOnPoint(x, y);

        //  get surrounding indices to whitelist
        const whitelist = [this.index(x, y), ...filteredTargets.map(t => this.index(x + t.x, y + t.y))].sort((a, b) => a - b);

        //  get the number of bombs to relocate
        const nBombs = cell.isBomb + filteredTargets.filter(t => this.model[y + t.y][x + t.x].isBomb).length;

        cell.value = 0;
        filteredTargets.map(t => {
                                this.model[y + t.y][x + t.x].value = 0;
                            });

        this.__relocateBombsOnFirstClick(whitelist, nBombs);
        this.fillLeftovers();
    }

    /**
      @brief    Relocates bombs elsewhere on the grid.
      @param    whitelist: Array[Number]: Indices of the grid to exclude when relocating bombs
      @param    n: Number: The number of bombs to relocate
    **/
    __relocateBombsOnFirstClick(whitelist=[], n) {
        for (let i = 0; i < this.height; ++i) {
            for (let j = 0; j < this.width; ++j) {
                const idx = this.index(j, i);
                if (this.model[i][j].isBomb)
                    sortedSetInsertion(whitelist, idx);
            }
        }

        for (let i = 0; i < n; ++i) {
            const pt = this.__randomPoint(whitelist);
            this.model[pt.y][pt.x].value = -1;  //  set a bomb
            console.log("relocated bomb to (%1, %2)".arg(pt.x).arg(pt.y));

            sortedSetInsertion(whitelist, this.index(pt.x, pt.y));  //  add the point to the whitelist

            //  recalculate values of adjacent cells
            this.__filterTargetsOnPoint(pt.x, pt.y).map(t => {
                                                          if (!this.model[pt.y + t.y][pt.x + t.x].isBomb)
                                                            this.model[pt.y + t.y][pt.x + t.x].value = this.__calculateValue(pt.x + t.x, pt.y + t.y);
                                                      });
        }
    }

    /**
      @brief    Selects a random, non-whitelisted relocation point on the grid.
      @param    whitelist: Array[Number]: Indices of the grid to exclude. The list is assume to be sorted
      @return   Point: A valid relocation point
    **/
    __randomPoint(whitelist=[]) {
        let randomIdx = randomInt(0, this.width * this.height - whitelist.length);
        for (const idx of whitelist) {
            if (idx <= randomIdx)
                randomIdx++;
        }
        return this.unindex(randomIdx);
    }

    /**
      @brief    Checks for the win state.
    **/
    __checkWinCondition() {
        if (this.countOpened === this.width * this.height - this.numBombs()) {
            this.state = State.Win;
        }

        switch (this.state) {
        case State.Win:
            console.warn("You win!");
            break;
        case State.Lose:
            console.warn("You lose!");
            break;
        default:
            break;
        }
    }

    /**
      @brief    Resets each cell to the default setting and resets first click.
    **/
    reset() {
        console.log("reseting board");
        for (let i = 0; i < this.height; ++i) {
            for (let j = 0; j < this.width; ++j) {
                this.model[i][j].isOpen = false;
                this.model[i][j].isFlagged = false;
                this.model[i][j].value = 0;
            }
        }

        this.countOpened = 0;
        this.firstClick = true;
        this.state = State.Active;
    }

    debug() {
        console.log('.width=%1, .height=%2'.arg(this.width).arg(this.height));
        for (let i = 0; i < this.height; ++i) {
            let str = '';
            for (let j = 0; j < this.width; ++j) {
                str += this.model[i][j].value + ' ';
            }
            console.log(str);
        }
    }

    static useDebugModel() {
        const width = 8;
        const height = 8;
        let model = new MSModel(width, height, MSTarget.target["Normal"]);
        const board = [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 1, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
        ];
        model.model = new Array(height);
        for (let i = 0; i < height; ++i) {
            model.model[i] = new Array(width);
            for (let j = 0; j < width; ++j)
                model.model[i][j] = new MSCell(false, false, board[i][j]);
        }
        model.fillLeftovers();
        return model;
    }
}
