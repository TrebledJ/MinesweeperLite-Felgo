pragma Singleton
import QtQuick 2.0
import Felgo 3.0

import "../js/MSEnum.js" as MSEnum

Item {
    id: item

    property int difficultyIndex: 0
    property int modeIndex: 0

    property QtObject settings


    function difficulty() {
        return MSEnum.Difficulty.index(difficultyIndex);
    }

    function mode() {
        return MSEnum.Mode.index(modeIndex);
    }

    function incrementDifficultyIndex() {
        difficultyIndex = (difficultyIndex + 1) % MSEnum.Difficulty.count;
    }

    function incrementModeIndex() {
        modeIndex = (modeIndex + 1) % MSEnum.Mode.count;
    }


    onSettingsChanged: {
        console.warn("Settings changed");

        if (settings === undefined || settings === null)
            return;

        var tmpDifficulty = settings.getValue("difficultyIndex");
        if (tmpDifficulty !== undefined)
            difficultyIndex = tmpDifficulty;
        else
            settings.setValue("difficultyIndex", 0);

        var tmpMode = settings.getValue("modeIndex");
        if (tmpMode !== undefined)
            modeIndex = tmpMode;
        else
            settings.setValue("modeIndex", 0);
    }

    onDifficultyIndexChanged: {
        settings.setValue("difficultyIndex", difficultyIndex);
        console.log("di changed:", difficultyIndex);
    }

    onModeIndexChanged: {
        settings.setValue("modeIndex", modeIndex);
        console.log("mi changed:", modeIndex);
    }

}
