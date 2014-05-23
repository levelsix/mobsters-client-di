//
//  BaseService.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "BaseService.h"

@implementation BaseService

- (uint64_t) getCurrentMilliseconds {
  return ((uint64_t)[[MSDate date] timeIntervalSince1970])*1000;
}

@end
