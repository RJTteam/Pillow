//
//  User.h
//  Pillow
//
//  Created by Xinyuan Wang on 1/13/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong, nonatomic)NSString *username;
@property(strong, nonatomic)NSString *password;
@property(strong, nonatomic)NSString *email;
@property(strong, nonatomic)NSString *mobile;
@property(strong, nonatomic)NSDate *birthday;
@property(strong, nonatomic)NSString *address1;
@property(strong, nonatomic)NSString *address2;
@property(strong, nonatomic)NSString *usertype;
@property(strong, nonatomic)NSString *usertstatus;
@property(nonatomic)NSInteger userid;

@property(readonly)NSDictionary *dictPresentation;

- (instancetype)initWithDictionary:(NSDictionary *)dict;


/*Class method: Used for making user login web service call
 *@param dict: contains user email address and password information, format: @{emailKey:email, passwordKey:password}
 *@param success: block executed when login successed (user only contain userid, user type, email and password)
 *@param failure: block executed when login failed or having network connection error
*/
+ (void)userLoginWithParameters:(NSDictionary *)dict success:(void(^)(User *user))success faliure:(void(^)(NSString *errorMessage))failure;

/*Class method: Used for making user register web service call
 *@param dict: a NSDictionary contains all user information collected from sign up page
 *@param success: block executed when register successed (user doesn't contain userid);
 *@param failure: block executed when register failed or having network connection error
 */
+ (void)userSignupWithParameters:(NSDictionary *)dict success:(void(^)(User *user, NSInteger status))success faliure:(void(^)(NSString *errorMessage))failure;

/*Class method: used for making search by userid call
 *@param userid: id for user
 *@param success: block executed when find user(user contain user name, user mobile, user email)
 *@param failure: block executed when search failed or having network connection error
 */
+ (void)userGetUserInfoWithUserId:(NSInteger)userid success:(void(^)(User *user))success failure:(void(^)(NSString *errorMessage))failure;
@end
