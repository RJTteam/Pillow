//
//  SignupViewController.m
//  RantalApt
//
//  Created by Xinyuan Wang on 1/10/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#import "SignUpViewController.h"



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

@property (nonatomic)BOOL buyerSelected;
@property (nonatomic)BOOL sellerSelected;
@property (nonatomic)BOOL termSelected;
@property (nonatomic)BOOL allFieldValid;

@end

@implementation SignUpViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *checked = [UIImage imageNamed:@"checked"];
    UIImage *unchecked = [UIImage imageNamed:@"unchecked"];
    self.allFieldValid = true;
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
    [self.signUpButton setEnabled:self.termSelected];
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
    [self.signUpButton setEnabled:self.termSelected && self.allFieldValid];
    
}

- (IBAction)signUpButtonClicked:(UIButton *)sender {
        //TODO validat user info
        //if success, save user info and back to sign in view;
        //if failed, inform the user
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    BOOL valid = YES;
    if(textField == self.dobDateTxtFld){
        valid = [self validateDateOfBirth:textField.text type:DateComponentTypeDate];
    }else if(textField == self.dobMonthTxtFld){
        valid = [self validateDateOfBirth:textField.text type:DateComponentTypeMonth];
    }else if(textField == self.dobYearTxtFld){
        valid = [self validateDateOfBirth:textField.text type:DateComponentTypeYear];
    }else if(textField == self.emailTxtFld){
        valid = [self validateEmailText:textField.text];
    }else if(textField == self.pwdTxtFld){
        valid = [self validatePWD:textField.text];
    }else {
        valid = textField.text.length > 0;
    }
    if(!valid){
        textField.layer.borderColor = [UIColor redColor].CGColor;
        textField.layer.borderWidth = 2.0;
    }else{
        textField.layer.borderColor = [UIColor clearColor].CGColor;
        textField.layer.borderWidth = 0.0;
    }
    self.allFieldValid &= valid;
    [self.signUpButton setEnabled:self.termSelected && self.allFieldValid];
    return true;
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
