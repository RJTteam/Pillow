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

@interface BuyerProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxt;
@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (nonatomic,strong)UIImagePickerController*picker;
@property (nonatomic,strong)NSNumber *userid;
@end

@implementation BuyerProfileViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:userKey];
    if(!userInfo){
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    }
    self.userid = [userInfo objectForKey:useridKey];
    [User userGetUserInfoWithUserId:self.userid.integerValue success:^(User *user) {
        self.usernameTxt.text = user.username;
        self.emailTxt.text = user.email;
        self.mobileTxt.text = user.mobile;

        ImageStoreManager *imageManager = [[ImageStoreManager alloc]init];
        NSString *iconWithID = [NSString stringWithFormat:@"%@",self.userid];
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
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"sign out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonClicked)];
    self.navigationItem.rightBarButtonItem = signOutButton;
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buyerProfile.jpg"]];
    backImageView.frame = self.view.bounds;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
//    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *effect = [[UIVisualEffectView alloc]initWithEffect:blur];
//    effect.frame = backImageView.bounds;
//    [backImageView addSubview:effect];
    [self.view insertSubview:backImageView atIndex:0];
    //initilize favourite list singleton and load data from local
//    [self testAddPropertyToFav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
#pragma mark - Event Methods

- (void)signOutButtonClicked{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:userKey];
    [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)favouriteClicked {
    FavouriteViewController *fav = [[FavouriteViewController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    NSInteger userid = [[[[NSUserDefaults standardUserDefaults] objectForKey:userKey] objectForKey:useridKey] integerValue];
    fav.userid = userid;
    [self.navigationController pushViewController:fav animated:true];
}

-(void)SourceISCamera{
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)sourceIsPhotoLibrary{
    self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
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

#pragma mark - test method
- (void)testAddPropertyToFav{
    NSDictionary *dict = @{@"Property Id":@"12",@"Property Name":@"vdbsn",@"Property Type":@"Apartment",@"Property Category":@"1",@"Property Address1":@"vdndm",@"Property Address2":@"vxbnx",@"Property Zip":@"99",@"Property Image 1":@"www.rjtmobile.com/realestate/images/99/file_avatar1.jpg",@"Property Image 2":@"",@"Property Image 3":@"",@"Property Latitude":@"41.9425260",@"Property Longitude":@"-88.2673400",@"Property Cost":@"8598",@"Property Size":@"965",@"Property Desc":@"cvxn",@"Property Published Date":@"2016-07-20 14:11:25",@"Property Modify Date":@"0000-00-00 00:00:00",@"Property Status":@"yes",@"User Id":@"0"};
    Property *p = [[Property alloc] initWithDictionary:dict];
    [[FavouriteList sharedInstance] addPropertyToFavourite:p];
}

@end
