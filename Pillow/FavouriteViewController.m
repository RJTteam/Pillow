//
//  FavourateViewController.m
//  Pillow
//
//  Created by Xinyuan Wang on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "FavouriteViewController.h"
#import "FavouriteCell.h"
#import "FavouriteList.h"

@interface FavouriteViewController ()<UICollectionViewDelegateFlowLayout>


@end


@implementation FavouriteViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[FavouriteCell class] forCellWithReuseIdentifier:@"favCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[FavouriteList sharedInstance] saveToLocalForUser:[NSString stringWithFormat:@"%lu", self.userid]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return [FavouriteList sharedInstance].favList.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FavouriteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"favCell" forIndexPath:indexPath];
    [[FavouriteList sharedInstance] getPropertyAtIndex:indexPath.item success:^(Property *property) {
        cell.property = property;
        [cell.collection reloadData];
    } failure:^(NSString *errorMessage) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:true completion:nil];
    }];
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




