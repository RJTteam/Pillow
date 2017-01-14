//
//  Property.h
//  Pillow
//
//  Created by Lucas Luo on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Property : NSObject

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
@property(strong,nonatomic)NSString *propertyPubDate;
@property(strong,nonatomic)NSString *propertyModDate;
@property(strong,nonatomic)NSString *propertyStatus;
@property(strong,nonatomic)NSString *userID;

- (instancetype)initWithDictionary: (NSDictionary *)dic;

@end
