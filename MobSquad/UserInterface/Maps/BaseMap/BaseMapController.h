//
//  MSTiledMapController.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <cocos2d.h>
#import "BaseMap.h"

@interface BaseMapController : CCScene <MSTiledMapDelegate>

@property (nonatomic, retain) BaseMap *map;

@end
