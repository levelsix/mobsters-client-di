//
//  SocketCommunication.m
//  Utopia
//
//  Created by Ashwin Kamath on 12/21/11.
//  Copyright (c) 2011 LVL6. All rights reserved.
//

#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import "SocketCommunication.h"
#import "ClientProperties.h"
#import "FullEvent.h"
#import "GenericPopupController.h"
#import <AdSupport/AdSupport.h>
#import "FacebookDelegate.h"

#import "SocketCommunication.h"

#import "MSRootViewController.h"
#import "User.h"

// Tags for keeping state
#define READING_HEADER_TAG -1
#define HEADER_SIZE 12

#define RECONNECT_TIMEOUT 0.5f
#define NUM_SILENT_RECONNECTS 1

#define CONNECTED_TO_HOST_DELEGATE_TAG 999998
#define CLAN_EVENT_DELEGATE_TAG 999999

@implementation SocketCommunication

static NSString *udid = nil;

- (NSString *) getIPAddress {
  NSURL *url = [[NSURL alloc] initWithString:@"http://checkip.dyndns.com/"];
  NSString *contents = [NSString stringWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:nil];
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\d+\\.\\d+\\.\\d+\\.\\d+" options:NSRegularExpressionCaseInsensitive error:nil];
  NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:contents options:0 range:NSMakeRange(0, [contents length])];
  if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
    NSString *substringForFirstMatch = [contents substringWithRange:rangeOfFirstMatch];
    return substringForFirstMatch;
  }
  return nil;
}

- (NSString *) getMacAddress {
  int                 mgmtInfoBase[6];
  char                *msgBuffer = NULL;
  size_t              length;
  unsigned char       macAddress[6];
  struct if_msghdr    *interfaceMsgStruct;
  struct sockaddr_dl  *socketStruct;
  NSString            *errorFlag = NULL;
  
  // Setup the management Information Base (mib)
  mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
  mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
  mgmtInfoBase[2] = 0;
  mgmtInfoBase[3] = AF_LINK;        // Request link layer information
  mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
  
  // With all configured interfaces requested, get handle index
  if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) {
    errorFlag = @"if_nametoindex failure";
  } else {
    // Get the size of the data available (store in len)
    if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) {
      errorFlag = @"sysctl mgmtInfoBase failure";
    } else {
      // Alloc memory based on above call
      if ((msgBuffer = malloc(length)) == NULL) {
        errorFlag = @"buffer allocation failure";
      } else {
        // Get system information, store in buffer
        if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
          errorFlag = @"sysctl msgBuffer failure";
      }
    }
  }
  
  // Befor going any further...
  if (errorFlag != NULL) {
    free(msgBuffer);
    NSLog(@"Error: %@", errorFlag);
    return errorFlag;
  }
  
  // Map msgbuffer to interface message structure
  interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
  
  // Map to link-level socket structure
  socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
  
  // Copy link layer address data in socket structure to an array
  memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
  
  // Read from char array into a string object, into traditional Mac address format
  NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                macAddress[0], macAddress[1], macAddress[2],
                                macAddress[3], macAddress[4], macAddress[5]];
  
  // Release the buffer memory
  free(msgBuffer);
  
  return macAddressString;
}

- (NSString *) getIFA {
  ASIdentifierManager *as = [ASIdentifierManager sharedManager];
  NSString *advertiserId = as.advertisingIdentifier.UUIDString;
  return advertiserId;
}

+ (BOOL) isForcedTutorial {
#ifdef FORCE_TUTORIAL
  return YES;
#else
  return NO;
#endif
}

+ (NSString *) getUdid {
  return udid;
}

- (id) init {
  if ((self = [super init])) {
    if (!udid) {
      if ([SocketCommunication isForcedTutorial]) {
        udid = [NSString stringWithFormat:@"%d%d%d", arc4random(), arc4random(), arc4random()];
      } else {
        udid = UDID;
      }
    }
    
    self.connectionThread = [[AMQPConnectionThread alloc] init];
    [self.connectionThread start];
    [self.connectionThread setName:@"AMQPConnectionThread"];
    self.connectionThread.delegate = self;
    
    self.queuedMessages = [NSMutableArray array];
    
    self.clanEventDelegates = [NSMutableArray array];
  }
  return self;
}

- (void) rebuildSender {
  int oldClanId = _sender.clan.clanId;
  User *user = [self.userDao myUser];
  _sender = [user convertToMinimumUserProto];

  // if clan changes, reload the queue
  if (oldClanId != _sender.clan.clanId) {
    [self reloadClanMessageQueue];
  }
}

- (MinimumUserProtoWithMaxResources *) senderWithMaxResources {
  MinimumUserProtoWithMaxResources_Builder *res = [MinimumUserProtoWithMaxResources builder];
  res.minUserProto = _sender;
//  res.maxCash = [gs maxCash];
//  res.maxOil = [gs maxOil];
  return res.build;
}

- (void) tryConnect {
  [FacebookDelegate getFacebookIdAndDoAction:^(NSString *facebookId) {
    [self.connectionThread connectWithUdid:udid facebookId:facebookId];
  }];
}

- (void) initNetworkCommunicationWithDelegate:(id)delegate {
  if (self.popupController) {
    [self.popupController close:nil];
    self.popupController = nil;
  }
  
  [self tryConnect];
  
  // In case we just came from inactive state
  _sender = nil;
  [self rebuildSender];
  _currentTagNum = arc4random();
  _shouldReconnect = YES;
  _numDisconnects = 0;
  _isCreatingQueues = YES;
  
  self.structRetrievals = [NSMutableArray array];
  self.structRetrievalAchievements = [NSMutableDictionary dictionary];
  
  self.tagDelegates = [NSMutableDictionary dictionary];
  [self setDelegate:delegate forTag:CONNECTED_TO_HOST_DELEGATE_TAG];
}

- (void) reloadClanMessageQueue {
  [self.connectionThread reloadClanMessageQueue:self.userDao.myUser.clan.clanId];
}

- (void) connectedToHost {
  MSLog(@"Connected to host");
  
  _isCreatingQueues = NO;
  
  NSObject *delegate = [self.tagDelegates objectForKey:[NSNumber numberWithInt:CONNECTED_TO_HOST_DELEGATE_TAG]];
  if (delegate) {
    SEL selector = @selector(handleConnectedToHost);
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelectorOnMainThread:selector withObject:nil waitUntilDone:NO];
    }
  } else {
    MSLog(@"Unable to find delegate for connectedToHost");
  }
  
  _flushTimer = [NSTimer timerWithTimeInterval:10.f target:self selector:@selector(flush) userInfo:nil repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:_flushTimer forMode:NSRunLoopCommonModes];
  
  NSMutableArray *toRemove = [NSMutableArray array];
  for (FullEvent *fe in self.queuedMessages) {
    if ([self isPreDbEventType:fe.requestType]) {
      [self sendData:fe.event withMessageType:fe.requestType tagNum:fe.tag flush:YES];
      NSLog(@"Sending queued event of type %@.", NSStringFromClass([fe.event class]));
      [toRemove addObject:fe];
    }
  }
  [self.queuedMessages removeObjectsInArray:toRemove];
  
  _numDisconnects = 0;
}

- (void) initUserIdMessageQueue {
  [self.connectionThread startUserIdQueue:self.userDao.myUser.userId];
  
  MSLog(@"Created user id queue");
  
  for (FullEvent *fe in self.queuedMessages) {
    [self sendData:fe.event withMessageType:fe.requestType tagNum:fe.tag flush:YES];
    NSLog(@"Sending queued event of type %@.", NSStringFromClass([fe.event class]));
  }
  [self.queuedMessages removeAllObjects];
}

- (void) tryReconnect {
  self.popupController = nil;
  [self tryConnect];
}

- (void) unableToConnectToHost:(NSString *)error
{
	MSLog(@"Unable to connect: %@", error);
  
  if (_shouldReconnect) {
    _numDisconnects++;
    if (_numDisconnects > NUM_SILENT_RECONNECTS) {
      MSLog(@"Asking to reconnect..");
      self.popupController = [GenericPopupController displayNotificationViewWithText:@"Sorry, we are unable to connect to the server. Please try again." title:@"Disconnected!" okayButton:@"Reconnect" target:self selector:@selector(tryReconnect)];
      _numDisconnects = 0;
    } else {
      MSLog(@"Silently reconnecting..");
      [self tryReconnect];
    }
  }
}

- (BOOL) isPreDbEventType:(EventProtocolRequest)type {
  return type == EventProtocolRequestCStartupEvent || type == EventProtocolRequestCUserCreateEvent;
}

- (void) sendData:(PBGeneratedMessage *)msg withMessageType:(int)type tagNum:(int)tagNum flush:(BOOL)flush {
  if (flush) {
    [self flush];
  }
  
  if (_isCreatingQueues) {
    FullEvent *fe = [FullEvent createWithEvent:msg tag:tagNum requestType:type];
    [self.queuedMessages addObject:fe];
    MSLog(@"Queueing up event of type %@.", NSStringFromClass(msg.class));
    return;
  } else {
    if (_sender.userId == 0) {
      if (![self isPreDbEventType:type]) {
        MSLog(@"User id is 0 or GameState is not connected!!!");
        MSLog(@"Ignoring event of type %@.", NSStringFromClass(msg.class));
        
        //FullEvent *fe = [FullEvent createWithEvent:msg tag:tagNum requestType:type];
        //[self.queuedMessages addObject:fe];
        return;
      }
    }
  }
  
  NSMutableData *messageWithHeader = [NSMutableData data];
  NSData *data = [msg data];
  
  // Need to reverse bytes for size and type(to account for endianness??)
  uint8_t header[HEADER_SIZE];
  header[3] = type & 0xFF;
  header[2] = (type & 0xFF00) >> 8;
  header[1] = (type & 0xFF0000) >> 16;
  header[0] = (type & 0xFF000000) >> 24;
  
  header[7] = tagNum & 0xFF;
  header[6] = (tagNum & 0xFF00) >> 8;
  header[5] = (tagNum & 0xFF0000) >> 16;
  header[4] = (tagNum & 0xFF000000) >> 24;
  
  NSInteger size = [data length];
  header[11] = size & 0xFF;
  header[10] = (size & 0xFF00) >> 8;
  header[9] = (size & 0xFF0000) >> 16;
  header[8] = (size & 0xFF000000) >> 24;
  
  [messageWithHeader appendBytes:header length:sizeof(header)];
  [messageWithHeader appendData:data];
  
  [self.connectionThread sendData:messageWithHeader];
}

- (int) sendData:(PBGeneratedMessage *)msg withMessageType:(int)type flush:(BOOL)flush {
  int tag = _currentTagNum;
  _currentTagNum++;
  _currentTagNum %= RAND_MAX;
  [self sendData:msg withMessageType:type tagNum:tag flush:flush];
  return tag;
}

- (int) sendData:(PBGeneratedMessage *)msg withMessageType:(int)type {
  return [self sendData:msg withMessageType:type flush:YES];
}

- (void) amqpConsumerThreadReceivedNewMessage:(AMQPMessage *)theMessage {
  NSData *data = theMessage.body;
  uint8_t *header = (uint8_t *)[data bytes];
  // Get the next 4 bytes for the payload size
  int nextMsgType = *(int *)(header);
  int tag = *(int *)(header+4);
  //  int size = *(int *)(header+8); // No longer used
  NSData *payload = [data subdataWithRange:NSMakeRange(HEADER_SIZE, data.length-HEADER_SIZE)];
  
  [self messageReceived:payload withType:nextMsgType tag:tag];
}

-(void) messageReceived:(NSData *)data withType:(EventProtocolResponse)eventType tag:(int)tag {
  // Get the proto class for this event type
  Class typeClass = [FullEvent getClassForType:eventType];
  if (!typeClass) {
    MSLog(@"Unable to find controller for event type: %d", eventType);
    return;
  }
  
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
  // Call handle<Proto Class> method in event controller
  NSString *selectorStr = [NSString stringWithFormat:@"handle%@:", [typeClass description]];
  SEL handleMethod = NSSelectorFromString(selectorStr);
  FullEvent *fe = [FullEvent createWithEvent:(PBGeneratedMessage *)[typeClass parseFromData:data] tag:tag];
  
  NSString *statusStr = @"";
  if ([fe.event respondsToSelector:@selector(status)]) {
    statusStr = [NSString stringWithFormat:@" with status %d", [fe.event status]];
  }
  MSLog(@"Received %@%@.", [fe.event class], statusStr);
  
  NSNumber *num = [NSNumber numberWithInt:tag];
  NSObject *delegate = [self.tagDelegates objectForKey:num];
  if (delegate) {
    if ([delegate respondsToSelector:handleMethod]) {
      [delegate performSelector:handleMethod withObject:fe];
    } else {
      MSLog(@"Unable to find %@ in %@", selectorStr, NSStringFromClass(delegate.class));
    }
    [self.tagDelegates removeObjectForKey:num];
  }
  
  BOOL isClanEvent = [FullEvent isEventTypeClanEvent:eventType];
  if (isClanEvent) {
    NSString *selectorStr = [NSString stringWithFormat:@"handleClanEvent%@:", [typeClass description]];
    SEL handleMethod = NSSelectorFromString(selectorStr);
    
    // Copy the delegates array in case it is mutated
    NSArray *curDelegates = [self.clanEventDelegates copy];
    for (id delegate in curDelegates) {
      if ([delegate respondsToSelector:handleMethod]) {
        [delegate performSelector:handleMethod withObject:fe.event];
      }
    }
  }
#pragma clang diagnostic pop
  
  // Rebuild sender after every response is received
  [self rebuildSender];
}

- (void) setDelegate:(id)delegate forTag:(int)tag {
  if (delegate && tag) {
    [self.tagDelegates setObject:delegate forKey:@(tag)];
  }
}

- (void) addClanEventObserver:(id)object {
  [self.clanEventDelegates addObject:object];
}

- (void) removeClanEventObserver:(id)object {
  [self.clanEventDelegates removeObject:object];
}

#pragma mark - Events

- (int) sendUserCreateMessageWithName:(NSString *)name facebookId:(NSString *)facebookId structs:(NSArray *)structs cash:(int)cash oil:(int)oil gems:(int)gems {
  UserCreateRequestProto_Builder *bldr = [UserCreateRequestProto builder];
  
  bldr.udid = udid;
  bldr.name = name;
  bldr.facebookId = facebookId;
  [bldr addAllStructsJustBuilt:structs];
  bldr.cash = cash;
  bldr.oil = oil;
  bldr.cash = cash;
  bldr.gems = gems;
  
  UserCreateRequestProto *req = [bldr build];
  return [self sendData:req withMessageType:EventProtocolRequestCUserCreateEvent];
}

- (int) sendStartupMessageWithFacebookId:(NSString *)facebookId isFreshRestart:(BOOL)isFreshRestart clientTime:(uint64_t)clientTime {
  NSString *advertiserId = [self getIFA];
  NSString *mac = [self getMacAddress];
  StartupRequestProto_Builder *bldr = [[[[[[[StartupRequestProto builder]
                                            setUdid:udid]
                                           setFbId:facebookId]
                                          setIsForceTutorial:[SocketCommunication isForcedTutorial]]
                                         setIsFreshRestart:isFreshRestart]
                                        setVersionNum:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] floatValue]]
                                       setMacAddress:mac];
  
  if (advertiserId) {
    [bldr setAdvertiserId:advertiserId];
  }
  if (facebookId) {
    [bldr setFbId:facebookId];
  }
  
  StartupRequestProto *req = [bldr build];
  
  MSLog(@"Sent over udid: %@", udid);
  MSLog(@"Facebook Id: %@", facebookId);
  MSLog(@"Mac Address: %@", mac);
  MSLog(@"Advertiser ID: %@", advertiserId);
  return [self sendData:req withMessageType:EventProtocolRequestCStartupEvent];
}

- (int) sendLogoutMessage {
  LogoutRequestProto *req = [[[LogoutRequestProto builder]
                              setSender:_sender]
                             build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCLogoutEvent];
}

- (int) sendInAppPurchaseMessage:(NSString *)receipt product:(SKProduct *)product {
  InAppPurchaseRequestProto *req = [[[[[[[[InAppPurchaseRequestProto builder]
                                          setReceipt:receipt]
                                         setLocalcents:[NSString stringWithFormat:@"%d", (int)(product.price.doubleValue*100.)]]
                                        setLocalcurrency:[product.priceLocale objectForKey:NSLocaleCurrencyCode]]
                                       setLocale:[product.priceLocale objectForKey:NSLocaleCountryCode]]
                                      setSender:_sender]
                                     setIpaddr:[self getIPAddress]]
                                    build];
  return [self sendData:req withMessageType:EventProtocolRequestCInAppPurchaseEvent];
}

- (int) sendExchangeGemsForResourcesMessage:(int)gems resources:(int)resources resType:(ResourceType)resType clientTime:(uint64_t)clientTime {
  ExchangeGemsForResourcesRequestProto *req = [[[[[[[ExchangeGemsForResourcesRequestProto builder]
                                                    setSender:[self senderWithMaxResources]]
                                                   setNumGems:gems]
                                                  setResourceType:resType]
                                                 setNumResources:resources]
                                                setClientTime:clientTime]
                                               build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCExchangeGemsForResourcesEvent];
}

- (int) sendPurchaseNormStructureMessage:(int)structId x:(int)x y:(int)y time:(uint64_t)time resourceType:(ResourceType)type resourceChange:(int)resourceChange gemCost:(int)gemCost {
  PurchaseNormStructureRequestProto *req = [[[[[[[[[PurchaseNormStructureRequestProto builder]
                                                   setSender:_sender]
                                                  setStructId:structId]
                                                 setStructCoordinates:[[[[CoordinateProto builder] setX:x] setY:y] build]]
                                                setTimeOfPurchase:time]
                                               setResourceType:type]
                                              setResourceChange:resourceChange]
                                             setGemsSpent:gemCost]
                                            build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCPurchaseNormStructureEvent];
}

- (int) sendMoveNormStructureMessage:(int)userStructId x:(int)x y:(int)y {
  MoveOrRotateNormStructureRequestProto *req =
  [[[[[[MoveOrRotateNormStructureRequestProto builder]
       setSender:_sender]
      setUserStructId:userStructId]
     setType:MoveOrRotateNormStructureRequestProto_MoveOrRotateNormStructTypeMove]
    setCurStructCoordinates:[[[[CoordinateProto builder] setX:x] setY:y] build]]
   build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCMoveOrRotateNormStructureEvent];
}

- (int) sendUpgradeNormStructureMessage:(int)userStructId time:(uint64_t)curTime resourceType:(ResourceType)type resourceChange:(int)resourceChange gemCost:(int)gemCost {
  UpgradeNormStructureRequestProto *req = [[[[[[[[UpgradeNormStructureRequestProto builder]
                                                 setSender:_sender]
                                                setUserStructId:userStructId]
                                               setTimeOfUpgrade:curTime]
                                              setResourceChange:resourceChange]
                                             setResourceType:type]
                                            setGemsSpent:gemCost]
                                           build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCUpgradeNormStructureEvent];
}

- (int) sendFinishNormStructBuildWithDiamondsMessage:(int)userStructId gemCost:(int)gemCost time:(uint64_t)milliseconds {
  FinishNormStructWaittimeWithDiamondsRequestProto *req = [[[[[[FinishNormStructWaittimeWithDiamondsRequestProto builder]
                                                               setSender:_sender]
                                                              setGemCostToSpeedup:gemCost]
                                                             setUserStructId:userStructId]
                                                            setTimeOfSpeedup:milliseconds]
                                                           build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCFinishNormStructWaittimeWithDiamondsEvent];
}

- (int) sendNormStructBuildsCompleteMessage:(NSArray *)userStructIds time:(uint64_t)curTime {
  NormStructWaitCompleteRequestProto *req = [[[[[NormStructWaitCompleteRequestProto builder]
                                                setSender:_sender]
                                               addAllUserStructId:userStructIds]
                                              setCurTime:curTime]
                                             build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCNormStructWaitCompleteEvent];
}

- (int) sendLoadPlayerCityMessage:(int)userId {
  LoadPlayerCityRequestProto *req = [[[[LoadPlayerCityRequestProto builder]
                                       setSender:_sender]
                                      setCityOwnerId:userId]
                                     build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCLoadPlayerCityEvent];
}

- (int) sendLoadCityMessage:(int)cityId {
  LoadCityRequestProto *req = [[[[LoadCityRequestProto builder]
                                 setSender:_sender]
                                setCityId:cityId]
                               build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCLoadCityEvent];
}

- (int) sendLevelUpMessage:(int)level {
  LevelUpRequestProto *req = [[[[LevelUpRequestProto builder]
                                setSender:_sender]
                               setNextLevel:level]
                              build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCLevelUpEvent];
}

- (int) sendQuestAcceptMessage:(int)questId {
  QuestAcceptRequestProto *req = [[[[QuestAcceptRequestProto builder]
                                    setSender:_sender]
                                   setQuestId:questId]
                                  build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCQuestAcceptEvent];
}

- (int) sendQuestProgressMessage:(int)questId isComplete:(BOOL)isComplete userQuestJobs:(NSArray *)userQuestJobs userMonsterIds:(NSArray *)userMonsterIds {
  QuestProgressRequestProto *req = [[[[[[[QuestProgressRequestProto builder]
                                         setSender:_sender]
                                        setQuestId:questId]
                                       setIsComplete:isComplete]
                                      addAllUserQuestJobs:userQuestJobs]
                                     addAllDeleteUserMonsterIds:userMonsterIds]
                                    build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCQuestProgressEvent];
}

- (int) sendQuestRedeemMessage:(int)questId {
  QuestRedeemRequestProto *req = [[[[QuestRedeemRequestProto builder]
                                    setSender:[self senderWithMaxResources]]
                                   setQuestId:questId]
                                  build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCQuestRedeemEvent];
}

- (int) sendRetrieveUsersForUserIds:(NSArray *)userIds includeCurMonsterTeam:(BOOL)includeCurMonsterTeam {
  RetrieveUsersForUserIdsRequestProto *req = [[[[[RetrieveUsersForUserIdsRequestProto builder]
                                                 setSender:_sender]
                                                addAllRequestedUserIds:userIds]
                                               setIncludeCurMonsterTeam:includeCurMonsterTeam]
                                              build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCRetrieveUsersForUserIdsEvent];
}

- (int) sendAPNSMessage:(NSString *)deviceToken {
  EnableAPNSRequestProto *req = [[[[EnableAPNSRequestProto builder]
                                   setSender:_sender]
                                  setDeviceToken:deviceToken]
                                 build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCEnableApnsEvent];
}

- (int) sendSetGameCenterMessage:(NSString *)gameCenterId {
  SetGameCenterIdRequestProto *req = [[[[SetGameCenterIdRequestProto builder]
                                        setSender:_sender]
                                       setGameCenterId:gameCenterId]
                                      build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCSetGameCenterIdEvent];
}

- (int) sendSetFacebookIdMessage:(NSString *)facebookId {
  SetFacebookIdRequestProto *req = [[[[SetFacebookIdRequestProto builder]
                                      setSender:_sender]
                                     setFbId:facebookId]
                                    build];
  
  return [self sendData:req withMessageType:EventProtocolResponseSSetFacebookIdEvent];
}

- (int) sendEarnFreeDiamondsFBConnectMessageClientTime:(uint64_t)time {
  EarnFreeDiamondsRequestProto *req = [[[[[EarnFreeDiamondsRequestProto builder]
                                          setSender:_sender]
                                         setFreeDiamondsType:EarnFreeDiamondsTypeFbConnect]
                                        setClientTime:time]
                                       build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCEarnFreeDiamondsEvent];
}

- (int) sendGroupChatMessage:(GroupChatScope)scope message:(NSString *)msg clientTime:(uint64_t)clientTime {
  SendGroupChatRequestProto *req = [[[[[[SendGroupChatRequestProto builder]
                                        setScope:scope]
                                       setChatMessage:msg]
                                      setSender:_sender]
                                     setClientTime:clientTime]
                                    build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCSendGroupChatEvent];
}

- (int) sendCreateClanMessage:(NSString *)clanName tag:(NSString *)tag description:(NSString *)description requestOnly:(BOOL)requestOnly iconId:(int)iconId cashChange:(int)cashChange gemsSpent:(int)gemsSpent {
  CreateClanRequestProto *req = [[[[[[[[[[CreateClanRequestProto builder]
                                         setSender:_sender]
                                        setName:clanName]
                                       setTag:tag]
                                      setDescription:description]
                                     setRequestToJoinClanRequired:requestOnly]
                                    setClanIconId:iconId]
                                   setCashChange:cashChange]
                                  setGemsSpent:gemsSpent]
                                 build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCCreateClanEvent];
}

- (int) sendLeaveClanMessage {
  LeaveClanRequestProto *req = [[[LeaveClanRequestProto builder]
                                 setSender:_sender]
                                build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCLeaveClanEvent];
}

- (int) sendRequestJoinClanMessage:(int)clanId {
  RequestJoinClanRequestProto *req = [[[[RequestJoinClanRequestProto builder]
                                        setSender:_sender]
                                       setClanId:clanId]
                                      build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCRequestJoinClanEvent];
}

- (int) sendRetractRequestJoinClanMessage:(int)clanId {
  RetractRequestJoinClanRequestProto *req = [[[[RetractRequestJoinClanRequestProto builder]
                                               setSender:_sender]
                                              setClanId:clanId]
                                             build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCRetractRequestJoinClanEvent];
}

- (int) sendApproveOrRejectRequestToJoinClan:(int)requesterId accept:(BOOL)accept {
  ApproveOrRejectRequestToJoinClanRequestProto *req = [[[[[ApproveOrRejectRequestToJoinClanRequestProto builder]
                                                          setSender:_sender]
                                                         setRequesterId:requesterId]
                                                        setAccept:accept]
                                                       build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCApproveOrRejectRequestToJoinClanEvent];
}

- (int) sendTransferClanOwnership:(int)newClanOwnerId {
  TransferClanOwnershipRequestProto *req = [[[[TransferClanOwnershipRequestProto builder]
                                              setSender:_sender]
                                             setClanOwnerIdNew:newClanOwnerId]
                                            build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCTransferClanOwnership];
}

- (int) sendChangeClanDescription:(BOOL)isDescription description:(NSString *)description isRequestType:(BOOL)isRequestType requestRequired:(BOOL)requestRequired isIcon:(BOOL)isIcon iconId:(int)iconId {
  ChangeClanSettingsRequestProto_Builder *bldr = [[ChangeClanSettingsRequestProto builder] setSender:_sender];
  
  if (isDescription) {
    bldr.isChangeDescription = isDescription;
    bldr.descriptionNow = description;
  }
  if (isRequestType) {
    bldr.isChangeJoinType = isRequestType;
    bldr.requestToJoinRequired = requestRequired;
  }
  if (isIcon) {
    bldr.isChangeIcon = isIcon;
    bldr.iconId = iconId;
  }
  
  return [self sendData:bldr.build withMessageType:EventProtocolRequestCChangeClanSettingsEvent];
}

- (int) sendRetrieveClanInfoMessage:(NSString *)clanName clanId:(int)clanId grabType:(RetrieveClanInfoRequestProto_ClanInfoGrabType)grabType isForBrowsingList:(BOOL)isForBrowsingList beforeClanId:(int)beforeClanId {
  RetrieveClanInfoRequestProto_Builder *bldr = [[[[RetrieveClanInfoRequestProto builder]
                                                  setSender:_sender]
                                                 setGrabType:grabType]
                                                setIsForBrowsingList:isForBrowsingList];
  
  if (clanName) bldr.clanName = clanName;
  if (clanId) bldr.clanId = clanId;
  if (beforeClanId) bldr.beforeThisClanId = beforeClanId;
  
  RetrieveClanInfoRequestProto *req = [bldr build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCRetrieveClanInfoEvent];
}

- (int) sendPromoteDemoteClanMemberMessage:(int)victimId newStatus:(UserClanStatus)status {
  PromoteDemoteClanMemberRequestProto *req = [[[[[PromoteDemoteClanMemberRequestProto builder]
                                                 setSender:_sender]
                                                setVictimId:victimId]
                                               setUserClanStatus:status]
                                              build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCPromoteDemoteClanMemberEvent];
}

- (int) sendBootPlayerFromClan:(int)playerId {
  BootPlayerFromClanRequestProto *req = [[[[BootPlayerFromClanRequestProto builder]
                                           setSender:_sender]
                                          setPlayerToBoot:playerId]
                                         build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCBootPlayerFromClanEvent];
}

- (int) sendPurchaseCityExpansionMessageAtX:(int)x atY:(int)y timeOfPurchase:(uint64_t)time {
  PurchaseCityExpansionRequestProto *req = [[[[[[PurchaseCityExpansionRequestProto builder]
                                                setSender:_sender]
                                               setXPosition:x]
                                              setYPosition:y]
                                             setTimeOfPurchase:time]
                                            build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCPurchaseCityExpansionEvent];
}

- (int) sendExpansionWaitCompleteMessage:(BOOL)speedUp gemCost:(int)gemCost curTime:(uint64_t)time atX:(int)x atY:(int)y {
  ExpansionWaitCompleteRequestProto *req = [[[[[[[[ExpansionWaitCompleteRequestProto builder]
                                                  setSender:_sender]
                                                 setXPosition:x]
                                                setYPosition:y]
                                               setSpeedUp:speedUp]
                                              setGemCostToSpeedup:gemCost]
                                             setCurTime:time]
                                            build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCExpansionWaitCompleteEvent];
}

- (int) sendRetrieveTournamentRankingsMessage:(int)eventId afterThisRank:(int)afterThisRank {
  RetrieveTournamentRankingsRequestProto *req = [[[[[RetrieveTournamentRankingsRequestProto builder]
                                                    setSender:_sender]
                                                   setEventId:eventId]
                                                  setAfterThisRank:afterThisRank]
                                                 build];
  return [self sendData:req withMessageType:EventProtocolRequestCRetrieveTournamentRankingsEvent];
}

- (int) sendPurchaseBoosterPackMessage:(int)boosterPackId clientTime:(uint64_t)clientTime {
  PurchaseBoosterPackRequestProto *req = [[[[[PurchaseBoosterPackRequestProto builder]
                                             setSender:_sender]
                                            setBoosterPackId:boosterPackId]
                                           setClientTime:clientTime]
                                          build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCPurchaseBoosterPackEvent];
}

- (int) sendPrivateChatPostMessage:(int)recipientId content:(NSString *)content {
  PrivateChatPostRequestProto *req = [[[[[PrivateChatPostRequestProto builder]
                                         setSender:_sender]
                                        setRecipientId:recipientId]
                                       setContent:content]
                                      build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCPrivateChatPostEvent];
}

- (int) sendRetrievePrivateChatPostsMessage:(int)otherUserId {
  RetrievePrivateChatPostsRequestProto *req = [[[[RetrievePrivateChatPostsRequestProto builder]
                                                 setOtherUserId:otherUserId]
                                                setSender:_sender]
                                               build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCRetrievePrivateChatPostEvent];
}

- (int) sendBeginDungeonMessage:(uint64_t)clientTime taskId:(int)taskId isEvent:(BOOL)isEvent eventId:(int)eventId gems:(int)gems enemyElement:(Element)element shouldForceElem:(BOOL)shouldForceElem questIds:(NSArray *)questIds {
  BeginDungeonRequestProto *req = [[[[[[[[[[[BeginDungeonRequestProto builder]
                                            setSender:_sender]
                                           setClientTime:clientTime]
                                          setTaskId:taskId]
                                         setIsEvent:isEvent]
                                        setPersistentEventId:eventId]
                                       setGemsSpent:gems]
                                      setElem:element]
                                     setForceEnemyElem:shouldForceElem]
                                    addAllQuestIds:questIds]
                                   build];
  return [self sendData:req withMessageType:EventProtocolRequestCBeginDungeonEvent];
}

- (int) sendUpdateMonsterHealthMessage:(uint64_t)clientTime monsterHealths:(NSArray *)monsterHealths isForTask:(BOOL)isForTask userTaskId:(int64_t)userTaskId taskStageId:(int)taskStageId {
  UpdateMonsterHealthRequestProto *req = [[[[[[[[UpdateMonsterHealthRequestProto builder]
                                                setSender:_sender]
                                               setClientTime:clientTime]
                                              addAllUmchp:monsterHealths]
                                             setIsUpdateTaskStageForUser:isForTask]
                                            setUserTaskId:userTaskId]
                                           setNuTaskStageId:taskStageId]
                                          build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCUpdateMonsterHealthEvent];
}

- (int) sendEndDungeonMessage:(uint64_t)userTaskId userWon:(BOOL)userWon isFirstTimeCompleted:(BOOL)isFirstTimeCompleted time:(uint64_t)time {
  EndDungeonRequestProto *req = [[[[[[[EndDungeonRequestProto builder]
                                      setSender:[self senderWithMaxResources]]
                                     setUserTaskId:userTaskId]
                                    setUserWon:userWon]
                                   setFirstTimeUserWonTask:isFirstTimeCompleted]
                                  setClientTime:time]
                                 build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCEndDungeonEvent];
}

- (int) sendCombineUserMonsterPiecesMessage:(NSArray *)userMonsterIds gemCost:(int)gemCost {
  CombineUserMonsterPiecesRequestProto *req = [[[[[CombineUserMonsterPiecesRequestProto builder]
                                                  setSender:_sender]
                                                 addAllUserMonsterIds:userMonsterIds]
                                                setGemCost:gemCost]
                                               build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCCombineUserMonsterPiecesEvent];
}

- (int) sendSellUserMonstersMessage:(NSArray *)sellProtos {
  SellUserMonsterRequestProto *req = [[[[SellUserMonsterRequestProto builder]
                                        setSender:[self senderWithMaxResources]]
                                       addAllSales:sellProtos]
                                      build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCSellUserMonsterEvent];
}

- (int) sendInviteFbFriendsForSlotsMessage:(NSArray *)fbFriendInvites {
  NSString *facebookId = [[self.userDao myUser] facebookId];
  MinimumUserProtoWithFacebookId *mup = [[[[MinimumUserProtoWithFacebookId builder]
                                           setMinUserProto:_sender]
                                          setFacebookId:facebookId]
                                         build];
  
  InviteFbFriendsForSlotsRequestProto *req = [[[[InviteFbFriendsForSlotsRequestProto builder]
                                                setSender:mup]
                                               addAllInvites:fbFriendInvites]
                                              build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCInviteFbFriendsForSlotsEvent];
}

- (int) sendAcceptAndRejectFbInviteForSlotsMessageAndAcceptIds:(NSArray *)acceptIds rejectIds:(NSArray *)rejectIds {
  NSString *facebookId = [[self.userDao myUser] facebookId];
  MinimumUserProtoWithFacebookId *mup = [[[[MinimumUserProtoWithFacebookId builder]
                                           setMinUserProto:_sender]
                                          setFacebookId:facebookId]
                                         build];
  
  AcceptAndRejectFbInviteForSlotsRequestProto *req = [[[[[AcceptAndRejectFbInviteForSlotsRequestProto builder]
                                                         setSender:mup]
                                                        addAllAcceptedInviteIds:acceptIds]
                                                       addAllRejectedInviteIds:rejectIds]
                                                      build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCAcceptAndRejectFbInviteForSlotsEvent];
}

- (int) sendEvolveMonsterMessageWithEvolution:(UserMonsterEvolutionProto *)evo gemCost:(int)gemCost oilChange:(int)oilChange {
  EvolveMonsterRequestProto *req = [[[[[[EvolveMonsterRequestProto builder]
                                        setSender:_sender]
                                       setEvolution:evo]
                                      setGemsSpent:gemCost]
                                     setOilChange:oilChange]
                                    build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCEvolveMonsterEvent];
}

- (int) sendEvolutionFinishedMessageWithGems:(int)gems {
  EvolutionFinishedRequestProto *req = [[[[EvolutionFinishedRequestProto builder]
                                          setSender:_sender]
                                         setGemsSpent:gems]
                                        build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCEvolutionFinishedEvent];
}

- (int) sendReviveInDungeonMessage:(uint64_t)userTaskId clientTime:(uint64_t)clientTime userHealths:(NSArray *)healths gems:(int)gems {
  ReviveInDungeonRequestProto *req = [[[[[[[ReviveInDungeonRequestProto builder]
                                           setSender:_sender]
                                          setUserTaskId:userTaskId]
                                         setClientTime:clientTime]
                                        addAllReviveMe:healths]
                                       setGemsSpent:gems]
                                      build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCReviveInDungeonEvent];
}

- (int) sendQueueUpMessage:(NSArray *)seenUserIds elo:(int)elo clientTime:(uint64_t)clientTime {
  QueueUpRequestProto *req = [[[[[[QueueUpRequestProto builder]
                                  addAllSeenUserIds:seenUserIds]
                                 setAttackerElo:elo]
                                setAttacker:_sender]
                               setClientTime:clientTime]
                              build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCQueueUpEvent];
}

- (int) sendUpdateUserCurrencyMessageWithCashSpent:(int)cashSpent oilSpent:(int)oilSpent gemsSpent:(int)gemsSpent clientTime:(uint64_t)clientTime reason:(NSString *)reason {
  UpdateUserCurrencyRequestProto *req = [[[[[[[[UpdateUserCurrencyRequestProto builder]
                                               setSender:_sender]
                                              setCashSpent:cashSpent]
                                             setOilSpent:oilSpent]
                                            setGemsSpent:gemsSpent]
                                           setClientTime:clientTime]
                                          setReason:reason]
                                         build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCUpdateUserCurrencyEvent];
}

- (int) sendBeginPvpBattleMessage:(PvpProto *)enemy senderElo:(int)elo isRevenge:(BOOL)isRevenge previousBattleTime:(uint64_t)previousBattleTime clientTime:(uint64_t)clientTime {
  BeginPvpBattleRequestProto *req = [[[[[[[[BeginPvpBattleRequestProto builder]
                                           setSender:_sender]
                                          setEnemy:enemy]
                                         setSenderElo:elo]
                                        setAttackStartTime:clientTime]
                                       setPreviousBattleEndTime:previousBattleTime]
                                      setExactingRevenge:isRevenge]
                                     build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCBeginPvpBattleEvent];
}

- (int) sendEndPvpBattleMessage:(int)defenderId userAttacked:(BOOL)userAttacked userWon:(BOOL)userWon oilChange:(int)oilChange cashChange:(int)cashChange clientTime:(uint64_t)clientTime {
  EndPvpBattleRequestProto *req = [[[[[[[[[EndPvpBattleRequestProto builder]
                                          setSender:[self senderWithMaxResources]]
                                         setDefenderId:defenderId]
                                        setUserAttacked:userAttacked]
                                       setUserWon:userWon]
                                      setOilChange:oilChange]
                                     setCashChange:cashChange]
                                    setClientTime:clientTime]
                                   build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCEndPvpBattleEvent];
}

- (int) sendBeginClanRaidMessage:(int)raidId eventId:(int)eventId isFirstStage:(BOOL)isFirstStage curTime:(uint64_t)curTime userMonsters:(NSArray *)userMonsters {
  BeginClanRaidRequestProto_Builder *bldr = [[[[[[BeginClanRaidRequestProto builder]
                                                 setSender:_sender]
                                                setCurTime:curTime]
                                               setRaidId:raidId]
                                              setClanEventId:eventId]
                                             setIsFirstStage:isFirstStage];
  
  if (userMonsters.count > 0) {
    [bldr setSetMonsterTeamForRaid:YES];
    [bldr addAllUserMonsters:userMonsters];
  }
  
  return [self sendData:bldr.build withMessageType:EventProtocolRequestCBeginClanRaidEvent];
}

- (int) sendAttackClanRaidMonsterMessage:(PersistentClanEventClanInfoProto *)eventDetails clientTime:(uint64_t)clientTime damageDealt:(int)damageDealt curTeam:(UserCurrentMonsterTeamProto *)curTeam monsterHealths:(NSArray *)monsterHealths attacker:(FullUserMonsterProto *)attacker {
  AttackClanRaidMonsterRequestProto_Builder *bldr = [AttackClanRaidMonsterRequestProto builder];
  bldr.sender = _sender;
  bldr.eventDetails = eventDetails;
  bldr.clientTime = clientTime;
  bldr.damageDealt = damageDealt;
  [bldr addAllMonsterHealths:monsterHealths];
  bldr.userMonsterTeam = curTeam;
  bldr.userMonsterThatAttacked = attacker;
  
  return [self sendData:bldr.build withMessageType:EventProtocolRequestCAttackClanRaidMonsterEvent];
}

- (int) sendSpawnObstacleMessage:(NSArray *)obstacles clientTime:(uint64_t)clientTime {
  SpawnObstacleRequestProto *req = [[[[[SpawnObstacleRequestProto builder]
                                       setSender:_sender]
                                      addAllProspectiveObstacles:obstacles]
                                     setCurTime:clientTime]
                                    build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCSpawnObstacleEvent];
}

- (int) sendBeginObstacleRemovalMessage:(int)userObstacleId resType:(ResourceType)resType resChange:(int)resChange gemsSpent:(int)gemsSpent clientTime:(uint64_t)clientTime {
  BeginObstacleRemovalRequestProto *req = [[[[[[[[BeginObstacleRemovalRequestProto builder]
                                                 setSender:_sender]
                                                setUserObstacleId:userObstacleId]
                                               setResourceType:resType]
                                              setResourceChange:resChange]
                                             setGemsSpent:gemsSpent]
                                            setCurTime:clientTime]
                                           build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCBeginObstacleRemovalEvent];
}

- (int) sendObstacleRemovalCompleteMessage:(int)userObstacleId speedup:(BOOL)speedUp gemsSpent:(int)gemsSpent maxObstacles:(BOOL)maxObstacles clientTime:(uint64_t)clientTime {
  ObstacleRemovalCompleteRequestProto *req = [[[[[[[[ObstacleRemovalCompleteRequestProto builder]
                                                    setUserObstacleId:userObstacleId]
                                                   setSender:_sender]
                                                  setSpeedUp:speedUp]
                                                 setGemsSpent:gemsSpent]
                                                setAtMaxObstacles:maxObstacles]
                                               setCurTime:clientTime]
                                              build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCObstacleRemovalCompleteEvent];
}

- (int) sendAchievementProgressMessage:(NSArray *)userAchievements clientTime:(uint64_t)clientTime {
  // If we are currently batching struct retrievals, save all achievements till the struct retrievals completes
  if (self.structRetrievals.count == 0) {
    AchievementProgressRequestProto *req = [[[[[AchievementProgressRequestProto builder]
                                               setSender:_sender]
                                              setClientTime:clientTime]
                                             addAllUapList:userAchievements]
                                            build];
    
    return [self sendData:req withMessageType:EventProtocolRequestCAchievementProgressEvent];
  } else {
    // Use a dictionary so that repeats will be replaced (i.e. 2 retrievals of cash)
    for (UserAchievementProto *uap in userAchievements) {
      [self.structRetrievalAchievements setObject:uap forKey:@(uap.achievementId)];
    }
    
    self.lastClientTime = clientTime;
    return _currentTagNum+1;
  }
}

- (int) sendAchievementRedeemMessage:(int)achievementId clientTime:(uint64_t)clientTime {
  AchievementRedeemRequestProto *req = [[[[[AchievementRedeemRequestProto builder]
                                           setSender:_sender]
                                          setAchievementId:achievementId]
                                         setClientTime:clientTime]
                                        build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCAchievementRedeemEvent];
}

- (int) sendSpawnMiniJobMessage:(int)numToSpawn clientTime:(uint64_t)clientTime structId:(int)structId {
  SpawnMiniJobRequestProto *req = [[[[[[SpawnMiniJobRequestProto builder]
                                       setSender:_sender]
                                      setNumToSpawn:numToSpawn]
                                     setClientTime:clientTime]
                                    setStructId:structId]
                                   build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCSpawnMiniJobEvent];
}

- (int) sendBeginMiniJobMessage:(uint64_t)userMiniJobId userMonsterIds:(NSArray *)userMonsterIds clientTime:(uint64_t)clientTime {
  BeginMiniJobRequestProto *req = [[[[[[BeginMiniJobRequestProto builder]
                                       setSender:_sender]
                                      setUserMiniJobId:userMiniJobId]
                                     addAllUserMonsterIds:userMonsterIds]
                                    setClientTime:clientTime]
                                   build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCBeginMiniJobEvent];
}

- (int) sendCompleteMiniJobMessage:(uint64_t)userMiniJobId isSpeedUp:(BOOL)isSpeedUp gemCost:(int)gemCost clientTime:(uint64_t)clientTime monsterHealths:(NSArray *)monsterHealths {
  CompleteMiniJobRequestProto *req = [[[[[[[[CompleteMiniJobRequestProto builder]
                                            setSender:_sender]
                                           setUserMiniJobId:userMiniJobId]
                                          setIsSpeedUp:isSpeedUp]
                                         setGemCost:gemCost]
                                        setClientTime:clientTime]
                                       addAllUmchp:monsterHealths]
                                      build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCCompleteMiniJobEvent];
}

- (int) sendRedeemMiniJobMessage:(uint64_t)userMiniJobId clientTime:(uint64_t)clientTime {
  RedeemMiniJobRequestProto *req = [[[[[RedeemMiniJobRequestProto builder]
                                       setSender:[self senderWithMaxResources]]
                                      setUserMiniJobId:userMiniJobId]
                                     setClientTime:clientTime]
                                    build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCRedeemMiniJobEvent];
}

#pragma mark - Batch/Flush events

- (int) sendHealQueueWaitTimeComplete:(NSArray *)monsterHealths {
  HealMonsterRequestProto *req = [[[[HealMonsterRequestProto builder]
                                    setSender:[self senderWithMaxResources]]
                                   addAllUmchp:monsterHealths]
                                  build];
  
  // Must manually flush in case heal is being batched
  [self flush];
  int tag = [self sendData:req withMessageType:EventProtocolRequestCHealMonsterEvent];
  
  [self reloadHealQueueSnapshot];
  
  return tag;
}

- (int) sendHealQueueSpeedup:(NSArray *)monsterHealths goldCost:(int)goldCost {
  HealMonsterRequestProto *req = [[[[[[HealMonsterRequestProto builder]
                                      setSender:[self senderWithMaxResources]]
                                     setIsSpeedup:YES]
                                    setGemsForSpeedup:goldCost]
                                   addAllUmchp:monsterHealths]
                                  build];
  
  int tag = [self sendData:req withMessageType:EventProtocolRequestCHealMonsterEvent];
  
  [self reloadHealQueueSnapshot];
  
  return tag;
}

- (int) sendAddMonsterToTeam:(uint64_t)userMonsterId teamSlot:(int)teamSlot {
  AddMonsterToBattleTeamRequestProto *req = [[[[[AddMonsterToBattleTeamRequestProto builder]
                                                setSender:_sender]
                                               setUserMonsterId:userMonsterId]
                                              setTeamSlotNum:teamSlot]
                                             build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCAddMonsterToBattleTeamEvent];
}

- (int) sendRemoveMonsterFromTeam:(uint64_t)userMonsterId {
  RemoveMonsterFromBattleTeamRequestProto *req = [[[[RemoveMonsterFromBattleTeamRequestProto builder]
                                                    setSender:_sender]
                                                   setUserMonsterId:userMonsterId]
                                                  build];
  
  return [self sendData:req withMessageType:EventProtocolRequestCRemoveMonsterFromBattleTeamEvent];
}

- (int) sendBuyInventorySlotsWithGems:(int)userStructId {
  IncreaseMonsterInventorySlotRequestProto *req = [[[[[IncreaseMonsterInventorySlotRequestProto builder]
                                                      setSender:_sender]
                                                     setIncreaseSlotType:IncreaseMonsterInventorySlotRequestProto_IncreaseSlotTypePurchase]
                                                    setUserStructId:userStructId]
                                                   build];
  
  return [self sendData:req withMessageType:EventProtocolResponseSIncreaseMonsterInventorySlotEvent];
}

- (int) sendBuyInventorySlots:(int)userStructId withFriendInvites:(NSArray *)inviteIds {
  IncreaseMonsterInventorySlotRequestProto *req = [[[[[[IncreaseMonsterInventorySlotRequestProto builder]
                                                       setSender:_sender]
                                                      setIncreaseSlotType:IncreaseMonsterInventorySlotRequestProto_IncreaseSlotTypeRedeemFacebookInvites]
                                                     setUserStructId:userStructId]
                                                    addAllUserFbInviteForSlotIds:inviteIds]
                                                   build];
  
  return [self sendData:req withMessageType:EventProtocolResponseSIncreaseMonsterInventorySlotEvent];
}

- (int) sendEnhanceQueueWaitTimeComplete:(UserMonsterCurrentExpProto *)monsterExp userMonsterIds:(NSArray *)userMonsterIds {
  EnhancementWaitTimeCompleteRequestProto *req = [[[[[EnhancementWaitTimeCompleteRequestProto builder]
                                                     setSender:_sender]
                                                    setUmcep:monsterExp]
                                                   addAllUserMonsterIds:userMonsterIds]
                                                  build];
  
  int tag = [self sendData:req withMessageType:EventProtocolRequestCEnhancementWaitTimeCompleteEvent];
  
  [self reloadEnhancementSnapshot];
  
  return tag;
}

- (int) sendEnhanceQueueSpeedup:(UserMonsterCurrentExpProto *)monsterExp userMonsterIds:(NSArray *)userMonsterIds goldCost:(int)goldCost {
  EnhancementWaitTimeCompleteRequestProto *req = [[[[[[[EnhancementWaitTimeCompleteRequestProto builder]
                                                       setSender:_sender]
                                                      setUmcep:monsterExp]
                                                     setIsSpeedup:YES]
                                                    setGemsForSpeedup:goldCost]
                                                   addAllUserMonsterIds:userMonsterIds]
                                                  build];
  
  int tag = [self sendData:req withMessageType:EventProtocolRequestCEnhancementWaitTimeCompleteEvent];
  
  [self reloadEnhancementSnapshot];
  
  return tag;
}

- (int) retrieveCurrencyFromStruct:(int)userStructId time:(uint64_t)time amountCollected:(int)amountCollected {
  [self flushAllExceptEventType:EventProtocolRequestCRetrieveCurrencyFromNormStructureEvent];
  RetrieveCurrencyFromNormStructureRequestProto_StructRetrieval *sr = [[[[[RetrieveCurrencyFromNormStructureRequestProto_StructRetrieval builder]
                                                                          setUserStructId:userStructId]
                                                                         setTimeOfRetrieval:time]
                                                                        setAmountCollected:amountCollected]
                                                                       build];
  [self.structRetrievals addObject:sr];
  return _currentTagNum;
}

- (int) sendRetrieveCurrencyFromNormStructureMessage {
  RetrieveCurrencyFromNormStructureRequestProto *req = [[[[RetrieveCurrencyFromNormStructureRequestProto builder]
                                                          setSender:[self senderWithMaxResources]]
                                                         addAllStructRetrievals:self.structRetrievals]
                                                        build];
  
  MSLog(@"Sending retrieve currency message with %d structs.",  (int)self.structRetrievals.count);
  
  return [self sendData:req withMessageType:EventProtocolRequestCRetrieveCurrencyFromNormStructureEvent flush:NO];
}

- (int) setHealQueueDirtyWithCoinChange:(int)coinChange gemCost:(int)gemCost {
  [self flushAllExceptEventType:EventProtocolRequestCHealMonsterEvent];
  _healingQueueCashChange += coinChange;
  _healingQueueGemCost += gemCost;
  _healingQueuePotentiallyChanged = YES;
  return _currentTagNum;
}

- (void) reloadHealQueueSnapshot {
//  GameState *gs = [GameState sharedGameState];
//  self.healingQueueSnapshot = [gs.monsterHealingQueue clone];
}

- (int) sendHealMonsterMessage {
//  NSMutableSet *old = [NSMutableSet setWithArray:self.healingQueueSnapshot];
//  NSMutableSet *cur = nil;//[NSMutableSet setWithArray:gs.monsterHealingQueue];
//  
//  NSMutableSet *added = cur.mutableCopy;
//  [added minusSet:old];
//  
//  NSMutableSet *removed = old.mutableCopy;
//  [removed minusSet:cur];
//  
//  NSMutableSet *modifiedOld = old.mutableCopy;
//  [modifiedOld intersectSet:cur];
//  
//  NSMutableSet *modifiedCur = cur.mutableCopy;
//  [modifiedCur intersectSet:old];
//  
//  NSMutableSet *changed = [NSMutableSet set];
//  for (UserMonsterHealingItem *itemOld in modifiedOld) {
//    UserMonsterHealingItem *itemNew = [modifiedCur member:itemOld];
//    if (![[itemOld convertToProto].data isEqual:[itemNew convertToProto].data]) {
//      [changed addObject:itemNew];
//    }
//  }
//  
//  if (added.count || removed.count || changed.count || _healingQueueCashChange || _healingQueueGemCost) {
//    HealMonsterRequestProto_Builder *bldr = [[HealMonsterRequestProto builder] setSender:[self senderWithMaxResources]];
//    
//    for (UserMonsterHealingItem *item in added) {
//      [bldr addUmhNew:[item convertToProto]];
//    }
//    
//    for (UserMonsterHealingItem *item in removed) {
//      [bldr addUmhDelete:[item convertToProto]];
//    }
//    
//    for (UserMonsterHealingItem *item in changed) {
//      [bldr addUmhUpdate:[item convertToProto]];
//    }
//    
//    [bldr setCashChange:_healingQueueCashChange];
//    [bldr setGemCostForHealing:_healingQueueGemCost];
//    
//    NSLog(@"Sending healing queue update with %d adds, %d removals, and %d updates.",  (int)added.count,  (int)removed.count,  (int)changed.count);
//    NSLog(@"Cash change: %@, gemCost: %d", [Globals commafyNumber:_healingQueueCashChange], _healingQueueGemCost);
//    
//    return [self sendData:bldr.build withMessageType:EventProtocolRequestCHealMonsterEvent flush:NO];
//  } else {
    return 0;
//  }
}

- (int) setEnhanceQueueDirtyWithCoinChange:(int)coinChange gemCost:(int)gemCost {
  [self flushAllExceptEventType:EventProtocolRequestCSubmitMonsterEnhancementEvent];
  _enhanceQueueOilChange += coinChange;
  _enhanceQueueGemCost += gemCost;
  _enhancementPotentiallyChanged = YES;
  return _currentTagNum;
}

- (void) reloadEnhancementSnapshot {
//  GameState *gs = [GameState sharedGameState];
//  self.enhancementSnapshot = [gs.userEnhancement clone];
}

- (int) sendEnhanceMonsterMessage {
//  NSMutableSet *old = [NSMutableSet setWithArray:self.enhancementSnapshot.feeders];
//  if (self.enhancementSnapshot.baseMonster) [old addObject:self.enhancementSnapshot.baseMonster];
//  NSMutableSet *cur = [NSMutableSet setWithArray:gs.userEnhancement.feeders];
//  if (gs.userEnhancement.baseMonster) [cur addObject:gs.userEnhancement.baseMonster];
//  
//  NSMutableSet *added = cur.mutableCopy;
//  [added minusSet:old];
//  
//  NSMutableSet *removed = old.mutableCopy;
//  [removed minusSet:cur];
//  
//  NSMutableSet *modifiedOld = old.mutableCopy;
//  [modifiedOld intersectSet:cur];
//  
//  NSMutableSet *modifiedCur = cur.mutableCopy;
//  [modifiedCur intersectSet:old];
//  
//  NSMutableSet *changed = [NSMutableSet set];
//  for (EnhancementItem *itemOld in modifiedOld) {
//    EnhancementItem *itemNew = [modifiedCur member:itemOld];
//    if (![[itemOld convertToProto].data isEqual:[itemNew convertToProto].data]) {
//      [changed addObject:itemNew];
//    }
//  }
//  
//  if (added.count || removed.count || changed.count || _enhanceQueueOilChange || _enhanceQueueGemCost) {
//    SubmitMonsterEnhancementRequestProto_Builder *bldr = [[SubmitMonsterEnhancementRequestProto builder] setSender:[self senderWithMaxResources]];
//    
//    for (EnhancementItem *item in added) {
//      [bldr addUeipNew:[item convertToProto]];
//    }
//    
//    for (EnhancementItem *item in removed) {
//      [bldr addUeipDelete:[item convertToProto]];
//    }
//    
//    for (EnhancementItem *item in changed) {
//      [bldr addUeipUpdate:[item convertToProto]];
//    }
//    
//    [bldr setOilChange:_enhanceQueueOilChange];
//    [bldr setGemsSpent:_enhanceQueueGemCost];
//    
//    NSLog(@"Sending enhancement update with %d adds, %d removals, and %d updates.",  (int)added.count,  (int)removed.count,  (int)changed.count);
//    
//    return [self sendData:bldr.build withMessageType:EventProtocolRequestCSubmitMonsterEnhancementEvent flush:NO];
//  } else {
    return 0;
//  }
}

- (void) flush {
  [self flushAllExceptEventType:-1];
}

- (void) flushAllExceptEventType:(int)val {
  [self flushAllExcept:[NSNumber numberWithInt:val]];
}

- (void) flushAllExcept:(NSNumber *)num {
  int type = num.intValue;
  if (type != EventProtocolRequestCRetrieveCurrencyFromNormStructureEvent) {
    if (self.structRetrievals.count > 0) {
      [self sendRetrieveCurrencyFromNormStructureMessage];
      [self.structRetrievals removeAllObjects];
      
      if (self.structRetrievalAchievements.count) {
        [self sendAchievementProgressMessage:self.structRetrievalAchievements.allValues clientTime:self.lastClientTime];
        [self.structRetrievalAchievements removeAllObjects];
      }
    }
  }
  
  if (type != EventProtocolRequestCHealMonsterEvent) {
    if (_healingQueuePotentiallyChanged) {
      [self sendHealMonsterMessage];
      [self reloadHealQueueSnapshot];
      _healingQueuePotentiallyChanged = NO;
      _healingQueueGemCost = 0;
      _healingQueueCashChange = 0;
    }
  }
  
  if (type != EventProtocolRequestCSubmitMonsterEnhancementEvent) {
    if (_enhancementPotentiallyChanged) {
      [self sendEnhanceMonsterMessage];
      [self reloadEnhancementSnapshot];
      _enhancementPotentiallyChanged = NO;
      _enhanceQueueGemCost = 0;
      _enhanceQueueOilChange = 0;
    }
  }
}

- (void) closeDownConnection {
  [_flushTimer invalidate];
  _flushTimer = nil;
  [self flush];
  [self.connectionThread end];
}

@end
