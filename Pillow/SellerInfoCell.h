//
//  SellerInfoCell.h
//  Pillow
//
//  Created by Lucas Luo on 1/16/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end
