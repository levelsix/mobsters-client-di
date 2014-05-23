//
//  NSString+Formatting.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Formatting)

+ (NSString *) cashStringForNumber:(int)n;
+ (NSString *) commafyNumber:(float)n;
+ (NSString *) qualifierStringForNumber:(int)rank;

@end
