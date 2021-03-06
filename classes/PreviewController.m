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
#import "UIButton+Bootstrap.h"
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
            [[self labelStudentNo] setText:obj.U_Name];
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
        
        
    } else {
        nIndex = 0;
        [self.commitBtn setHidden:YES];
        [self.returnBtn setFrame:self.commitBtn.frame];
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
    
    [[self TotalSum] setText:[NSString stringWithFormat:@"%0.1f", [self getTotalSum]]];
    [[self actureScore] setText:[NSString stringWithFormat:@"%0.1f", [self getSum]]];
    
}

-(void)getScoreImage
{
    //display student photo
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"/AppDataInterface/HandScore.aspx/SearchScoreInfoImage?SI_ID=%@",[self scoreID]];
    NSURL *TempUrl = [NSURL URLWithString:url];
    [WTRequestCenter getImageWithURL:TempUrl completionHandler:^(UIImage *image) {
        if (image != nil) {
            [[self signButton] setBackgroundImage:image forState:UIControlStateNormal];
        }
        
    }];
}

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
                                                  _sections = [[NSMutableArray alloc] init];
                                                  _sheetItems = [[NSMutableArray alloc] init];
                                                  [self.sheetItems addObject:[NSMutableArray array]];
                                                  [self.sections addObject:[NSMutableArray array]];
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
                                                  
                                                  [[self TotalSum] setText:[NSString stringWithFormat:@"%0.1f", [self getTotalSum]]];
                                                  [[self actureScore] setText:[NSString stringWithFormat:@"%0.1f", [self getSum]]];

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
        return [self getLabelHeight:indexPath];
    }
    
    
    // 這裏返回需要的高度
    return 60;
}

-(CGFloat)getLabelHeight:(NSIndexPath *)indexPath {
    // 列寬
    CGFloat contentWidth = 570;
    // 用何種字體進行顯示
    UIFont *font = [UIFont systemFontOfSize:20];
    
    id obj = _sheetItems[nIndex][indexPath.section];
    MarkSheetItem *item = (MarkSheetItem*) [obj objectAtIndex:indexPath.row];
    
    // 該行要顯示的內容
    NSString *content = [item.MSI_Item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, 40)+20;
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
        rect.size.height = [self getLabelHeight:indexPath];
        [cell.scoreContent setFrame:rect];
        [cell.scoreContent setText:content];
        //

        cell.scoreValue.text = item.Item_Score;
    }
    
    
    return cell;
    
    
}

- (IBAction)backToScore:(id)sender {
    /*if ([self nTag] == 1) {
        ScoreViewController *scoreController=[[ScoreViewController alloc]init];
        scoreController.sections = self.sections;
        scoreController.sheetItems = self.sheetItems;
        scoreController.sIndex = [NSString stringWithFormat: @"%d", nIndex];
        scoreController.markSheets = self.markSheets;
        scoreController.dataMarkSheet = self.dataMarkSheet;
        scoreController.imgPath = [self imgPath];
        [self presentViewController:scoreController animated:YES completion:nil];
    } else {
        //return mainview
        MainViewController *mainController=[[MainViewController alloc]init];
        [self presentViewController:mainController animated:YES completion:nil];
        
    }*/
    
    TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.gImgPath = [self imgPath];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

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


-(void) addScoreInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    
    NSString * strJson = [self getJsonFromDict:[self dataMarkSheet]];
    if (strJson == nil) {
        return;
    }
    float nSum = [self getSum];
    int nScore = nSum;
    
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    LoginInfoType *info = appDelegate.gLoginItem;
    [params setObject:info.E_ID forKey:@"E_ID"];
    [params setObject:info.ES_ID forKey:@"ES_ID"];
    [params setObject:info.Room_ID forKey:@"Room_ID"];
    [params setObject:appDelegate.gStudentId forKey:@"Student_ID"];
    [params setObject:info.U_ID forKey:@"Rater_ID"];
    [params setObject:[NSString stringWithFormat:@"%d",nScore] forKey:@"SI_Score"];//因为数据库字段未int
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
                                                  [appDelegate.gStudentScores addObject:temp];
                                                  
                                                  //modify student state
                                                  float nSum = [self getSum];
                                                  for (Student *obj in appDelegate.gStudnetArray) {
                                                      if ([obj.U_ID isEqualToString:appDelegate.gStudentId]) {
                                                          obj.student_state = [NSString stringWithFormat: @"%d", HaveScored];
                                                          obj.student_score = [NSString stringWithFormat: @"%0.1f", nSum];
                                                          break;
                                                      }
                                                  }
                                                  
                                                  //return mainview
                                                  
                                                  //MainViewController *mainController=[[MainViewController alloc]init];
                                                  //[self presentViewController:mainController animated:YES completion:nil];
                                                  
                                                  //[[self ] dismissViewControllerAnimated:YES completion:nil];
                                                  
                                                  
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

-(float)getSum {
    float nSum = 0.0;
    for (NSArray *obj in [_sheetItems objectAtIndex:nIndex]) {
        for (MarkSheetItem *item in obj) {
            nSum += [item.Item_Score floatValue];
        }
    }
    return nSum;
}

-(float)getTotalSum {
    float nSum = 0.0;
    for (NSArray *obj in [_sheetItems objectAtIndex:nIndex]) {
        for (MarkSheetItem *item in obj) {
            nSum += [item.MSI_Score floatValue];
        }
    }
    return nSum;
}

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
                [childItem setValue:markItem.Item_Score forKey:@"MSI_Score"];
                [childItem removeObjectForKey:@"MSI_Item"];
            }
            
        }else if ([[dicItems allKeys] containsObject:@"MSI_Score"]){
            MarkSheetItem *markItem = (MarkSheetItem *)[self.sheetItems[nIndex][j] objectAtIndex:0];
            [dicItems setValue:markItem.Item_Score forKey:@"MSI_Score"];
            [dicItems removeObjectForKey:@"MSI_Item"];
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

-(void)savePic:(UIImage *)image
{
    NSString *uuidFile = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
    _imgPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:uuidFile];
    //保存png的图片到app下的Document/
    [UIImagePNGRepresentation(image) writeToFile:_imgPath atomically:YES];
}

@end
