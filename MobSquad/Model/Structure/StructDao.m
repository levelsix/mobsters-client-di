//
//  StructDao.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "StructDao.h"

@implementation StructDao

- (void) createStructDictFromList:(NSArray *)structs {
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:structs.count];
  for (id<StaticStructure> ss in structs) {
    [dict setObject:ss forKey:@(ss.structInfo.structId)];
  }
  self.structures = dict;
}

- (id) structForId:(int)structId {
  id<StaticStructure> ss = self.structures[@(structId)];
  if (!ss) {
    [MSNotification popupMessage:[NSString stringWithFormat:@"Attempted to access struct %d", structId]];
  }
  return ss;
}

@end
