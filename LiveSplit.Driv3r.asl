//Autosplitter by Mythicy for Driv3r.

state("Driv3r","1.0"){								// No-CD Patched v1.0
	byte gamestate : 0x4da66d;						// 1 = In Game
	byte paused : 0x4da5e4;							// 7 = Paused | In Menu
	byte missionID : 0x4b84d4, 0x8;					// 1 = Police HQ, 2 = Lead on Baccus. See settings part for more information.
	byte missionpassedtitle : 0x4b84dc, 0x4;		// 2 = Popping up
}

state("Driv3r","2.0"){								// No-CD Patched v2.0
	byte gamestate : 0x4dfd89;						// 1 = In Game
	byte paused : 0x4d6e2c;							// 7 = Paused | In Menu
	byte missionID : 0x4ac3ac, 0x8;					// 1 = Police HQ, 2 = Lead on Baccus. See settings part for more information.
	byte missionpassedtitle : 0x4ac3b4, 0x4;		// 2 = Popping up
//	byte collectibles : 0x4ac58c, 0x180;			// 1 = Collected, 0 = Not Collected. 0x180 = 1st Timmy in Miami, 0x18A = 1st Timmy in Nice, 0x194 = 1st Timmy in Istanbul, 0x1B5 = 1st Secret Car in Miami, 0x1BB = 1st Secret Car in Nice, 0x1BE = 1st Secret Car in Istanbul...
}

//state("Driv3r","Euro/USA"){						// Original retail version
//	byte gamestate : 0x4dfd89;
//	byte paused : 0x4d6e2c;
//	byte missionID : 0x4ac3ac, 0x8;
//	byte missionpassedtitle : 0x4ac3b4, 0x4;
//}

init{
	//print(modules.First().ModuleMemorySize.ToString());
    switch(modules.First().ModuleMemorySize){
	case 5177344:
        version = "1.0";
		vars.collectiblebaseaddr = 0x4b86b4;
        break;
	case 5337088: case 5332992:
        version = "2.0";
		vars.collectiblebaseaddr = 0x4ac58c;
        break;
//	case 7405568:
//        version = "Euro/USA";
//        break;
    default:
        print("Unknown version detected");
        return false;
    }

	// Adds collectibles memory addresses (with the correct offset) to the watcher list.
	vars.memoryWatchers = new MemoryWatcherList();
	
	//------Timmy Vermicellis in Miami------//
	for(int i = 0x0; i<=9; ++i)
	{
		vars.memoryWatchers.Add(new MemoryWatcher<byte>(new DeepPointer(vars.collectiblebaseaddr, 0x180 + i)){ Name = "miamTim"+(i+1).ToString() });
	}
	
	//------Timmy Vermicellis in Nice------//
	for(int i = 0x0; i<=9; ++i)
	{
		vars.memoryWatchers.Add(new MemoryWatcher<byte>(new DeepPointer(vars.collectiblebaseaddr, 0x18A + i)){ Name = "niceTim"+(i+1).ToString() });
	}
	
	//------Timmy Vermicellis in Istanbul------//
	for(int i = 0x0; i<=9; ++i)
	{
		vars.memoryWatchers.Add(new MemoryWatcher<byte>(new DeepPointer(vars.collectiblebaseaddr, 0x194 + i)){ Name = "istaTim"+(i+1).ToString() });
	}

	//------Secret Cars in Miami------//
	for(int i = 0x0; i<=2; ++i)
	{
		vars.memoryWatchers.Add(new MemoryWatcher<byte>(new DeepPointer(vars.collectiblebaseaddr, 0x1B5 + i)){ Name = "miamSC"+(i+1).ToString() });
	}

	//------Secret Cars in Nice------//
	for(int i = 0x0; i<=2; ++i)
	{
		vars.memoryWatchers.Add(new MemoryWatcher<byte>(new DeepPointer(vars.collectiblebaseaddr, 0x1BB + i)){ Name = "niceSC"+(i+1).ToString() });
	}

	//------Secret Cars in Istanbul------//
	for(int i = 0x0; i<=2; ++i)
	{
		vars.memoryWatchers.Add(new MemoryWatcher<byte>(new DeepPointer(vars.collectiblebaseaddr, 0x1BE + i)){ Name = "istaSC"+(i+1).ToString() });
	}

}

update
{
	// Disables all the action blocks below in the code if the user is using an unsupported version.
	if (version == "")
		return false;
		
	// Update all of the memory readings for the collectible memory addresses.
	vars.memoryWatchers.UpdateAll(game);

}

startup
{
	// Set the autosplitter refresh rate (lower = less CPU and less accurate, higher = more CPU usage and more accurate) default: 60
	refreshRate = 30;
	
	vars.missions_splitted = new List<byte>();
	vars.timmyswastedinmiami = 0;
	vars.timmyswastedinnice = 0;
	vars.timmyswastedinistanbul = 0;

	// Settings


		//------Undercover Missions------//
	    settings.Add("UMs", true, "Undercover Missions");
			settings.Add("miam", true, "Miami", "UMs");
				settings.Add("U_M"+1, true, "Police HQ", "miam");
				settings.Add("U_M"+2, true, "Lead on Baccus", "miam");
				settings.Add("U_M"+3, true, "The Siege", "miam");
				settings.Add("U_M"+4, true, "Rooftops", "miam");
				settings.Add("U_M"+5, true, "Impress Lomaz", "miam");
				settings.Add("U_M"+6, true, "Gator's Yacht", "miam");
				settings.Add("U_M"+7, true, "The Hit", "miam");
				settings.Add("U_M"+8, true, "Trapped", "miam");
				settings.Add("U_M"+9, true, "Dodge Island", "miam");
				settings.Add("U_M"+10, true, "Retribution", "miam");

			settings.Add("nice", true, "Nice", "UMs");
				settings.Add("U_M"+11, true, "Welcome to Nice", "nice");
				settings.Add("U_M"+13, true, "Smash & Run", "nice");
				settings.Add("U_M"+14, true, "18 Wheeler", "nice");
				settings.Add("U_M"+15, true, "Hijack", "nice");
				settings.Add("U_M"+16, true, "Arms Deal", "nice");
				settings.Add("U_M"+17, true, "Booby Trap", "nice");
				settings.Add("U_M"+18, true, "Calita In Trouble", "nice");
				settings.Add("U_M"+19, true, "Rescue Dubois", "nice");
				settings.Add("U_M"+21, true, "Hunted", "nice");
			
			settings.Add("ista", true, "Istanbul", "UMs");
				settings.Add("U_M"+22, true, "Surveillance", "ista");
				settings.Add("U_M"+24, true, "Tanner Escapes", "ista");
				settings.Add("U_M"+25, true, "Another Lead", "ista");
				settings.Add("U_M"+27, true, "Alleyway", "ista");
				settings.Add("U_M"+28, true, "The Chase", "ista");
				settings.Add("U_M"+30, true, "Bomb Truck", "ista");
				settings.Add("U_M"+31, true, "Chase The Train", "ista");
		
		//------Timmy Vermicellis------//
	    settings.Add("TVs", false, "Timmy Vermicellis"); 
			settings.Add("miam_TVs", true, "Miami(Each)", "TVs");
			settings.Add("miam_allTVs", true, "Miami(All)", "TVs");
			settings.Add("nice_TVs", true, "Nice(Each)", "TVs");
			settings.Add("nice_allTVs", true, "Nice(All)", "TVs");
			settings.Add("ista_TVs", true, "Istanbul(Each)", "TVs");
			settings.Add("ista_allTVs", true, "Istanbul(All)", "TVs");

		//------Secret Cars------//
	    settings.Add("SCs", false, "Secret Cars"); 
			settings.Add("miam_SCs", true, "Miami", "SCs");
				settings.Add("miam_SC1", true, "Shelby Cobra", "miam_SCs");
				settings.Add("miam_SC2", true, "Ford GT40", "miam_SCs");
				settings.Add("miam_SC3", true, "Made For Game Kart", "miam_SCs");
			settings.Add("nice_SCs", true, "Nice", "SCs");
				settings.Add("nice_SC1", true, "Plymouth Prowler", "nice_SCs");
				settings.Add("nice_SC2", true, "Clark CH-60", "nice_SCs");
				settings.Add("nice_SC3", true, "Volkswagen Transporter (Typ 2/T2)", "nice_SCs");
			settings.Add("ista_SCs", true, "Istanbul", "SCs");
				settings.Add("ista_SC1", true, "Auto Union Type D", "ista_SCs");
				settings.Add("ista_SC2", true, "Bugatti Type 57 SC", "ista_SCs");
				settings.Add("ista_SC3", true, "1935 Auburn 851 Speedster", "ista_SCs");


}

start{

	if (current.gamestate == 1 && old.gamestate == 0)
	{
		vars.missions_splitted.Clear();
		vars.timmyswastedinmiami = 0;
		vars.timmyswastedinnice = 0;
		vars.timmyswastedinistanbul = 0;
		return true;
	}

}

split{
	//------Undercover Missions------//
	if (current.missionpassedtitle == 2 && old.missionpassedtitle < 2 && current.paused != 7 &! vars.missions_splitted.Contains(current.missionID) && current.missionID <= 31)
	{
		vars.missions_splitted.Add(current.missionID);
		//print("Mission "+current.missionID+" passed");
		return settings["U_M"+current.missionID];
	}

	//------Secret Cars------//
	foreach(var secretcar in vars.memoryWatchers)
	{
		if (secretcar.Current == 1 && secretcar.Old == 0 && current.gamestate != 0)
		{
			if (secretcar.Name.Contains("miamSC"))
			{
				if (secretcar.Name.Contains("1"))
				{
					return settings["miam_SC1"];
				}
				else if (secretcar.Name.Contains("2"))
				{
					return settings["miam_SC2"];
				}
				else if (secretcar.Name.Contains("3"))
				{
					return settings["miam_SC3"];
				}
			}
			else if (secretcar.Name.Contains("niceSC"))
			{
				if (secretcar.Name.Contains("1"))
				{
					return settings["nice_SC1"];
				}
				else if (secretcar.Name.Contains("2"))
				{
					return settings["nice_SC2"];
				}
				else if (secretcar.Name.Contains("3"))
				{
					return settings["nice_SC3"];
				}
			}
			else if (secretcar.Name.Contains("istaSC"))
			{
				if (secretcar.Name.Contains("1"))
				{
					return settings["ista_SC1"];
				}
				else if (secretcar.Name.Contains("2"))
				{
					return settings["ista_SC2"];
				}
				else if (secretcar.Name.Contains("3"))
				{
					return settings["ista_SC3"];
				}
			}
		}
	}

	//------Timmy Vermicellis------//
	foreach(var timmy in vars.memoryWatchers)
	{
		if (timmy.Current == 1 && timmy.Old == 0 && current.gamestate != 0)
		{
			if (timmy.Name.Contains("miamTim"))
			{
				vars.timmyswastedinmiami++;
				//print("Miami Timmy "+vars.timmyswastedinmiami+" wasted");
				if (vars.timmyswastedinmiami == 10)
				{
					return settings["miam_allTVs"];
				}
				else
				{
					return settings["miam_TVs"];
				}
			}
			else if (timmy.Name.Contains("niceTim"))
			{
				vars.timmyswastedinnice++;
				//print("Nice Timmy "+vars.timmyswastedinnice+" wasted");
				if (vars.timmyswastedinnice == 10)
				{
					return settings["nice_allTVs"];
				}
				else
				{
					return settings["nice_TVs"];
				}
			}
			else if (timmy.Name.Contains("istaTim"))
			{
				vars.timmyswastedinistanbul++;
				//print("Istanbul Timmy "+vars.timmyswastedinistanbul+" wasted");
				if (vars.timmyswastedinistanbul == 10)
				{
					return settings["ista_allTVs"];
				}
				else
				{
					return settings["ista_TVs"];
				}
			}
		}
	}

}

reset
{
	return (((current.gamestate == 1 && old.gamestate == 0) && current.missionID == 1) || (current.missionID ==1 && old.missionID != 1)) && TimeSpan.Parse(timer.CurrentTime.RealTime.ToString()).TotalSeconds > 5;
}
