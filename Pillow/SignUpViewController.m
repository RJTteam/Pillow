//
//  SignupViewController.m
//  RantalApt
//
//  Created by Xinyuan Wang on 1/10/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"
#import "Contants.h"


@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *buyerCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *sellerCheckButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *pwdTxtFld;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UITextField *dobDateTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *dobMonthTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *dobYearTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *addr1TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *addr2TxtFld;

@property (nonatomic)BOOL buyerSelected;
@property (nonatomic)BOOL sellerSelected;
@property (nonatomic)BOOL termSelected;
@property (nonatomic)BOOL validUsername;
@property (nonatomic)BOOL validDate;
@property (nonatomic)BOOL validMonth;
@property (nonatomic)BOOL validYear;
@property (nonatomic)BOOL validemail;
@property (nonatomic)BOOL validPwd;
@property (nonatomic)BOOL validMobile;


@end

@implementation SignUpViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *checked = [UIImage imageNamed:@"checked"];
    UIImage *unchecked = [UIImage imageNamed:@"unchecked"];
    
    //set buyer's checker
    [self.buyerCheckButton setBackgroundImage:unchecked forState:UIControlStateNormal];
    [self.buyerCheckButton setBackgroundImage:checked forState:UIControlStateSelected];
    [self.buyerCheckButton setSelected:true];
    self.buyerSelected = true;
    //set seller's checker
    [self.sellerCheckButton setBackgroundImage:unchecked forState:UIControlStateNormal];
    [self.sellerCheckButton setBackgroundImage:checked forState:UIControlStateSelected];
    [self.sellerCheckButton setSelected:false];
    self.sellerSelected = !self.buyerSelected;
    //set terms of service checker
    [self.termsButton setBackgroundImage:unchecked forState:UIControlStateNormal];
    [self.termsButton setBackgroundImage:checked forState:UIControlStateSelected];
    self.termSelected = false;
    [self.termsButton setSelected:self.termSelected];
    //set register button status
    BOOL allValid = self.validUsername && self.validPwd && self.validemail && self.validYear && self.validMonth && self.validDate && self.validMobile;
    [self.signUpButton setEnabled:self.termSelected && allValid];
    [self.signUpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Method
- (IBAction)backToSignInClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyerCheckClicked:(UIButton *)sender {
    if(self.buyerSelected){
        [self.buyerCheckButton setSelected:!self.buyerSelected];
    }else{
        self.sellerSelected = self.buyerSelected;
        [self.sellerCheckButton setSelected:self.sellerSelected];
        [self.buyerCheckButton setSelected:!self.buyerSelected];
    }
    self.buyerSelected = !self.buyerSelected;
}

- (IBAction)sellerCheckClicked:(UIButton *)sender {
    if(self.sellerSelected){
        [self.sellerCheckButton setSelected:!self.sellerSelected];
    }else{
        self.buyerSelected= self.sellerSelected;
        [self.buyerCheckButton setSelected:self.buyerSelected];
        [self.sellerCheckButton setSelected:!self.sellerSelected];
    }
    self.sellerSelected = !self.sellerSelected;
}
- (IBAction)termsCheckClicked:(UIButton *)sender {
    self.termSelected = !self.termSelected;
    [sender setSelected:self.termSelected];
    BOOL allValid = self.validUsername && self.validPwd && self.validemail && self.validYear && self.validMonth && self.validDate && self.validMobile;
    [self.signUpButton setEnabled:self.termSelected && allValid];
    
}

- (IBAction)signUpButtonClicked:(UIButton *)sender {
    if(self.validUsername && self.validPwd && self.validemail && self.validDate && self.validMonth && self.validYear && self.validMobile){
        NSString *dobString = [self formatDob:self.dobDateTxtFld.text.integerValue month:self.dobMonthTxtFld.text.integerValue year:self.dobYearTxtFld.text.integerValue];
        NSDictionary *dict = @{
                               usernameKey:self.usernameTxtFld.text,
                               passwordKey:self.pwdTxtFld.text,
                               emailKey:self.emailTxtFld.text,
                               mobileKey : self.mobileTextField.text,
                               dobKey : dobString,
                               usertypeKey:self.buyerSelected? @"buyer" : @"seller",
                               address1Key: self.addr1TxtFld.text.length != 0 ? self.addr1TxtFld.text : @"addressLine1",
                               address2Key: self.addr2TxtFld.text.length != 0 ? self.addr2TxtFld.text : @"addressLine2"
                               };
        [User userSignupWithParameters:dict success:^(User *user, NSInteger status) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[user dictPresentation] forKey:userKey];
            [self.navigationController popViewControllerAnimated:true];
        } faliure:^(NSString *errorMessage) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:true completion:nil];
        }];
    }
}

#pragma mark - Private Methods

- (NSString *)formatDob:(NSInteger)date month:(NSInteger)month year:(NSInteger)year{
    NSString *dateformat = date <= 9 ? @"0%lu" : @"%lu";
    NSString *monthformat = month <= 9 ? @"0%lu" : @"%lu";
    NSString *yearformat = @"%lu";
    NSString *dateString = [NSString stringWithFormat:dateformat, date];
    NSString *monthString = [NSString stringWithFormat:monthformat, month];
    NSString *yearString = [NSString stringWithFormat:yearformat, year];
    NSString *ret = [NSString stringWithFormat:@"%@-%@-%@", dateString, monthString, yearString];
    return  ret;
}

- (BOOL)validateDateOfBirth:(NSString *)text type:(DateComponentType)type{
    BOOL valid = false;
    NSScanner *scanner = [NSScanner scannerWithString:text];
    valid = [scanner scanInteger:nil];
    if(!valid){
        return valid;
    }
    switch (type) {
        case DateComponentTypeDate:
            valid = text.integerValue <= 31;
            break;
        case DateComponentTypeMonth:
            valid = text.integerValue <= 12;
            break;
        case DateComponentTypeYear:
            valid = text.integerValue >= 1900 && text.integerValue < 2017;
            break;
    }
    return valid;
}

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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    BOOL valid = YES;
    if(textField == self.dobDateTxtFld){
        valid = [self validateDateOfBirth:textField.text type:DateComponentTypeDate];
        self.validDate = valid;
    }else if(textField == self.dobMonthTxtFld){
        valid = [self validateDateOfBirth:textField.text type:DateComponentTypeMonth];
        self.validMonth = valid;
    }else if(textField == self.dobYearTxtFld){
        valid = [self validateDateOfBirth:textField.text type:DateComponentTypeYear];
        self.validYear = valid;
    }else if(textField == self.emailTxtFld){
        valid = [self validateEmailText:textField.text];
        self.validemail = valid;
    }else if(textField == self.pwdTxtFld){
        valid = [self validatePWD:textField.text];
        self.validPwd = valid;
    }else if(textField == self.usernameTxtFld){
        valid = textField.text.length > 0;
        self.validUsername = valid;
    }else if(textField == self.mobileTextField){
        valid = self.mobileTextField.text >= 10;
        self.validMobile = valid;
    }
    if(!valid){
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.layer.borderWidth = 2.0;
    }else{
        textField.layer.borderColor = [UIColor clearColor].CGColor;
        textField.layer.borderWidth = 0.0;
    }
    BOOL allValid = self.validUsername && self.validPwd && self.validemail && self.validYear && self.validMonth && self.validDate && self.validMobile;
    [self.signUpButton setEnabled:self.termSelected && allValid];
    return true;
}

@end
