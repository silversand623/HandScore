//
//  ScoreViewController.m
//  HandScore
//
//  Created by lyn on 14-8-22.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "ScoreViewController.h"
#import "ScoreTableViewCell.h"
#import "WTRequestCenter.h"
#import "LoginInfoType.h"
#import "MarkSheetItem.h"
#import "RMMapper.h"
#import "ComboxView.h"
#import "PreviewController.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "TYAppDelegate.h"
#import "Student.h"
#import "LoginViewController.h"
#import "Settings.h"
#import "MJExtension.h"
#import <math.h>
#import "HCSStarRatingView.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#define SCORECELLID @"ScoreCell"


@interface ScoreViewController ()

@end

@implementation ScoreViewController

int nCount = 0;
bool bScore = YES;
double dStep = 1.0;
int nMode = 0;
bool bScoreRule = NO;
long lTime = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  界面加载方法
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"ScoreTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:SCORECELLID];
    
    [self.btnShowInfo setHidden:YES];
    
    bScore = YES;
    self.tableView.rowHeight = 60;
    _comView = [[ComboxView alloc] initWithFrame:CGRectMake(140, 140, 490, 100)];
    //[self.view addSubview:_comView]; //comment for only one marksheet
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:@"closeView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSetting) name:@"updateSet" object:nil];
    
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    LoginInfoType *info = appDelegate.gLoginItem;
    if (info != nil) {
        [[self ExamName] setText:[info.E_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[self StationName] setText:[info.ES_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[self RoomName] setText:[info.Room_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[self ScoreItems] setText:[info.mark_sheet_count stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (Student * obj in appDelegate.gStudnetArray) {
        if ([obj.U_ID isEqualToString:appDelegate.gStudentId]) {
            [[self StudentNo] setText:obj.EStu_ExamNumber];//确认到底是学生号码还是考试号码
            [[self txtName] setText:[obj.U_TrueName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
    }
    
    
    if (_sheetItems.count < 1) {
        self.sections = [[NSMutableArray alloc] init];
        self.sheetItems = [[NSMutableArray alloc] init];
        self.markSheets = [[NSMutableArray alloc] init];
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.HUD setLabelText:@"正在加载评分表信息"];
        [self getMarkSheetInfo];
    }else {
        nCount = [_sIndex integerValue];
        _comView.tableArray = [self markSheets];
        _comView.delegate = self;
        _comView.textField.text = _markSheets[nCount];
        [_comView.dropTableView reloadData];
        [[self MarkSheetName] setText:_markSheets[0]];
        [self getTotalSum];
    }
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *step = [defaults objectForKey:@"Step"];
    NSString *sMode = [defaults objectForKey:@"Mode"];
    if (step != nil) {
        dStep = [step doubleValue];
    } else {
        dStep = 1.0;
    }
    if (sMode != nil) {
        nMode = [sMode integerValue];
    } else {
        nMode = 0;
    }
    
    _bZero = NO;
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(Beep) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}

-(void)Beep
{
    lTime++;
    if (lTime > _nElapseTime && _nElapseTime > 0)
    {
        [_myTimer invalidate];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您设置的评分提醒时间已到，请尽快完成评分！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        
        //定义一个SystemSoundID
        SystemSoundID soundID = 1005;//具体参数详情下面贴出来
        //播放声音
        AudioServicesPlaySystemSound(soundID);
        
        _nElapseTime = 0;
    }
    
}

-(void)getTotalSum {
    float nSum = 0.0;
    for (NSArray *obj in [_sheetItems objectAtIndex:0]) {
        for (MarkSheetItem *item in obj) {
            nSum += [item.MSI_Score floatValue];
        }
    }
    [_Total setText:[NSString stringWithFormat:@"%.f", nSum]];
}

-(void)getSum {
    float nSum = 0.0;
    for (NSArray *obj in [_sheetItems objectAtIndex:0]) {
        for (MarkSheetItem *item in obj) {
            nSum += [item.Item_Score floatValue];
        }
    }
    if (_bZero==YES)
    {
        nSum = 0.0;
    }
    [_Actual setText:[NSString stringWithFormat:@"%.f", nSum]];
}

/**
 *  屏幕触控事件
 *
 *  @param touches 触控对象
 *  @param event   事件对象
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.comView closeTableView];
}

-(void)closeWindow {
    [self performFakeMemoryWarning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) performFakeMemoryWarning {
#ifdef DEBUG_BUILD
    SEL memoryWarningSel = @selector(_performMemoryWarning);
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
        [[UIApplication sharedApplication] performSelector:memoryWarningSel];
    }else {
        NSLog(@"Whoops UIApplication no loger responds to -_performMemoryWarning");
    }
#else
    NSLog(@"Warning: performFakeMemoryWarning called on a non debug build");
#endif
}

/**
 *  更新设置
 */
-(void)updateSetting {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *step = [defaults objectForKey:@"Step"];
    NSString *sMode = [defaults objectForKey:@"Mode"];
    if (step != nil) {
        dStep = [step doubleValue];
    } else {
        dStep = 1.0;
    }
    if (sMode != nil) {
        nMode = [sMode integerValue];
    } else {
        nMode = 0;
    }
    
    [self setState:nMode step:dStep];
}

- (IBAction)getSwitch:(UISwitch*)sender
{
    ScoreTableViewCell *cell = [self getCell:sender];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    int nIndex = 0;
    if (sender.on) {
        nIndex = 1;
    }else
    {
        nIndex = 0;
    }
    item.rating_value = [NSString stringWithFormat:@"%d", nIndex];
    id temp =[item.item_detail_list objectAtIndex:nIndex];
    item.Item_Score = [temp objectForKey:@"MSIRD_Score"];
    NSString *comment = [[temp objectForKey:@"MSIRD_Item"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.FinalScore setText:item.Item_Score];
    [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    [cell.Comment setText:comment];
    if (nIndex == 0 && bScoreRule==NO) {
        _bZero = YES;
    }else
    {
        _bZero = NO;
    }
    [self getSum];
}

/**
 *  设置状态和步长
 *
 *  @param mode  打分模式
 *  @param dStep 打分步长
 */
-(void)setState:(int)mode step:(float)dStep {
    switch (mode) {
        case AddScore:
            if (_sheetItems.count > 0) {
                for (int i = 0; i < [_sheetItems[nCount] count]; i++) {
                    id obj = _sheetItems[nCount][i];
                    for (int j=0; j < [obj count]; j++) {
                        MarkSheetItem *msItem = (MarkSheetItem*) [obj objectAtIndex:j];
                        msItem.Item_Score = nil;
                        msItem.rating_value=nil;
                        msItem.step_value=nil;
                    }
                }
                
            }
            bScore = YES;
            break;
            
        case MinusScore:
            if (_sheetItems.count > 0) {
                for (int i = 0; i < [_sheetItems[nCount] count]; i++) {
                    id obj = _sheetItems[nCount][i];
                    for (int j=0; j < [obj count]; j++) {
                        MarkSheetItem *msItem = (MarkSheetItem*) [obj objectAtIndex:j];
                        msItem.Item_Score = msItem.MSI_Score;
                        msItem.rating_value=@"1.0";
                        double dScore = [msItem.MSI_Score doubleValue];
                        double rate = dScore/dStep;
                        msItem.step_value = [NSString stringWithFormat:@"%.2f", rate];
                        
                    }
                }
                
            }
            bScore = YES;
            break;
            
        default:
            break;
    }
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  获取评分标信息
 */
-(void) getMarkSheetInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    
    [params setObject:self.loginItem.EU_ID forKey:@"EU_ID"];
    
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchMarkSheet"];
    NSURL *TempUrl = [NSURL URLWithString:url];
    
    [WTRequestCenter postWithoutCacheURL:TempUrl
                              parameters:params completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                  if (!error) {
                                      NSError *jsonError = nil;
                                      [self.HUD hide:YES afterDelay:0.5];
                                      id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                      if (!jsonError) {
                                          ///
                                          NSString *str = [obj objectForKey:@"result"];
                                          if (str != nil) {
                                              int nRestult = [self dealError:str];
                                              if (nRestult == Success) {
                                                  // Tell MJExtension what type model will be contained in statuses and ads.
                                                  [MarkSheetItem mj_setupObjectClassInArray:^NSDictionary *{
                                                      return @{
                                                               @"item_detail_list" : @"DetailItems"
                                                               // @"ads" : [Ad class]
                                                               };
                                                  }];
                                                  
                                                  self.dataMarkSheet = obj;
                                                  NSArray *mark_list = [obj objectForKey:@"mark_sheet_list"];
                                                  for (int i=0; i<mark_list.count; i++) {
                                                      [self.sheetItems addObject:[NSMutableArray array]];
                                                      [self.sections addObject:[NSMutableArray array]];
                                                      NSDictionary *dicList = [mark_list objectAtIndex:i];
                                                      [self.markSheets addObject:[[dicList objectForKey:@"MS_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                                      if ([[dicList objectForKey:@"MarkSheetNumber2"] isEqualToString:@"0"])
                                                      {
                                                          bScoreRule = YES;//成绩累计
                                                      }
                                                      NSArray *mark_sheet_items = [dicList objectForKey:@"item_list"];
                                                      for (int j=0; j<mark_sheet_items.count; j++) {
                                                          NSDictionary *dicItems = [mark_sheet_items objectAtIndex:j];
    
                                                          if ([[dicItems allKeys] containsObject:@"children_item_list"]) {
                                                              NSArray *children_list = [dicItems objectForKey:@"children_item_list"];
                                                              
                                                              
                                                              
                                                              
                                                              [self.sections[i] addObject:([dicItems objectForKey:@"MSI_Item"])];
                                                              [self.sheetItems[i] addObject:[NSMutableArray array]];
                                                              for (int k=0; k<children_list.count;k++)
                                                              {
                                                                  MarkSheetItem *markItem = [MarkSheetItem mj_objectWithKeyValues:children_list[k]];
                                                                  [self.sheetItems[i][j] addObject:markItem];
                                                              }

                                                              
                                                          }else if ([[dicItems allKeys] containsObject:@"MSI_Score"]){
                                                              MarkSheetItem *markItem=[RMMapper objectWithClass:[MarkSheetItem class]
                                                                                                 fromDictionary:dicItems];
                                                              [self.sections[i] addObject:(markItem.MSI_Item)];
                                                              [self.sheetItems[i] addObject:[NSMutableArray array]];
                                                              [self.sheetItems[i][j] addObject:markItem];
                                                          }
                                                      }
                                                  }
                                                  //choice 0 marksheetiem
                                                  nCount = 0;
                                                  _comView.tableArray = [self markSheets];
                                                  _comView.delegate = self;
                                                  _comView.textField.text = _markSheets[0];
                                                  [_comView.dropTableView reloadData];
                                                  
                                                  [[self MarkSheetName] setText:_markSheets[0]];
                                                  
                                                  [self setState:nMode step:dStep];
                                                  
                                                  [[self tableView] reloadData];
                                                  
                                                  [self getTotalSum];
                                                  
                                                  ////
                                              }
                                          }
                                      }else
                                      {
                                          NSLog(@"jsonError:%@",jsonError);
                                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"json格式错误" message:[jsonError localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                          [alert show];
                                          NSLog(@"jsonError:%@",jsonError);
                                      }
                                      
                                  }else
                                  {
                                      [self.HUD hide:YES];
                                      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                      [alert show];
                                      NSLog(@"error:%@",error);
                                  }
                                  
                              }];
}

-(int)dealError:(NSString *) result{
    int nCase = [result integerValue];
    switch (nCase) {
        case Success:
        {
            break;
        }
        default:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"其它错误" message:@"其他内部错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
    }
    
    return nCase;
}

- (void)passValue:(NSInteger )value{
    nCount = value;
    [[self tableView] reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_sheetItems.count > 0) {
        id obj = _sheetItems[nCount][indexPath.section];
        MarkSheetItem *item = (MarkSheetItem*) [obj objectAtIndex:indexPath.row];
        NSString *content = [item.MSI_Item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self getLabelHeight:content widthIs:480];
    }
    
    
    // 這裏返回需要的高度
    return 60;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_sections.count > 0) {
        
        NSString *content = [_sections[nCount][section] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self getLabelHeight:content widthIs:1000];
    }
    return 23;
}


-(CGFloat)getLabelHeight:(NSString *)content widthIs:(CGFloat)width {
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:20];
    
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, 40)+20;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_sheetItems.count > 0) {
        return [self.sheetItems[nCount] count];
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sheetItems.count > 0) {
        id obj = _sheetItems[nCount][section];
        return [obj count];
    }else{
        return 1;
    }
}

/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_sections.count > 0) {
        //return [_sections[nCount][section] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return @"奥斯卡级打法是否可奥斯卡及地方撒了开发奥斯卡积分打算离开；发送了；卡刷卡福利大师傅就卡的身份案例看世界发达时刻就发生科技发生了开发了快速；剪发卡时间了垃圾收福利卡手机费爱上浪费的空间按时付款了大师及福利卡时间了；按时交付的绿卡手机发送看来就爱上离开；按时交付的考拉说法都是老会计法拉数据的发生了咖啡加大了说开发商可交付拉就是的罚款了手机费";
    } else {
        return @"";
    }
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    NSString *content=@"";
    if (_sections.count > 0)
    {
        content = [_sections[nCount][section] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        height = [self getLabelHeight:content widthIs:1000];
    }
    UIView * v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, tableView.frame.size.width, height);
    v.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    UILabel * label = [[UILabel alloc] init];
    label.numberOfLines=0;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.frame = CGRectMake(10, 0, tableView.frame.size.width, height);
    label.text = content;
    [label setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    label.font = [UIFont systemFontOfSize:20];
    [v addSubview:label];
    
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ScoreTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SCORECELLID forIndexPath:indexPath];
    //add event
    [cell.Rating addTarget:self action:@selector(slidderChanged:) forControlEvents:UIControlEventValueChanged];
    //add click event
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [cell.Rating addGestureRecognizer:gr];
    
    [cell.stepValue addTarget:self action:@selector(StepperChanged:) forControlEvents:UIControlEventValueChanged];
    
    [cell.StarRate addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    MarkSheetItem *item = nil;
    if (_sheetItems.count > 0) {
        id obj = _sheetItems[nCount][indexPath.section];
        item = (MarkSheetItem*) [obj objectAtIndex:indexPath.row];
        //
        
        
        cell.ScoreValue.text = item.MSI_Score;
        
        //resize the height of label
        NSString *content = [item.MSI_Item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGRect rect = cell.ScoreItem.frame;
        rect.size.height = [self getLabelHeight:content widthIs:480];
        if (iOS8)
        {
            [cell.ScoreItem setFrame:CGRectMake(20, 0, rect.size.width, rect.size.height)];
        } else if (iOS7) {
            [cell.ScoreItem setFrame:rect];
        }
        
        if (item.rating_value == nil) {
            if (bScore) {
                cell.FinalScore.text = nil;
                
            } else {
                cell.FinalScore.text = @"请评分";
                [cell.FinalScore setTextColor:[UIColor redColor]];
                [cell.FinalScore setFont:[UIFont systemFontOfSize:20.0]];
            }
        }
        
        [cell.ScoreItem setText:content];
        
        if ([item.Score_Type isEqualToString:@"0"])
        {
            //
            [cell.StarRate setHidden:YES];
            [cell.Rating setHidden:NO];
            [cell.stepValue setHidden:NO];
            [cell.Comment setHidden:YES];
            [cell.scoreSwitch setHidden:YES];
            [cell.FinalScore setText:@""];
            
            if (item.rating_value != nil) {
                if (fabs([item.Item_Score floatValue]) < 0.001f) {
                    cell.Rating.value = 0.0;
                }else
                {
                    cell.Rating.value = [item.rating_value floatValue];
                }
                
                cell.FinalScore.text = item.Item_Score;
                [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
                [cell.FinalScore setFont:[UIFont systemFontOfSize:25.0]];
                cell.stepValue.value = [item.step_value doubleValue];
            }else {
                cell.Rating.value = 0.0;
                cell.stepValue.value = 0.0;
                if (bScore) {
                    cell.FinalScore.text = nil;
                    
                } else {
                    cell.FinalScore.text = @"请评分";
                    [cell.FinalScore setTextColor:[UIColor redColor]];
                    [cell.FinalScore setFont:[UIFont systemFontOfSize:20.0]];
                }
                
            }
            
            
            
        }else if ([item.Score_Type isEqualToString:@"1"])
        {
            //
            [cell.StarRate setHidden:NO];
            
            [cell.Rating setHidden:YES];
            [cell.stepValue setHidden:YES];
            [cell.Comment setHidden:NO];
            [cell.scoreSwitch setHidden:YES];
            cell.StarRate.maximumValue = item.item_detail_list.count;
            [cell.Comment setText:@""];
            [cell.FinalScore setText:@""];
            [cell.StarRate setValue:0];
            
            if (item.rating_value != nil)
            {
                cell.StarRate.value = [item.rating_value floatValue];
                cell.FinalScore.text = item.Item_Score;
                [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
                [cell.FinalScore setFont:[UIFont systemFontOfSize:25.0]];
                int nIndex = [item.rating_value intValue];
                if (nIndex >=1)
                {
                    id temp =[item.item_detail_list objectAtIndex:nIndex-1];
                    item.Item_Score = [temp objectForKey:@"MSIRD_Score"];
                    NSString *comment = [[temp objectForKey:@"MSIRD_Item"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [cell.Comment setText:comment];
                }
            }
            
        }else if ([item.Score_Type isEqualToString:@"2"])
        {
            //
            [cell.StarRate setHidden:YES];
            [cell.Rating setHidden:YES];
            [cell.stepValue setHidden:YES];
            [cell.Comment setHidden:NO];
            [cell.scoreSwitch setHidden:NO];
            
            [cell.Comment setText:@""];
            [cell.FinalScore setText:@""];
            
            if (item.rating_value != nil)
            {
                
                cell.FinalScore.text = item.Item_Score;
                [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
                [cell.FinalScore setFont:[UIFont systemFontOfSize:25.0]];
                int nIndex = [item.rating_value intValue];
                if (nIndex ==0)
                {
                    [cell.scoreSwitch setOn:NO];
                }else
                {
                    [cell.scoreSwitch setOn:YES];
                }
                if (nIndex >=0)
                {
                    id temp =[item.item_detail_list objectAtIndex:nIndex];
                    item.Item_Score = [temp objectForKey:@"MSIRD_Score"];
                    NSString *comment = [[temp objectForKey:@"MSIRD_Item"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    [cell.Comment setText:comment];
                }
            }
        }
        
        
    }else{
        cell.Rating.value = 0.0;
        cell.FinalScore.text = nil;
        cell.stepValue.value = 0.0;
        cell.StarRate.value = 0.0;
    }
    
    
    return cell;
    
    
}

/*
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.backgroundView = ({
        UIView * view1 = [[UIView alloc] initWithFrame:header.bounds];
        view1.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        view1;
    });
    [header.textLabel setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    [header.textLabel setNumberOfLines:0];
    [header.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [header.detailTextLabel setText:[self tableView: tableView titleForHeaderInSection: section]];
    
}
*/

- (void)didChangeValue:(HCSStarRatingView *)sender {
    ScoreTableViewCell *cell = [self getCell:sender];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    int nIndex = (int)sender.value;
    item.rating_value = [NSString stringWithFormat:@"%d", nIndex];
    id temp =[item.item_detail_list objectAtIndex:nIndex-1];
    item.Item_Score = [temp objectForKey:@"MSIRD_Score"];
    NSString *comment = [[temp objectForKey:@"MSIRD_Item"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.FinalScore setText:item.Item_Score];
    [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    [cell.Comment setText:comment];
    [self getSum];
}

/**
 *  触摸滑竿响应方法
 *
 *  @param g 手势对象
 */
- (void) tapped: (UITapGestureRecognizer*) g {
    UISlider* sender = (UISlider*)g.view;
    if (sender.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: sender];
    CGFloat percentage = pt.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    
    ScoreTableViewCell *cell = [self getCell:sender];
    
    double stepValue = dStep;
    double score = [cell.ScoreValue.text doubleValue];
    if (dStep > score ) {
        stepValue = score;
    }
    float nValue = 0.0f;
    if (fabs(score) < 0.001f) {
        value = 0.0f;
    }else
    {
        nValue= floorf((value*score)/stepValue);
    }
    [sender setValue:value];
    
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
    cell.stepValue.value = nValue;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    item.rating_value = [NSString stringWithFormat:@"%.2f", sender.value];
    item.Item_Score = [NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue];
    item.step_value = [NSString stringWithFormat:@"%.f", nValue];
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
    //[cell.FinalScore setTextColor:[UIColor blueColor]];
    [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    [cell.FinalScore setFont:[UIFont systemFontOfSize:25.0]];
    [self getSum];
}

/**
 *  滑竿值变动响应事件
 *
 *  @param sender 滑竿对象
 */
- (void)slidderChanged:(UISlider*)sender {
    ScoreTableViewCell *cell = [self getCell:sender];
    double stepValue = dStep;
    double score = [cell.ScoreValue.text doubleValue];
    if (dStep > score ) {
        stepValue = score;
    }
    CGFloat value = sender.value;
    float nValue = 0.0f;
    if (fabs(score) < 0.001f) {
        value = 0.0f;
        [sender setValue:value];
    }else
    {
        nValue= floorf((value*score)/stepValue);
    }
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
    cell.stepValue.value = nValue;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    item.rating_value = [NSString stringWithFormat:@"%.2f", sender.value];
    item.Item_Score = [NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue];
    item.step_value = [NSString stringWithFormat:@"%.f", nValue];
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
    //[cell.FinalScore setTextColor:[UIColor blueColor]];
    [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    [cell.FinalScore setFont:[UIFont systemFontOfSize:25.0]];
    [self getSum];
}

/**
 *  计步器值变动响应事件
 *
 *  @param sender 计步器对象
 */
- (void)StepperChanged:(UIStepper *)sender {
    ScoreTableViewCell *cell = [self getCell:sender];
    double stepValue = dStep;
    double score = [cell.ScoreValue.text doubleValue];
    
    CGFloat value = sender.value;
    if (fabs(score) < 0.001f) {
        value = 0.0f;
    }
    
    sender.value = MIN(score/stepValue, value);
    cell.Rating.value = sender.value*stepValue/score;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    item.rating_value = [NSString stringWithFormat:@"%.2f", cell.Rating.value];
    item.Item_Score = [NSString stringWithFormat:@"%.1f", sender.value*stepValue];
    item.step_value = [NSString stringWithFormat:@"%.f", sender.value];
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", sender.value*stepValue]];
    //[cell.FinalScore setTextColor:[UIColor blueColor]];
    [cell.FinalScore setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    [cell.FinalScore setFont:[UIFont systemFontOfSize:25.0]];
    [self getSum];
}

- (ScoreTableViewCell *)getCell:(id)obj
{
    ScoreTableViewCell *cell = nil;
    if (iOS8)
    {
        cell = (ScoreTableViewCell*)[[obj superview] superview];
    }
    else if (iOS7) {
        cell = (ScoreTableViewCell*)[[[obj superview] superview] superview];
    }
    return cell;
}

/**
 *  预览成绩
 *
 *  @param sender 预览按钮对象
 */
- (IBAction)previewScore:(id)sender {
    BOOL bValue = NO;
    int nIndex = -1;
    int nScoreCount=0;
    int nSection = -1;
    if (_sheetItems.count > 0) {
        for (int i = 0; i < [_sheetItems[nCount] count]; i++) {
            if (!bValue) {
                nIndex = -1;
                nSection++;
            }
            
            id obj = _sheetItems[nCount][i];
            for (int j=0; j < [obj count]; j++) {
                MarkSheetItem *item = (MarkSheetItem*) [obj objectAtIndex:j];
                if (!bValue) {
                    nIndex++;
                }
                
                if (item.Item_Score == nil){
                    bValue = YES;
                    nScoreCount++;
                }
            }
        }
    }
    
    if (bValue) {
        bScore = NO;
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:nIndex inSection:nSection];//定位到第X行
        [[self tableView] scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [[self tableView] reloadData];
        NSString *strMsg = [NSString stringWithFormat:@"还有%d项未打分，请完成打分再预览", nScoreCount];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"有未完成打分项" message:strMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    PreviewController *previewController=[[PreviewController alloc]init];
    previewController.sections = self.sections;
    previewController.sheetItems = self.sheetItems;
    previewController.sIndex = [NSString stringWithFormat: @"%d", nCount];
    previewController.markSheets = self.markSheets;
    previewController.dataMarkSheet = [NSMutableDictionary dictionaryWithDictionary:self.dataMarkSheet];
    previewController.nTag = 1;
    previewController.bZero = _bZero;
    TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    previewController.imgPath = appDelegate.gImgPath;
    appDelegate.gImgPath = nil;
    [self presentViewController:previewController animated:YES completion:nil];
    
}

/**
 *  返回学生信息展示主界面
 *
 *  @param sender 返回按钮对象
 */
- (IBAction)returnMainview:(UIButton *)sender {
    NSString * str = @"请确认是否返回主界面，如果确定则当前评分记录会丢失。";
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"确认返回主界面" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil ] ;
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.gImgPath = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


/**
 *  启动设置界面
 *
 *  @param sender 设置按钮
 */
- (IBAction)setSetings:(id)sender {
    Settings *set = [[Settings alloc] init];
    [self presentViewController:set animated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender {
    
}
@end
