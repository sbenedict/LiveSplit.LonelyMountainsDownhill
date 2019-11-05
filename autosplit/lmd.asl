/*
 lmd.asl

 Game: Lonely Mountains: Downhill
 Game Version: 1.0.1.2356.0060 (Steam)
 Script Version: 1.02 (2019-11-04)

 Contributors:
    Kilaye (discord: Kilaye#8700)
    psam (discord: psam#0545)
 
 Changelog:
    v1.02 - Changed start to level startup (psam)
          - Updated for game v1.01 (psam)
    v1.01 - Fixed checkpoint split (psam)
          - Added end of trail split (psam)
    v1.00 - Initial release with incorrect checkpoint split (Kilaye)
*/

state("LMD_Win_x64", "v1.0.1.2356.0060 (Steam)")
{
    /* Is in menu */
    byte inGame : "GameAssembly.dll", 0x01D92D08;

	/* Is the timer running */
	byte timerRunning : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x20;

	/* Did we cross at least one checkpoint */
	byte initCheckpoint : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x21;

	/* Crash state */
	byte crash : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x22;

	/* Level startup */
	byte startup : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x23;

	/* Current checkpoint */
	int curCheckpoint : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x48, 0x5c;

	/* Total checkpoints */
	int totCheckpoints : "GameAssembly.dll", 0x01D32F08, 0xB8, 0x10, 0x20, 0xA4;

    /* Trail finished */
    int trailFinished : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x48, 0x64; // while on trail = curCheckpoint, finished = -1
}

startup
{
	vars.game_state = "MENU";
    
    settings.Add("splitAtCheckpoint", false, "Split at checkpoint");
}

update
{
	//if (current.startup == 1 && vars.game_state == "MENU")
	//{
	//	vars.game_state = "STARTUP";
	//}
	
	/* Check beginning of track */
	//if (current.timerRunning == 1 && old.timerRunning == 0 && vars.game_state == "STARTUP")
	//{
	//	vars.game_state = "TRACK";
	//}
    
    /* Print debug info */
    ///*
    print("vars.game_state: " + vars.game_state
     + "\nmenuPtr: " + current.menuPtr
     + "\ntimerRunning: " + current.timerRunning
     + "\ninitCheckpoint: " + current.initCheckpoint
     + "\ncrash: " + current.crash
     + "\nstartup: " + current.startup
     + "\ncurCheckpoint: " + current.curCheckpoint
     + "\ntotCheckpoints: " + current.totCheckpoints
     + "\ntrailFinished: " + current.trailFinished);
    //*/
}

start
{
	/* Check level startup */
	if (current.startup == 1 && old.startup == 0 && current.totCheckpoints > 0)
	{
		vars.game_state = "TRACK";
		return true;
	}
}

split
{
	/* Check end of track */
	if (current.trailFinished == -1 && vars.game_state == "TRACK")
	{
		vars.game_state = "MENU";
		return true;
	}

    /* Check end of checkpoint */
    if (settings["splitAtCheckpoint"] && current.curCheckpoint != old.curCheckpoint && vars.game_state == "TRACK")
    {
		return true;
    }
}

isLoading
{
	return vars.game_state != "TRACK";
}