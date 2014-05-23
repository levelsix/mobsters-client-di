//
//  MSMapSprite.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import <cocos2d.h>

@interface MapSprite : CCSprite {
  CCSprite *_arrow;
}

@property (nonatomic, assign) BOOL isSelectable;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isExemptFromReorder;

- (BOOL) select;
- (void) unselect;

- (void) displayArrow;
- (void) removeArrowAnimated:(BOOL)animated;

@end
