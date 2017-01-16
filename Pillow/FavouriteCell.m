//
//  FavouriteCell.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "FavouriteCell.h"
#import "PLNetworking.h"
#import "FavouriteList.h"

@interface ThumbnailCell : UICollectionViewCell

@property(strong, nonatomic)UIImageView *thumbnail;
@property(strong, nonatomic)UILabel *priceLabel;
@property(strong, nonatomic)UILabel *typeLabel;

@property(strong, nonatomic)UIButton *favButton;
@property(strong, nonatomic)Property *property;

@end

@implementation ThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.typeLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.favButton.translatesAutoresizingMaskIntoConstraints = false;
        [self.favButton addTarget:self action:@selector(favButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)favButtonClicked:(UIButton *)sender{
    if(!sender.isSelected){
        [[FavouriteList sharedInstance] removePropertyFromFavourite:self.property];
    }else{
        [[FavouriteList sharedInstance] addPropertyToFavourite:self.property];
    }
    [sender setSelected:!sender.isSelected];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.thumbnail.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.thumbnail.image = [UIImage imageNamed:@"placeholder"];
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.font = [UIFont fontWithName:@"Courier" size:28.0f];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.font = [UIFont fontWithName:@"Courier" size:28.0f];
    self.backgroundView = self.thumbnail;
    [self.favButton setBackgroundImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
    [self.favButton setBackgroundImage:[UIImage imageNamed:@"unFav"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.favButton];
    
    NSString *hformat = [NSString stringWithFormat:@"H:|-5-[v0]-%.2f-|", self.bounds.size.width / 3];
    NSString *priceHFormat = [NSString stringWithFormat:@"H:|-5-[v0]-%.2f-[v1]-10-|", self.bounds.size.width / 3];
    NSString *vformat = [NSString stringWithFormat:@"V:|-%0.2f-[v1]-10-[v0]-10-|", self.bounds.size.height / 2];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:priceHFormat options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"v0":self.priceLabel, @"v1":self.favButton}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hformat options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"v0":self.typeLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vformat options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"v0":self.priceLabel, @"v1":self.typeLabel}]];
}

@end

@interface DescriptCell : UICollectionViewCell

@property(strong, nonatomic)UIImageView *backImageView;
@property(strong, nonatomic)UILabel *priceLabel;
@property(strong, nonatomic)UILabel *addrLabel;
@property(strong, nonatomic)UILabel *descriptAndSize;
@property(strong, nonatomic)UIButton *detailButton;

@property(strong, nonatomic)Property *property;


@end

/************************************************************************************************/

@implementation DescriptCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLabel.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:40];
        self.priceLabel.textColor = [UIColor whiteColor];
        self.priceLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.addrLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.addrLabel.textColor = [UIColor whiteColor];
        self.addrLabel.backgroundColor = [UIColor clearColor];
        self.addrLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.descriptAndSize = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descriptAndSize.textColor = [UIColor whiteColor];
        self.descriptAndSize.backgroundColor = [UIColor clearColor];
        self.descriptAndSize.translatesAutoresizingMaskIntoConstraints = false;
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.detailButton setTitle:@"More Info" forState:UIControlStateNormal];
        self.detailButton.titleLabel.font = [UIFont fontWithName:@"Courier" size:17.0f];
        self.detailButton.translatesAutoresizingMaskIntoConstraints = false;
        [self.detailButton addTarget:self action:@selector(toDetailClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundView = self.backImageView;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:blur];
    effect.frame = self.backgroundView.frame;
    [self.backgroundView addSubview:effect];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.addrLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptAndSize.textAlignment = NSTextAlignmentCenter;
    self.detailButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.detailButton.layer.borderWidth = 2;
    self.detailButton.layer.cornerRadius = 4;
    self.detailButton.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.addrLabel];
    [self.contentView addSubview:self.descriptAndSize];
    [self.contentView addSubview:self.detailButton];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[v0]-8-[v1]-8-[v2]-10-[v3]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"v0":self.priceLabel, @"v1" : self.addrLabel, @"v2": self.descriptAndSize, @"v3": self.detailButton}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.priceLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.descriptAndSize attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.addrLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.detailButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.detailButton addConstraint:[NSLayoutConstraint constraintWithItem:self.detailButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:self.contentView.bounds.size.width / 3]];
}

- (void)toDetailClicked:(UIButton *)sender{
    //TODO to detail view Controller;
    assert(NO);
}

@end

/************************************************************************************************/

@interface FavouriteCell()

@property(nonatomic)BOOL isDownloaded;
@property(strong, nonatomic)UIImage *propIMG;

@end

@implementation FavouriteCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setupViews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self addSubview:self.collection];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[v0]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"v0":self.collection}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[v0]|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"v0":self.collection}]];
    self.collection.backgroundColor = [UIColor colorWithRed:(CGFloat)(252.0/255) green:(CGFloat)(67.0/255) blue:(CGFloat)(117.0/255) alpha:1.0f];
    self.isDownloaded = false;

}

#pragma mark - Private Methods

- (void)setupViews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collection.pagingEnabled = true;
    self.collection.showsHorizontalScrollIndicator = false;
    self.collection.dataSource = self;
    self.collection.delegate = self;
    self.collection.translatesAutoresizingMaskIntoConstraints = false;
    [self.collection registerClass:[ThumbnailCell class] forCellWithReuseIdentifier:@"thumbnailCell"];
    [self.collection registerClass:[DescriptCell class] forCellWithReuseIdentifier:@"DescriptCell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.item == 0){
        ThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thumbnailCell" forIndexPath:indexPath];
        if(self.property != nil){
            cell.priceLabel.text = [NSString stringWithFormat:@"$%@", self.property.propertyCost];
            cell.property = self.property;
            cell.typeLabel.text = self.property.propertyType;
            if(!self.isDownloaded){
                NSString *rawUrl = [self.property.propertyImage1 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                NSString *finalUrl = [NSString stringWithFormat:@"http://%@", rawUrl];
                [[PLNetworking manager] sendGETRequestToURL:finalUrl parameters:@{} success:^(NSData *data, NSInteger status) {
                    if(status == 200){
                        self.propIMG = [UIImage imageWithData:data];
                        cell.thumbnail.image = self.propIMG;
                        self.isDownloaded = true;
                    }else{
                        NSLog(@"internet error: %lu", status);
                    }
                } failed:^(NSError *error) {
                    NSLog(@"Image download error: %@", error);
                }];
            }
        }else{
            cell.thumbnail.image = [UIImage imageNamed:@"placeholder"];
        }
        return cell;
    }
    DescriptCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"DescriptCell" forIndexPath:indexPath];
    if(self.property != nil){
        cell.priceLabel.text = [NSString stringWithFormat:@"$%@", self.property.propertyCost];
        cell.addrLabel.text = [NSString stringWithFormat:@"%@, %@", self.property.propertyAdd1, self.property.propertyadd2];
        cell.descriptAndSize.text = [NSString stringWithFormat:@"Descrition: %@ / Size: %@ sqft", self.property.propertyDesc, self.property.propertySize];
        cell.property = self.property;
        if(!self.isDownloaded){
            NSString *imgUrl = self.property.propertyImage1;
            [[PLNetworking manager] sendGETRequestToURL:imgUrl parameters:@{} success:^(NSData *data, NSInteger status) {
                if(status == 200){
                    self.propIMG = [UIImage imageWithData:data];
                    cell.backImageView.image = self.propIMG;
                    self.isDownloaded = true;
                }else{
                    NSLog(@"internet error: %lu", status);
                }
            } failed:^(NSError *error) {
                NSLog(@"Image download error: %@", error);
            }];
        }else{
            cell.backImageView.image = self.propIMG;
        }
    }else{
        cell.backImageView.image = [UIImage imageNamed:@"placeholder"];
    }
    return cell;
    
}

#pragma mark - UICollectionViewFlowlayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

@end





