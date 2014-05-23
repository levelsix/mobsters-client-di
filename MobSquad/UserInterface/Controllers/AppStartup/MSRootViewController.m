//
//  MSRootViewController.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/16/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MSRootViewController.h"
#import <cocos2d.h>
#import "CCTexture_Private.h"
#import <cocos2d-ui.h>
#import "HomeMapController.h"
#import "MSAssembly.h"
#import "FacebookDelegate.h"
#import "SocketCommunication.h"
#import "StartupController.h"
#import "MSUIKitUtils.h"
#import "Downloader.h"

@interface MSRootViewController ()

@end

@implementation MSRootViewController

- (id) init {
  if ((self = [super init])) {
    _isFreshRestart = YES;
  }
  return self;
}

- (void) typhoonSetFactory:(id)theFactory {
  _factory = theFactory;
}

- (void) loadView {
  CGRect rect = [[UIScreen mainScreen] bounds];
  CGSize size = rect.size;
  rect.size = CGSizeMake(rect.size.height, rect.size.width);
  rect.origin = CGPointMake((size.height-rect.size.width)/2, (size.width-rect.size.height)/2);
  UIView *v = [[UIView alloc] initWithFrame:rect];
  v.backgroundColor = [UIColor blackColor];
  
  self.view = v;
}

- (void) viewDidLoad {
  [self setupCocos2D];
}

- (BOOL) prefersStatusBarHidden {
  return YES;
}

- (void) setupCocos2D {
  CCDirector *director = [CCDirector sharedDirector];
  CCGLView *glView = [CCGLView viewWithFrame:self.view.bounds
                                 pixelFormat:kEAGLColorFormatRGB565
                                 depthFormat:GL_DEPTH24_STENCIL8_OES
                          preserveBackbuffer:NO
                                  sharegroup:nil
                               multiSampling:NO
                             numberOfSamples:0];
  
  // Display link director is causing problems with uiscrollview and table view.
  [director setProjection:CCDirectorProjection2D];
  [director setView:glView];
  
  [self.view insertSubview:glView atIndex:0];
  
	[director setAnimationInterval:1.0/60];
  
#ifdef DEBUG
	[director setDisplayStats:YES];
#endif
  
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture setDefaultAlphaPixelFormat:CCTexturePixelFormat_RGBA8888];
  
  [CCTexture PVRImagesHavePremultipliedAlpha:NO];
  
  [[CCFileUtils sharedFileUtils] setiPhoneRetinaDisplaySuffix:@"@2x"];
  [[CCDirector sharedDirector] setDownloaderDelegate:self];
  
  NSArray *arr = [[CCFileUtils sharedFileUtils] searchPath];
  NSString *docDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
  [[CCFileUtils sharedFileUtils] setSearchPath:[arr arrayByAddingObject:docDir]];
  
  [self addChildViewController:director];
  [self.view addSubview:director.view];
  
  MSMapAssembly *mapAssembly = (MSMapAssembly *)_factory;
  [director pushScene:[mapAssembly homeMapController]];
}

- (void) handleConnectedToHost {
  [self.startupController handleConnectedToHost];
}

- (void) openGemShop {
  
}

#pragma mark - CCDirectorDownloaderDelegate methods

- (NSString *) filepathToFile:(NSString *)filename {
  return [MSFileUtils pathToFile:filename];
}

- (NSString *) downloadFile:(NSString *)filename {
  return [[Downloader sharedDownloader] syncDownloadFile:[MSFileUtils getDoubleResolutionImage:filename]];
}

@end
