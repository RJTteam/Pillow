//
//  GoogleSignInController.m
//  GoogleSignInDemo
//
//  Created by Xinyuan Wang on 1/16/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "GoogleSignInController.h"
#import "Contants.h"
#import "HomeViewController.h"

@implementation GoogleSignInController

+ (instancetype)sharedInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GoogleSignInController alloc] init];
    });
    return instance;
}

#pragma mark -GIDSignInDelegate 

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if(!error){
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *fullName = user.profile.name;
        NSString *email = user.profile.email;
        NSString *img = @"";
        if(user.profile.hasImage){
            img = [user.profile imageURLWithDimension:100].absoluteString;
        }
        NSDictionary *dict = @{
                               emailKey : email,
                               usertypeKey : buyerContent,
                               usernameKey : fullName,
                               useridKey : userId,
                               imgUrlKey : img,
                               loginTypeKey:loginTypeGoogle
                               };
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:dict forKey:userKey];
        HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        [self.destinationController presentViewController:home animated:YES completion:nil];
    }else{
        NSLog(@"%@", error);
    }
}


// Finished disconnecting |user| from the app successfully if |error| is |nil|.
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
    NSLog(@"Did remove current user from user default");
}

#pragma mark - GIDSignInUIDelegate
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController{
    [self.destinationController presentViewController:viewController animated:true completion:nil];
}

// If implemented, this method will be invoked when sign in needs to dismiss a view controller.
// Typically, this should be implemented by calling |dismissViewController| on the passed
// view controller.
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController{
    [self.destinationController dismissViewControllerAnimated:true completion:nil];
}


@end
