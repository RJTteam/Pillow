//
//  SellerProfileVC.m
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "SellerProfileVC.h"

@interface SellerProfileVC ()<UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *appDele;
}
@property (weak, nonatomic) IBOutlet UITableView *profileTable;

@end

@implementation SellerProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.profileTable.allowsSelection = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (! cell) {
        NSArray *parts = [[NSBundle mainBundle] loadNibNamed:@"SellerProfileCell" owner:nil options:nil];
        cell = [parts objectAtIndex:0];
    }

    return cell;
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
