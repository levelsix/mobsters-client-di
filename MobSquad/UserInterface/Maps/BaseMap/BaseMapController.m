//
//  MSTiledMapController.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "BaseMapController.h"

@implementation BaseMapController

- (void) typhoonDidInject {
  self.map.delegate = self;
  
  [self addChild:self.map];
}

@end
