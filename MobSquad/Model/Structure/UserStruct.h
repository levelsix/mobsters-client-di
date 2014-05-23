//
//  MSUserStructure.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStruct : NSObject

@property (nonatomic, assign) int userStructId;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int structId;
@property (nonatomic, assign) int fbInviteStructLvl;
@property (nonatomic, retain) MSDate *lastRetrieved;
@property (nonatomic, assign) CGPoint coordinates;
@property (nonatomic, retain) MSDate *purchaseTime;
@property (nonatomic, assign) BOOL isComplete;
@property (nonatomic, assign) StructOrientation orientation;

- (id) initWithStructProto:(FullUserStructureProto *)proto;

@end
