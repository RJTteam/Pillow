//
//  Property.m
//  Pillow
//
//  Created by Lucas Luo on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "Property.h"

@implementation Property

- (instancetype)initWithDictionary: (NSDictionary *)dic{
    if(self = [super init]){
        _propertyID = dic[@"Property Id"];
        _propertyName = dic[@"Property Name"];
        _propertyType = dic[@"Property Type"];
        _propertyCategory = dic[@"Property Category"];
        _propertyAdd1 = dic[@"Property Address1"];
        _propertyadd2 = dic[@"Property Address2"];
        _propertyZip = dic[@"Property Zip"];
        _propertyImage1 = dic[@"Property Image 1"];
        _propertyImage2 = dic[@"Property Image 2"];
        _propertyImage3 = dic[@"Property Image 3"];
        _propertyLatitute = dic[@"Property Latitude"];
        _propertyLongitute = dic[@"Property Longitude"];
        _propertyCost = dic[@"Property Cost"];
        _propertySize = dic[@"Property Size"];
        _propertyDesc = dic[@"Property Desc"];
        _propertyPubDate = dic[@"Property Published Date"];
        _propertyModDate = dic[@"Property Modify Date"];
        _propertyStatus = dic[@"Property Status"];
        _userID = dic[@"User Id"];
    }
    return self;
}

@end
