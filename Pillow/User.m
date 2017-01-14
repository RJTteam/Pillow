//
//  User.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/13/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "User.h"
#import "Contants.h"
#import "PLNetworking.h"

static NSString *const baseUrl = @"http://rjtmobile.com/realestate/register.php?";
@implementation User

@synthesize dictPresentation;

-(NSDictionary *)dictPresentation{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(self.userid){
        dict[useridKey] = [NSNumber numberWithInteger:self.userid];
    }
    if(self.username){
        dict[usernameKey] = self.username;
    }
    if(self.email){
        dict[emailKey] = self.email;
    }
    if(self.password){
        dict[passwordKey] = self.password;
    }
    if(self.mobile){
        dict[mobileKey] = self.mobile;
    }
    if(self.usertype){
        dict[usertypeKey] = self.usertype;
    }
    if(self.address1){
        dict[address1Key] = self.address1;
    }
    if(self.address2){
        dict[address2Key] = self.address2;
    }
    if(self.birthday){
        dict[dobKey] = self.birthday;
    }
    if(self.usertstatus){
        dict[userstatusKey] = self.usertstatus;
    }
    return dict;
}

+ (void)userLoginWithParameters:(NSDictionary *)dict success:(void(^)(User *user))success faliure:(void(^)(NSString *errorMessage))failure{
    NSString *final = [baseUrl stringByAppendingString:@"login"];
    PLNetworking *man = [PLNetworking manager];
    [man sendPOSTRequestToURL:final parameters:dict success:^(NSData *data, NSInteger status) {
        NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if(status != 200){
            failure(@"Internet Failure!");
            return;
        }
        if(jsonObj.count != 0){
            User *applyedUser = [[User alloc] initWithDictionary:dict];
            applyedUser.userid = [[[jsonObj firstObject] objectForKey:loginRespondIdKey] integerValue];
            applyedUser.usertype = [[jsonObj firstObject] objectForKey:loginRespondTypeKey];
            success(applyedUser);
        }else {
            failure(@"User Login Failed!");
        }
    } failed:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)userSignupWithParameters:(NSDictionary *)dict success:(void(^)(User *user, NSInteger status))success faliure:(void(^)(NSString *errorMessage))failure{
    NSString *final = [baseUrl stringByAppendingString:@"signup"];
    PLNetworking *man = [PLNetworking manager];
    [man sendPOSTRequestToURL:final parameters:dict success:^(NSData *data, NSInteger status) {
        if(status != 200){
            failure(@"Internet Failure!");
            return;
        }
        NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([message containsString:@"true"]){
            User *applyedUser = [[User alloc] initWithDictionary:dict];
            success(applyedUser, status);
        }else{
            failure(@"User Register Failure");
        }
    } failed:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

+ (void)userGetUserInfoWithUserId:(NSInteger)userid success:(void(^)(User *user))success failure:(void(^)(NSString *errorMessage))failure{
    PLNetworking *man = [PLNetworking manager];
    [man sendGETRequestToURL:baseUrl parameters:@{useridKey:[[NSNumber alloc] initWithInteger:userid]} success:^(NSData *data, NSInteger status) {
        if(status == 200){
            NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if(jsonData.count != 0){
                User *user = [[User alloc] initWithDictionary:[jsonData firstObject]];
                success(user);
            }else{
                failure(@"User Not Found");
            }
        }
    } failed:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if(self = [super init]){
        if(dict[loginRespondIdKey]){
            _userid = [dict[loginRespondIdKey] integerValue];
        }
        if(dict[usertypeKey]){
            _usertype = dict[usertypeKey];
        }else{
            _usertype = dict[loginRespondTypeKey];
        }
        _username = dict[usernameKey];
        _password = dict[passwordKey];
        _email = dict[emailKey];
        _mobile = dict[mobileKey];
        _birthday = [self stringToDate:dict[dobKey]];
        _address1 = dict[address1Key];
        _address2 = dict[address2Key];
        _usertstatus = dict[userstatusKey];
    }
    return self;
}

-(NSDate *)stringToDate:(NSString *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = dateFormat;
    NSDate *returnDate = [formatter dateFromString:date];
    return returnDate;
}

@end
