/*  _________________________________________________________
	|                                                       |
	|                  Moderator V 1.4                      |
	|                          BY                           |
	|                       Czechu                          |
	|                                                       |
	|_______________________________________________________|


	Dzi�ki �e pobra�e�(a�) m�j skrypt "Moderator v 1.4 :)
	Mam nadziej� �e bedzie ci dobrze s�u�y�.
	Zezwalam na : edytowanie wed�ug w�asnych potrzeb, wrzucenie do w�asnej mapki (ale prosz� oto aby
	komend� /mabout takze skopiowa� :)
	Zabraniam : wystawiania na inne fora, zmiany autora

	Zmiany v 1.4 :

	- Zmieniono system logowania na moderatora, teraz wszystko dzieje si�
	automatycznie po wej�ciu gracza,
	- Dodano rangi moderatora, 1 - najni�sza, 2- najwy�sza,
	- Dodano kilkana�cie komend, w tym dodawanie oraz usuwanie moderator�w,
	- Logowanie gracza na administratora do czasu wylogowania,

*/
//---------------------INCLUDE--------------------------------------------------
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <dini>
//---------------------DEFINICJE------------------------------------------------
#define MG "Mod/mody.ini" //Lokalizacja pliku z nazwami oraz poziomami Mod�w
#define WARNY "Mod/warny.ini" //lokalizacja pliku z warnami graczy
#define MAX_GRACZY 20 //Maksymalna ilos� graczy na serwerze
#define DIALOG_MADM 200 //ID dialogu komend Admina (Moderator)
#define DIALOG_MCMD 201 //ID dialogu komend Moderatora
#define DIALOG_MONL 202 //ID dialogu komendy /monline
#define DIALOG_MABOUT 203 //ID dialogu komendy /mabout
#define DIALOG_NETSTATS 204 //ID dialogu komendy /netstats
#define DIALOG_MCMD2 205 //ID dialogu komend Moderatora cz�c 2
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
	"Bobcat","MrWhoopee","BFInjection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Busa","Czo�g",
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
	#emit load.pri d //�adowanie zmiennej "d" do pami�ci (bazowane na Asemblerze)
	#emit stor.pri d //zapisywanie zmiennej "d" do pami�ci (bazowane na Asemblerze)
	#pragma unused amx
}

main()
{
	AntyDeAMX();
	print("\n----------------------------------");
	print(" Moderator v1.4 by Czechu za�adowany!");
	print("----------------------------------\n");
}

public OnFilterScriptInit()
{

	print("\n----------------------------------");
	print(" Moderator v1.4 by Czechu za�adowany!");
	print("----------------------------------\n");
	AntyDeAMX();
	if(!dini_Exists(MG)) dini_Create(MG);
	if(!dini_Exists(WARNY)) dini_Create(WARNY);

	return 1;
}

public OnFilterScriptExit()
{
	print("\n-----------------------------------");
	print(" Moderator v1.4 by Czechu nieza�adowany!");
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
		format(str, sizeof(str), "[M-INFO] Witaj %s, tw�j poziom Moderatora to : Moderator poziomu %d", PlayerName(playerid), Mod[playerid]);
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
		SendClientMessage(playerid,0xFF0000FF,"{24FF0A}[ERROR] {FFFFFF}Nie mo�esz pisa�, gdy jeste� wyciszony(a)!");
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
		SendClientMessage(playerid, COLOR_LEMON, "[INFO] Nie masz �adnego ostrze�enia, tak trzymaj ! :)");
		return 1;
	}

	format(str, sizeof(str), "[INFO] Twoja ilo�� ostrze�e�: %d", Warn[playerid]);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mabout(playerid, params[])
{
	new Str[256];

	strcat(Str,"Autor : Czechu \n");
	strcat(Str,"Edited by: (tw�j nick) \n");
	strcat(Str,"Wersja : 1.4\n");
	strcat(Str,"Ostatnia Aktualizacja: : 27.10.2013|16:54\n");
	strcat(Str,"W razie pyta�, pisz GG: 6445926\n");
	ShowPlayerDialog(playerid, DIALOG_MABOUT, DIALOG_STYLE_MSGBOX, "{AAFFCC}Informacje",Str,"Wyjd�", "");
	return 1;
}

CMD:madmin(playerid, params[])
{
	new Str[512];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Administratorem!");

    strcat(Str,"{FFFF00}/dajmoda [ID] [POZIOM 1-2] {FFFFFF}- Dajesz graczowi moda\n");
    strcat(Str,"{FFFF00}/wezmoda [ID] [POW�D] {FFFFFF}- Zabierasz graczowi moda\n");
	strcat(Str,"{FFFF00}/mloguj [ID] [POZIOM 1-2] {FFFFFF}- Logujesz gracza na Moderatora, do czasu wyj�cia z serwera\n");
	strcat(Str,"{FFFF00}/mwyloguj [ID] {FFFFFF}- Wylogowujesz gracza z Moderatora\n");
	ShowPlayerDialog(playerid, DIALOG_MADM, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Administratora {63AFF0}(Moderator v 1.4 by Czechu)",Str,"Wyjd�", "");
	return 1;
}

CMD:mcmd(playerid, params[])
{
	new Str[3096];
	
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	strcat(Str,"{00A600}Moderator Poziomu 1 :\n\n");
	strcat(Str,"{FFFF00}/mgod [ID] {FFFFFF}- Dajesz nie�miertelno�� graczowi\n");
	strcat(Str,"{FFFF00}/mtp [ID] [ID2] {FFFFFF}- Teleportujesz [ID] do [ID2]\n");
	strcat(Str,"{FFFF00}/marmor [ID] {FFFFFF}- Dajesz armor graczowi\n");
	strcat(Str,"{FFFF00}/mheal [ID] {FFFFFF}- Uzdrawiasz danego gracza\n");
	strcat(Str,"{FFFF00}/msettime [GODZINA] {FFFFFF}- Zmieniasz czas\n");
	strcat(Str,"{FFFF00}/mweather [POGODA] {FFFFFF}- Zmieniasz pogod�\n");
	strcat(Str,"{FFFF00}/mgivecash [ID] [ILOSC] {FFFFFF}- Dajesz got�wke graczowi\n");
	strcat(Str,"{FFFF00}/mann [CZAS] [TEXT] {FFFFFF}- Piszesz na �rodku ekranu\n");
	strcat(Str,"{FFFF00}/mczysc {FFFFFF}- Czyscisz czat\n");
	strcat(Str,"{FFFF00}/mfreeze [ID] {FFFFFF}- Zamra�asz gracza\n");
	strcat(Str,"{FFFF00}/munfreeze [ID] {FFFFFF}- Odmra�asz gracza\n");
	strcat(Str,"{FFFF00}/mwarn [ID] [POWOD] {FFFFFF}- Dajesz warna graczowi\n");
	strcat(Str,"{FFFF00}/munwarn [ID] {FFFFFF}- Zabierasz warna graczowi\n");
	strcat(Str,"{FFFF00}/mvirtualworld [ID] {FFFFFF}- Zmieniasz graczowi VW\n");
	strcat(Str,"{FFFF00}/mgivescore [ID] [score] {FFFFFF}- Dajesz graczowi score\n");
	strcat(Str,"{FFFF00}/msetscore [ID] [score] {FFFFFF}- Zmieniasz ilo�� score graczowi\n");
	strcat(Str,"{FFFF00}/mresetscore [ID] {FFFFFF}- Resetujesz score graczowi\n");
	strcat(Str,"{FFFF00}/mdisarm [ID] {FFFFFF}- Rozbrajasz gracza\n");
	strcat(Str,"{FFFF00}/mresetcash [ID] {FFFFFF}- Resetujesz pieni�dze graczowi\n");
	strcat(Str,"{FFFF00}/msetcash [ID] [kasa] {FFFFFF}- Ustawiasz pieni�dze graczowi\n");
	strcat(Str,"{FFFF00}/mmute [ID] [czas (min)] [pow�d] {FFFFFF}- Uciszasz gracza\n");
	strcat(Str,"{FFFF00}/munmute [ID] {FFFFFF}- Odciszasz gracza\n");
	strcat(Str,"{FFFF00}/mgivegun [ID] [ID broni] [AMMO] {FFFFFF}- Dajesz bro� graczowi\n");
	strcat(Str,"{FFFF00}/mip [ID] {FFFFFF}- Sprawdzasz adres IP gracza\n");
	strcat(Str,"{FFFF00}/mwersja [ID] {FFFFFF}- Sprawdzasz wersje SA-MP gracza\n");
	strcat(Str,"{FFFF00}/mincar [ID] {FFFFFF}- Sprawdzasz informacje o pojezdzie gracza\n");
	strcat(Str,"{FFFF00}/mrfv [ID] {FFFFFF}- Wyrzucasz gracza z pojazdu\n");
	strcat(Str,"{FFFF00}/mkill [ID] {FFFFFF}- Zabijasz gracza\n");
	strcat(Str,"{FFFF00}/mnetstats [ID] {FFFFFF}- Statystyki po��czenia serwera\n");
	strcat(Str,"{FFFF00}/mjetpack [ID] {FFFFFF}- Dajesz jetpacka\n");
	strcat(Str,"{FFFF00}/mvehgod [ID] {FFFFFF}- Dajesz niezniszczalny pojazd\n");
	strcat(Str,"{FFFF00}/mdestroyveh [ID]{FFFFFF}- Rozwalasz pojazd\n");
	strcat(Str,"{FFFF00}/mslap [ID] [HP 1-10]{FFFFFF}- Uderzasz gracza\n");
	strcat(Str,"{FFFF00}/mrepairveh [ID]{FFFFFF}- Naprawiasz pojazd\n\n");
	
	strcat(Str,"{B4B5B7}Moderator Poziomu 2 :\n\n");
	
	strcat(Str,"{FFFF00}/mgodall {FFFFFF}- Dajesz nie�miertelno�� wszystkim graczom\n");
	strcat(Str,"{FFFF00}/marmorall {FFFFFF}- Dajesz armor wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mhealall {FFFFFF}- Uzdrawiasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mexplode [ID] {FFFFFF}- Wysadzasz gracza\n");
	strcat(Str,"{FFFF00}/mexplodeall {FFFFFF}- Wysadzasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mgivecashall {FFFFFF}- Dajesz got�wke wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mfreezeall {FFFFFF}- Zamra�asz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/munfreezeall {FFFFFF}- Odmra�asz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mvirtualworldall {FFFFFF}- Zmieniasz wszystkim graczom VW\n");
	strcat(Str,"{FFFF00}/mgivescoreall {FFFFFF}- Dajesz score wszystkim graczom\n");
	strcat(Str,"{FFFF00}/msetscoreall [score] {FFFFFF}- Zmieniasz ilo�� score wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mresetscoreall {FFFFFF}- Resetujesz score wszystkim graczomm\n");
	strcat(Str,"{FFFF00}/mresetcashall {FFFFFF}- Resetujesz pieni�dze wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mdisarmall {FFFFFF}- Rozbrajasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mkillall {FFFFFF}- Zabijasz wszystkich graczy w wyj�tkiem Moderator�w/Administrator�w\n");
	ShowPlayerDialog(playerid, DIALOG_MCMD, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Moderatora 1/2 {63AFF0}(Moderator v 1.4 by Czechu)", Str, "Dalej", "Wyjd�");
	return 1;
}

CMD:dajmoda(playerid, params[])
{
	new str[128];
	new gracz;
	new Poziom;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Administratorem!");

	if(sscanf(params, "dd", gracz, Poziom)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /dajmoda [ID] [POZIOM 1-2]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");
	
	if(Poziom < 1 || Poziom > 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dny poziom ! [1-2]");
	
	if(Mod[gracz] == Poziom) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz jest ju� moderatorem tego poziomu");

	Mod[gracz] = Poziom;
	dini_IntSet(MG, PlayerName(gracz), Poziom);
	
	format(str, sizeof(str), "[INFO] Otrzyma�e� Moderatora poziomu %d od Admina %s (ID: %d)", Poziom, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:wezmoda(playerid, params[])
{
	new str[128];
	new gracz;
	new Powod[128];

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Administratorem!");

	if(sscanf(params, "ds", gracz, Powod)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /wezmoda [ID] [POW�D]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");
	
	if(Mod[gracz] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest Moderatorem");

	Mod[gracz] = 0;
	dini_Unset(MG, PlayerName(gracz));

	format(str, sizeof(str), "[INFO] Admin %s (ID: %d) zabra� ci moderatora z powodu : %s", PlayerName(playerid), playerid, Powod);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}


CMD:mloguj(playerid, params[])
{
	new str[128];
	new gracz;
	new Poziom;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Administratorem!");

	if(sscanf(params, "dd", gracz, Poziom)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mloguj [ID] [POZIOM 1-2]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");
	
	if(Poziom < 1 || Poziom > 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dny poziom ! [1-2]");

	Mod[gracz] = Poziom;

	format(str, sizeof(str), "[INFO] %s (ID: %d) Zosta�(a) zalogowany(a) na Moderatora poziomu %d do czasu wylogowania si� przez Admina %s (ID: %d)", PlayerName(gracz), gracz, Poziom, PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta�e�(a�) zalogowany na Moderatora poziomu %d do czasu wylogowania si� przez Admina %s (ID: %d)", Poziom, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zalogowa�e�(a�) %s (ID: %d) na Moderatora poziomu %d do czasu wylogowania.", PlayerName(gracz), gracz, PlayerName(playerid), playerid, Mod[playerid]);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mwyloguj(playerid, params[])
{
	new str[128];
	new gracz;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Administratorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /moff [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(!Mod[gracz]) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest Moderatorem");

	Mod[gracz] = 0;

	format(str, sizeof(str), "[INFO] Admin %s (ID: %d) wylogowa�(a) ci� z Moderatora!", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Wylogowa�e�(a�) %s (ID: %d) z Moderatora!", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgod(playerid, params[])
{
	new gracz;
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mgod [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerHealth(gracz, 9999999);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) nie�miertelno�� %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzyma�e�(a�) nie�miertelno�� od Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mgodall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerHealth(x, 9999999);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Da�e�(a�) nie�miertelno�� wszystkim graczom!");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %s) Da�(a) nie�miertelno�� wszystkim graczom!", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mtp(playerid, params[])
{
	new str[256];
	new Float:pX, Float:pY, Float:pZ;
	new giveplayerid, teleid;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "dd", giveplayerid, teleid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mtp [ID] [ID2]");

	if(IsPlayerConnected(giveplayerid) && IsPlayerConnected(teleid))
	{
		GetPlayerPos(teleid, pX,pY,pZ);
		new Interior;
		Interior = GetPlayerInterior(teleid);
		SetPlayerInterior(giveplayerid, Interior);
		SetPlayerPos(giveplayerid, pX,pY,pZ);

		format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Teleportowa�(a) %s (ID: %d) do %s (ID: %d)", PlayerName(playerid), playerid, PlayerName(giveplayerid), giveplayerid, PlayerName(teleid), teleid);
		SendClientMessageToAll(COLOR_LEMON, str);
	}

	if(!IsPlayerConnected(giveplayerid)) {
		format(str, sizeof(str), "[ERROR] %d Nie jest pod��czony", giveplayerid);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
	}
	if(!IsPlayerConnected(teleid)) {
		format(str, sizeof(str), "[ERROR] %d Nie jest pod��czony", teleid);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
	}
	return 1;
}

CMD:marmor(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /marmor [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerArmour(gracz, 100);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) pancerz %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) ci pancerz", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:marmorall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerArmour(x, 100);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Da�e�(a�) pancerz wszystkim graczom!");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) pancerz wszystkim graczom", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mheal(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mheal [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerHealth(gracz, 100);

	format(str, sizeof(str), "[M-INFO] Uzdrowi�e�(a�) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ucdrowi�(a) ci�", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mhealall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerHealth(x, 100);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Uzdrowi�e�(a�) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Uzdrowi�(a) wszystkich graczy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mexplode(playerid, params[])
{
	new Float:x,Float:y,Float:z;
	new str[128];
	new gracz;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mexplode [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	GetPlayerPos(gracz, x, y, z);

	CreateExplosion( x, y, z, 2, 50);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) wysadzi�(a) ci� w powietrze!", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Wysadzi�e�(a�) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mexplodeall(playerid, params[])
{
	new Float:x,Float:y,Float:z;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", czas)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /msettime [godzina]");

	if(czas > 24 || czas < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dna godzina! [0-24]");

	SetWorldTime(czas);

	format(str, sizeof(str), "[M-INFO] Zmieni�e�(a�) czas na %02d:00", czas);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni�(a) czas na %02d:00", PlayerName(playerid), playerid, czas);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mweather(playerid, params[])
{
	new str[128];
	new weather;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", weather)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mweather [pogoda]");

	if(weather > 46 || weather < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dna godzina! [0-24]");

	SetWeather(weather);

	format(str, sizeof(str), "[M-INFO] Zmieni�e�(a�) pogode na %02d", weather);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni�(a)pogode na %02d", PlayerName(playerid), playerid, weather);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mgivecash(playerid, params[])
{
	new gracz, kasa, str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "dd", gracz, kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mgivecash [ID] [ILOSC]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(kasa > 9999999 || kasa < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dna ilos� got�wki! [0-9999999]");

	GivePlayerMoney(gracz, kasa);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) graczowi %s (ID: %d) %d got�wki", PlayerName(gracz), gracz, kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzyma�e�(a�) %d got�wki od Moderatora %s (ID: %d)", kasa, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mgivecashall(playerid, params[])
{
	new kasa, str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "d", kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mgivecashall [ILOSC]");

	if(kasa > 9999999 || kasa < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dna ilos� got�wki! [0-9999999]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		GivePlayerMoney(x, kasa);
	}
	format(str, sizeof(str), "[M-INFO] Da�e�(a�) wszystkim graczom %s got�wki", kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) wszystkim %d got�wki", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mann(playerid, params[])
{
	new msg[128], sek2, str[256];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "ds[128]", sek2, msg)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mann [czas] [tresc]");

	if(sek2 == 0)
	{
		SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mann [czas] [tresc]");
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
		ShowPlayerDialog(playerid, DIALOG_MONL, DIALOG_STYLE_MSGBOX, "{AAFFCC}Moderatorzy Online:", "{FAEAA9}Obecnie nie ma �adnego Moderatora Online ...", "Ok", "");
	return 1;
}

CMD:mczysc(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	for(new i = 0 ; i <= 45 ; i++)
	{
		SendClientMessageToAll(0x00CC00AA, " ");
	}
	format(str, sizeof(str), "[INFO] Czat zosta� wyszyszczony przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:mfreeze(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mfreeze [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	TogglePlayerControllable(gracz, 0);

	format(str, sizeof(str), "[M-INFO] Zamrozi�e�(a�) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta�e�(a�) zamro�ony(a) przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:munfreeze(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /munfreeze [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	TogglePlayerControllable(gracz, 1);

	format(str, sizeof(str), "[M-INFO] Odmrozi�e�(a�) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta�e�(a�) odmro�ony(a) przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mfreezeall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			TogglePlayerControllable(x, 0);
		}
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zamrozi�e�(a�) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Wszyscy zostali zamro�eni przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:munfreezeall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			TogglePlayerControllable(x, 1);
		}
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Odmrozi�e�(a�) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Wszyscy zostali odmro�eni przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:mwarn(playerid, params[])
{
	new str[128];
	new gracz;
	new reason[64];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "ds[64]", gracz, reason)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mwarn [ID] [POW�D]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(Warn[gracz] == 0)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzyma�e�(a�) ostrze�enie od Moderatora %s (ID: %d) pow�d : %s (1/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		return 1;
	}

	if(Warn[gracz] == 1)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzyma�e�(a�) ostrze�enie od Moderatora %s (ID: %d) pow�d : %s (2/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		return 1;
	}
	if(Warn[gracz] == 2)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzyma�e�(a�) ostrze�enie od Moderatora %s (ID: %d) pow�d : %s (3/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		format(str, sizeof(str), "[INFO] %s (ID: %d) Zosta�(a) wyrzucony(a), Pow�d: Ostrze�enia (3/3)", PlayerName(gracz), gracz);
		SendClientMessageToAll(COLOR_LEMON, str);
		SendClientMessage(gracz, COLOR_LEMON, "Zosta�e�(a�) wyrzucony(a) z serwera z powodu: Ostrze�enia (3/3)");
		Kick(gracz);
		return 1;
	}
	return 1;
}

CMD:munwarn(playerid, params[])
{
	new gracz;
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d]", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /munwarn [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(Warn[gracz] == 0)
	{
		format(str, sizeof(str), "[ERROR] %s (ID: %d) Nie ma �adnego ostrze�enia", PlayerName(gracz), gracz);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
		return 1;
	}
	Warn[gracz] --;

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zabra�(a) ci ostrze�enie", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zabra�e�(a�) ostrze�enie %s (ID: %d) ", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mvirtualworld(playerid, params[])
{
	new str[128];
	new gracz;
	new world;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "dd", gracz, world)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mvirtualworld [ID] [VW]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerVirtualWorld(gracz, world);

	format(str, sizeof(str), "[M-INFO] Zmieni�e�(a�) WietualWorld %s (ID: %d) na %d", PlayerName(gracz), gracz, world);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni�(a) ci WirtualWorld na %d", PlayerName(playerid), playerid, world);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mvirtualworldall(playerid, params[])
{
	new str[128];
	new world;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "d", world)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mvirtualworldall [VW]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerVirtualWorld(x, world);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni�(a) WirtualWorld wszystkim graczom na %d", PlayerName(playerid), playerid, world);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieni�e�(a�) WietualWorld wszystkim graczom na %d", world);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivescore(playerid, params[])
{
	new str[128];
	new gracz;
	new score;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "dd", gracz, score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mgivescore [ID] [score]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerScore(gracz, GetPlayerScore(gracz) + score);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) ci %d respektu (score)", PlayerName(playerid), playerid, score);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) %s (ID: %d) %d respektu (score)", PlayerName(gracz), gracz, score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivescoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "d", score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mgivescoreall [score]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, GetPlayerScore(x) + score);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) wszystkim %d respektu (score)", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) wszystkim graczom %d respektu (score)", score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetscore(playerid, params[])
{
	new str[128];
	new gracz;
	new score;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "dd", gracz, score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /msetscore [ID] [score]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerScore(gracz, score);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmieni�(a) ci ilo�� respektu (score) na %d", PlayerName(playerid), playerid, score);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieni�e�(a�) %s (ID: %d) ilo�� respektu (score) na %d", PlayerName(gracz), gracz, score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetscoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "d", score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /msetscoreall [score]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, score);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmieni�(a) ilo�� score wszystkim graczom na %d", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieni�e�(a�) wszystkim graczom respekt (score) na %d", score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetscore(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mresetscore [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerScore(gracz, 0);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrestartowa�(a) ci respekt (score)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zresetowa�e�(a�) score %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetscoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, 0);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetowa�(a) wszystkim score", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zresetowa�e�(a�) wszystkim score");
	return 1;
}

CMD:mdisarm(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mdisarm [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	ResetPlayerWeapons(gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozbroi�(a) ci�", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Rozbroi�e�(a�) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mdisarmall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			ResetPlayerWeapons(x);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozbroi�(a) wszystkich", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Rozbroi�e�(a�) wszystkich graczy");
	return 1;
}

CMD:mresetcash(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mresetcash [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	ResetPlayerMoney(gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetowa�(a) ci pieni�dze", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zresetowa�e�(a�) pieni�dze  %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetcashall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			ResetPlayerMoney(x);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetowa�(a) wszystkim pieni�dze", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zresetowa�e�(a�) wszystkim pieni�dze");
	return 1;
}

CMD:msetcash(playerid, params[])
{
	new str[128];
	new gracz;
	new kasa;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "dd", gracz, kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /msetcash [ID] [kasa]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerMoney(gracz, kasa);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ustawi�(a) ci kase na %d", PlayerName(playerid), playerid, kasa);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Ustawile�(a�) kase %s (ID: %d) na %d", PlayerName(gracz), gracz, kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetcashall(playerid, params[])
{
	new str[128];
	new kasa;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "d", kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /msetcashall [kasa]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerMoney(x, kasa);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmieni�(a) wszystkim ilo�� kasy na %d", PlayerName(playerid), playerid, kasa);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Ustawile�(a�) wszystkim kase na %d", kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mmute(playerid, params[])
{
	new str[128];
	new gracz;
	new mtime;
	new reason[64];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "ids[64]", gracz, mtime, reason)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mmute [ID] [czas (min) [pow�d]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	Muted[gracz] = 1;
	KillTimer(MuteTimer[gracz]);
	MuteTimer[gracz] = SetTimerEx("UnmutePlayer",mtime*60000,0,"i", gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) uciszy�(a) ci� na %d min, pow�d: %s", PlayerName(playerid), playerid, mtime, reason);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Uciszy�e�(a�) %s (ID: %d) na %d min, pow�d: %s", PlayerName(gracz), gracz, mtime, reason);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:munmute(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /munmute [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	Muted[gracz] = 0;
	KillTimer(MuteTimer[gracz]);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) odciszy�(a) ci�", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Odciszy�e�(a�) %s (ID: %d)", PlayerName(gracz), gracz);
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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "idd", gracz, bron, ammo)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mgivegun [ID] [ID broni] [AMMO]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(bron > 46 || bron < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dne ID broni [1-46]");

	if(ammo > 99999999 || ammo < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dna ilo�� amuicji [1-99999999]");

	GivePlayerWeapon(gracz, bron, ammo);

	GetWeaponName(bron, nbron, 32);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) ci bro� %s (ID: %d) i %d amunicji", PlayerName(playerid), playerid, nbron, bron, ammo);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) bro� %s (ID: %d) i %d amunicji %s (ID: %d)", nbron, bron, ammo, PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivegunall(playerid, params[])
{
	new str[256];
	new nbron[32];
	new bron;
	new ammo;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params,"dd",bron, ammo)) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] U�yj /mgivegunall [ID broni] [AMMO]!");

	if(bron > 46 || bron < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dne ID broni [1-46]");

	if(ammo > 99999999 || ammo < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dna ilo�� amuicji [1-99999999]");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		GivePlayerWeapon(x, bron, ammo);
	}
	GetWeaponName(bron, nbron, 32);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) wszystkim bro� %s (ID: %d) i %d amunicji", PlayerName(playerid), playerid, nbron, bron, ammo);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) wszystkim bro� %s (ID: %d) i %d amunicji", nbron, bron, ammo);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mip(playerid, params[])
{
	new str[128];
	new gracz;
	new adips[16];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mip [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mwersja [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");


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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mincar [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest w �adnym poje�dzie!");

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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mrfv [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest w �adnym poje�dzie!");

	veah = GetPlayerVehicleID(gracz);
	RemovePlayerFromVehicle(gracz);

	format(str, sizeof(str), "[M-INFO] Wyrzuci�e�(a�) %s (ID %d) z pojazdu %s, (ID: %d)", PlayerName(gracz), gracz, carname[GetVehicleModel(GetPlayerVehicleID(gracz)) - 400], veah);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta�e�(a�) wyrzucony(a) z pojazdu przez moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrfvall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		RemovePlayerFromVehicle(x);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) wyrzuci�(a) wszystkich graczy z pojazd�w", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Wyrzuci�e�(a�) wszystkich graczy z pojazd�w");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mcrash(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mcrash [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	SetPlayerSkin(gracz, 555);

	format(str, sizeof(str), "[M-INFO] Wywo�a�e�(a�) Crash GTA, %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mkill(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mkill [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie mo�esz zabi� modaratora poziomu 2!");
	
	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie mo�esz zabi� Administratora!");
	
	SetPlayerHealth(gracz, 0);

	format(str, sizeof(str), "[M-INFO] Zabi�e�(a�) gracza %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta�e�(a�) zabity(a) przez moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mkillall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		if(Mod[x] < 1 && !IsPlayerAdmin(x))
		{
		SetPlayerHealth(x, 0);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zabi�(a) wszystkich graczy z wyj�tkiem moderator�w/Administrator�w ", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zabi�e�(a�) wszystkich graczy z wyj�tkiem Moderator�w/Administrator�w");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mjetpack(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mjetpack [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

    SetPlayerSpecialAction(gracz, SPECIAL_ACTION_USEJETPACK);
    
	format(str, sizeof(str), "[M-INFO] Da�e�(a�) jetpack'a graczowi %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzyma�e�(a�) jetpack'a od Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mjetpackall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jeste� Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
 		SetPlayerSpecialAction(x, SPECIAL_ACTION_USEJETPACK);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da�(a) wszystkim jetpack", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da�e�(a�) wszystkim jetpacka ;O");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mkick(playerid, params[])
{
	new str[128], gracz, Powod[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "iu", gracz, Powod)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mkick [ID] [POW�D]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");
	
	if(gracz == playerid) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie mo�esz wyrzuci� samego siebie!");

	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie mo�esz wyrzuci� modaratora poziomu 2!");

	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie mo�esz wyrzuci� Administratora!");


	format(str, sizeof(str), "[M-INFO] Wyrzuci�e� %s (ID: %d) z pwowodu : %s", PlayerName(gracz), gracz, Powod);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta�e�(a�) wyrzucony(a) przez Moderatora %s (ID: %d), z powodu: %s", PlayerName(playerid), playerid, Powod);
	SendClientMessage(gracz, COLOR_LEMON, str);
	
	format(str, sizeof(str), "[INFO] %s (ID: %d) zosta�(a) wyrzucony(a) przez Moderatora %s (ID: %d) z powodu: %s", PlayerName(gracz), gracz, PlayerName(playerid), playerid, Powod);
	SendClientMessageToAll(COLOR_LEMON, str);

	Kick(gracz);
	return 1;
}

CMD:mnetstats(playerid, params[])
{
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	gNetStatsPlayerId = playerid;
	NetStatsDisplay();
	gNetStatsTimerId = SetTimer("NetStatsDisplay", 2000, true);

	return 1;
}

CMD:mpm(playerid, params[])
{
	new MSG[128];
	new str[128];
	
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "s[128]", MSG)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mpm [TRE��]");

    format(str, sizeof(str), "|MOD-CHAT| (%s ID: %d| POZ: %d): %s",PlayerName(playerid), playerid, Mod[playerid], MSG);
	SendClientMessageToMod(0x24FF0AB9, str);
	//0x9E3DFFAA
	return 1;
}

CMD:mvehgod(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mvehgod [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w �adnym poje�dzie!");
    
    SetVehicleHealth(GetPlayerVehicleID(gracz), 9999999);

	format(str, sizeof(str), "[M-INFO] Zrobi�e�(a�) graczowi %s (ID: %d) niezniszczalny pojazd", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrobi�(a) ci niezniszczalny pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mvehgodall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jeste� Moderatorem poziomu 2!");

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

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrobi�(a) wszystkim niezniszczalne pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zrobi�e�(a�) wszystkim niezniszczalne pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mdestroyveh(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mdestroyveh [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w �adnym poje�dzie!");

    SetVehicleHealth(GetPlayerVehicleID(gracz), 0);

	format(str, sizeof(str), "[M-INFO] Rozwali�e�(a�) graczowi %s (ID: %d) pojazd", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozwali�(a) ci pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mdestroyvehall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jeste� Moderatorem poziomu 2!");

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

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozwali� wszystkim pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Rozwali�e�(a�) wszystkim pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mslap(playerid, params[])
{
	new str[128];
	new gracz;
	new Float:HPY;
	new wezHPY;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "ii", gracz, wezHPY)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mslap [ID] [HP 1-10]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");
	
	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie mo�esz uderzy� modaratora poziomu 2!");

	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie mo�esz uderzy� Administratora!");

	if(wezHPY < 1 || wezHPY > 10) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B��dna ilo�� HP ![1-10]");

    GetPlayerHealth(gracz, HPY);
	SetPlayerHealth(gracz, floatround(HPY)-wezHPY);

	format(str, sizeof(str), "[M-INFO] Uderzy�e� %s (ID: %d) zadaj�c %d obra�e�", PlayerName(gracz), gracz, wezHPY);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) uderzy�(a) ci�, zadaj�c %d obra�e�", PlayerName(playerid), playerid, wezHPY);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrepairveh(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mrepairveh [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod��czony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w �adnym poje�dzie!");

    new POJ = GetPlayerVehicleID(gracz);
    RepairVehicle(POJ);
    
	format(str, sizeof(str), "[M-INFO] Naprawi�e�(a�) pojazd graczowi %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) naprawi�(a) ci pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrepairvehall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jeste� Moderatorem poziomu 2!");

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

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) naprawi� wszystkim pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Naprawi�es wszystkim pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgravity(playerid, params[])
{
	new str[128];
	new gravity;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jeste� Moderatorem poziomu 2!");

	if(sscanf(params, "i", gravity)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] U�yj /mgravity [grawitacja] |Domy�lnie - 0.008|");

	SetGravity(gravity);

	format(str, sizeof(str), "[M-INFO] Ustawi�e�(a�) grawitacje na %d", gravity);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ustawi� grawitacje na %d", PlayerName(playerid), playerid, gravity);
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
		if(response)//co ma sie dzia� po wybiraniu pierwszej opcji (DALEJ)
		{
  			new Str[1024];

			strcat(Str,"{FFFF00}/msetcashall [kasa] {FFFFFF}- Ustawiasz pieni�dze wszystkim graczom\n");
			strcat(Str,"{FFFF00}/mgivegunall [ID broni] [AMMO] {FFFFFF}- Dajesz bro� wszystkim graczom\n");
            strcat(Str,"{FFFF00}/mrfvall [ID] {FFFFFF}- Wyrzucasz wszystkich graczy z pojazdu\n");
			strcat(Str,"{FFFF00}/mkick [ID] [Pow�d] {FFFFFF}- Wyrzucasz gracza\n");
			strcat(Str,"{FFFF00}/mvehgodall {FFFFFF}- Dajesz wszystkim niezniszczalne pojazdy\n");
			strcat(Str,"{FFFF00}/mcrash [ID] {FFFFFF}- Wywo�ujesz Crash'a graczowi\n");
			strcat(Str,"{FFFF00}/mjetpackall {FFFFFF}- Dajesz jetpack wszystkim\n");
			strcat(Str,"{FFFF00}/mdestroyvehall {FFFFFF}- Rozwalasz wszystkim pojazdy\n");
			strcat(Str,"{FFFF00}/mrepairvehall {FFFFFF}- Naprawiasz wszystkim pojazdy\n");
			strcat(Str,"{FFFF00}/mgravity [gravitacja] {FFFFFF}- Ustawiasz grawitacje\n");
		    ShowPlayerDialog(playerid, DIALOG_MCMD2, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Moderatora 2/2 {63AFF0}(Moderator v 1.4 by Czechu)", Str, "Wyjd�", "");
		}
		else if(!response)//co sie ma dziac po wybraniu drugiej opcji (WYJD�)
		{
			//cu� tu powinno by� co nie :) ?
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
	SendClientMessage(playerid,COLOR_LEMON,"[INFO] Twoja kara wyciszenia min�a!");
	return 1;
}
// 		_________________________________________________________
// 	 	|                                                       |
//  	|               KONIEC-KONIEC-KONIEC-KONIEC             |
//		|               KONIEC-KONIEC-KONIEC-KONIEC             |
//		|               KONIEC-KONIEC-KONIEC-KONIEC             |
//  	|_______________________________________________________|

