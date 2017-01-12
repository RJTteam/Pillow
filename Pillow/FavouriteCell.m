//
//  FavouriteCell.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "FavouriteCell.h"

@interface ThumbnailCell : UICollectionViewCell

@property(strong, nonatomic)UIImageView *thumbnail;
@property(strong, nonatomic)UILabel *priceLabel;

@end

@implementation ThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.thumbnail.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.thumbnail.image = [UIImage imageNamed:@"placeholder"];
    self.priceLabel.text = @"$300000.00";
    self.priceLabel.textColor = [UIColor whiteColor];
    self.priceLabel.font = [UIFont fontWithName:@"Courier" size:36.0f];
    self.backgroundView = self.thumbnail;
    [self.contentView addSubview:self.priceLabel];
    
    NSString *hformat = [NSString stringWithFormat:@"H:|-5-[v0]-%.2f-|", self.bounds.size.width / 3];
    NSString *vformat = [NSString stringWithFormat:@"V:|-%.2f-[v0]|", self.bounds.size.height * 2 / 3];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:hformat options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"v0":self.priceLabel}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vformat options:NSLayoutFormatDirectionLeftToRight metrics:nil views:@{@"v0":self.priceLabel}]];
}

@end

@interface DescriptCell : UICollectionViewCell

@property(strong, nonatomic)UIImageView *backImageView;
@property(strong, nonatomic)UILabel *priceLabel;
@property(strong, nonatomic)UILabel *addrLabel;
@property(strong, nonatomic)UILabel *descriptAndSize;
@property(strong, nonatomic)UIButton *detailButton;


@end

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
        self.detailButton.translatesAutoresizingMaskIntoConstraints = false;
        [self.detailButton addTarget:self action:@selector(toDetailClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundView = self.backImageView;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effect = [[UIVisualEffectView alloc] initWithEffect:blur];
    [self insertSubview:effect aboveSubview:self.backgroundView];
    self.priceLabel.text = @"$300000.00";
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    self.addrLabel.text = @"2056 Wessel Ct, St Charles, IL, 60174";
    self.addrLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptAndSize.text = @"Good Place to live * 5000sqft";
    self.descriptAndSize.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.addrLabel];
    [self.contentView addSubview:self.descriptAndSize];
    [self.contentView addSubview:self.detailButton];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[v0]-8-[v1]-8-[v2]-10-[v3]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"v0":self.priceLabel, @"v1" : self.addrLabel, @"v2": self.descriptAndSize, @"v3": self.detailButton}]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.priceLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.descriptAndSize attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.addrLabel attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.detailButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void)toDetailClicked{
    //TODO to detail view Controller;
    assert(NO);
}

@end

/************************************************************************************************/

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
    self.collection.backgroundColor = [UIColor blackColor];

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
        return cell;
    }
    DescriptCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"DescriptCell" forIndexPath:indexPath];
    cell.backImageView.image = [UIImage imageNamed:@"placeholder"];
    return cell;
    
}

#pragma mark - UICollectionViewFlowlayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

@end





