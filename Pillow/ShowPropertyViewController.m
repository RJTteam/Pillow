//
//  ShowPropertyViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "ShowPropertyViewController.h"
#import "FavouriteList.h"
#import "User.h"
#import "Contants.h"


@interface ShowPropertyViewController ()
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMobile;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSNumber *userid;
@end

@implementation ShowPropertyViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [userDefault objectForKey:userKey];
    if(!userInfo){
        [self.tabBarController dismissViewControllerAnimated:YES completion:nil];
    }
    self.userid = [userInfo objectForKey:useridKey];
    [User userGetUserInfoWithUserId:self.userid.integerValue success:^(User *user) {
        self.userName = user.username;
        self.userEmail = user.email;
        self.userMobile = user.mobile;
        self.contactInfoLabel.text = [NSString stringWithFormat:@"Call %@ now With Number:%@",self.userName,self.userMobile];
    } failure:^(NSString *errorMessage) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.propertyID.text = self.propertyToShow.propertyID;
    if(self.propertyToShow.propertyType.length < 1){
        self.propertyType.text = @"N/A";
    }else{
        self.propertyType.text = self.propertyToShow.propertyType;
    }
    if(self.propertyToShow.propertyCost.length < 1){
        self.propertyCost.text = @"N/A";
    }else{
        self.propertyCost.text = self.propertyToShow.propertyCost;
    }
    self.propertyZip.text = self.propertyToShow.propertyZip;
    if(self.propertyToShow.propertyStatus.length < 1){
        self.propertyStatus.text = @"N/A";
    }else{
        self.propertyStatus.text = self.propertyToShow.propertyStatus;
    }
    if(self.propertyToShow.propertyName.length < 1){
        self.propertyName.text = @"N/A";
    }else{
        self.propertyName.text = self.propertyToShow.propertyName;
    }
    if(self.propertyToShow.propertyAdd1.length < 1){
        self.propertyAdd.text = @"N/A";
    }else{
        NSMutableString* myAdd = [NSMutableString stringWithString:self.propertyToShow.propertyAdd1];
        [myAdd stringByAppendingString:self.propertyToShow.propertyadd2];
        self.propertyAdd.text = myAdd;
    }
    

    //self.imageManager = [SDWebImageManager sharedManager];
    NSString* url1 = [self.propertyToShow.propertyImage1 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString* url2 = [self.propertyToShow.propertyImage2 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString* url3 = [self.propertyToShow.propertyImage3 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSMutableString* newurl = [[NSMutableString alloc]initWithString:@"http://"];
    url1 = [newurl stringByAppendingString:url1];
    url2 = [newurl stringByAppendingString:url2];
    url3 = [newurl stringByAppendingString:url3];
    
    [self.firstImage sd_setImageWithURL:[NSURL URLWithString:url1] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image == nil){
            self.firstImage.image = [UIImage imageNamed:@"noImage"];
        }
    }];
    [self.secondImage sd_setImageWithURL:[NSURL URLWithString:url2] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image == nil){
            self.secondImage.image = [UIImage imageNamed:@"noImage"];
        }
    }];
    [self.thirdImage sd_setImageWithURL:[NSURL URLWithString:url3] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image == nil){
            self.thirdImage.image = [UIImage imageNamed:@"noImage"];
        }
    }];
    
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareBtnClicked)];
    self.navigationItem.rightBarButtonItem = shareBtn;
}
- (IBAction)phoneCallBtn:(id)sender {
    NSString *phoneString = [NSString stringWithFormat:@"tel:%@",self.userMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]options:@{} completionHandler:nil];
}

-(void)shareBtnClicked{
    NSString *bodyStr = [NSString stringWithFormat:@"Hi, My Name is: %@ \n My Mobile Number: %@ \n My Email: %@ \n",self.userName,self.userMobile,self.userEmail];
    NSString *propertyInfo = [NSString stringWithFormat:@"My Property Named %@, is located in %@ %@, for $%@. \n If interested please contact me",self.propertyName.text,self.propertyAdd.text,self.propertyZip.text,self.propertyCost.text];
    
    UIActivityViewController *MoreVC = [[UIActivityViewController alloc] initWithActivityItems:@[bodyStr,self.firstImage.image,propertyInfo] applicationActivities:nil];
    MoreVC.excludedActivityTypes = @[UIActivityTypeOpenInIBooks,
                                     UIActivityTypePrint,
                                     UIActivityTypeAssignToContact];
    [self presentViewController:MoreVC animated:YES completion:nil];
}


- (IBAction)addToFavirate:(UIButton *)sender {
    [[FavouriteList sharedInstance] addPropertyToFavourite:self.propertyToShow];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Successfully add property to favourite" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

-(void)downLoadImage:(NSString*)url forImageView:(UIImageView *)imageView{

    UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imageView addSubview:act];
    [act startAnimating];
    
    [self.myProvider getPic:url withHandler:^(NSData *data, NSError *error, NSURLResponse *webStatus) {
        if(error){
            imageView.image = [UIImage imageNamed:@"noImage"];
            [act stopAnimating];
            [act hidesWhenStopped];
            //[self.view insertSubview: self.certainSearchView  aboveSubview:self.mapView];
        }else if(!data){
            imageView.image = [UIImage imageNamed:@"noImage"];
            [act stopAnimating];
            [act hidesWhenStopped];
            //[self.view insertSubview: self.certainSearchView  aboveSubview:self.mapView];
        }else{
            imageView.image = [UIImage imageWithData:data];
            [act stopAnimating];
            [act hidesWhenStopped];
        }
    }];
    
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
