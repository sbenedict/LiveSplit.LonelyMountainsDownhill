state("LMD_Win_x64", "v1.0.0.2347.1131 (Steam)")
{
	/* Is the timer running */
	byte timerRunning : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x20;

	/* Did we cross at least one checkpoint */
	byte checkpoint : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x21;

	/* Crash state */
	byte crash : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x22;

	/* Level startup */
	byte startup : "GameAssembly.dll", 0x01C36618, 0x758, 0x3d0, 0x23;

	/* Current checkpoint */
	int nCheckpoint : "GameAssembly.dll", 0x01C42638, 0xb8, 0x170, 0x48, 0x5c;
}

startup
{
	vars.game_state = "MENU";
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
	if (current.timerRunning == 1 && old.timerRunning == 0 && current.checkpoint == 0)
	{
		vars.game_state = "TRACK";
		return true;
	}
}

split
{
	/* Check end of track */
	if (current.nCheckpoint == 8 && old.nCheckpoint == 7 && vars.game_state == "TRACK")
	{
		vars.game_state = "MENU";
		return true;
	}
}

isLoading
{
	return vars.game_state != "TRACK";
}