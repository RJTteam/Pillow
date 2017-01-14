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
#import <AFURLSessionManager.h>
#import "Property.h"

@interface SellerPropertyVC ()<UITableViewDelegate,UITableViewDataSource,NSURLSessionDelegate>
{
    AppDelegate *appDele;
    NSMutableArray *propertyArray;
    NSInteger expendRow;
}
@property (weak, nonatomic) IBOutlet UITableView *propertyList;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleBtn;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;

@end

@implementation SellerPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.addBtn.layer.cornerRadius = 21.0f;
    self.addBtn.hidden = YES;
    self.addBtn.tag = 200;
    self.editBtn.layer.cornerRadius = 21.0f;
    self.editBtn.hidden = YES;
    self.editBtn.tag = 201;
    self.deleBtn.layer.cornerRadius = 21.0f;
    self.deleBtn.hidden = YES;
    self.deleBtn.tag = 202;
    self.menuBtn.layer.cornerRadius = 21.0f;
    self.menuBtn.hidden = NO;

    expendRow = 999;
    
    propertyArray = [NSMutableArray array];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/getproperty.php?all&userid=2"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@",error);
        }
        else{
            for (NSDictionary *dic in responseObject) {
                Property *property = [[Property alloc] initWithDictionary:dic];
                [propertyArray addObject:property];
            }
            [self.propertyList reloadData];
        }
    }];
    [dataTask resume];
    

//    NSError *error;
//    NSData *propertyData = [NSData dataWithContentsOfURL:url];
//    id jsonObject = [NSJSONSerialization JSONObjectWithData:propertyData options:NSJSONReadingAllowFragments error:&error];
//    propertyArray = jsonObject;
    
    appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
     self.propertyList.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (IBAction)menuClick:(id)sender {
    if ([self.menuBtn.titleLabel.text  isEqual: @"+"]) {
        self.addBtn.hidden = NO;
        self.editBtn.hidden = NO;
        self.deleBtn.hidden = NO;
        [self.menuBtn setTitle:@"-" forState:UIControlStateNormal];
    }
    else{
        self.addBtn.hidden = YES;
        self.editBtn.hidden = YES;
        self.deleBtn.hidden = YES;
        [self.menuBtn setTitle:@"+" forState:UIControlStateNormal];
    }
}

- (IBAction)settingBtnClicked:(id)sender {
    EditPropertyVC *editVC = [[EditPropertyVC alloc]initWithNibName:@"EditPropertyVC" bundle:nil];
    [self presentViewController:editVC animated:YES completion:nil];
}

#pragma mark- TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return propertyArray.count;
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
    cell.detailBtn.tag = indexPath.row+100;
    [cell.detailBtn addTarget:self action:@selector(toDetailVC) forControlEvents:UIControlEventTouchUpInside];
    
    Property *obj = [propertyArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = obj.propertyName;
    cell.typeLabel.text = obj.propertyType;
    cell.dateLabel.text = obj.propertyModDate;
    cell.priceLabel.text = obj.propertyCost;
    cell.sizeLabel.text = obj.propertySize;
    
    NSString* urlStr = [obj.propertyImage1 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSURL* imageurl = [ NSURL URLWithString:urlStr ];
    NSData* data = [ NSData dataWithContentsOfURL: imageurl ];
    UIImage *currentdownloadimage = [ UIImage imageWithData: data ];
    cell.propertyImage.image = currentdownloadimage;
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == expendRow) {
        return 392;
    }
    else{
        return 230;
    }
}

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

-(void)toDetailVC{
    
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
