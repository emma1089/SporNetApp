//
//  rankingCell.h
//  SporNetApp
//
//  Created by 浦明晖 on 7/6/16.
//  Copyright © 2016 Peng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MockUser.h"
@interface rankingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *medalImageView;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIView *userBestSportColorView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userSchoolLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bestSportImageView;
@property(strong) UILabel *rankLabel;



-(void)configureCellWithUser:(MockUser*)user Ranking:(NSInteger)ranking;
@end