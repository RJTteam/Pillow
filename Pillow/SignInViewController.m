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
#import "BuyerProfileViewController.h"
#import "SellerProfileVC.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtFld;
@property (nonatomic)BOOL isBuyer;

@end

@implementation SignInViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(skipSignInClicked)];
    self.navigationItem.rightBarButtonItem = skipButton;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Buyer", @"Seller", nil];
    UISegmentedControl *buyerVSseller = [[UISegmentedControl alloc]initWithItems:itemArray];
    buyerVSseller.frame = CGRectMake(128, 198, 121, 28);
    [buyerVSseller addTarget:self action:@selector(buyerVSsellerAction:) forControlEvents: UIControlEventValueChanged];
    buyerVSseller.selectedSegmentIndex = 1;
    
    [self.view insertSubview:buyerVSseller aboveSubview:_emailTxtFld];
}

- (void)buyerVSsellerAction:(UISegmentedControl *)segment{
    if(segment.selectedSegmentIndex == 0)
    {
        //Sign in as Buyer
        self.isBuyer = true;
    }
    else{
        //Sign in as Seller
        self.isBuyer = false;
    }
}

#pragma mark - Even Method

- (void)skipSignInClicked{
    //TODO Go to Home view directly without Sign in or sign up
    assert(NO);
}

- (IBAction)signInButtonClicked:(UIButton *)sender {
//    BOOL validEmail = [self validateEmailText:self.emailTxtFld.text];
//    BOOL validPwd = [self validatePWD:self.pwdTxtFld.text];
//    if(!validEmail || !validPwd){
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Not Valid Email or password" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
//    }else{
//
//    }
    HomeViewController* hvc = [[HomeViewController alloc]init];
    //TODO set the logined user 's type here
    [self presentViewController:hvc animated:YES completion:nil];
    NSLog(@"Login success");
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
- (IBAction)facebookClicked {
    //TODO jump to facebook sigin clicked
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
