//
//  FavouriteList.h
//  Pillow
//
//  Created by Xinyuan Wang on 1/15/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Property.h"

@interface FavouriteList : NSObject

@property(readonly, nonatomic)NSArray *favList;

+ (instancetype)sharedInstance;

- (void)loadFavListForUser:(NSString *)userid;

- (void)addPropertyToFavourite:(Property *)property;

- (void)removePropertyFromFavourite:(Property *)property;

- (void)saveToLocalForUser:(NSString *)userid;

- (void)getPropertyAtIndex:(NSInteger)index success:(void(^)(Property *property))success failure:(void(^)(NSString *errorMessage))faliure;

@end
