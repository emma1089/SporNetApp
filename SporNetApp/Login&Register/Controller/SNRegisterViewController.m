//
//  SNRegisterViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/5.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNRegisterViewController.h"

@interface SNRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwTextfield;

@end

@implementation SNRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _emailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your school email" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    _confirmPwTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"confirm your password" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//method for tip button
- (IBAction)tipClick {

    UIAlertView *tip = [[UIAlertView alloc]initWithTitle:@"Tip !" message:@"Please use your school email !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [tip show];

}

//method for submit
- (IBAction)submitClick {

    BOOL *validE = [self validateEmail:_emailTextfield.text];
//    NSLog(@"%@",validE?@"YES":@"NO");  //打印邮箱的BOOL值
    
    if (_emailTextfield.text.length != 0 && _passwordTextfield.text.length != 0 && _confirmPwTextfield.text.length !=0) {
        if (validE) {
            //判断edu方法待研究
            if (YES) {
                //是否合后台已有用户帐号重合待研究
                if (_emailTextfield.text != @"yang@gmail.com") {
                    if (_passwordTextfield.text == _confirmPwTextfield.text) {
                        NSLog(@"Save in background");//调用存储用户方法
                        [self back];
                        UIAlertView *finishAlert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:@"Your information have been saved !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [finishAlert show];
                    } else {
                        UIAlertView *unmatchAlert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:@"Your password didn't match !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [unmatchAlert show];
                    }
                } else {
                    UIAlertView *existingAlert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:@"This user already exist !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [existingAlert show];
                }
            } else {
                //使用edu邮箱
            }
        } else {
            UIAlertView *emailVAlert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:@"Please use your school email !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [emailVAlert show];
        }
    } else {
        UIAlertView *infoAlert = [[UIAlertView alloc]initWithTitle:@"Alert !" message:@"Please fill out all information !" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [infoAlert show];
    }
}

/**
 *  Email validation
 *
 *  @param email input email
 *
 *  @return Yes if Email is validation
 */
- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@,%@",NSStringFromRange(range),string);
    return YES;
}

@end