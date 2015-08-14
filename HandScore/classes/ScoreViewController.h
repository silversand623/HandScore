//
//  ScoreViewController.h
//  HandScore
//
//  Created by lyn on 14-8-22.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginInfoType;
@class ComboxView;
@class MBProgressHUD;

@protocol PassValueDelegate
// 必选方法
- (void)passValue:(NSInteger )value;
@end

@interface ScoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ExamName;
@property (weak, nonatomic) IBOutlet UILabel *StationName;
@property (weak, nonatomic) IBOutlet UILabel *RoomName;
@property (weak, nonatomic) IBOutlet UILabel *ScoreItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain) LoginInfoType *loginItem;
@property(nonatomic,retain) NSMutableArray *sections;//一级评分表名称
@property(nonatomic,retain) NSMutableArray *sheetItems;//二级评分表名称
@property(nonatomic,retain) NSMutableArray *markSheets;//评分表名字
@property(nonatomic,retain) ComboxView *comView;
@property(nonatomic,retain) NSString *sIndex;//评分表索引
@property(nonatomic,retain) NSDictionary *dataMarkSheet;//评分表原始数据
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (nonatomic,retain) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UILabel *StudentNo;
@property(nonatomic,retain) NSString *imgPath;//签名图像路径
@property (weak, nonatomic) IBOutlet UILabel *txtName;
- (IBAction)setSetings:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnShowInfo;

- (IBAction)showInfo:(id)sender;

typedef enum
{
    //以下是枚举成员
    AddScore = 0,
    MinusScore = 1,
    Others = 2
}ScoreState;//枚举名称

@end
