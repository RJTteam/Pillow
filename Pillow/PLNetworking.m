//
//  PLNetworking.m
//  LayerView
//
//  Created by Xinyuan Wang on 1/12/17.
//  Copyright © 2017 AlexW. All rights reserved.
//

#import "PLNetworking.h"

@implementation PLNetworking

+(instancetype)manager{
    static PLNetworking *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PLNetworking alloc] init];
    });
    return instance;
}

- (void)sendGETRequestToURL:(NSString *)url parameters:(NSDictionary *)param success:(void(^)(NSData *data, NSInteger status))success failed:(void(^)(NSError *error))failed{
    NSString *fragment = [self httpFragmentForParameters:param];
    NSURL *final = [NSURL URLWithString:[url stringByAppendingString:fragment]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:final completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
            return;
        }
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(data, statusCode);
            });
        }
    }];
    [task resume];
}

- (NSString *)httpFragmentForParameters:(NSDictionary *)param{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *format = [NSString stringWithFormat:@"%@=%@", key, obj];
        [array addObject:format];
    }];
    NSString *bodyString = [array componentsJoinedByString:@"&"];
    return bodyString;
}

- (void) sendPOSTRequestToURL:(NSString *)url parameters:(NSDictionary *)param success:(void (^)(NSData *data, NSInteger status))success failed:(void(^)(NSError *error))failed{
    NSURL *finalUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [self generatePostRequestForURL:finalUrl data:[self httpBodyForParameters:param]];
    NSURLSessionDataTask *datatask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
            return;
        }
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(data, statusCode);
            });
        }
    }];
    [datatask resume];
}

- (NSURLRequest *)generatePostRequestForURL:(NSURL *)url data: (NSData *)data{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    return request;
}

- (NSData *)httpBodyForParameters:(NSDictionary *)param{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *format = [NSString stringWithFormat:@"%@=%@", key, obj];
        [array addObject:format];
    }];
    NSString *bodyString = [array componentsJoinedByString:@"&"];
    return [self percentEscapeString: bodyString];
}

- (NSData *)percentEscapeString:(NSString *)str{
    NSString *encodeStr = [str stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLFragmentAllowedCharacterSet]];
    return [encodeStr dataUsingEncoding:NSUTF8StringEncoding];
}
@end
