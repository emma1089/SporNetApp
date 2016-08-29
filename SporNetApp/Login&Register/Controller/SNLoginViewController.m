//
//  SNLoginViewController.m
//  SporNetApp
//
//  Created by ZhengYang on 16/7/11.
//  Copyright © 2016年 Peng Wang. All rights reserved.
//

#import "SNLoginViewController.h"
#import "SNRegisterViewController.h"
#import "SNFpDreViewController.h"
#import "ProgressHUD.h"
#import "AVUser.h"
#import "AVFile.h"
#import "SNMainFeatureTabController.h"
#import "LocalDataManager.h"
@interface SNLoginViewController ()<UITextFieldDelegate>
/**
 *  User Email Input
 */
@property (weak, nonatomic) IBOutlet UITextField *userEmailTextfield;
/**
 *  User Password Input
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
/**
 *  Autolayout Constraint
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstrainatBottom;



@end

@implementation SNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set NavigationBar Hidden
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //Set Up UI
    [self setUpAllUI];
    
    //Set Up Notification Center
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

}

#pragma marks - Init UI

- (void)setUpAllUI {
    
    _userEmailTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your school email" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    _passwordTextfield.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"your password" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//method for login button
- (IBAction)login:(id)sender {
    if([_userEmailTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"Please input username!"];
    } else if([_passwordTextfield.text isEqual:@""]) {
        [ProgressHUD showError:@"Please input password!"];
    } else {
        [ProgressHUD show:@"Logging now..."];
        [AVUser logInWithUsernameInBackground:_userEmailTextfield.text password:_passwordTextfield.text block:^(AVUser *user, NSError *error) {
            if(error.code == 211)  {
                [ProgressHUD showError:@"Email doesn't exist!"];
            } else if (error.code == 210) {
                [ProgressHUD showError:@"Wrong password!"];
            } else{
#warning 最好不要显示用户名的email
                [ProgressHUD showSuccess:[NSString stringWithFormat:@"Welcome back, %@!", user.username]];
                if([[AVUser currentUser]objectForKey:@"basicInfo"] != nil) {
#warning 需要先判断沙盒是否有值, 如果有值就跳转到Main（可以做一个对比），没有值就在注册的时候存储沙盒
                    [LocalDataManager fetchProfileInfoFromCloud];
                    SNMainFeatureTabController *tabVC = [[SNMainFeatureTabController alloc]init];
                    [self presentViewController:tabVC animated:YES completion:nil];
                } else {
                    [self performSegueWithIdentifier:@"firstTimeLoginSegue" sender:nil];
                }

            }
        }];
    }
}



//method for forget password button
- (IBAction)forgetPassword {
    [self performSegueWithIdentifier:@"fpSegue" sender:nil];
}

//method for dont receive email
- (IBAction)dontRE {
    [self performSegueWithIdentifier:@"dreSegue" sender:nil];
}

//pass the segue condition in next view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    SNFpDreViewController *destination = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"fpSegue"]) {
        destination.isFp = YES;
    } else if([segue.identifier isEqualToString:@"dreSegue"]){
        destination.isFp = NO;
    }
    
}

//method for signup button
- (IBAction)signup:(id)sender {
    NSLog(@"did sign up");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login&RegisterStoryBoard" bundle:nil];
    SNRegisterViewController *regVc = [storyboard instantiateViewControllerWithIdentifier:@"RegisterPage"];
    
    [self.navigationController pushViewController:regVc animated:YES];

    
}

#pragma marks -KeyBoard Show&Hidden

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.inputViewConstrainatBottom.constant = 280;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.inputViewConstrainatBottom.constant = 200;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
