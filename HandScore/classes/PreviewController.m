//
//  PreviewController.m
//  HandScore
//
//  Created by lyn on 14-8-26.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "PreviewController.h"
#import "PreviewTableCell.h"
#import "MarkSheetItem.h"
#import "ScoreViewController.h"
#import "MarkSheetItem.h"
#import "TYAppDelegate.h"
#import "Student.h"
#import "MarkSheetItem.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "LoginInfoType.h"
#import "PopSignUtil.h"
#import "WTRequestCenter.h"
#import "LoginViewController.h"
#import "RMMapper.h"
#import "UIImageView+PINRemoteImage.h"
#import "PINCache/PINCache.h"
#import "FLAnimatedImage/FLAnimatedImageView.h"

#define PREVIEWCELLID @"UMPreviewCell"

@interface PreviewController ()

@end

@implementation PreviewController

int nIndex = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:@"PreviewTableCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:PREVIEWCELLID];
    //[self.returnBtn infoStyle];
    //[self.commitBtn infoStyle];
    
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
            [[self labelExamNo] setText:obj.EStu_ExamNumber];//确认到底是学生号码还是考试号码
            [[self labelName] setText:[obj.U_TrueName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[self labelStudentNo] setText:[obj.U_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[self labelClassName] setText:[obj.O_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            break;
        }
    }
    

    //1代表从评分页面进入，2代表从查看页面进入
    BOOL bValue = NO;
    if ([self nTag] == 1) {
        nIndex = [[self sIndex] integerValue];
        if (_imgPath != nil) {
            UIImage *bgImage = [[UIImage alloc]initWithContentsOfFile:[self imgPath]];
            [self.signButton setBackgroundImage:bgImage forState:UIControlStateNormal];
            [self.signButton setTitle:@"" forState:UIControlStateNormal];
        }
        [[self MarkSheetName] setText:_markSheets[0]];
        [[self actureScore] setText:_sActualScore];
        
    } else {
        nIndex = 0;
        [self.commitBtn setHidden:YES];
        //[self.returnBtn setFrame:self.commitBtn.frame];
        [self.signButton setTitle:@"" forState:UIControlStateNormal];
        [self.signButton setUserInteractionEnabled:NO];
        
        TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
        for (NSArray *obj in appDelegate.gStudentScores) {
            NSString *uid = [obj objectAtIndex:0];
            if ([appDelegate.gStudentId isEqualToString:uid]) {
                _sections = [[NSMutableArray alloc] init];
                _sheetItems = [[NSMutableArray alloc] init];
                [_sections addObject:[obj objectAtIndex:1]];
                [_sheetItems addObject:[obj objectAtIndex:2]];
                _imgPath = [obj objectAtIndex:3];
                if (_imgPath != nil) {
                    UIImage *bgImage = [[UIImage alloc]initWithContentsOfFile:[self imgPath]];
                    [self.signButton setBackgroundImage:bgImage forState:UIControlStateNormal];
                }
                [[self MarkSheetName] setText:[obj objectAtIndex:4]];
                bValue = YES;
                
                break;
            }
        }
        if (!bValue) {
            self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.HUD setLabelText:@"正在查询成绩"];
            [self getScoreInfo];
            
            
        }
        
        
    }
    
    [[self TotalSum] setText:[NSString stringWithFormat:@"%0.2f", [self getTotalSum]]];
    
    
}

/**
 *  获取考试评委签名图像
 */
-(void)getScoreImage
{
    //display student photo
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"/AppDataInterface/HandScore.aspx/SearchScoreInfoImage?SI_ID=%@",[self scoreID]];
    NSURL *TempUrl = [NSURL URLWithString:url];
    /*
    [WTRequestCenter getImageWithURL:TempUrl completionHandler:^(UIImage *image) {
        if (image != nil) {
            [[self signButton] setBackgroundImage:image forState:UIControlStateNormal];
        }
        
    }];
    */
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageFromURL:TempUrl
                     completion:^(PINRemoteImageManagerResult *result) {
                         if (result.image != nil) {
                             [[self signButton] setBackgroundImage:result.image forState:UIControlStateNormal];
                         }
                     }];
}

/**
 *  查询当前学生考试成绩
 */
-(void) getScoreInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    
    TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    LoginInfoType *info = appDelegate.gLoginItem;
    [params setObject:info.E_ID forKey:@"E_ID"];
    [params setObject:info.ES_ID forKey:@"ES_ID"];
    [params setObject:info.Room_ID forKey:@"Room_ID"];
    [params setObject:info.U_ID forKey:@"U_ID"];
    [params setObject:appDelegate.gStudentId forKey:@"Student_U_ID"];
    
    
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchStudentScore"];
    NSURL *TempUrl = [NSURL URLWithString:url];
    
    [WTRequestCenter postWithoutCacheURL:TempUrl
                              parameters:params completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                  if (!error) {
                                      [self.HUD hide:YES];
                                      NSError *jsonError = nil;
                                      [self.HUD hide:YES];
                                      id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                      if (!jsonError) {
                                          ///
                                          NSString *str = [obj objectForKey:@"result"];
                                          if (str != nil) {
                                              int nRestult = [self dealError:str];
                                              if (nRestult == Success) {
                                                  ///
                                                  NSString * markName = [obj objectForKey:@"MS_Name"];
                                                  [[self MarkSheetName] setText:[markName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                                  
                                                  _sections = [[NSMutableArray alloc] init];
                                                  _sheetItems = [[NSMutableArray alloc] init];
                                                  [self.sheetItems addObject:[NSMutableArray array]];
                                                  [self.sections addObject:[NSMutableArray array]];
                                                  _sActualScore = [obj objectForKey:@"SI_Score"];
                                                  _scoreID = [obj objectForKey:@"SI_ID"];
                                                  NSArray *mark_sheet_items = [obj objectForKey:@"item_score_list"];
                                                  for (int j=0; j<mark_sheet_items.count; j++) {
                                                      NSDictionary *dicItems = [mark_sheet_items objectAtIndex:j];
                                                      if ([[dicItems allKeys] containsObject:@"children_item_list"]) {
                                                          NSArray *children_list = [dicItems objectForKey:@"children_item_list"];
                                                          NSMutableArray* markItems = [RMMapper mutableArrayOfClass:[MarkSheetItem class]
                                                                                              fromArrayOfDictionary:children_list];
                                                          [self.sections[0] addObject:([dicItems objectForKey:@"MSI_Item"])];
                                                          [self.sheetItems[0] addObject:[NSMutableArray array]];
                                                          for (int n=0; n<markItems.count; n++) {
                                                              [self.sheetItems[0][j] addObject:markItems[n]];
                                                          }
                                                          
                                                      }else if ([[dicItems allKeys] containsObject:@"MSI_Score"]){
                                                          MarkSheetItem *markItem=[RMMapper objectWithClass:[MarkSheetItem class]
                                                                                             fromDictionary:dicItems];
                                                          [self.sections[0] addObject:(markItem.MSI_Item)];
                                                          [self.sheetItems[0] addObject:[NSMutableArray array]];
                                                          [self.sheetItems[0][j] addObject:markItem];
                                                      }
                                                  }
                                                  ////
                                                  nIndex = 0;
                                                  [self getScoreImage];
                                                  
                                                  [[self TotalSum] setText:[NSString stringWithFormat:@"%0.2f", [self getTotalSum]]];
                                                  [[self actureScore] setText:_sActualScore];

                                                  [[self tableView] reloadData];
                                                  
                                              }
                                              
                                          }
                                          ////
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
                                      [alert show];                          }
                                  
                              }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_sheetItems.count > 0) {
        id obj = _sheetItems[nIndex][indexPath.section];
        MarkSheetItem *item = (MarkSheetItem*) [obj objectAtIndex:indexPath.row];
        NSString *content = [item.MSI_Item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self getLabelHeight:content widthIs:520];
        
    }
    
    
    // 這裏返回需要的高度
    return 60;
}

/**
 *  获取标签内文字高度
 *
 *  @param indexPath 标签所在表格行号
 *
 *  @return 返回标签高度
 */
-(CGFloat)getLabelHeight:(NSString *)content widthIs:(CGFloat)width {
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:20];
    
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(width, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, 40)+20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    NSString *content=@"";
    if (_sections.count > 0)
    {
        content = [_sections[nIndex][section] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_sections.count > 0) {
        
        NSString *content = [_sections[nIndex][section] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self getLabelHeight:content widthIs:1000];
    }
    return 23;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_sheetItems.count > 0) {
        return [self.sheetItems[nIndex] count];
        
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sheetItems.count > 0) {
        id obj = _sheetItems[nIndex][section];
        return [obj count];
    }else{
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_sections.count > 0) {
        return [_sections[nIndex][section] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    } else {
        return @"";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PreviewTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PREVIEWCELLID forIndexPath:indexPath];
    
    MarkSheetItem *item = nil;
    if (_sheetItems.count > 0) {
        id obj = _sheetItems[nIndex][indexPath.section];
        item = (MarkSheetItem*) [obj objectAtIndex:indexPath.row];
        //resize the height of label
        NSString *content = [item.MSI_Item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGRect rect = cell.scoreContent.frame;
        rect.size.height = [self getLabelHeight:content widthIs:520];
        if (iOS8)
        {
            [cell.scoreContent setFrame:CGRectMake(20, 0, rect.size.width, rect.size.height)];
        } else if (iOS7) {
            [cell.scoreContent setFrame:rect];
        }
        [cell.scoreContent setText:content];
        //
        if (item.Item_Score == nil) {
            item.Item_Score =@"0.00";
        }
        cell.scoreValue.text = item.Item_Score;
    }
    
    
    return cell;
    
    
}

/*
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [TYAppDelegate colorWithHexString:@"EFEFF4"];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[TYAppDelegate colorWithHexString:@"067BAB"]];
    
}
*/
 
/**
 *  回退到考试评分界面
 *
 *  @param sender 回退按钮
 */
- (IBAction)backToScore:(id)sender {
    TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.gImgPath = [self imgPath];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  触发签名控件
 *
 *  @param sender 签名按钮
 */
- (IBAction)getSign:(id)sender {
    TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.myView = self.view;//设置签名窗口的父窗口
    
    [PopSignUtil getSignWithVC:self withOk:^(UIImage *image) {
        [PopSignUtil closePop];
        if (image != nil) {
            [self.signButton setBackgroundImage:image forState:UIControlStateNormal];
            [self.signButton setTitle:@"" forState:UIControlStateNormal];
            [self savePic:image];
            image = nil;
        }
        
    } withCancel:^{
        [PopSignUtil closePop];
    }];

}

/**
 *  提交成绩
 *
 *  @param sender 提交成绩按钮
 */
- (IBAction)commitScore:(UIButton *)sender {
    
    
    if ([self.signButton backgroundImageForState:UIControlStateNormal]) {
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.HUD setLabelText:@"正在提交成绩"];
        [self addScoreInfo];
        
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提交成绩错误" message:@"提交成绩前请先签名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

/**
 *  调用提交成绩接口
 */
-(void) addScoreInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    
    NSString * strJson = [self getJsonFromDict:[self dataMarkSheet]];
    if (strJson == nil) {
        return;
    }
    //float nSum = [self getSum];
    float nSum = _sActualScore.doubleValue;
    
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    LoginInfoType *info = appDelegate.gLoginItem;
    [params setObject:info.E_ID forKey:@"E_ID"];
    [params setObject:info.ES_ID forKey:@"ES_ID"];
    [params setObject:info.Room_ID forKey:@"Room_ID"];
    [params setObject:appDelegate.gStudentId forKey:@"Student_ID"];
    [params setObject:info.U_ID forKey:@"Rater_ID"];
    [params setObject:[NSString stringWithFormat:@"%0.2f",nSum] forKey:@"SI_Score"];//因为数据库字段未int
    [params setObject:[self.markSheets objectAtIndex:0] forKey:@"SI_Item"];
    [params setObject:self.markSheetId forKey:@"MS_ID"];
    [params setObject:info.EU_ID forKey:@"EU_ID"];
    [params setObject:strJson forKey:@"SI_Items"];
    //[params setObject:@"111" forKey:@"image"];
    
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/AddScoreInfo"];
    NSURL *TempUrl = [NSURL URLWithString:url];
    
    [WTRequestCenter postImageWithoutCacheURL:TempUrl
                                   parameters:params imgpath:self.imgPath completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                  if (!error) {
                                      NSError *jsonError = nil;
                                      [self.HUD hide:YES afterDelay:1];
                                      
                                      id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                      if (!jsonError) {
                                          ///
                                          NSString *str = [obj objectForKey:@"result"];
                                          if (str != nil) {
                                              int nResult = [self dealError:str];
                                              if (nResult == Success) {
                                                  ///
                                                  TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
                                                  //save scores
                                                  NSMutableArray *temp = [[NSMutableArray alloc] init];
                                                  [temp addObject:appDelegate.gStudentId];//学生id
                                                  [temp addObject:[_sections objectAtIndex:nIndex]];//一级评分表项
                                                  [temp addObject:[_sheetItems objectAtIndex:nIndex]];//评分表项
                                                  [temp addObject:_imgPath];//添加签名图片路径
                                                  [temp addObject:_markSheets[0]];//评分表名字
                                                  [appDelegate.gStudentScores addObject:temp];
                                                  
                                                  //modify student state
                                                  //float nSum = [self getSum];
                                                  float nSum = _sActualScore.doubleValue;
                                                  for (Student *obj in appDelegate.gStudnetArray) {
                                                      if ([obj.U_ID isEqualToString:appDelegate.gStudentId]) {
                                                          obj.student_state = [NSString stringWithFormat: @"%d", HaveScored];
                                                          obj.student_score = [NSString stringWithFormat: @"%0.2f", nSum];
                                                          break;
                                                      }
                                                  }
                                                  
                                                  
                                                  /////
                                                  
                                                  [self saveScores];
                                                  
                                                  //////
                                                  
                                                  [self dismissViewControllerAnimated:NO completion:nil];
                                                  
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"closeView" object:nil];
                                                  
                                                  ////
                                              }
                                          }
                                          
                                          ////
                                      }else
                                      {
                                          NSLog(@"jsonError:%@",jsonError);
                                          UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"json格式错误" message:[jsonError localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                          [alert show];
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
        case -1:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"成绩提交" message:@"考生成绩已提交，请不要重复提交。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        [self dismissViewControllerAnimated:NO completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeView" object:nil];
    }
}

/**
 *  获取考试实际成绩
 *
 *  @return 返回累加成绩分数
 */
-(float)getSum {
    float nSum = 0.00;
    for (NSArray *obj in [_sheetItems objectAtIndex:nIndex]) {
        for (MarkSheetItem *item in obj) {
            nSum += [item.Item_Score floatValue];
        }
    }
    if (_bZero==YES)
    {
        nSum = 0.00;
    }
    return nSum;
}

/**
 *  获取评分表总分数
 *
 *  @return 返回总分数
 */
-(float)getTotalSum {
    float nSum = 0.00;
    for (NSArray *obj in [_sheetItems objectAtIndex:nIndex]) {
        for (MarkSheetItem *item in obj) {
            nSum += [item.MSI_Score floatValue];
        }
    }
    return nSum;
}

/**
 *  根据字典转成json串
 *
 *  @param data 字典数组
 *
 *  @return 返回json串
 */
- (NSString *)getJsonFromDict:(NSMutableDictionary *)data {
    NSArray *mark_list = [data objectForKey:@"mark_sheet_list"];
    NSMutableDictionary *dicList = [mark_list objectAtIndex:nIndex];
    NSArray *mark_sheet_items = [dicList objectForKey:@"item_list"];
    self.markSheetId = [dicList objectForKey:@"MS_ID"];
    for (int j=0; j<mark_sheet_items.count; j++) {
        NSMutableDictionary *dicItems = [mark_sheet_items objectAtIndex:j];
        if ([[dicItems allKeys] containsObject:@"children_item_list"]) {
            NSArray *children_list = [dicItems objectForKey:@"children_item_list"];
            
            for (int n=0; n<children_list.count; n++) {
                MarkSheetItem *markItem = (MarkSheetItem *)[self.sheetItems[nIndex][j] objectAtIndex:n];
                NSMutableDictionary *childItem = [children_list objectAtIndex:n];
                if (markItem.Item_Score == nil) {
                    [childItem setValue:@"0" forKey:@"Item_Score"];
                }else
                {
                    [childItem setValue:markItem.Item_Score forKey:@"Item_Score"];
                }
                [childItem setValue:@"" forKey:@"MSIRD_ID"];
                for (int k=0; k<markItem.item_detail_list.count; k++) {
                    id temp =[markItem.item_detail_list objectAtIndex:k];
                    NSString *str1 = [markItem.Item_Score substringToIndex:3];
                    NSString *str2 = [[temp objectForKey:@"MSIRD_Score"] substringToIndex:3];
                    if ([str1 isEqualToString:str2])
                    {
                        [childItem setValue:[temp objectForKey:@"MSIRD_ID"] forKey:@"MSIRD_ID"];
                        break;
                    }
                }
                
            }
            
        }else if ([[dicItems allKeys] containsObject:@"MSI_Score"]){
            //MarkSheetItem *markItem = (MarkSheetItem *)[self.sheetItems[nIndex][j] objectAtIndex:0];
            //[dicItems setValue:markItem.Item_Score forKey:@"MSI_Score"];
            //[dicItems removeObjectForKey:@"MSI_Item"];
        }
    }
    
    NSError *error;
    NSString *strJson = nil;
    NSData *registerData = [NSJSONSerialization dataWithJSONObject:dicList options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        strJson = [[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
    } else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"json格式错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    return strJson;
}

/**
 *  保存签名图片
 *
 *  @param image 签名图像
 */
-(void)savePic:(UIImage *)image
{
    NSString *uuidFile = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
    _imgPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:uuidFile];
    //保存png的图片到app下的Document/
    [UIImagePNGRepresentation(image) writeToFile:_imgPath atomically:YES];
}

-(void)saveScores {
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    NSString *sFile = appDelegate.gScoreFile;
    if (sFile == nil) {
        NSString *uuidFile = [NSString stringWithFormat:@"%@.txt", [[NSUUID UUID] UUIDString]];
        appDelegate.gScoreFile = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:uuidFile];
        sFile = appDelegate.gScoreFile;
    }
    //BOOL bresult = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sFile]) {
        [fm createFileAtPath:sFile contents:nil attributes:nil];
    }
    NSFileHandle * fileHandle = [NSFileHandle fileHandleForWritingAtPath:sFile];
    
    if(fileHandle == nil)
    {
        return;
    }
    [fileHandle seekToEndOfFile];
    NSData *data = nil;
    
    for (NSArray *obj in appDelegate.gStudentScores) {
        [fileHandle seekToEndOfFile];
        data = [[obj[0] stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:data];
        [fileHandle seekToEndOfFile];
        data = [[[obj[1] objectAtIndex:0] stringByAppendingString:@"\n" ]dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:data];
        id scoreItems = [obj[2] objectAtIndex:0];
        for (MarkSheetItem *item in scoreItems) {
            [fileHandle seekToEndOfFile];
            data = [NSKeyedArchiver archivedDataWithRootObject:item];
            [fileHandle writeData:data];
            [fileHandle seekToEndOfFile];
            data = [@"\n" dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:data];
        }
        [fileHandle seekToEndOfFile];
        data = [[obj[3] stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:data];
    }
    
    [fileHandle closeFile];
}

@end
