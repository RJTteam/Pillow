//
//  ForgetPwdViewController.m
//  RantalApt
//
//  Created by Xinyuan Wang on 1/10/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "ForgetPwdViewController.h"

@interface ForgetPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButtonClicked;

@end

@implementation ForgetPwdViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Method

- (IBAction)sendEmailButtonClicked:(UIButton *)sender {
    BOOL validEmail = [self validateEmailText:self.emailTxtFld.text];
    if(!validEmail){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Not Valid Username or Email or password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //TODO send reset password request and email to server;
        assert(NO);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Private Method

- (BOOL)validateEmailText:(NSString *)text{
    if(text.length == 0){
        return false;
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\\w\\d]+@[\\w\\d]+\\.[\\w\\d]+$"];
    return [predicate evaluateWithObject:text];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
