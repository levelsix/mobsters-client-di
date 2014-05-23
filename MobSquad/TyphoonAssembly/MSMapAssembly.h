//
//  MSMapAssembly.h
//  MobSquad
//
//  Created by Ashwin Kamath on 5/20/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "TyphoonAssembly.h"

#import "MSDaoAssembly.h"

@interface MSMapAssembly : TyphoonAssembly 

@property (nonatomic, strong, readonly) MSDaoAssembly *daoAssembly;

- (id) homeMapController;

@end
