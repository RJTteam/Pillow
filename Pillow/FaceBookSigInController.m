//
//  FaceBookSigInController.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/16/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "FaceBookSigInController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FaceBookSigInController ()

@property(strong, nonatomic)FBSDKLoginManager *manager;

@end

@implementation FaceBookSigInController

@synthesize readPermissions = _readPermissions;

-(instancetype)init{
    if(self = [super init]){
        _manager = [[FBSDKLoginManager alloc] init];
        _readPermissions= @[@"public_profile"];
    }
    return self;
}

+ (instancetype)sharedInstance{
    static FaceBookSigInController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FaceBookSigInController alloc] init];
    });
    return instance;
}

-(void)FBLoginWithViewController:(UIViewController *)controller{
    if([self.delegate respondsToSelector:@selector(fbController:didFinishLoginWithResult:andError:)]){
        [_manager logInWithReadPermissions:_readPermissions fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            [self.delegate fbController:self didFinishLoginWithResult:result andError:error];
        }];
    }
}

-(void)FBLogOut{
    if([self.delegate respondsToSelector:@selector(fbControllerWillLogOut:)]){
        [self.delegate fbControllerWillLogOut:self];
        [_manager logOut];
    }
}


@end
