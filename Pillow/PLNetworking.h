//
//  PLNetworking.h
//  LayerView
//
//  Created by Xinyuan Wang on 1/12/17.
//  Copyright © 2017 AlexW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLNetworking : NSObject

+(instancetype)manager;

- (void)sendPOSTRequestToURL:(NSString *)url parameters:(NSDictionary *)param success:(void (^)(NSData *data, NSInteger status))success failed:(void(^)(NSError *error))failed;

- (NSURLRequest *)createMutiPartsFormRequestToUrl:(NSString *)url param:(NSDictionary *)param andDataPath:(NSString *)dir;

- (void)sendGETRequestToURL:(NSString *)url parameters:(NSDictionary *)param success:(void(^)(NSData *data, NSInteger status))success failed:(void(^)(NSError *error))failed;
@end
