//
//  ImageDownloader.m
//  Utopia
//
//  Created by Ashwin Kamath on 1/14/12.
//  Copyright (c) 2012 LVL6. All rights reserved.
//

#import "Downloader.h"
#import "MSSynthesizeSingleton.h"
#import "SSZipArchive.h"

#define URL_BASE @"https://s3-us-west-1.amazonaws.com/lvl6mobsters/Resources/";

@implementation Downloader

MS_SYNTHESIZE_SINGLETON_FOR_CLASS(Downloader);

- (id) init {
  if ((self = [super init])) {
    _syncQueue = dispatch_queue_create("Sync Downloader", NULL);
    _asyncQueue = dispatch_queue_create("Async Downloader", NULL);
    _cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] copy];
  }
  return self;
}

- (NSString *) downloadFile:(NSString *)imageName {
  if (!imageName) {
    return nil;
  }
  
  // MSLogs here are NOT thread safe, be careful
  NSURL *url = nil;
  if ([imageName rangeOfString:@"http"].location == NSNotFound) {
    NSString *urlBase = URL_BASE;
    url = [[NSURL alloc] initWithString:[urlBase stringByAppendingString:imageName]];
  } else {
    url = [[NSURL alloc] initWithString:imageName];
  }
  NSString *filePath = [NSString stringWithFormat:@"%@/%@",_cacheDir, imageName.lastPathComponent];
  BOOL success = YES;
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    if (data) {
      success = [data writeToFile:filePath atomically:YES];
    } else {
      success = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      if (success) {
        MSLog(@"Download of %@ complete.", imageName);
      } else {
        MSLog(@"Failed to download %@.", imageName);
      }
    });
  }
  
  return success ? filePath : nil;
}

- (void) asyncDownloadFile:(NSString *)imageName completion:(void (^)(void))completed {
  // Get an image from the URL below
  dispatch_async(_asyncQueue, ^{
    [self downloadFile:imageName];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      if (completed) {
        completed();
      }
    });
  });
}

- (NSString *) syncDownloadFile:(NSString *)fileName {
  MSLog(@"Beginning sync download of file %@", fileName);
  NSString *path = [self downloadFile:fileName];
  return path;
}

- (void) downloadBundle:(NSString *)zipFile {
  NSString *filePath = [self downloadFile:zipFile];
  if (filePath) {
    [SSZipArchive unzipFileAtPath:filePath toDestination:_cacheDir];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
  }
}

- (void) deletePreviousBundles:(NSString *)bundleName {
  NSString *num = [bundleName pathExtension];
  NSString *base = [bundleName stringByDeletingPathExtension];
  int numVal = num.intValue;
  
  for (int i = 0; i < numVal; i++) {
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%d",_cacheDir, base, i];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
      [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
  }
}

- (void) syncDownloadBundle:(NSString *)bundleName {
  MSLog(@"Beginning sync download of bundle %@", bundleName);
  //  [self performSelectorOnMainThread:@selector(beginLoading:) withObject:bundleName waitUntilDone:YES];
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
  dispatch_sync(_syncQueue, ^{
    [self downloadBundle:[bundleName stringByAppendingString:@".zip"]];
    [self deletePreviousBundles:bundleName];
  });
  MSLog(@"Download of bundle %@ complete", bundleName);
}

- (void) asyncDownloadBundle:(NSString *)bundleName {
  MSLog(@"Beginning async download of bundle %@", bundleName);
  dispatch_async(_asyncQueue, ^{
    [self downloadBundle:[bundleName stringByAppendingString:@".zip"]];
    [self deletePreviousBundles:bundleName];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      MSLog(@"Download of bundle %@ complete", bundleName);
    });
  });
}

- (void) purgeAllDownloadedData {
  NSFileManager *fileMgr = [NSFileManager defaultManager];
  NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:_cacheDir error:nil];
  for (NSString *filename in fileArray)  {
    [fileMgr removeItemAtPath:[_cacheDir stringByAppendingPathComponent:filename] error:NULL];
  }
}

- (void) deleteFile:(NSString *)file {
  NSFileManager *fileMgr = [NSFileManager defaultManager];
  BOOL success = [fileMgr removeItemAtPath:[_cacheDir stringByAppendingPathComponent:file] error:NULL];
  
  if (success) {
    MSLog(@"Deleted %@.", file);
  }
}

@end
