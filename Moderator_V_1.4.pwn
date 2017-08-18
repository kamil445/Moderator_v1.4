/*  _________________________________________________________
	|                                                       |
	|                  Moderator V 1.4                      |
	|                          BY                           |
	|                       Czechu                          |
	|                                                       |
	|_______________________________________________________|


	Dzięki że pobrałeś(aś) mój skrypt "Moderator v 1.4 :)
	Mam nadzieję że bedzie ci dobrze służył.
	Zezwalam na : edytowanie według własnych potrzeb, wrzucenie do własnej mapki (ale proszę oto aby
	komendę /mabout takze skopiować :)
	Zabraniam : wystawiania na inne fora, zmiany autora

	Zmiany v 1.4 :

	- Zmieniono system logowania na moderatora, teraz wszystko dzieje się
	automatycznie po wejściu gracza,
	- Dodano rangi moderatora, 1 - najniższa, 2- najwyższa,
	- Dodano kilkanaście komend, w tym dodawanie oraz usuwanie moderatorów,
	- Logowanie gracza na administratora do czasu wylogowania,

*/
//---------------------INCLUDE--------------------------------------------------
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <dini>
//---------------------DEFINICJE------------------------------------------------
#define MG "Mod/mody.ini" //Lokalizacja pliku z nazwami oraz poziomami Modów
#define WARNY "Mod/warny.ini" //lokalizacja pliku z warnami graczy
#define MAX_GRACZY 20 //Maksymalna ilosć graczy na serwerze
#define DIALOG_MADM 200 //ID dialogu komend Admina (Moderator)
#define DIALOG_MCMD 201 //ID dialogu komend Moderatora
#define DIALOG_MONL 202 //ID dialogu komendy /monline
#define DIALOG_MABOUT 203 //ID dialogu komendy /mabout
#define DIALOG_NETSTATS 204 //ID dialogu komendy /netstats
#define DIALOG_MCMD2 205 //ID dialogu komend Moderatora częśc 2
//--------------------KOLORKI---------------------------------------------------
#define COLOR_LEMON 0xDDDD2357
#define COLOR_BLUEGREEN 0x46BBAA00
//------------------------NEW'Y-------------------------------------------------
new Mod[MAX_GRACZY]; //Moderator
new Warn[MAX_GRACZY]; //Warny
new MuteTimer[MAX_GRACZY]; //Timer Mute
new Muted[MAX_GRACZY]; //Mute

new gNetStatsPlayerId = INVALID_PLAYER_ID;
new gNetStatsTimerId = 0;

new carname[][] =
{
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Limuzyne",
	"Manane","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulans","Leviathan","Moonbeam","Esperanto","Taxi","Washington",
	"Bobcat","MrWhoopee","BFInjection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Busa","Czołg",
	"Barracks","Hotknifa","Trailer","Previon","Autokar","Cabbie","Stallion","Rumpo","RCBandit","Romero","Packer","Monster Trucka",
	"Admiral","Squalo","Seasparrow","Pizzaboy","Tramwaj","Trailer","Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee",
	"Caddy","Solair","Berkley'sRCVan","Skimmer","PCJ - 600","Faggio","Freeway","RCBaron","RCRaider","Glendale","Oceanic",
	"Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR350","Walton","Regina","Comet",
	"BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","newsChopper","Rancher","FBIRancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","BlistaCompact","PoliceMaverick","Boxville","Benson","Mesa","RCGoblin","HotringRacer",
	"HotringRacer","BloodringBanger","Rancher","SuperGT","Elegant","Journey","Bike","MountainBike","Beagle","Cropdust",
	"Stunt","Tanker","RoadTrain","Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","CementTruck",
	"TowTruck","Fortune","Cadrona","FBITruck","Willard","Forklift","Traktor","Combine","Feltzer","Remington","Slamvan",
	"Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo",
	"Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster","Monster","Uranus","Jester",
	"Sultan","Stratum","Elegy","Raindance","RCTiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer","Kart","Mower",
	"Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","newsvan","Tug","Trailer",
	"Emperor","Wayfarer","Euros","Hotdog","Club","Trailer","Trailer","Andromada","Dodo","RCCam","Launch","PoliceCar(LSPD)",
	"PoliceCar(SFPD)","PoliceCar(LVPD)","PoliceRanger","Picador","S.W.A.T.Van","Alpha","Phoenix","Glendale","Sadler",
	"LuggageTrailer","LuggageTrailer","StairTrailer","Boxville","FarmPlow","UtilityTrailer"
};
//------------------------ANTYDEAMX+EMIT----------------------------------------
AntyDeAMX()
{
	new amx[][] ={"Unarmed (Fist)","Brass K"};
	new d; // zmienna d
	#emit load.pri d //ładowanie zmiennej "d" do pamięci (bazowane na Asemblerze)
	#emit stor.pri d //zapisywanie zmiennej "d" do pamięci (bazowane na Asemblerze)
	#pragma unused amx
}

main()
{
	AntyDeAMX();
	print("\n----------------------------------");
	print(" Moderator v1.4 by Czechu załadowany!");
	print("----------------------------------\n");
}

public OnFilterScriptInit()
{

	print("\n----------------------------------");
	print(" Moderator v1.4 by Czechu załadowany!");
	print("----------------------------------\n");
	AntyDeAMX();
	if(!dini_Exists(MG)) dini_Create(MG);
	if(!dini_Exists(WARNY)) dini_Create(WARNY);

	return 1;
}

public OnFilterScriptExit()
{
	print("\n-----------------------------------");
	print(" Moderator v1.4 by Czechu niezaładowany!");
	print("------------------------------------\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	Mod[playerid] = 0;
	Muted[playerid] = 0;

	Warn[playerid] = dini_Int(WARNY, PlayerName(playerid));
	
	new playername[MAX_GRACZY];
	GetPlayerName(playerid,playername,sizeof(playername));
	
	new str[256];
	
	str = dini_Get(MG,playername);
	
	new Poziom = strval(str);
	
	if(Poziom == 2)
	{
		Mod[playerid] = 2;
	}
	if(Poziom == 1)
	{
		Mod[playerid] = 1;
	}
	if(Mod[playerid] >= 1)
 	{
		format(str, sizeof(str), "[M-INFO] Witaj %s, twój poziom Moderatora to : Moderator poziomu %d", PlayerName(playerid), Mod[playerid]);
		SendClientMessage(playerid, COLOR_LEMON, str);
		SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Komendy Moderatora znajdziesz pod /mcmd");
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(Warn[playerid] == 3)
	{
		Warn[playerid] = 0;
		return 1;
	}

	if(Warn[playerid] >= 1)
	{
		dini_IntSet(WARNY, PlayerName(playerid), Warn[playerid]);
	}
	Warn[playerid] = 0;
	Mod[playerid] = 0;
	Muted[playerid] = 0;
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new str[256];

	if(Muted[playerid] == 1)
	{
		SendClientMessage(playerid,0xFF0000FF,"{24FF0A}[ERROR] {FFFFFF}Nie możesz pisać, gdy jesteś wyciszony(a)!");
		return 0;
	}

	if(Mod[playerid])
	{
		format(str, sizeof(str),"(Moderator|POZ: %d| ID: %d): %s", Mod[playerid], playerid, text);
		SendPlayerMessageToAll(playerid, str);
		} else {
		format(str, sizeof(str),"(Gracz| ID: %d): %s", playerid, text);
		SendPlayerMessageToAll(playerid, str);
	}
	return 0;
}

CMD:warny(playerid, params[])
{
	new str[128];
	if(Warn[playerid] == 0)
	{
		SendClientMessage(playerid, COLOR_LEMON, "[INFO] Nie masz żadnego ostrzeżenia, tak trzymaj ! :)");
		return 1;
	}

	format(str, sizeof(str), "[INFO] Twoja ilość ostrzeżeń: %d", Warn[playerid]);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mabout(playerid, params[])
{
	new Str[256];

	strcat(Str,"Autor : Czechu \n");
	strcat(Str,"Edited by: (twój nick) \n");
	strcat(Str,"Wersja : 1.4\n");
	strcat(Str,"Ostatnia Aktualizacja: : 27.10.2013|16:54\n");
	strcat(Str,"W razie pytań, pisz GG: 6445926\n");
	ShowPlayerDialog(playerid, DIALOG_MABOUT, DIALOG_STYLE_MSGBOX, "{AAFFCC}Informacje",Str,"Wyjdź", "");
	return 1;
}

CMD:madmin(playerid, params[])
{
	new Str[512];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Administratorem!");

    strcat(Str,"{FFFF00}/dajmoda [ID] [POZIOM 1-2] {FFFFFF}- Dajesz graczowi moda\n");
    strcat(Str,"{FFFF00}/wezmoda [ID] [POWÓD] {FFFFFF}- Zabierasz graczowi moda\n");
	strcat(Str,"{FFFF00}/mloguj [ID] [POZIOM 1-2] {FFFFFF}- Logujesz gracza na Moderatora, do czasu wyjścia z serwera\n");
	strcat(Str,"{FFFF00}/mwyloguj [ID] {FFFFFF}- Wylogowujesz gracza z Moderatora\n");
	ShowPlayerDialog(playerid, DIALOG_MADM, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Administratora {63AFF0}(Moderator v 1.4 by Czechu)",Str,"Wyjdź", "");
	return 1;
}

CMD:mcmd(playerid, params[])
{
	new Str[3096];
	
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	strcat(Str,"{00A600}Moderator Poziomu 1 :\n\n");
	strcat(Str,"{FFFF00}/mgod [ID] {FFFFFF}- Dajesz nieśmiertelność graczowi\n");
	strcat(Str,"{FFFF00}/mtp [ID] [ID2] {FFFFFF}- Teleportujesz [ID] do [ID2]\n");
	strcat(Str,"{FFFF00}/marmor [ID] {FFFFFF}- Dajesz armor graczowi\n");
	strcat(Str,"{FFFF00}/mheal [ID] {FFFFFF}- Uzdrawiasz danego gracza\n");
	strcat(Str,"{FFFF00}/msettime [GODZINA] {FFFFFF}- Zmieniasz czas\n");
	strcat(Str,"{FFFF00}/mweather [POGODA] {FFFFFF}- Zmieniasz pogodę\n");
	strcat(Str,"{FFFF00}/mgivecash [ID] [ILOSC] {FFFFFF}- Dajesz gotówke graczowi\n");
	strcat(Str,"{FFFF00}/mann [CZAS] [TEXT] {FFFFFF}- Piszesz na środku ekranu\n");
	strcat(Str,"{FFFF00}/mczysc {FFFFFF}- Czyscisz czat\n");
	strcat(Str,"{FFFF00}/mfreeze [ID] {FFFFFF}- Zamrażasz gracza\n");
	strcat(Str,"{FFFF00}/munfreeze [ID] {FFFFFF}- Odmrażasz gracza\n");
	strcat(Str,"{FFFF00}/mwarn [ID] [POWOD] {FFFFFF}- Dajesz warna graczowi\n");
	strcat(Str,"{FFFF00}/munwarn [ID] {FFFFFF}- Zabierasz warna graczowi\n");
	strcat(Str,"{FFFF00}/mvirtualworld [ID] {FFFFFF}- Zmieniasz graczowi VW\n");
	strcat(Str,"{FFFF00}/mgivescore [ID] [score] {FFFFFF}- Dajesz graczowi score\n");
	strcat(Str,"{FFFF00}/msetscore [ID] [score] {FFFFFF}- Zmieniasz ilość score graczowi\n");
	strcat(Str,"{FFFF00}/mresetscore [ID] {FFFFFF}- Resetujesz score graczowi\n");
	strcat(Str,"{FFFF00}/mdisarm [ID] {FFFFFF}- Rozbrajasz gracza\n");
	strcat(Str,"{FFFF00}/mresetcash [ID] {FFFFFF}- Resetujesz pieniądze graczowi\n");
	strcat(Str,"{FFFF00}/msetcash [ID] [kasa] {FFFFFF}- Ustawiasz pieniądze graczowi\n");
	strcat(Str,"{FFFF00}/mmute [ID] [czas (min)] [powód] {FFFFFF}- Uciszasz gracza\n");
	strcat(Str,"{FFFF00}/munmute [ID] {FFFFFF}- Odciszasz gracza\n");
	strcat(Str,"{FFFF00}/mgivegun [ID] [ID broni] [AMMO] {FFFFFF}- Dajesz broń graczowi\n");
	strcat(Str,"{FFFF00}/mip [ID] {FFFFFF}- Sprawdzasz adres IP gracza\n");
	strcat(Str,"{FFFF00}/mwersja [ID] {FFFFFF}- Sprawdzasz wersje SA-MP gracza\n");
	strcat(Str,"{FFFF00}/mincar [ID] {FFFFFF}- Sprawdzasz informacje o pojezdzie gracza\n");
	strcat(Str,"{FFFF00}/mrfv [ID] {FFFFFF}- Wyrzucasz gracza z pojazdu\n");
	strcat(Str,"{FFFF00}/mkill [ID] {FFFFFF}- Zabijasz gracza\n");
	strcat(Str,"{FFFF00}/mnetstats [ID] {FFFFFF}- Statystyki połączenia serwera\n");
	strcat(Str,"{FFFF00}/mjetpack [ID] {FFFFFF}- Dajesz jetpacka\n");
	strcat(Str,"{FFFF00}/mvehgod [ID] {FFFFFF}- Dajesz niezniszczalny pojazd\n");
	strcat(Str,"{FFFF00}/mdestroyveh [ID]{FFFFFF}- Rozwalasz pojazd\n");
	strcat(Str,"{FFFF00}/mslap [ID] [HP 1-10]{FFFFFF}- Uderzasz gracza\n");
	strcat(Str,"{FFFF00}/mrepairveh [ID]{FFFFFF}- Naprawiasz pojazd\n\n");
	
	strcat(Str,"{B4B5B7}Moderator Poziomu 2 :\n\n");
	
	strcat(Str,"{FFFF00}/mgodall {FFFFFF}- Dajesz nieśmiertelność wszystkim graczom\n");
	strcat(Str,"{FFFF00}/marmorall {FFFFFF}- Dajesz armor wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mhealall {FFFFFF}- Uzdrawiasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mexplode [ID] {FFFFFF}- Wysadzasz gracza\n");
	strcat(Str,"{FFFF00}/mexplodeall {FFFFFF}- Wysadzasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mgivecashall {FFFFFF}- Dajesz gotówke wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mfreezeall {FFFFFF}- Zamrażasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/munfreezeall {FFFFFF}- Odmrażasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mvirtualworldall {FFFFFF}- Zmieniasz wszystkim graczom VW\n");
	strcat(Str,"{FFFF00}/mgivescoreall {FFFFFF}- Dajesz score wszystkim graczom\n");
	strcat(Str,"{FFFF00}/msetscoreall [score] {FFFFFF}- Zmieniasz ilość score wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mresetscoreall {FFFFFF}- Resetujesz score wszystkim graczomm\n");
	strcat(Str,"{FFFF00}/mresetcashall {FFFFFF}- Resetujesz pieniądze wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mdisarmall {FFFFFF}- Rozbrajasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mkillall {FFFFFF}- Zabijasz wszystkich graczy w wyjątkiem Moderatorów/Administratorów\n");
	ShowPlayerDialog(playerid, DIALOG_MCMD, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Moderatora 1/2 {63AFF0}(Moderator v 1.4 by Czechu)", Str, "Dalej", "Wyjdź");
	return 1;
}

CMD:dajmoda(playerid, params[])
{
	new str[128];
	new gracz;
	new Poziom;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Administratorem!");

	if(sscanf(params, "dd", gracz, Poziom)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /dajmoda [ID] [POZIOM 1-2]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");
	
	if(Poziom < 1 || Poziom > 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędny poziom ! [1-2]");
	
	if(Mod[gracz] == Poziom) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz jest już moderatorem tego poziomu");

	Mod[gracz] = Poziom;
	dini_IntSet(MG, PlayerName(gracz), Poziom);
	
	format(str, sizeof(str), "[INFO] Otrzymałeś Moderatora poziomu %d od Admina %s (ID: %d)", Poziom, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:wezmoda(playerid, params[])
{
	new str[128];
	new gracz;
	new Powod[128];

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Administratorem!");

	if(sscanf(params, "ds", gracz, Powod)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /wezmoda [ID] [POWÓD]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");
	
	if(Mod[gracz] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest Moderatorem");

	Mod[gracz] = 0;
	dini_Unset(MG, PlayerName(gracz));

	format(str, sizeof(str), "[INFO] Admin %s (ID: %d) zabrał ci moderatora z powodu : %s", PlayerName(playerid), playerid, Powod);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}


CMD:mloguj(playerid, params[])
{
	new str[128];
	new gracz;
	new Poziom;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Administratorem!");

	if(sscanf(params, "dd", gracz, Poziom)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mloguj [ID] [POZIOM 1-2]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");
	
	if(Poziom < 1 || Poziom > 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędny poziom ! [1-2]");

	Mod[gracz] = Poziom;

	format(str, sizeof(str), "[INFO] %s (ID: %d) Został(a) zalogowany(a) na Moderatora poziomu %d do czasu wylogowania się przez Admina %s (ID: %d)", PlayerName(gracz), gracz, Poziom, PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zostałeś(aś) zalogowany na Moderatora poziomu %d do czasu wylogowania się przez Admina %s (ID: %d)", Poziom, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zalogowałeś(aś) %s (ID: %d) na Moderatora poziomu %d do czasu wylogowania.", PlayerName(gracz), gracz, PlayerName(playerid), playerid, Mod[playerid]);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mwyloguj(playerid, params[])
{
	new str[128];
	new gracz;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Administratorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /moff [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(!Mod[gracz]) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest Moderatorem");

	Mod[gracz] = 0;

	format(str, sizeof(str), "[INFO] Admin %s (ID: %d) wylogował(a) cię z Moderatora!", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Wylogowałeś(aś) %s (ID: %d) z Moderatora!", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgod(playerid, params[])
{
	new gracz;
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mgod [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerHealth(gracz, 9999999);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) nieśmiertelność %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzymałeś(aś) nieśmiertelność od Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mgodall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerHealth(x, 9999999);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Dałeś(aś) nieśmiertelność wszystkim graczom!");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %s) Dał(a) nieśmiertelność wszystkim graczom!", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mtp(playerid, params[])
{
	new str[256];
	new Float:pX, Float:pY, Float:pZ;
	new giveplayerid, teleid;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "dd", giveplayerid, teleid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mtp [ID] [ID2]");

	if(IsPlayerConnected(giveplayerid) && IsPlayerConnected(teleid))
	{
		GetPlayerPos(teleid, pX,pY,pZ);
		new Interior;
		Interior = GetPlayerInterior(teleid);
		SetPlayerInterior(giveplayerid, Interior);
		SetPlayerPos(giveplayerid, pX,pY,pZ);

		format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Teleportował(a) %s (ID: %d) do %s (ID: %d)", PlayerName(playerid), playerid, PlayerName(giveplayerid), giveplayerid, PlayerName(teleid), teleid);
		SendClientMessageToAll(COLOR_LEMON, str);
	}

	if(!IsPlayerConnected(giveplayerid)) {
		format(str, sizeof(str), "[ERROR] %d Nie jest podłączony", giveplayerid);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
	}
	if(!IsPlayerConnected(teleid)) {
		format(str, sizeof(str), "[ERROR] %d Nie jest podłączony", teleid);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
	}
	return 1;
}

CMD:marmor(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /marmor [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerArmour(gracz, 100);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) pancerz %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) ci pancerz", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:marmorall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerArmour(x, 100);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Dałeś(aś) pancerz wszystkim graczom!");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) pancerz wszystkim graczom", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mheal(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mheal [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerHealth(gracz, 100);

	format(str, sizeof(str), "[M-INFO] Uzdrowiłeś(aś) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ucdrowił(a) cię", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mhealall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerHealth(x, 100);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Uzdrowiłeś(aś) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Uzdrowił(a) wszystkich graczy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mexplode(playerid, params[])
{
	new Float:x,Float:y,Float:z;
	new str[128];
	new gracz;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mexplode [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	GetPlayerPos(gracz, x, y, z);

	CreateExplosion( x, y, z, 2, 50);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) wysadził(a) cię w powietrze!", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Wysadziłeś(aś) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mexplodeall(playerid, params[])
{
	new Float:x,Float:y,Float:z;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new i = 0 ; i < MAX_GRACZY ; i++)
	{
		GetPlayerPos(i, x, y, z);
		CreateExplosion(x, y, z, 2, 10.0);
	}
	return 1;
}

CMD:msettime(playerid, params[])
{
	new str[64];
	new czas;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", czas)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /msettime [godzina]");

	if(czas > 24 || czas < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędna godzina! [0-24]");

	SetWorldTime(czas);

	format(str, sizeof(str), "[M-INFO] Zmieniłeś(aś) czas na %02d:00", czas);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmienił(a) czas na %02d:00", PlayerName(playerid), playerid, czas);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mweather(playerid, params[])
{
	new str[128];
	new weather;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", weather)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mweather [pogoda]");

	if(weather > 46 || weather < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędna godzina! [0-24]");

	SetWeather(weather);

	format(str, sizeof(str), "[M-INFO] Zmieniłeś(aś) pogode na %02d", weather);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmienił(a)pogode na %02d", PlayerName(playerid), playerid, weather);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mgivecash(playerid, params[])
{
	new gracz, kasa, str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "dd", gracz, kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mgivecash [ID] [ILOSC]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(kasa > 9999999 || kasa < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędna ilosć gotówki! [0-9999999]");

	GivePlayerMoney(gracz, kasa);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) graczowi %s (ID: %d) %d gotówki", PlayerName(gracz), gracz, kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzymałeś(aś) %d gotówki od Moderatora %s (ID: %d)", kasa, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mgivecashall(playerid, params[])
{
	new kasa, str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "d", kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mgivecashall [ILOSC]");

	if(kasa > 9999999 || kasa < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędna ilosć gotówki! [0-9999999]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		GivePlayerMoney(x, kasa);
	}
	format(str, sizeof(str), "[M-INFO] Dałeś(aś) wszystkim graczom %s gotówki", kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) wszystkim %d gotówki", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mann(playerid, params[])
{
	new msg[128], sek2, str[256];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "ds[128]", sek2, msg)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mann [czas] [tresc]");

	if(sek2 == 0)
	{
		SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mann [czas] [tresc]");
		return 1;
	}
	format(str,sizeof(str),"~w~(Mod %s) %s",PlayerName(playerid), msg);
	sek2 = sek2 * 1000;
	GameTextForAll(str,sek2,3);
	return 1;
}

CMD:monline(playerid, params[])
{
	new Name[MAX_PLAYER_NAME], String[128], Count;
	for(new i, mp = MAX_GRACZY; i < mp; i++)
	{
		if(IsPlayerConnected(i) && Mod[i])
		{
			GetPlayerName(i, Name, MAX_PLAYER_NAME);

			format(String, sizeof(String), "{81CFAB}%s\n{81CFAB}%s {AAFFCC}(ID: %d) {FFFFFF}| {DEAD43}Poziom : {209CF2}%d", String, Name, i, Mod[i]);
			Count++;
		}
	}
	if(Count)
		ShowPlayerDialog(playerid, DIALOG_MONL, DIALOG_STYLE_MSGBOX, "{AAFFCC}Moderatorzy Online:", String, "Ok", "");
	else
		ShowPlayerDialog(playerid, DIALOG_MONL, DIALOG_STYLE_MSGBOX, "{AAFFCC}Moderatorzy Online:", "{FAEAA9}Obecnie nie ma Żadnego Moderatora Online ...", "Ok", "");
	return 1;
}

CMD:mczysc(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	for(new i = 0 ; i <= 45 ; i++)
	{
		SendClientMessageToAll(0x00CC00AA, " ");
	}
	format(str, sizeof(str), "[INFO] Czat został wyszyszczony przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:mfreeze(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mfreeze [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	TogglePlayerControllable(gracz, 0);

	format(str, sizeof(str), "[M-INFO] Zamroziłeś(aś) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zostałeś(aś) zamrożony(a) przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:munfreeze(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /munfreeze [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	TogglePlayerControllable(gracz, 1);

	format(str, sizeof(str), "[M-INFO] Odmroziłeś(aś) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zostałeś(aś) odmrożony(a) przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mfreezeall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			TogglePlayerControllable(x, 0);
		}
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zamroziłeś(aś) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Wszyscy zostali zamrożeni przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:munfreezeall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			TogglePlayerControllable(x, 1);
		}
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Odmroziłeś(aś) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Wszyscy zostali odmrożeni przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:mwarn(playerid, params[])
{
	new str[128];
	new gracz;
	new reason[64];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "ds[64]", gracz, reason)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mwarn [ID] [POWÓD]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(Warn[gracz] == 0)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzymałeś(aś) ostrzeżenie od Moderatora %s (ID: %d) powód : %s (1/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		return 1;
	}

	if(Warn[gracz] == 1)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzymałeś(aś) ostrzeżenie od Moderatora %s (ID: %d) powód : %s (2/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		return 1;
	}
	if(Warn[gracz] == 2)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzymałeś(aś) ostrzeżenie od Moderatora %s (ID: %d) powód : %s (3/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		format(str, sizeof(str), "[INFO] %s (ID: %d) Został(a) wyrzucony(a), Powód: Ostrzeżenia (3/3)", PlayerName(gracz), gracz);
		SendClientMessageToAll(COLOR_LEMON, str);
		SendClientMessage(gracz, COLOR_LEMON, "Zostałeś(aś) wyrzucony(a) z serwera z powodu: Ostrzeżenia (3/3)");
		Kick(gracz);
		return 1;
	}
	return 1;
}

CMD:munwarn(playerid, params[])
{
	new gracz;
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d]", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /munwarn [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(Warn[gracz] == 0)
	{
		format(str, sizeof(str), "[ERROR] %s (ID: %d) Nie ma żadnego ostrzeżenia", PlayerName(gracz), gracz);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
		return 1;
	}
	Warn[gracz] --;

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zabrał(a) ci ostrzeżenie", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zabrałeś(aś) ostrzeżenie %s (ID: %d) ", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mvirtualworld(playerid, params[])
{
	new str[128];
	new gracz;
	new world;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "dd", gracz, world)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mvirtualworld [ID] [VW]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerVirtualWorld(gracz, world);

	format(str, sizeof(str), "[M-INFO] Zmieniłeś(aś) WietualWorld %s (ID: %d) na %d", PlayerName(gracz), gracz, world);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmienił(a) ci WirtualWorld na %d", PlayerName(playerid), playerid, world);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mvirtualworldall(playerid, params[])
{
	new str[128];
	new world;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "d", world)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mvirtualworldall [VW]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerVirtualWorld(x, world);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmienił(a) WirtualWorld wszystkim graczom na %d", PlayerName(playerid), playerid, world);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieniłeś(aś) WietualWorld wszystkim graczom na %d", world);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivescore(playerid, params[])
{
	new str[128];
	new gracz;
	new score;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "dd", gracz, score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mgivescore [ID] [score]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerScore(gracz, GetPlayerScore(gracz) + score);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) ci %d respektu (score)", PlayerName(playerid), playerid, score);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) %s (ID: %d) %d respektu (score)", PlayerName(gracz), gracz, score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivescoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "d", score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mgivescoreall [score]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, GetPlayerScore(x) + score);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) wszystkim %d respektu (score)", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) wszystkim graczom %d respektu (score)", score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetscore(playerid, params[])
{
	new str[128];
	new gracz;
	new score;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "dd", gracz, score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /msetscore [ID] [score]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerScore(gracz, score);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmienił(a) ci ilość respektu (score) na %d", PlayerName(playerid), playerid, score);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieniłeś(aś) %s (ID: %d) ilość respektu (score) na %d", PlayerName(gracz), gracz, score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetscoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "d", score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /msetscoreall [score]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, score);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmienił(a) ilość score wszystkim graczom na %d", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieniłeś(aś) wszystkim graczom respekt (score) na %d", score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetscore(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mresetscore [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerScore(gracz, 0);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrestartował(a) ci respekt (score)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zresetowałeś(aś) score %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetscoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, 0);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetował(a) wszystkim score", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zresetowałeś(aś) wszystkim score");
	return 1;
}

CMD:mdisarm(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mdisarm [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	ResetPlayerWeapons(gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozbroił(a) cię", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Rozbroiłeś(aś) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mdisarmall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			ResetPlayerWeapons(x);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozbroił(a) wszystkich", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Rozbroiłeś(aś) wszystkich graczy");
	return 1;
}

CMD:mresetcash(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mresetcash [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	ResetPlayerMoney(gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetował(a) ci pieniądze", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zresetowałeś(aś) pieniądze  %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetcashall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			ResetPlayerMoney(x);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetował(a) wszystkim pieniądze", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zresetowałeś(aś) wszystkim pieniądze");
	return 1;
}

CMD:msetcash(playerid, params[])
{
	new str[128];
	new gracz;
	new kasa;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "dd", gracz, kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /msetcash [ID] [kasa]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerMoney(gracz, kasa);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ustawił(a) ci kase na %d", PlayerName(playerid), playerid, kasa);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Ustawileś(aś) kase %s (ID: %d) na %d", PlayerName(gracz), gracz, kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetcashall(playerid, params[])
{
	new str[128];
	new kasa;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "d", kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /msetcashall [kasa]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerMoney(x, kasa);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmienił(a) wszystkim ilość kasy na %d", PlayerName(playerid), playerid, kasa);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Ustawileś(aś) wszystkim kase na %d", kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mmute(playerid, params[])
{
	new str[128];
	new gracz;
	new mtime;
	new reason[64];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "ids[64]", gracz, mtime, reason)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mmute [ID] [czas (min) [powód]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	Muted[gracz] = 1;
	KillTimer(MuteTimer[gracz]);
	MuteTimer[gracz] = SetTimerEx("UnmutePlayer",mtime*60000,0,"i", gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) uciszył(a) cię na %d min, powód: %s", PlayerName(playerid), playerid, mtime, reason);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Uciszyłeś(aś) %s (ID: %d) na %d min, powód: %s", PlayerName(gracz), gracz, mtime, reason);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:munmute(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /munmute [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	Muted[gracz] = 0;
	KillTimer(MuteTimer[gracz]);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) odciszył(a) cię", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Odciszyłeś(aś) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivegun(playerid, params[])
{
	new str[128];
	new gracz;
	new nbron[32];
	new bron;
	new ammo;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "idd", gracz, bron, ammo)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mgivegun [ID] [ID broni] [AMMO]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(bron > 46 || bron < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędne ID broni [1-46]");

	if(ammo > 99999999 || ammo < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędna ilość amuicji [1-99999999]");

	GivePlayerWeapon(gracz, bron, ammo);

	GetWeaponName(bron, nbron, 32);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) ci broń %s (ID: %d) i %d amunicji", PlayerName(playerid), playerid, nbron, bron, ammo);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) broń %s (ID: %d) i %d amunicji %s (ID: %d)", nbron, bron, ammo, PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivegunall(playerid, params[])
{
	new str[256];
	new nbron[32];
	new bron;
	new ammo;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params,"dd",bron, ammo)) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Użyj /mgivegunall [ID broni] [AMMO]!");

	if(bron > 46 || bron < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędne ID broni [1-46]");

	if(ammo > 99999999 || ammo < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędna ilość amuicji [1-99999999]");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		GivePlayerWeapon(x, bron, ammo);
	}
	GetWeaponName(bron, nbron, 32);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) wszystkim broń %s (ID: %d) i %d amunicji", PlayerName(playerid), playerid, nbron, bron, ammo);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) wszystkim broń %s (ID: %d) i %d amunicji", nbron, bron, ammo);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mip(playerid, params[])
{
	new str[128];
	new gracz;
	new adips[16];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mip [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	GetPlayerIp(playerid, adips, sizeof(adips));

	format(str, sizeof(str), "[M-INFO] Adres IP %s (ID: %d) to %d", PlayerName(gracz), gracz, adips);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mwersja(playerid, params[])
{
	new str[128];
	new str2[216];
	new gracz;

	GetPlayerVersion(playerid, str2, sizeof(str2));

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mwersja [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");


	format(str, sizeof(str), "[M-INFO] Wersja SA-MP'a %s (ID: %d) to SA-MP: %s", PlayerName(gracz), gracz, str2);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mincar(playerid, params[])
{
	new str[128];
	new gracz;
	new Float:health;
	new veah;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mincar [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest w żadnym pojeździe!");

	veah = GetPlayerVehicleID(gracz);
	GetVehicleHealth(veah, health);

	format(str, sizeof(str), "[M-INFO] %s (ID: %d), w pojezdzie %s, (ID: %d), HP pojazdu %f, Wirtual World : %d", PlayerName(gracz), gracz, carname[GetVehicleModel(GetPlayerVehicleID(gracz)) - 400], veah, health, GetVehicleVirtualWorld(GetPlayerVehicleID(gracz)));
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mrfv(playerid, params[])
{
	new str[128];
	new gracz;
	new veah;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mrfv [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest w żadnym pojeździe!");

	veah = GetPlayerVehicleID(gracz);
	RemovePlayerFromVehicle(gracz);

	format(str, sizeof(str), "[M-INFO] Wyrzuciłeś(aś) %s (ID %d) z pojazdu %s, (ID: %d)", PlayerName(gracz), gracz, carname[GetVehicleModel(GetPlayerVehicleID(gracz)) - 400], veah);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zostałeś(aś) wyrzucony(a) z pojazdu przez moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrfvall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		RemovePlayerFromVehicle(x);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) wyrzucił(a) wszystkich graczy z pojazdów", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Wyrzuciłeś(aś) wszystkich graczy z pojazdów");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mcrash(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mcrash [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	SetPlayerSkin(gracz, 555);

	format(str, sizeof(str), "[M-INFO] Wywołałeś(aś) Crash GTA, %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mkill(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mkill [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie możesz zabić modaratora poziomu 2!");
	
	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie możesz zabić Administratora!");
	
	SetPlayerHealth(gracz, 0);

	format(str, sizeof(str), "[M-INFO] Zabiłeś(aś) gracza %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zostałeś(aś) zabity(a) przez moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mkillall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		if(Mod[x] < 1 && !IsPlayerAdmin(x))
		{
		SetPlayerHealth(x, 0);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zabił(a) wszystkich graczy z wyjątkiem moderatorów/Administratorów ", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zabiłeś(aś) wszystkich graczy z wyjątkiem Moderatorów/Administratorów");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mjetpack(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mjetpack [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

    SetPlayerSpecialAction(gracz, SPECIAL_ACTION_USEJETPACK);
    
	format(str, sizeof(str), "[M-INFO] Dałeś(aś) jetpack'a graczowi %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzymałeś(aś) jetpack'a od Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mjetpackall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
 		SetPlayerSpecialAction(x, SPECIAL_ACTION_USEJETPACK);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) dał(a) wszystkim jetpack", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Dałeś(aś) wszystkim jetpacka ;O");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mkick(playerid, params[])
{
	new str[128], gracz, Powod[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "iu", gracz, Powod)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mkick [ID] [POWÓD]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");
	
	if(gracz == playerid) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie możesz wyrzucić samego siebie!");

	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie możesz wyrzucić modaratora poziomu 2!");

	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie możesz wyrzucić Administratora!");


	format(str, sizeof(str), "[M-INFO] Wyrzuciłeś %s (ID: %d) z pwowodu : %s", PlayerName(gracz), gracz, Powod);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zostałeś(aś) wyrzucony(a) przez Moderatora %s (ID: %d), z powodu: %s", PlayerName(playerid), playerid, Powod);
	SendClientMessage(gracz, COLOR_LEMON, str);
	
	format(str, sizeof(str), "[INFO] %s (ID: %d) został(a) wyrzucony(a) przez Moderatora %s (ID: %d) z powodu: %s", PlayerName(gracz), gracz, PlayerName(playerid), playerid, Powod);
	SendClientMessageToAll(COLOR_LEMON, str);

	Kick(gracz);
	return 1;
}

CMD:mnetstats(playerid, params[])
{
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	gNetStatsPlayerId = playerid;
	NetStatsDisplay();
	gNetStatsTimerId = SetTimer("NetStatsDisplay", 2000, true);

	return 1;
}

CMD:mpm(playerid, params[])
{
	new MSG[128];
	new str[128];
	
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "s[128]", MSG)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mpm [TREŚĆ]");

    format(str, sizeof(str), "|MOD-CHAT| (%s ID: %d| POZ: %d): %s",PlayerName(playerid), playerid, Mod[playerid], MSG);
	SendClientMessageToMod(0x24FF0AB9, str);
	//0x9E3DFFAA
	return 1;
}

CMD:mvehgod(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mvehgod [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w żadnym pojeździe!");
    
    SetVehicleHealth(GetPlayerVehicleID(gracz), 9999999);

	format(str, sizeof(str), "[M-INFO] Zrobiłeś(aś) graczowi %s (ID: %d) niezniszczalny pojazd", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrobił(a) ci niezniszczalny pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mvehgodall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		if(IsPlayerConnected(x))
		{
			if(IsPlayerInAnyVehicle(x))
			{
				SetVehicleHealth(GetPlayerVehicleID(x), 9999999);
			}
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrobił(a) wszystkim niezniszczalne pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zrobiłeś(aś) wszystkim niezniszczalne pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mdestroyveh(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mdestroyveh [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w żadnym pojeździe!");

    SetVehicleHealth(GetPlayerVehicleID(gracz), 0);

	format(str, sizeof(str), "[M-INFO] Rozwaliłeś(aś) graczowi %s (ID: %d) pojazd", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozwalił(a) ci pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mdestroyvehall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		if(IsPlayerConnected(x))
		{
			if(IsPlayerInAnyVehicle(x))
			{
				SetVehicleHealth(GetPlayerVehicleID(x), 0);
			}
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozwalił wszystkim pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Rozwaliłeś(aś) wszystkim pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mslap(playerid, params[])
{
	new str[128];
	new gracz;
	new Float:HPY;
	new wezHPY;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "ii", gracz, wezHPY)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mslap [ID] [HP 1-10]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");
	
	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie możesz uderzyć modaratora poziomu 2!");

	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie możesz uderzyć Administratora!");

	if(wezHPY < 1 || wezHPY > 10) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Błędna ilość HP ![1-10]");

    GetPlayerHealth(gracz, HPY);
	SetPlayerHealth(gracz, floatround(HPY)-wezHPY);

	format(str, sizeof(str), "[M-INFO] Uderzyłeś %s (ID: %d) zadając %d obrażeń", PlayerName(gracz), gracz, wezHPY);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) uderzył(a) cię, zadając %d obrażeń", PlayerName(playerid), playerid, wezHPY);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrepairveh(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mrepairveh [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest podłączony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w żadnym pojeździe!");

    new POJ = GetPlayerVehicleID(gracz);
    RepairVehicle(POJ);
    
	format(str, sizeof(str), "[M-INFO] Naprawiłeś(aś) pojazd graczowi %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) naprawił(a) ci pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrepairvehall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteś Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		if(IsPlayerConnected(x))
		{
			if(IsPlayerInAnyVehicle(x))
			{
				new POJ = GetPlayerVehicleID(x);
				RepairVehicle(POJ);
			}
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) naprawił wszystkim pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Naprawiłes wszystkim pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgravity(playerid, params[])
{
	new str[128];
	new gravity;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteś Moderatorem poziomu 2!");

	if(sscanf(params, "i", gravity)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Użyj /mgravity [grawitacja] |Domyślnie - 0.008|");

	SetGravity(gravity);

	format(str, sizeof(str), "[M-INFO] Ustawiłeś(aś) grawitacje na %d", gravity);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ustawił grawitacje na %d", PlayerName(playerid), playerid, gravity);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	for(new i = strlen(inputtext) - 1; i >= 0; i--)
		if(inputtext[i] == '%')
			inputtext[i] = '#';

	if(dialogid == DIALOG_NETSTATS) {
		KillTimer(gNetStatsTimerId);
		gNetStatsPlayerId = INVALID_PLAYER_ID;
		return 1;
	}


    if(dialogid == DIALOG_MCMD)
	{
		if(response)//co ma sie dziać po wybiraniu pierwszej opcji (DALEJ)
		{
  			new Str[1024];

			strcat(Str,"{FFFF00}/msetcashall [kasa] {FFFFFF}- Ustawiasz pieniądze wszystkim graczom\n");
			strcat(Str,"{FFFF00}/mgivegunall [ID broni] [AMMO] {FFFFFF}- Dajesz broń wszystkim graczom\n");
            strcat(Str,"{FFFF00}/mrfvall [ID] {FFFFFF}- Wyrzucasz wszystkich graczy z pojazdu\n");
			strcat(Str,"{FFFF00}/mkick [ID] [Powód] {FFFFFF}- Wyrzucasz gracza\n");
			strcat(Str,"{FFFF00}/mvehgodall {FFFFFF}- Dajesz wszystkim niezniszczalne pojazdy\n");
			strcat(Str,"{FFFF00}/mcrash [ID] {FFFFFF}- Wywołujesz Crash'a graczowi\n");
			strcat(Str,"{FFFF00}/mjetpackall {FFFFFF}- Dajesz jetpack wszystkim\n");
			strcat(Str,"{FFFF00}/mdestroyvehall {FFFFFF}- Rozwalasz wszystkim pojazdy\n");
			strcat(Str,"{FFFF00}/mrepairvehall {FFFFFF}- Naprawiasz wszystkim pojazdy\n");
			strcat(Str,"{FFFF00}/mgravity [gravitacja] {FFFFFF}- Ustawiasz grawitacje\n");
		    ShowPlayerDialog(playerid, DIALOG_MCMD2, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Moderatora 2/2 {63AFF0}(Moderator v 1.4 by Czechu)", Str, "Wyjdź", "");
		}
		else if(!response)//co sie ma dziac po wybraniu drugiej opcji (WYJDŹ)
		{
			//cuś tu powinno być co nie :) ?
		}
	}
	return 0;
}

forward NetStatsDisplay();
public NetStatsDisplay()
{
	new netstats_str[2048+1];
	GetNetworkStats(netstats_str, 2048);
	ShowPlayerDialog(gNetStatsPlayerId, DIALOG_NETSTATS, DIALOG_STYLE_MSGBOX, "Net STATS", netstats_str, "Ok", "");
}

stock SetPlayerMoney(playerid, cash)
{
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, cash);
}

stock SendClientMessageToMod(color, msg[]){
	for(new x=0; x<MAX_PLAYERS; x++) {
		if(IsPlayerConnected(x)) {
			if(Mod[x] >= 1) {
				SendClientMessage(x, color, msg);
			}
		}
	}
	return 1;
}

PlayerName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

forward UnmutePlayer(playerid);
public UnmutePlayer(playerid)
{
	Muted[playerid] = 0;
	KillTimer(MuteTimer[playerid]);
	SendClientMessage(playerid,COLOR_LEMON,"[INFO] Twoja kara wyciszenia minęła!");
	return 1;
}
// 		_________________________________________________________
// 	 	|                                                       |
//  	|               KONIEC-KONIEC-KONIEC-KONIEC             |
//		|               KONIEC-KONIEC-KONIEC-KONIEC             |
//		|               KONIEC-KONIEC-KONIEC-KONIEC             |
//  	|_______________________________________________________|

