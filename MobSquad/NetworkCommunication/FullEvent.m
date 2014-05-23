//
//  FullEvent.m
//  Utopia
//
//  Created by Ashwin Kamath on 6/22/12.
//  Copyright (c) 2012 LVL6. All rights reserved.
//

#import "FullEvent.h"

@implementation FullEvent

@synthesize event;
@synthesize tag;

+ (id) createWithEvent:(PBGeneratedMessage *)e tag:(int)t {
  return [[self alloc] initWithEvent:e tag:t];
}

- (id) initWithEvent:(PBGeneratedMessage *)e tag:(int)t {
  if ((self = [super init])) {
    self.event = e;
    self.tag = t;
  }
  return self;
}

+ (id) createWithEvent:(PBGeneratedMessage *)e tag:(int)t requestType:(EventProtocolRequest)requestType {
  return [[self alloc] initWithEvent:e tag:t requestType:requestType];
}

- (id) initWithEvent:(PBGeneratedMessage *)e tag:(int)t requestType:(EventProtocolRequest)requestType {
  if ((self = [super init])) {
    self.event = e;
    self.tag = t;
    self.requestType = requestType;
  }
  return self;
}

+ (Class) getClassForType:(EventProtocolResponse)type {
  // This is very hacky but I suppose necessary.. :/
  Class responseClass;
  switch (type) {
    case EventProtocolResponseSUserCreateEvent:
      responseClass = [UserCreateResponseProto class];
      break;
    case EventProtocolResponseSStartupEvent:
      responseClass = [StartupResponseProto class];
      break;
    case EventProtocolResponseSLevelUpEvent:
      responseClass = [LevelUpResponseProto class];
      break;
    case EventProtocolResponseSInAppPurchaseEvent:
      responseClass = [InAppPurchaseResponseProto class];
      break;
    case EventProtocolResponseSUpdateClientUserEvent:
      responseClass = [UpdateClientUserResponseProto class];
      break;
    case EventProtocolResponseSPurchaseNormStructureEvent:
      responseClass = [PurchaseNormStructureResponseProto class];
      break;
    case EventProtocolResponseSMoveOrRotateNormStructureEvent:
      responseClass = [MoveOrRotateNormStructureResponseProto class];
      break;
    case EventProtocolResponseSUpgradeNormStructureEvent:
      responseClass = [UpgradeNormStructureResponseProto class];
      break;
    case EventProtocolResponseSNormStructWaitCompleteEvent:
      responseClass = [NormStructWaitCompleteResponseProto class];
      break;
    case EventProtocolResponseSFinishNormStructWaittimeWithDiamondsEvent:
      responseClass = [FinishNormStructWaittimeWithDiamondsResponseProto class];
      break;
    case EventProtocolResponseSRetrieveCurrencyFromNormStructureEvent:
      responseClass = [RetrieveCurrencyFromNormStructureResponseProto class];
      break;
    case EventProtocolResponseSLoadPlayerCityEvent:
      responseClass = [LoadPlayerCityResponseProto class];
      break;
    case EventProtocolResponseSLoadCityEvent:
      responseClass = [LoadCityResponseProto class];
      break;
    case EventProtocolResponseSQuestAcceptEvent:
      responseClass = [QuestAcceptResponseProto class];
      break;
    case EventProtocolResponseSQuestRedeemEvent:
      responseClass = [QuestRedeemResponseProto class];
      break;
    case EventProtocolResponseSQuestProgressEvent:
      responseClass = [QuestProgressResponseProto class];
      break;
    case EventProtocolResponseSRetrieveUsersForUserIdsEvent:
      responseClass = [RetrieveUsersForUserIdsResponseProto class];
      break;
    case EventProtocolResponseSReferralCodeUsedEvent:
      responseClass = [ReferralCodeUsedResponseProto class];
      break;
    case EventProtocolResponseSEnableApnsEvent:
      responseClass = [EnableAPNSResponseProto class];
      break;
    case EventProtocolResponseSEarnFreeDiamondsEvent:
      responseClass = [EarnFreeDiamondsResponseProto class];
      break;
    case EventProtocolResponseSPurgeStaticDataEvent:
      responseClass = [PurgeClientStaticDataResponseProto class];
      break;
    case EventProtocolResponseSSendGroupChatEvent:
      responseClass = [SendGroupChatResponseProto class];
      break;
    case EventProtocolResponseSReceivedGroupChatEvent:
      responseClass = [ReceivedGroupChatResponseProto class];
      break;
    case EventProtocolResponseSCreateClanEvent:
      responseClass = [CreateClanResponseProto class];
      break;
    case EventProtocolResponseSApproveOrRejectRequestToJoinClanEvent:
      responseClass = [ApproveOrRejectRequestToJoinClanResponseProto class];
      break;
    case EventProtocolResponseSLeaveClanEvent:
      responseClass = [LeaveClanResponseProto class];
      break;
    case EventProtocolResponseSRequestJoinClanEvent:
      responseClass = [RequestJoinClanResponseProto class];
      break;
    case EventProtocolResponseSRetractRequestJoinClanEvent:
      responseClass = [RetractRequestJoinClanResponseProto class];
      break;
    case EventProtocolResponseSRetrieveClanInfoEvent:
      responseClass = [RetrieveClanInfoResponseProto class];
      break;
    case EventProtocolResponseSTransferClanOwnership:
      responseClass = [TransferClanOwnershipResponseProto class];
      break;
    case EventProtocolResponseSChangeClanSettingsEvent:
      responseClass = [ChangeClanSettingsResponseProto class];
      break;
    case EventProtocolResponseSPromoteDemoteClanMemberEvent:
      responseClass = [PromoteDemoteClanMemberResponseProto class];
      break;
    case EventProtocolResponseSBootPlayerFromClanEvent:
      responseClass = [BootPlayerFromClanResponseProto class];
      break;
    case EventProtocolResponseSExpansionWaitCompleteEvent:
      responseClass = [ExpansionWaitCompleteResponseProto class];
      break;
    case EventProtocolResponseSPurchaseCityExpansionEvent:
      responseClass = [PurchaseCityExpansionResponseProto class];
      break;
    case EventProtocolResponseSSendAdminMessageEvent:
      responseClass = [SendAdminMessageResponseProto class];
      break;
    case EventProtocolResponseSGeneralNotificationEvent:
      responseClass = [GeneralNotificationResponseProto class];
      break;
    case EventProtocolResponseSRetrieveTournamentRankingsEvent:
      responseClass = [RetrieveTournamentRankingsResponseProto class];
      break;
    case EventProtocolResponseSSubmitMonsterEnhancementEvent:
      responseClass = [SubmitMonsterEnhancementResponseProto class];
      break;
    case EventProtocolResponseSEnhancementWaitTimeCompleteEvent:
      responseClass = [EnhancementWaitTimeCompleteResponseProto class];
      break;
    case EventProtocolResponseSPurchaseBoosterPackEvent:
      responseClass = [PurchaseBoosterPackResponseProto class];
      break;
    case EventProtocolResponseSReceivedRareBoosterPurchaseEvent:
      responseClass = [ReceivedRareBoosterPurchaseResponseProto class];
      break;
    case EventProtocolResponseSPrivateChatPostEvent:
      responseClass = [PrivateChatPostResponseProto class];
      break;
    case EventProtocolResponseSRetrievePrivateChatPostEvent:
      responseClass = [RetrievePrivateChatPostsResponseProto class];
      break;
    case EventProtocolResponseSBeginDungeonEvent:
      responseClass = [BeginDungeonResponseProto class];
      break;
    case EventProtocolResponseSReviveInDungeonEvent:
      responseClass = [ReviveInDungeonResponseProto class];
      break;
    case EventProtocolResponseSEndDungeonEvent:
      responseClass = [EndDungeonResponseProto class];
      break;
    case EventProtocolResponseSHealMonsterEvent:
      responseClass = [HealMonsterResponseProto class];
      break;
    case EventProtocolResponseSAddMonsterToBattleTeamEvent:
      responseClass = [AddMonsterToBattleTeamResponseProto class];
      break;
    case EventProtocolResponseSIncreaseMonsterInventorySlotEvent:
      responseClass = [IncreaseMonsterInventorySlotResponseProto class];
      break;
    case EventProtocolResponseSRemoveMonsterFromBattleTeamEvent:
      responseClass = [RemoveMonsterFromBattleTeamResponseProto class];
      break;
    case EventProtocolResponseSUpdateMonsterHealthEvent:
      responseClass = [UpdateMonsterHealthResponseProto class];
      break;
    case EventProtocolResponseSCombineUserMonsterPiecesEvent:
      responseClass = [CombineUserMonsterPiecesResponseProto class];
      break;
    case EventProtocolResponseSSellUserMonsterEvent:
      responseClass = [SellUserMonsterResponseProto class];
      break;
    case EventProtocolResponseSInviteFbFriendsForSlotsEvent:
      responseClass = [InviteFbFriendsForSlotsResponseProto class];
      break;
    case EventProtocolResponseSAcceptAndRejectFbInviteForSlotsEvent:
      responseClass = [AcceptAndRejectFbInviteForSlotsResponseProto class];
      break;
    case EventProtocolResponseSExchangeGemsForResourcesEvent:
      responseClass = [ExchangeGemsForResourcesResponseProto class];
      break;
    case EventProtocolResponseSEvolveMonsterEvent:
      responseClass = [EvolveMonsterResponseProto class];
      break;
    case EventProtocolResponseSEvolutionFinishedEvent:
      responseClass = [EvolutionFinishedResponseProto class];
      break;
    case EventProtocolResponseSQueueUpEvent:
      responseClass = [QueueUpResponseProto class];
      break;
    case EventProtocolResponseSUpdateUserCurrencyEvent:
      responseClass = [UpdateUserCurrencyResponseProto class];
      break;
    case EventProtocolResponseSBeginPvpBattleEvent:
      responseClass = [BeginPvpBattleResponseProto class];
      break;
    case EventProtocolResponseSBeginClanRaidEvent:
      responseClass = [BeginClanRaidResponseProto class];
      break;
    case EventProtocolResponseSAttackClanRaidMonsterEvent:
      responseClass = [AttackClanRaidMonsterResponseProto class];
      break;
    case EventProtocolResponseSSetGameCenterIdEvent:
      responseClass = [SetGameCenterIdResponseProto class];
      break;
    case EventProtocolResponseSSetFacebookIdEvent:
      responseClass = [SetFacebookIdResponseProto class];
      break;
    case EventProtocolResponseSEndPvpBattleEvent:
      responseClass = [EndPvpBattleResponseProto class];
      break;
    case EventProtocolResponseSForceLogoutEvent:
      responseClass = [ForceLogoutResponseProto class];
      break;
    case EventProtocolResponseSSpawnObstacleEvent:
      responseClass = [SpawnObstacleResponseProto class];
      break;
    case EventProtocolResponseSBeginObstacleRemovalEvent:
      responseClass = [BeginObstacleRemovalResponseProto class];
      break;
    case EventProtocolResponseSObstacleRemovalCompleteEvent:
      responseClass = [ObstacleRemovalCompleteResponseProto class];
      break;
    case EventProtocolResponseSAchievementProgressEvent:
      responseClass = [AchievementProgressResponseProto class];
      break;
    case EventProtocolResponseSAchievementRedeemEvent:
      responseClass = [AchievementRedeemResponseProto class];
      break;
    case EventProtocolResponseSSpawnMiniJobEvent:
      responseClass = [SpawnMiniJobResponseProto class];
      break;
    case EventProtocolResponseSBeginMiniJobEvent:
      responseClass = [BeginMiniJobResponseProto class];
      break;
    case EventProtocolResponseSCompleteMiniJobEvent:
      responseClass = [CompleteMiniJobResponseProto class];
      break;
    case EventProtocolResponseSRedeemMiniJobEvent:
      responseClass = [RedeemMiniJobResponseProto class];
      break;
      
    default:
      responseClass = nil;
      break;
  }
  return responseClass;
}

+ (BOOL) isEventTypeClanEvent:(EventProtocolResponse)eventType {
  switch (eventType) {
    case EventProtocolResponseSApproveOrRejectRequestToJoinClanEvent:
    case EventProtocolResponseSPromoteDemoteClanMemberEvent:
    case EventProtocolResponseSCreateClanEvent:
    case EventProtocolResponseSChangeClanSettingsEvent:
    case EventProtocolResponseSLeaveClanEvent:
    case EventProtocolResponseSRequestJoinClanEvent:
    case EventProtocolResponseSRetractRequestJoinClanEvent:
    case EventProtocolResponseSBootPlayerFromClanEvent:
    case EventProtocolResponseSTransferClanOwnership:
      return YES;
      break;
      
    default:
      return NO;
      break;
  }
}

@end
