//
//  StructDao.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StaticStructure.h"

@interface StructDao : NSObject

@property (nonatomic, retain) NSDictionary *structures;

- (void) createStructDictFromList:(NSArray *)structs;
- (id) structForId:(int)structId;

@end
