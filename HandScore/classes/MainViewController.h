//
//  MainViewController.h
//  HandScore
//
//  Created by lyn on 14-8-21.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class LoginInfoType;
@class MBProgressHUD;

@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegment;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UILabel *ExamName;
@property (weak, nonatomic) IBOutlet UILabel *StationName;
@property (weak, nonatomic) IBOutlet UILabel *RoomName;
@property (weak, nonatomic) IBOutlet UILabel *ScoreItems;
@property BOOL bHaveMarkSheet;//判断是否有评分表

typedef enum
{
    //以下是枚举成员
    NotDefine = 0,
    AbsenceExam = 1,
    HaveScored = 2,
    NoScore = 3
}StudentState;//枚举名称

@end
