.pragma library

class MSCell {
    constructor() {
        this.isOpen = false;
        this.isFlagged = false;
        this.value = 0;
    }
}

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
    }

    filterTargetsOnPoint(x, y) {
        return this.targets.filter(t => (0 <= x+t.x && x+t.x < this.width && 0 <= y+t.y && y+t.y < this.height));
    }

    open(x, y) {
        var cell = this.model[y][x];
        if (cell.isOpen) {
            //  check adjacent flags and open adjacent closed
            let filteredTargets = this.filterTargetsOnPoint(x, y);
            let valueOpenBombs = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isOpen && this.model[y + t.y][x + t.x].value === -1) * t.weight, 0);
            let valueFlagged = filteredTargets.reduce((acc, t) => acc + this.model[y + t.y][x + t.x].isFlagged * t.weight, 0);
            if (valueFlagged + valueOpenBombs === cell.value) {
                //  open the unopened and unflagged
                filteredTargets.filter(t => !(this.model[y + t.y][x + t.x].isFlagged || this.model[y + t.y][x + t.x].isOpen)).map(t => this.open(x + t.x, y + t.y));
                //  unflag incorrect flags
                filteredTargets.filter(t => this.model[y + t.y][x + t.x].isFlagged && this.model[y + t.y][x + t.x].value !== -1).map(t => this.flag(x + t.x, y + t.y));
            }
            return;
        }

        //  set cell to open
        cell.isOpen = true;

        //  cascade
        if (cell.value === 0) {
            let filteredTargets = this.filterTargetsOnPoint(x, y);
            filteredTargets.map(t => this.open(x + t.x, y + t.y));
        }
    }

    flag(x, y) {
        if (this.model[y][x].isOpen) {
            let filteredTargets = this.filterTargetsOnPoint(x, y);
            let filteredClosedTargets = filteredTargets.filter(t => !this.model[y + t.y][x + t.x].isOpen);
            let valueOpenBombs = filteredTargets.reduce((acc, t) => acc + (this.model[y + t.y][x + t.x].isOpen && this.model[y + t.y][x + t.x].value === -1) * t.weight, 0);
            let valueClosed = filteredClosedTargets.reduce((acc, t) => acc + t.weight, 0);

            //  execute flagging if value of closed cells and value of open bombs add up to clicked cell's value
            if (valueClosed + valueOpenBombs === this.model[y][x].value) {
                let valueClosedFlagged = filteredClosedTargets.reduce((acc, t) => acc + this.model[y + t.y][x + t.x].isFlagged * t.weight, 0);
                //  none are flagged or all are flagged
                if (valueClosedFlagged === 0 || valueOpenBombs + valueClosedFlagged == this.model[y][x].value) {
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

    generateBombs() {
        //  reset squares
        this.reset();

        var array = new Array(this.width * this.height);
        for (let i = 0; i < this.width * this.height; ++i)
            array[i] = Qt.point(i % this.width, Math.floor(i / this.height));

        //  set bombs
        for (let i = 0; i < 0.1 * this.width * this.height; ++i) {
            let randomIndex = randomInt(0, array.length);
            this.model[array[randomIndex].y][array[randomIndex].x].value = -1;
            array.splice(randomIndex, 1);
        }

        //  set value for leftovers
        for (let i = 0; i < array.length; ++i) {
            let filteredTargets = this.filterTargetsOnPoint(array[i].x, array[i].y);
            let count = filteredTargets.reduce((acc, t) => acc + (this.model[array[i].y + t.y][array[i].x + t.x].value === -1) * t.weight, 0);
            this.model[array[i].y][array[i].x].value = count;
        }
    }

    reset() {
        console.log('reseting board');
        for (let i = 0; i < this.height; ++i) {
            for (let j = 0; j < this.width; ++j) {
                this.model[i][j].isOpen = false;
                this.model[i][j].isFlagged = false;
                this.model[i][j].value = 0;
            }
        }
    }
}
