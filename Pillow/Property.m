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

@end
