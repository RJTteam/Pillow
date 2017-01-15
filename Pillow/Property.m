//
//  Property.m
//  Pillow
//
//  Created by Lucas Luo on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "Property.h"
#import "Contants.h"
#import "PLNetworking.h"

static NSString *const baseUrl = @"http://rjtmobile.com/realestate/register.php?";
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

-(NSString *)dateToString:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"dd-MM-yyyy";
    NSString *stringDate = [formatter stringFromDate:date];
    return stringDate;
}
    
+ (void)sellerGetPropertyWithUserId:(NSInteger)userid success:(void(^)(NSArray *propertyArray))success failure:(void(^)(NSString *errorMessage))failure{
    NSString *getPropertyURL = @"http://www.rjtmobile.com/realestate/getproperty.php?all&";
    PLNetworking *manager = [PLNetworking manager];
    [manager sendGETRequestToURL:getPropertyURL parameters:@{@"userid":[[NSNumber alloc]initWithInteger: userid ]} success:^(NSData *data, NSInteger status) {
        if(status == 200){
            NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if(jsonData.count != 0){
                NSArray *propertyArray = [[NSArray alloc]initWithArray:jsonData];
                success(propertyArray);
            }
        }
    } failed:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)sellerDeleteWithParameters:(NSInteger)propertyid faliure:(void(^)(NSString *errorMessage))failure{
    NSString *destination = [baseUrl stringByAppendingString:@"property&delete&"];
    PLNetworking *manager = [PLNetworking manager];
    [manager sendGETRequestToURL:destination parameters:@{@"pptyid":[[NSNumber alloc]initWithInteger: propertyid ]} success:^(NSData *data, NSInteger status) {
        if (status != 200) {
            failure(@"Internet not connected");
        }
        else{
            NSLog(@"successful delete Property");
        }
    } failed:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)sellerEditWithParameters:(NSDictionary *)dict faliure:(void(^)(NSString *errorMessage))failure{
    NSString *destination = [baseUrl stringByAppendingString:@"property&edit&"];
    PLNetworking *manager = [PLNetworking manager];
    [manager sendPOSTRequestToURL:destination parameters:dict success:^(NSData *data, NSInteger status) {
        if (status != 200) {
            failure(@"Internet not connecte");
        }
        else{
            NSLog(@"successful update Property");
        }
    } failed:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)sellerAddWithParameters:(NSDictionary *)dict faliure:(void(^)(NSString *errorMessage))failure{
    NSString *destination = [baseUrl stringByAppendingString:@"property&add&"];
    PLNetworking *manager = [PLNetworking manager];
    [manager sendPOSTRequestToURL:destination parameters:dict success:^(NSData *data, NSInteger status) {
        if (status != 200) {
            failure(@"Internet not connecte");
        }
        else{
            NSLog(@"successful add Property");
        }
    } failed:^(NSError *error) {
        failure(error.localizedDescription);
    }];
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
