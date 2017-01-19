//
//  ListTableViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "ListTableViewController.h"
#import <AFURLSessionManager.h>
#import "Property.h"
#import "FavouriteList.h"

@interface ListTableViewController ()<UITableViewDelegate,NSURLSessionDelegate>
{
    NSMutableArray *propertyArray;
    
    UIPickerView *myPicker;
    
    NSString *textStr;
    
    UIToolbar *toolBar;
    
    NSArray *demoArray;
    
    UITextField* type;
    
    UIButton* search;
}

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    propertyArray = [NSMutableArray array];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://www.rjtmobile.com/realestate/getproperty.php?all"];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    [dataTask resume];
    
    
    //prepare the customized picker for use
//    demoArray = @[@"1000",@"3000",@"6000",@"9000",@"15000",@"20000",@"30000",@"40000",@"other"];
//    
//    myPicker = [[UIPickerView alloc]init];
//    myPicker.dataSource = (id)self;
//    myPicker.delegate = (id)self;
//    
//    toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
//    [toolBar setBarStyle:UIBarStyleDefault];
//    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(changeFromLabel:)];
//    toolBar.items = @[barButtonDone];
//    barButtonDone.tintColor=[UIColor blackColor];
//    
//    
//    self.type.inputView = pickerDemo;
//    self.type.inputAccessoryView = toolBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return propertyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ListTableViewCell";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        NSArray *parts = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [parts objectAtIndex:0];
    }
    
    Property* p = [propertyArray objectAtIndex:indexPath.row];
    cell.cellType.text = p.propertyType;
    if(p.propertyCost.length < 1){
        cell.cellPrice.text = @"N/A";
    }else{
        cell.cellPrice.text = p.propertyCost;
    }
    if(p.propertyStatus.length < 1){
        cell.cellStatus.text = @"N/A";
    }else{
        cell.cellStatus.text = p.propertyStatus;
    }
    
    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [act startAnimating];
    
    NSString* url = [p.propertyImage1 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    webProvider* listProvider = delegate.provider;
    
    [listProvider getPic:url withHandler:^(NSData *data, NSError *error, NSURLResponse *webStatus) {
        if(error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setNeedsDisplay];
                cell.cellImage.image = [UIImage imageNamed:@"noImage"];
                [act stopAnimating];
                [act hidesWhenStopped];
            });
            //[self.view insertSubview: self.certainSearchView  aboveSubview:self.mapView];
        }else if(!data){
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setNeedsDisplay];
                cell.cellImage.image = [UIImage imageNamed:@"noImage"];
                [act stopAnimating];
                [act hidesWhenStopped];
            });
            //[self.view insertSubview: self.certainSearchView  aboveSubview:self.mapView];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setNeedsDisplay];
                cell.cellImage.image = [UIImage imageWithData:data];
                [act stopAnimating];
                [act hidesWhenStopped];
            });
        }
    }];
    cell.addFavirate.tag = indexPath.row;
    [cell.addFavirate addTarget:self action:@selector(addFavirate:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)addFavirate:(UIButton *)sender{
    Property *p = [propertyArray objectAtIndex:sender.tag];
    [[FavouriteList sharedInstance] addPropertyToFavourite:p];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Successfully add property to favourite" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 150.0;
    
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShowPropertyViewController *detailViewController = [[ShowPropertyViewController alloc]initWithNibName:@"ShowPropertyViewController" bundle:nil];
    Property* p = [propertyArray objectAtIndex:indexPath.row];
    detailViewController.propertyToShow = p;
                                                        
    [self.navigationController pushViewController:detailViewController animated:YES];
                                                        
//    ShowPropertyViewController* spvc = [[ShowPropertyViewController alloc]init];
//    [self.navigationController pushViewController:spvc animated:YES];
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
