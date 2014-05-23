//
//  StructService.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "BaseService.h"

@interface StructService : BaseService

- (void) loadPlayerCity:(int)playerId delegate:(id)delegate;

@end
