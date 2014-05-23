//
//  MSHomeMapController.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "BaseMapController.h"

#import "UserStructDao.h"
#import "StructDao.h"

@interface HomeMapController : BaseMapController

@property (nonatomic, retain) UserStructDao *userStructDao;
@property (nonatomic, retain) StructDao *structDao;

@end
