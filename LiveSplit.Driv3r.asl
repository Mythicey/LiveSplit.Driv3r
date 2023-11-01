//Autosplitter by Mythicy for Driv3r.

state("Driv3r","1.0"){								// No-CD Patched v1.0
	byte gamestate : 0x4da66d;						// 1 = In Game
	byte paused : 0x4da5e4;							// 7 = Paused | In Menu
	byte missionID : 0x4b84d4, 0x8;					// 1 = Police HQ, 2 = Lead on Baccus. See settings part for more information.
	byte missionpassedtitle : 0x4b84dc, 0x4;		// 2 = Popping up
	byte timmyswasted : 0x4b8408, 0x8, 0x6;			// Euqals number of Timmys that you have wasted in current mode
	byte miamisecretcar1 : 0x4b86b4, 0x1B5;			// Shelby Cobra
	byte miamisecretcar2 : 0x4b86b4, 0x1B6;			// Ford GT40
	byte miamisecretcar3 : 0x4b86b4, 0x1B7;			// Made For Game Kart
	byte nicesecretcar1 : 0x4b86b4, 0x1BB;			// Plymouth Prowler
	byte nicesecretcar2 : 0x4b86b4, 0x1BC;			// Clark CH-60
	byte nicesecretcar3 : 0x4b86b4, 0x1BD;			// Volkswagen Transporter (Typ 2/T2)
	byte istanbulsecretcar1 : 0x4b86b4, 0x1BE;		// Auto Union Type D
	byte istanbulsecretcar2 : 0x4b86b4, 0x1BF;		// Bugatti Type 57 SC
	byte istanbulsecretcar3 : 0x4b86b4, 0x1C0;		// 1935 Auburn 851 Speedster
}

state("Driv3r","2.0"){								// No-CD Patched v2.0
	byte gamestate : 0x4dfd89;						// 1 = In Game
	byte paused : 0x4d6e2c;							// 7 = Paused | In Menu
	byte missionID : 0x4ac3ac, 0x8;					// 1 = Police HQ, 2 = Lead on Baccus. See settings part for more information.
	byte missionpassedtitle : 0x4ac3b4, 0x4;		// 2 = Popping up
	byte timmyswasted : 0x4ac2e0, 0x8, 0x6;			// Euqals number of Timmys that you have wasted in current mode. DE 4C 6F 67 69 63 20 45 78 70 6F 72 74 20 44 61 74 61
	byte miamisecretcar1 : 0x4ac58c, 0x1B5;			// Shelby Cobra
	byte miamisecretcar2 : 0x4ac58c, 0x1B6;			// Ford GT40
	byte miamisecretcar3 : 0x4ac58c, 0x1B7;			// Made For Game Kart
	byte nicesecretcar1 : 0x4ac58c, 0x1BB;			// Plymouth Prowler
	byte nicesecretcar2 : 0x4ac58c, 0x1BC;			// Clark CH-60
	byte nicesecretcar3 : 0x4ac58c, 0x1BD;			// Volkswagen Transporter (Typ 2/T2)
	byte istanbulsecretcar1 : 0x4ac58c, 0x1BE;		// Auto Union Type D
	byte istanbulsecretcar2 : 0x4ac58c, 0x1BF;		// Bugatti Type 57 SC
	byte istanbulsecretcar3 : 0x4ac58c, 0x1C0;		// 1935 Auburn 851 Speedster
}

//state("Driv3r","Euro/USA"){						// Original retail version
//	byte gamestate : 0x4dfd89;
//	byte paused : 0x4d6e2c;
//	byte missionID : 0x4ac3ac, 0x8;
//	byte missionpassedtitle : 0x4ac3b4, 0x4;
//	int timmyswasted : 0x4ac2cc, 0x4, 0x6e4, 0x528;
//}

init{
	//print(modules.First().ModuleMemorySize.ToString());
    switch(modules.First().ModuleMemorySize){
	case 5177344:
        version = "1.0";
        break;
	case 5337088:
        version = "2.0";
        break;
	case 5332992:
        version = "2.0";
        break;
//	case 7405568:
//        version = "Euro/USA";
//        break;
    default:
        print("Unknown version detected");
        return false;
    }
}

startup
{
	// Set the autosplitter refresh rate (lower = less CPU and less accurate, higher = more CPU usage and more accurate) default: 60
	refreshRate = 30;
	
	vars.mission_splitted = new List<byte>();
	vars.valid_timmy_number = new List<byte>(){1,2,3,4,5,6,7,8,9,10};
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
		vars.mission_splitted.Clear();
		vars.timmyswastedinmiami = 0;
		vars.timmyswastedinnice = 0;
		vars.timmyswastedinistanbul = 0;
		return true;
	}

}

split{
	//------Undercover Missions------//
	if (current.missionpassedtitle == 2 && old.missionpassedtitle < 2 && current.paused != 7 &! vars.mission_splitted.Contains(current.missionID) && current.missionID <= 31)
	{
		vars.mission_splitted.Add(current.missionID);
		//print("Mission "+current.missionID+" passed");
		return settings["U_M"+current.missionID];
	}

	//------Timmy Vermicellis------//
	else if (vars.valid_timmy_number.Contains(current.timmyswasted) && (((settings["miam_TVs"] && current.missionID == 77 && current.timmyswasted > vars.timmyswastedinmiami) || (settings["miam_allTVs"] && current.missionID == 77 && current.timmyswasted > 9 && old.timmyswasted == 9)) || ((settings["nice_TVs"] && current.missionID == 80 && current.timmyswasted > vars.timmyswastedinnice) || (settings["nice_allTVs"] && current.missionID == 80 && current.timmyswasted > 9 && old.timmyswasted == 9)) || ((settings["ista_TVs"] && current.missionID == 83 && current.timmyswasted > vars.timmyswastedinistanbul) || (settings["ista_allTVs"] && current.missionID == 83 && current.timmyswasted > 9 && old.timmyswasted == 9))) && current.gamestate != 0)
	{
		switch((byte)current.missionID)
		{
			case 77:
			vars.timmyswastedinmiami ++;
			break;

			case 80:
			vars.timmyswastedinnice ++;
			break;

			case 83:
			vars.timmyswastedinistanbul ++;
			break;
		}
		return true;
	}

	//------Secret Cars------//
	else if (((current.miamisecretcar1 == 1 && old.miamisecretcar1 == 0 && settings["miam_SC1"]) || (current.miamisecretcar2 == 1 && old.miamisecretcar2 == 0 && settings["miam_SC2"]) || (current.miamisecretcar3 == 1 && old.miamisecretcar3 == 0 && settings["miam_SC3"])) && current.gamestate != 0)
	{
		return true;
	}

	else if (((current.nicesecretcar1 == 1 && old.nicesecretcar1 == 0 && settings["nice_SC1"]) || (current.nicesecretcar2 == 1 && old.nicesecretcar2 == 0 && settings["nice_SC2"]) || (current.nicesecretcar3 == 1 && old.nicesecretcar3 == 0 && settings["nice_SC3"])) && current.gamestate != 0)
	{
		return true;
	}

	else if (((current.istanbulsecretcar1 == 1 && old.istanbulsecretcar1 == 0 && settings["ista_SC1"]) || (current.istanbulsecretcar2 == 1 && old.istanbulsecretcar2 == 0 && settings["ista_SC2"]) || (current.istanbulsecretcar3 == 1 && old.istanbulsecretcar3 == 0 && settings["ista_SC3"])) && current.gamestate != 0)
	{
		return true;
	}

}

reset
{
	return (((current.gamestate == 1 && old.gamestate == 0) && current.missionID == 1) || (current.missionID ==1 && old.missionID != 1)) && TimeSpan.Parse(timer.CurrentTime.RealTime.ToString()).TotalSeconds > 5;
}
