//
//  SellerPropertyVC.m
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "SellerPropertyVC.h"
#import "SellerOwnPropertyCell.h"
#import "AppDelegate.h"
#import "EditPropertyVC.h"
#import "Property.h"
#import "Contants.h"
#import <SDwebImage/UIImageView+WebCache.h>

@interface SellerPropertyVC ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>
{
    AppDelegate *appDele;
    NSMutableArray *sellerPropertyArray;
    NSInteger expendRow;
    NSDictionary *userInfoDic;
}
@property (weak, nonatomic) IBOutlet UITableView *propertyList;
@property (assign,nonatomic) NSInteger userID;

@end

@implementation SellerPropertyVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    sellerPropertyArray = [NSMutableArray array];
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    userInfoDic = [userdefault objectForKey:userKey];
    self.userID = [[userInfoDic objectForKey:useridKey] integerValue];
    
    [Property sellerGetPropertyWithUserId:self.userID success:^(NSArray *propertyArray) {
        for (NSDictionary *dic in propertyArray) {
            Property *property = [[Property alloc] initWithDictionary:dic];
            [sellerPropertyArray addObject:property];
        }
        [self.propertyList reloadData];
    } failure:^(NSString *errorMessage) {
        NSLog(@"Error: %@",errorMessage);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    expendRow = 999;
    
    appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
     self.propertyList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProperty)];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

#pragma mark- TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sellerPropertyArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"PropertyCell";
    SellerOwnPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *parts = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [parts objectAtIndex:0];
    }
    cell.zoomButton.tag = indexPath.row;
    [cell.zoomButton addTarget:self action:@selector(reSizeCell:) forControlEvents:UIControlEventTouchUpInside];
    
    Property *obj = [sellerPropertyArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = obj.propertyName;
    cell.typeLabel.text = obj.propertyType;
    cell.dateLabel.text = obj.propertyModDate;
    cell.priceLabel.text = obj.propertyCost;
    cell.sizeLabel.text = obj.propertySize;
    
    NSString* urlStr1 = [self dealWithURLFormate:obj.propertyImage1];
    NSString* urlStr2 = [self dealWithURLFormate:obj.propertyImage2];
    NSString* urlStr3 = [self dealWithURLFormate:obj.propertyImage3];

    [cell.propertyImage1 sd_setImageWithURL:[NSURL URLWithString:urlStr1] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.propertyImage2 sd_setImageWithURL:[NSURL URLWithString:urlStr2] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [cell.propertyImage3 sd_setImageWithURL:[NSURL URLWithString:urlStr3] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;

}

-(NSString *)dealWithURLFormate:(NSString *)imageURL{
    NSString *step1 = [imageURL stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString *step2 = [NSString stringWithFormat:@"%@%@",@"http://",step1];
    return step2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == expendRow) {
        return 392;
    }
    else{
        return 230;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditPropertyVC *editVC = [[EditPropertyVC alloc]initWithNibName:@"EditPropertyVC" bundle:nil];
    editVC.aProperty = [sellerPropertyArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:editVC animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Update data source array here, something like [array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - privite method
-(void)reSizeCell:(UIButton *)cellBtn{
//    [self.propertyList reloadRowsAtIndexPaths:[NSIndexSet indexSetWithIndex:cellBtn.tag] withRowAnimation:UITableViewRowAnimationFade];
    if (expendRow != cellBtn.tag) {
        expendRow = cellBtn.tag;
        [self.propertyList reloadData];
    }
    else{
        expendRow = 999;
        [self.propertyList reloadData];
    }
}

-(void)addNewProperty{
    EditPropertyVC *editVC = [[EditPropertyVC alloc]initWithNibName:@"EditPropertyVC" bundle:nil];
    [self presentViewController:editVC animated:YES completion:nil];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"EditPropertyVC"]) {
//        if ([sender isKindOfClass:[UITableViewCell class]]) {
//            NSIndexPath *indexPath = [self.propertyList indexPathForSelectedRow];
//            EditPropertyVC *desitViewControl = segue.destinationViewController;
//            EditPropertyVC.aProperty = [sellerPropertyArray objectAtIndex:indexPath.row];
//        }
//        
//    }
//}


@end
