//
//  MSRootViewController.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/16/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Typhoon.h>

#import "CCDirector+Downloader.h"

@class StartupController;

@interface MSRootViewController : UIViewController <CCDirectorDownloaderDelegate> {
  TyphoonComponentFactory *_factory;
  
  BOOL _isFreshRestart;
  BOOL _isFromFacebook;
}

@property (nonatomic, retain) StartupController *startupController;

- (void) handleConnectedToHost;

- (void) openGemShop;

@end
