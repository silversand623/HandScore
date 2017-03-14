//
//  PreviewController.h
//  HandScore
//
//  Created by lyn on 14-8-26.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface PreviewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *sections;
@property(nonatomic,retain) NSMutableArray *sheetItems;
@property(nonatomic,retain) NSString *imgPath;//签名图像路径
@property(nonatomic,retain) NSString *scoreID;//成绩保存id
@property(nonatomic,retain) NSString *sIndex;
@property(nonatomic,retain) NSString *markSheetId;
@property(nonatomic,retain) NSMutableArray *markSheets;
@property (weak, nonatomic) IBOutlet UILabel *ExamName;
@property (weak, nonatomic) IBOutlet UILabel *StationName;
@property (weak, nonatomic) IBOutlet UILabel *RoomName;
@property (weak, nonatomic) IBOutlet UILabel *ScoreItems;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UILabel *MarkSheetName;
@property(nonatomic,retain) NSMutableDictionary *dataMarkSheet;//评分表原始数据,需要修改值，所以用可变字典
@property NSInteger nTag;//区分从哪里进入预览页面
@property (nonatomic,retain) MBProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelExamNo;
@property (weak, nonatomic) IBOutlet UILabel *labelStudentNo;
@property (weak, nonatomic) IBOutlet UILabel *labelClassName;
@property (weak, nonatomic) IBOutlet UILabel *TotalSum;
@property (weak, nonatomic) IBOutlet UILabel *actureScore;
@property BOOL bZero;
@property(nonatomic,retain) NSString *sActualScore;//实际成绩
@end
