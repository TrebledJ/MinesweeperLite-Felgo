.pragma library

class MSCell {
    constructor() {
        this.isOpen = false;
        this.isFlagged = false;
        this.value = 0;
    }

    get isBomb() {
        return this.value === -1;
    }
}

/**
  @brief: Generates a random integer in the range [low, high).
**/
function randomInt(low, high) {
    return Math.floor(low + (high - low) * Math.random());
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

        this.firstClick = true;
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

    numBombs() {
        return Math.floor(this.mineDensity * this.width * this.height);
    }

    flagsLeft() {
        var flags = 0;
        var openBombs = 0;
        for (let i = 0; i < this.height; ++i) {
            for (let j = 0; j < this.width; ++j) {
                if (this.model[i][j].isFlagged && !this.model[i][j].isOpen)
                    flags++;
                if (this.model[i][j].isOpen && this.model[i][j].isBomb)
                    openBombs++;
            }
        }
        return this.numBombs() - flags - openBombs;
    }

    filterTargetsOnPoint(x, y) {
        return this.targets.filter(t => (0 <= x+t.x && x+t.x < this.width && 0 <= y+t.y && y+t.y < this.height));
    }

    calculateValue(x, y) {
        var filteredTargets = this.filterTargetsOnPoint(x, y);
        return filteredTargets.reduce((acc, t) => acc + this.model[y + t.y][x + t.x].isBomb * t.weight, 0);
    }

    /**
      @brief: Opens or chords the cell at the coordinates (x, y), where (0, 0) is the top-left corner of the board.
      @param x: Number
      @param y: Number
    **/
    open(x, y) {
        var cell = this.model[y][x];
        var filteredTargets = this.filterTargetsOnPoint(x, y);

        if (this.firstClick) {
            this.firstClick = false;

            while (filteredTargets.some(t => this.model[y + t.y][x + t.x].isBomb) || cell.value !== 0) {
                filteredTargets.map(t => this.model[y + t.y][x + t.x].isBomb ? this.relocate(x + t.x, y + t.y) : 0);

                if (cell.value !== 0) {
                    this.relocate(x, y);
                }
            }


        }

        if (cell.isOpen) {
            //  check adjacent flags and open adjacent closed
            let valueOpenBombs = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isOpen && this.model[y + t.y][x + t.x].isBomb) * t.weight, 0);
            let valueClosedFlagged = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isFlagged && !this.model[y+t.y][x+t.x].isOpen) * t.weight, 0);
            if (valueClosedFlagged + valueOpenBombs === cell.value) {
                //  chord
                filteredTargets.filter(t => !(this.model[y + t.y][x + t.x].isFlagged || this.model[y + t.y][x + t.x].isOpen)).map(t => this.open(x + t.x, y + t.y));
                //  unflag incorrect flags
//                filteredTargets.filter(t => this.model[y + t.y][x + t.x].isFlagged && !this.model[y + t.y][x + t.x].isBomb).map(t => this.flag(x + t.x, y + t.y));
            }
            return;
        }

        //  set cell to open
        cell.isOpen = true;

        //  cascade
        if (cell.value === 0) {
            filteredTargets.map(t => this.open(x + t.x, y + t.y));
        }
    }

    /**
      @brief: Flags or chord-flags the cell at the coordinates (x, y), where (0, 0) is the top-left corner of the board.
      @param x: Number
      @param y: Number
    **/
    flag(x, y) {
        if (this.model[y][x].isOpen) {
            let filteredTargets = this.filterTargetsOnPoint(x, y);
            let filteredClosedTargets = filteredTargets.filter(t => !this.model[y + t.y][x + t.x].isOpen);
            let valueOpenBombs = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isOpen && this.model[y + t.y][x + t.x].isBomb) * t.weight, 0);
            let valueClosed = filteredClosedTargets.reduce((acc, t) => acc + t.weight, 0);

            //  execute flagging if value of closed cells and value of open bombs add up to clicked cell's value
            if (valueClosed + valueOpenBombs === this.model[y][x].value) {
                let valueClosedFlagged = filteredClosedTargets.reduce((acc, t) => acc + this.model[y + t.y][x + t.x].isFlagged * t.weight, 0);
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
      @brief: resets grid and generates bombs, whitelisted indices will never have bombs
      @param whitelist: Array[Number] := indices of the grid (row-major) to exclude when generating bombs
    **/
    generateBombs(whitelist = []) {
        //  reset squares
        this.reset();

        var array = new Array(this.width * this.height);
        for (let i = 0; i < this.width * this.height; ++i) {
            if (!whitelist.includes(i))
                array[i] = Qt.point(i % this.width, Math.floor(i / this.width));
        }

        //  set bombs
        for (let i = 0; i < this.numBombs(); ++i) {
            let randomIndex = randomInt(0, array.length);
            this.model[array[randomIndex].y][array[randomIndex].x].value = -1;
            array.splice(randomIndex, 1);
        }


        //  add whitelist to array
        for (let i = 0; i < whitelist.length; ++i) {
            array.push(Qt.point(whitelist[i] % this.width, Math.floor(whitelist[i] / this.width)));
        }
        //  set value for leftovers
        for (let i = 0; i < array.length; ++i) {
            let count = this.calculateValue(array[i].x, array[i].y);
            this.model[array[i].y][array[i].x].value = count;
        }
    }

    /**
      @brief: Relocates the cell at (x, y) to a non-bomb point elsewhere on the board.
      @param x: Number
      @param y: Number
    **/
    relocate(x, y) {
        var point = this.selectRelocation(x, y);
        this.model[point.y][point.x].value = this.model[y][x].value;

        if (this.model[y][x].isBomb) {
            //  decrement adjacent cells of old bomb
            this.filterTargetsOnPoint(x, y).map(t => (!this.model[y+t.y][x+t.x].isBomb && !(x+t.x === point.x && y+t.y === point.y)) ? this.model[y+t.y][x+t.x].value -= t.weight : 0);
        }

        //  recalculates value of cell
        this.model[y][x].value = this.calculateValue(x, y);

        if (this.model[point.y][point.x].isBomb) {
            //  increment adjacent cells of new bomb
            this.filterTargetsOnPoint(point.x, point.y).map(t => (!this.model[point.y+t.y][point.x+t.x].isBomb && !(point.x+t.x === x && point.y+t.y === y)) ? this.model[point.y+t.y][point.x+t.x].value += t.weight : 0);
        }
        console.warn('relocated (%1, %2) to (%3, %4)'.arg(x).arg(y).arg(point.x).arg(point.y));
    }

    /**
      @brief: Selects a valid (non-bomb) relocation point from the coordinates (x, y).
      @param x: Number
      @param y: Number
    **/
    selectRelocation(x, y) {
        var resx = 0;
        var resy = 0;
        do {
//            resx++;
//            if (resx >= this.width) {
//                resx = 0;
//                resy++;
//            }
            resx = randomInt(0, this.width);
            resy = randomInt(0, this.height);
        } while (this.model[resy][resx].isBomb || (resx === x && resy === y));
        return Qt.point(resx, resy);
    }

    reset() {
        console.log("reseting board");
        for (let i = 0; i < this.height; ++i) {
            for (let j = 0; j < this.width; ++j) {
                this.model[i][j].isOpen = false;
                this.model[i][j].isFlagged = false;
                this.model[i][j].value = 0;
            }
        }
        this.firstClick = true;
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
}
