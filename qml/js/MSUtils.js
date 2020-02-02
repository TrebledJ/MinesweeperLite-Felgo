.pragma library

function getValueColor(value) {
    if (!(0 < value && value < 20))
        return "black";

    switch(value) {
    case 1: return "blue";
    case 2: return "green";
    case 3: return "red";
    case 4: return "purple";
    case 5: return "maroon";
    case 6: return "turquoise";
    case 7: return "black";
    case 8:
    default:
        return "gray";
    }
}
