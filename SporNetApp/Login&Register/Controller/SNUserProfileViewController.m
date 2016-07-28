//
//  SNUserProfileViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 6/29/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//
#import "SNUser.h"
#import "SNUserProfileViewController.h"
#import <AVObject+Subclass.h>

#define PROFILE_IMAGE [UIImage imageNamed:@"profile"]
#define ADD_IMAGE [UIImage imageNamed:@"add"]
@interface SNUserProfileViewController ()



@property (strong, nonatomic) IBOutlet UITableView        *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell    *nameCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *genderCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *birthdayCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *graduationCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *bestSportCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *sportTimeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *aboutMeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *picCell;
@property (strong, nonatomic) IBOutlet UITableViewCell    *doneCell;

@property (weak, nonatomic) IBOutlet UILabel *placeHolder;

//These two textfield are used to pop picker view. No use for data.
@property (strong, nonatomic) IBOutlet UITextField        *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField        *lastNameTextField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottonConstraint;
@property (strong, nonatomic) IBOutlet UILabel            *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel            *birthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel            *gradLabel;
@property (weak, nonatomic) IBOutlet UILabel *sportTimeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView       *sexPicker;
@property (strong, nonatomic) IBOutlet UIPickerView       *graduationYearPicker;
@property (strong, nonatomic) IBOutlet UIPickerView       *sportTimePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (strong, nonatomic) IBOutlet UITextField        *sexTextField;
@property (strong, nonatomic) IBOutlet UITextField        *gradTextField;
@property (weak, nonatomic) IBOutlet UITextField *sportTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTextField;
@property (strong, nonatomic) IBOutlet UITextView         *aboutmeTextView;
@property UIImageView *selectedBestSportImageView;
//gender selected by user
@property GenderType selectedGender;
//best sport selected by user
@property(nonatomic) BestSports selectedBestSport;
//graduation year selected by user
@property int selectedGradYear;
//sport time selected by user
@property SportTimeSlot selectedSpotrTime;
//birthday of user selected
@property NSDate* selectedBirthday;
//profile images selected by user
@property NSMutableArray *selectedProfileImageArray;

@property (weak, nonatomic  ) UIPickerView                *birthdayPiker;

//image picker controller
@property(nonatomic) UIImagePickerController *imagePicker;
//alert controller
@property(nonatomic) UIAlertController *alert;
@end

@implementation SNUserProfileViewController
//select options of gradYears
NSArray *gradYears;
//select options for gender
NSArray *genderArray;
//select options for sport time
NSArray *sportTime;

NSArray *bestSportsPicArray;
NSArray *bestSportsPicArraySelected;
NSInteger selectedImageTag;

- (void)viewDidLoad {
    [super viewDidLoad];
    //set delegates
    self.sexPicker.delegate = self;
    self.sexPicker.dataSource = self;
    self.graduationYearPicker.delegate = self;
    self.graduationYearPicker.dataSource = self;
    self.sportTimePicker.delegate = self;
    self.sportTimePicker.dataSource = self;
    self.aboutmeTextView.delegate = self;
    [self.birthdayPicker addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    //set constant arrays
    gradYears = @[@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021"];
    genderArray = @[@"Male", @"Female"];
    sportTime = @[@"Morning",@"Noon",@"Afternoon",@"Evening"];
    bestSportsPicArray = @[@"jogging", @"muscle", @"soccer", @"basketball", @"yoga"];
    bestSportsPicArraySelected = @[@"joggingSelected", @"muscleSelected", @"soccerSelected", @"basketballSelected", @"yogaSelected"];

    //set pickers as input views of textfields.
    self.sexTextField.inputView = self.sexPicker;
    self.gradTextField.inputView = self.graduationYearPicker;
    self.sportTimeTextField.inputView = self.sportTimePicker;
    self.birthdayTextField.inputView = self.birthdayPicker;
    self.lastNameTextField.adjustsFontSizeToFitWidth = YES;
    self.lastNameTextField.minimumFontSize = 8;
    //add tap gestures to 5 sport images.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    for(int i = 1; i <= 5; i++) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sportTapped:)];
        UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:i];
        [imageView addGestureRecognizer:tapRecognizer];
    }
    self.selectedProfileImageArray = [[NSMutableArray alloc]initWithCapacity:6];
}
#pragma mark - Table view delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return UserProfileRowNumber;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (indexPath.row) {
        case UserProfileRowName:
            height = 80;
            break;
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
            [self.sexTextField becomeFirstResponder];
            break;
        case UserProfileRowBirthday:
            NSLog(@"select birthday");
            [self.birthdayTextField becomeFirstResponder];
            break;
        case UserProfileRowGraduation:
            NSLog(@"Select graduation");
            [self.gradTextField becomeFirstResponder];
            break;
        case UserProfileRowBestSport:
            NSLog(@"Select best sport");
            break;
        case UserProfileRowSportTime:
            NSLog(@"select sport time");
            [self.sportTimeTextField becomeFirstResponder];
            [self pickerViewWillShow];
            break;
        case  UserProfileRowDone:
            NSLog(@"save action");
            [self demoCreateObject];
            break;
            //[self saveData];
        default:
            break;
    }
}
//dismiss keyboard with animation
-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = 0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
#pragma mark - Picker view delegate & datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        return 2;
    } else if([pickerView isEqual:self.graduationYearPicker]){
        return gradYears.count;
    } else{
        return sportTime.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if([pickerView isEqual:self.sexPicker]) {
        return genderArray[row];
    } else if([pickerView isEqual:self.graduationYearPicker]){
        return gradYears[row];
    }else{
        return sportTime[row];
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if([pickerView isEqual:self.sexPicker]) {
        self.sexLabel.text = genderArray[row];
        self.selectedGender = (GenderType)row;
    } else if([pickerView isEqual:self.graduationYearPicker]){
        self.gradLabel.text = gradYears[row];
        self.selectedGradYear = [self.gradLabel.text intValue];
    }else{
        self.sportTimeLabel.text = sportTime[row];
        self.selectedSpotrTime = (SportTimeSlot)row;
    }
}


#pragma mark - Scroll view delegate.
//dismiss keyboard when the table view start scrolling
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        [self dismissKeyboard];
    }
}


//When the best sport image is tapped, reset that image.
- (void)sportTapped:(UITapGestureRecognizer *)tapGesture {
    UIImageView *image = (UIImageView*)tapGesture.view;
    self.selectedBestSport = (BestSports)image.tag;
}

-(void)pickerViewWillShow{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = [self.sportTimeTextField isFirstResponder]? 150:0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

#pragma mark - move about me textview with animation when keyboard popping up.
- (void)keyboardWillChange:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    self.bottonConstraint.constant = [self.aboutmeTextView isFirstResponder]? keyboardSize.height:0;
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
//save user information
- (void)demoCreateObject {
    //更新的时候，得把NSInteger值转为NSNumber
    //AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:@"5776986f5e10720046e19002"];
    
    [AVUser logInWithUsername:@"zheng.yang2@husky.neu.edu" password:@"123456" error:nil];
    AVQuery *query = [SNUser query];
    //选取当前登陆用户的所有记录
    [query whereKey:@"userID" equalTo:[AVUser currentUser].objectId];
    //[query includeKey:@"photoes"];
    NSArray *fetchedPrayers = [query findObjects];
    SNUser *user;
    if(fetchedPrayers.count) user = fetchedPrayers[0];
    else user = [[SNUser alloc]init];
//    AVObject *user = [AVObject objectWithClassName:@"SNUser" objectId:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    
    [user setObject:[NSString stringWithFormat:@"%@ %@", self.firstNameTextField.text, self.lastNameTextField.text] forKey:@"name"];
    [user setObject:[NSNumber numberWithInteger:self.selectedGradYear] forKey:@"gradYear"];
    [user setObject:[NSNumber numberWithInt:self.selectedGender] forKey:@"gender"];
    [user setObject:[NSNumber numberWithInteger:self.selectedBestSport] forKey:@"bestSport"];
    [user setObject:[NSNumber numberWithInteger:SportTimeSlotNight] forKey:@"sportTimeSlot"];
    [user setObject:self.aboutmeTextView.text forKey:@"aboutMe"];
    [user setObject:[AVUser currentUser].objectId forKey:@"userID"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"存储成功哈哈哈");
        } else {
            NSLog(@"存储失败");
        }
    }];
}

-(void)dateSelected:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    self.birthdayLabel.text = [dateFormatter stringFromDate:date];
}
- (IBAction)picButtonClicked:(UIButton *)sender {
    selectedImageTag = sender.tag;
    if(!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
    }
    if([sender.currentBackgroundImage isEqual:PROFILE_IMAGE] | [sender.currentBackgroundImage isEqual:ADD_IMAGE]) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        [self presentViewController:_imagePicker animated:true completion:nil];
    } else {
        [self presentViewController:self.alert animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIButton *selectedButton = (UIButton*)[self.picCell viewWithTag:selectedImageTag];
    [selectedButton setBackgroundImage:chosenImage forState:normal];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
/**
 *  initiate action sheet for when there are photos in picCell.
 *
 *  @return alert
 */
-(UIAlertController*)alert {
    if(_alert == nil) {
        _alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Change Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UIButton *selectedButton = (UIButton*)[self.picCell viewWithTag:selectedImageTag];
            if(selectedImageTag == 1) {
                [selectedButton setBackgroundImage:PROFILE_IMAGE forState:normal];
            } else {
                [selectedButton setBackgroundImage:ADD_IMAGE forState:normal];
            }
        }]];
        [_alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];
    }
    return _alert;
}
-(void)setSelectedBestSport:(BestSports)selectedBestSport {
    if(!_selectedBestSportImageView){
        _selectedBestSportImageView = [[UIImageView alloc]init];
        [self.bestSportCell addSubview:_selectedBestSportImageView];
    }
    _selectedBestSport = selectedBestSport;
    UIImageView *imageView = (UIImageView*)[self.bestSportCell viewWithTag:selectedBestSport];
    _selectedBestSportImageView.frame = CGRectMake(imageView.frame.origin.x - 5, imageView.frame.origin.y - 5, imageView.frame.size.width + 10, imageView.frame.size.height + 10);
    _selectedBestSportImageView.image = [UIImage imageNamed: bestSportsPicArraySelected[selectedBestSport-1]];
}
-(void)textViewDidChange:(UITextView *)textView {
    if([textView.text isEqual:@""]) {
        _placeHolder.hidden = NO;
    } else {
        _placeHolder.hidden = YES;
    }
}
@end
