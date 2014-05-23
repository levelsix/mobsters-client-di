//
//  StartupController.m
//  MobSquad
//
//  Created by Ashwin Kamath on 5/22/14.
//  Copyright (c) 2014 LVL6. All rights reserved.
//

#import "StartupController.h"

#import "MSAssembly.h"
#import "FacebookDelegate.h"
#import "StartupService.h"
#import "StructService.h"
#import "StaticDataController.h"
#import "UserStructDao.h"

#define PART_0_PERCENT 0.f
#define PART_1_PERCENT 0.05f
#define PART_2_PERCENT 0.75f
#define PART_3_PERCENT 0.9f

@implementation StartupController

- (void) typhoonSetFactory:(id)theFactory {
  _factory = theFactory;
}

- (void) handleConnectedToHost {
  [FacebookDelegate getFacebookIdAndDoAction:^(NSString *facebookId) {
    if ([SocketCommunication isForcedTutorial]) {
      NSLog(@"Forcing tutorial. Throwing away facebook id %@.", facebookId);
      facebookId = nil;
    }
    [[(MSServiceAssembly *)_factory startupService] startupWithFacebookId:facebookId isFreshRestart:YES delegate:self];
  }];
}

- (void) handleStartupResponseProto:(FullEvent *)fe {
  StartupResponseProto *proto = (StartupResponseProto *)fe.event;
  
  [[(MSInitAssembly *)_factory staticDataController] updateForStaticData:proto.staticDataStuffProto];
  
  if (proto.startupStatus == StartupResponseProto_StartupStatusUserInDb) {
    [self parseUserData:proto];
    
    SocketCommunication *sc = [(MSInitAssembly *)_factory socketCommunication];
    [sc initUserIdMessageQueue];
    [sc rebuildSender];
    
    [[(MSServiceAssembly *)_factory structService] loadPlayerCity:proto.sender.userId delegate:self];
  } else if (proto.startupStatus == StartupResponseProto_StartupStatusUserNotInDb) {
    [self.delegate shouldBeginTutorial];
  } else if (proto.startupStatus == StartupResponseProto_StartupStatusServerInMaintenance) {
    [self.delegate reachedProgressPercent:PART_2_PERCENT];
    [GenericPopupController displayNotificationViewWithText:@"Sorry, the server is undergoing maintenance right now. Try again?"
                                                      title:@"Server Maintenance" okayButton:@"Retry"
                                                     target:self selector:@selector(handleConnectedToHost)];
  }
}

- (void) handleLoadPlayerCityResponseProto:(FullEvent *)fe {
  LoadPlayerCityResponseProto *proto = fe.event;
  if (proto.status == LoadPlayerCityResponseProto_LoadPlayerCityStatusSuccess) {
    [self parseCityData:proto];
  }
}

#pragma mark - Helper methods

- (void) parseUserData:(StartupResponseProto *)proto {
  User *user = [[(MSDaoAssembly *)_factory userDao] myUser];
  [user syncWithFullUserProto:proto.sender];
}

- (void) parseCityData:(LoadPlayerCityResponseProto *)proto {
  MSDaoAssembly *daoAssembly = (MSDaoAssembly *)_factory;
  User *user = [[daoAssembly userDao] myUser];
  if (proto.cityOwner.userId == user.userId) {
    UserStructDao *userStructDao = [daoAssembly userStructureDao];
    [userStructDao createUserStructDictWithList:proto.ownerNormStructsList];
  }
}

@end
