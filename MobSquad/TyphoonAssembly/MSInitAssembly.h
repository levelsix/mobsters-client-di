//
//  MSInitAssembly.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/16/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "TyphoonAssembly.h"

#import "MSDaoAssembly.h"

@interface MSInitAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) MSDaoAssembly *daoAssembly;

- (id) staticDataController;
- (id) rootViewController;
- (id) socketCommunication;

@end
