//
//  PLNetworking.m
//  LayerView
//
//  Created by Xinyuan Wang on 1/12/17.
//  Copyright © 2017 AlexW. All rights reserved.
//

#import "PLNetworking.h"
#import "Contants.h"

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
    NSString *rawUrl = [[url stringByAppendingString:fragment]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *final = [NSURL URLWithString:rawUrl];
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

- (void) sendPostRequestToURL:(NSString *)url withParams:(NSDictionary *)param andDataDir:(NSString *)dir success:(void (^)(NSData *data, NSInteger status))success failed:(void(^)(NSError *error))failed{
    NSURLRequest *request = [self createMutiPartsFormRequestToUrl:url param:param andDataPath:dir];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            failed(error);
            return;
        }
        if([response isKindOfClass:[NSHTTPURLResponse class]]){
            NSInteger status = [(NSHTTPURLResponse *)response statusCode];
            success(data, status);
        }
    }];
    [task resume];
}

- (NSURLRequest *)createMutiPartsFormRequestToUrl:(NSString *)url param:(NSDictionary *)param andDataPath:(NSString *)dir{
    //generate boundary
    NSString *boundary = [self generatBoundary];
    //create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    //set Content type
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    //create body
    NSData *body = [self createHTTPBodyWith:boundary parameters:param directoryPath:dir];
    request.HTTPBody = body;
    //return request with body
    return request;
}

- (NSData *)createHTTPBodyWith:(NSString *)boundary parameters:(NSDictionary *)param directoryPath:(NSString *)path{
    //init mutable data
    NSMutableData *httpbody = [NSMutableData data];
    //append parameters into data
    [param enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
        [httpbody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *encodeValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [httpbody appendData:[[NSString stringWithFormat:@"Content-Disposition form-data: name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpbody appendData:[[NSString stringWithFormat:@"%@\r\n",encodeValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    //append image data into data
    for(NSString *filename in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]){
        NSString *filepath = [path stringByAppendingPathComponent:filename];
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        NSString *mimetype = @"image/png";
        
        [httpbody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpbody appendData:[[NSString stringWithFormat:@"Content-Disposition form-data: name=\"%@\"; filename=\"%@\"\r\n",filename, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpbody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpbody appendData:data];
        [httpbody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //append boundary
    [httpbody appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //return data
    return httpbody;
}

- (NSString *)generatBoundary{
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}
@end
