#include <sdktools>

#pragma newdecls required

Handle g_hTimer;
int notification_number;
bool g_bEnable;

public Plugin myinfo = {

	name = "SM ZR/ZE count down",
	author = "Kyle",
	description = "countdown and sound",
	version = "3.0",
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
	PrepareSound();

	g_bEnable = false;
	CreateTimer(GetConVarFloat(FindConVar("mp_warmuptime")), Timer_Warmup, _, TIMER_FLAG_NO_MAPCHANGE);
	SetConVarFloat(FindConVar("zr_infect_spawntime_min"), GetConVarFloat(FindConVar("zr_infect_spawntime_max")));
}

public void OnMapEnd()
{
	if(g_hTimer != INVALID_HANDLE)
	{
		KillTimer(g_hTimer);
		g_hTimer = INVALID_HANDLE;
	}
}

public Action Timer_Warmup(Handle timer)
{
	g_bEnable = true;
}

public Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast) 
{
	if(g_hTimer != INVALID_HANDLE)
	{
		KillTimer(g_hTimer);
		g_hTimer = INVALID_HANDLE;
	}
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
		Format(szSound, 32, "*zr/countdown/%d.mp3", notification_number)
		SoundToAll(szSound);
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

void PrepareSound()
{
	char szPath[2][128];
	for(int x = 1; x <= 10; ++x)
	{
		Format(szPath[0], 128, "*zr/countdown/%d.mp3", x);
		Format(szPath[1], 128, "sound/countdown/%d.mp3", x);

		AddToStringTable(FindStringTable("soundprecache"), szPath[0]);
		AddFileToDownloadsTable(szPath[1]);
	}
}

stock void SoundToAll(const char[] SOUND)
{
	int[] targets = new int[MaxClients];
	int total = 0;
	
	for(int i=1; i <= MaxClients; i++)
		if(IsClientInGame(i))
			targets[total++] = i;
			
	if(!total) return;

	EmitSound(targets, total, SOUND, SOUND_FROM_WORLD);
}

stock void tPrintHintTextToAll(const char[] szMessage, any ...)
{
	char szBuffer[256];
	
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			SetGlobalTransTarget(i);
			VFormat(szBuffer, 256, szMessage, 2);
			PrintHintText(i, szBuffer);
		}
	}
}