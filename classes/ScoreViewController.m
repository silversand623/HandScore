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
#import "UIButton+Bootstrap.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "TYAppDelegate.h"
#import "Student.h"
#import "LoginViewController.h"


#define SCORECELLID @"ScoreCell"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

int nCount = 0;

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
    UINib *nib = [UINib nibWithNibName:@"ScoreTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:SCORECELLID];
    
    self.tableView.rowHeight = 60;
    _comView = [[ComboxView alloc] initWithFrame:CGRectMake(712, 80, 140, 100)];
    [self.view addSubview:_comView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeWindow) name:@"closeView" object:nil];
    
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
    }
    
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

-(void)closeComboxView {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
                                                  self.dataMarkSheet = obj;
                                                  NSArray *mark_list = [obj objectForKey:@"mark_sheet_list"];
                                                  for (int i=0; i<mark_list.count; i++) {
                                                      [self.sheetItems addObject:[NSMutableArray array]];
                                                      [self.sections addObject:[NSMutableArray array]];
                                                      NSDictionary *dicList = [mark_list objectAtIndex:i];
                                                      [self.markSheets addObject:[[dicList objectForKey:@"MS_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                                      NSArray *mark_sheet_items = [dicList objectForKey:@"item_list"];
                                                      for (int j=0; j<mark_sheet_items.count; j++) {
                                                          NSDictionary *dicItems = [mark_sheet_items objectAtIndex:j];
                                                          if ([[dicItems allKeys] containsObject:@"children_item_list"]) {
                                                              NSArray *children_list = [dicItems objectForKey:@"children_item_list"];
                                                              NSMutableArray* markItems = [RMMapper mutableArrayOfClass:[MarkSheetItem class]
                                                                                                  fromArrayOfDictionary:children_list];
                                                              [self.sections[i] addObject:([dicItems objectForKey:@"MSI_Item"])];
                                                              [self.sheetItems[i] addObject:[NSMutableArray array]];
                                                              for (int n=0; n<markItems.count; n++) {
                                                                  [self.sheetItems[i][j] addObject:markItems[n]];
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
                                                  [[self tableView] reloadData];
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
    
    id obj = _sheetItems[nCount][indexPath.section];
    MarkSheetItem *item = (MarkSheetItem*) [obj objectAtIndex:indexPath.row];
    
    // 該行要顯示的內容
    NSString *content = [item.MSI_Item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000.0f) lineBreakMode:NSLineBreakByWordWrapping];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_sections.count > 0) {
        return [_sections[nCount][section] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
    
    ScoreTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SCORECELLID forIndexPath:indexPath];
    //add event
    [cell.Rating addTarget:self action:@selector(slidderChanged:) forControlEvents:UIControlEventValueChanged];
    //add click event
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [cell.Rating addGestureRecognizer:gr];
    
    [cell.stepValue addTarget:self action:@selector(StepperChanged:) forControlEvents:UIControlEventValueChanged];
    
    MarkSheetItem *item = nil;
    if (_sheetItems.count > 0) {
        id obj = _sheetItems[nCount][indexPath.section];
        item = (MarkSheetItem*) [obj objectAtIndex:indexPath.row];
        cell.ScoreValue.text = item.MSI_Score;
        
        //resize the height of label
        NSString *content = [item.MSI_Item stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        CGRect rect = cell.ScoreItem.frame;
        rect.size.height = [self getLabelHeight:indexPath];
        [cell.ScoreItem setFrame:rect];
        [cell.ScoreItem setText:content];
        //
        if (item.rating_value != nil) {
            cell.Rating.value = [item.rating_value floatValue];
            cell.FinalScore.text = item.Item_Score;
            cell.stepValue.value = [item.step_value doubleValue];
        }else {
            cell.Rating.value = 0.0;
            cell.FinalScore.text = nil;
            cell.stepValue.value = 0.0;
        }
        
    }else{
        cell.Rating.value = 0.0;
        cell.FinalScore.text = nil;
        cell.stepValue.value = 0.0;
    }
    
    
    return cell;
    
    
}

- (void) tapped: (UITapGestureRecognizer*) g {
    UISlider* sender = (UISlider*)g.view;
    if (sender.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: sender];
    CGFloat percentage = pt.x / sender.bounds.size.width;
    CGFloat delta = percentage * (sender.maximumValue - sender.minimumValue);
    CGFloat value = sender.minimumValue + delta;
    [sender setValue:value];
    
    ScoreTableViewCell *cell = (ScoreTableViewCell*)[[[sender superview] superview]superview];
    double stepValue = 1.0;
    int score = [cell.ScoreValue.text integerValue];
    float nValue = floorf((sender.value*score)/stepValue);
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
    cell.stepValue.value = nValue;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    item.rating_value = [NSString stringWithFormat:@"%.2f", sender.value];
    item.Item_Score = [NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue];
    item.step_value = [NSString stringWithFormat:@"%.f", nValue];
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
    
}

- (void)slidderChanged:(UISlider*)sender {
    ScoreTableViewCell *cell = (ScoreTableViewCell*)[[[sender superview] superview]superview];
    double stepValue = 1.0;
    int score = [cell.ScoreValue.text integerValue];
    float nValue = floorf((sender.value*score)/stepValue);
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
    cell.stepValue.value = nValue;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    item.rating_value = [NSString stringWithFormat:@"%.2f", sender.value];
    item.Item_Score = [NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue];
    item.step_value = [NSString stringWithFormat:@"%.f", nValue];
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", floorf(nValue)*stepValue]];
}

- (void)StepperChanged:(UIStepper *)sender {
    ScoreTableViewCell *cell = (ScoreTableViewCell*)[[[sender superview] superview] superview];
    double stepValue = 1.0;
    int score = [cell.ScoreValue.text integerValue];
    sender.value = MIN(score/stepValue, sender.value);
    cell.Rating.value = sender.value*stepValue/score;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    MarkSheetItem *item = (MarkSheetItem*) [_sheetItems[nCount][path.section] objectAtIndex:path.row];
    item.rating_value = [NSString stringWithFormat:@"%.2f", cell.Rating.value];
    item.Item_Score = [NSString stringWithFormat:@"%.1f", sender.value*stepValue];
    item.step_value = [NSString stringWithFormat:@"%.f", sender.value];
    [cell.FinalScore setText:[NSString stringWithFormat:@"%.1f", sender.value*stepValue]];
}

- (IBAction)previewScore:(id)sender {
    BOOL bValue = NO;
    for (NSArray *obj in self.sheetItems[nCount]) {
        for (MarkSheetItem *item in obj) {
            if (item.Item_Score == nil){
                bValue = YES;
                break;
            }
        }
        if (bValue) {
            break;
        }
    }
    
    if (bValue) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"有未完成打分项" message:@"还有未打分项，请完成打分再预览" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    previewController.imgPath = appDelegate.gImgPath;
    appDelegate.gImgPath = nil;
    [self presentViewController:previewController animated:YES completion:nil];
    
}

- (IBAction)returnMainview:(UIButton *)sender {
    NSString * str = @"请确认是否返回主界面，如果确定则当前评分记录会丢失。";
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"确认返回主界面" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil ] ;
    
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        //MainViewController *mainController=[[MainViewController alloc]init];
        //[self presentViewController:mainController animated:YES completion:nil];
        TYAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.gImgPath = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
