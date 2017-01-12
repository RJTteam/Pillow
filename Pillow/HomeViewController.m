//
//  HomeViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    MapViewController * first = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    ListTableViewController * second = [[ListTableViewController alloc] initWithNibName:@"ListTableViewController" bundle:nil];
    SellerPropertyVC * third = [[SellerPropertyVC alloc]initWithNibName:@"SellerPropertyVC" bundle:nil];
    
    UINavigationController* nvOfThird = [[UINavigationController alloc]initWithRootViewController:third];
    UINavigationController* nvOfSecond = [[UINavigationController alloc]initWithRootViewController:second];
    UINavigationController* nvOfFirst = [[UINavigationController alloc]initWithRootViewController:first];
    
    NSArray* controllers = [NSArray arrayWithObjects:nvOfFirst, nvOfSecond, nvOfThird,nil];
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