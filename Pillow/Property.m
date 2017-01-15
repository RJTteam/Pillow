//
//  Property.m
//  Pillow
//
//  Created by Lucas Luo on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "Property.h"
#import "Contants.h"

@implementation Property

- (instancetype)initWithDictionary: (NSDictionary *)dic{
    if(self = [super init]){
        _propertyID = dic[propIDKey];
        _propertyName = dic[propNameKey];
        _propertyType = dic[propTypeKey];
        _propertyCategory = dic[propCataKey];
        _propertyAdd1 = dic[propAddr1Key];
        _propertyadd2 = dic[propAddr2Key];
        _propertyZip = dic[propZipKey];
        _propertyImage1 = dic[propImg1Key];
        _propertyImage2 = dic[propImg2Key];
        _propertyImage3 = dic[propImg3Key];
        _propertyLatitute = dic[propLatKey];
        _propertyLongitute = dic[propLongKey];
        _propertyCost = dic[propCostKey];
        _propertySize = dic[propSizeKey];
        _propertyDesc = dic[propDescKey];
        _propertyPubDate = dic[propPubDateKey];
        _propertyModDate = dic[propModDateKey];
        _propertyStatus = dic[propStatusKey];
        _userID = dic[loginRespondIdKey];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.propertyID forKey:propIDKey];
    [aCoder encodeObject:self.propertyName forKey:propNameKey];
    [aCoder encodeObject:self.propertyType forKey:propTypeKey];
    [aCoder encodeObject:self.propertyCategory forKey:propCataKey];
    [aCoder encodeObject:self.propertyAdd1 forKey:propAddr1Key];
    [aCoder encodeObject:self.propertyadd2 forKey:propAddr2Key];
    [aCoder encodeObject:self.propertyZip  forKey:propZipKey];
    [aCoder encodeObject:self.propertyImage1 forKey:propImg1Key];
    [aCoder encodeObject:self.propertyImage2 forKey:propImg2Key];
    [aCoder encodeObject:self.propertyImage3 forKey:propImg3Key];
    [aCoder encodeObject:self.propertyLatitute forKey:propLatKey];
    [aCoder encodeObject:self.propertyLongitute forKey:propLongKey];
    [aCoder encodeObject:self.propertyCost forKey:propCostKey];
    [aCoder encodeObject:self.propertySize forKey:propSizeKey];
    [aCoder encodeObject:self.propertyDesc forKey:propDescKey];
    [aCoder encodeObject:self.propertyPubDate forKey:propPubDateKey];
    [aCoder encodeObject:self.propertyModDate forKey:propModDateKey];
    [aCoder encodeObject:self.propertyStatus forKey:propStatusKey];
    [aCoder encodeObject:self.userID forKey:loginRespondIdKey];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    NSArray *keys = @[propIDKey, propNameKey, propTypeKey, propCataKey, propAddr1Key, propAddr2Key, propZipKey, propImg1Key, propImg2Key, propImg3Key, propLatKey, propLongKey, propCostKey, propSizeKey, propDescKey, propPubDateKey, propModDateKey, propStatusKey, loginRespondIdKey];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for(NSString *key in keys){
        NSString *value = [aDecoder decodeObjectForKey:key];
        [dict setObject:value forKey:key];
    }
    return [[Property alloc] initWithDictionary:dict];
}
@end
