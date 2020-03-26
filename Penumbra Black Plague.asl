state("penumbra"){
    string32 level_name: 0x2DCAF0, 0x154, 0x40, 0x0;
    float gameTime: 0x2DCAF0, 0x188, 0x4C, 0x1C;
}

startup{
    vars.prevPhase = null;
    vars.loadedTime = 0;
	//settings.Add("cells_to_vents", true, "Cells to Vents");
	settings.Add("vents_to_messhall_entrance", true, "Vents to Messhall entrance");
	settings.Add("entrance_to_messhall", true, "Messhall Entrance to Messhall");
	settings.Add("messhall_to_sewers", true, "Messhall to Sewers");
	settings.Add("sewers_to_swanson", true, "Sewers to Dr. Swanson");
	settings.Add("swanson_to_corridor", true, "Dr. Swanson to Residential Corridor");
	settings.Add("corridor_to_infirmary", true, "Residential Corridor to Infirmary");
	settings.Add("infirmary_to_corridor", true, "Infirmary to Residential Corridor");
	settings.Add("corridor_to_machine", true, "Residential Corridor to Machine Room");
	settings.Add("machine_to_corridor", true, "Machine Room to Residential Corridor");
	settings.Add("corridor_to_library", true, "Residential Corridor to Library");
	settings.Add("library_to_cave", true, "Library to Cave");
	settings.Add("cave_to_outside", true, "Cave to Outside");
	settings.Add("outside_to_corridor", true, "Outside to Infected Corridors");
	settings.Add("corridor_to_chemlab", true, "Corridor to Chem Lab");
	settings.Add("chemlab_to_corridor", true, "Chem Lab to Corridor");
	settings.Add("corridor_to_exam", true, "Corridor to Examination Room");
	settings.Add("exam_to_corridor", true, "Examination Room to Corridor");
	settings.Add("corridor_to_tower1", false, "Corridor to Waiting Room");
	settings.Add("tower1_to_tower2", false, "Waiting Room to Challenge 1");
	settings.Add("tower2_to_tower1", true, "Challenge 1 to Waiting Room");
	settings.Add("tower1_to_tower3", false, "Waiting Room to Challenge 2");
	settings.Add("tower3_to_tower1", true, "Challenge 2 to Waiting Room");
	settings.Add("tower1_to_tower4", false, "Waiting Room to Challenge 3");
	settings.Add("tower4_to_tower1", false, "Challenge 3 to Waiting Room");
	settings.Add("tower1_to_ending", true, "Waiting Room to Ending");
}


update{
    if (current.gameTime == 0 && old.gameTime > 0)
        vars.loadedTime += old.gameTime;
    if (timer.CurrentPhase == TimerPhase.Running && vars.prevPhase == TimerPhase.NotRunning)
        vars.loadedTime = 0;

    vars.prevPhase = timer.CurrentPhase;

}

start{
    bool starting = old.gameTime == 0 && current.gameTime > 0;
    if (starting)
        vars.split = 0;
    return starting;
}

isLoading{
    return true;
}

split{
	if (current.level_name == old.level_name)
        return false;
    if (current.level_name == "level02_vents.dae" && vars.split == 0 && settings["cells_to_vents"])
        return true;
	if (current.level_name == "level03_messhall_entrance.dae" && old.level_name == "level02_vents.dae" && settings["vents_to_messhall_entrance"])
        return true;
	if (current.level_name == "level04_messhall.dae" && old.level_name == "level03_messhall_entrance.dae" && settings["entrance_to_messhall"])
        return true;
	if (current.level_name == "level05_sewers.dae" && old.level_name == "level04_messhall.dae" && settings["messhall_to_sewers"])
        return true;
	if (current.level_name == "level06_dr_swansons_room.dae" && old.level_name == "level05_sewers.dae" && settings["sewers_to_swanson"])
        return true;
	if (vars.split == 0 && current.level_name == "level07_residental_corridors.dae" && old.level_name == "level06_dr_swansons_room.dae" && settings["swanson_to_corridor"]){
        vars.split += 1;
        return true;}
	if (current.level_name == "level11_infirmary.dae" && old.level_name == "level07_residental_corridors.dae" && settings["corridor_to_infirmary"])
        return true;
	if (current.level_name == "level07_residental_corridors.dae" && old.level_name == "level11_infirmary.dae" && settings["infirmary_to_corridor"])
        return true;
	if (current.level_name == "level10_machine_room.dae" && old.level_name == "level07_residental_corridors.dae" && settings["corridor_to_machine"])
        return true;
	if (current.level_name == "level07_residental_corridors.dae" && old.level_name == "level10_machine_room.dae" && settings["machine_to_corridor"])
        return true;
	if (current.level_name == "level13_library.dae" && old.level_name == "level07_residental_corridors.dae" && settings["corridor_to_library"])
        return true;
	if (current.level_name == "level14_cave.dae" && old.level_name == "level13_library.dae" && settings["library_to_cave"])
        return true;
	if (current.level_name == "level15_outside.dae" && old.level_name == "level14_cave.dae" && settings["cave_to_outside"])
        return true;
	if (current.level_name == "level16_infected_corridors.dae" && old.level_name == "level15_outside.dae" && settings["outside_to_corridor"])
        return true;
	if (current.level_name == "level19_chemical_laboratory.dae" && old.level_name == "level16_infected_corridors.dae" && settings["corridor_to_chemlab"])
        return true;
	if (current.level_name == "level16_infected_corridors.dae" && old.level_name == "level19_chemical_laboratory.dae" && settings["chemlab_to_corridor"])
        return true;
	if (current.level_name == "level20_examination_room.dae" && old.level_name == "level16_infected_corridors.dae" && settings["corridor_to_exam"])
        return true;
	if (current.level_name == "level16_infected_corridors.dae" && old.level_name == "level20_examination_room.dae" && settings["exam_to_corridor"])
        return true;
	if (current.level_name == "level21_tower_1.dae" && old.level_name == "level16_infected_corridors.dae" && settings["corridor_to_tower1"])
       return true;
	if (current.level_name == "level21_tower_2.dae" && old.level_name =="level21_tower_1.dae" && settings["tower1_to_tower2"])
        return true;
	if (current.level_name == "level21_tower_1.dae" && old.level_name =="level21_tower_2.dae" && settings["tower2_to_tower1"])
        return true;
	if (current.level_name == "level21_tower_3.dae" && old.level_name =="level21_tower_1.dae" && settings["tower1_to_tower3"])
        return true;
	if (current.level_name == "level21_tower_1.dae" && old.level_name =="level21_tower_3.dae" && settings["tower3_to_tower1"])
        return true;
	if (current.level_name == "level21_tower_4.dae" && old.level_name =="level21_tower_1.dae" && settings["tower1_to_tower4"])
        return true;
	if (current.level_name == "level21_tower_1.dae" && old.level_name =="level21_tower_4.dae" && settings["tower4_to_tower1"])
        return true;
	if (current.level_name == "level22_ending.dae" && old.level_name =="level21_tower_1.dae" && settings["tower1_to_ending"])
		return true;
	return false;
}

gameTime{
    return TimeSpan.FromSeconds(current.gameTime + vars.loadedTime);
}
