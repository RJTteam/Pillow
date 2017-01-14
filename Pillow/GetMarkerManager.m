//
//  manager.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "GetMarkerManager.h"
#import "CSMarker.h"
#import "Property.h"

@implementation GetMarkerManager

+(instancetype)sharedInstance{

    static GetMarkerManager* m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[GetMarkerManager alloc]init];
        m.markers = [[NSMutableSet alloc]init];
    });
    return m;
}

-(NSMutableSet*)createMarkerArrayWithArray:(NSArray*)arr{
    
    NSMutableSet* mutableSet = [[NSMutableSet alloc]initWithSet:self.markers];
    for(Property* d in arr){
        
        CSMarker* marker = [[CSMarker alloc]init];
        marker.objectID = d.propertyID;
        marker.position = CLLocationCoordinate2DMake(d.propertyLatitute.doubleValue, d.propertyLongitute.doubleValue);
        marker.title = d.propertyName;
        marker.snippet = d.propertyType;
        marker.propertyStoredInMarker = d;
        [mutableSet addObject:marker];
    }
    self.markers = [mutableSet copy];
    //NSLog(@"output all the markers %@",self.markers);
    return self.markers;
}

@end
