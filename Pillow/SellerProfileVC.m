//
//  SellerProfileVC.m
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "SellerProfileVC.h"
#import "SellerPropertyVC.h"

@interface SellerProfileVC ()<UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *appDele;
    NSArray *infoItem;
}
@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@end

@implementation SellerProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.profileTable.allowsSelection = NO;
    self.profileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    infoItem = @[@"SellerProfileCell",@"SellerInfoCell",@"SellerPropertyCell"];

}
- (IBAction)viewBtnClicked:(id)sender {
    SellerPropertyVC *sellerPropertyVC = [[SellerPropertyVC alloc]initWithNibName:@"SellerPropertyVC" bundle:nil];
//    [self presentViewController:sellerPropertyVC animated:YES completion:nil];
    [self.navigationController pushViewController:sellerPropertyVC animated:YES];
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoItem.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellIdentifier = [infoItem objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *parts = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [parts objectAtIndex:0];
    }
    return cell;
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
