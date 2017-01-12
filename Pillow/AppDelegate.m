//
//  AppDelegate.m
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "AppDelegate.h"
#import "SignInViewController.h"

@import GoogleMaps;
@import GooglePlaces;

@interface AppDelegate ()

@property (strong, nonatomic) SellerProfileVC *sellerprofileVC;
@property (strong, nonatomic) SellerPropertyVC *sellerPropertyVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:@"AIzaSyCUN5ix7arYIgDZ_Nol_rpsnUnYzlvNn2M"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyCUN5ix7arYIgDZ_Nol_rpsnUnYzlvNn2M"];
    self.manager = [ [ CLLocationManager alloc ] init ];
    self.manager.delegate = (id)self;
    [ self.manager requestAlwaysAuthorization ];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    SignInViewController *signIn = [[SignInViewController alloc] initWithNibName:@"SignInView" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signIn];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if( status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse )
    {
        [ self.manager startUpdatingLocation ];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
