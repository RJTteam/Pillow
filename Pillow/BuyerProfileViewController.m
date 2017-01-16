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

@interface BuyerProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxt;

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
    NSNumber *userid = [userInfo objectForKey:useridKey];
    [User userGetUserInfoWithUserId:userid.integerValue success:^(User *user) {
        self.usernameTxt.text = user.username;
        self.emailTxt.text = user.email;
        self.mobileTxt.text = user.mobile;
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

#pragma mark - test method
- (void)testAddPropertyToFav{
    NSDictionary *dict = @{@"Property Id":@"12",@"Property Name":@"vdbsn",@"Property Type":@"Apartment",@"Property Category":@"1",@"Property Address1":@"vdndm",@"Property Address2":@"vxbnx",@"Property Zip":@"99",@"Property Image 1":@"www.rjtmobile.com/realestate/images/99/file_avatar1.jpg",@"Property Image 2":@"",@"Property Image 3":@"",@"Property Latitude":@"41.9425260",@"Property Longitude":@"-88.2673400",@"Property Cost":@"8598",@"Property Size":@"965",@"Property Desc":@"cvxn",@"Property Published Date":@"2016-07-20 14:11:25",@"Property Modify Date":@"0000-00-00 00:00:00",@"Property Status":@"yes",@"User Id":@"0"};
    Property *p = [[Property alloc] initWithDictionary:dict];
    [[FavouriteList sharedInstance] addPropertyToFavourite:p];
}

@end
