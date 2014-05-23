//
//  User.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "User.h"

@implementation User

- (void) syncWithFullUserProto:(FullUserProto *)user {
  self.userId = user.userId;
  self.name = user.name;
  self.clan = user.clan;
  self.level = user.level;
  self.gems = user.gems;
  self.cash = user.cash;
  self.oil = user.oil;
  self.experience = user.experience;
  self.numReferrals = user.numReferrals;
  self.isAdmin = user.isAdmin;
  self.numBeginnerSalesPurchased = user.numBeginnerSalesPurchased;
  self.createTime = [MSDate dateWithTimeIntervalSince1970:user.createTime/1000.0];
  self.lastObstacleCreateTime = [MSDate dateWithTimeIntervalSince1970:user.lastObstacleSpawnedTime/1000.0];
  self.lastMiniJobSpawnTime = [MSDate dateWithTimeIntervalSince1970:user.lastMiniJobSpawnedTime/1000.0];
  if (user.hasFacebookId) self.facebookId = user.facebookId;
  
  self.lastLogoutTime = [MSDate dateWithTimeIntervalSince1970:user.lastLogoutTime/1000.0];
  self.lastLoginTimeNum = user.lastLoginTime;
  
  if (user.hasPvpLeagueInfo) {
    self.pvpLeague = user.pvpLeagueInfo;
    self.shieldEndTime = [MSDate dateWithTimeIntervalSince1970:user.pvpLeagueInfo.shieldEndTime/1000.0];
  }
}

- (MinimumUserProto *) convertToMinimumUserProto {
  MinimumUserProto *mup = [[[[[MinimumUserProto builder]
                             setUserId:_userId]
                            setName:_name]
                            setClan:_clan]
                           build];
  
  return mup;
}

@end
