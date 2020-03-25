state("penumbra"){
    string32 level_name: 0x2DCAF0, 0x154, 0x40, 0x0;
    float gameTime: 0x2DCAF0, 0x188, 0x4C, 0x1C;
}

startup{
    vars.prevPhase = null;
    vars.loadedTime = 0;
}

init{
    vars.split = 0;
}
update{
    if (current.gameTime == 0 && old.gameTime > 0)
        vars.loadedTime += old.gameTime;
    if (timer.CurrentPhase == TimerPhase.Running && vars.prevPhase == TimerPhase.NotRunning)
        vars.loadedTime = 0;

    vars.prevPhase = timer.CurrentPhase;

}

start{
    return old.gameTime == 0 && current.gameTime > 0;
}

isLoading{
    return true;
}

split{
    if (vars.split == 6 && current.level_name == "level07_residental_corridors.dae")
        return false;
    if (vars.split == 6 && current.level_name == "level06_dr_swansons_room.dae")
        return false;
    if (current.level_name == "level21_tower_1.dae" && old.level_name == "level16_infected_corridors.dae")
        return false;
    if (current.level_name == "level21_tower_2.dae" && old.level_name == "level21_tower_1.dae")
        return false;
    if (current.level_name == "level21_tower_3.dae" && old.level_name == "level21_tower_1.dae")
        return false;
    if (current.level_name == "level21_tower_4.dae" && old.level_name == "level21_tower_1.dae")
        return false;
    if (current.level_name == "level21_tower_1.dae" && old.level_name == "level21_tower_4.dae")
        return false;
    if(current.level_name != "" && old.level_name != ""){
        if(current.level_name != old.level_name){
            vars.split += 1;
            return true;
        }
    }
    return false;
}

gameTime{
    return TimeSpan.FromSeconds(current.gameTime + vars.loadedTime);
}