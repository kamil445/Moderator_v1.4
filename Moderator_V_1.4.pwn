/*  _________________________________________________________
	|                                                       |
	|                  Moderator V 1.4                      |
	|                          BY                           |
	|                       Czechu                          |
	|                                                       |
	|_______________________________________________________|


	DziÍki øe pobra≥eú(aú) mÛj skrypt "Moderator v 1.4 :)
	Mam nadziejÍ øe bedzie ci dobrze s≥uøy≥.
	Zezwalam na : edytowanie wed≥ug w≥asnych potrzeb, wrzucenie do w≥asnej mapki (ale proszÍ oto aby
	komendÍ /mabout takze skopiowaÊ :)
	Zabraniam : wystawiania na inne fora, zmiany autora

	Zmiany v 1.4 :

	- Zmieniono system logowania na moderatora, teraz wszystko dzieje siÍ
	automatycznie po wejúciu gracza,
	- Dodano rangi moderatora, 1 - najniøsza, 2- najwyøsza,
	- Dodano kilkanaúcie komend, w tym dodawanie oraz usuwanie moderatorÛw,
	- Logowanie gracza na administratora do czasu wylogowania,

*/
//---------------------INCLUDE--------------------------------------------------
#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <dini>
//---------------------DEFINICJE------------------------------------------------
#define MG "Mod/mody.ini" //Lokalizacja pliku z nazwami oraz poziomami ModÛw
#define WARNY "Mod/warny.ini" //lokalizacja pliku z warnami graczy
#define MAX_GRACZY 20 //Maksymalna ilosÊ graczy na serwerze
#define DIALOG_MADM 200 //ID dialogu komend Admina (Moderator)
#define DIALOG_MCMD 201 //ID dialogu komend Moderatora
#define DIALOG_MONL 202 //ID dialogu komendy /monline
#define DIALOG_MABOUT 203 //ID dialogu komendy /mabout
#define DIALOG_NETSTATS 204 //ID dialogu komendy /netstats
#define DIALOG_MCMD2 205 //ID dialogu komend Moderatora czÍúc 2
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
	"Bobcat","MrWhoopee","BFInjection","Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Busa","Czo≥g",
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
	#emit load.pri d //≥adowanie zmiennej "d" do pamiÍci (bazowane na Asemblerze)
	#emit stor.pri d //zapisywanie zmiennej "d" do pamiÍci (bazowane na Asemblerze)
	#pragma unused amx
}

main()
{
	AntyDeAMX();
	print("\n----------------------------------");
	print(" Moderator v1.4 by Czechu za≥adowany!");
	print("----------------------------------\n");
}

public OnFilterScriptInit()
{

	print("\n----------------------------------");
	print(" Moderator v1.4 by Czechu za≥adowany!");
	print("----------------------------------\n");
	AntyDeAMX();
	if(!dini_Exists(MG)) dini_Create(MG);
	if(!dini_Exists(WARNY)) dini_Create(WARNY);

	return 1;
}

public OnFilterScriptExit()
{
	print("\n-----------------------------------");
	print(" Moderator v1.4 by Czechu nieza≥adowany!");
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
		format(str, sizeof(str), "[M-INFO] Witaj %s, twÛj poziom Moderatora to : Moderator poziomu %d", PlayerName(playerid), Mod[playerid]);
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
		SendClientMessage(playerid,0xFF0000FF,"{24FF0A}[ERROR] {FFFFFF}Nie moøesz pisaÊ, gdy jesteú wyciszony(a)!");
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
		SendClientMessage(playerid, COLOR_LEMON, "[INFO] Nie masz øadnego ostrzeøenia, tak trzymaj ! :)");
		return 1;
	}

	format(str, sizeof(str), "[INFO] Twoja iloúÊ ostrzeøeÒ: %d", Warn[playerid]);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mabout(playerid, params[])
{
	new Str[256];

	strcat(Str,"Autor : Czechu \n");
	strcat(Str,"Edited by: (twÛj nick) \n");
	strcat(Str,"Wersja : 1.4\n");
	strcat(Str,"Ostatnia Aktualizacja: : 27.10.2013|16:54\n");
	strcat(Str,"W razie pytaÒ, pisz GG: 6445926\n");
	ShowPlayerDialog(playerid, DIALOG_MABOUT, DIALOG_STYLE_MSGBOX, "{AAFFCC}Informacje",Str,"Wyjdü", "");
	return 1;
}

CMD:madmin(playerid, params[])
{
	new Str[512];
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Administratorem!");

    strcat(Str,"{FFFF00}/dajmoda [ID] [POZIOM 1-2] {FFFFFF}- Dajesz graczowi moda\n");
    strcat(Str,"{FFFF00}/wezmoda [ID] [POW”D] {FFFFFF}- Zabierasz graczowi moda\n");
	strcat(Str,"{FFFF00}/mloguj [ID] [POZIOM 1-2] {FFFFFF}- Logujesz gracza na Moderatora, do czasu wyjúcia z serwera\n");
	strcat(Str,"{FFFF00}/mwyloguj [ID] {FFFFFF}- Wylogowujesz gracza z Moderatora\n");
	ShowPlayerDialog(playerid, DIALOG_MADM, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Administratora {63AFF0}(Moderator v 1.4 by Czechu)",Str,"Wyjdü", "");
	return 1;
}

CMD:mcmd(playerid, params[])
{
	new Str[3096];
	
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	strcat(Str,"{00A600}Moderator Poziomu 1 :\n\n");
	strcat(Str,"{FFFF00}/mgod [ID] {FFFFFF}- Dajesz nieúmiertelnoúÊ graczowi\n");
	strcat(Str,"{FFFF00}/mtp [ID] [ID2] {FFFFFF}- Teleportujesz [ID] do [ID2]\n");
	strcat(Str,"{FFFF00}/marmor [ID] {FFFFFF}- Dajesz armor graczowi\n");
	strcat(Str,"{FFFF00}/mheal [ID] {FFFFFF}- Uzdrawiasz danego gracza\n");
	strcat(Str,"{FFFF00}/msettime [GODZINA] {FFFFFF}- Zmieniasz czas\n");
	strcat(Str,"{FFFF00}/mweather [POGODA] {FFFFFF}- Zmieniasz pogodÍ\n");
	strcat(Str,"{FFFF00}/mgivecash [ID] [ILOSC] {FFFFFF}- Dajesz gotÛwke graczowi\n");
	strcat(Str,"{FFFF00}/mann [CZAS] [TEXT] {FFFFFF}- Piszesz na úrodku ekranu\n");
	strcat(Str,"{FFFF00}/mczysc {FFFFFF}- Czyscisz czat\n");
	strcat(Str,"{FFFF00}/mfreeze [ID] {FFFFFF}- Zamraøasz gracza\n");
	strcat(Str,"{FFFF00}/munfreeze [ID] {FFFFFF}- Odmraøasz gracza\n");
	strcat(Str,"{FFFF00}/mwarn [ID] [POWOD] {FFFFFF}- Dajesz warna graczowi\n");
	strcat(Str,"{FFFF00}/munwarn [ID] {FFFFFF}- Zabierasz warna graczowi\n");
	strcat(Str,"{FFFF00}/mvirtualworld [ID] {FFFFFF}- Zmieniasz graczowi VW\n");
	strcat(Str,"{FFFF00}/mgivescore [ID] [score] {FFFFFF}- Dajesz graczowi score\n");
	strcat(Str,"{FFFF00}/msetscore [ID] [score] {FFFFFF}- Zmieniasz iloúÊ score graczowi\n");
	strcat(Str,"{FFFF00}/mresetscore [ID] {FFFFFF}- Resetujesz score graczowi\n");
	strcat(Str,"{FFFF00}/mdisarm [ID] {FFFFFF}- Rozbrajasz gracza\n");
	strcat(Str,"{FFFF00}/mresetcash [ID] {FFFFFF}- Resetujesz pieniπdze graczowi\n");
	strcat(Str,"{FFFF00}/msetcash [ID] [kasa] {FFFFFF}- Ustawiasz pieniπdze graczowi\n");
	strcat(Str,"{FFFF00}/mmute [ID] [czas (min)] [powÛd] {FFFFFF}- Uciszasz gracza\n");
	strcat(Str,"{FFFF00}/munmute [ID] {FFFFFF}- Odciszasz gracza\n");
	strcat(Str,"{FFFF00}/mgivegun [ID] [ID broni] [AMMO] {FFFFFF}- Dajesz broÒ graczowi\n");
	strcat(Str,"{FFFF00}/mip [ID] {FFFFFF}- Sprawdzasz adres IP gracza\n");
	strcat(Str,"{FFFF00}/mwersja [ID] {FFFFFF}- Sprawdzasz wersje SA-MP gracza\n");
	strcat(Str,"{FFFF00}/mincar [ID] {FFFFFF}- Sprawdzasz informacje o pojezdzie gracza\n");
	strcat(Str,"{FFFF00}/mrfv [ID] {FFFFFF}- Wyrzucasz gracza z pojazdu\n");
	strcat(Str,"{FFFF00}/mkill [ID] {FFFFFF}- Zabijasz gracza\n");
	strcat(Str,"{FFFF00}/mnetstats [ID] {FFFFFF}- Statystyki po≥πczenia serwera\n");
	strcat(Str,"{FFFF00}/mjetpack [ID] {FFFFFF}- Dajesz jetpacka\n");
	strcat(Str,"{FFFF00}/mvehgod [ID] {FFFFFF}- Dajesz niezniszczalny pojazd\n");
	strcat(Str,"{FFFF00}/mdestroyveh [ID]{FFFFFF}- Rozwalasz pojazd\n");
	strcat(Str,"{FFFF00}/mslap [ID] [HP 1-10]{FFFFFF}- Uderzasz gracza\n");
	strcat(Str,"{FFFF00}/mrepairveh [ID]{FFFFFF}- Naprawiasz pojazd\n\n");
	
	strcat(Str,"{B4B5B7}Moderator Poziomu 2 :\n\n");
	
	strcat(Str,"{FFFF00}/mgodall {FFFFFF}- Dajesz nieúmiertelnoúÊ wszystkim graczom\n");
	strcat(Str,"{FFFF00}/marmorall {FFFFFF}- Dajesz armor wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mhealall {FFFFFF}- Uzdrawiasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mexplode [ID] {FFFFFF}- Wysadzasz gracza\n");
	strcat(Str,"{FFFF00}/mexplodeall {FFFFFF}- Wysadzasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mgivecashall {FFFFFF}- Dajesz gotÛwke wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mfreezeall {FFFFFF}- Zamraøasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/munfreezeall {FFFFFF}- Odmraøasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mvirtualworldall {FFFFFF}- Zmieniasz wszystkim graczom VW\n");
	strcat(Str,"{FFFF00}/mgivescoreall {FFFFFF}- Dajesz score wszystkim graczom\n");
	strcat(Str,"{FFFF00}/msetscoreall [score] {FFFFFF}- Zmieniasz iloúÊ score wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mresetscoreall {FFFFFF}- Resetujesz score wszystkim graczomm\n");
	strcat(Str,"{FFFF00}/mresetcashall {FFFFFF}- Resetujesz pieniπdze wszystkim graczom\n");
	strcat(Str,"{FFFF00}/mdisarmall {FFFFFF}- Rozbrajasz wszystkich graczy\n");
	strcat(Str,"{FFFF00}/mkillall {FFFFFF}- Zabijasz wszystkich graczy w wyjπtkiem ModeratorÛw/AdministratorÛw\n");
	ShowPlayerDialog(playerid, DIALOG_MCMD, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Moderatora 1/2 {63AFF0}(Moderator v 1.4 by Czechu)", Str, "Dalej", "Wyjdü");
	return 1;
}

CMD:dajmoda(playerid, params[])
{
	new str[128];
	new gracz;
	new Poziom;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Administratorem!");

	if(sscanf(params, "dd", gracz, Poziom)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /dajmoda [ID] [POZIOM 1-2]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");
	
	if(Poziom < 1 || Poziom > 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídny poziom ! [1-2]");
	
	if(Mod[gracz] == Poziom) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz jest juø moderatorem tego poziomu");

	Mod[gracz] = Poziom;
	dini_IntSet(MG, PlayerName(gracz), Poziom);
	
	format(str, sizeof(str), "[INFO] Otrzyma≥eú Moderatora poziomu %d od Admina %s (ID: %d)", Poziom, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:wezmoda(playerid, params[])
{
	new str[128];
	new gracz;
	new Powod[128];

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Administratorem!");

	if(sscanf(params, "ds", gracz, Powod)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /wezmoda [ID] [POW”D]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");
	
	if(Mod[gracz] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest Moderatorem");

	Mod[gracz] = 0;
	dini_Unset(MG, PlayerName(gracz));

	format(str, sizeof(str), "[INFO] Admin %s (ID: %d) zabra≥ ci moderatora z powodu : %s", PlayerName(playerid), playerid, Powod);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}


CMD:mloguj(playerid, params[])
{
	new str[128];
	new gracz;
	new Poziom;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Administratorem!");

	if(sscanf(params, "dd", gracz, Poziom)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mloguj [ID] [POZIOM 1-2]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");
	
	if(Poziom < 1 || Poziom > 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídny poziom ! [1-2]");

	Mod[gracz] = Poziom;

	format(str, sizeof(str), "[INFO] %s (ID: %d) Zosta≥(a) zalogowany(a) na Moderatora poziomu %d do czasu wylogowania siÍ przez Admina %s (ID: %d)", PlayerName(gracz), gracz, Poziom, PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta≥eú(aú) zalogowany na Moderatora poziomu %d do czasu wylogowania siÍ przez Admina %s (ID: %d)", Poziom, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zalogowa≥eú(aú) %s (ID: %d) na Moderatora poziomu %d do czasu wylogowania.", PlayerName(gracz), gracz, PlayerName(playerid), playerid, Mod[playerid]);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mwyloguj(playerid, params[])
{
	new str[128];
	new gracz;

	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Administratorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /moff [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(!Mod[gracz]) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest Moderatorem");

	Mod[gracz] = 0;

	format(str, sizeof(str), "[INFO] Admin %s (ID: %d) wylogowa≥(a) ciÍ z Moderatora!", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Wylogowa≥eú(aú) %s (ID: %d) z Moderatora!", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgod(playerid, params[])
{
	new gracz;
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mgod [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerHealth(gracz, 9999999);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) nieúmiertelnoúÊ %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzyma≥eú(aú) nieúmiertelnoúÊ od Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mgodall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerHealth(x, 9999999);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Da≥eú(aú) nieúmiertelnoúÊ wszystkim graczom!");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %s) Da≥(a) nieúmiertelnoúÊ wszystkim graczom!", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mtp(playerid, params[])
{
	new str[256];
	new Float:pX, Float:pY, Float:pZ;
	new giveplayerid, teleid;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "dd", giveplayerid, teleid)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mtp [ID] [ID2]");

	if(IsPlayerConnected(giveplayerid) && IsPlayerConnected(teleid))
	{
		GetPlayerPos(teleid, pX,pY,pZ);
		new Interior;
		Interior = GetPlayerInterior(teleid);
		SetPlayerInterior(giveplayerid, Interior);
		SetPlayerPos(giveplayerid, pX,pY,pZ);

		format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Teleportowa≥(a) %s (ID: %d) do %s (ID: %d)", PlayerName(playerid), playerid, PlayerName(giveplayerid), giveplayerid, PlayerName(teleid), teleid);
		SendClientMessageToAll(COLOR_LEMON, str);
	}

	if(!IsPlayerConnected(giveplayerid)) {
		format(str, sizeof(str), "[ERROR] %d Nie jest pod≥πczony", giveplayerid);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
	}
	if(!IsPlayerConnected(teleid)) {
		format(str, sizeof(str), "[ERROR] %d Nie jest pod≥πczony", teleid);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
	}
	return 1;
}

CMD:marmor(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /marmor [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerArmour(gracz, 100);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) pancerz %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) ci pancerz", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:marmorall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerArmour(x, 100);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Da≥eú(aú) pancerz wszystkim graczom!");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) pancerz wszystkim graczom", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mheal(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mheal [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerHealth(gracz, 100);

	format(str, sizeof(str), "[M-INFO] Uzdrowi≥eú(aú) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ucdrowi≥(a) ciÍ", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mhealall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerHealth(x, 100);
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Uzdrowi≥eú(aú) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Uzdrowi≥(a) wszystkich graczy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mexplode(playerid, params[])
{
	new Float:x,Float:y,Float:z;
	new str[128];
	new gracz;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mexplode [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	GetPlayerPos(gracz, x, y, z);

	CreateExplosion( x, y, z, 2, 50);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) wysadzi≥(a) ciÍ w powietrze!", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Wysadzi≥eú(aú) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mexplodeall(playerid, params[])
{
	new Float:x,Float:y,Float:z;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", czas)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /msettime [godzina]");

	if(czas > 24 || czas < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídna godzina! [0-24]");

	SetWorldTime(czas);

	format(str, sizeof(str), "[M-INFO] Zmieni≥eú(aú) czas na %02d:00", czas);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni≥(a) czas na %02d:00", PlayerName(playerid), playerid, czas);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mweather(playerid, params[])
{
	new str[128];
	new weather;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", weather)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mweather [pogoda]");

	if(weather > 46 || weather < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídna godzina! [0-24]");

	SetWeather(weather);

	format(str, sizeof(str), "[M-INFO] Zmieni≥eú(aú) pogode na %02d", weather);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni≥(a)pogode na %02d", PlayerName(playerid), playerid, weather);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mgivecash(playerid, params[])
{
	new gracz, kasa, str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "dd", gracz, kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mgivecash [ID] [ILOSC]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(kasa > 9999999 || kasa < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídna ilosÊ gotÛwki! [0-9999999]");

	GivePlayerMoney(gracz, kasa);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) graczowi %s (ID: %d) %d gotÛwki", PlayerName(gracz), gracz, kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzyma≥eú(aú) %d gotÛwki od Moderatora %s (ID: %d)", kasa, PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mgivecashall(playerid, params[])
{
	new kasa, str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "d", kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mgivecashall [ILOSC]");

	if(kasa > 9999999 || kasa < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídna ilosÊ gotÛwki! [0-9999999]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		GivePlayerMoney(x, kasa);
	}
	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) wszystkim graczom %s gotÛwki", kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) wszystkim %d gotÛwki", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);
	return 1;
}

CMD:mann(playerid, params[])
{
	new msg[128], sek2, str[256];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "ds[128]", sek2, msg)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mann [czas] [tresc]");

	if(sek2 == 0)
	{
		SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mann [czas] [tresc]");
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
		ShowPlayerDialog(playerid, DIALOG_MONL, DIALOG_STYLE_MSGBOX, "{AAFFCC}Moderatorzy Online:", "{FAEAA9}Obecnie nie ma Øadnego Moderatora Online ...", "Ok", "");
	return 1;
}

CMD:mczysc(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	for(new i = 0 ; i <= 45 ; i++)
	{
		SendClientMessageToAll(0x00CC00AA, " ");
	}
	format(str, sizeof(str), "[INFO] Czat zosta≥ wyszyszczony przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:mfreeze(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mfreeze [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	TogglePlayerControllable(gracz, 0);

	format(str, sizeof(str), "[M-INFO] Zamrozi≥eú(aú) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta≥eú(aú) zamroøony(a) przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:munfreeze(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /munfreeze [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	TogglePlayerControllable(gracz, 1);

	format(str, sizeof(str), "[M-INFO] Odmrozi≥eú(aú) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta≥eú(aú) odmroøony(a) przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mfreezeall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			TogglePlayerControllable(x, 0);
		}
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zamrozi≥eú(aú) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Wszyscy zostali zamroøeni przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:munfreezeall(playerid, params[])
{
	new str[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			TogglePlayerControllable(x, 1);
		}
	}
	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Odmrozi≥eú(aú) wszystkich graczy");

	format(str, sizeof(str), "[INFO] Wszyscy zostali odmroøeni przez Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessageToAll( COLOR_LEMON, str);
	return 1;
}

CMD:mwarn(playerid, params[])
{
	new str[128];
	new gracz;
	new reason[64];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "ds[64]", gracz, reason)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mwarn [ID] [POW”D]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(Warn[gracz] == 0)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzyma≥eú(aú) ostrzeøenie od Moderatora %s (ID: %d) powÛd : %s (1/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		return 1;
	}

	if(Warn[gracz] == 1)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzyma≥eú(aú) ostrzeøenie od Moderatora %s (ID: %d) powÛd : %s (2/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		return 1;
	}
	if(Warn[gracz] == 2)
	{
		Warn[gracz] ++;

		format(str, sizeof(str), "[INFO] Otrzyma≥eú(aú) ostrzeøenie od Moderatora %s (ID: %d) powÛd : %s (3/3)", PlayerName(playerid), playerid, reason);
		SendClientMessage(gracz, COLOR_LEMON, str);
		format(str, sizeof(str), "[INFO] %s (ID: %d) Zosta≥(a) wyrzucony(a), PowÛd: Ostrzeøenia (3/3)", PlayerName(gracz), gracz);
		SendClientMessageToAll(COLOR_LEMON, str);
		SendClientMessage(gracz, COLOR_LEMON, "Zosta≥eú(aú) wyrzucony(a) z serwera z powodu: Ostrzeøenia (3/3)");
		Kick(gracz);
		return 1;
	}
	return 1;
}

CMD:munwarn(playerid, params[])
{
	new gracz;
	new str[128];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d]", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /munwarn [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(Warn[gracz] == 0)
	{
		format(str, sizeof(str), "[ERROR] %s (ID: %d) Nie ma øadnego ostrzeøenia", PlayerName(gracz), gracz);
		SendClientMessage(playerid, COLOR_BLUEGREEN, str);
		return 1;
	}
	Warn[gracz] --;

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zabra≥(a) ci ostrzeøenie", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zabra≥eú(aú) ostrzeøenie %s (ID: %d) ", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mvirtualworld(playerid, params[])
{
	new str[128];
	new gracz;
	new world;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "dd", gracz, world)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mvirtualworld [ID] [VW]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerVirtualWorld(gracz, world);

	format(str, sizeof(str), "[M-INFO] Zmieni≥eú(aú) WietualWorld %s (ID: %d) na %d", PlayerName(gracz), gracz, world);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni≥(a) ci WirtualWorld na %d", PlayerName(playerid), playerid, world);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mvirtualworldall(playerid, params[])
{
	new str[128];
	new world;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "d", world)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mvirtualworldall [VW]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerVirtualWorld(x, world);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) Zmieni≥(a) WirtualWorld wszystkim graczom na %d", PlayerName(playerid), playerid, world);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieni≥eú(aú) WietualWorld wszystkim graczom na %d", world);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivescore(playerid, params[])
{
	new str[128];
	new gracz;
	new score;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "dd", gracz, score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mgivescore [ID] [score]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerScore(gracz, GetPlayerScore(gracz) + score);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) ci %d respektu (score)", PlayerName(playerid), playerid, score);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) %s (ID: %d) %d respektu (score)", PlayerName(gracz), gracz, score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivescoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "d", score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mgivescoreall [score]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, GetPlayerScore(x) + score);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) wszystkim %d respektu (score)", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) wszystkim graczom %d respektu (score)", score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetscore(playerid, params[])
{
	new str[128];
	new gracz;
	new score;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "dd", gracz, score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /msetscore [ID] [score]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerScore(gracz, score);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmieni≥(a) ci iloúÊ respektu (score) na %d", PlayerName(playerid), playerid, score);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieni≥eú(aú) %s (ID: %d) iloúÊ respektu (score) na %d", PlayerName(gracz), gracz, score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetscoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "d", score)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /msetscoreall [score]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, score);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmieni≥(a) iloúÊ score wszystkim graczom na %d", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zmieni≥eú(aú) wszystkim graczom respekt (score) na %d", score);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetscore(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mresetscore [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerScore(gracz, 0);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrestartowa≥(a) ci respekt (score)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zresetowa≥eú(aú) score %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetscoreall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerScore(x, 0);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetowa≥(a) wszystkim score", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zresetowa≥eú(aú) wszystkim score");
	return 1;
}

CMD:mdisarm(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mdisarm [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	ResetPlayerWeapons(gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozbroi≥(a) ciÍ", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Rozbroi≥eú(aú) %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mdisarmall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			ResetPlayerWeapons(x);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozbroi≥(a) wszystkich", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Rozbroi≥eú(aú) wszystkich graczy");
	return 1;
}

CMD:mresetcash(playerid, params[])
{
	new str[128];
	new gracz;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mresetcash [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	ResetPlayerMoney(gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetowa≥(a) ci pieniπdze", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zresetowa≥eú(aú) pieniπdze  %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mresetcashall(playerid, params[])
{
	new str[128];
	new score;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		if(x != playerid)
		{
			ResetPlayerMoney(x);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zresetowa≥(a) wszystkim pieniπdze", PlayerName(playerid), playerid, score);
	SendClientMessageToAll(COLOR_LEMON, str);

	SendClientMessage(playerid, COLOR_LEMON, "[M-INFO] Zresetowa≥eú(aú) wszystkim pieniπdze");
	return 1;
}

CMD:msetcash(playerid, params[])
{
	new str[128];
	new gracz;
	new kasa;


	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "dd", gracz, kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /msetcash [ID] [kasa]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerMoney(gracz, kasa);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ustawi≥(a) ci kase na %d", PlayerName(playerid), playerid, kasa);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Ustawileú(aú) kase %s (ID: %d) na %d", PlayerName(gracz), gracz, kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:msetcashall(playerid, params[])
{
	new str[128];
	new kasa;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "d", kasa)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /msetcashall [kasa]");

	for (new x = 0 ; x < MAX_GRACZY ; x++)
	{
		SetPlayerMoney(x, kasa);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zmieni≥(a) wszystkim iloúÊ kasy na %d", PlayerName(playerid), playerid, kasa);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Ustawileú(aú) wszystkim kase na %d", kasa);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mmute(playerid, params[])
{
	new str[128];
	new gracz;
	new mtime;
	new reason[64];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "ids[64]", gracz, mtime, reason)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mmute [ID] [czas (min) [powÛd]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	Muted[gracz] = 1;
	KillTimer(MuteTimer[gracz]);
	MuteTimer[gracz] = SetTimerEx("UnmutePlayer",mtime*60000,0,"i", gracz);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) uciszy≥(a) ciÍ na %d min, powÛd: %s", PlayerName(playerid), playerid, mtime, reason);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Uciszy≥eú(aú) %s (ID: %d) na %d min, powÛd: %s", PlayerName(gracz), gracz, mtime, reason);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:munmute(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "d", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /munmute [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	Muted[gracz] = 0;
	KillTimer(MuteTimer[gracz]);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) odciszy≥(a) ciÍ", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Odciszy≥eú(aú) %s (ID: %d)", PlayerName(gracz), gracz);
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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "idd", gracz, bron, ammo)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mgivegun [ID] [ID broni] [AMMO]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(bron > 46 || bron < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídne ID broni [1-46]");

	if(ammo > 99999999 || ammo < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídna iloúÊ amuicji [1-99999999]");

	GivePlayerWeapon(gracz, bron, ammo);

	GetWeaponName(bron, nbron, 32);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) ci broÒ %s (ID: %d) i %d amunicji", PlayerName(playerid), playerid, nbron, bron, ammo);
	SendClientMessage(gracz, COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) broÒ %s (ID: %d) i %d amunicji %s (ID: %d)", nbron, bron, ammo, PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgivegunall(playerid, params[])
{
	new str[256];
	new nbron[32];
	new bron;
	new ammo;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params,"dd",bron, ammo)) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Uøyj /mgivegunall [ID broni] [AMMO]!");

	if(bron > 46 || bron < 0) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídne ID broni [1-46]");

	if(ammo > 99999999 || ammo < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídna iloúÊ amuicji [1-99999999]");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		GivePlayerWeapon(x, bron, ammo);
	}
	GetWeaponName(bron, nbron, 32);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) wszystkim broÒ %s (ID: %d) i %d amunicji", PlayerName(playerid), playerid, nbron, bron, ammo);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) wszystkim broÒ %s (ID: %d) i %d amunicji", nbron, bron, ammo);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mip(playerid, params[])
{
	new str[128];
	new gracz;
	new adips[16];

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mip [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mwersja [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");


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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mincar [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest w øadnym pojeüdzie!");

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

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mrfv [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest w øadnym pojeüdzie!");

	veah = GetPlayerVehicleID(gracz);
	RemovePlayerFromVehicle(gracz);

	format(str, sizeof(str), "[M-INFO] Wyrzuci≥eú(aú) %s (ID %d) z pojazdu %s, (ID: %d)", PlayerName(gracz), gracz, carname[GetVehicleModel(GetPlayerVehicleID(gracz)) - 400], veah);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta≥eú(aú) wyrzucony(a) z pojazdu przez moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrfvall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		RemovePlayerFromVehicle(x);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) wyrzuci≥(a) wszystkich graczy z pojazdÛw", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Wyrzuci≥eú(aú) wszystkich graczy z pojazdÛw");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mcrash(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mcrash [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	SetPlayerSkin(gracz, 555);

	format(str, sizeof(str), "[M-INFO] Wywo≥a≥eú(aú) Crash GTA, %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mkill(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mkill [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie moøesz zabiÊ modaratora poziomu 2!");
	
	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie moøesz zabiÊ Administratora!");
	
	SetPlayerHealth(gracz, 0);

	format(str, sizeof(str), "[M-INFO] Zabi≥eú(aú) gracza %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta≥eú(aú) zabity(a) przez moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mkillall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
		if(Mod[x] < 1 && !IsPlayerAdmin(x))
		{
		SetPlayerHealth(x, 0);
		}
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zabi≥(a) wszystkich graczy z wyjπtkiem moderatorÛw/AdministratorÛw ", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zabi≥eú(aú) wszystkich graczy z wyjπtkiem ModeratorÛw/AdministratorÛw");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mjetpack(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mjetpack [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

    SetPlayerSpecialAction(gracz, SPECIAL_ACTION_USEJETPACK);
    
	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) jetpack'a graczowi %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Otrzyma≥eú(aú) jetpack'a od Moderatora %s (ID: %d)", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mjetpackall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteú Moderatorem poziomu 2!");

	for(new x = 0; x < MAX_GRACZY; x ++)
	{
 		SetPlayerSpecialAction(x, SPECIAL_ACTION_USEJETPACK);
	}

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) da≥(a) wszystkim jetpack", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Da≥eú(aú) wszystkim jetpacka ;O");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mkick(playerid, params[])
{
	new str[128], gracz, Powod[128];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "iu", gracz, Powod)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mkick [ID] [POW”D]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");
	
	if(gracz == playerid) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie moøesz wyrzuciÊ samego siebie!");

	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie moøesz wyrzuciÊ modaratora poziomu 2!");

	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie moøesz wyrzuciÊ Administratora!");


	format(str, sizeof(str), "[M-INFO] Wyrzuci≥eú %s (ID: %d) z pwowodu : %s", PlayerName(gracz), gracz, Powod);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Zosta≥eú(aú) wyrzucony(a) przez Moderatora %s (ID: %d), z powodu: %s", PlayerName(playerid), playerid, Powod);
	SendClientMessage(gracz, COLOR_LEMON, str);
	
	format(str, sizeof(str), "[INFO] %s (ID: %d) zosta≥(a) wyrzucony(a) przez Moderatora %s (ID: %d) z powodu: %s", PlayerName(gracz), gracz, PlayerName(playerid), playerid, Powod);
	SendClientMessageToAll(COLOR_LEMON, str);

	Kick(gracz);
	return 1;
}

CMD:mnetstats(playerid, params[])
{
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	gNetStatsPlayerId = playerid;
	NetStatsDisplay();
	gNetStatsTimerId = SetTimer("NetStatsDisplay", 2000, true);

	return 1;
}

CMD:mpm(playerid, params[])
{
	new MSG[128];
	new str[128];
	
	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "s[128]", MSG)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mpm [TREå∆]");

    format(str, sizeof(str), "|MOD-CHAT| (%s ID: %d| POZ: %d): %s",PlayerName(playerid), playerid, Mod[playerid], MSG);
	SendClientMessageToMod(0x24FF0AB9, str);
	//0x9E3DFFAA
	return 1;
}

CMD:mvehgod(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mvehgod [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w øadnym pojeüdzie!");
    
    SetVehicleHealth(GetPlayerVehicleID(gracz), 9999999);

	format(str, sizeof(str), "[M-INFO] Zrobi≥eú(aú) graczowi %s (ID: %d) niezniszczalny pojazd", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrobi≥(a) ci niezniszczalny pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mvehgodall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteú Moderatorem poziomu 2!");

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

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) zrobi≥(a) wszystkim niezniszczalne pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Zrobi≥eú(aú) wszystkim niezniszczalne pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mdestroyveh(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mdestroyveh [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w øadnym pojeüdzie!");

    SetVehicleHealth(GetPlayerVehicleID(gracz), 0);

	format(str, sizeof(str), "[M-INFO] Rozwali≥eú(aú) graczowi %s (ID: %d) pojazd", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozwali≥(a) ci pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mdestroyvehall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteú Moderatorem poziomu 2!");

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

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) rozwali≥ wszystkim pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Rozwali≥eú(aú) wszystkim pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mslap(playerid, params[])
{
	new str[128];
	new gracz;
	new Float:HPY;
	new wezHPY;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "ii", gracz, wezHPY)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mslap [ID] [HP 1-10]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");
	
	if(Mod[gracz] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie moøesz uderzyÊ modaratora poziomu 2!");

	if(IsPlayerAdmin(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie moøesz uderzyÊ Administratora!");

	if(wezHPY < 1 || wezHPY > 10) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] B≥Ídna iloúÊ HP ![1-10]");

    GetPlayerHealth(gracz, HPY);
	SetPlayerHealth(gracz, floatround(HPY)-wezHPY);

	format(str, sizeof(str), "[M-INFO] Uderzy≥eú %s (ID: %d) zadajπc %d obraøeÒ", PlayerName(gracz), gracz, wezHPY);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) uderzy≥(a) ciÍ, zadajπc %d obraøeÒ", PlayerName(playerid), playerid, wezHPY);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrepairveh(playerid, params[])
{
	new str[128];
	new gracz;

	if(Mod[playerid] < 1) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem!");

	if(sscanf(params, "i", gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mrepairveh [ID]");

	if(!IsPlayerConnected(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Ten gracz nie jest pod≥πczony!");

    if(!IsPlayerInAnyVehicle(gracz)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Gracz nie znajduje sie w øadnym pojeüdzie!");

    new POJ = GetPlayerVehicleID(gracz);
    RepairVehicle(POJ);
    
	format(str, sizeof(str), "[M-INFO] Naprawi≥eú(aú) pojazd graczowi %s (ID: %d)", PlayerName(gracz), gracz);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) naprawi≥(a) ci pojazd", PlayerName(playerid), playerid);
	SendClientMessage(gracz, COLOR_LEMON, str);
	return 1;
}

CMD:mrepairvehall(playerid, params[])
{
	new str[256];

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN,"[ERROR] Nie jesteú Moderatorem poziomu 2!");

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

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) naprawi≥ wszystkim pojazdy", PlayerName(playerid), playerid);
	SendClientMessageToAll(COLOR_LEMON, str);

	format(str, sizeof(str), "[M-INFO] Naprawi≥es wszystkim pojazdy");
	SendClientMessage(playerid, COLOR_LEMON, str);
	return 1;
}

CMD:mgravity(playerid, params[])
{
	new str[128];
	new gravity;

	if(Mod[playerid] < 2) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Nie jesteú Moderatorem poziomu 2!");

	if(sscanf(params, "i", gravity)) return SendClientMessage(playerid, COLOR_BLUEGREEN, "[ERROR] Uøyj /mgravity [grawitacja] |Domyúlnie - 0.008|");

	SetGravity(gravity);

	format(str, sizeof(str), "[M-INFO] Ustawi≥eú(aú) grawitacje na %d", gravity);
	SendClientMessage(playerid, COLOR_LEMON, str);

	format(str, sizeof(str), "[INFO] Moderator %s (ID: %d) ustawi≥ grawitacje na %d", PlayerName(playerid), playerid, gravity);
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
		if(response)//co ma sie dziaÊ po wybiraniu pierwszej opcji (DALEJ)
		{
  			new Str[1024];

			strcat(Str,"{FFFF00}/msetcashall [kasa] {FFFFFF}- Ustawiasz pieniπdze wszystkim graczom\n");
			strcat(Str,"{FFFF00}/mgivegunall [ID broni] [AMMO] {FFFFFF}- Dajesz broÒ wszystkim graczom\n");
            strcat(Str,"{FFFF00}/mrfvall [ID] {FFFFFF}- Wyrzucasz wszystkich graczy z pojazdu\n");
			strcat(Str,"{FFFF00}/mkick [ID] [PowÛd] {FFFFFF}- Wyrzucasz gracza\n");
			strcat(Str,"{FFFF00}/mvehgodall {FFFFFF}- Dajesz wszystkim niezniszczalne pojazdy\n");
			strcat(Str,"{FFFF00}/mcrash [ID] {FFFFFF}- Wywo≥ujesz Crash'a graczowi\n");
			strcat(Str,"{FFFF00}/mjetpackall {FFFFFF}- Dajesz jetpack wszystkim\n");
			strcat(Str,"{FFFF00}/mdestroyvehall {FFFFFF}- Rozwalasz wszystkim pojazdy\n");
			strcat(Str,"{FFFF00}/mrepairvehall {FFFFFF}- Naprawiasz wszystkim pojazdy\n");
			strcat(Str,"{FFFF00}/mgravity [gravitacja] {FFFFFF}- Ustawiasz grawitacje\n");
		    ShowPlayerDialog(playerid, DIALOG_MCMD2, DIALOG_STYLE_MSGBOX, "{AAFFCC}Komendy Moderatora 2/2 {63AFF0}(Moderator v 1.4 by Czechu)", Str, "Wyjdü", "");
		}
		else if(!response)//co sie ma dziac po wybraniu drugiej opcji (WYJDè)
		{
			//cuú tu powinno byÊ co nie :) ?
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
	SendClientMessage(playerid,COLOR_LEMON,"[INFO] Twoja kara wyciszenia minÍ≥a!");
	return 1;
}
// 		_________________________________________________________
// 	 	|                                                       |
//  	|               KONIEC-KONIEC-KONIEC-KONIEC             |
//		|               KONIEC-KONIEC-KONIEC-KONIEC             |
//		|               KONIEC-KONIEC-KONIEC-KONIEC             |
//  	|_______________________________________________________|

