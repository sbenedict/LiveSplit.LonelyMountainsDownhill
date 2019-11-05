/*
 lmd.asl

 Game: Lonely Mountains: Downhill
 Game Version: 1.0.1.2356.0060 (Steam)
 Script Version: 1.03 (2019-11-05)

 Contributors:
    Kilaye (discord: Kilaye#8700)
    psam (discord: psam#0545)
 
 Changelog:
    v1.03 - Simplified logic to use only 'in game' and 'finished' (psam)
    v1.02 - Changed start to level startup (psam)
          - Updated for game v1.01 (psam)
    v1.01 - Fixed checkpoint split (psam)
          - Added end of trail split (psam)
    v1.00 - Initial release with incorrect checkpoint split (Kilaye)
*/

state("LMD_Win_x64", "v1.0.1.2356.0060 (Steam)")
{
    /* Is in game (not menu) */
    byte inGame : "GameAssembly.dll", 0x01D92D08;

	/* Current checkpoint */
	int curCheckpoint : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x48, 0x64; // finished = -1
}

startup
{
	vars.game_state = "MENU";
    
    settings.Add("splitAtCheckpoint", false, "Split at checkpoint");
}

update
{
    /* Check if quit to menu */
    if (vars.game_state == "TRACK" && current.inGame == 0)
    {
        vars.game_state = "MENU";
    }

    /* Print debug info */
    /*
    print("vars.game_state: " + vars.game_state
     + "\ninGame: " + current.inGame
     + "\ncurCheckpoint: " + current.curCheckpoint
     + "\nold.curCheckpoint: " + old.curCheckpoint);
    */
}

start
{
	/* Check level startup */
	if (current.inGame == 1 && old.inGame == 0)
	{
		vars.game_state = "TRACK";
		return true;
	}
}

split
{
    if (current.inGame == 1)
    {
        /* Check end of track */
        if (current.curCheckpoint == -1 && old.curCheckpoint != -1)
        {
            vars.game_state = "MENU";
            return true;
        }

        /* Check end of checkpoint */
        if (settings["splitAtCheckpoint"] && current.curCheckpoint > 1 && current.curCheckpoint != old.curCheckpoint)
        {
            return true;
        }
    }
}

isLoading
{
	return vars.game_state != "TRACK";
}