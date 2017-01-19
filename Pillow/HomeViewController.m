//
//  HomeViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "HomeViewController.h"
#import "BuyerProfileViewController.h"
#import "Contants.h"
#import "FavouriteList.h"

@interface HomeViewController ()


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //For test purpose, delete when model is introduced
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:userKey];
    BOOL isTourist = NO;
    BOOL isBuyer = NO;
    if(!userInfo){
        isTourist = YES;
    }else{
        isBuyer = [userInfo[usertypeKey] isEqualToString:buyerContent];
        if(isBuyer){
            [[FavouriteList sharedInstance] loadFavListForUser:userInfo[useridKey]];
        }
    }
    MapViewController * first = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    ListTableViewController * second = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    
    UINavigationController* nvOfFirst = [[UINavigationController alloc]initWithRootViewController:first];
    UINavigationController* nvOfSecond = [[UINavigationController alloc]initWithRootViewController:second];
    NSMutableArray* controllers = [NSMutableArray arrayWithObjects:nvOfFirst,nvOfSecond,nil];
    
    //TODO read user type from model
    
        
    if(isBuyer || isTourist){
        BuyerProfileViewController *third = [[BuyerProfileViewController alloc]initWithNibName:@"BuyerProfileView" bundle:nil];
        UINavigationController *nvOfThird = [[UINavigationController alloc] initWithRootViewController:third];
        [controllers addObject:nvOfThird];
    }else{
        SellerProfileVC * third = [[SellerProfileVC alloc]initWithNibName:@"SellerProfileVC" bundle:nil];
        UINavigationController *nvOfThird = [[UINavigationController alloc] initWithRootViewController:third];
        [controllers addObject:nvOfThird];
    }
    self.viewControllers = controllers;
    [[self.tabBar.items objectAtIndex:0] setTitle:@"Map"];
    [[self.tabBar.items objectAtIndex:1] setTitle:@"List"];
    [[self.tabBar.items objectAtIndex:2] setTitle:@"Me"];
    
    [[self.tabBar.items objectAtIndex:0]setImage:[UIImage imageNamed:@"map"]];
    [[self.tabBar.items objectAtIndex:1]setImage:[UIImage imageNamed: @"list"]];
    [[self.tabBar.items objectAtIndex:2]setImage:[UIImage imageNamed: @"me"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
