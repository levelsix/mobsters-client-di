//
//  main.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/15/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSAppDelegate.h"

void SigPipeHandler(int s);

int main(int argc, char *argv[]) {
  int retVal = -1;
  @try {
    signal(SIGPIPE, SigPipeHandler);
    retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([MSAppDelegate class]));
  }
  @catch (NSException* exception) {
    NSLog(@"Uncaught exception: %@", exception.description);
    NSLog(@"Stack trace: %@", [exception callStackSymbols]);
  }
  NSLog(@"Return Val: %d", retVal);
  return retVal;
}

void SigPipeHandler(int s) {
  // do your handling
  NSLog(@"GOT SIGPIPE!! %d", s);
}