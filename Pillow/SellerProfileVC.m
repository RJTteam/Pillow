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
#import "ImageStoreManager.h"

@interface SellerProfileVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    AppDelegate *appDele;
    NSArray *infoItem;
    NSNumber *userID;
}
@property (weak, nonatomic) IBOutlet UITableView *profileTable;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMobile;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) UIImage *userIcon;
@property (nonatomic,strong)UIImagePickerController*picker;

@end

@implementation SellerProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buyerProfile.jpg"]];
    backImageView.frame = self.view.bounds;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
   
    [self.view insertSubview:backImageView atIndex:0];

    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:userKey];
    if(!userInfo){
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        userID = [userInfo objectForKey:useridKey];
    }
    
    appDele = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.profileTable.allowsSelection = NO;
    self.profileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    infoItem = @[@"SellerProfileCell",@"SellerInfoCell"];

    [User userGetUserInfoWithUserId:userID.integerValue success:^(User *user) {
        self.userName = user.username;
        self.userMobile = user.mobile;
        self.userEmail = user.email;
        
        ImageStoreManager *imageManager = [[ImageStoreManager alloc]init];
        NSString *iconWithID = [NSString stringWithFormat:@"%@",userID];
        NSData *iconData = [imageManager readimageDataWithimageName:iconWithID];
        self.userIcon = [UIImage imageWithData:iconData];
        [self.profileTable reloadData];
    } failure:^(NSString *errorMessage) {
        NSLog(@"Error ------ %@",errorMessage);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tabBarController dismissViewControllerAnimated:true completion:^{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:userKey];
            }];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
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

-(void)SourceISCamera{
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)sourceIsPhotoLibrary{
    self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)pickImage{
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;//Need confirm NagivationColler Delegate
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Image Source" message:@"Select Image Source" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [self SourceISCamera];
    }];
    UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action){
        [self sourceIsPhotoLibrary];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addAction:cameraAction];
    }
    [actionSheet addAction:galleryAction];
    [actionSheet addAction:cancelAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark-UIImagePickViewController Delegate Netgids
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    self.userIcon = image;
    NSData *imageData = UIImagePNGRepresentation(image);
    ImageStoreManager *imageManager = [[ImageStoreManager alloc]init];
    NSString *iconWithID = [NSString stringWithFormat:@"%@",userID];
    [imageManager storeImageToFile:imageData ImageName:iconWithID];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.profileTable reloadData];
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
        if (self.userIcon == nil) {
            cell1.userIcon.image = [UIImage imageNamed:@"userAvatar"];
            cell1.userIcon.layer.cornerRadius = cell1.userIcon.bounds.size.width / 2;
            cell1.userIcon.layer.masksToBounds = YES;
        }
        else{
        cell1.userIcon.image = self.userIcon;
        }
        cell1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.62f];
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
        cell2.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.62f];
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
