
state("Driv3r","1.0"){                       // No-CD Patched V1.0
	byte gamestate : 0x4da66d;  //1 = In Game
	byte paused : 0x4da514; //7 = Paused | In Menu
	byte missionplayed : 0x4b84d4, 0x8;
	byte missionpassedtitle : 0x4b84dc, 0x4; 
	int timmyswasted : 0x4b83f4, 0x4, 0x66c, 0x7f8;
}

state("Driv3r","2.0"){                       // No-CD Patched V2.0
	byte gamestate : 0x4dfd89;  //1 = In Game
	byte paused : 0x4d6e2c; //7 = Paused | In Menu
	byte missionplayed : 0x4ac3ac, 0x8;
	byte missionpassedtitle : 0x4ac3b4, 0x4;
	int timmyswasted : 0x4ac2cc, 0x4, 0x6e4, 0x528;
}

init{
	//print(modules.First().ModuleMemorySize.ToString());
    switch(modules.First().ModuleMemorySize){
	case 5177344:
        version = "1.0";
        break;
	case 5337088:
        version = "2.0";
        break;
    default:
        print("Unknown version detected");
        return false;
    }
}

startup
{
	// Set the autosplitter refresh rate (lower = less CPU and less accurate, higher = more CPU usage and more accurate) default: 60
	refreshRate = 30;
	
	vars.counter = 1; //For main missions
	vars.timmyswastedinmiami = 0;
	vars.timmyswastedinnice = 0;
	vars.timmyswastedinistanbul = 0;

	// Settings


		//------Main Missions------//
	    settings.Add("MMs", true, "Missions");
			settings.Add("miam", true, "Miami", "MMs");
				settings.Add("M_M"+1, true, "Police HQ", "miam");
				settings.Add("M_M"+2, true, "Lead on Baccus", "miam");
				settings.Add("M_M"+3, true, "The Siege", "miam");
				settings.Add("M_M"+4, true, "Rooftops", "miam");
				settings.Add("M_M"+5, true, "Impress Lomaz", "miam");
				settings.Add("M_M"+6, true, "Gator's Yacht", "miam");
				settings.Add("M_M"+7, true, "The Hit", "miam");
				settings.Add("M_M"+8, true, "Trapped", "miam");
				settings.Add("M_M"+9, true, "Dodge Island", "miam");
				settings.Add("M_M"+10, true, "Retribution", "miam");

			settings.Add("nice", true, "Nice", "MMs");
				settings.Add("M_M"+11, true, "Welcome to Nice", "nice");
				settings.Add("M_M"+13, true, "Smash & Run", "nice");
				settings.Add("M_M"+14, true, "18 Wheeler", "nice");
				settings.Add("M_M"+15, true, "Hijack", "nice");
				settings.Add("M_M"+16, true, "Arms Deal", "nice");
				settings.Add("M_M"+17, true, "Booby Trap", "nice");
				settings.Add("M_M"+18, true, "Calita In Trouble", "nice");
				settings.Add("M_M"+19, true, "Rescue Dubois", "nice");
				settings.Add("M_M"+21, true, "Hunted", "nice");
			
			settings.Add("ista", true, "Istanbul", "MMs");
				settings.Add("M_M"+22, true, "Surveillance", "ista");
				settings.Add("M_M"+24, true, "Tanner Escapes", "ista");
				settings.Add("M_M"+25, true, "Another Lead", "ista");
				settings.Add("M_M"+27, true, "Alleyway", "ista");
				settings.Add("M_M"+28, true, "The Chase", "ista");
				settings.Add("M_M"+30, true, "Bomb Truck", "ista");
				settings.Add("M_M"+31, true, "Chase The Train", "ista");
		
				//------Timmy Vermicellis------//
	    settings.Add("TVs", false, "Timmy Vermicellis"); 
			settings.Add("miam_TVs", true, "Miami(Each)", "TVs");
			settings.Add("miam_allTVs", true, "Miami(All)", "TVs");
			settings.Add("nice_TVs", true, "Nice(Each)", "TVs");
			settings.Add("nice_allTVs", true, "Nice(All)", "TVs");
			settings.Add("ista_TVs", true, "Istanbul(Each)", "TVs");
			settings.Add("ista_allTVs", true, "Istanbul(All)", "TVs");

}

start{
	
	vars.counter = 1;
	vars.timmyswastedinmiami = 0;
	vars.timmyswastedinnice = 0;
	vars.timmyswastedinistanbul = 0;

	if (current.gamestate == 1 && old.gamestate == 0)
	{
		return true;
	}

}

split{
	//------Main Missions------//
	if (current.missionpassedtitle == 2 && old.missionpassedtitle < 2 && current.missionplayed == vars.counter && current.paused != 7)
	{
		switch((byte)vars.counter)
		{
			case 11:case 19:case 22:case 25:case 28:
			vars.counter=vars.counter+1;
			break;
		}
		vars.counter=vars.counter+1;
		return settings["M_M"+current.missionplayed];
	}

	//------Timmy Vermicellis------//
	else if (current.timmyswasted > old.timmyswasted && current.timmyswasted <11 && (((settings["miam_TVs"] && current.missionplayed == 77 && current.timmyswasted > vars.timmyswastedinmiami) || (settings["miam_allTVs"] && current.missionplayed == 77 && current.timmyswasted == 10)) || ((settings["nice_TVs"] && current.missionplayed == 80 && current.timmyswasted > vars.timmyswastedinnice) || (settings["nice_allTVs"] && current.missionplayed == 80 && current.timmyswasted == 10)) || ((settings["ista_TVs"] && current.missionplayed == 83 && current.timmyswasted > vars.timmywastsedinistanbul)|| (settings["ista_allTVs"] && current.missionplayed == 83 && current.timmyswasted == 10))) && current.paused != 7)
	{	
		switch((byte)current.missionplayed)
		{
			case 77:
			vars.timmyswastedinmiami=current.timmyswasted;
			break;

			case 80:
			vars.timmyswastedinnice=current.timmyswasted;
			break;

			case 83:
			vars.timmyswastedinistanbul=current.timmyswasted;
			break;
		}
		return true;
	}
}

reset
{
	return (((current.gamestate == 1 && old.gamestate == 0) && current.missionplayed == 1) || (current.missionplayed ==1 && old.missionplayed != 1)) && TimeSpan.Parse(timer.CurrentTime.RealTime.ToString()).TotalSeconds > 5;
}