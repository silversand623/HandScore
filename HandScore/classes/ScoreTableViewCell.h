//
//  ScoreCell.h
//  HandScore
//
//  Created by lyn on 14-8-25.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCSStarRatingView;
@interface ScoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ScoreItem;
@property (weak, nonatomic) IBOutlet UILabel *ScoreValue;
@property (weak, nonatomic) IBOutlet UIStepper *stepValue;
@property (weak, nonatomic) IBOutlet UILabel *FinalScore;
@property (weak, nonatomic) IBOutlet UISlider *Rating;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *StarRate;

@end
