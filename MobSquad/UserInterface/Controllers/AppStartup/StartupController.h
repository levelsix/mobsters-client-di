//
//  StartupController.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Typhoon.h>
#import "SocketCommunication.h"

@protocol StartupControllerDelegate <NSObject>

- (void) reachedProgressPercent:(float)percent;
- (void) shouldBeginTutorial;

@end

@interface StartupController : NSObject {
  TyphoonComponentFactory *_factory;
}

@property (nonatomic, assign) id<StartupControllerDelegate> delegate;

- (void) handleConnectedToHost;
- (void) handleStartupResponseProto:(FullEvent *)fe;
- (void) handleLoadPlayerCityResponseProto:(FullEvent *)fe;

@end
