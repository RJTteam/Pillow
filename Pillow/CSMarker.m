//
//  CSMarker.m
//  Estate_proj
//
//  Created by Yangbin on 1/9/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "CSMarker.h"

@implementation CSMarker

-(BOOL)isEqual:(id)object{
    
    CSMarker* otherMarker = (CSMarker*)object;
    if([self.objectID isEqualToString:otherMarker.objectID]){
        return YES;
    }
    return NO;
}

-(NSUInteger)hash{

    return [self.objectID hash];

}

@end
