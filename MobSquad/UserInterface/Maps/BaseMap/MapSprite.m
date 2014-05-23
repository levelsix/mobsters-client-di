//
//  MSMapSprite.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "MapSprite.h"

#define GLOW_DURATION 0.6f
#define GLOW_ACTION_TAG 3021

@implementation MapSprite

- (BOOL) select {
  _isSelected = YES;
  
  if (![self getActionByTag:GLOW_ACTION_TAG]) {
    int amt = 135;
    CCActionTintTo *tint = [CCActionTintTo actionWithDuration:GLOW_DURATION color:[CCColor colorWithCcColor3b:ccc3(amt, amt, amt)]];
    CCActionTintTo *tintBack = [CCActionTintTo actionWithDuration:GLOW_DURATION color:[CCColor colorWithCcColor3b:ccc3(255, 255, 255)]];
    CCAction *action = [CCActionRepeatForever actionWithAction:[CCActionSequence actions:tint, tintBack, nil]];
    action.tag = GLOW_ACTION_TAG;
    [self runAction:action];
  }
  
  return YES;
}

- (void) unselect {
  _isSelected = NO;
  [self stopActionByTag:GLOW_ACTION_TAG];
  [self setColor:[CCColor colorWithCcColor3b:ccc3(255, 255, 255)]];
}

- (void) displayArrow {
  [self removeArrowAnimated:NO];
  _arrow = [CCSprite spriteWithImageNamed:@"arrow.png"];
  [self addChild:_arrow];
  
  _arrow.anchorPoint = ccp(0.5f, 0.f);
  _arrow.position = ccp(self.contentSize.width/2, self.contentSize.height+5.f);
  
  CCActionSpawn *down = [CCActionSpawn actions:
                         [CCActionEaseInOut actionWithAction:[CCActionScaleBy actionWithDuration:0.7f scaleX:1.f scaleY:0.88f]],
                         [CCActionEaseInOut actionWithAction:[CCActionMoveBy actionWithDuration:0.7f position:ccp(0.f, -5.f)]],
                         nil];
  CCActionInterval *up = [down reverse];
  [_arrow runAction:[CCActionRepeatForever actionWithAction:[CCActionSequence actions:down, up, nil]]];
}

- (void) removeArrowAnimated:(BOOL)animated {
  if (_arrow) {
    if (!animated) {
      [_arrow removeFromParentAndCleanup:YES];
      _arrow = nil;
    } else {
      [_arrow runAction:[CCActionSequence actions:[CCActionFadeOut actionWithDuration:0.2f], [CCActionCallBlock actionWithBlock:^{
        [_arrow removeFromParentAndCleanup:YES];
        _arrow = nil;
      }], nil]];
    }
  }
}

@end
