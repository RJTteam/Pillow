//
//  ShowPropertyViewController.m
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import "ShowPropertyViewController.h"

@interface ShowPropertyViewController ()

@end

@implementation ShowPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   // self.myProvider = [webProvider sharedInstance];
    
    //NSLog(@"get current property -> %@",self.propertyToShow.propertyName);
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
    
    NSLog(@"url1 %@",url1);
//    [self downLoadImage:url1 forImageView:self.firstImage];
//    [self downLoadImage:url2 forImageView:self.secondImage];
//    [self downLoadImage:url3 forImageView:self.thirdImage];
    
    
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToFavirate:(UIButton *)sender {
    
     assert(NO);
    
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
