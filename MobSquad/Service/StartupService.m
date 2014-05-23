//
//  StartupService.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "StartupService.h"

@implementation StartupService

- (void) startupWithFacebookId:(NSString *)facebookId isFreshRestart:(BOOL)isFreshRestart delegate:(id)delegate {
  int tag = [self.socketCommunication sendStartupMessageWithFacebookId:facebookId isFreshRestart:isFreshRestart clientTime:[self getCurrentMilliseconds]];
  [self.socketCommunication setDelegate:delegate forTag:tag];
}

@end
