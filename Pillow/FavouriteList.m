//
//  FavouriteList.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/15/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "FavouriteList.h"
#import "Property.h"
#import "Contants.h"
#import "PLNetworking.h"

static NSString *const searchURL = @"http://www.rjtmobile.com/realestate/getproperty.php?psearch&";

@interface FavouriteList ()

@property(strong, nonatomic)NSMutableArray *innerList;
@property(strong, nonatomic)NSMutableArray *deletedList;

@end

@implementation FavouriteList

@synthesize favList;

-(NSArray *)favList{
    return self.innerList;
}

- (instancetype)init{
    if (self = [super init]){
        self.innerList = [[NSMutableArray alloc] init];
        self.deletedList = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance{
    static FavouriteList *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FavouriteList alloc] init];
    });
    return instance;
}

- (void)getPropertyAtIndex:(NSInteger)index success:(void(^)(Property *property))success failure:(void(^)(NSString *errorMessage))faliure{
    if(self.innerList.count <= index){
        faliure(@"Property is not in the favourite list");
    }
    NSDictionary *dict = [self.innerList objectAtIndex:index];
    [[PLNetworking manager] sendGETRequestToURL:searchURL parameters:dict success:^(NSData *data, NSInteger status) {
        if(status != 200){
            faliure([NSString stringWithFormat:@"Internet error: %lu", status]);
        }
        NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *objDict = [jsonObj firstObject];
        success([[Property alloc] initWithDictionary:objDict]);
    } failed:^(NSError *error) {
        faliure(error.localizedDescription);
    }];
}

- (void)loadFavListForUser:(NSString *)userid{
    NSString *userPath = [self getUserSavedPath:userid];
    NSString *finalPath = [userPath stringByAppendingPathComponent:favDirKey];
    if([[NSFileManager defaultManager] fileExistsAtPath:finalPath]){
        NSData *data = [NSData dataWithContentsOfFile:finalPath];
        NSArray *unpackedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        self.innerList = [NSMutableArray arrayWithArray: unpackedArray];
    }
}


- (NSString *)getUserSavedPath:(NSString *)userID{
    NSString *HomePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *userPath = [HomePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", userID]];
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:userPath isDirectory:&isDir];
    if(!isDir){
        [[NSFileManager defaultManager] createDirectoryAtPath:userPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return userPath;
}

- (void)addPropertyToFavourite:(Property *)property{
    NSDictionary *dict = @{
                           propSearchIDKey : property.propertyID,
                           propSearchNameKey:property.propertyName,
                           propSearchTypeKey:property.propertyType,
                           propSearchZipKey: property.propertyZip,
                           propSearchCatIDKey: property.propertyCategory
                           };
    for(NSDictionary *d in self.innerList){
        if([d[propSearchIDKey] isEqualToString:dict[propSearchIDKey]]){
            [self.innerList removeObject:d];
            break;
        }
    }
    for(NSDictionary *d in self.deletedList){
        if([d[propSearchIDKey] isEqualToString:dict[propSearchIDKey]]){
            [self.deletedList removeObject:d];
            break;
        }
    }
    [self.innerList addObject:dict];
}

- (void)removePropertyFromFavourite:(Property *)property{
    for(NSDictionary *p in self.innerList){
        if([p[propSearchIDKey] isEqualToString:property.propertyID]){
            [self.deletedList addObject:p];
            break;
        }
    }
}

- (void)saveToLocalForUser:(NSString *)userid{
    NSString *path = [self getUserSavedPath:userid];
    NSString *savePath = [path stringByAppendingPathComponent:favDirKey];
    [self.innerList removeObjectsInArray:self.deletedList];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.innerList];
    [data writeToFile:savePath atomically:true];
}


@end
