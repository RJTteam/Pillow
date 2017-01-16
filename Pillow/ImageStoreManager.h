//
//  ImageStoreManager.h
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageStoreManager : NSObject

-(instancetype)init;
-(void)storeImageToFile:(NSData*)imageData ImageName:(NSString*)name;
-(NSData *)readimageDataWithimageName:(NSString *)name;

@end
