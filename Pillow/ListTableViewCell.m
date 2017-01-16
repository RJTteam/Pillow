//
//  ListTableViewCell.m
//  
//
//  Created by Yangbin on 1/11/17.
//
//

#import "ListTableViewCell.h"

@implementation ListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    //ShowPropertyViewController* spvc = [[ShowPropertyViewController alloc]init];
    
    
}

//- (IBAction)addToFavirate:(UIButton *)sender {
//    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Successfully Operation" message:@"this property has been added to your favirate list" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:nil];
//    
//}


@end
