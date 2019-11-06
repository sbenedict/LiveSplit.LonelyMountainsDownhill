/*
    lmd.asl

    Game: Lonely Mountains: Downhill
    Game Version: 1.0.1.2356.0060 (Steam)
                  1.0.0.2348.0868 (Xbox)
    Script Version: 1.06 (2019-11-06)

    Contributors:
        Kilaye (discord: Kilaye#8700)
        psam (discord: psam#0545)
 
    Changelog:
        v1.06 - Add Xbox game version (psam)
        v1.05 - Change game time tracking to sync with game timer (psam)
              - Add game version check (psam)
        v1.04 - Increased refresh rate to 100/second (psam)
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

    /* Is the timer running */
    byte timerRunning : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x20;

    /* Current checkpoint */
    int curCheckpoint : "GameAssembly.dll", 0x01D34D40, 0xB8, 0x10, 0x48, 0x64; // finished = -1
}

state("LMD_PC-MasterBuild-Xbl_Win_x64", "v1.0.0.2348.0868 (Xbox)")
{
    /* Is in game (not menu) */
    byte inGame : "mono-2.0-bdwgc.dll", 0x00499034;

    /* Is the timer running */
    byte timerRunning : "mono-2.0-bdwgc.dll", 0x0048FA90, 0xD10, 0x58;

    /* Current checkpoint */
    int curCheckpoint : "mono-2.0-bdwgc.dll", 0x0048FA90, 0xD10, 0x20, 0x10, 0x28, 0x20, 0x38, 0x38, 0x50, 0x70, 0x64; // finished = -1
}

startup
{
    settings.Add("splitAtCheckpoint", false, "Split at checkpoint");
}

init
{
    var moduleVersion = modules.First().FileVersionInfo;
    var fileName = Path.GetFileNameWithoutExtension(moduleVersion.FileName);
    var fileVersion = moduleVersion.FileVersion;
    print("FileName: " + fileName + "\nFileVersion: " + fileVersion);

    if (fileName == "LMD_Win_x64" && fileVersion == "2018.4.8.10209753") version = "v1.0.1.2356.0060 (Steam)";
    if (fileName == "LMD_PC-MasterBuild-Xbl_Win_x64" && fileVersion == "2018.4.8.10209753") version = "v1.0.0.2348.0868 (Xbox)";

    refreshRate = 100.0;
}

exit
{
    refreshRate = 0.5;
}

update
{
    /* Check if supported version */
    if (version == "") return false;

    /* Print debug info */
    /*
    if (current.inGame != old.inGame
    || current.timerRunning != old.timerRunning
    || current.curCheckpoint != old.curCheckpoint)
        print("inGame: " + current.inGame
         + "\ntimerRunning: " + current.timerRunning
         + "\ncurCheckpoint: " + current.curCheckpoint
         + "\nold.curCheckpoint: " + old.curCheckpoint
         + "\n");
    */
}

start
{
    /* Check level startup */
    if (current.inGame == 1 && old.inGame == 0)
    {
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
    return current.timerRunning == 0 || current.curCheckpoint == -1;
}