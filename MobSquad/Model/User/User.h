//
//  User.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, assign) int userId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int gems;
@property (nonatomic, assign) int cash;
@property (nonatomic, assign) int oil;
@property (nonatomic, assign) int experience;
@property (nonatomic, assign) int numReferrals;
@property (nonatomic, assign) int elo;
@property (nonatomic, assign) int playerHasBoughtInAppPurchase;
@property (nonatomic, assign) BOOL isAdmin;
@property (nonatomic, retain) MSDate *createTime;
@property (nonatomic, assign) int numBeginnerSalesPurchased;
@property (nonatomic, retain) MSDate *shieldEndTime;
@property (nonatomic, retain) MSDate *lastObstacleCreateTime;
@property (nonatomic, retain) MSDate *lastMiniJobSpawnTime;

@property (nonatomic, copy) NSString *udid;
@property (nonatomic, copy) NSString *facebookId;

@property (nonatomic, retain) MinimumClanProto *clan;

@property (nonatomic, retain) UserPvpLeagueProto *pvpLeague;

@property (nonatomic, retain) MSDate *lastLogoutTime;
@property (nonatomic, assign) int64_t lastLoginTimeNum;

- (void) syncWithFullUserProto:(FullUserProto *)user;
- (MinimumUserProto *) convertToMinimumUserProto;

@end
