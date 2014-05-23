//
//  MSHomeMapController.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "HomeMapController.h"

@implementation HomeMapController

- (void) onEnter {
  [super onEnter];
  
  OBSERVE_NOTIFICATION(USER_STRUCTS_CHANGED_NOTIFICATION, @selector(refresh));
}

- (void) onExit {
  [super onExit];
  
  UNOBSERVE_ALL_NOTIFICATIONS;
}

- (void) refresh {
  [self.map reloadData];
}

#pragma mark - Tiled Map delegate

- (CCSprite *) backgroundImage {
  CCSprite *map = [CCSprite spriteWithImageNamed:@"mapnopier.jpg"];
  map.position = ccp(map.contentSize.width/2-33, map.contentSize.height/2-50);
  return map;
}

- (NSArray *) listOfAssetIdsForMap:(BaseMap *)map {
  return [self.userStructDao listOfUserStructIds];
}

- (MapSprite *) map:(BaseMap *)map spriteForAssetId:(int)assetId {
  UserStruct *us = [self.userStructDao userStructWithId:assetId];
  StructureInfoProto *sip = [[self.structDao structForId:us.structId] structInfo];
  
  MapSprite *ms = [[MapSprite alloc] initWithImageNamed:sip.imgName];
  return ms;
}

- (CGPoint) map:(BaseMap *)map locationForAssetId:(int)assetId {
  UserStruct *us = [self.userStructDao userStructWithId:assetId];
  return us.coordinates;
}

- (CGSize) map:(BaseMap *)map sizeForAssetId:(int)assetId {
  UserStruct *us = [self.userStructDao userStructWithId:assetId];
  StructureInfoProto *sip = [[self.structDao structForId:us.structId] structInfo];
  return CGSizeMake(sip.width, sip.height);
}

@end
