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

const Knight = [
                 new Target(Qt.point(-2, -1), 1),
                 new Target(Qt.point(-1, -2), 1),
                 new Target(Qt.point(+1, -2), 1),
                 new Target(Qt.point(+2, -1), 1),
                 new Target(Qt.point(+2, +1), 1),
                 new Target(Qt.point(+1, +2), 1),
                 new Target(Qt.point(-1, +2), 1),
                 new Target(Qt.point(-2, +1), 1),
             ];

const Orth = [
               new Target(Qt.point(-1, +0), 1),
               new Target(Qt.point(+0, +1), 1),
               new Target(Qt.point(+1, +0), 1),
               new Target(Qt.point(+0, -1), 1),
           ];

const Swath = [
                new Target(Qt.point(-2, -2), 1),
                new Target(Qt.point(-1, -2), 1),
                new Target(Qt.point(+0, -2), 1),
                new Target(Qt.point(+1, -2), 1),
                new Target(Qt.point(+2, -2), 1),

                new Target(Qt.point(-2, -1), 1),
                new Target(Qt.point(-1, -1), 1),
                new Target(Qt.point(+0, -1), 1),
                new Target(Qt.point(+1, -1), 1),
                new Target(Qt.point(+2, -1), 1),

                new Target(Qt.point(-2, +0), 1),
                new Target(Qt.point(-1, +0), 1),
                new Target(Qt.point(+1, +0), 1),
                new Target(Qt.point(+2, +0), 1),

                new Target(Qt.point(-2, +1), 1),
                new Target(Qt.point(-1, +1), 1),
                new Target(Qt.point(+0, +1), 1),
                new Target(Qt.point(+1, +1), 1),
                new Target(Qt.point(+2, +1), 1),

                new Target(Qt.point(-2, +2), 1),
                new Target(Qt.point(-1, +2), 1),
                new Target(Qt.point(+0, +2), 1),
                new Target(Qt.point(+1, +2), 1),
                new Target(Qt.point(+2, +2), 1),
            ];

const target = {
    Normal,
    Doubled,
    Knight,
    Orth,
    Swath,
};
