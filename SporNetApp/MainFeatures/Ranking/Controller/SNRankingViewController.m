//
//  RankingViewController.m
//  SporNetApp
//
//  Created by 浦明晖 on 7/6/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import "SNRankingViewController.h"
#import "rankingCell.h"
#import "SNUser.h"
#import <AVQuery.h>
#import "LocalDataManager.h"
#import "SNSearchNearbyProfileViewController.h"
@interface SNRankingViewController ()

@property (strong, nonatomic) IBOutlet UITableView    *tableView;
@property (strong, nonatomic) IBOutlet UILabel        *titleLabel;
//currently selected sport.
@property (nonatomic        ) enum     BestSports     currentSport;
//mock data of all users.
@property (nonatomic, strong) NSMutableArray        *allUsers;
//users of currently selected sport.
@property (nonatomic, strong) NSMutableArray *currentUsers;
//array of 5 sport images.
@property (nonatomic        ) NSArray        *sportArray;
//array of 5 sport images on selection state.
@property (nonatomic        ) NSArray        *sportArraySelected;
//array of 5 sport titles.
@property (nonatomic        ) NSArray        *titles;
@end

@implementation SNRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //register ranking cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"rankingCell" bundle:nil] forCellReuseIdentifier:@"rankingCell"];

    //initilize current users as nil and current sport as basketball.
    self.currentUsers = [[NSMutableArray alloc]init];
   
}
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    //fetch all users
    self.allUsers = [[LocalDataManager defaultManager]fetchCurrentAllUserInfo];
    //set selected sport
     self.currentSport = BestSportsBasketball;
}
#pragma mark: tableview delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentUsers.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    rankingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"rankingCell"];
    [cell configureCellWithUser:self.currentUsers[indexPath.row] Ranking:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SNSearchNearbyProfileViewController *vc = [[SNSearchNearbyProfileViewController alloc]init];
    vc.currentUserProfile = _currentUsers[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}
- (IBAction)sportButtonClicked:(UIButton *)sender {
    self.currentSport = sender.tag;
}
/**
 *  setter of currentsport when property "currentSport" value changed. This setter method will 1) reset the already highlighted sport button 2) hightlight the current sport button 3)generate a new currentusers based on their best sport. 4) reload tableview.
 */
-(void)setCurrentSport:(enum BestSports )currentSport {
    if(_currentSport != 0) {
    UIButton *button = (UIButton*)[[self.view viewWithTag:10]viewWithTag:(NSInteger)_currentSport];
    [button setBackgroundImage:self.sportArray[(NSInteger)_currentSport-1] forState:normal];
    }
    UIButton *newButton = (UIButton*)[[self.view viewWithTag:10]viewWithTag:(NSInteger)currentSport];
    [newButton setBackgroundImage:self.sportArraySelected[(NSInteger)currentSport-1] forState:normal];
    _currentSport = currentSport;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ TOP", self.titles[currentSport-1]];
    [self.currentUsers removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id obj, NSDictionary *bing) {
        return ((SNUser*)obj).bestSport == _currentSport;
    }];
    self.currentUsers = [[self.allUsers filteredArrayUsingPredicate:predicate]mutableCopy];
    [self.tableView reloadData];
}

#pragma mark: getter of some properties.
-(NSArray*)sportArraySelected {
    _sportArraySelected = @[[UIImage imageNamed:@"joggingSelected"], [UIImage imageNamed:@"muscleSelected"], [UIImage imageNamed:@"soccerSelected"], [UIImage imageNamed:@"basketballSelected"], [UIImage imageNamed:@"yogaSelected"]];
    return _sportArraySelected;
}
//getter of sportArray
-(NSArray*)sportArray {
    _sportArray = @[[UIImage imageNamed:@"jogging"], [UIImage imageNamed:@"muscle"], [UIImage imageNamed:@"soccer"], [UIImage imageNamed:@"basketball"], [UIImage imageNamed:@"yoga"]];
    return _sportArray;
}
//getter of titles
-(NSArray*)titles {
    _titles = @[@"RUNNING", @"FITNESS", @"SOCCER", @"BASKETBALL", @"YOGA"];
    return _titles;
}
@end
