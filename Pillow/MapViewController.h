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
//#import "manager.h"
//#import "webService.h"

@import GooglePlaces;
@import GoogleMaps;

@interface MapViewController : UIViewController

@property (nonatomic,strong) GMSMapView* mapView;
@property (copy,nonatomic) NSSet* markers;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong,nonatomic) NSString* zipCode;
//@property (strong, nonatomic) IBOutlet UITextField *range;
@property (strong, nonatomic) IBOutlet UITextField *range;

-(void)drawMarkers;


@end
