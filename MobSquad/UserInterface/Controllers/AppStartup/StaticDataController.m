//
//  StaticDataController.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "StaticDataController.h"

#import "Protocols.pb.h"
#import "MSAssembly.h"

#import "StructDao.h"

@implementation StaticDataController

- (void) typhoonSetFactory:(id)theFactory {
  _factory = theFactory;
}

- (void) updateForStaticData:(StaticDataProto *)proto {
  MSDaoAssembly *daoAssembly = (MSDaoAssembly *)_factory;
  
  NSMutableArray *staticStructs = [NSMutableArray array];
  [staticStructs addObjectsFromArray:proto.allGeneratorsList];
  [staticStructs addObjectsFromArray:proto.allTownHallsList];
  [staticStructs addObjectsFromArray:proto.allStoragesList];
  [staticStructs addObjectsFromArray:proto.allHospitalsList];
  [staticStructs addObjectsFromArray:proto.allResidencesList];
  [staticStructs addObjectsFromArray:proto.allLabsList];
  [staticStructs addObjectsFromArray:proto.allMiniJobCentersList];
  [[daoAssembly structureDao] createStructDictFromList:staticStructs];
}

@end
