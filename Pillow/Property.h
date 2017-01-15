//
//  Property.h
//  Pillow
//
//  Created by Lucas Luo on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Property : NSObject<NSCoding>

@property(strong,nonatomic)NSString *propertyID;
@property(strong,nonatomic)NSString *propertyName;
@property(strong,nonatomic)NSString *propertyType;
@property(strong,nonatomic)NSString *propertyCategory;
@property(strong,nonatomic)NSString *propertyAdd1;
@property(strong,nonatomic)NSString *propertyadd2;
@property(strong,nonatomic)NSString *propertyZip;
@property(strong,nonatomic)NSString *propertyImage1;
@property(strong,nonatomic)NSString *propertyImage2;
@property(strong,nonatomic)NSString *propertyImage3;
@property(strong,nonatomic)NSString *propertyLatitute;
@property(strong,nonatomic)NSString *propertyLongitute;
@property(strong,nonatomic)NSString *propertyCost;
@property(strong,nonatomic)NSString *propertySize;
@property(strong,nonatomic)NSString *propertyDesc;
@property(strong,nonatomic)NSDate *propertyPubDate;
@property(strong,nonatomic)NSDate *propertyModDate;
@property(strong,nonatomic)NSString *propertyStatus;
@property(strong,nonatomic)NSString *userID;

- (instancetype)initWithDictionary: (NSDictionary *)dic;
-(NSString *)dateToString:(NSDate *)date;
//****************************GET****************************
/*Class method: Used for get All Properties with userID
 *@param dict format: @{userid:userID}
 */
+ (void)sellerGetPropertyWithUserId:(NSInteger)userid success:(void(^)(NSArray *propertyArray))success failure:(void(^)(NSString *errorMessage))failure;

//****************************POST****************************
/*Class method: Used for add property when user type is seller
 *@param dict format: @{"Property Id":propertyID, "Property Name":propertyName, "Property Type":propertyType, "Property Category":propertyCategory, "Property Address1":propertyAdd1, "Property Address2",propertyAdd2, "Property Zip":propertyZip, "Property Image 1":propertyImage2,"Property Image 1":propertyImage2, "Property Image 3":propertyImage3, "Property Latitude":propertyLatitute, "Property Longitude":propertyLongitute, "Property Cost":propertyCost, "Property Size":propertySize, "Property Desc":propertyDesc, "Property Published Date":propertyPubDate, "Property Modify Date":propertyModDate, "Property Status":propertyStatus, "User Id":userID}
 *@param success: block executed when add successed (return bool(true)
 *@param failure: block executed when add failed or having network connection error
 */
+ (void)sellerAddWithParameters:(NSDictionary *)dict faliure:(void(^)(NSString *errorMessage))failure;

/*Class method: Used for edit property when user type is seller
 *@param dict format: @{"Property Id":propertyID, "Property Name":propertyName, "Property Type":propertyType, "Property Category":propertyCategory, "Property Address1":propertyAdd1, "Property Address2",propertyAdd2, "Property Zip":propertyZip, "Property Image 1":propertyImage2,"Property Image 1":propertyImage2, "Property Image 3":propertyImage3, "Property Latitude":propertyLatitute, "Property Longitude":propertyLongitute, "Property Cost":propertyCost, "Property Size":propertySize, "Property Desc":propertyDesc, "Property Published Date":propertyPubDate, "Property Modify Date":propertyModDate, "Property Status":propertyStatus, "User Id":userID}
 *@param success: block executed when edit successed (return bool(true)
 *@param failure: block executed when add failed or having network connection error
 */
+ (void)sellerEditWithParameters:(NSDictionary *)dict faliure:(void(^)(NSString *errorMessage))failure;


/*Class method: Used for delete property when user type is seller
 *@param dict format: @{"Property Id":propertyID}
 *@param success: block executed when add successed (return bool(true)
 *@param failure: block executed when add failed or having network connection error
 */
+ (void)sellerDeleteWithParameters:(NSInteger)propertyid faliure:(void(^)(NSString *errorMessage))failure;

@end
