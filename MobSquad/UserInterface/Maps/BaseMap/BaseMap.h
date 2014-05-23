//
//  MSTiledMap.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <cocos2d.h>
#import "MapSprite.h"

#define MAX_ZOOM 1.8f
#define MIN_ZOOM 0.3f
#define DEFAULT_ZOOM 0.8f

@class BaseMap;

@protocol MSTiledMapDelegate <NSObject>

@optional
- (MapSprite *) map:(BaseMap *)map spriteForAssetId:(int)assetId;
- (CGPoint) map:(BaseMap *)map locationForAssetId:(int)assetId;
- (CGSize) map:(BaseMap *)map sizeForAssetId:(int)assetId;

- (CCSprite *) backgroundImage;
- (NSArray *) listOfAssetIdsForMap:(BaseMap *)map;

- (BOOL) map:(BaseMap *)map didSelectAssetWithId:(int)assetId;

@end

@interface BaseMap : CCTiledMap <UIGestureRecognizerDelegate> {
  CGPoint _bottomLeftCorner;
  CGPoint _topRightCorner;
}

@property (nonatomic, retain) NSArray *gestureRecognizers;

@property (nonatomic, retain) CCSprite *bgdImage;

@property (nonatomic, retain) MapSprite *selected;
@property (nonatomic, assign) CGSize tileSizeInPoints;

@property (nonatomic, retain) NSMutableArray *walkableData;

@property (nonatomic, assign) id<MSTiledMapDelegate> delegate;

- (void) loadInitMapData;

- (void) reloadData;

- (MapSprite *) spriteForAssetId:(int)assetId;

@end
