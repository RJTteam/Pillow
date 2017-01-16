//
//  manager.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "manager.h"
#import "CSMarker.h"
#import "Property.h"

@implementation manager

+(instancetype)sharedInstance{

    static manager* m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[manager alloc]init];
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
