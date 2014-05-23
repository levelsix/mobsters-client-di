//
//  MSUserStructureDao.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StructDao.h"
#import "UserStruct.h"

@interface UserStructDao : NSObject

@property (nonatomic, retain) NSMutableDictionary *structDict;

@property (nonatomic, retain) StructDao *structDao;

- (void) createUserStructDictWithList:(NSArray *)list;
- (NSArray *) listOfUserStructIds;
- (UserStruct *) userStructWithId:(int)userStructId;

- (UserStruct *) myTownHall;
- (UserStruct *) myLaboratory;
- (UserStruct *) myMiniJobCenter;
- (NSArray *) allHospitals;
- (NSArray *) validHospitals;

@end
