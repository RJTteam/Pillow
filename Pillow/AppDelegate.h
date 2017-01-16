//
//  AppDelegate.h
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "webProvider.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property( strong ) CLLocationManager* manager;
@property (strong,nonatomic) webProvider* provider;

@end

