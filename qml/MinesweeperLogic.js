.pragma library

//class MinesweeperCell {
//    constructor() {
//        this.isOpen = false;
//        this.isFlagged = false;
//        this.value = 0;
//    }
//}

function MinesweeperCell() {
    this.isOpen = false;
    this.isFlagged = false;
    this.value = 0;
}


function randomInt(low, high) {
    return Math.floor(low + (high - low) * Math.random());
}


//function MinesweeperModel(width, height, targets, mineDensity) {
//    this.width = width;
//    this.height = height;
//    this.model = new Array(height);
//    for (let i = 0; i < height; ++i) {
//        this.model[i] = new Array(width);
//        for (let j = 0; j < width; ++j)
//            this.model[i][j] = new MinesweeperCell();
//    }

//    this.targets = targets;
//    this.mineDensity = mineDensity;
//}


//MinesweeperModel.prototype.filterTargetsOnPoint = function(x, y) {
//    return this.targets.filter(t => (0 <= x+t.x && x+t.x < this.width && 0 <= y+t.y && y+t.y < this.height));
//}

//MinesweeperModel.prototype.open = function(x, y) {
//    //  check out of bounds
//    if (!(0 <= x && x < this.width && 0 <= y && y < this.height))
//        return;

//    var cell = this.model[y][x];
//    if (cell.isOpen) {
//        //  todo implement "check adjacent flags and open adjacent closed"

//        return;
//    }

//    cell.isOpen = true;

//    if (cell.value === 0) {
//        var filteredTargets = this.filterTargetsOnPoint(x, y);
//        filteredTargets.map(t => open(x + t.x, y + t.y));
//    }
//}

//MinesweeperModel.prototype.flag = function(x, y) {
//    this.model[y][x].isFlagged = !this.model[y][x].isFlagged;
//}

//MinesweeperModel.prototype.generateBombs = function() {
//    //  reset squares
//    this.reset();

//    var array = new Array(this.width * this.height);
//    for (let i = 0; i < this.width * this.height; ++i)
//        array[i] = Qt.point(i % this.width, Math.floor(i / this.height));

//    //  set bombs
//    for (let i = 0; i < 0.1 * this.width * this.height; ++i) {
//        var randomIndex = randomInt(0, array.length);
//        this.model[array[randomIndex].y][array[randomIndex].x].value = -1;
//        array.splice(randomIndex, 1);
//    }

//    //  set value for leftovers
//    for (let i = 0; i < array.length; ++i) {
//        var count = 0;
//        for (var t = 0; t < this.targets.length; ++t) {
//            var dx = this.targets[t].x;
//            var dy = this.targets[t].y;
//            if (0 <= array[i].x + dx && array[i].x + dx < 8 && 0 <= array[i].y + dy && array[i].y + dy < 8) {
//                count += (this.model[array[i].y][array[i].x].value === -1);
//            }
//        }

//        this.model[array[i].y][array[i].x].value = count;
//    }
//}

//MinesweeperModel.prototype.reset = function() {
//    for (let i = 0; i < this.height; ++i) {
//        for (let j = 0; j < this.width; ++j) {
//            this.model[i][j].isOpen = false;
//            this.model[i][j].isFlagged = false;
//            this.model[i][j].value = 0;
//        }
//    }
//}


class MinesweeperModel {
    constructor(width, height, targets, mineDensity) {
        this.width = width;
        this.height = height;
        this.model = new Array(height);
        for (let i = 0; i < height; ++i) {
            this.model[i] = new Array(width);
            for (let j = 0; j < width; ++j)
                this.model[i][j] = new MinesweeperCell();
        }

        this.targets = targets;
        this.mineDensity = mineDensity;
    }

    filterTargetsOnPoint(x, y) {
        return this.targets.filter(t => (0 <= x+t.x && x+t.x < this.width && 0 <= y+t.y && y+t.y < this.height));
    }

    open(x, y) {
        //  check out of bounds
        if (!(0 <= x && x < this.width && 0 <= y && y < this.height))
            return;

        var cell = this.model[y][x];
        if (cell.isOpen) {
            //  todo implement "check adjacent flags and open adjacent closed"
            return;
        }

        cell.isOpen = true;

        if (cell.value === 0) {
            var filteredTargets = this.filterTargetsOnPoint(x, y);
            filteredTargets.map(t => this.open(x + t.x, y + t.y));
        }
    }

    flag(x, y) {
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
            let count = filteredTargets.filter(t => this.model[array[i].y + t.y][array[i].x + t.x].value === -1).length;
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
