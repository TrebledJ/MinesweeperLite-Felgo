#include <QApplication>
#include <FelgoApplication>

#include <QQmlApplicationEngine>
#include <QQmlContext>

//#define PUBLISH	//	 uncomment to publish

#ifndef PUBLISH
# include <FelgoLiveClient>
#endif

//#include <QDebug>


int main(int argc, char *argv[])
{

    QApplication app(argc, argv);


    FelgoApplication felgo;

    // QQmlApplicationEngine is the preferred way to start qml projects since Qt 5.2
    // if you have older projects using Qt App wizards from previous QtCreator versions than 3.1, please change them to QQmlApplicationEngine
    QQmlApplicationEngine engine;
    felgo.initialize(&engine);

#ifndef	PUBLISH
    // ** use this during development **
    felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml"));	//	comment for publishing
    // ** for PUBLISHING, use the entry point below **
#endif

    // use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
    // this is the preferred deployment option for publishing games to the app stores, because then your qml files and js files are protected
    // to avoid deployment of your qml files and images, also comment the DEPLOYMENTFOLDERS command in the .pro file
    // also see the .pro file for more details

#ifdef PUBLISH
    felgo.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml")); // uncomment for publishing
#endif

#ifdef PUBLISH
    engine.load(QUrl(felgo.mainQmlFileName()));	// uncomment for publishing
#else
    FelgoLiveClient liveClient(&engine);	//	comment to disable live client and/or for publishing
#endif

    return app.exec();
}
