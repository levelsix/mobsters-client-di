//
//  MSHomeMap.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/19/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "BaseMap.h"

@interface HomeMap : BaseMap {
  int _redTileGid;
  int _greenTileGid;
}

@property (nonatomic, retain) NSMutableArray *buildableData;

@end
