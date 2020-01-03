#include "mscell.h"

MSCell::MSCell(QObject *parent)
    : QObject(parent)
    , isOpen(false)
    , isFlagged(false)
    , value(0)
{

}
