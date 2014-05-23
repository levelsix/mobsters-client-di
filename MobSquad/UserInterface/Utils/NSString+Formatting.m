//
//  NSString+Formatting.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "NSString+Formatting.h"

@implementation NSString (Formatting)

+ (NSString *) cashStringForNumber:(int)n {
  return [NSString stringWithFormat:@"$%@", [self commafyNumber:n]];
}

+ (NSString *) commafyNumber:(float)f {
  int n = (int)f;
  float r = f-n;
  
  BOOL neg = n < 0;
  n = abs(n);
  NSString *s = [NSString stringWithFormat:@"%03d", n%1000];
  n /= 1000;
  while (n > 0) {
    s = [NSString stringWithFormat:@"%03d,%@", n%1000, s];
    n /= 1000;
  }
  
  int x = 0;
  while (x < s.length && [s characterAtIndex:x] == '0') {
    x++;
  }
  s = [s substringFromIndex:x];
  NSString *pre = neg ? @"-" : @"";
  NSString *toRet = s.length > 0 ? [pre stringByAppendingString:s] : @"0";
  
  if (r > 0) {
    toRet = [toRet stringByAppendingString:[[NSString stringWithFormat:@"%g", r] substringFromIndex:1]];
  }
  
  return toRet;
}

+ (NSString *) qualifierStringForNumber:(int)rank {
  int lastDigit = rank % 10;
  int secondDigit = (rank / 10) % 10;
  NSString *qualifier = @"th";
  if (secondDigit != 1 && lastDigit >= 1 && lastDigit <= 3) {
    if (lastDigit == 1) {
      qualifier = @"st";
    } else if (lastDigit == 2) {
      qualifier = @"nd";
    } else if (lastDigit == 3) {
      qualifier = @"rd";
    }
  }
  return qualifier;
}

@end
