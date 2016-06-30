//
//  SNUserProfileViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 6/29/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNUserProfileViewController.h"
#import <AVObject+Subclass.h>
@interface SNUserProfileViewController ()
@property (strong, nonatomic) IBOutlet UITableView     *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *genderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *graduationCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *bestSportCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *sportTimeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *aboutMeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *picCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *doneCell;

@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;

@property (strong, nonatomic) IBOutlet UILabel *gradLabel;

@property (strong, nonatomic) IBOutlet UIPickerView *sexPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *graduationYearPicker;
@property(weak, nonatomic) UIPickerView *birthdayPiker;

@property (strong, nonatomic) IBOutlet UITextField *sexTextField;

@property (strong, nonatomic) IBOutlet UITextField *gradTextField;

@property NSArray *gradYears;
@property NSArray *sex;
@end

@implementation SNUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.graduationYearPicker.delegate = self;
    self.graduationYearPicker.dataSource = self;
    self.gradYears = @[@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021"];
    self.sex = @[@"Male", @"Female"];
    self.sexTextField.inputView = self.sexPicker;

    self.gradTextField.inputView = self.graduationYearPicker;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UserProfileRowNumber;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (indexPath.row) {
        case UserProfileRowPic:
            height = 200;
            break;
        case UserProfileRowBestSport:
            height = 80;
            break;

        case UserProfileRowAboutMe:
            height = 100;
            break;
        default:
            height = 55;
            break;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    switch (indexPath.row) {
        case UserProfileRowPic:
            cell = self.picCell;
            break;
        case UserProfileRowName:
            cell = self.nameCell;
            break;
        case UserProfileRowGender:
            cell = self.genderCell;
            break;
        case UserProfileRowBirthday:
            cell = self.birthdayCell;
            break;
        case  UserProfileRowGraduation:
            cell = self.graduationCell;
            break;
        case UserProfileRowBestSport:
            cell = self.bestSportCell;
            break;
        case  UserProfileRowSportTime:
            cell = self.sportTimeCell;
            break;
        case UserProfileRowAboutMe:
            cell = self.aboutMeCell;
            break;
        case UserProfileRowDone:
            cell = self.doneCell;
            break;
        default:
            cell = nil;
            break;
    }
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    switch (indexPath.row) {
        case UserProfileRowGender:
            NSLog(@"select gender");
            //[self.view addSubview:self.sexPicker];
            [self.sexTextField becomeFirstResponder];
            break;
        case UserProfileRowBirthday:
            NSLog(@"select birthday");
            break;
        case UserProfileRowGraduation:
            NSLog(@"Select graduation");
            [self.gradTextField becomeFirstResponder];
            break;
        case UserProfileRowSportTime:
            NSLog(@"select sport time");
            break;
        case  UserProfileRowDone:
            NSLog(@"save action");
            [self saveData];
        default:
            break;
    }
}
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        return 2;
    } else {
        return self.gradYears.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:self.sexPicker]) {
        return self.sex[row];
    } else {
        return self.gradYears[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        self.sexLabel.text = self.sex[row];
    } else {
        self.gradLabel.text = self.gradYears[row];
    }
}

-(void)saveData {
    AVObject *user1 = [AVObject objectWithClassName:@"User"];
    [user1 setObject:@"Emma" forKey:@"name"];
    [user1 setObject:@"Female" forKey:@"gender"];
    [user1 setObject:@"gradYear" forKey:@"2016"];
    [user1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"存储成功");
        } else {
            NSLog(@"存储失败");
        }
    }];
}
@end