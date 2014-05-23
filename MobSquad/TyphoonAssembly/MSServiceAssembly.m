//
//  MSServiceAssembly.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MSServiceAssembly.h"

#import "StartupService.h"
#import "StructService.h"

@implementation MSServiceAssembly

- (id) baseService {
  return [TyphoonDefinition withClass:[BaseService class] configuration:^(TyphoonDefinition *definition) {
    [definition injectProperty:@selector(socketCommunication)];
  }];
}

- (id) startupService {
  return [TyphoonDefinition withClass:[StartupService class] configuration:^(TyphoonDefinition *definition) {
    definition.parent = [self baseService];
  }];
}

- (id) structService {
  return [TyphoonDefinition withClass:[StructService class] configuration:^(TyphoonDefinition *definition) {
    definition.parent = [self baseService];
  }];
}

@end
