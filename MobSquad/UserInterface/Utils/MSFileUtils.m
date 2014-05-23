//
//  MSFileUtils.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MSFileUtils.h"

#import "Downloader.h"
#import <cocos2d.h>

@implementation MSFileUtils

+ (NSString*) getDoubleResolutionImage:(NSString *)path {
	if ([CCDirector sharedDirector].contentScaleFactor == 2) {
		NSString *pathWithoutExtension = [path stringByDeletingPathExtension];
		NSString *name = [pathWithoutExtension lastPathComponent];
		
		// check if path already has the suffix.
		if ([name rangeOfString:@"@2x"].location != NSNotFound) {
			return path;
		}
    
		NSString *extension = [path pathExtension];
		
		if ([extension isEqualToString:@"ccz"] || [extension isEqualToString:@"gz"]) {
			// All ccz / gz files should be in the format filename.xxx.ccz
			// so we need to pull off the .xxx part of the extension as well
			extension = [NSString stringWithFormat:@"%@.%@", [pathWithoutExtension pathExtension], extension];
			pathWithoutExtension = [pathWithoutExtension stringByDeletingPathExtension];
		}
		
		NSString *retinaName = [pathWithoutExtension stringByAppendingString:@"@2x"];
		retinaName = [retinaName stringByAppendingPathExtension:extension];
    
    return retinaName;
	}
	
	return path;
}

+ (BOOL) isFileDownloaded:(NSString *)fileName {
  if (!fileName) {
    return NO;
  }
  
  // prevents overloading the autorelease pool
  NSString *resName = [self getDoubleResolutionImage:fileName];
  NSString *fullpath = [[NSBundle mainBundle] pathForResource:resName ofType:nil];
  
  // Added for Utopia project
  if (!fullpath) {
    // Image not in NSBundle: look in documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    fullpath = [documentsPath stringByAppendingPathComponent:resName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
      // Map not in docs: download it
      return NO;
    }
  }
  
  return YES;
}

+ (NSString *) pathToFile:(NSString *)fileName {
  if (!fileName) {
    return nil;
  }
  
  // prevents overloading the autorelease pool
  NSString *resName = [self getDoubleResolutionImage:fileName];
  NSString *fullpath = [[NSBundle mainBundle] pathForResource:resName ofType:nil];
  
  // Added for Utopia project
  if (!fullpath) {
    // Image not in NSBundle: look in documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    fullpath = [documentsPath stringByAppendingPathComponent:resName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
      // Map not in docs: download it
      [[Downloader sharedDownloader] syncDownloadFile:fullpath.lastPathComponent];
    }
  }
  
  return fullpath;
}

@end
