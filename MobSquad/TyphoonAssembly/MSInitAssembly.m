//
//  MSInitAssembly.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/16/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MSInitAssembly.h"

#import "MSRootViewController.h"
#import "SocketCommunication.h"
#import "StartupController.h"
#import "StaticDataController.h"

@implementation MSInitAssembly

- (id) startupController {
  return [TyphoonDefinition withClass:[StartupController class]];
}

- (id) staticDataController {
  return [TyphoonDefinition withClass:[StaticDataController class]];
}

- (id) rootViewController {
  return [TyphoonDefinition withClass:[MSRootViewController class] configuration:^(TyphoonDefinition* definition) {
    [definition injectProperty:@selector(startupController) with:[self startupController]];
    definition.scope = TyphoonScopeSingleton;
  }];
}

- (id) socketCommunication {
  return [TyphoonDefinition withClass:[SocketCommunication class] configuration:^(TyphoonDefinition* definition) {
    [definition injectProperty:@selector(userDao) with:[self.daoAssembly userDao]];
    definition.scope = TyphoonScopeSingleton;
  }];
}

@end
