// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "Chat.pb.h"

@implementation ChatRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [ChatRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [UserRoot registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

BOOL GroupChatScopeIsValidValue(GroupChatScope value) {
  switch (value) {
    case GroupChatScopeClan:
    case GroupChatScopeGlobal:
      return YES;
    default:
      return NO;
  }
}
@interface PrivateChatPostProto ()
@property int32_t privateChatPostId;
@property (retain) MinimumUserProtoWithLevel* poster;
@property (retain) MinimumUserProtoWithLevel* recipient;
@property int64_t timeOfPost;
@property (retain) NSString* content;
@end

@implementation PrivateChatPostProto

- (BOOL) hasPrivateChatPostId {
  return !!hasPrivateChatPostId_;
}
- (void) setHasPrivateChatPostId:(BOOL) value {
  hasPrivateChatPostId_ = !!value;
}
@synthesize privateChatPostId;
- (BOOL) hasPoster {
  return !!hasPoster_;
}
- (void) setHasPoster:(BOOL) value {
  hasPoster_ = !!value;
}
@synthesize poster;
- (BOOL) hasRecipient {
  return !!hasRecipient_;
}
- (void) setHasRecipient:(BOOL) value {
  hasRecipient_ = !!value;
}
@synthesize recipient;
- (BOOL) hasTimeOfPost {
  return !!hasTimeOfPost_;
}
- (void) setHasTimeOfPost:(BOOL) value {
  hasTimeOfPost_ = !!value;
}
@synthesize timeOfPost;
- (BOOL) hasContent {
  return !!hasContent_;
}
- (void) setHasContent:(BOOL) value {
  hasContent_ = !!value;
}
@synthesize content;
- (void) dealloc {
  self.poster = nil;
  self.recipient = nil;
  self.content = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.privateChatPostId = 0;
    self.poster = [MinimumUserProtoWithLevel defaultInstance];
    self.recipient = [MinimumUserProtoWithLevel defaultInstance];
    self.timeOfPost = 0L;
    self.content = @"";
  }
  return self;
}
static PrivateChatPostProto* defaultPrivateChatPostProtoInstance = nil;
+ (void) initialize {
  if (self == [PrivateChatPostProto class]) {
    defaultPrivateChatPostProtoInstance = [[PrivateChatPostProto alloc] init];
  }
}
+ (PrivateChatPostProto*) defaultInstance {
  return defaultPrivateChatPostProtoInstance;
}
- (PrivateChatPostProto*) defaultInstance {
  return defaultPrivateChatPostProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasPrivateChatPostId) {
    [output writeInt32:1 value:self.privateChatPostId];
  }
  if (self.hasPoster) {
    [output writeMessage:2 value:self.poster];
  }
  if (self.hasRecipient) {
    [output writeMessage:3 value:self.recipient];
  }
  if (self.hasTimeOfPost) {
    [output writeInt64:4 value:self.timeOfPost];
  }
  if (self.hasContent) {
    [output writeString:5 value:self.content];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasPrivateChatPostId) {
    size += computeInt32Size(1, self.privateChatPostId);
  }
  if (self.hasPoster) {
    size += computeMessageSize(2, self.poster);
  }
  if (self.hasRecipient) {
    size += computeMessageSize(3, self.recipient);
  }
  if (self.hasTimeOfPost) {
    size += computeInt64Size(4, self.timeOfPost);
  }
  if (self.hasContent) {
    size += computeStringSize(5, self.content);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (PrivateChatPostProto*) parseFromData:(NSData*) data {
  return (PrivateChatPostProto*)[[[PrivateChatPostProto builder] mergeFromData:data] build];
}
+ (PrivateChatPostProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PrivateChatPostProto*)[[[PrivateChatPostProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (PrivateChatPostProto*) parseFromInputStream:(NSInputStream*) input {
  return (PrivateChatPostProto*)[[[PrivateChatPostProto builder] mergeFromInputStream:input] build];
}
+ (PrivateChatPostProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PrivateChatPostProto*)[[[PrivateChatPostProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PrivateChatPostProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (PrivateChatPostProto*)[[[PrivateChatPostProto builder] mergeFromCodedInputStream:input] build];
}
+ (PrivateChatPostProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (PrivateChatPostProto*)[[[PrivateChatPostProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (PrivateChatPostProto_Builder*) builder {
  return [[[PrivateChatPostProto_Builder alloc] init] autorelease];
}
+ (PrivateChatPostProto_Builder*) builderWithPrototype:(PrivateChatPostProto*) prototype {
  return [[PrivateChatPostProto builder] mergeFrom:prototype];
}
- (PrivateChatPostProto_Builder*) builder {
  return [PrivateChatPostProto builder];
}
@end

@interface PrivateChatPostProto_Builder()
@property (retain) PrivateChatPostProto* result;
@end

@implementation PrivateChatPostProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[PrivateChatPostProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (PrivateChatPostProto_Builder*) clear {
  self.result = [[[PrivateChatPostProto alloc] init] autorelease];
  return self;
}
- (PrivateChatPostProto_Builder*) clone {
  return [PrivateChatPostProto builderWithPrototype:result];
}
- (PrivateChatPostProto*) defaultInstance {
  return [PrivateChatPostProto defaultInstance];
}
- (PrivateChatPostProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (PrivateChatPostProto*) buildPartial {
  PrivateChatPostProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (PrivateChatPostProto_Builder*) mergeFrom:(PrivateChatPostProto*) other {
  if (other == [PrivateChatPostProto defaultInstance]) {
    return self;
  }
  if (other.hasPrivateChatPostId) {
    [self setPrivateChatPostId:other.privateChatPostId];
  }
  if (other.hasPoster) {
    [self mergePoster:other.poster];
  }
  if (other.hasRecipient) {
    [self mergeRecipient:other.recipient];
  }
  if (other.hasTimeOfPost) {
    [self setTimeOfPost:other.timeOfPost];
  }
  if (other.hasContent) {
    [self setContent:other.content];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (PrivateChatPostProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (PrivateChatPostProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setPrivateChatPostId:[input readInt32]];
        break;
      }
      case 18: {
        MinimumUserProtoWithLevel_Builder* subBuilder = [MinimumUserProtoWithLevel builder];
        if (self.hasPoster) {
          [subBuilder mergeFrom:self.poster];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setPoster:[subBuilder buildPartial]];
        break;
      }
      case 26: {
        MinimumUserProtoWithLevel_Builder* subBuilder = [MinimumUserProtoWithLevel builder];
        if (self.hasRecipient) {
          [subBuilder mergeFrom:self.recipient];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setRecipient:[subBuilder buildPartial]];
        break;
      }
      case 32: {
        [self setTimeOfPost:[input readInt64]];
        break;
      }
      case 42: {
        [self setContent:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasPrivateChatPostId {
  return result.hasPrivateChatPostId;
}
- (int32_t) privateChatPostId {
  return result.privateChatPostId;
}
- (PrivateChatPostProto_Builder*) setPrivateChatPostId:(int32_t) value {
  result.hasPrivateChatPostId = YES;
  result.privateChatPostId = value;
  return self;
}
- (PrivateChatPostProto_Builder*) clearPrivateChatPostId {
  result.hasPrivateChatPostId = NO;
  result.privateChatPostId = 0;
  return self;
}
- (BOOL) hasPoster {
  return result.hasPoster;
}
- (MinimumUserProtoWithLevel*) poster {
  return result.poster;
}
- (PrivateChatPostProto_Builder*) setPoster:(MinimumUserProtoWithLevel*) value {
  result.hasPoster = YES;
  result.poster = value;
  return self;
}
- (PrivateChatPostProto_Builder*) setPosterBuilder:(MinimumUserProtoWithLevel_Builder*) builderForValue {
  return [self setPoster:[builderForValue build]];
}
- (PrivateChatPostProto_Builder*) mergePoster:(MinimumUserProtoWithLevel*) value {
  if (result.hasPoster &&
      result.poster != [MinimumUserProtoWithLevel defaultInstance]) {
    result.poster =
      [[[MinimumUserProtoWithLevel builderWithPrototype:result.poster] mergeFrom:value] buildPartial];
  } else {
    result.poster = value;
  }
  result.hasPoster = YES;
  return self;
}
- (PrivateChatPostProto_Builder*) clearPoster {
  result.hasPoster = NO;
  result.poster = [MinimumUserProtoWithLevel defaultInstance];
  return self;
}
- (BOOL) hasRecipient {
  return result.hasRecipient;
}
- (MinimumUserProtoWithLevel*) recipient {
  return result.recipient;
}
- (PrivateChatPostProto_Builder*) setRecipient:(MinimumUserProtoWithLevel*) value {
  result.hasRecipient = YES;
  result.recipient = value;
  return self;
}
- (PrivateChatPostProto_Builder*) setRecipientBuilder:(MinimumUserProtoWithLevel_Builder*) builderForValue {
  return [self setRecipient:[builderForValue build]];
}
- (PrivateChatPostProto_Builder*) mergeRecipient:(MinimumUserProtoWithLevel*) value {
  if (result.hasRecipient &&
      result.recipient != [MinimumUserProtoWithLevel defaultInstance]) {
    result.recipient =
      [[[MinimumUserProtoWithLevel builderWithPrototype:result.recipient] mergeFrom:value] buildPartial];
  } else {
    result.recipient = value;
  }
  result.hasRecipient = YES;
  return self;
}
- (PrivateChatPostProto_Builder*) clearRecipient {
  result.hasRecipient = NO;
  result.recipient = [MinimumUserProtoWithLevel defaultInstance];
  return self;
}
- (BOOL) hasTimeOfPost {
  return result.hasTimeOfPost;
}
- (int64_t) timeOfPost {
  return result.timeOfPost;
}
- (PrivateChatPostProto_Builder*) setTimeOfPost:(int64_t) value {
  result.hasTimeOfPost = YES;
  result.timeOfPost = value;
  return self;
}
- (PrivateChatPostProto_Builder*) clearTimeOfPost {
  result.hasTimeOfPost = NO;
  result.timeOfPost = 0L;
  return self;
}
- (BOOL) hasContent {
  return result.hasContent;
}
- (NSString*) content {
  return result.content;
}
- (PrivateChatPostProto_Builder*) setContent:(NSString*) value {
  result.hasContent = YES;
  result.content = value;
  return self;
}
- (PrivateChatPostProto_Builder*) clearContent {
  result.hasContent = NO;
  result.content = @"";
  return self;
}
@end

@interface ColorProto ()
@property int32_t red;
@property int32_t green;
@property int32_t blue;
@end

@implementation ColorProto

- (BOOL) hasRed {
  return !!hasRed_;
}
- (void) setHasRed:(BOOL) value {
  hasRed_ = !!value;
}
@synthesize red;
- (BOOL) hasGreen {
  return !!hasGreen_;
}
- (void) setHasGreen:(BOOL) value {
  hasGreen_ = !!value;
}
@synthesize green;
- (BOOL) hasBlue {
  return !!hasBlue_;
}
- (void) setHasBlue:(BOOL) value {
  hasBlue_ = !!value;
}
@synthesize blue;
- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.red = 0;
    self.green = 0;
    self.blue = 0;
  }
  return self;
}
static ColorProto* defaultColorProtoInstance = nil;
+ (void) initialize {
  if (self == [ColorProto class]) {
    defaultColorProtoInstance = [[ColorProto alloc] init];
  }
}
+ (ColorProto*) defaultInstance {
  return defaultColorProtoInstance;
}
- (ColorProto*) defaultInstance {
  return defaultColorProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasRed) {
    [output writeInt32:1 value:self.red];
  }
  if (self.hasGreen) {
    [output writeInt32:2 value:self.green];
  }
  if (self.hasBlue) {
    [output writeInt32:3 value:self.blue];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasRed) {
    size += computeInt32Size(1, self.red);
  }
  if (self.hasGreen) {
    size += computeInt32Size(2, self.green);
  }
  if (self.hasBlue) {
    size += computeInt32Size(3, self.blue);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (ColorProto*) parseFromData:(NSData*) data {
  return (ColorProto*)[[[ColorProto builder] mergeFromData:data] build];
}
+ (ColorProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ColorProto*)[[[ColorProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (ColorProto*) parseFromInputStream:(NSInputStream*) input {
  return (ColorProto*)[[[ColorProto builder] mergeFromInputStream:input] build];
}
+ (ColorProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ColorProto*)[[[ColorProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ColorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (ColorProto*)[[[ColorProto builder] mergeFromCodedInputStream:input] build];
}
+ (ColorProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ColorProto*)[[[ColorProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ColorProto_Builder*) builder {
  return [[[ColorProto_Builder alloc] init] autorelease];
}
+ (ColorProto_Builder*) builderWithPrototype:(ColorProto*) prototype {
  return [[ColorProto builder] mergeFrom:prototype];
}
- (ColorProto_Builder*) builder {
  return [ColorProto builder];
}
@end

@interface ColorProto_Builder()
@property (retain) ColorProto* result;
@end

@implementation ColorProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[ColorProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (ColorProto_Builder*) clear {
  self.result = [[[ColorProto alloc] init] autorelease];
  return self;
}
- (ColorProto_Builder*) clone {
  return [ColorProto builderWithPrototype:result];
}
- (ColorProto*) defaultInstance {
  return [ColorProto defaultInstance];
}
- (ColorProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (ColorProto*) buildPartial {
  ColorProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (ColorProto_Builder*) mergeFrom:(ColorProto*) other {
  if (other == [ColorProto defaultInstance]) {
    return self;
  }
  if (other.hasRed) {
    [self setRed:other.red];
  }
  if (other.hasGreen) {
    [self setGreen:other.green];
  }
  if (other.hasBlue) {
    [self setBlue:other.blue];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (ColorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (ColorProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 8: {
        [self setRed:[input readInt32]];
        break;
      }
      case 16: {
        [self setGreen:[input readInt32]];
        break;
      }
      case 24: {
        [self setBlue:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasRed {
  return result.hasRed;
}
- (int32_t) red {
  return result.red;
}
- (ColorProto_Builder*) setRed:(int32_t) value {
  result.hasRed = YES;
  result.red = value;
  return self;
}
- (ColorProto_Builder*) clearRed {
  result.hasRed = NO;
  result.red = 0;
  return self;
}
- (BOOL) hasGreen {
  return result.hasGreen;
}
- (int32_t) green {
  return result.green;
}
- (ColorProto_Builder*) setGreen:(int32_t) value {
  result.hasGreen = YES;
  result.green = value;
  return self;
}
- (ColorProto_Builder*) clearGreen {
  result.hasGreen = NO;
  result.green = 0;
  return self;
}
- (BOOL) hasBlue {
  return result.hasBlue;
}
- (int32_t) blue {
  return result.blue;
}
- (ColorProto_Builder*) setBlue:(int32_t) value {
  result.hasBlue = YES;
  result.blue = value;
  return self;
}
- (ColorProto_Builder*) clearBlue {
  result.hasBlue = NO;
  result.blue = 0;
  return self;
}
@end

@interface GroupChatMessageProto ()
@property (retain) MinimumUserProtoWithLevel* sender;
@property int64_t timeOfChat;
@property (retain) NSString* content;
@property BOOL isAdmin;
@property int32_t chatId;
@end

@implementation GroupChatMessageProto

- (BOOL) hasSender {
  return !!hasSender_;
}
- (void) setHasSender:(BOOL) value {
  hasSender_ = !!value;
}
@synthesize sender;
- (BOOL) hasTimeOfChat {
  return !!hasTimeOfChat_;
}
- (void) setHasTimeOfChat:(BOOL) value {
  hasTimeOfChat_ = !!value;
}
@synthesize timeOfChat;
- (BOOL) hasContent {
  return !!hasContent_;
}
- (void) setHasContent:(BOOL) value {
  hasContent_ = !!value;
}
@synthesize content;
- (BOOL) hasIsAdmin {
  return !!hasIsAdmin_;
}
- (void) setHasIsAdmin:(BOOL) value {
  hasIsAdmin_ = !!value;
}
- (BOOL) isAdmin {
  return !!isAdmin_;
}
- (void) setIsAdmin:(BOOL) value {
  isAdmin_ = !!value;
}
- (BOOL) hasChatId {
  return !!hasChatId_;
}
- (void) setHasChatId:(BOOL) value {
  hasChatId_ = !!value;
}
@synthesize chatId;
- (void) dealloc {
  self.sender = nil;
  self.content = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.sender = [MinimumUserProtoWithLevel defaultInstance];
    self.timeOfChat = 0L;
    self.content = @"";
    self.isAdmin = NO;
    self.chatId = 0;
  }
  return self;
}
static GroupChatMessageProto* defaultGroupChatMessageProtoInstance = nil;
+ (void) initialize {
  if (self == [GroupChatMessageProto class]) {
    defaultGroupChatMessageProtoInstance = [[GroupChatMessageProto alloc] init];
  }
}
+ (GroupChatMessageProto*) defaultInstance {
  return defaultGroupChatMessageProtoInstance;
}
- (GroupChatMessageProto*) defaultInstance {
  return defaultGroupChatMessageProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasSender) {
    [output writeMessage:1 value:self.sender];
  }
  if (self.hasTimeOfChat) {
    [output writeInt64:2 value:self.timeOfChat];
  }
  if (self.hasContent) {
    [output writeString:3 value:self.content];
  }
  if (self.hasIsAdmin) {
    [output writeBool:4 value:self.isAdmin];
  }
  if (self.hasChatId) {
    [output writeInt32:5 value:self.chatId];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasSender) {
    size += computeMessageSize(1, self.sender);
  }
  if (self.hasTimeOfChat) {
    size += computeInt64Size(2, self.timeOfChat);
  }
  if (self.hasContent) {
    size += computeStringSize(3, self.content);
  }
  if (self.hasIsAdmin) {
    size += computeBoolSize(4, self.isAdmin);
  }
  if (self.hasChatId) {
    size += computeInt32Size(5, self.chatId);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (GroupChatMessageProto*) parseFromData:(NSData*) data {
  return (GroupChatMessageProto*)[[[GroupChatMessageProto builder] mergeFromData:data] build];
}
+ (GroupChatMessageProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (GroupChatMessageProto*)[[[GroupChatMessageProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (GroupChatMessageProto*) parseFromInputStream:(NSInputStream*) input {
  return (GroupChatMessageProto*)[[[GroupChatMessageProto builder] mergeFromInputStream:input] build];
}
+ (GroupChatMessageProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (GroupChatMessageProto*)[[[GroupChatMessageProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (GroupChatMessageProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (GroupChatMessageProto*)[[[GroupChatMessageProto builder] mergeFromCodedInputStream:input] build];
}
+ (GroupChatMessageProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (GroupChatMessageProto*)[[[GroupChatMessageProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (GroupChatMessageProto_Builder*) builder {
  return [[[GroupChatMessageProto_Builder alloc] init] autorelease];
}
+ (GroupChatMessageProto_Builder*) builderWithPrototype:(GroupChatMessageProto*) prototype {
  return [[GroupChatMessageProto builder] mergeFrom:prototype];
}
- (GroupChatMessageProto_Builder*) builder {
  return [GroupChatMessageProto builder];
}
@end

@interface GroupChatMessageProto_Builder()
@property (retain) GroupChatMessageProto* result;
@end

@implementation GroupChatMessageProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[GroupChatMessageProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (GroupChatMessageProto_Builder*) clear {
  self.result = [[[GroupChatMessageProto alloc] init] autorelease];
  return self;
}
- (GroupChatMessageProto_Builder*) clone {
  return [GroupChatMessageProto builderWithPrototype:result];
}
- (GroupChatMessageProto*) defaultInstance {
  return [GroupChatMessageProto defaultInstance];
}
- (GroupChatMessageProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (GroupChatMessageProto*) buildPartial {
  GroupChatMessageProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (GroupChatMessageProto_Builder*) mergeFrom:(GroupChatMessageProto*) other {
  if (other == [GroupChatMessageProto defaultInstance]) {
    return self;
  }
  if (other.hasSender) {
    [self mergeSender:other.sender];
  }
  if (other.hasTimeOfChat) {
    [self setTimeOfChat:other.timeOfChat];
  }
  if (other.hasContent) {
    [self setContent:other.content];
  }
  if (other.hasIsAdmin) {
    [self setIsAdmin:other.isAdmin];
  }
  if (other.hasChatId) {
    [self setChatId:other.chatId];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (GroupChatMessageProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (GroupChatMessageProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        MinimumUserProtoWithLevel_Builder* subBuilder = [MinimumUserProtoWithLevel builder];
        if (self.hasSender) {
          [subBuilder mergeFrom:self.sender];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setSender:[subBuilder buildPartial]];
        break;
      }
      case 16: {
        [self setTimeOfChat:[input readInt64]];
        break;
      }
      case 26: {
        [self setContent:[input readString]];
        break;
      }
      case 32: {
        [self setIsAdmin:[input readBool]];
        break;
      }
      case 40: {
        [self setChatId:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasSender {
  return result.hasSender;
}
- (MinimumUserProtoWithLevel*) sender {
  return result.sender;
}
- (GroupChatMessageProto_Builder*) setSender:(MinimumUserProtoWithLevel*) value {
  result.hasSender = YES;
  result.sender = value;
  return self;
}
- (GroupChatMessageProto_Builder*) setSenderBuilder:(MinimumUserProtoWithLevel_Builder*) builderForValue {
  return [self setSender:[builderForValue build]];
}
- (GroupChatMessageProto_Builder*) mergeSender:(MinimumUserProtoWithLevel*) value {
  if (result.hasSender &&
      result.sender != [MinimumUserProtoWithLevel defaultInstance]) {
    result.sender =
      [[[MinimumUserProtoWithLevel builderWithPrototype:result.sender] mergeFrom:value] buildPartial];
  } else {
    result.sender = value;
  }
  result.hasSender = YES;
  return self;
}
- (GroupChatMessageProto_Builder*) clearSender {
  result.hasSender = NO;
  result.sender = [MinimumUserProtoWithLevel defaultInstance];
  return self;
}
- (BOOL) hasTimeOfChat {
  return result.hasTimeOfChat;
}
- (int64_t) timeOfChat {
  return result.timeOfChat;
}
- (GroupChatMessageProto_Builder*) setTimeOfChat:(int64_t) value {
  result.hasTimeOfChat = YES;
  result.timeOfChat = value;
  return self;
}
- (GroupChatMessageProto_Builder*) clearTimeOfChat {
  result.hasTimeOfChat = NO;
  result.timeOfChat = 0L;
  return self;
}
- (BOOL) hasContent {
  return result.hasContent;
}
- (NSString*) content {
  return result.content;
}
- (GroupChatMessageProto_Builder*) setContent:(NSString*) value {
  result.hasContent = YES;
  result.content = value;
  return self;
}
- (GroupChatMessageProto_Builder*) clearContent {
  result.hasContent = NO;
  result.content = @"";
  return self;
}
- (BOOL) hasIsAdmin {
  return result.hasIsAdmin;
}
- (BOOL) isAdmin {
  return result.isAdmin;
}
- (GroupChatMessageProto_Builder*) setIsAdmin:(BOOL) value {
  result.hasIsAdmin = YES;
  result.isAdmin = value;
  return self;
}
- (GroupChatMessageProto_Builder*) clearIsAdmin {
  result.hasIsAdmin = NO;
  result.isAdmin = NO;
  return self;
}
- (BOOL) hasChatId {
  return result.hasChatId;
}
- (int32_t) chatId {
  return result.chatId;
}
- (GroupChatMessageProto_Builder*) setChatId:(int32_t) value {
  result.hasChatId = YES;
  result.chatId = value;
  return self;
}
- (GroupChatMessageProto_Builder*) clearChatId {
  result.hasChatId = NO;
  result.chatId = 0;
  return self;
}
@end
