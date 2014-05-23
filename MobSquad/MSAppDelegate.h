//
//  MSAppDelegate.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/15/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Typhoon.h>

@interface MSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) TyphoonComponentFactory* factory;

@end
