//-----------------------------------------------------------------
//  About: Load Remover & Auto Splitter
//  Author: MagicALCN, Kappawaii, Astropilot, Tarados, DrTChops, Kotti
//  Version: 1.1
//  Last Release Date: 29 March 2020
//-----------------------------------------------------------------


state("penumbra") {
    // Our two variables needed to retrieve the names of the loaded levels.
    // Note that the first variable is no longer used by the game when a level whose name is higher than 16 characters is loaded,
    // it is then definitively replaced until the game is restarted by the second variable.
    string16 levelName1: 0x2DCAF0, 0x174, 0x24, 0xF4;
    string50 levelName2: 0x2DCAF0, 0x174, 0x24, 0xF4, 0x0;

    int wallCounter: 0x2DCAF0, 0x15C, 0x74, 0x70, 0x0, 0x48; // The wallCounter used in the last level to unlock the computer
    int computerEnding: 0x2E46F0; // Seems to be a boolean set to false when interacting with the computer on text screens

    // The InGame time in seconds (and milliseconds in the decimal part)
    // It is reset to 0 when returning to the game after a death or a save reload for example
    float gameTime: 0x2DCAF0, 0x188, 0x4C, 0x1C;
}


startup {
    vars.prevPhase = null; // The previous LiveSplit timer status
    vars.loadedTime = 0; // Variable to save the ingame time when you die or reload the level
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
    if (current.gameTime == 0 && old.gameTime > 0) { // If we come back into the game after a death or a save reload
        vars.loadedTime += old.gameTime; // We save the previous ingame time
    }
    if (timer.CurrentPhase == TimerPhase.Running && vars.prevPhase == TimerPhase.NotRunning) // If the LiveSplit timer has just started (e.g. new run)
        vars.loadedTime = 0; // We reset the saved ingame time

    vars.prevPhase = timer.CurrentPhase; // Saving the previous state of the LiveSplit timer

    // Here if we detect that the first variable is no longer used by the game, then we use the second one
    // Technical information which may be useful: The value of the first variable when it is no longer used is replaced by the address of the second variable
    if (current.levelName1 != null && current.levelName1.Length > 0 && !current.levelName1.StartsWith("level")) {
        current.levelName = current.levelName2;
    } else {
        current.levelName = current.levelName1;
    }
}


isLoading {
    // Prevents the use of the LiveSplit timer to use ingame time
    return true;
}


gameTime {
    return TimeSpan.FromSeconds(current.gameTime + vars.loadedTime); // The ingame time is therefore the current ingame time plus the saved one
}


reset {
  return (current.gameTime == 0 && current.levelName == "level01_cells"); // If a new game is found, we reset the splits
}


start {
    bool starting = old.gameTime == 0 && current.gameTime > 0; // If we start a new game or load a save from the main menu
    if (starting) { // We reset our variables
        vars.clarenceSkip = false;
    }
    return starting;
}


split {
    // Basically we look at the name of the previous level with the new one to see if we should split
    if (settings["cells_to_vents"] && current.levelName == "level02_vents" && old.levelName == "level01_cells")
        return true;
    if (settings["vents_to_messhall_entrance"] && current.levelName == "level03_messhall_entrance" && old.levelName == "level02_vents")
        return true;
    if (settings["entrance_to_messhall"] && current.levelName == "level04_messhall" && old.levelName == "level03_messhall_entrance")
        return true;
    if (settings["messhall_to_sewers"] && current.levelName == "level05_sewers" && old.levelName == "level04_messhall")
        return true;
    if (settings["sewers_to_swanson"] && current.levelName == "level06_dr_swansons_room" && old.levelName == "level05_sewers")
        return true;
    // We have to be careful here with Clarence's skip
    if (settings["swanson_to_corridor"] && vars.clarenceSkip == false && current.levelName == "level07_residental_corridors" && old.levelName == "level06_dr_swansons_room") {
        vars.clarenceSkip = true;
        return true;
    }
    if (settings["corridor_to_infirmary"] && current.levelName == "level11_infirmary" && old.levelName == "level07_residental_corridors")
        return true;
    if (settings["infirmary_to_corridor"] && current.levelName == "level07_residental_corridors" && old.levelName == "level11_infirmary")
        return true;
    if (settings["corridor_to_machine"] && current.levelName == "level10_machine_room" && old.levelName == "level07_residental_corridors")
        return true;
    if (settings["machine_to_corridor"] && current.levelName == "level07_residental_corridors" && old.levelName == "level10_machine_room")
        return true;
    if (settings["corridor_to_library"] && current.levelName == "level13_library" && old.levelName == "level07_residental_corridors")
        return true;
    if (settings["library_to_cave"] && current.levelName == "level14_cave" && old.levelName == "level13_library")
        return true;
    if (settings["cave_to_outside"] && current.levelName == "level15_outside" && old.levelName == "level14_cave")
        return true;
    if (settings["outside_to_corridor"] && current.levelName == "level16_infected_corridors" && old.levelName == "level15_outside")
        return true;
    if (settings["corridor_to_chemlab"] && current.levelName == "level19_chemical_laboratory" && old.levelName == "level16_infected_corridors")
        return true;
    if (settings["chemlab_to_corridor"] && current.levelName == "level16_infected_corridors" && old.levelName == "level19_chemical_laboratory")
        return true;
    if (settings["corridor_to_exam"] && current.levelName == "level20_examination_room" && old.levelName == "level16_infected_corridors")
        return true;
    if (settings["exam_to_corridor"] && current.levelName == "level16_infected_corridors" && old.levelName == "level20_examination_room")
        return true;
    if (settings["corridor_to_tower1"] && current.levelName == "level21_tower_1" && old.levelName == "level16_infected_corridors")
       return true;
    if (settings["tower1_to_tower2"] && current.levelName == "level21_tower_2" && old.levelName == "level21_tower_1")
        return true;
    if (settings["tower2_to_tower1"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_2")
        return true;
    if (settings["tower1_to_tower3"] && current.levelName == "level21_tower_3" && old.levelName == "level21_tower_1")
        return true;
    if (settings["tower3_to_tower1"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_3")
        return true;
    if (settings["tower1_to_tower4"] && current.levelName == "level21_tower_4" && old.levelName == "level21_tower_1")
        return true;
    if (settings["tower4_to_tower1"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_4")
        return true;
    if (settings["tower1_to_ending"] && current.levelName == "level22_ending" && old.levelName == "level21_tower_1")
        return true;

    // The end-of-run detection condition
    // The use of the wallCounter is essential because the computerEnding is also triggered during the first interaction with the computer
    if (current.wallCounter == 4 && current.levelName == "level22_ending" && old.computerEnding == 1 && current.computerEnding == 0)
      return true;

    return false;
}
