//
//  FavourateViewController.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteCell.h"

@interface FavouriteViewController ()<UICollectionViewDelegateFlowLayout>

@end


@implementation FavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[FavouriteCell class] forCellWithReuseIdentifier:@"favCell"];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return 4;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FavouriteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"favCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.bounds.size.width, 200);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

#pragma mark - UICollectionViewDelegate

@end




