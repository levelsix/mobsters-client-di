//
//  MSUserStructureDao.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "UserStructDao.h"

@implementation UserStructDao

- (void) createUserStructDictWithList:(NSArray *)list {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  for (FullUserStructureProto *proto in list) {
    UserStruct *us = [[UserStruct alloc] initWithStructProto:proto];
    [dict setObject:us forKey:@(us.structId)];
  }
  self.structDict = dict;
  
  POST_NOTIFICATION(USER_STRUCTS_CHANGED_NOTIFICATION);
}

- (NSArray *) listOfUserStructIds {
  return [self.structDict allKeys];
}

- (UserStruct *) userStructWithId:(int)userStructId {
  return self.structDict[@(userStructId)];
}

- (UserStruct *) myTownHall {
  for (UserStruct *us in self.structDict.allValues) {
    id<StaticStructure> ss = [self.structDao structForId:us.structId];
    if (ss.structInfo.structType == StructureInfoProto_StructTypeTownHall) {
      return us;
    }
  }
  return nil;
}

- (UserStruct *) myLaboratory {
  for (UserStruct *us in self.structDict.allValues) {
    id<StaticStructure> ss = [self.structDao structForId:us.structId];
    if (ss.structInfo.structType == StructureInfoProto_StructTypeLab) {
      return us;
    }
  }
  return nil;
}

- (UserStruct *) myMiniJobCenter {
  for (UserStruct *us in self.structDict.allValues) {
    id<StaticStructure> ss = [self.structDao structForId:us.structId];
    if (ss.structInfo.structType == StructureInfoProto_StructTypeMiniJob) {
      return us;
    }
  }
  return nil;
}

- (NSArray *) allHospitals {
  NSMutableArray *allHospitals = [NSMutableArray array];
  for (UserStruct *us in self.structDict.allValues) {
    id<StaticStructure> ss = [self.structDao structForId:us.structId];
    if (ss.structInfo.structType == StructureInfoProto_StructTypeHospital) {
      [allHospitals addObject:us];
    }
  }
  return allHospitals;
}

- (NSArray *) validHospitals {
  NSMutableArray *arr = [NSMutableArray array];
  for (UserStruct *us in self.structDict.allValues) {
    id<StaticStructure> ss = [self.structDao structForId:us.structId];
    if (ss.structInfo.structType == StructureInfoProto_StructTypeHospital && us.isComplete) {
      [arr addObject:us];
    }
  }
  [arr sortUsingComparator:^NSComparisonResult(UserStruct *obj1, UserStruct *obj2) {
    HospitalProto *hosp1 = [self.structDao structForId:obj1.structId];
    HospitalProto *hosp2 = [self.structDao structForId:obj2.structId];
    return [@(hosp2.healthPerSecond) compare:@(hosp1.healthPerSecond)];
  }];
  return arr;
}

@end
