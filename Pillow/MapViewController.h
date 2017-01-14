//
//  MapViewController.h
//  MyEstate
//
//  Created by Yangbin on 1/10/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ShowPropertyViewController.h"
#import "CSMarker.h"
#import "GetMarkerManager.h"
#import "webProvider.h"
#import "Property.h"
#import <AFURLSessionManager.h>

@import GooglePlaces;
@import GoogleMaps;

@interface MapViewController : UIViewController

@property (nonatomic,strong) GMSMapView* mapView;
@property (copy,nonatomic) NSMutableSet* markers;
@property (strong,nonatomic) NSString* zipCode;
//@property (strong, nonatomic) IBOutlet UITextField *range;
@property (strong, nonatomic) IBOutlet UITextField *range;
@property (weak,nonatomic) GetMarkerManager* mapManager;
@property (strong, nonatomic) IBOutlet UIView *searchBarView;
@property (strong, nonatomic) IBOutlet UIView *certainSearchView;
@property (strong,nonatomic) webProvider* mapProvider;
@property (strong,nonatomic) CSMarker* userSearchMarker;
@property (strong,nonatomic) UIImageView* imageView;
@property (strong,nonatomic) UIImage* image;

-(void)drawMarkers;


@end
