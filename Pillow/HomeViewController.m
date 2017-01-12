//
//  HomeViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "HomeViewController.h"
#import "BuyerProfileViewController.h"

@interface HomeViewController ()

@property(nonatomic)BOOL isBuyer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //For test purpose, delete when model is introduced
    self.isBuyer = YES;
    
    MapViewController * first = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    ListTableViewController * second = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    UINavigationController* nvOfFirst = [[UINavigationController alloc]initWithRootViewController:first];
    UINavigationController* nvOfSecond = [[UINavigationController alloc]initWithRootViewController:second];
    NSMutableArray* controllers = [NSMutableArray arrayWithObjects:nvOfFirst,nvOfSecond, nil];
    
    //TODO read user type from model
    if(self.isBuyer){
        BuyerProfileViewController *third = [[BuyerProfileViewController alloc]initWithNibName:@"BuyerProfileView" bundle:nil];
        UINavigationController *nvOfThird = [[UINavigationController alloc] initWithRootViewController:third];
        [controllers addObject:nvOfThird];
    }else{
        SellerPropertyVC * third = [[SellerPropertyVC alloc]initWithNibName:@"SellerPropertyVC" bundle:nil];
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
