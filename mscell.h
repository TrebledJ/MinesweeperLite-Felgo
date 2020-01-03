#ifndef MSCELL_H
#define MSCELL_H

#include <QObject>

class MSCell : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isOpen MEMBER isOpen NOTIFY isOpenChanged)
    Q_PROPERTY(bool isFlagged MEMBER isFlagged NOTIFY isFlaggedChanged)
    Q_PROPERTY(int value MEMBER value NOTIFY valueChanged)
public:
    explicit MSCell(QObject *parent = nullptr);

    bool isOpen;
    bool isFlagged;
    int value;
signals:
    void isOpenChanged();
    void isFlaggedChanged();
    void valueChanged();
};

#endif // MSCELL_H
