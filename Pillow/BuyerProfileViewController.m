//
//  ProfileViewController.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "BuyerProfileViewController.h"
#import "FavouriteViewController.h"
#import "FavouriteList.h"
#import "Contants.h"
#import "User.h"
#import "ImageStoreManager.h"
#import <GOOGLE/SignIn.h>
#import "FaceBookSigInController.h"

@interface BuyerProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, FaceBookLoginControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxt;
@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic,strong)UIImagePickerController*picker;
@property (strong, nonatomic)NSNumber *userid;
@end

@implementation BuyerProfileViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:userKey];
    [self setUpViews];
    if(!userInfo){
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    }
    self.userid = [userInfo objectForKey:useridKey];
    NSString *loginType = [userDefault objectForKey:loginTypeKey];
    if([loginType isEqualToString:loginTypeNormal]){
        [self getUserIconWithUserId:self.userid];
    }else {
        self.usernameTxt.text = userInfo[usernameKey];
        self.emailTxt.text = userInfo[emailKey];
        self.mobileTxt.text = @"";
        NSString *imageUrl = userInfo[imgUrlKey];
        [self setImageAsync:imageUrl];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [FaceBookSigInController sharedInstance].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods

-(void)setImageAsync:(NSString *)imageUrl{
    if(![imageUrl isEqualToString:@""]){
        dispatch_async(dispatch_get_global_queue(2, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconImage.image = [UIImage imageWithData:imageData];
            });
        });
    }else{
        self.iconImage.image = [UIImage imageNamed:@"userAvatar"];
    }
}

-(void)setUpViews{
    self.iconImage.layer.masksToBounds = true;
    self.iconImage.layer.cornerRadius = self.iconImage.bounds.size.width / 2;
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"sign out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonClicked)];
    self.navigationItem.rightBarButtonItem = signOutButton;
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buyerProfile.jpg"]];
    backImageView.frame = self.view.bounds;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view insertSubview:backImageView atIndex:0];
}

-(void)getUserIconWithUserId:(NSNumber *)userid{
    [User userGetUserInfoWithUserId:userid.integerValue success:^(User *user) {
        self.usernameTxt.text = user.username;
        self.emailTxt.text = user.email;
        self.mobileTxt.text = user.mobile;
        
        ImageStoreManager *imageManager = [[ImageStoreManager alloc]init];
        NSString *iconWithID = [NSString stringWithFormat:@"%@",userid];
        NSData *iconData = [imageManager readimageDataWithimageName:iconWithID];
        if (iconData == nil) {
            self.iconImage.image =  [UIImage imageNamed:@"userAvatar"];
        }
        else{
            self.iconImage.image = [UIImage imageWithData:iconData];
        }
    } failure:^(NSString *errorMessage) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tabBarController dismissViewControllerAnimated:true completion:^{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:userKey];
            }];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    }];
}

-(void)SourceISCamera{
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)sourceIsPhotoLibrary{
    self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
}

#pragma mark - Event Methods

- (IBAction)pickBtnClicked:(id)sender {
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;//Need confirm NagivationColler Delegate
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Select Image Source" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [self SourceISCamera];
    }];
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [self sourceIsPhotoLibrary];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addAction:cameraAction];
    }
    [actionSheet addAction:galleryAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)signOutButtonClicked{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:userKey];
    NSString *loginType = userInfo[loginTypeKey];
    [[FavouriteList sharedInstance] saveToLocalForUser:userInfo[useridKey]];
    if([loginType isEqualToString:loginTypeNormal]){
        [userDefault removeObjectForKey:userKey];
    }else if([loginType isEqualToString:loginTypeFaceBook]){
        [[FaceBookSigInController sharedInstance] FBLogOut];
        [userDefault removeObjectForKey:userKey];
    }else if([loginType isEqualToString:loginTypeGoogle]){
        [[GIDSignIn sharedInstance] signOut];
        [userDefault removeObjectForKey:userKey];
    }
    [userDefault removeObjectForKey:loginTypeKey];
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)favouriteClicked {
    FavouriteViewController *fav = [[FavouriteViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    NSInteger userid = [[[[NSUserDefaults standardUserDefaults] objectForKey:userKey] objectForKey:useridKey] integerValue];
    fav.userid = userid;
    [self.navigationController pushViewController:fav animated:true];
}




#pragma mark-UIImagePickViewController Delegate Netgids
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    self.iconImage.image = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    ImageStoreManager *imageManager = [[ImageStoreManager alloc]init];
    NSString *iconWithID = [NSString stringWithFormat:@"%@",self.userid];
    [imageManager storeImageToFile:imageData ImageName:iconWithID];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FaceBookLoginControllerDelegate

- (void)fbControllerWillLogOut:(FaceBookSigInController *)controller{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
   [userDefault removeObjectForKey:userKey];
}

@end
