//
//  FavouriteCell.h
//  Pillow
//
//  Created by Xinyuan Wang on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteCell :UICollectionViewCell<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property(strong, nonatomic)UICollectionView *collection;

@end
