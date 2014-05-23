//
//  MSHomeMap.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "HomeMap.h"

#define BUILDABLE_LAYER_NAME @"Buildable"
#define META_LAYER_NAME @"MetaLayer"

@implementation HomeMap

- (void) loadInitMapData {
  [super loadInitMapData];
  
  int width = self.mapSize.width;
  int height = self.mapSize.height;
  // Get the walkable data
  CCTiledMapLayer *layer = [self layerNamed:@"Buildable"];
  
  self.buildableData = [NSMutableArray arrayWithCapacity:[self mapSize].width];
  for (int i = 0; i < width; i++) {
    NSMutableArray *row = [NSMutableArray arrayWithCapacity:self.mapSize.height];
    for (int j = 0; j < height; j++) {
      // Convert their coordinates to our coordinate system
      CGPoint tileCoord = ccp(height-j-1, width-i-1);
      int tileGid = [layer tileGIDAt:tileCoord];
      [row addObject:[NSNumber numberWithBool:tileGid > 0]];
    }
    [self.buildableData addObject:row];
  }
  layer.visible = NO;
  
  layer = [self layerNamed:@"MetaLayer"];
  CGPoint redGidPt = ccp(_mapSize.width-1, _mapSize.height-1);
  CGPoint greenGidPt = ccp(_mapSize.width-1, _mapSize.height-2);
  _redTileGid = [layer tileGIDAt:redGidPt];
  _greenTileGid = [layer tileGIDAt:greenGidPt];
  [layer removeTileAt:redGidPt];
  [layer removeTileAt:greenGidPt];
  
  layer.zOrder = 1001;
}

@end
