//
//  ShowPropertyViewController.h
//  MyEstate
//
//  Created by Yangbin on 1/11/17.
//  Copyright © 2017 com.rjtcompuquest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Property.h"
#import "webProvider.h"
#import <SDwebImage/UIImageView+WebCache.h>

@interface ShowPropertyViewController : UIViewController<NSURLSessionDelegate>

@property (strong,nonatomic) Property* propertyToShow;
@property (strong, nonatomic) IBOutlet UILabel *propertyID;
@property (strong, nonatomic) IBOutlet UILabel *propertyType;
@property (strong, nonatomic) IBOutlet UILabel *propertyCost;
@property (strong, nonatomic) IBOutlet UILabel *propertyZip;
@property (strong, nonatomic) IBOutlet UILabel *propertyStatus;
@property (strong, nonatomic) IBOutlet UILabel *propertyName;
@property (strong, nonatomic) IBOutlet UILabel *propertyAdd;
@property (strong, nonatomic) IBOutlet UIImageView *firstImage;
@property (strong, nonatomic) IBOutlet UIImageView *secondImage;
@property (strong, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UILabel *contactInfoLabel;

@property (strong,nonatomic) SDWebImageManager *imageManager;
@property (strong,nonatomic) webProvider* myProvider;

-(void)downLoadImage:(NSString*)url forImageView:(UIImageView*)imageView;

@end
