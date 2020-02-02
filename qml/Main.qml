import Felgo 3.0
import QtQuick 2.12

import "scenes"
import "settings"
import "js/MSEnum.js" as MSEnum

GameWindow {
    id: gameWindow

    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
    // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
    // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
    // this resolution is for iPhone 4 & iPhone 4S
    screenWidth: 640
    screenHeight: 960

    Component.onCompleted: {
        console.warn("Settings.ready:", MSSettings.ready);
        MSSettings.settings = gameWindow.settings;
//        MSSettings.ready = true;
    }

    MinesweeperScene {
        id: minesweeperScene
//        minesweeperBoard.difficulty: MSEnum.Difficulty.index(settingsScene.difficultyIndex)
//        minesweeperBoard.mode: MSEnum.Mode.index(settingsScene.modeIndex)
        onGotoSettings: {
            gameWindow.state = "settingsScene";
        }
    }

    SettingsScene {
        id: settingsScene
        onBackButtonPressed: {
            gameWindow.state = "minesweeperScene";
        }
    }

    state: "minesweeperScene"
    states: [
        State {
            name: "minesweeperScene"
            PropertyChanges { target: gameWindow; activeScene: minesweeperScene }
            PropertyChanges { target: minesweeperScene; opacity: 1 }
        },
        State {
            name: "settingsScene"
            PropertyChanges { target: gameWindow; activeScene: settingsScene }
            PropertyChanges { target: settingsScene; opacity: 1 }
        }
    ]

//    Connections {
//        target: MSSettings

//        onDifficultyIndexChanged: {
//            gameWindow.settings.setValue("difficultyIndex", difficultyIndex);
//            console.log("di changed");
//        }

//        onModeIndexChanged: {
//            gameWindow.settings.setValue("modeIndex", modeIndex);
//            console.log("mi changed");
//        }
//    }
}
