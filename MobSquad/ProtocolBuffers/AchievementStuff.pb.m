// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import "AchievementStuff.pb.h"

@implementation AchievementStuffRoot
static PBExtensionRegistry* extensionRegistry = nil;
+ (PBExtensionRegistry*) extensionRegistry {
  return extensionRegistry;
}

+ (void) initialize {
  if (self == [AchievementStuffRoot class]) {
    PBMutableExtensionRegistry* registry = [PBMutableExtensionRegistry registry];
    [self registerAllExtensions:registry];
    [MonsterStuffRoot registerAllExtensions:registry];
    [SharedEnumConfigRoot registerAllExtensions:registry];
    [StructureRoot registerAllExtensions:registry];
    extensionRegistry = [registry retain];
  }
}
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry {
}
@end

@interface AchievementProto ()
@property int32_t achievementId;
@property (retain) NSString* name;
@property (retain) NSString* description;
@property int32_t gemReward;
@property int32_t lvl;
@property AchievementProto_AchievementType achievementType;
@property ResourceType resourceType;
@property Element element;
@property Quality quality;
@property int32_t staticDataId;
@property int32_t quantity;
@property int32_t priority;
@property int32_t prerequisiteId;
@property int32_t successorId;
@end

@implementation AchievementProto

- (BOOL) hasAchievementId {
  return !!hasAchievementId_;
}
- (void) setHasAchievementId:(BOOL) value {
  hasAchievementId_ = !!value;
}
@synthesize achievementId;
- (BOOL) hasName {
  return !!hasName_;
}
- (void) setHasName:(BOOL) value {
  hasName_ = !!value;
}
@synthesize name;
- (BOOL) hasDescription {
  return !!hasDescription_;
}
- (void) setHasDescription:(BOOL) value {
  hasDescription_ = !!value;
}
@synthesize description;
- (BOOL) hasGemReward {
  return !!hasGemReward_;
}
- (void) setHasGemReward:(BOOL) value {
  hasGemReward_ = !!value;
}
@synthesize gemReward;
- (BOOL) hasLvl {
  return !!hasLvl_;
}
- (void) setHasLvl:(BOOL) value {
  hasLvl_ = !!value;
}
@synthesize lvl;
- (BOOL) hasAchievementType {
  return !!hasAchievementType_;
}
- (void) setHasAchievementType:(BOOL) value {
  hasAchievementType_ = !!value;
}
@synthesize achievementType;
- (BOOL) hasResourceType {
  return !!hasResourceType_;
}
- (void) setHasResourceType:(BOOL) value {
  hasResourceType_ = !!value;
}
@synthesize resourceType;
- (BOOL) hasElement {
  return !!hasElement_;
}
- (void) setHasElement:(BOOL) value {
  hasElement_ = !!value;
}
@synthesize element;
- (BOOL) hasQuality {
  return !!hasQuality_;
}
- (void) setHasQuality:(BOOL) value {
  hasQuality_ = !!value;
}
@synthesize quality;
- (BOOL) hasStaticDataId {
  return !!hasStaticDataId_;
}
- (void) setHasStaticDataId:(BOOL) value {
  hasStaticDataId_ = !!value;
}
@synthesize staticDataId;
- (BOOL) hasQuantity {
  return !!hasQuantity_;
}
- (void) setHasQuantity:(BOOL) value {
  hasQuantity_ = !!value;
}
@synthesize quantity;
- (BOOL) hasPriority {
  return !!hasPriority_;
}
- (void) setHasPriority:(BOOL) value {
  hasPriority_ = !!value;
}
@synthesize priority;
- (BOOL) hasPrerequisiteId {
  return !!hasPrerequisiteId_;
}
- (void) setHasPrerequisiteId:(BOOL) value {
  hasPrerequisiteId_ = !!value;
}
@synthesize prerequisiteId;
- (BOOL) hasSuccessorId {
  return !!hasSuccessorId_;
}
- (void) setHasSuccessorId:(BOOL) value {
  hasSuccessorId_ = !!value;
}
@synthesize successorId;
- (void) dealloc {
  self.name = nil;
  self.description = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.achievementId = 0;
    self.name = @"";
    self.description = @"";
    self.gemReward = 0;
    self.lvl = 0;
    self.achievementType = AchievementProto_AchievementTypeNoAchievement;
    self.resourceType = ResourceTypeNoResource;
    self.element = ElementNoElement;
    self.quality = QualityNoQuality;
    self.staticDataId = 0;
    self.quantity = 0;
    self.priority = 0;
    self.prerequisiteId = 0;
    self.successorId = 0;
  }
  return self;
}
static AchievementProto* defaultAchievementProtoInstance = nil;
+ (void) initialize {
  if (self == [AchievementProto class]) {
    defaultAchievementProtoInstance = [[AchievementProto alloc] init];
  }
}
+ (AchievementProto*) defaultInstance {
  return defaultAchievementProtoInstance;
}
- (AchievementProto*) defaultInstance {
  return defaultAchievementProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasAchievementId) {
    [output writeInt32:1 value:self.achievementId];
  }
  if (self.hasName) {
    [output writeString:2 value:self.name];
  }
  if (self.hasDescription) {
    [output writeString:3 value:self.description];
  }
  if (self.hasGemReward) {
    [output writeInt32:4 value:self.gemReward];
  }
  if (self.hasLvl) {
    [output writeInt32:5 value:self.lvl];
  }
  if (self.hasAchievementType) {
    [output writeEnum:6 value:self.achievementType];
  }
  if (self.hasResourceType) {
    [output writeEnum:7 value:self.resourceType];
  }
  if (self.hasElement) {
    [output writeEnum:8 value:self.element];
  }
  if (self.hasQuality) {
    [output writeEnum:9 value:self.quality];
  }
  if (self.hasStaticDataId) {
    [output writeInt32:10 value:self.staticDataId];
  }
  if (self.hasQuantity) {
    [output writeInt32:11 value:self.quantity];
  }
  if (self.hasPriority) {
    [output writeInt32:12 value:self.priority];
  }
  if (self.hasPrerequisiteId) {
    [output writeInt32:13 value:self.prerequisiteId];
  }
  if (self.hasSuccessorId) {
    [output writeInt32:14 value:self.successorId];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasAchievementId) {
    size += computeInt32Size(1, self.achievementId);
  }
  if (self.hasName) {
    size += computeStringSize(2, self.name);
  }
  if (self.hasDescription) {
    size += computeStringSize(3, self.description);
  }
  if (self.hasGemReward) {
    size += computeInt32Size(4, self.gemReward);
  }
  if (self.hasLvl) {
    size += computeInt32Size(5, self.lvl);
  }
  if (self.hasAchievementType) {
    size += computeEnumSize(6, self.achievementType);
  }
  if (self.hasResourceType) {
    size += computeEnumSize(7, self.resourceType);
  }
  if (self.hasElement) {
    size += computeEnumSize(8, self.element);
  }
  if (self.hasQuality) {
    size += computeEnumSize(9, self.quality);
  }
  if (self.hasStaticDataId) {
    size += computeInt32Size(10, self.staticDataId);
  }
  if (self.hasQuantity) {
    size += computeInt32Size(11, self.quantity);
  }
  if (self.hasPriority) {
    size += computeInt32Size(12, self.priority);
  }
  if (self.hasPrerequisiteId) {
    size += computeInt32Size(13, self.prerequisiteId);
  }
  if (self.hasSuccessorId) {
    size += computeInt32Size(14, self.successorId);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (AchievementProto*) parseFromData:(NSData*) data {
  return (AchievementProto*)[[[AchievementProto builder] mergeFromData:data] build];
}
+ (AchievementProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (AchievementProto*)[[[AchievementProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (AchievementProto*) parseFromInputStream:(NSInputStream*) input {
  return (AchievementProto*)[[[AchievementProto builder] mergeFromInputStream:input] build];
}
+ (AchievementProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (AchievementProto*)[[[AchievementProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (AchievementProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (AchievementProto*)[[[AchievementProto builder] mergeFromCodedInputStream:input] build];
}
+ (AchievementProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (AchievementProto*)[[[AchievementProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (AchievementProto_Builder*) builder {
  return [[[AchievementProto_Builder alloc] init] autorelease];
}
+ (AchievementProto_Builder*) builderWithPrototype:(AchievementProto*) prototype {
  return [[AchievementProto builder] mergeFrom:prototype];
}
- (AchievementProto_Builder*) builder {
  return [AchievementProto builder];
}
@end

BOOL AchievementProto_AchievementTypeIsValidValue(AchievementProto_AchievementType value) {
  switch (value) {
    case AchievementProto_AchievementTypeNoAchievement:
    case AchievementProto_AchievementTypeCollectResource:
    case AchievementProto_AchievementTypeCreateGrenade:
    case AchievementProto_AchievementTypeCreateRainbow:
    case AchievementProto_AchievementTypeCreateRocket:
    case AchievementProto_AchievementTypeDefeatMonsters:
    case AchievementProto_AchievementTypeDestroyOrbs:
    case AchievementProto_AchievementTypeEnhancePoints:
    case AchievementProto_AchievementTypeHealMonsters:
    case AchievementProto_AchievementTypeJoinLeague:
    case AchievementProto_AchievementTypeMakeCombo:
    case AchievementProto_AchievementTypeRemoveObstacle:
    case AchievementProto_AchievementTypeSellMonster:
    case AchievementProto_AchievementTypeStealResource:
    case AchievementProto_AchievementTypeTakeDamage:
    case AchievementProto_AchievementTypeUpgradeBuilding:
    case AchievementProto_AchievementTypeWinPvpBattle:
      return YES;
    default:
      return NO;
  }
}
@interface AchievementProto_Builder()
@property (retain) AchievementProto* result;
@end

@implementation AchievementProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[AchievementProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (AchievementProto_Builder*) clear {
  self.result = [[[AchievementProto alloc] init] autorelease];
  return self;
}
- (AchievementProto_Builder*) clone {
  return [AchievementProto builderWithPrototype:result];
}
- (AchievementProto*) defaultInstance {
  return [AchievementProto defaultInstance];
}
- (AchievementProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (AchievementProto*) buildPartial {
  AchievementProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (AchievementProto_Builder*) mergeFrom:(AchievementProto*) other {
  if (other == [AchievementProto defaultInstance]) {
    return self;
  }
  if (other.hasAchievementId) {
    [self setAchievementId:other.achievementId];
  }
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.hasDescription) {
    [self setDescription:other.description];
  }
  if (other.hasGemReward) {
    [self setGemReward:other.gemReward];
  }
  if (other.hasLvl) {
    [self setLvl:other.lvl];
  }
  if (other.hasAchievementType) {
    [self setAchievementType:other.achievementType];
  }
  if (other.hasResourceType) {
    [self setResourceType:other.resourceType];
  }
  if (other.hasElement) {
    [self setElement:other.element];
  }
  if (other.hasQuality) {
    [self setQuality:other.quality];
  }
  if (other.hasStaticDataId) {
    [self setStaticDataId:other.staticDataId];
  }
  if (other.hasQuantity) {
    [self setQuantity:other.quantity];
  }
  if (other.hasPriority) {
    [self setPriority:other.priority];
  }
  if (other.hasPrerequisiteId) {
    [self setPrerequisiteId:other.prerequisiteId];
  }
  if (other.hasSuccessorId) {
    [self setSuccessorId:other.successorId];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (AchievementProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (AchievementProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
        [self setAchievementId:[input readInt32]];
        break;
      }
      case 18: {
        [self setName:[input readString]];
        break;
      }
      case 26: {
        [self setDescription:[input readString]];
        break;
      }
      case 32: {
        [self setGemReward:[input readInt32]];
        break;
      }
      case 40: {
        [self setLvl:[input readInt32]];
        break;
      }
      case 48: {
        int32_t value = [input readEnum];
        if (AchievementProto_AchievementTypeIsValidValue(value)) {
          [self setAchievementType:value];
        } else {
          [unknownFields mergeVarintField:6 value:value];
        }
        break;
      }
      case 56: {
        int32_t value = [input readEnum];
        if (ResourceTypeIsValidValue(value)) {
          [self setResourceType:value];
        } else {
          [unknownFields mergeVarintField:7 value:value];
        }
        break;
      }
      case 64: {
        int32_t value = [input readEnum];
        if (ElementIsValidValue(value)) {
          [self setElement:value];
        } else {
          [unknownFields mergeVarintField:8 value:value];
        }
        break;
      }
      case 72: {
        int32_t value = [input readEnum];
        if (QualityIsValidValue(value)) {
          [self setQuality:value];
        } else {
          [unknownFields mergeVarintField:9 value:value];
        }
        break;
      }
      case 80: {
        [self setStaticDataId:[input readInt32]];
        break;
      }
      case 88: {
        [self setQuantity:[input readInt32]];
        break;
      }
      case 96: {
        [self setPriority:[input readInt32]];
        break;
      }
      case 104: {
        [self setPrerequisiteId:[input readInt32]];
        break;
      }
      case 112: {
        [self setSuccessorId:[input readInt32]];
        break;
      }
    }
  }
}
- (BOOL) hasAchievementId {
  return result.hasAchievementId;
}
- (int32_t) achievementId {
  return result.achievementId;
}
- (AchievementProto_Builder*) setAchievementId:(int32_t) value {
  result.hasAchievementId = YES;
  result.achievementId = value;
  return self;
}
- (AchievementProto_Builder*) clearAchievementId {
  result.hasAchievementId = NO;
  result.achievementId = 0;
  return self;
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (AchievementProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (AchievementProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (BOOL) hasDescription {
  return result.hasDescription;
}
- (NSString*) description {
  return result.description;
}
- (AchievementProto_Builder*) setDescription:(NSString*) value {
  result.hasDescription = YES;
  result.description = value;
  return self;
}
- (AchievementProto_Builder*) clearDescription {
  result.hasDescription = NO;
  result.description = @"";
  return self;
}
- (BOOL) hasGemReward {
  return result.hasGemReward;
}
- (int32_t) gemReward {
  return result.gemReward;
}
- (AchievementProto_Builder*) setGemReward:(int32_t) value {
  result.hasGemReward = YES;
  result.gemReward = value;
  return self;
}
- (AchievementProto_Builder*) clearGemReward {
  result.hasGemReward = NO;
  result.gemReward = 0;
  return self;
}
- (BOOL) hasLvl {
  return result.hasLvl;
}
- (int32_t) lvl {
  return result.lvl;
}
- (AchievementProto_Builder*) setLvl:(int32_t) value {
  result.hasLvl = YES;
  result.lvl = value;
  return self;
}
- (AchievementProto_Builder*) clearLvl {
  result.hasLvl = NO;
  result.lvl = 0;
  return self;
}
- (BOOL) hasAchievementType {
  return result.hasAchievementType;
}
- (AchievementProto_AchievementType) achievementType {
  return result.achievementType;
}
- (AchievementProto_Builder*) setAchievementType:(AchievementProto_AchievementType) value {
  result.hasAchievementType = YES;
  result.achievementType = value;
  return self;
}
- (AchievementProto_Builder*) clearAchievementType {
  result.hasAchievementType = NO;
  result.achievementType = AchievementProto_AchievementTypeNoAchievement;
  return self;
}
- (BOOL) hasResourceType {
  return result.hasResourceType;
}
- (ResourceType) resourceType {
  return result.resourceType;
}
- (AchievementProto_Builder*) setResourceType:(ResourceType) value {
  result.hasResourceType = YES;
  result.resourceType = value;
  return self;
}
- (AchievementProto_Builder*) clearResourceType {
  result.hasResourceType = NO;
  result.resourceType = ResourceTypeNoResource;
  return self;
}
- (BOOL) hasElement {
  return result.hasElement;
}
- (Element) element {
  return result.element;
}
- (AchievementProto_Builder*) setElement:(Element) value {
  result.hasElement = YES;
  result.element = value;
  return self;
}
- (AchievementProto_Builder*) clearElement {
  result.hasElement = NO;
  result.element = ElementNoElement;
  return self;
}
- (BOOL) hasQuality {
  return result.hasQuality;
}
- (Quality) quality {
  return result.quality;
}
- (AchievementProto_Builder*) setQuality:(Quality) value {
  result.hasQuality = YES;
  result.quality = value;
  return self;
}
- (AchievementProto_Builder*) clearQuality {
  result.hasQuality = NO;
  result.quality = QualityNoQuality;
  return self;
}
- (BOOL) hasStaticDataId {
  return result.hasStaticDataId;
}
- (int32_t) staticDataId {
  return result.staticDataId;
}
- (AchievementProto_Builder*) setStaticDataId:(int32_t) value {
  result.hasStaticDataId = YES;
  result.staticDataId = value;
  return self;
}
- (AchievementProto_Builder*) clearStaticDataId {
  result.hasStaticDataId = NO;
  result.staticDataId = 0;
  return self;
}
- (BOOL) hasQuantity {
  return result.hasQuantity;
}
- (int32_t) quantity {
  return result.quantity;
}
- (AchievementProto_Builder*) setQuantity:(int32_t) value {
  result.hasQuantity = YES;
  result.quantity = value;
  return self;
}
- (AchievementProto_Builder*) clearQuantity {
  result.hasQuantity = NO;
  result.quantity = 0;
  return self;
}
- (BOOL) hasPriority {
  return result.hasPriority;
}
- (int32_t) priority {
  return result.priority;
}
- (AchievementProto_Builder*) setPriority:(int32_t) value {
  result.hasPriority = YES;
  result.priority = value;
  return self;
}
- (AchievementProto_Builder*) clearPriority {
  result.hasPriority = NO;
  result.priority = 0;
  return self;
}
- (BOOL) hasPrerequisiteId {
  return result.hasPrerequisiteId;
}
- (int32_t) prerequisiteId {
  return result.prerequisiteId;
}
- (AchievementProto_Builder*) setPrerequisiteId:(int32_t) value {
  result.hasPrerequisiteId = YES;
  result.prerequisiteId = value;
  return self;
}
- (AchievementProto_Builder*) clearPrerequisiteId {
  result.hasPrerequisiteId = NO;
  result.prerequisiteId = 0;
  return self;
}
- (BOOL) hasSuccessorId {
  return result.hasSuccessorId;
}
- (int32_t) successorId {
  return result.successorId;
}
- (AchievementProto_Builder*) setSuccessorId:(int32_t) value {
  result.hasSuccessorId = YES;
  result.successorId = value;
  return self;
}
- (AchievementProto_Builder*) clearSuccessorId {
  result.hasSuccessorId = NO;
  result.successorId = 0;
  return self;
}
@end

@interface UserAchievementProto ()
@property int32_t achievementId;
@property int32_t progress;
@property BOOL isComplete;
@property BOOL isRedeemed;
@end

@implementation UserAchievementProto

- (BOOL) hasAchievementId {
  return !!hasAchievementId_;
}
- (void) setHasAchievementId:(BOOL) value {
  hasAchievementId_ = !!value;
}
@synthesize achievementId;
- (BOOL) hasProgress {
  return !!hasProgress_;
}
- (void) setHasProgress:(BOOL) value {
  hasProgress_ = !!value;
}
@synthesize progress;
- (BOOL) hasIsComplete {
  return !!hasIsComplete_;
}
- (void) setHasIsComplete:(BOOL) value {
  hasIsComplete_ = !!value;
}
- (BOOL) isComplete {
  return !!isComplete_;
}
- (void) setIsComplete:(BOOL) value {
  isComplete_ = !!value;
}
- (BOOL) hasIsRedeemed {
  return !!hasIsRedeemed_;
}
- (void) setHasIsRedeemed:(BOOL) value {
  hasIsRedeemed_ = !!value;
}
- (BOOL) isRedeemed {
  return !!isRedeemed_;
}
- (void) setIsRedeemed:(BOOL) value {
  isRedeemed_ = !!value;
}
- (void) dealloc {
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.achievementId = 0;
    self.progress = 0;
    self.isComplete = NO;
    self.isRedeemed = NO;
  }
  return self;
}
static UserAchievementProto* defaultUserAchievementProtoInstance = nil;
+ (void) initialize {
  if (self == [UserAchievementProto class]) {
    defaultUserAchievementProtoInstance = [[UserAchievementProto alloc] init];
  }
}
+ (UserAchievementProto*) defaultInstance {
  return defaultUserAchievementProtoInstance;
}
- (UserAchievementProto*) defaultInstance {
  return defaultUserAchievementProtoInstance;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (self.hasAchievementId) {
    [output writeInt32:1 value:self.achievementId];
  }
  if (self.hasProgress) {
    [output writeInt32:2 value:self.progress];
  }
  if (self.hasIsComplete) {
    [output writeBool:3 value:self.isComplete];
  }
  if (self.hasIsRedeemed) {
    [output writeBool:4 value:self.isRedeemed];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (self.hasAchievementId) {
    size += computeInt32Size(1, self.achievementId);
  }
  if (self.hasProgress) {
    size += computeInt32Size(2, self.progress);
  }
  if (self.hasIsComplete) {
    size += computeBoolSize(3, self.isComplete);
  }
  if (self.hasIsRedeemed) {
    size += computeBoolSize(4, self.isRedeemed);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (UserAchievementProto*) parseFromData:(NSData*) data {
  return (UserAchievementProto*)[[[UserAchievementProto builder] mergeFromData:data] build];
}
+ (UserAchievementProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UserAchievementProto*)[[[UserAchievementProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (UserAchievementProto*) parseFromInputStream:(NSInputStream*) input {
  return (UserAchievementProto*)[[[UserAchievementProto builder] mergeFromInputStream:input] build];
}
+ (UserAchievementProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UserAchievementProto*)[[[UserAchievementProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UserAchievementProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (UserAchievementProto*)[[[UserAchievementProto builder] mergeFromCodedInputStream:input] build];
}
+ (UserAchievementProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (UserAchievementProto*)[[[UserAchievementProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (UserAchievementProto_Builder*) builder {
  return [[[UserAchievementProto_Builder alloc] init] autorelease];
}
+ (UserAchievementProto_Builder*) builderWithPrototype:(UserAchievementProto*) prototype {
  return [[UserAchievementProto builder] mergeFrom:prototype];
}
- (UserAchievementProto_Builder*) builder {
  return [UserAchievementProto builder];
}
@end

@interface UserAchievementProto_Builder()
@property (retain) UserAchievementProto* result;
@end

@implementation UserAchievementProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if ((self = [super init])) {
    self.result = [[[UserAchievementProto alloc] init] autorelease];
  }
  return self;
}
- (PBGeneratedMessage*) internalGetResult {
  return result;
}
- (UserAchievementProto_Builder*) clear {
  self.result = [[[UserAchievementProto alloc] init] autorelease];
  return self;
}
- (UserAchievementProto_Builder*) clone {
  return [UserAchievementProto builderWithPrototype:result];
}
- (UserAchievementProto*) defaultInstance {
  return [UserAchievementProto defaultInstance];
}
- (UserAchievementProto*) build {
  [self checkInitialized];
  return [self buildPartial];
}
- (UserAchievementProto*) buildPartial {
  UserAchievementProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (UserAchievementProto_Builder*) mergeFrom:(UserAchievementProto*) other {
  if (other == [UserAchievementProto defaultInstance]) {
    return self;
  }
  if (other.hasAchievementId) {
    [self setAchievementId:other.achievementId];
  }
  if (other.hasProgress) {
    [self setProgress:other.progress];
  }
  if (other.hasIsComplete) {
    [self setIsComplete:other.isComplete];
  }
  if (other.hasIsRedeemed) {
    [self setIsRedeemed:other.isRedeemed];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (UserAchievementProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (UserAchievementProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
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
        [self setAchievementId:[input readInt32]];
        break;
      }
      case 16: {
        [self setProgress:[input readInt32]];
        break;
      }
      case 24: {
        [self setIsComplete:[input readBool]];
        break;
      }
      case 32: {
        [self setIsRedeemed:[input readBool]];
        break;
      }
    }
  }
}
- (BOOL) hasAchievementId {
  return result.hasAchievementId;
}
- (int32_t) achievementId {
  return result.achievementId;
}
- (UserAchievementProto_Builder*) setAchievementId:(int32_t) value {
  result.hasAchievementId = YES;
  result.achievementId = value;
  return self;
}
- (UserAchievementProto_Builder*) clearAchievementId {
  result.hasAchievementId = NO;
  result.achievementId = 0;
  return self;
}
- (BOOL) hasProgress {
  return result.hasProgress;
}
- (int32_t) progress {
  return result.progress;
}
- (UserAchievementProto_Builder*) setProgress:(int32_t) value {
  result.hasProgress = YES;
  result.progress = value;
  return self;
}
- (UserAchievementProto_Builder*) clearProgress {
  result.hasProgress = NO;
  result.progress = 0;
  return self;
}
- (BOOL) hasIsComplete {
  return result.hasIsComplete;
}
- (BOOL) isComplete {
  return result.isComplete;
}
- (UserAchievementProto_Builder*) setIsComplete:(BOOL) value {
  result.hasIsComplete = YES;
  result.isComplete = value;
  return self;
}
- (UserAchievementProto_Builder*) clearIsComplete {
  result.hasIsComplete = NO;
  result.isComplete = NO;
  return self;
}
- (BOOL) hasIsRedeemed {
  return result.hasIsRedeemed;
}
- (BOOL) isRedeemed {
  return result.isRedeemed;
}
- (UserAchievementProto_Builder*) setIsRedeemed:(BOOL) value {
  result.hasIsRedeemed = YES;
  result.isRedeemed = value;
  return self;
}
- (UserAchievementProto_Builder*) clearIsRedeemed {
  result.hasIsRedeemed = NO;
  result.isRedeemed = NO;
  return self;
}
@end
