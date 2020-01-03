#ifndef MSMODEL_H
#define MSMODEL_H

#include <QObject>
#include <QVector>

class MSModel : public QObject
{
    Q_OBJECT
public:
    explicit MSModel(QObject *parent = nullptr);

signals:

public slots:

private:
    int width;
    int height;
//    QVector v;
};

#endif // MSMODEL_H
