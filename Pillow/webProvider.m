//
//  webProvider.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "webProvider.h"
#import <AFURLSessionManager.h>
#import "Property.h"

@implementation webProvider

+(instancetype)sharedInstance{

    static webProvider* provider = nil;
    dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        provider = [[webProvider alloc]init];
    });
    return provider;
}

- (NSString *) baseURL
{
    return @"http://www.rjtmobile.com/realestate/getproperty.php?psearch&";
}

//http://www.rjtmobile.com/realestate/getproperty.php?psearch&ploc=8784545&pnear=4

-(void)webServiceCall:(NSDictionary*) parameter withHandler:(void (^)(NSArray* arrayOfProperty, NSError* error,NSURLResponse* webStatus ))returnData
{
    
    NSMutableString* urlString = [ NSMutableString stringWithString: [ self baseURL ] ];
        //[ urlString appendString: methodName ];
        //[ urlString appendString: @"?&" ];
        for( NSString* key in parameter )
        {
            [ urlString appendFormat: @"%@=%@&", key, [ parameter objectForKey: key ] ];
        }
    NSString* urlStr = [ urlString substringToIndex: urlString.length - 1 ];
    NSString* urlStr1 = [urlStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:urlStr1];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@",error);
        }
        else{
            _propertyArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in responseObject) {
                Property *property = [[Property alloc] initWithDictionary:dic];
                [_propertyArray addObject:property];
            }
            returnData(_propertyArray,error,response);
        }
    }];
    [dataTask resume];
}

-(void)getPic:(NSString*)url withHandler:(void (^)(NSData* data, NSError* error,NSURLResponse* webStatus ))returnData{

    NSMutableString* mstr = [[NSMutableString alloc]initWithString:@"http://"];
    NSString* newUrl = [mstr stringByAppendingString:url];
    NSURL* myUrl = [NSURL URLWithString:newUrl];
    NSLog(@"%@",myUrl);
    //NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
   // NSURLRequest* request = [NSURLRequest requestWithURL:myUrl];
//    NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSData* d = (NSData*)responseObject;
//        returnData(d,error,response);
//    }];
    
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:myUrl
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSString* status = nil;
                                                if (error) {
                                                    NSLog(@"dataTaskWithRequest error: %@", error);
                                                }
                                                if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                                    
                                                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                                    
                                                    if (statusCode != 200) {
                                                        NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                                        status = @"http request goes wrong";
                                                    }
                                                }
                                                returnData(data,error,response);
                                            }];
    
    [dataTask resume];
}

@end
