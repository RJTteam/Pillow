//
//  manager.h
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface manager : NSObject

@property (nonatomic,strong) NSMutableSet* markers;


-(NSMutableSet*)createMarkerArrayWithArray:(NSArray*)arr;
+(instancetype)sharedInstance;

@end
