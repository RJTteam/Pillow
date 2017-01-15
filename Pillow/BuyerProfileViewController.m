//
//  ProfileViewController.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "BuyerProfileViewController.h"
#import "FavouriteViewController.h"
#import "Contants.h"

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
    UIBarButtonItem *signOutButton = [[UIBarButtonItem alloc] initWithTitle:@"sign out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutButtonClicked)];
    self.navigationItem.rightBarButtonItem = signOutButton;
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
    //Send Current user id to favourite controller
    
    [self.navigationController pushViewController:fav animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
