//
//  MSFileUtils.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSFileUtils : NSObject

+ (NSString*) getDoubleResolutionImage:(NSString *)path;
+ (BOOL) isFileDownloaded:(NSString *)fileName;
+ (NSString *) pathToFile:(NSString *)fileName;

@end
