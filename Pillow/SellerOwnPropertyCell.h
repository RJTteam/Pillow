//
//  SellerOwnPropertyCell.h
//  Pillow
//
//  Created by Lucas Luo on 1/11/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerOwnPropertyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *propertyImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIView *propertyView;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *zoomButton;

@end
