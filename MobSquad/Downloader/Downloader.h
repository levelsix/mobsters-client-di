//
//  ImageDownloader.h
//  Utopia
//
//  Created by Ashwin Kamath on 1/14/12.
//  Copyright (c) 2012 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject {
  dispatch_queue_t _syncQueue;
  dispatch_queue_t _asyncQueue;
  NSString *_cacheDir;
}

+ (Downloader *) sharedDownloader;

- (NSString *) syncDownloadFile:(NSString *)fileName;
- (void) asyncDownloadFile:(NSString *)imageName completion:(void (^)(void))completed;
- (void) syncDownloadBundle:(NSString *)bundleName;
- (void) asyncDownloadBundle:(NSString *)bundleName;

- (void) purgeAllDownloadedData;
- (void) deleteFile:(NSString *)file;

@end
