#include <sourcemod>
#include <sdktools>
#include <emitsoundany>

#define VERSION "1.1.2"

static Handle:timer = INVALID_HANDLE;
static notification_number;

public Plugin:myinfo = {

	name = "SM ZR/ZE count down",
	author = "yoshino(Maoling)",
	description = "countdown and sound",
	version = VERSION,
	url = "xqy@tiara.moe"
}

public OnPluginStart() 
{
	HookEvent("round_freeze_end", on_round_start);
}

public OnMapStart()
{
	//Download and Precache
	AddFileToDownloadsTable("sound/cg/ze/1.mp3");
	AddFileToDownloadsTable("sound/cg/ze/2.mp3");
	AddFileToDownloadsTable("sound/cg/ze/3.mp3");
	AddFileToDownloadsTable("sound/cg/ze/4.mp3");
	AddFileToDownloadsTable("sound/cg/ze/5.mp3");
	AddFileToDownloadsTable("sound/cg/ze/6.mp3");
	AddFileToDownloadsTable("sound/cg/ze/7.mp3");
	AddFileToDownloadsTable("sound/cg/ze/8.mp3");
	AddFileToDownloadsTable("sound/cg/ze/9.mp3");
	AddFileToDownloadsTable("sound/cg/ze/10.mp3");

	PrecacheSoundAny("cg/ze/1.mp3", true);
	PrecacheSoundAny("cg/ze/2.mp3", true);
	PrecacheSoundAny("cg/ze/3.mp3", true);
	PrecacheSoundAny("cg/ze/4.mp3", true);
	PrecacheSoundAny("cg/ze/5.mp3", true);
	PrecacheSoundAny("cg/ze/6.mp3", true);
	PrecacheSoundAny("cg/ze/7.mp3", true);
	PrecacheSoundAny("cg/ze/8.mp3", true);
	PrecacheSoundAny("cg/ze/9.mp3", true);
	PrecacheSoundAny("cg/ze/10.mp3", true);
}

public on_round_start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	if (timer != INVALID_HANDLE)
		CloseHandle(timer);
	notification_number = RoundToZero(GetConVarFloat(FindConVar("zr_infect_spawntime_max")));   // Depend on zr_infect_spawntime_max == zr_infect_spawntime_min
	timer = CreateTimer(1.0, countdown_timer);
}

public OnMapEnd() 
{
	if (timer != INVALID_HANDLE) {
		CloseHandle(timer);
		timer = INVALID_HANDLE;
	}
}

public Action:countdown_timer(Handle:timer_) 
{
	if (notification_number > 0) 
	{
		if (notification_number == 10)
		{
			EmitSoundToAllAny("cg/ze/10.mp3");
		}
		
		if (notification_number == 9)
		{
			EmitSoundToAllAny("cg/ze/9.mp3");
		}
		
		if (notification_number == 8)
		{
			EmitSoundToAllAny("cg/ze/8.mp3");
		}
		
		if (notification_number == 7)
		{
			EmitSoundToAllAny("cg/ze/7.mp3");
		}
		
		if (notification_number == 6)
		{
			EmitSoundToAllAny("cg/ze/6.mp3");
		}
		
		if (notification_number == 5)
		{
			EmitSoundToAllAny("cg/ze/5.mp3");
		}
		
		if (notification_number == 4)
		{
			EmitSoundToAllAny("cg/ze/4.mp3");
		}
		
		if (notification_number == 3)
		{
			EmitSoundToAllAny("cg/ze/3.mp3");
		}
		
		if (notification_number == 2)
		{
			EmitSoundToAllAny("cg/ze/2.mp3");
		}
		
		if (notification_number == 1)
		{
			EmitSoundToAllAny("cg/ze/1.mp3");
		}

		PrintHintTextToAll("<font color='#0066CC'>病毒正在寻找宿主,尸变将在\n</font><font color='#993300'>　　　　　%d秒\n</font><font color='#0066CC'>后发生，届时母体僵尸出现！</font>", notification_number);	// Set ur like
		timer = CreateTimer(1.0, countdown_timer);
		--notification_number;		
	}
	else 
	{
		timer = INVALID_HANDLE;
		PrintHintTextToAll("<font color='#993300'>　　　　病毒宿主已经出现\n　\n</font><font color='#0066CC'>积极断后,拒绝贴门,慎用神器,严防贴边!");	// Set ur like
	}
}