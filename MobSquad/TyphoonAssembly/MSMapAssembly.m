//
//  MSMapAssembly.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MSMapAssembly.h"

#import "HomeMapController.h"
#import "HomeMap.h"

@implementation MSMapAssembly

- (id) homeMap {
  return [TyphoonDefinition withClass:[HomeMap class] configuration:^(TyphoonDefinition *definition) {
    [definition useInitializer:@selector(initWithFile:) parameters:^(TyphoonMethod *initializer) {
      [initializer injectParameterWith:@"home.tmx"];
    }];
  }];
}

- (id) homeMapController {
  return [TyphoonDefinition withClass:[HomeMapController class] configuration:^(TyphoonDefinition* definition) {
    [definition injectProperty:@selector(map) with:[self homeMap]];
    [definition injectProperty:@selector(userStructDao) with:[_daoAssembly userStructureDao]];
    [definition injectProperty:@selector(structDao) with:[_daoAssembly structureDao]];
  }];
}

@end
