//
//  GoogleSignInController.h
//  GoogleSignInDemo
//
//  Created by Xinyuan Wang on 1/16/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface GoogleSignInController : NSObject<GIDSignInDelegate, GIDSignInUIDelegate>

+ (instancetype)sharedInstance;

@property(weak , nonatomic)UIViewController *destinationController;

@end
