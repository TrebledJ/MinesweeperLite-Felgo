.pragma library

class Target {
    constructor(point, weight) {
        this.x = point.x;
        this.y = point.y;
        this.weight = weight;
    }
}

var Normal = [
    new Target(Qt.point(-1, -1), 1),
    new Target(Qt.point(+0, -1), 1),
    new Target(Qt.point(+1, -1), 1),
    new Target(Qt.point(-1, +0), 1),
    new Target(Qt.point(+1, +0), 1),
    new Target(Qt.point(-1, +1), 1),
    new Target(Qt.point(+0, +1), 1),
    new Target(Qt.point(+1, +1), 1),
]
