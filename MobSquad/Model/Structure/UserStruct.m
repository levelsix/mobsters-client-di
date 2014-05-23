//
//  MSUserStructure.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "UserStruct.h"

@implementation UserStruct

- (id) initWithStructProto:(FullUserStructureProto *)proto {
  if ((self = [super init])) {
    self.userStructId = proto.userStructId;
    self.userId = proto.userId;
    self.structId = proto.structId;
    self.isComplete = proto.isComplete;
    self.coordinates = CGPointMake(proto.coordinates.x, proto.coordinates.y);
    self.orientation = proto.orientation;
    self.purchaseTime = proto.hasPurchaseTime ? [MSDate dateWithTimeIntervalSince1970:proto.purchaseTime/1000.0] : nil;
    self.lastRetrieved = proto.hasLastRetrieved ? [MSDate dateWithTimeIntervalSince1970:proto.lastRetrieved/1000.0] : nil;
    self.fbInviteStructLvl = proto.fbInviteStructLvl;
  }
  return self;
}

@end
