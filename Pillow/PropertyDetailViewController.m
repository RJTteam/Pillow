//
//  PropertyDetailViewController.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/12/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "PropertyDetailViewController.h"

@interface PropertyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@end

@implementation PropertyDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionViewDataSource



#pragma mark - UICollectionViewDelegate



#pragma mark - UICollectionViewFlowlayoutDelegate;


@end
