//
//  BaseService.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SocketCommunication.h"

@interface BaseService : NSObject

@property (nonatomic, retain) SocketCommunication *socketCommunication;

- (uint64_t) getCurrentMilliseconds;

@end
