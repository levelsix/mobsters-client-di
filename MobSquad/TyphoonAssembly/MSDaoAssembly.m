//
//  MSDaoAssembly.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MSDaoAssembly.h"

#import "UserDao.h"
#import "UserStructDao.h"

@implementation MSDaoAssembly

- (id) userDao {
  return [TyphoonDefinition withClass:[UserDao class] configuration:^(TyphoonDefinition* definition) {
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (id) userStructureDao {
  return [TyphoonDefinition withClass:[UserStructDao class] configuration:^(TyphoonDefinition* definition) {
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (id) structureDao {
  return [TyphoonDefinition withClass:[StructDao class] configuration:^(TyphoonDefinition* definition) {
    definition.scope = TyphoonScopeSingleton;
  }];
}

@end
