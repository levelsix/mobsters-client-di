//
//  MSTiledMap.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "BaseMap.h"

#define ASSET_TAG(d) [NSString stringWithFormat:@"Asset%d", d]

@implementation BaseMap

- (id) initWithFile:(NSString *)tmxFile {
  if ((self = [super initWithFile:tmxFile])) {
    if ([CCDirector sharedDirector].contentScaleFactor == 2) {
      _tileSizeInPoints = CGSizeMake(self.tileSize.width/2, self.tileSize.height/2);
    } else {
      _tileSizeInPoints = _tileSize;
    }
    
    self.scale = DEFAULT_ZOOM;
  }
  return self;
}

- (void) setDelegate:(id<MSTiledMapDelegate>)delegate {
  _delegate = delegate;
  [self reloadData];
  
  // Init the bgd image separately
  [self makeBgdImage];
}

- (void) makeBgdImage {
  if ([self.delegate respondsToSelector:@selector(backgroundImage)]) {
    CCSprite *map = [self.delegate backgroundImage];
    [self addChild:map z:-1000];
    self.bgdImage = map;
    
    _bottomLeftCorner = ccp(map.position.x-map.contentSize.width/2, map.position.y-map.contentSize.height/2);
    _topRightCorner = ccp(map.position.x+map.contentSize.width/2, map.position.y+map.contentSize.height/2);
  }
}

- (void) loadInitMapData {
  int width = self.mapSize.width;
  int height = self.mapSize.height;
  // Get the walkable data
  CCTiledMapLayer *layer = [self layerNamed:@"Walkable"];
  
  self.walkableData = [NSMutableArray arrayWithCapacity:[self mapSize].width];
  for (int i = 0; i < width; i++) {
    NSMutableArray *row = [NSMutableArray arrayWithCapacity:self.mapSize.height];
    for (int j = 0; j < height; j++) {
      // Convert their coordinates to our coordinate system
      CGPoint tileCoord = ccp(height-j-1, width-i-1);
      int tileGid = [layer tileGIDAt:tileCoord];
      [row addObject:[NSNumber numberWithBool:tileGid > 0]];
    }
    [self.walkableData addObject:row];
  }
  layer.visible = NO;
}

- (void) reloadData {
  [self loadInitMapData];
  
  NSArray *vals = [self.delegate listOfAssetIdsForMap:self];
  for (NSNumber *assetIdNum in vals) {
    int assetId = [assetIdNum intValue];
    MapSprite *ms = [self.delegate map:self spriteForAssetId:assetId];
    
    CGPoint pt = [self.delegate map:self locationForAssetId:assetId];
    
    ms.anchorPoint = ccp(0.5, 0);
    ms.position = [self convertTilePointToCCPoint:pt];
    
    [self addChild:ms];
  }
}

- (MapSprite *) spriteForAssetId:(int)assetId {
  return (MapSprite *)[self getChildByName:ASSET_TAG(assetId) recursively:NO];
}

- (BOOL) hitTestWithWorldPos:(CGPoint)pt {
  // Whole screen is in area
  return YES;
}

#pragma mark - Gesture Recognizers

- (void) loadGestureRecognizers {
  [self unloadGestureRecognizers];
  
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
  pan.delegate = self;
  pan.maximumNumberOfTouches = 1;
  [[[CCDirector sharedDirector] view] addGestureRecognizer:pan];
  
  // add UIPinchGestureRecognizer
  UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
  pinch.delegate = self;
  [[[CCDirector sharedDirector] view] addGestureRecognizer:pinch];
  
  // add UITapGestureRecognizer
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
  tap.delegate = self;
  [[[CCDirector sharedDirector] view] addGestureRecognizer:tap];
  
  self.gestureRecognizers = @[pan, pinch, tap];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  CCResponderManager *resp = [CCDirector sharedDirector].responderManager;
  BOOL shouldReceive = [resp nodeAtPoint:[touch locationInWorld]] == nil;
  return shouldReceive;
}

- (void) unloadGestureRecognizers {
  for (UIGestureRecognizer *gest in self.gestureRecognizers) {
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:gest];
  }
  self.gestureRecognizers = nil;
}

#pragma mark - Selection

- (NSMutableArray *) mapSprites {
  NSMutableArray *ms = [NSMutableArray array];
  for (CCNode *n in self.children) {
    if ([n isKindOfClass:[MapSprite class]]) {
      [ms addObject:n];
    }
  }
  return ms;
}

- (NSComparisonResult) compareMapSprite1:(MapSprite *)obj1 toMapSprite2:(MapSprite *)obj2 {
  //  // winner = sprite that is in front
  //  MSMapSprite *winner = nil;
  //  CGSize ms = [self mapSize];
  //  CGRect loc1 = obj1.location;
  //  CGRect loc2 = obj2.location;
  //
  //  CGRect rx1 = loc1; rx1.origin.y = 0; rx1.size.height = ms.height;
  //  CGRect rx2 = loc2; rx2.origin.y = 0; rx2.size.height = ms.height;
  //  CGRect ry1 = loc1; ry1.origin.x = 0; ry1.size.width = ms.width;
  //  CGRect ry2 = loc2; ry2.origin.x = 0; ry2.size.width = ms.width;
  //
  //  BOOL xIntersects = CGRectIntersectsRect(rx1, rx2);
  //  BOOL yIntersects = CGRectIntersectsRect(ry1, ry2);
  //
  //  // If neither intersect, use sum of x and y
  //  // If one side intersects, use the other side to calculate
  //  // If both sides intersect, just choose side with shorter intesection and calculate
  //  if (!xIntersects && !yIntersects) {
  //    float sum1 = loc1.origin.x+loc1.origin.y;
  //    float sum2 = loc2.origin.x+loc2.origin.y;
  //
  //    if (sum1 != sum2) {
  //      winner = sum1 < sum2 ? obj1 : obj2;
  //    }
  //  } else if (!xIntersects) {
  //    if (loc1.origin.x != loc2.origin.x) {
  //      winner = loc1.origin.x < loc2.origin.x ? obj1 : obj2;
  //    }
  //  } else if (!yIntersects) {
  //    if (loc1.origin.y != loc2.origin.y) {
  //      winner = loc1.origin.y < loc2.origin.y ? obj1 : obj2;
  //    }
  //  } else {
  //    // Choose smaller intersection
  //    CGRect intersection = CGRectIntersection(loc1, loc2);
  //    if (intersection.size.width > intersection.size.height) {
  //      if (loc1.origin.y != loc2.origin.y) {
  //        winner = loc1.origin.y < loc2.origin.y ? obj1 : obj2;
  //      }
  //    } else {
  //      if (loc1.origin.x != loc2.origin.x) {
  //        winner = loc1.origin.x < loc2.origin.x ? obj1 : obj2;
  //      }
  //    }
  //  }
  //
  //  if (winner == obj1) {
  //    return NSOrderedDescending;
  //  } else if (winner == obj2) {
  //    return NSOrderedAscending;
  //  } else {
  //    return NSOrderedSame;
  //  }
  return NSOrderedSame;
}

- (void) doReorder {
  //  [_mapSprites sortUsingComparator:^NSComparisonResult(MapSprite *obj1, MapSprite *obj2) {
  //    return [self compareMapSprite1:obj1 toMapSprite2:obj2];
  //  }];
  //
  //  for (int i = 0; i < [_mapSprites count]; i++) {
  //    MapSprite *child = [_mapSprites objectAtIndex:i];
  //    if (![child isExemptFromReorder]) {
  //      child.zOrder = i+REORDER_START_Z;
  //    }
  //  }
}

- (MapSprite *) selectableForPt:(CGPoint)pt {
  //  // Find sprite that has center closest to pt
  //  SelectableSprite *toRet = nil;
  //  float distToCenter = 320.f;
  //  for(MapSprite *spr in _mapSprites) {
  //    if (![spr isKindOfClass:[SelectableSprite class]]) {
  //      continue;
  //    }
  //    SelectableSprite *child = (SelectableSprite *)spr;
  //    if ([child hitTestWithWorldPos:pt] && child.visible && child.opacity > 0.f) {
  //      CGPoint center = ccp(child.contentSize.width/2, child.contentSize.height/2);
  //      float thisDistToCenter = ccpDistance(center, [child convertToNodeSpace:pt]);
  //
  //      if (thisDistToCenter < distToCenter) {
  //        distToCenter = thisDistToCenter;
  //        toRet = child;
  //      }
  //    }
  //  }
  //  return toRet;
  return nil;
}

#pragma mark Gesture Recognizer Handlers

- (void) tap:(UIGestureRecognizer *)recognizer {
  CGPoint pt = [recognizer locationInView:recognizer.view];
  pt = [[CCDirector sharedDirector] convertToGL:pt];
  
  MapSprite *ss = [self selectableForPt:pt];
  self.selected = ss;
  
  if (ss == nil) {
    pt = [self convertToNodeSpace:pt];
    pt = [self convertCCPointToTilePoint:pt];
    CGPoint loc = CGPointMake(roundf(pt.x), roundf(pt.y));
    
    // Make one of the team run here
  }
}

- (void) drag:(UIGestureRecognizer *)recognizer {
  // Now do drag motion
  UIPanGestureRecognizer* pan = (UIPanGestureRecognizer*)recognizer;
  
  if([recognizer state] == UIGestureRecognizerStateBegan ||
     [recognizer state] == UIGestureRecognizerStateChanged ) {
    [self stopActionByTag:190];
    CGPoint translation = [pan translationInView:pan.view.superview];
    
    CGPoint delta = [self convertVectorToGL: translation];
    [self setPosition:ccpAdd(self.position, delta)];
    [pan setTranslation:CGPointZero inView:pan.view.superview];
  } else if ([recognizer state] == UIGestureRecognizerStateEnded) {
    CGPoint vel = [pan velocityInView:pan.view.superview];
    vel = [self convertVectorToGL: vel];
    
    float dist = ccpDistance(ccp(0,0), vel);
    if (dist < 500) {
      return;
    }
    
    vel.x /= 3;
    vel.y /= 3;
    id actionID = [CCActionMoveBy actionWithDuration:dist/1500 position:vel];
    CCActionEaseOut *action = [CCActionEaseSineOut actionWithAction:actionID];
    action.tag = 190;
    [self runAction:action];
  }
}

- (void) scale:(UIGestureRecognizer *)recognizer {
  UIPinchGestureRecognizer* pinch = (UIPinchGestureRecognizer*)recognizer;
  
  // See if zoom should even be allowed
  float newScale = self.scale * pinch.scale;
  pinch.scale = 1.0f; // we just reset the scaling so we only wory about the delta
  if (newScale > MAX_ZOOM || newScale < MIN_ZOOM) {
    return;
  }
  
  CCDirector* director = [CCDirector sharedDirector];
  CGPoint pt = [recognizer locationInView:recognizer.view.superview];
  pt = [director convertToGL:pt];
  CGPoint beforeScale = [self convertToNodeSpace:pt];
  
  self.scale = newScale;
  CGPoint afterScale = [self convertToNodeSpace:pt];
  CGPoint diff = ccpSub(afterScale, beforeScale);
  
  self.position = ccpAdd(self.position, ccpMult(diff, self.scale));
}

- (CGPoint) clipPositionToBoundary:(CGPoint)position scale:(float)scale {
  // For y, make sure to account for anchor point being at bottom middle.
  CGPoint blPt = _bottomLeftCorner;
  CGPoint trPt = _topRightCorner;
  float minX = blPt.x;
  float minY = blPt.y;
  float maxX = trPt.x;
  float maxY = trPt.y;
  
  float x = MAX(MIN(-minX*scale, position.x), -maxX*scale + [[CCDirector sharedDirector] viewSize].width);
  float y = MAX(MIN(-minY*scale, position.y), -maxY*scale + [[CCDirector sharedDirector] viewSize].height);
  
  return ccp(x, y);
}

- (void) setPosition:(CGPoint)position {
  [super setPosition:[self clipPositionToBoundary:position scale:self.scale]];
}

- (void) setScale:(float)scale {
  CGPoint tr = _topRightCorner;
  CGPoint bl = _bottomLeftCorner;
  int newWidth = (tr.x-bl.x)*scale;
  int newHeight = (tr.y-bl.y)*scale;
  
  if (newWidth >= self.parent.contentSize.width && newHeight >= self.parent.contentSize.height) {
    [super setScale:scale];
  }
}

#pragma mark - Converting points

- (CGPoint) convertTilePointToCCPoint:(CGPoint)pt {
  CGSize ms = _mapSize;
  CGSize ts = _tileSizeInPoints;
  return ccp( ms.width * ts.width/2.f + ts.width * (pt.x-pt.y)/2.f,
             ts.height * (pt.y+pt.x)/2.f);
}

- (CGPoint) convertCCPointToTilePoint:(CGPoint)pt {
  CGSize ms = _mapSize;
  CGSize ts = _tileSizeInPoints;
  float a = (pt.x - ms.width*ts.width/2.f)/ts.width;
  float b = pt.y/ts.height;
  float x = a+b;
  float y = b-a;
  return ccp(x,y);
}

- (CGPoint) convertVectorToGL:(CGPoint)uiPoint {
  return ccp(uiPoint.x, -uiPoint.y);
}

#pragma mark -

- (void) onEnter {
  [super onEnter];
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTeamSprites) name:MY_TEAM_CHANGED_NOTIFICATION object:nil];
  //[self setupTeamSprites];
  
  [self loadGestureRecognizers];
}

- (void) onExit {
  self.selected = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  [self unloadGestureRecognizers];
  [super onExit];
}

@end
