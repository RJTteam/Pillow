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
#import "User.h"
#import "Contants.h"
#import "FavouriteList.h"


@interface SignInViewController ()<UITextFieldDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property(strong, nonatomic)UISegmentedControl *buyerVSseller;

@property (nonatomic)BOOL isBuyer;
@property (nonatomic)CGFloat moveOffset;
@property (nonatomic)BOOL keyboardShown;

@end

@implementation SignInViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBuyer = YES;
    UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(skipSignInClicked)];
    self.navigationItem.rightBarButtonItem = skipButton;
    [GIDSignIn sharedInstance].uiDelegate = self;

    self.signInButton.style = kGIDSignInButtonStyleIconOnly;
    self.signInButton.colorScheme = kGIDSignInButtonColorSchemeDark;
    NSArray *itemArray = [NSArray arrayWithObjects: @"Buyer", @"Seller", nil];
    self.buyerVSseller = [[UISegmentedControl alloc]initWithItems:itemArray];
    _buyerVSseller.frame = CGRectMake(128, 198, 121, 28);
    [_buyerVSseller addTarget:self action:@selector(buyerVSsellerAction:) forControlEvents: UIControlEventValueChanged];
    [self.view insertSubview:self.buyerVSseller aboveSubview:_emailTxtFld];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.moveOffset = self.view.bounds.size.height - self.forgetPwdButton.frame.origin.y - self.forgetPwdButton.frame.size.height - 10;
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefault objectForKey:userKey];
    if(dict){
        self.emailTxtFld.text = dict[emailKey];
        self.pwdTxtFld.text = dict[passwordKey];
        self.isBuyer = [dict[usertypeKey] isEqualToString:buyerContent];
    }else{
        self.emailTxtFld.text = @"";
        self.pwdTxtFld.text = @"";
        self.isBuyer = true;
    }
    [self setSegmentStatus];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Even Method

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGSize keysize =  [value CGRectValue].size;
    CGFloat keyboardHeight = keysize.height;
    CGFloat finalOffset = keyboardHeight - self.moveOffset;
    if(!self.keyboardShown){
        self.keyboardShown = true;
        self.view.frame = CGRectMake(0, -finalOffset, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGSize keysize =  [value CGRectValue].size;
    CGFloat keyboardHeight = keysize.height;
    CGFloat finalOffset = keyboardHeight - self.moveOffset;
    if(self.keyboardShown){
        self.keyboardShown = false;
        self.view.frame = CGRectMake(0, self.view.frame.origin.y + finalOffset, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (void)buyerVSsellerAction:(UISegmentedControl *)segment{
    if(segment.selectedSegmentIndex == 0)
    {
        //Sign in as Buyer
        [UIView animateWithDuration:0.5 delay:0.2f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.backgroundImage.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.backgroundImage.image = [UIImage imageNamed:@"signInBuyerBack.jpg"];
            self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
            [UIView animateWithDuration:0.5f delay:0.2f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.backgroundImage.alpha = 1.0f;
            } completion:nil];
        }];
        self.isBuyer = true;
    }
    else{
        //Sign in as Seller
         [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.backgroundImage.alpha = 0.0f;
        } completion:^(BOOL finished) {
            self.backgroundImage.image = [UIImage imageNamed:@"signInSellerBack.jpg"];
            self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
            [UIView animateWithDuration:0.5f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.backgroundImage.alpha = 1.0f;
            } completion:nil];
        }];
        self.isBuyer = false;
    }
}

- (void)skipSignInClicked{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userKey];
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self presentViewController:home animated:YES completion:nil];
}

- (IBAction)signInButtonClicked:(UIButton *)sender {
    BOOL validEmail = [self validateEmailText:self.emailTxtFld.text];
    BOOL validPwd = [self validatePWD:self.pwdTxtFld.text];
    if(!validEmail){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please input a valid email" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else if(!validPwd){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Password must be 6 ~ 12 characters!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSDictionary *dict = @{
                               emailKey : self.emailTxtFld.text,
                               passwordKey : self.pwdTxtFld.text,
                               usertypeKey : self.isBuyer ? buyerContent : sellerContent
                               };
        [User userLoginWithParameters:dict success:^(User *user) {
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:[user dictPresentation] forKey:userKey];
            HomeViewController* hvc = [[HomeViewController alloc]init];
            if([user.usertype isEqualToString:buyerContent]){
                [[FavouriteList sharedInstance] loadFavListForUser:[NSString stringWithFormat:@"%lu", user.userid]];
            }
            [self presentViewController:hvc animated:YES completion:nil];
        } faliure:^(NSString *errorMessage) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}


- (IBAction)signUpButtonClicked:(UIButton *)sender {
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

- (void)setSegmentStatus{
    if(self.isBuyer){
        self.buyerVSseller.selectedSegmentIndex = 0;
    }else{
        self.buyerVSseller.selectedSegmentIndex = 1;
    }
}

- (BOOL)validateEmailText:(NSString *)text{
    if(text.length == 0){
        return false;
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\\w\\d]+@[\\w\\d]+\\.[\\w\\d]+$"];
    return [predicate evaluateWithObject:text];
}

- (BOOL)validatePWD:(NSString *)text{
    BOOL result = text.length >= 6 && text.length <= 12;
    return result;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - GIDSignInUIDelegate

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
