//
//  StaticDataController.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Typhoon.h>

@interface StaticDataController : NSObject {
  TyphoonComponentFactory *_factory;
}

- (void) updateForStaticData:(StaticDataProto *)proto;

@end
