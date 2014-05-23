//
//  MSNotification.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSNotification : NSObject

+ (void) popupMessage:(NSString *)msg;
+ (void) addAlertNotification:(NSString *)msg;
+ (void) addGreenAlertNotification:(NSString *)msg;

@end
