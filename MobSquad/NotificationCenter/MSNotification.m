//
//  MSNotification.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MSNotification.h"

#import "GenericPopupController.h"

@implementation MSNotification

+ (void) popupMessage:(NSString *)msg {
  [GenericPopupController displayNotificationViewWithText:msg title:@"Notification"];
}

+ (void) addAlertNotification:(NSString *)msg {
}

+ (void) addGreenAlertNotification:(NSString *)msg {
}

@end
