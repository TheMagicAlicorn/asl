//-----------------------------------------------------------------
//  About: Load Remover & Auto Splitter
//  Author: MagicALCN, Kappawaii, Astropilot, Tarados, DrTChops, Kotti
//  Version: 1.0
//  Last Release Date: 27 March 2020
//-----------------------------------------------------------------


state("penumbra") {
    string50 debug_console: 0x2DCAF0, 0x2C, 0x54, 0xC4, 0x38, 0x4BC; // To retrieve game maps into debug logs
    int wallCounter: 0x2DCAF0, 0x15C, 0x74, 0x70, 0x0, 0x48; // The wallCounter used in the last level to unlock the computer
    int computerEnding: 0x2E46F0; // Seems to be a boolean set to false when interacting with the computer on text screens

    // The InGame time in seconds (and milliseconds in the decimal part)
    // It is reset to 0 when returning to the game after a death or a save reload for example
    float gameTime: 0x2DCAF0, 0x188, 0x4C, 0x1C;
}


startup {
    vars.prevPhase = null; // The previous LiveSplit timer status
    vars.loadedTime = 0; // Variable to save the ingame time when you die or reload the level
    vars.prevLevelName = ""; // Variable to save the previous level
    vars.clarenceSkip = false; // The trick to skip the effects of Clarence in the Residential Corridor by going back into Dr. Swanson's office

    // Boolean settings to select the desired splits
    settings.Add("Splits");
	settings.CurrentDefaultParent = "Splits";
    settings.Add("cells_to_vents", true, "Cells to Vents");
    settings.Add("vents_to_messhall_entrance", true, "Vents to Messhall Entrance");
    settings.Add("entrance_to_messhall", true, "Messhall Entrance to Messhall");
    settings.Add("messhall_to_sewers", true, "Messhall to Sewers");
    settings.Add("sewers_to_swanson", true, "Sewers to Dr. Swanson");
    settings.Add("swanson_to_corridor", true, "Dr. Swanson to Residental Corridors");
    settings.Add("corridor_to_infirmary", true, "Residental Corridor to Infirmary");
    settings.Add("infirmary_to_corridor", true, "Infirmary to Residental Corridors");
    settings.Add("corridor_to_machine", true, "Residental Corridors to Machine Room");
    settings.Add("machine_to_corridor", true, "Machine Room to Residental Corridors");
    settings.Add("corridor_to_library", true, "Residental Corridors to Library");
    settings.Add("library_to_cave", true, "Library to Cave");
    settings.Add("cave_to_outside", true, "Cave to Outside");
    settings.Add("outside_to_corridor", true, "Outside to Infected Corridors");
    settings.Add("corridor_to_chemlab", true, "Infected Corridors to Chem Lab");
    settings.Add("chemlab_to_corridor", true, "Chem Lab to Infected Corridors");
    settings.Add("corridor_to_exam", true, "Corridor to Examination Room");
    settings.Add("exam_to_corridor", true, "Examination Room to Infected Corridors");
    settings.Add("corridor_to_tower1", false, "Infected Corridors to Tower");
    settings.Add("tower1_to_tower2", false, "Tower to Challenge 1");
    settings.Add("tower2_to_tower1", true, "Challenge 1 to Tower");
    settings.Add("tower1_to_tower3", false, "Tower to Challenge 2");
    settings.Add("tower3_to_tower1", true, "Challenge 2 to Tower");
    settings.Add("tower1_to_tower4", false, "Tower to Challenge 3");
    settings.Add("tower4_to_tower1", false, "Challenge 3 to Tower");
    settings.Add("tower1_to_ending", true, "Tower to Ending");
}


update {
    if (current.gameTime == 0 && old.gameTime > 0) // If we come back into the game after a death or a save reload
        vars.loadedTime += old.gameTime; // We save the previous ingame time
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
  return current.gameTime == 0 && vars.prevLevelName == "level01_cells.dae"; // If a new game is found, we reset the splits
}


start {
    bool starting = old.gameTime == 0 && current.gameTime > 0; // If we start a new game or load a save from the main menu
    if (starting) { // We reset our variables
        vars.clarenceSkip = false;
        vars.prevLevelName = "";
    }
    return starting;
}


split {
    // The end-of-run detection condition
    // The use of the wallCounter is essential because the computerEnding is also triggered during the first interaction with the computer
    if (current.wallCounter == 4 && vars.prevLevelName == "level22_ending.dae" && current.computerEnding == 0) {
      vars.prevLevelName = "end"; // We change the name of the level to prevent multiple splits
      return true;
    }

    // Debug console value when for example first level has been loaded: 'level01_cells.dae' took: 3774 ms
    // The debug console is very often used by the game for different errors or internal information, so it is not dedicated to loading levels
    if (!current.debug_console.StartsWith("'level")) // So we're waiting for a level loading message
        return false;

    String currentLevelName = current.debug_console.Split('\'')[1]; // We extract the name of the level of the complete message

    if (currentLevelName == vars.prevLevelName) // If we don't change levels, we don't do anything
        return false;

    bool isSplit = false; // Boolean to know if we're going to have to do a split or not

    // Basically we look at the name of the previous level with the new one to see if we should split
    if (currentLevelName == "level02_vents.dae" && vars.prevLevelName == "level01_cells.dae" && settings["cells_to_vents"])
        isSplit = true;
    else if (currentLevelName == "level03_messhall_entrance.dae" && vars.prevLevelName == "level02_vents.dae" && settings["vents_to_messhall_entrance"])
        isSplit = true;
    else if (currentLevelName == "level04_messhall.dae" && vars.prevLevelName == "level03_messhall_entrance.dae" && settings["entrance_to_messhall"])
        isSplit = true;
    else if (currentLevelName == "level05_sewers.dae" && vars.prevLevelName == "level04_messhall.dae" && settings["messhall_to_sewers"])
        isSplit = true;
    else if (currentLevelName == "level06_dr_swansons_room.dae" && vars.prevLevelName == "level05_sewers.dae" && settings["sewers_to_swanson"])
        isSplit = true;
    // We have to be careful here with Clarence's skip
    else if (vars.clarenceSkip == false && currentLevelName == "level07_residental_corridors.dae" && vars.prevLevelName == "level06_dr_swansons_room.dae" && settings["swanson_to_corridor"]) {
        vars.clarenceSkip = true;
        isSplit = true;
    } else if (currentLevelName == "level11_infirmary.dae" && vars.prevLevelName == "level07_residental_corridors.dae" && settings["corridor_to_infirmary"])
        isSplit = true;
    else if (currentLevelName == "level07_residental_corridors.dae" && vars.prevLevelName == "level11_infirmary.dae" && settings["infirmary_to_corridor"])
        isSplit = true;
    else if (currentLevelName == "level10_machine_room.dae" && vars.prevLevelName == "level07_residental_corridors.dae" && settings["corridor_to_machine"])
        isSplit = true;
    else if (currentLevelName == "level07_residental_corridors.dae" && vars.prevLevelName == "level10_machine_room.dae" && settings["machine_to_corridor"])
        isSplit = true;
    else if (currentLevelName == "level13_library.dae" && vars.prevLevelName == "level07_residental_corridors.dae" && settings["corridor_to_library"])
        isSplit = true;
    else if (currentLevelName == "level14_cave.dae" && vars.prevLevelName == "level13_library.dae" && settings["library_to_cave"])
        isSplit = true;
    else if (currentLevelName == "level15_outside.dae" && vars.prevLevelName == "level14_cave.dae" && settings["cave_to_outside"])
        isSplit = true;
    else if (currentLevelName == "level16_infected_corridors.dae" && vars.prevLevelName == "level15_outside.dae" && settings["outside_to_corridor"])
        isSplit = true;
    else if (currentLevelName == "level19_chemical_laboratory.dae" && vars.prevLevelName == "level16_infected_corridors.dae" && settings["corridor_to_chemlab"])
        isSplit = true;
    else if (currentLevelName == "level16_infected_corridors.dae" && vars.prevLevelName == "level19_chemical_laboratory.dae" && settings["chemlab_to_corridor"])
        isSplit = true;
    else if (currentLevelName == "level20_examination_room.dae" && vars.prevLevelName == "level16_infected_corridors.dae" && settings["corridor_to_exam"])
        isSplit = true;
    else if (currentLevelName == "level16_infected_corridors.dae" && vars.prevLevelName == "level20_examination_room.dae" && settings["exam_to_corridor"])
        isSplit = true;
    else if (currentLevelName == "level21_tower_1.dae" && vars.prevLevelName == "level16_infected_corridors.dae" && settings["corridor_to_tower1"])
       isSplit = true;
    else if (currentLevelName == "level21_tower_2.dae" && vars.prevLevelName == "level21_tower_1.dae" && settings["tower1_to_tower2"])
        isSplit = true;
    else if (currentLevelName == "level21_tower_1.dae" && vars.prevLevelName == "level21_tower_2.dae" && settings["tower2_to_tower1"])
        isSplit = true;
    else if (currentLevelName == "level21_tower_3.dae" && vars.prevLevelName == "level21_tower_1.dae" && settings["tower1_to_tower3"])
        isSplit = true;
    else if (currentLevelName == "level21_tower_1.dae" && vars.prevLevelName == "level21_tower_3.dae" && settings["tower3_to_tower1"])
        isSplit = true;
    else if (currentLevelName == "level21_tower_4.dae" && vars.prevLevelName == "level21_tower_1.dae" && settings["tower1_to_tower4"])
        isSplit = true;
    else if (currentLevelName == "level21_tower_1.dae" && vars.prevLevelName == "level21_tower_4.dae" && settings["tower4_to_tower1"])
        isSplit = true;
    else if (currentLevelName == "level22_ending.dae" && vars.prevLevelName == "level21_tower_1.dae" && settings["tower1_to_ending"])
        isSplit = true;

    vars.prevLevelName = currentLevelName; // The previous level is now the current level
    return isSplit;
}
