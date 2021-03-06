//
//  MainViewController.m
//  HandScore
//
//  Created by lyn on 14-8-21.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "MainViewController.h"
#import "UMTableViewCell.h"
#import "WTRequestCenter.h"
#import "LoginInfoType.h"
#import "RMMapper.h"
#import "Student.h"
#import "CustomIOS7AlertView.h"
#import "ScoreViewController.h"
#import "UIButton+Bootstrap.h"
#import "TYAppDelegate.h"
#import "LoginViewController.h"
#import "PreviewController.h"
#import "MBProgressHUD.h"

#define PAGECOUNT @"1000"
#define CUSTOMCELLID @"UMCell"

@implementation MainViewController
{
    LoginInfoType *loginItem;
    NSMutableArray *StudentArray;
    NSMutableArray *FilterStudentArray;
    NSArray *StatusArray;
    MBProgressHUD *HUD;
}
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
    //[self.tableView registerClass :[UMTableViewCell class] forCellReuseIdentifier:@"UMCell"];
    UINib *nib = [UINib nibWithNibName:@"UMTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:CUSTOMCELLID];
    //[self.exitBtn grayStyle];
    
    self.tableView.rowHeight = 60;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    }
    
    StudentArray = [[NSMutableArray alloc] init];
    FilterStudentArray = [[NSMutableArray alloc] init];
    StatusArray = [[NSArray alloc] initWithObjects:@"未定义",@"缺考",@"已考",@"未考",nil];
    
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    LoginInfoType *info = appDelegate.gLoginItem;
    if (info != nil) {
        [[self ExamName] setText:[info.E_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[self StationName] setText:[info.ES_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[self RoomName] setText:[info.Room_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[self ScoreItems] setText:[info.mark_sheet_count stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (appDelegate.gStudnetArray.count > 0) {
        int nIndex = appDelegate.gSegSelectedIndex;
        [[self filterSegment] setSelectedSegmentIndex:nIndex];
        FilterStudentArray = appDelegate.gStudnetArray;
        StudentArray = [self getStudentArray:nIndex];
        [self updateSegment];
    }else{
        loginItem = appDelegate.gLoginItem;
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HUD setLabelText:@"正在加载学生信息"];
        
        [self getStudentInfo];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    StudentArray = [self getStudentArray:[self.filterSegment selectedSegmentIndex]];
    [self updateSegment];
    [[self tableView] reloadData];
}

-(void) getStudentInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        
    
    [params setObject:loginItem.E_ID forKey:@"E_ID"];
    [params setObject:loginItem.ES_ID forKey:@"ES_ID"];
    [params setObject:loginItem.Room_ID forKey:@"Room_ID"];
    [params setObject:loginItem.U_ID forKey:@"U_ID"];
    //[params setObject:self.loginItem.EU_ID forKey:@"EU_ID"];
    //[params setObject:self.loginItem.ESR_ID forKey:@"ESR_ID"];
    [params setObject:@"1" forKey:@"search_type"];
    [params setObject:@"" forKey:@"search_keyword"];
    [params setObject:@"1" forKey:@"page_index"];
    [params setObject:PAGECOUNT forKey:@"page_size"];
    //[params setObject:@"1" forKey:@"test"];
    
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchStudentInfo"];
    NSURL *TempUrl = [NSURL URLWithString:url];
    
    [WTRequestCenter postWithoutCacheURL:TempUrl
                      parameters:params completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                          if (!error) {
                              NSError *jsonError = nil;
                              [HUD hide:YES];
                              id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                              id objList = [obj objectForKey:@"student_list"];
                              if (!jsonError) {
                                  ///
                                  NSString *str = [obj objectForKey:@"result"];
                                  if (str != nil) {
                                      int nRestult = [self dealError:str];
                                      if (nRestult == Success) {
                                          NSMutableArray* logInfo = [RMMapper mutableArrayOfClass:[Student class]
                                                                            fromArrayOfDictionary:objList];
                                          for (int i=0;i<logInfo.count;i++){
                                              [FilterStudentArray addObject:logInfo[i]];
                                              
                                          }
                                          
                                          TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
                                          appDelegate.gStudnetArray = FilterStudentArray;
                                          [[self filterSegment] setSelectedSegmentIndex:0];
                                          StudentArray = [self getStudentArray:0];
                                          [self updateSegment];
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
                              [HUD hide:YES];
                              UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                              [alert show];                          }
                          
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return StudentArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %ld:%ld", (long)indexPath.section, (long)indexPath.row);
    NSLog(@"selected cell index path is %@", [self.tableView indexPathForSelectedRow]);
    
    if (!tableView.isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - UIScrollViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UMTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CUSTOMCELLID forIndexPath:indexPath];
    
    // optionally specify a width that each set of utility buttons will share
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:90.0f];
    
    
    cell.delegate = self;
    if (indexPath.row < StudentArray.count) {
        Student *studentInfo = StudentArray[indexPath.row];
        cell.labelTime.text = studentInfo.Exam_StartTime;
        cell.labelExamNo.text = studentInfo.EStu_ExamNumber;
        cell.labelStudentNo.text = studentInfo.U_Name;
        cell.labelName.text = [studentInfo.U_TrueName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        cell.labelStatus.text = [StatusArray objectAtIndex:([studentInfo.student_state intValue])];
        cell.labelScore.text = studentInfo.student_score;
        cell.labelClassName.text = [studentInfo.O_Name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        int nButton = [studentInfo.student_state intValue];
        [cell setRightUtilityButtons:[self rightButtons:nButton] WithButtonWidth:90.0f];
        
        //display student photo
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
        NSString *url=@"http://";
        url=[url stringByAppendingString:BaseUrl];
        url=[url stringByAppendingFormat:@"/AppDataInterface/HandScore.aspx/SearchStudentPhoto?U_ID=%@",studentInfo.U_ID];
        NSURL *TempUrl = [NSURL URLWithString:url];
        [WTRequestCenter getImageWithURL:TempUrl completionHandler:^(UIImage *image) {
            if (image != nil) {
                cell.image.image = image;
            }
            else {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"studentphoto" ofType:@"png"];
                cell.image.image = [UIImage imageWithContentsOfFile:path];
            }
            
        }];
    }
    if ((indexPath.row%2) == 0) {
        //cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        //cell.contentView.backgroundColor = [UIColor cyanColor];
    }
    
    return cell;

    
}

- (NSArray *)rightButtons:(NSInteger) count
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    switch (count) {
        case AbsenceExam:
        {
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             //[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
             [UIColor colorWithRed:52.0/255.0 green:158.0/255.0 blue:201.0/255.0 alpha:1.0]
                                                        title:@"评分"];
            
            break;
        }
        case HaveScored:
        {
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             //[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
             [UIColor colorWithRed:52.0/255.0 green:158.0/255.0 blue:201.0/255.0 alpha:1.0]
                                                        title:@"查看"];
            
            break;
        }
        case NoScore:
        {
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             //[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
             [UIColor colorWithRed:52.0/255.0 green:158.0/255.0 blue:201.0/255.0 alpha:1.0]
                                                        title:@"评分"];
            [rightUtilityButtons sw_addUtilityButtonWithColor:
             [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                        title:@"缺考"];
            break;
        }
            
        default:
            break;
    }
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                               title:@"照片"];
    return leftUtilityButtons;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want default white
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"left button 0 was pressed");
            //NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            //cell.imageView.image
            // Here we need to pass a full frame
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
            
            // Add some custom content to the alert view
            [alertView setContainerView:[self createImageView:cell]];
            
            // Modify the parameters
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"关闭", nil]];
            //[alertView setDelegate:self];
            
            // You may use a Block, rather than a delegate.
            [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
                [alertView close];
            }];
            
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (UIView *)createImageView:(SWTableViewCell *)cell
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 160, 160)];
    [imageView setImage:((UMTableViewCell*)cell).image.image];
    [demoView addSubview:imageView];
    
    return demoView;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    UIButton *obj = [[cell rightUtilityButtons] objectAtIndex:index];
    int ncount = -1;
    
    if ([obj.currentTitle isEqualToString:@"查看"]) {
        ncount=HaveScored;
    }else if ([obj.currentTitle isEqualToString:@"评分"])
    {
        ncount=NoScore;
    }else if ([obj.currentTitle isEqualToString:@"缺考"])
    {
        ncount=AbsenceExam;
    }
    
    [cell hideUtilityButtonsAnimated:YES];
    
    switch (ncount) {
        case HaveScored:
        {
            TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
            NSIndexPath *nsPath = [[self tableView] indexPathForCell:cell];
            Student *Info = (Student *)StudentArray[nsPath.row];
            appDelegate.gStudentId = Info.U_ID;
            
            PreviewController *previewController=[[PreviewController alloc]init];
            previewController.nTag = 2;
            [self presentViewController:previewController animated:YES completion:nil];
            break;
        }
        case NoScore:
        {
            TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
            NSIndexPath *nsPath = [[self tableView] indexPathForCell:cell];
            Student *Info = (Student *)StudentArray[nsPath.row];
            appDelegate.gStudentId = Info.U_ID;
            ScoreViewController *scoreViewController=[[ScoreViewController alloc]init];
            scoreViewController.loginItem = appDelegate.gLoginItem;
            [self presentViewController:scoreViewController animated:YES completion:nil];
            break;
        }
        case AbsenceExam:
        {
            //register exam status
            
            NSIndexPath *nsPath = [[self tableView] indexPathForCell:cell];
            
            TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
            Student *Info = (Student *)StudentArray[nsPath.row];
            for (Student *obj in appDelegate.gStudnetArray) {
                if ([obj.U_ID isEqualToString:Info.U_ID]) {
                    obj.student_state = [NSString stringWithFormat:@"%d",AbsenceExam];
                    //update student status
                    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [HUD setLabelText:@"正在提交缺考"];
                    [self updateStudentState:obj];
                }
            }
            FilterStudentArray = appDelegate.gStudnetArray;
            StudentArray = [self getStudentArray:_filterSegment.selectedSegmentIndex];
            [[self tableView] reloadData];
            
            break;
        }
        default:
            break;
    }
}

-(void) updateStudentState:(Student *)obj
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    LoginInfoType *info = appDelegate.gLoginItem;
    [params setObject:info.E_ID forKey:@"E_ID"];
    [params setObject:info.ES_ID forKey:@"ES_ID"];
    [params setObject:info.Room_ID forKey:@"Room_ID"];
    [params setObject:info.U_ID forKey:@"U_ID"];
    [params setObject:obj.U_ID forKey:@"Student_U_ID"];
    [params setObject:info.EU_ID forKey:@"EU_ID"];
    
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/AddScoreInfoWithMiss"];
    NSURL *TempUrl = [NSURL URLWithString:url];
    
    [WTRequestCenter postWithoutCacheURL:TempUrl
                              parameters:params completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                  if (!error) {
                                      NSError *jsonError = nil;
                                      [HUD hide:YES afterDelay:1];
                                      
                                      id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                                      if (!jsonError) {
                                          ///
                                          NSString *str = [obj objectForKey:@"result"];
                                          if (str != nil) {
                                              int nResult = [self dealError:str];
                                              if (nResult == Success) {
                                                  ///
                                                  
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
                                      [HUD hide:YES];
                                      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"网络连接错误" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                      [alert show];
                                      NSLog(@"error:%@",error);
                                  }
                                  
                              }];
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return YES;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

-(NSMutableArray *)getStudentArray:(int) nIndex
{
    NSMutableArray *filter = [[NSMutableArray alloc] init];
    
    switch (nIndex) {
        case 0:
        {
            for (int i = 0;i<FilterStudentArray.count;i++)
            {
                Student *info = (Student *)[FilterStudentArray objectAtIndex:i];
                int nState = [info.student_state integerValue];
                if (nState != HaveScored) {
                    [filter addObject:[FilterStudentArray objectAtIndex:i]];
                }
            }
            break;
        }
        case 1:
        {
            for (int i = 0;i<FilterStudentArray.count;i++)
            {
                Student *info = (Student *)[FilterStudentArray objectAtIndex:i];
                int nState = [info.student_state integerValue];
                if (nState == HaveScored) {
                    [filter addObject:[FilterStudentArray objectAtIndex:i]];
                }
            }
            break;
        }
        default:
        {
            filter = FilterStudentArray;
            break;
        }
    }
    return filter;
}

- (IBAction)filterStudent:(UISegmentedControl *)sender {
    
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.gSegSelectedIndex = sender.selectedSegmentIndex;
    StudentArray = [self getStudentArray:sender.selectedSegmentIndex];
    [self.tableView reloadData];

}

- (IBAction)exitMainview:(UIButton *)sender {
    //clear global var
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.gLoginItem = nil;
    [appDelegate.gStudnetArray removeAllObjects];
    [appDelegate.gStudentScores removeAllObjects];
    appDelegate.gStudnetArray = nil;
    appDelegate.gStudentScores = nil;
    appDelegate.gStudentId = nil;
    appDelegate.gSegSelectedIndex = 0;
    appDelegate.gImgPath = nil;
    //LoginViewController *loginController=[[LoginViewController alloc]init];
    //[self presentViewController:loginController animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateSegment {
    int nHaveScore = 0;
    int nAll = 0;
    TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    nAll = appDelegate.gStudnetArray.count;
    for (Student *obj in appDelegate.gStudnetArray) {
        if ([obj.student_state isEqualToString:@"2"]) {
            nHaveScore++;
        }
    }
    [[self filterSegment] setTitle:[NSString stringWithFormat:@"未评分(%d人)",nAll-nHaveScore] forSegmentAtIndex:0];
    [[self filterSegment] setTitle:[NSString stringWithFormat:@"已评分(%d人)",nHaveScore] forSegmentAtIndex:1];
    [[self filterSegment] setTitle:[NSString stringWithFormat:@"全部(%d人)",nAll] forSegmentAtIndex:2];
}

@end
