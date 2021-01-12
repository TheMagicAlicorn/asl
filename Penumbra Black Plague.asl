//-----------------------------------------------------------------
//  About: Load Remover & Auto Splitter
//  Author: MagicALCN, Kappawaii, Astropilot, Tarados, DrTChops, Kotti
//  Version: 1.2
//  Last Release Date: 12 January 2021
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
    vars.clarenceSkip = false; // The trick to skip the effects of Clarence in the Residental Corridors by going back into Dr. Swanson's office
    vars.category = timer.Run.CategoryName.ToLower();

    // Boolean settings to select the desired splits
    settings.Add("Any%/QSA/2 Players 1 Computer");
        settings.Add("cells_to_vents_any", true, "Cells to Vents", "Any%/QSA/2 Players 1 Computer");
        settings.Add("vents_to_messhall_entrance_any", true, "Vents to Messhall Entrance", "Any%/QSA/2 Players 1 Computer");
        settings.Add("entrance_to_messhall_any", true, "Messhall Entrance to Messhall", "Any%/QSA/2 Players 1 Computer");
        settings.Add("messhall_to_sewers_any", true, "Messhall to Sewers", "Any%/QSA/2 Players 1 Computer");
        settings.Add("sewers_to_swanson_any", true, "Sewers to Dr. Swanson", "Any%/QSA/2 Players 1 Computer");
        settings.Add("swanson_to_corridor_any", true, "Dr. Swanson to Residental Corridors", "Any%/QSA/2 Players 1 Computer");
        settings.Add("corridor_to_infirmary_any", true, "Residental Corridor to Infirmary", "Any%/QSA/2 Players 1 Computer");
        settings.Add("infirmary_to_corridor_any", true, "Infirmary to Residental Corridors", "Any%/QSA/2 Players 1 Computer");
        settings.Add("corridor_to_machine_any", true, "Residental Corridors to Machine Room", "Any%/QSA/2 Players 1 Computer");
        settings.Add("machine_to_corridor_any", true, "Machine Room to Residental Corridors", "Any%/QSA/2 Players 1 Computer");
        settings.Add("corridor_to_library_any", true, "Residental Corridors to Library", "Any%/QSA/2 Players 1 Computer");
        settings.Add("library_to_cave_any", true, "Library to Cave", "Any%/QSA/2 Players 1 Computer");
        settings.Add("cave_to_outside_any", true, "Cave to Outside", "Any%/QSA/2 Players 1 Computer");
        settings.Add("outside_to_corridor_any", true, "Outside to Infected Corridors", "Any%/QSA/2 Players 1 Computer");
        settings.Add("corridor_to_chemlab_any", true, "Infected Corridors to Chem Lab", "Any%/QSA/2 Players 1 Computer");
        settings.Add("chemlab_to_corridor_any", true, "Chem Lab to Infected Corridors", "Any%/QSA/2 Players 1 Computer");
        settings.Add("corridor_to_exam_any", true, "Corridor to Examination Room", "Any%/QSA/2 Players 1 Computer");
        settings.Add("exam_to_corridor_any", true, "Examination Room to Infected Corridors", "Any%/QSA/2 Players 1 Computer");
        settings.Add("corridor_to_tower1_any", false, "Infected Corridors to Tower", "Any%/QSA/2 Players 1 Computer");
        settings.Add("tower1_to_tower2_any", false, "Tower to Challenge 1", "Any%/QSA/2 Players 1 Computer");
        settings.Add("tower2_to_tower1_any", true, "Challenge 1 to Tower", "Any%/QSA/2 Players 1 Computer");
        settings.Add("tower1_to_tower3_any", false, "Tower to Challenge 2", "Any%/QSA/2 Players 1 Computer");
        settings.Add("tower3_to_tower1_any", true, "Challenge 2 to Tower", "Any%/QSA/2 Players 1 Computer");
        settings.Add("tower1_to_tower4_any", false, "Tower to Challenge 3", "Any%/QSA/2 Players 1 Computer");
        settings.Add("tower4_to_tower1_any", false, "Challenge 3 to Tower", "Any%/QSA/2 Players 1 Computer");
        settings.Add("tower1_to_ending_any", true, "Tower to Ending", "Any%/QSA/2 Players 1 Computer");

    settings.Add("No Major Glitches");
        settings.Add("cells_to_vents_nmg", true, "Cells to Vents", "No Major Glitches");
        settings.Add("vents_to_messhall_entrance_nmg", true, "Vents to Messhall Entrance", "No Major Glitches");
        settings.Add("entrance_to_cells_nmg", true, "Messhall Entrance to Cells", "No Major Glitches");
        settings.Add("cells_to_entrance_nmg", true, "Cells to Messhall Entrance", "No Major Glitches");
        settings.Add("entrance_to_messhall_nmg", true, "Messhall Entrance to Messhall", "No Major Glitches");
        settings.Add("messhall_to_sewers_nmg", true, "Messhall to Sewers", "No Major Glitches");
        settings.Add("sewers_to_swanson_nmg", true, "Sewers to Dr. Swanson", "No Major Glitches");
        settings.Add("swanson_to_corridor_nmg", true, "Dr. Swanson to Residental Corridors", "No Major Glitches");
        settings.Add("corridor_to_machine_nmg", true, "Residental Corridors to Machine Room", "No Major Glitches");
        settings.Add("machine_to_corridor_nmg", true, "Machine Room to Residental Corridors", "No Major Glitches");
        settings.Add("corridor_to_computer_nmg", true, "Residental Corridors to Computer Room", "No Major Glitches");
        settings.Add("computer_to_corridor_nmg", true, "Computer Room to Residental Corridors", "No Major Glitches");
        settings.Add("corridor_to_infirmary_nmg", true, "Residental Corridor to Infirmary", "No Major Glitches");
        settings.Add("infirmary_to_corridor_nmg", true, "Infirmary to Residental Corridors", "No Major Glitches");
        settings.Add("corridor_to_library_nmg", true, "Residental Corridors to Library", "No Major Glitches");
        settings.Add("library_to_cave_nmg", true, "Library to Cave", "No Major Glitches");
        settings.Add("cave_to_outside_nmg", true, "Cave to Outside", "No Major Glitches");
        settings.Add("outside_to_corridor_nmg", true, "Outside to Infected Corridors", "No Major Glitches");
        settings.Add("corridor_to_kennel_nmg", true, "Infected Corridors to Kennel", "No Major Glitches");
        settings.Add("kennel_to_corridor_nmg", true, "Kennel to Infected Corridors", "No Major Glitches");
        settings.Add("corridor_to_research_nmg", true, "Infected Corridors to Research Room", "No Major Glitches");
        settings.Add("research_to_corridor_nmg", true, "Research Room to Infected Corridors", "No Major Glitches");
        settings.Add("corridor_to_chemlab_nmg", true, "Infected Corridors to Chem Lab", "No Major Glitches");
        settings.Add("chemlab_to_corridor_nmg", true, "Chem Lab to Infected Corridors", "No Major Glitches");
        settings.Add("corridor_to_exam_nmg", true, "Corridor to Examination Room", "No Major Glitches");
        settings.Add("exam_to_corridor_nmg", true, "Examination Room to Infected Corridors", "No Major Glitches");
        settings.Add("corridor_to_tower1_nmg", false, "Infected Corridors to Tower", "No Major Glitches");
        settings.Add("tower1_to_tower2_nmg", false, "Tower to Challenge 1", "No Major Glitches");
        settings.Add("tower2_to_tower1_nmg", true, "Challenge 1 to Tower", "No Major Glitches");
        settings.Add("tower1_to_tower3_nmg", false, "Tower to Challenge 2", "No Major Glitches");
        settings.Add("tower3_to_tower1_nmg", true, "Challenge 2 to Tower", "No Major Glitches");
        settings.Add("tower1_to_tower4_nmg", false, "Tower to Challenge 3", "No Major Glitches");
        settings.Add("tower4_to_tower1_nmg", false, "Challenge 3 to Tower", "No Major Glitches");
        settings.Add("tower1_to_ending_nmg", true, "Tower to Ending", "No Major Glitches");

    settings.Add("100%");
        settings.Add("cells_to_vents_100", true, "Cells to Vents", "100%");
        settings.Add("vents_to_messhall_entrance_100", true, "Vents to Messhall Entrance", "100%");
        settings.Add("entrance_to_cells_100", true, "Messhall Entrance to Cells", "100%");
        settings.Add("cells_to_entrance_100", true, "Cells to Messhall Entrance", "100%");
        settings.Add("entrance_to_messhall_100", true, "Messhall Entrance to Messhall", "100%");
        settings.Add("messhall_to_sewers_100", true, "Messhall to Sewers", "100%");
        settings.Add("sewers_to_swanson_100", true, "Sewers to Dr. Swanson", "100%");
        settings.Add("swanson_to_corridor_100", true, "Dr. Swanson to Residental Corridors", "100%");
        settings.Add("corridor_to_computer_100", true, "Residental Corridors to Computer Room", "100%");
        settings.Add("computer_to_corridor_100", true, "Computer Room to Residental Corridors", "100%");
        settings.Add("corridor_to_infirmary_100", true, "Residental Corridor to Infirmary", "100%");
        settings.Add("infirmary_to_corridor_100", true, "Infirmary to Residental Corridors", "100%");
        settings.Add("corridor_to_storage_100", true, "Residental Corridors to Storage Room", "100%");
        settings.Add("storage_to_corridor_100", true, "Storage Room to Residental Corridors", "100%");
        settings.Add("corridor_to_machine_100", true, "Residental Corridors to Machine Room", "100%");
        settings.Add("machine_to_corridor_100", true, "Machine Room to Residental Corridors", "100%");
        settings.Add("corridor_to_library_100", true, "Residental Corridors to Library", "100%");
        settings.Add("library_to_cave_100", true, "Library to Cave", "100%");
        settings.Add("cave_to_outside_100", true, "Cave to Outside", "100%");
        settings.Add("outside_to_corridor_100", true, "Outside to Infected Corridors", "100%");
        settings.Add("corridor_to_kennel_100", true, "Infected Corridors to Kennel", "100%");
        settings.Add("kennel_to_corridor_100", true, "Kennel to Infected Corridors", "100%");
        settings.Add("corridor_to_research_100", true, "Infected Corridors to Research Room", "100%");
        settings.Add("research_to_corridor_100", true, "Research Room to Infected Corridors", "100%");
        settings.Add("corridor_to_chemlab_100", true, "Infected Corridors to Chem Lab", "100%");
        settings.Add("chemlab_to_corridor_100", true, "Chem Lab to Infected Corridors", "100%");
        settings.Add("corridor_to_exam_100", true, "Corridor to Examination Room", "100%");
        settings.Add("exam_to_corridor_100", true, "Examination Room to Infected Corridors", "100%");
        settings.Add("corridor_to_tower1_100", false, "Infected Corridors to Tower", "100%");
        settings.Add("tower1_to_tower2_100", false, "Tower to Challenge 1", "100%");
        settings.Add("tower2_to_tower1_100", true, "Challenge 1 to Tower", "100%");
        settings.Add("tower1_to_tower3_100", false, "Tower to Challenge 2", "100%");
        settings.Add("tower3_to_tower1_100", true, "Challenge 2 to Tower", "100%");
        settings.Add("tower1_to_tower4_100", false, "Tower to Challenge 3", "100%");
        settings.Add("tower4_to_tower1_100", false, "Challenge 3 to Tower", "100%");
        settings.Add("tower1_to_ending_100", true, "Tower to Ending", "100%");
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
  return (current.gameTime == 0 && (current.levelName == "level01_cells" || current.levelName == "level00_tutorial")); // If a new game is found, we reset the splits
}


start {
    bool starting = old.gameTime == 0 && current.gameTime > 0 && (current.levelName == "level01_cells" || current.levelName == "level00_tutorial"); // If we start a new game
    if (starting) { // We reset our variables
        vars.clarenceSkip = false;
    }
    return starting;
}


split {

    if (vars.category.Contains("any") || vars.category.Contains("players") || vars.category.Contains("2p") || vars.category.Contains("qsa") || vars.category.Contains("quick")) {
        // Basically we look at the name of the previous level with the new one to see if we should split
        if (settings["cells_to_vents_any"] && current.levelName == "level02_vents" && old.levelName == "level01_cells")
            return true;
        if (settings["vents_to_messhall_entrance_any"] && current.levelName == "level03_messhall_entrance" && old.levelName == "level02_vents")
            return true;
        if (settings["entrance_to_messhall_any"] && current.levelName == "level04_messhall" && old.levelName == "level03_messhall_entrance")
            return true;
        if (settings["messhall_to_sewers_any"] && current.levelName == "level05_sewers" && old.levelName == "level04_messhall")
            return true;
        if (settings["sewers_to_swanson_any"] && current.levelName == "level06_dr_swansons_room" && old.levelName == "level05_sewers")
            return true;
        // We have to be careful here with Clarence's skip
        if (settings["swanson_to_corridor_any"] && vars.clarenceSkip == false && current.levelName == "level07_residental_corridors" && old.levelName == "level06_dr_swansons_room") {
            vars.clarenceSkip = true;
            return true;
        }
        if (settings["corridor_to_infirmary_any"] && current.levelName == "level11_infirmary" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["infirmary_to_corridor_any"] && current.levelName == "level07_residental_corridors" && old.levelName == "level11_infirmary")
            return true;
        if (settings["corridor_to_machine_any"] && current.levelName == "level10_machine_room" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["machine_to_corridor_any"] && current.levelName == "level07_residental_corridors" && old.levelName == "level10_machine_room")
            return true;
        if (settings["corridor_to_library_any"] && current.levelName == "level13_library" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["library_to_cave_any"] && current.levelName == "level14_cave" && old.levelName == "level13_library")
            return true;
        if (settings["cave_to_outside_any"] && current.levelName == "level15_outside" && old.levelName == "level14_cave")
            return true;
        if (settings["outside_to_corridor_any"] && current.levelName == "level16_infected_corridors" && old.levelName == "level15_outside")
            return true;
        if (settings["corridor_to_chemlab_any"] && current.levelName == "level19_chemical_laboratory" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["chemlab_to_corridor_any"] && current.levelName == "level16_infected_corridors" && old.levelName == "level19_chemical_laboratory")
            return true;
        if (settings["corridor_to_exam_any"] && current.levelName == "level20_examination_room" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["exam_to_corridor_any"] && current.levelName == "level16_infected_corridors" && old.levelName == "level20_examination_room")
            return true;
        if (settings["corridor_to_tower1_any"] && current.levelName == "level21_tower_1" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["tower1_to_tower2_any"] && current.levelName == "level21_tower_2" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower2_to_tower1_any"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_2")
            return true;
        if (settings["tower1_to_tower3_any"] && current.levelName == "level21_tower_3" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower3_to_tower1_any"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_3")
            return true;
        if (settings["tower1_to_tower4_any"] && current.levelName == "level21_tower_4" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower4_to_tower1_any"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_4")
            return true;
        if (settings["tower1_to_ending_any"] && current.levelName == "level22_ending" && old.levelName == "level21_tower_1")
            return true;
    }

    else if (vars.category.Contains("major") || vars.category.Contains("nmg")) {
        if (settings["cells_to_vents_nmg"] && current.levelName == "level02_vents" && old.levelName == "level01_cells")
            return true;
        if (settings["vents_to_messhall_entrance_nmg"] && current.levelName == "level03_messhall_entrance" && old.levelName == "level02_vents")
            return true;
        if (settings["entrance_to_cells_nmg"] && current.levelName == "level01_cells" && old.levelName == "level03_messhall_entrance")
            return true;
        if (settings["cells_to_entrance_nmg"] && current.levelName == "level03_messhall_entrance" && old.levelName == "level01_cells")
            return true;
        if (settings["entrance_to_messhall_nmg"] && current.levelName == "level04_messhall" && old.levelName == "level03_messhall_entrance")
            return true;
        if (settings["messhall_to_sewers_nmg"] && current.levelName == "level05_sewers" && old.levelName == "level04_messhall")
            return true;
        if (settings["sewers_to_swanson_nmg"] && current.levelName == "level06_dr_swansons_room" && old.levelName == "level05_sewers")
            return true;
        if (settings["swanson_to_corridor_nmg"] && current.levelName == "level07_residental_corridors" && old.levelName == "level06_dr_swansons_room")
            return true;
        if (settings["corridor_to_machine_nmg"] && current.levelName == "level10_machine_room" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["machine_to_corridor_nmg"] && current.levelName == "level07_residental_corridors" && old.levelName == "level10_machine_room")
            return true;
        if (settings["corridor_to_computer_nmg"] && current.levelName == "level08_computer_room" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["computer_to_corridor_nmg"] && current.levelName == "level07_residental_corridors" && old.levelName == "level08_computer_room")
            return true;
        if (settings["corridor_to_infirmary_nmg"] && current.levelName == "level11_infirmary" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["infirmary_to_corridor_nmg"] && current.levelName == "level07_residental_corridors" && old.levelName == "level11_infirmary")
            return true;
        if (settings["corridor_to_library_nmg"] && current.levelName == "level13_library" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["library_to_cave_nmg"] && current.levelName == "level14_cave" && old.levelName == "level13_library")
            return true;
        if (settings["cave_to_outside_nmg"] && current.levelName == "level15_outside" && old.levelName == "level14_cave")
            return true;
        if (settings["outside_to_corridor_nmg"] && current.levelName == "level16_infected_corridors" && old.levelName == "level15_outside")
            return true;
        if (settings["corridor_to_kennel_nmg"] && current.levelName == "level17_kennel" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["kennel_to_corridor_nmg"] && current.levelName == "level16_infected_corridors" && old.levelName == "level17_kennel")
            return true;
        if (settings["corridor_to_research_nmg"] && current.levelName == "level18_reasearch_room" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["research_to_corridor_nmg"] && current.levelName == "level16_infected_corridors" && old.levelName == "level18_reasearch_room")
            return true;
        if (settings["corridor_to_chemlab_nmg"] && current.levelName == "level19_chemical_laboratory" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["chemlab_to_corridor_nmg"] && current.levelName == "level16_infected_corridors" && old.levelName == "level19_chemical_laboratory")
            return true;
        if (settings["corridor_to_exam_nmg"] && current.levelName == "level20_examination_room" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["exam_to_corridor_nmg"] && current.levelName == "level16_infected_corridors" && old.levelName == "level20_examination_room")
            return true;
        if (settings["corridor_to_tower1_nmg"] && current.levelName == "level21_tower_1" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["tower1_to_tower2_nmg"] && current.levelName == "level21_tower_2" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower2_to_tower1_nmg"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_2")
            return true;
        if (settings["tower1_to_tower3_nmg"] && current.levelName == "level21_tower_3" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower3_to_tower1_nmg"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_3")
            return true;
        if (settings["tower1_to_tower4_nmg"] && current.levelName == "level21_tower_4" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower4_to_tower1_nmg"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_4")
            return true;
        if (settings["tower1_to_ending_nmg"] && current.levelName == "level22_ending" && old.levelName == "level21_tower_1")
            return true;
    }

    else if (vars.category.Contains("100")) {
        if (settings["cells_to_vents_100"] && current.levelName == "level02_vents" && old.levelName == "level01_cells")
            return true;
        if (settings["vents_to_messhall_entrance_100"] && current.levelName == "level03_messhall_entrance" && old.levelName == "level02_vents")
            return true;
        if (settings["entrance_to_cells_100"] && current.levelName == "level01_cells" && old.levelName == "level03_messhall_entrance")
            return true;
        if (settings["cells_to_entrance_100"] && current.levelName == "level03_messhall_entrance" && old.levelName == "level01_cells")
            return true;
        if (settings["entrance_to_messhall_100"] && current.levelName == "level04_messhall" && old.levelName == "level03_messhall_entrance")
            return true;
        if (settings["messhall_to_sewers_100"] && current.levelName == "level05_sewers" && old.levelName == "level04_messhall")
            return true;
        if (settings["sewers_to_swanson_100"] && current.levelName == "level06_dr_swansons_room" && old.levelName == "level05_sewers")
            return true;
        if (settings["swanson_to_corridor_100"] && current.levelName == "level07_residental_corridors" && old.levelName == "level06_dr_swansons_room")
            return true;
        if (settings["corridor_to_computer_100"] && current.levelName == "level08_computer_room" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["computer_to_corridor_100"] && current.levelName == "level07_residental_corridors" && old.levelName == "level08_computer_room")
            return true;
        if (settings["corridor_to_infirmary_100"] && current.levelName == "level11_infirmary" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["infirmary_to_corridor_100"] && current.levelName == "level07_residental_corridors" && old.levelName == "level11_infirmary")
            return true;
        if (settings["corridor_to_storage_100"] && current.levelName == "level09_storage_room" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["storage_to_corridor_100"] && current.levelName == "level07_residental_corridors" && old.levelName == "level09_storage_room")
            return true;
        if (settings["corridor_to_machine_100"] && current.levelName == "level10_machine_room" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["machine_to_corridor_100"] && current.levelName == "level07_residental_corridors" && old.levelName == "level10_machine_room")
            return true;
        if (settings["corridor_to_library_100"] && current.levelName == "level13_library" && old.levelName == "level07_residental_corridors")
            return true;
        if (settings["library_to_cave_100"] && current.levelName == "level14_cave" && old.levelName == "level13_library")
            return true;
        if (settings["cave_to_outside_100"] && current.levelName == "level15_outside" && old.levelName == "level14_cave")
            return true;
        if (settings["outside_to_corridor_100"] && current.levelName == "level16_infected_corridors" && old.levelName == "level15_outside")
            return true;
        if (settings["corridor_to_kennel_100"] && current.levelName == "level17_kennel" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["kennel_to_corridor_100"] && current.levelName == "level16_infected_corridors" && old.levelName == "level17_kennel")
            return true;
        if (settings["corridor_to_research_100"] && current.levelName == "level18_reasearch_room" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["research_to_corridor_100"] && current.levelName == "level16_infected_corridors" && old.levelName == "level16_reasearch_room")
            return true;
        if (settings["corridor_to_chemlab_100"] && current.levelName == "level19_chemical_laboratory" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["chemlab_to_corridor_100"] && current.levelName == "level16_infected_corridors" && old.levelName == "level19_chemical_laboratory")
            return true;
        if (settings["corridor_to_exam_100"] && current.levelName == "level20_examination_room" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["exam_to_corridor_100"] && current.levelName == "level16_infected_corridors" && old.levelName == "level20_examination_room")
            return true;
        if (settings["corridor_to_tower1_100"] && current.levelName == "level21_tower_1" && old.levelName == "level16_infected_corridors")
            return true;
        if (settings["tower1_to_tower2_100"] && current.levelName == "level21_tower_2" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower2_to_tower1_100"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_2")
            return true;
        if (settings["tower1_to_tower3_100"] && current.levelName == "level21_tower_3" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower3_to_tower1_100"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_3")
            return true;
        if (settings["tower1_to_tower4_100"] && current.levelName == "level21_tower_4" && old.levelName == "level21_tower_1")
            return true;
        if (settings["tower4_to_tower1_100"] && current.levelName == "level21_tower_1" && old.levelName == "level21_tower_4")
            return true;
        if (settings["tower1_to_ending_100"] && current.levelName == "level22_ending" && old.levelName == "level21_tower_1")
            return true;
    }

    //If an unknown category exists, here's a simple autosplitter
    else if (current.levelName != old.levelName)
        return true;

    // The end-of-run detection condition
    // The use of the wallCounter is essential because the computerEnding is also triggered during the first interaction with the computer
    if (current.wallCounter == 4 && current.levelName == "level22_ending" && old.computerEnding == 1 && current.computerEnding == 0)
      return true;

    return false;
}
