//
//  MSNotificationKeys.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IAP_DEFAULTS_KEY @"Unresponded In Apps"

#define LAST_LEAGUE_SHOWN_DEFAULTS_KEY @"LastLeagueShownKey"

#define MUSIC_DEFAULTS_KEY @"MusicDefaultsKey"
#define SOUND_EFFECTS_DEFAULTS_KEY @"SoundEffectsDefaultsKey"
#define SHAKE_DEFAULTS_KEY @"ShakeDefaultsKey"

#define IAP_SUCCESS_NOTIFICATION @"IapSuccessNotification"

#define HEAL_WAIT_COMPLETE_NOTIFICATION @"HealWaitCompleteNotification"
#define MONSTER_QUEUE_CHANGED_NOTIFICATION @"MonsterQueueChangedNotification"
#define ENHANCE_WAIT_COMPLETE_NOTIFICATION @"EnhanceWaitCompleteNotification"
#define EVOLUTION_WAIT_COMPLETE_NOTIFICATION @"EvolutionWaitCompleteNotification"
#define COMBINE_WAIT_COMPLETE_NOTIFICATION @"CombineWaitCompleteNotification"
#define MINI_JOB_WAIT_COMPLETE_NOTIFICATION @"MiniJobWaitCompleteNotification"
#define MONSTER_SOLD_COMPLETE_NOTIFICATION @"MonsterSoldNotification"

#define USER_STRUCTS_CHANGED_NOTIFICATION @"UserStructsChangedNotification"

#define GAMESTATE_UPDATE_NOTIFICATION @"GameStateUpdateNotification"

#define MY_TEAM_CHANGED_NOTIFICATION @"MyTeamChangedNotification"

#define GLOBAL_CHAT_RECEIVED_NOTIFICATION @"GlobalChatReceivedNotification"
#define CLAN_CHAT_RECEIVED_NOTIFICATION @"ClanChatReceivedNotification"
#define PRIVATE_CHAT_RECEIVED_NOTIFICATION @"PrivateChatReceivedNotification"

#define NEW_FB_INVITE_NOTIFICATION @"NewFbInviteNotification"
#define FB_INVITE_RESPONDED_NOTIFICATION @"FbInviteRespondedNotification"
#define FB_INVITE_ACCEPTED_NOTIFICATION @"FbInviteAcceptedNotification"
#define FB_INCREASE_SLOTS_NOTIFICATION @"FbIncreaseSlotsNotification"

#define NEW_BATTLE_HISTORY_NOTIFICATION @"NewBattleHistoryNotification"
#define BATTLE_HISTORY_VIEWED_NOTIFICATION @"BattleHistoryViewedNotification"

#define QUESTS_CHANGED_NOTIFICATION @"QuestsChangedNotification"
#define ACHIEVEMENTS_CHANGED_NOTIFICATION @"AchievementsChangedNotification"

#define MY_CLAN_MEMBERS_LIST_NOTIFICATION @"MyClanMembersListNotification"
#define CLAN_RAID_ATTACK_NOTIFICATION @"ClanRaidAttackNotification"

#define NEW_OBSTACLES_CREATED_NOTIFICATION @"NewObstaclesCreatedNotification"

#define MY_CLAN_MEMBERS_LIST_KEY @"MyMembersList"
#define CLAN_RAID_ATTACK_KEY @"ClanRaidAttackKey"

#define OBSERVE_NOTIFICATION_OBJ(n, s, o) [[NSNotificationCenter defaultCenter] addObserver:self selector:s name:n object:o]
#define OBSERVE_NOTIFICATION(n, s) OBSERVE_NOTIFICATION_OBJ(n, s, nil)
#define POST_NOTIFICATION_OBJ(n, o) [[NSNotificationCenter defaultCenter] postNotificationName:n object:o]
#define POST_NOTIFICATION(n) POST_NOTIFICATION_OBJ(n, nil)
#define UNOBSERVE_ALL_NOTIFICATIONS [[NSNotificationCenter defaultCenter] removeObserver:self]
