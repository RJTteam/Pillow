//
//  SignUpViewController.m
//  RentalApt
//
//  Created by Xinyuan Wang on 1/10/17.
//  Copyright © 2017 AlexW. All rights reserved.
//

#import "SignInViewController.h"
#import "SignupViewController.h"
#import "ForgetPwdViewController.h"
#import "HomeViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtFld;

@end

@implementation SignInViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Even Method

- (IBAction)signInButtonClicked:(UIButton *)sender {
    BOOL validEmail = [self validateEmailText:self.emailTxtFld.text];
    BOOL validPwd = [self validatePWD:self.pwdTxtFld.text];
    if(!validEmail || !validPwd){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Not Valid Email or password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        //TODO jump to home view, set current user to the login user
        HomeViewController* hvc = [[HomeViewController alloc]init];
        [self presentViewController:hvc animated:YES completion:nil];
        NSLog(@"Login success");
    }
}

- (IBAction)signUpButtonClicked:(UIButton *)sender {
    //TODO jump to signUpViewController
    SignUpViewController *signupVC = [[SignUpViewController alloc] initWithNibName:@"SignUpView" bundle:nil];
    [self.navigationController pushViewController:signupVC animated:YES];
    
}

- (IBAction)forgetPwdButtonClicked {
    ForgetPwdViewController *vc = [[ForgetPwdViewController alloc] initWithNibName:@"ForgetPwdView" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)googleClicked {
    //TODO jump to google login service
    assert(NO);
}
#pragma mark - Private Method

- (BOOL)validateEmailText:(NSString *)text{
    if(text.length == 0){
        return false;
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\\w\\d]+@[\\w\\d]+\\.[\\w\\d]+$"];
    return [predicate evaluateWithObject:text];
}

- (BOOL)validatePWD:(NSString *)text{
    return text.length >= 8;
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
