//
//  UIImage+Downloading.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/21/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "UIImage+Downloading.h"
#import "UIImage+Masking.h"

#import "MSFileUtils.h"

#import "Downloader.h"
#import "CCDirector.h"

@implementation UIImage (Downloading)

+ (UIImage *) loadImageNamed:(NSString *)path {
  if (!path) {
    return nil;
  }
  
  // prevents overloading the autorelease pool
  NSString *resName = [MSFileUtils getDoubleResolutionImage:path];
  UIImage *image = nil;
  NSString *fullpath = [[NSBundle mainBundle] pathForResource:resName ofType:nil];
  
  if (!fullpath) {
    // Image not in NSBundle: look in documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    BOOL fileExists = NO;
    fullpath = [documentsPath stringByAppendingPathComponent:resName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
      fileExists = YES;
    }
    
    if (!fileExists) {
      // Image not in docs: download it
      [[Downloader sharedDownloader] syncDownloadFile:fullpath.lastPathComponent];
    }
  }
  
  image = [UIImage imageWithContentsOfFile:fullpath];
  
  return image;
}

+ (void) loadImageNamed:(NSString *)imageName withView:(UIView *)view indicator: (UIActivityIndicatorViewStyle)indicatorStyle clearImageDuringDownload:(BOOL)clear {
  [self loadImageNamed:imageName withView:view maskedColor:nil greyscale:NO indicator:indicatorStyle clearImageDuringDownload:clear];
}

+ (void) loadImageNamed:(NSString *)imageName withView:(UIView *)view maskedColor:(UIColor *)color indicator: (UIActivityIndicatorViewStyle)indicatorStyle clearImageDuringDownload:(BOOL)clear {
  [self loadImageNamed:imageName withView:view maskedColor:color greyscale:NO indicator:indicatorStyle clearImageDuringDownload:clear];
}

+ (void) loadImageNamed:(NSString *)imageName withView:(UIView *)view greyscale:(BOOL)greyscale indicator: (UIActivityIndicatorViewStyle)indicatorStyle clearImageDuringDownload:(BOOL)clear {
  [self loadImageNamed:imageName withView:view maskedColor:nil greyscale:greyscale indicator:indicatorStyle clearImageDuringDownload:clear];
}

static NSMutableDictionary *viewsWaitingForDownloading;

+ (void) loadImageNamed:(NSString *)imageName withView:(UIView *)view maskedColor:(UIColor *)color greyscale:(BOOL)greyscale indicator: (UIActivityIndicatorViewStyle)indicatorStyle clearImageDuringDownload:(BOOL)clear {
  if (!viewsWaitingForDownloading) {
    viewsWaitingForDownloading = [NSMutableDictionary dictionary];
  }
  
  // If imageName is null, it will clear the view's pre-downloading stuff
  // If view is null, it will download image without worrying about the view
  NSString *key = [NSString stringWithFormat:@"%p", view];
  [viewsWaitingForDownloading removeObjectForKey:key];
  
  UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)[view viewWithTag:150];
  [loadingView stopAnimating];
  [loadingView removeFromSuperview];
  
  if (!imageName || imageName.length == 0) {
    if ([view isKindOfClass:[UIImageView class]]) {
      [(UIImageView *)view setImage:nil];
    } else if ([view isKindOfClass:[UIButton class]]) {
      [(UIButton *)view setImage:nil forState:UIControlStateNormal];
    }
    return;
  }
  
  NSString *resName =  [imageName rangeOfString:@"http"].location != NSNotFound ? imageName : [MSFileUtils getDoubleResolutionImage:imageName];
  NSString *fullpath = [[NSBundle mainBundle] pathForResource:resName ofType:nil];
  
  if (!fullpath) {
    // Image not in NSBundle: look in documents
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    fullpath = [documentsPath stringByAppendingPathComponent:resName.lastPathComponent];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullpath]) {
      if (indicatorStyle >= 0 && ![view viewWithTag:150]) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:indicatorStyle];
        loadingView.tag = 150;
        [loadingView startAnimating];
        [view addSubview:loadingView];
        loadingView.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
        
        // Set up scale
        float scale = MIN(1.f, MIN(view.frame.size.width/loadingView.frame.size.width/2.f, view.frame.size.width/loadingView.frame.size.width/2.f));
        loadingView.transform = CGAffineTransformMakeScale(scale, scale);
      }
      
      if (clear) {
        if ([view isKindOfClass:[UIImageView class]]) {
          [(UIImageView *)view setImage:nil];
        } else if ([view isKindOfClass:[UIButton class]]) {
          [(UIButton *)view setImage:nil forState:UIControlStateNormal];
        }
      }
      
      [viewsWaitingForDownloading setObject:imageName forKey:key];
      
      [[Downloader sharedDownloader] asyncDownloadFile:resName completion:^{
        NSString *str = [viewsWaitingForDownloading objectForKey:key];
        if ([str isEqualToString:imageName]) {
          UIImage *img = [UIImage imageWithContentsOfFile:fullpath];
          
          if (img) {
            if (color) {
              img = [self maskImage:img withColor:color];
            } else if (greyscale) {
              img = [self greyScaleImageWithBaseImage:img];
            }
          }
          
          if ([view isKindOfClass:[UIImageView class]]) {
            [(UIImageView *)view setImage:img];
          } else if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setImage:img forState:UIControlStateNormal];
          }
          
          UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)[view viewWithTag:150];
          [loadingView stopAnimating];
          [loadingView removeFromSuperview];
          [viewsWaitingForDownloading removeObjectForKey:key];
        }
      }];
      return;
    }
  }
  
  UIImage* image = [UIImage imageWithContentsOfFile:fullpath];
  UIView *loader = [view viewWithTag:150];
  if (loader) {
    [loader removeFromSuperview];
  }
  
  if (image) {
    if (color) {
      image = [self maskImage:image withColor:color];
    } else if (greyscale) {
      image = [self greyScaleImageWithBaseImage:image];
    }
    
    if ([view isKindOfClass:[UIImageView class]]) {
      [(UIImageView *)view setImage:image];
    } else if ([view isKindOfClass:[UIButton class]]) {
      [(UIButton *)view setImage:image forState:UIControlStateNormal];
    }
  }
}

@end
