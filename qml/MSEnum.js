.pragma library


class Difficulty {
    static get Beginner() { return "Beginner"; }
    static get Intermediate() { return "Intermediate"; }
    static get Advanced() { return "Advanced"; }
    static get Custom() { return "Custom"; }

    static get count() { return 4; }
    static index(i) { return [Difficulty.Beginner, Difficulty.Intermediate, Difficulty.Advanced, Difficulty.Custom][i]; }
}

class Mode {
    static get Normal() { return "Normal"; }
    static get Doubled() { return "Doubled"; }
    static get Orth() { return "Orth"; }
    static get Knight() { return "Knight"; }
    static get Swath() { return "Swath"; }

    static get count() { return 5; }
    static index(i) { return [Mode.Normal, Mode.Doubled, Mode.Orth, Mode.Knight, Mode.Swath][i]; }
}
