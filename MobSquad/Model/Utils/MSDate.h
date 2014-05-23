//
//  MSDate.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSDate : NSObject

@property (nonatomic, retain) NSDate *underlyingDate;

- (NSComparisonResult) compare:(MSDate *)date;
- (BOOL) isEqualToDate:(MSDate *)date;

- (MSDate *) dateByAddingTimeInterval:(NSTimeInterval)timeInterval;
- (NSTimeInterval) timeIntervalSinceNow;
- (NSTimeInterval) timeIntervalSinceDate:(MSDate *)date;
- (NSTimeInterval) timeIntervalSince1970;

- (NSDate *) relativeNSDate;
- (NSDate *) actualNSDate;

+ (MSDate *) date;
+ (MSDate *) dateWithTimeIntervalSince1970:(NSTimeInterval)timeInterval;
+ (MSDate *) dateWithTimeInterval:(NSTimeInterval)timeInterval sinceDate:(MSDate *)date;
+ (void) setServerTime:(uint64_t)time;

@end
