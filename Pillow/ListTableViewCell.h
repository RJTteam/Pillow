//
//  ListTableViewCell.h
//  
//
//  Created by Yangbin on 1/11/17.
//
//

#import <UIKit/UIKit.h>
#import "ShowPropertyViewController.h"

@interface ListTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *cellType;
@property (strong, nonatomic) IBOutlet UILabel *cellPrice;
@property (strong, nonatomic) IBOutlet UILabel *cellStatus;
@property (strong, nonatomic) IBOutlet UIButton *addFavirate;

@end
