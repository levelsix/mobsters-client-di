//
//  StartupService.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "BaseService.h"

@interface StartupService : BaseService

- (void) startupWithFacebookId:(NSString *)facebookId isFreshRestart:(BOOL)isFreshRestart delegate:(id)delegate;

@end
