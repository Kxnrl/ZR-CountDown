#include <sourcemod>
#include <sdktools>
#include <emitsoundany>
#include <maoling>

#pragma newdecls required

Handle g_hTimer;
int notification_number;
bool g_bEnable;

public Plugin myinfo = {

	name = "SM ZR/ZE count down",
	author = "maoling ( xQy )",
	description = "countdown and sound",
	version = "2.0",
	url = "https://irelia.me"
}

public void OnPluginStart() 
{
	HookEvent("round_freeze_end", Event_RoundStart);
	HookEvent("round_end", Event_RoundStart);
	LoadTranslations("countdown.phrases");
}

public void OnMapStart()
{
	g_bEnable = false;
	CreateTimer(GetConVarFloat(FindConVar("mp_warmuptime")), Timer_Warmup, _, TIMER_FLAG_NO_MAPCHANGE);
	SetConVarFloat(FindConVar("zr_infect_spawntime_min"), GetConVarFloat(FindConVar("zr_infect_spawntime_max")));
}

public void OnMapEnd()
{
	ClearTimer(g_hTimer);
}

public Action Timer_Warmup(Handle timer)
{
	g_bEnable = true;
}

public Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast) 
{
	ClearTimer(g_hTimer);
	if(StrContains(name, "freeze") == -1)
		return;
	notification_number = RoundToZero(GetConVarFloat(FindConVar("zr_infect_spawntime_max")));
	if(g_bEnable) g_hTimer = CreateTimer(1.0, Timer_CountDown);
}

public Action Timer_CountDown(Handle timer) 
{
	if(notification_number > 0) 
	{
		char szSound[32];
		Format(szSound, 32, "zr/countdown/%d.mp3", notification_number)
		EmitSoundToAllAny(szSound);
		tPrintHintTextToAll("%t", "mother infect countdown", notification_number);
		--notification_number;
		g_hTimer = CreateTimer(1.0, Timer_CountDown);
	}
	else 
	{
		tPrintHintTextToAll("%t", "first infected");
		g_hTimer = INVALID_HANDLE;
	}
}