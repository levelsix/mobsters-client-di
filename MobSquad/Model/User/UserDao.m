//
//  UserDao.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "UserDao.h"

@implementation UserDao

- (id) init {
  if ((self = [super init])) {
    self.myUser = [[User alloc] init];
  }
  return self;
}

@end
