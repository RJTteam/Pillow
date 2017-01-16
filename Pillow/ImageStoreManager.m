//
//  ImageStoreManager.m
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "ImageStoreManager.h"

@implementation ImageStoreManager

-(instancetype)init{
    self=[super init];
    return self;
}
-(NSString*)getImageStoreDirectoryPath{
   return [NSHomeDirectory() stringByAppendingString:@"/tmp/"];
}

-(NSString*)imageStoreFilePathByImageName:(NSString*)name{
    return [[[self getImageStoreDirectoryPath] stringByAppendingString:[NSString stringWithFormat:@"%@.jpg",name]] stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet.URLQueryAllowedCharacterSet)];
}


-(void)storeImageToFile:(NSData*)imageData ImageName:(NSString*)name{
    NSString *imageFilePath = [self imageStoreFilePathByImageName:name];
    [imageData writeToFile:imageFilePath atomically:YES];
}

-(NSData *)readimageDataWithimageName:(NSString *)name{
    NSString *imageFullname = [name stringByAppendingString:@".jpg"];
    NSString *filePath = [[self getImageStoreDirectoryPath] stringByAppendingString:imageFullname];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    return imageData;
}
//-(NSString *)imageStore:(NSString*)imageUrl hotelId:(NSString*)hotelId{
//    NSURL *url = [NSURL URLWithString:imageUrl];
//    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        
//        if(error){
//            NSLog(@"Error %@",error.description);
//            return;
//        }
//        
//        //After request call success we get here but may be web-server return some error
//        if([response isKindOfClass:[NSHTTPURLResponse class]]){
//            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
//            //if success then we will get 200
//            if( statusCode !=200){
//                //Error in HTTP request
//                NSLog(@"Error in HTTP Request:%ld",(long)statusCode);
//                return;
//            }
//            else{
//                //[self.delegate sendFilePath:[self storeImageToFile:data hotelId:hotelId]];
//                [self storeImageToFile:data hotelId:hotelId];
//            }
//        }
//    }]resume];
//    return [self getImageStoreFilePathByHotelId:hotelId];
//}



@end
