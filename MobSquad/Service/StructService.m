//
//  StructService.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "StructService.h"

@implementation StructService

- (void) loadPlayerCity:(int)userId delegate:(id)delegate {
  int tag = [self.socketCommunication sendLoadPlayerCityMessage:userId];
  [self.socketCommunication setDelegate:delegate forTag:tag];
}

@end
