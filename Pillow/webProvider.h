//
//  webProvider.h
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface webProvider : NSObject

@property (nonatomic,strong)   NSMutableArray *propertyArray;

- (NSString *) baseURL;

-(void)webServiceCall:(NSDictionary*) parameter withHandler:(void (^)(NSArray* arrayOfProperty, NSError* error,NSURLResponse* webStatus ))returnData;

-(void)getPic:(NSString*) url withHandler:(void (^)(NSData* data, NSError* error,NSURLResponse* webStatus ))returnData;

+(instancetype)sharedInstance;

@end
