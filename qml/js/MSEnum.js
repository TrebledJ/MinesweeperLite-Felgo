.pragma library


class Difficulty {
    static get Beginner() { return "Beginner"; }
    static get Intermediate() { return "Intermediate"; }
    static get Advanced() { return "Advanced"; }
    static get Custom() { return "Custom"; }

    static get list() { return [Difficulty.Beginner, Difficulty.Intermediate, Difficulty.Advanced, Difficulty.Custom]; }
    static get count() { return Difficulty.list.length; }
    static index(i) { return Difficulty.list[i]; }
}

class Mode {
    static get Normal() { return "Normal"; }
    static get Doubled() { return "Doubled"; }
    static get Knight() { return "Knight"; }
    static get Orth() { return "Orth"; }
    static get Swath() { return "Swath"; }

    static get list() { return [Mode.Normal, Mode.Doubled, Mode.Knight, Mode.Orth, Mode.Swath]; }
    static get count() { return Mode.list.length; }
    static index(i) { return Mode.list[i]; }
}
