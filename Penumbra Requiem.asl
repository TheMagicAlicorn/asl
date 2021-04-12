//-----------------------------------------------------------------
//  About: Load Remover & Auto Splitter
//  Author: MagicALCN
//  Version: 1.0.0
//  Last Release Date: 08 April 2021
//-----------------------------------------------------------------


state("requiem") {
    // Our variable needed to retrieve the name of the loaded level.
    string7 levelName: 0x2DECD8, 0x16C, 0x24, 0xF4;

    // The InGame time in seconds (and milliseconds in the decimal part)
    // It is reset to 0 when returning to the game after a death or a save reload for example
    float gameTime: 0x2DECD8, 0x188, 0x4C, 0x1C;

    //This is the old variable to pause the timer while in loading. I find it useful for the auto-reset.
    int isLoading: 0x2DECD8, 0x15C, 0x368;
}


startup {
    vars.prevPhase = null; // The previous LiveSplit timer status
    vars.loadedTime = 0; // Variable to save the ingame time when you die or reload the level
    vars.clarenceSkip = false; // The trick to skip the effects of Clarence in the Residental Corridors by going back into Dr. Swanson's office
    vars.category = timer.Run.CategoryName.ToLower();

    //Boolean settings to select the desired splits
    settings.Add("Any%");
        settings.Add("01_to_02_any", true, "Tomb to Residental", "Any%");
        settings.Add("02_to_03_any", true, "Residental to Vertical Shaft", "Any%");
        settings.Add("03_to_04_any", true, "Vertical Shaft to Sewer", "Any%");
        settings.Add("04_to_05_any", true, "Sewer to Surface Station", "Any%");
        settings.Add("05_to_06_any", true, "Surface Station to Power Station", "Any%");
        settings.Add("06_to_07_any", true, "Power Station to Engine", "Any%");
        settings.Add("07_to_08_any", true, "Engine to Steam", "Any%");
        settings.Add("08_to_09_any", true, "Steam to Closure", "Any%");
}


update {
    if (current.gameTime == 0 && old.gameTime > 0) { // If we come back into the game after a death or a save reload
        vars.loadedTime += old.gameTime; // We save the previous ingame time
    }
    if (timer.CurrentPhase == TimerPhase.Running && vars.prevPhase == TimerPhase.NotRunning) // If the LiveSplit timer has just started (e.g. new run)
        vars.loadedTime = 0; // We reset the saved ingame time

    vars.prevPhase = timer.CurrentPhase; // Saving the previous state of the LiveSplit timer
}


isLoading {
    // Prevents the use of the LiveSplit timer to use ingame time
    return true;
}


gameTime {
    return TimeSpan.FromSeconds(current.gameTime + vars.loadedTime); // The ingame time is therefore the current ingame time plus the saved one
}


reset {
  return (current.gameTime == 0 && (current.levelName == "level01") && current.isLoading != 0); // If a new game is found, we reset the splits
}


start {
    bool starting = old.gameTime == 0 && current.gameTime > 0 && (current.levelName == "level01"); // If we start a new game
    if (starting) { // We reset our variables
        vars.clarenceSkip = false;
    }
    return starting;
}


split {
    if (vars.category.Contains("any")) {
        // Basically we look at the name of the previous level with the new one to see if we should split
        if (settings["01_to_02_any"] && current.levelName == "level02" && old.levelName == "level01")
            return true;
        if (settings["02_to_03_any"] && current.levelName == "level03" && old.levelName == "level02")
            return true;
        if (settings["03_to_04_any"] && current.levelName == "level04" && old.levelName == "level03")
            return true;
        if (settings["04_to_05_any"] && current.levelName == "level05" && old.levelName == "level04")
            return true;
        if (settings["05_to_06_any"] && current.levelName == "level06" && old.levelName == "level05")
            return true;
        if (settings["06_to_07_any"] && current.levelName == "level07" && old.levelName == "level06")
            return true;
        if (settings["07_to_08_any"] && current.levelName == "level08" && old.levelName == "level07")
            return true;
        if (settings["08_to_09_any"] && current.levelName == "level09" && old.levelName == "level08")
            return true;
    }

    //If an unknown category exists, here's a simple autosplitter
    else if (current.levelName != old.levelName)
        return true;

    // The end-of-run detection condition
    // The use of the wallCounter is essential because the computerEnding is also triggered during the first interaction with the computer
    //if (current.wallCounter == 4 && current.levelName == "level22_ending" && old.computerEnding == 1 && current.computerEnding == 0)
    //return true;

    return false;
}