.pragma library

class Target {
    constructor(point, weight) {
        this.x = point.x;
        this.y = point.y;
        this.weight = weight;
    }
}

const Normal = [
            new Target(Qt.point(-1, -1), 1),
            new Target(Qt.point(+0, -1), 1),
            new Target(Qt.point(+1, -1), 1),
            new Target(Qt.point(-1, +0), 1),
            new Target(Qt.point(+1, +0), 1),
            new Target(Qt.point(-1, +1), 1),
            new Target(Qt.point(+0, +1), 1),
            new Target(Qt.point(+1, +1), 1),
        ];

const Doubled = [
            new Target(Qt.point(-1, -1), 1),
            new Target(Qt.point(+0, -1), 2),
            new Target(Qt.point(+1, -1), 1),
            new Target(Qt.point(-1, +0), 2),
            new Target(Qt.point(+1, +0), 2),
            new Target(Qt.point(-1, +1), 1),
            new Target(Qt.point(+0, +1), 2),
            new Target(Qt.point(+1, +1), 1),
        ];

const target = {
    Normal,
    Doubled,
};
