//
//  CSMarker.h
//  Estate_proj
//
//  Created by Yangbin on 1/9/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <Foundation/Foundation.h>
#import "Property.h"

@interface CSMarker : GMSMarker

@property(nonatomic,strong) NSString* objectID;
@property(nonatomic,strong) Property* propertyStoredInMarker;

@end
