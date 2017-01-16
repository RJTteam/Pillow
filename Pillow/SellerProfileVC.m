//
//  SellerProfileVC.m
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "SellerProfileVC.h"
#import "SellerPropertyVC.h"
#import "Contants.h"
#import "User.h"
#import "SellerInfoCell.h"
#import "SellerProfileCell.h"

@interface SellerProfileVC ()<UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *appDele;
    NSArray *infoItem;
    NSInteger userID;
}
@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMobile;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) UIImage *userIcon;
@end

@implementation SellerProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:userKey];
    if(!userInfo){
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        userID = [[userInfo objectForKey:useridKey]integerValue];
    }
    
    appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.profileTable.allowsSelection = NO;
    self.profileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    infoItem = @[@"SellerProfileCell",@"SellerInfoCell"];

    [User userGetUserInfoWithUserId:userID success:^(User *user) {
        self.userName = user.username;
        self.userMobile = user.mobile;
        self.userEmail = user.email;
    } failure:^(NSString *errorMessage) {
        NSLog(@"Error ------ %@",errorMessage);

    }];
}
- (IBAction)viewBtnClicked:(id)sender {
    SellerPropertyVC *sellerPropertyVC = [[SellerPropertyVC alloc]initWithNibName:@"SellerPropertyVC" bundle:nil];
//    [self presentViewController:sellerPropertyVC animated:YES completion:nil];
    [self.navigationController pushViewController:sellerPropertyVC animated:YES];
}

- (IBAction)logOutClicked:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:userKey];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pickImage{
    
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoItem.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellIdentifier = [infoItem objectAtIndex:indexPath.row];
    if ([cellIdentifier isEqualToString:@"SellerProfileCell"]) {
        SellerProfileCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell1) {
            NSArray *parts = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell1 = [parts objectAtIndex:0];
        }
        [cell1.pickerBtn addTarget:self action:@selector(pickImage) forControlEvents:UIControlEventTouchUpInside];
        cell1.userIcon.image = self.userIcon;
        return cell1;
    }
    else{
        SellerInfoCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell2) {
            NSArray *parts = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell2 = [parts objectAtIndex:0];
        }
        cell2.nameLabel.text = self.userName;
        cell2.mobileLabel.text = self.userMobile;
        cell2.emailLabel.text = self.userEmail;
        return cell2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 127;
    }
    else if(indexPath.row == 1){
        return 180;
    }
    else{
        return 177;
    }
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
