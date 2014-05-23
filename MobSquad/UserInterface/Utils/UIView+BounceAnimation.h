//
//  UIView+BounceAnimation.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BounceAnimation)

+ (void) bounceView:(UIView *)view;
+ (void) bounceView:(UIView *)view fadeInBgdView: (UIView *)bgdView;
+ (void) bounceView:(UIView *)view fadeInBgdView:(UIView *)bgdView completion:(void (^)(BOOL))completed;
+ (void) popOutView:(UIView *)view fadeOutBgdView:(UIView *)bgdView completion:(void (^)(void))completed;
+ (void) shakeView:(UIView *)view duration:(float)duration offset:(int)offset;

@end
