/*
 lmd.asl

 Game: Lonely Mountains: Downhill
 Game Version: 1.0.0.2347.1131 (Steam)
 Script Version: 1.01 (2019-11-03)

 Contributors:
    Kilaye (discord: Kilaye#8700)
    psam (discord: psam#0545)
 
 Changelog:
    v1.01 - Fixed checkpoint split (psam)
          - Added end of trail split (psam)
    v1.00 - Initial release with incorrect checkpoint split (Kilaye)
*/

state("LMD_Win_x64", "v1.0.0.2347.1131 (Steam)")
{
	/* Is the timer running */
	byte timerRunning : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x20;

	/* Did we cross at least one checkpoint */
	byte initCheckpoint : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x21;

	/* Crash state */
	byte crash : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x22;

	/* Level startup */
	byte startup : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x23;

	/* Current checkpoint */
	int curCheckpoint : "GameAssembly.dll", 0x01C420D8, 0x48, 0xB8, 0x0, 0x48, 0x5c;
    
    /* Trail finished */
    int trailFinished : "GameAssembly.dll", 0x01C420D8, 0x78, 0xB8, 0x0, 0x48, 0x64; // while on trail = curCheckpoint, finished = -1
}

startup
{
	vars.game_state = "MENU";
    
    settings.Add("splitAtCheckpoint", false, "Split at checkpoint");
}

update
{
	if (current.startup == 1 && vars.game_state == "MENU")
	{
		vars.game_state = "STARTUP";
	}
	
	/* Check beginning of track */
	if (current.timerRunning == 1 && old.timerRunning == 0 && vars.game_state == "STARTUP")
	{
		vars.game_state = "TRACK";
	}
}

start
{
	/* Check beginning of track */
	if (current.timerRunning == 1 && old.timerRunning == 0 && current.initCheckpoint == 0)
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