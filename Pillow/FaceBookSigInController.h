//
//  FaceBookSigInController.h
//  Pillow
//
//  Created by Xinyuan Wang on 1/16/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@class FaceBookSigInController;

@protocol FaceBookLoginControllerDelegate <NSObject>

@optional
- (void)fbController:(FaceBookSigInController *)controller didFinishLoginWithResult:(FBSDKLoginManagerLoginResult *)result andError:(NSError *)error;

- (void)fbControllerWillLogOut:(FaceBookSigInController *)controller;

@end

@interface FaceBookSigInController : NSObject

@property(weak, nonatomic)id<FaceBookLoginControllerDelegate>delegate;

@property(strong, nonatomic)NSArray *readPermissions;

+(instancetype)sharedInstance;

-(void)FBLoginWithViewController:(UIViewController *)controller;
-(void)FBLogOut;
@end
