//
//  ScoreTableViewController.m
//  HandScore
//
//  Created by lyn on 14-5-12.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "ScoreTableViewController.h"
#import "SelectTableViewController.h"
#import "PreviewViewController.h"
#import "LoginViewController.h"
#import "Scorecell.h"
#import "TYAppDelegate.h"

@interface ScoreTableViewController ()

@end

@implementation ScoreTableViewController
#define kMaxLength 20
static NSString *CellTalbeIdentifier=@"CellTableIdentifier";
UIButton *btna;
UIButton *btnb;
UIButton *btnc;
NSString *size;
int oo;
int selectsize;
int prewTag ;  //编辑上一个UITextField的TAG,需要在XIB文件中定义或者程序中添加，不能让两个控件的TAG相同
float prewMoveY;
UITableViewCell *cell3;
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
    [self setlayout];
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    if(_previewreturn){
               _computers=delegate.update;
    }else{
//        if(delegate.update!=nil){
//            _computers=delegate.update;
//        }
//    self.computers=@[@{@"Id" : @"1",@"Content" : @"主诉倾听，现病史了解 ",@"Score" : @"10",@"Size":@"18.0f"},@{@"Id" : @"2",@"Content" : @"询问诊疗及检查情况，治疗效果 ",@"Score" : @"10",@"Size":@"18.0f"},@{@"Id" : @"3",@"Content" : @"询问过敏史、预防接种史 ",@"Score" : @"8",@"Size":@"18.0f"},@{@"Id" : @"4",@"Content" : @"是否围绕病情展开问询 ",@"Score" : @"6",@"Size":@"18.0f"},@{@"Id" : @"5",@"Content" : @"问诊态度是否认真，沟通是否礼貌 ",@"Score" : @"8",@"Size":@"18.0f"},];
    }
    _tableview=(id)[self.view viewWithTag:1];
    //tableView.rowHeight=65;
//    UINib *nib=[UINib nibWithNibName:@"Scorecell" bundle:nil];
//    [_tableview registerNib:nib forCellReuseIdentifier:CellTalbeIdentifier];
    btna=[[UIButton alloc]init];
    btnb=[[UIButton alloc]init];
    btnc=[[UIButton alloc]init];
    [btna setTitle:@"大" forState:UIControlStateNormal];
 [btnb setTitle:@"中" forState:UIControlStateNormal];
     [btnc setTitle:@"小" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnb setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnc setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btna addTarget:self action:@selector(largefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnb addTarget:self action:@selector(middlefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnc addTarget:self action:@selector(smallfont:) forControlEvents:UIControlEventTouchUpInside];
       btna.frame=CGRectMake(865,77,49,49);
    btnb.frame=CGRectMake(922,80,42,42);
    btnc.frame=CGRectMake(972,80,42,42);
   
    [btna setBackgroundImage:[UIImage imageNamed:@"fontbtnb"] forState:UIControlStateNormal];
    [btnb setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [btnc setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [self.view addSubview:btna];
    [self.view addSubview:btnb];
    [self.view addSubview:btnc];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    SelectTableViewController *selecttableviewController=[[SelectTableViewController alloc]init];
    [self presentViewController:selecttableviewController animated:YES completion:nil];
}
- (void)loginback{
    LoginViewController *loginviewController=[[LoginViewController alloc]init];
    [self presentViewController:loginviewController animated:YES completion:nil];

}
- (IBAction)preview:(id)sender {
    PreviewViewController *previewController=[[PreviewViewController alloc]init];
  TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    if(delegate.update==nil){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"请进行完评分在进入预览界面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        int num = 0;int sum=0;
        NSMutableArray *newarray = [delegate.update mutableCopy];
        for(int i=0;i<[newarray count];i++){
            // NSArray *oldArray = (NSArray *)[newarray objectAtIndex:i];
            NSMutableDictionary *rowData=newarray[i];
           NSMutableDictionary *array1=rowData[@"GetScore"];
            NSArray *array=rowData[@"MSI_Score"];
            sum+=[array count];
            num+=[array1 count];
        }
        if(num!=sum){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"请进行完评分在进入预览界面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            previewController.computers=delegate.update;
    NSLog(@"%@",delegate.update);
            [self presentViewController:previewController animated:YES completion:nil];
        }
    }
 
}

- (IBAction)largefont:(id)sender {
    [btna removeFromSuperview];
    [btnb removeFromSuperview];
    [btnc removeFromSuperview];
   btna=[[UIButton alloc]init];
     btnb=[[UIButton alloc]init];
     btnc=[[UIButton alloc]init];
    btna.frame=CGRectMake(865,77,49,49);
    btnb.frame=CGRectMake(922,80,42,42);
    btnc.frame=CGRectMake(972,80,42,42);
    [btna setBackgroundImage:[UIImage imageNamed:@"fontbtnb"] forState:UIControlStateNormal];
    [btnb setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [btnc setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [btna setTitle:@"大" forState:UIControlStateNormal];
    [btnb setTitle:@"中" forState:UIControlStateNormal];
    [btnc setTitle:@"小" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnb setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnc setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btna addTarget:self action:@selector(largefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnb addTarget:self action:@selector(middlefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnc addTarget:self action:@selector(smallfont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btna];
    [self.view addSubview:btnb];
    [self.view addSubview:btnc];
    selectsize=20;
    NSMutableArray *newarray = [self.computers mutableCopy];
    for(int i=0;i<[newarray count];i++){
        NSMutableDictionary *rowData=newarray[i];
        NSArray *array=rowData[@"MSI_Score"];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
       UITableViewCell *cell = (UITableViewCell *)[_tableview viewWithTag:20+i+1];


        for (int j=0; j<[array count]; j++) {
                       UILabel *label=(UILabel *)[cell viewWithTag:10+i+1];
            label.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            UITextField *textfield=(UITextField *)[cell viewWithTag:j+1];
            UILabel *label1=(UILabel *)[cell viewWithTag:700+j+1];
           UILabel *label2=(UILabel *)[cell viewWithTag:800+j+1];
            textfield.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label1.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            [defaults setObject:@"20" forKey:@"size"];
            [defaults synchronize];
        }}
//     self.computers=newarray;
//    [_tableview reloadData];
//
//    [_tableview reloadInputViews];
//    self.methodid.font=[UIFont systemFontOfSize:18.0f];
//   self.methodcontent.font=[UIFont systemFontOfSize:18.0f];
//    self.methodscore.font=[UIFont systemFontOfSize:18.0f];
//    self.methodgetscore.font=[UIFont systemFontOfSize:18.0f];
//    self.methodwritemessage.font=[UIFont systemFontOfSize:18.0f];
   }

- (IBAction)middlefont:(id)sender {
    [btna removeFromSuperview];
    [btnb removeFromSuperview];
    [btnc removeFromSuperview];
    btna=[[UIButton alloc]init];
    btnb=[[UIButton alloc]init];
    btnc=[[UIButton alloc]init];
    [btna setFrame:CGRectMake(865,80,42,42)];
    [btnb setFrame:CGRectMake(917,77,49,49)];
    [btnc setFrame:CGRectMake(972,80,42,42)];
    [btna setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [btnb setBackgroundImage:[UIImage imageNamed:@"fontbtnb"] forState:UIControlStateNormal];
    [btnc setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [btna setTitle:@"大" forState:UIControlStateNormal];
    [btnb setTitle:@"中" forState:UIControlStateNormal];
    [btnc setTitle:@"小" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnb setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnc setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btna addTarget:self action:@selector(largefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnb addTarget:self action:@selector(middlefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnc addTarget:self action:@selector(smallfont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btna];
    [self.view addSubview:btnb];
    [self.view addSubview:btnc];
    selectsize=17;
    NSMutableArray *newarray = [self.computers mutableCopy];
    for(int i=0;i<[newarray count];i++){
        NSMutableDictionary *rowData=newarray[i];
        NSArray *array=rowData[@"MSI_Score"];
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
       UITableViewCell *cell = (UITableViewCell *)[_tableview viewWithTag:20+i+1];

        for (int j=0; j<[array count]; j++) {
           
            UILabel *label=(UILabel *)[cell viewWithTag:10+i+1];
            label.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
            UITextField *textfield=(UITextField *)[cell viewWithTag:j+1];
            UILabel *label1=(UILabel *)[cell viewWithTag:700+j+1];
            UILabel *label2=(UILabel *)[cell viewWithTag:800+j+1];
            textfield.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
            label1.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:17];
            [defaults setObject:@"17" forKey:@"size"];
            [defaults synchronize];

    }
    }
//    self.computers=newarray;
//    [_tableview reloadData];
//    [_tableview reloadInputViews];
//    self.methodid.font=[UIFont systemFontOfSize:16.0f];
//    self.methodcontent.font=[UIFont systemFontOfSize:16.0f];
//    self.methodscore.font=[UIFont systemFontOfSize:16.0f];
//    self.methodgetscore.font=[UIFont systemFontOfSize:16.0f];
//    self.methodwritemessage.font=[UIFont systemFontOfSize:16.0f];
}

- (IBAction)smallfont:(id)sender {
    [btna removeFromSuperview];
    [btnb removeFromSuperview];
    [btnc removeFromSuperview];
    btna=[[UIButton alloc]init];
    btnb=[[UIButton alloc]init];
    btnc=[[UIButton alloc]init];
    [btna setFrame:CGRectMake(865,80,42,42)];
    [btnb setFrame:CGRectMake(922,80,42,42)];
    [btnc setFrame:CGRectMake(977,77,49,49)];
    [btna setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [btnb setBackgroundImage:[UIImage imageNamed:@"fontbtna"] forState:UIControlStateNormal];
    [btnc setBackgroundImage:[UIImage imageNamed:@"fontbtnb"] forState:UIControlStateNormal];
    [btna setTitle:@"大" forState:UIControlStateNormal];
    [btnb setTitle:@"中" forState:UIControlStateNormal];
    [btnc setTitle:@"小" forState:UIControlStateNormal];
    [btna setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnb setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnc setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btna addTarget:self action:@selector(largefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnb addTarget:self action:@selector(middlefont:) forControlEvents:UIControlEventTouchUpInside];
    [btnc addTarget:self action:@selector(smallfont:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btna];
    [self.view addSubview:btnb];
    [self.view addSubview:btnc];
    selectsize=14;
    NSMutableArray *newarray = [self.computers mutableCopy];
    for(int i=0;i<[newarray count];i++){
        //NSArray *oldArray = (NSArray *)[newarray objectAtIndex:i];
        NSMutableDictionary *rowData=newarray[i];
       NSArray *array=rowData[@"MSI_Score"];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
      //  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [defaults setObject:@"14" forKey:@"size"];
        [defaults synchronize];
       // NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",  i];//以indexPath来唯一确定cell
        UITableViewCell *cell = (UITableViewCell *)[_tableview viewWithTag:20+i+1];
        for (int j=0; j<[array count]; j++) {
          
            UILabel *label=(id)[cell viewWithTag:10+i+1];
            label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
          UITextField *textfield=(UITextField *)[cell viewWithTag:j+1];
            UILabel *label1=(id)[cell viewWithTag:700+j+1];
            UILabel *label2=(id)[cell viewWithTag:800+j+1];
            textfield.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
                       label1.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        }
        }
//        NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
//        [rowData1 setObject:rowData[@"Id"] forKey:@"Id"];
//        [rowData1 setObject:rowData[@"Content"] forKey:@"Content"];
//        [rowData1 setObject:rowData[@"Score"] forKey:@"Score"];
//        [rowData1 setObject:@"14.0f" forKey:@"Size"];
        //NSMutableArray *newArray=@[rowData1];
        //[newarray replaceObjectAtIndex:i withObject:rowData1];
   // }
//     self.computers=newarray;
//       [_tableview reloadData];
//    [_tableview reloadInputViews];
//    self.methodid.font=[UIFont systemFontOfSize:14.0f];
//    self.methodcontent.font=[UIFont systemFontOfSize:14.0f];
//    self.methodscore.font=[UIFont systemFontOfSize:14.0f];
//    self.methodgetscore.font=[UIFont systemFontOfSize:14.0f];
//    self.methodwritemessage.font=[UIFont systemFontOfSize:14.0f];

}

- (void)setlayout{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
     self.appuser.text=[NSString stringWithFormat:@"你好，%@",[defaults objectForKey:@"TrueName"]];
    self.appuser.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.appuser.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    NSMutableAttributedString *hyperlink=[[NSMutableAttributedString alloc]initWithString:@"退出"];
    NSRange selecr={0,[hyperlink length]};
    [hyperlink beginEditing];
    [hyperlink addAttribute:NSForegroundColorAttributeName
                      value:[UIColor colorWithRed:37.0/255 green:242.0/255 blue:1.0f alpha:1.0f] // 更改颜色
                      range:selecr];
    [hyperlink addAttribute:NSUnderlineStyleAttributeName
                      value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] // 添加下化线
                      range:selecr];
    [hyperlink addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:20.0]
                      range:selecr];
    [hyperlink endEditing];
    self.labellogout.attributedText=hyperlink;
    UITapGestureRecognizer *tapRecongizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginback)];
    self.labellogout.userInteractionEnabled=YES;
    [self.labellogout addGestureRecognizer:tapRecongizer];
    self.examname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.examname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.examname.text=@"考试名：";
    self.showexamname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showexamname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showexamname.text=[defaults objectForKey:@"examname"];;
    self.examclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.examclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.examclassnum.text=@"考站：";
    self.showexamclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showexamclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showexamclassnum.text=[defaults objectForKey:@"ES_Name"];
    self.studentexamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamnum.text=@"学生考号：";
    self.showstudentexamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamnum.text=[defaults objectForKey:@"studentcode"];
    self.scoretable.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.scoretable.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.scoretable.text=@"评分表：";
    self.showscoretable.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showscoretable.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showscoretable.text=[defaults objectForKey:@"Table_Name"];
    self.methodid.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methodid.font=[UIFont systemFontOfSize:18.0];
    self.methodid.text=@"步骤";
    self.methodcontent.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methodcontent.font=[UIFont systemFontOfSize:18.0];
    self.methodcontent.text=@"内容";
    self.methodscore.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methodscore.font=[UIFont systemFontOfSize:18.0];
    self.methodscore.text=@"分值";
    self.methodgetscore.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methodgetscore.font=[UIFont systemFontOfSize:18.0];
    self.methodgetscore.text=@"得分";
    self.methodwritemessage.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methodwritemessage.font=[UIFont systemFontOfSize:18.0];
    self.methodwritemessage.text=@"评论";
    self.labelfont.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.labelfont.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.labelfont.text=@"字号";
     self.showcolor.backgroundColor=[UIColor colorWithRed:21.0/255 green:162.0/255 blue:213.0/255 alpha:1.0f];
                               
}
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.computers count];
}
//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
//  cell = [tableView cellForRowAtIndexPath:indexPath];
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",  [indexPath row]];//以indexPath来唯一确定cell
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];//以indexPath来唯一确定cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];     if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
         cell.tag=20+indexPath.row+1;
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        NSDictionary *rowData;
        if(delegate.update==nil){
            rowData=self.computers[indexPath.row];
        }else{
            rowData=delegate.update[indexPath.row];
            NSLog(@"%d",2222222);
        }
        //_indexpath=indexPath.row;
        // cell.computers=self.computers;
        _id=[rowData[@"MSI_ItemName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _content=rowData[@"MSI_Item"];
        _score=rowData[@"MSI_Score"];
        // cell.size=rowData[@"Size"];
        _value=rowData[@"GetScore"];
        _flag=rowData[@"Flag"];
        _commet=rowData[@"Commet"];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        int size;
        if(selectsize==0){
             size=20;
        }else{
            size=selectsize;
        }
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardHide:)
//                                                     name:UIKeyboardWillHideNotification
//                                                   object:nil];
        //  [self setUpForDismissKeyboard];
        
        
        UILabel  *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 128, 39*[_content count])];
        lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
        lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:size];
        lable1.text=_id;
        lable1.tag=10+indexPath.row+1;
        lable1.layer.masksToBounds=YES;
        lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
        lable1.layer.borderWidth= 1.0f;
        lable1.textAlignment = UITextAlignmentCenter;
        [cell addSubview:lable1];
        for(int i=0;i<[_content count];i++){
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(138,8+39*i,292,35)];
            label2.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:size];
            label2.tag=700+i+1;
            label2.text=[_content[i]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(425,8+39*i,51,35) ];
            label3.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label3.font=[UIFont fontWithName:@"Helvetica-Bold" size:size];
            label3.text=_score[i];
            label3.tag=800+i+1;
            label3.textAlignment
            = UITextAlignmentCenter;
            [cell addSubview:label2];
            [cell addSubview:label3];
            UITextField *textfield=[[UITextField alloc]initWithFrame:CGRectMake(526, 5+39*i, 97, 37)];
            textfield.borderStyle=UITextBorderStyleRoundedRect;
            textfield.layer.borderWidth=1.0;
            textfield.layer.borderColor=[[UIColor blackColor]CGColor];
            textfield.font=[UIFont fontWithName:@"Helvetica-Bold" size:size];
            textfield.tag=i+1;
            if([_value count]>i){
                textfield.text=_value[[NSString stringWithFormat:@"%d",i]];
            }
            textfield.textAlignment = UITextAlignmentCenter;
            [cell addSubview:textfield];
            UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(623, 5+39*i, 41, 37)];
            [button setBackgroundImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
            button.tag=100+10*indexPath.row+i+1;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            UIButton *button1=[[UIButton alloc]initWithFrame:CGRectMake(679, 7+39*i, 48, 34)];
            [button1 setBackgroundImage:[UIImage imageNamed:@"scoreadd"] forState:UIControlStateNormal];
            button1.tag=200+10*indexPath.row+i+1;
            [button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button1];
            UIButton *button2=[[UIButton alloc]initWithFrame:CGRectMake(734, 7+39*i, 48, 34)];
            [button2 setBackgroundImage:[UIImage imageNamed:@"scorereduce"] forState:UIControlStateNormal];
            button2.tag=300+10*indexPath.row+i+1;
            [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button2];
            UIButton *button3=[[UIButton alloc]initWithFrame:CGRectMake(805, 10+39*i, 32, 32)];
            // [button3 setBackgroundImage:[UIImage imageNamed:@"btndui"] forState:UIControlStateNormal];
            button3.tag=400+10*indexPath.row+i+1;
            [button3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            UIButton *button4=[[UIButton alloc]initWithFrame:CGRectMake(845, 10+39*i, 32, 32)];
            // [button4 setBackgroundImage:[UIImage imageNamed:@"btncuo"] forState:UIControlStateNormal];
            button4.tag=500+10*indexPath.row+i+1;
            [button4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
           // NSLog(@"%@",_flag[i]);
             NSString *flag=_flag[[NSString stringWithFormat:@"%d",i]];
            if(_flag[[NSString stringWithFormat:@"%d",i]]==nil){
                [button3 setBackgroundImage:[UIImage imageNamed:@"btndui"] forState:UIControlStateNormal];
                [button4 setBackgroundImage:[UIImage imageNamed:@"btncuo"] forState:UIControlStateNormal];
            }
           
            else if([flag compare:@"YES"]==0){
                [button3 setBackgroundImage:[UIImage imageNamed:@"btnduis"] forState:UIControlStateNormal];
                [button4 setBackgroundImage:[UIImage imageNamed:@"btncuo"] forState:UIControlStateNormal];
            }else if([flag compare:@"NO"]==0){
                [button3 setBackgroundImage:[UIImage imageNamed:@"btndui"] forState:UIControlStateNormal];
                [button4 setBackgroundImage:[UIImage imageNamed:@"btncuos"] forState:UIControlStateNormal];
                
            }
            
            [cell addSubview:button3];
            
            [cell addSubview:button4];
            UITextField *textfield1=[[UITextField alloc]initWithFrame:CGRectMake(899, 10+39*i, 99, 30)];
            textfield1.placeholder=@"评论";
            textfield1.borderStyle=UITextBorderStyleRoundedRect;
            textfield1.tag=600+10*indexPath.row+i+1;
            textfield1.delegate=self;
            textfield1.text=_commet[[NSString stringWithFormat:@"%d",i]];
            // textfield1.tag=i;
            [cell addSubview:textfield1];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                        name:@"UITextFieldTextDidChangeNotification"
                                                      object:textfield1];
            // }
        }

    }
  
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowData;
    rowData=self.computers[indexPath.row];
    NSArray *aa=rowData[@"MSI_Item"];
    if([aa count]>3){
        return 42*[aa count];
    }else if([aa count]>1){
        return 42*[aa count];
    }else{
         return 44*[aa count];
    }
    
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
-(IBAction) buttonClicked:(id)sender {
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.flag=YES;
    UIButton *button = (UIButton *)sender;
    NSString *aa=[NSString stringWithFormat:@"%d",button.tag];
    NSString *bb=[aa substringWithRange:NSMakeRange(0, 1)];
     NSString *dd=[aa substringWithRange:NSMakeRange(1, 1)];
    NSString *cc=[aa substringWithRange:NSMakeRange(2, 1)];
    int a=[cc intValue]-1;
    //TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSDictionary *rowData;
    if(delegate.update==nil){
        rowData=self.computers[[dd intValue]];
    }else{
        rowData=delegate.update[[dd intValue]];
        NSLog(@"%d",2222222);
    }
    //_indexpath=indexPath.row;
    // cell.computers=self.computers;
    _id=[rowData[@"MSI_ItemName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _content=rowData[@"MSI_Item"];
    _score=rowData[@"MSI_Score"];
    // cell.size=rowData[@"Size"];
    _value=rowData[@"GetScore"];
    _flag=rowData[@"Flag"];
    _commet=rowData[@"Commet"];
   // NSIndexPath *indexpath=[dd integerValue];
   UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableview indexPathForCell:cell];
    NSLog(@"%d",path.row);
   
    if([bb compare:@"1"]==0){
        NSMutableArray *arrat=[[NSMutableArray alloc]init];
        UITextField *textfield=(UITextField *)[cell viewWithTag:[cc intValue]];
        oo=[cc intValue]-1;
        for (int i=0; i<=[_score[a] intValue]; i++) {
            [arrat addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        [self.poc setPopoverContentSize:CGSizeMake(138, 23*([arrat count]+1))];
        CGRect rect;
        int u=_tableview.contentOffset.y;
        //textfield.frame.origin.y;
//        if([dd intValue]>0){
//            if([dd intValue]==1){
//                if(a>2){
//                    rect =CGRectMake(388, cell.frame.origin.y+39*(a-2)+1, 138, 23*([arrat count]+1));
//                }else{
//                    rect =CGRectMake(388, cell.frame.origin.y+39*a+214, 138, 23*([arrat count]+1));
//                }
//            }else{
//                rect =CGRectMake(388, cell.frame.origin.y+39*a-79, 138, 23*([arrat count]+1));
//            }
//        }else{
                      //int u=cell.frame.origin.y;
            
            rect =CGRectMake(388, cell.frame.origin.y+39*a+214-u, 138, 23*([arrat count]+1));
        
              //        UITableViewCell *cell1 = (UITableViewCell *)[_tableview viewWithTag:20+a];
//             rect =CGRectMake(388, cell.superview.frame.origin.y+209+39*a+cell3, 138, 23*([arrat count]+1));
               //设置箭头坐标--也是设置如何显示这个浮动框
        [self.poc presentPopoverFromRect:rect
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionLeft//可以任意换--换换看，你立马就知道
                                animated:NO];
    }else if([bb compare:@"2"]==0){
        NSString *empty=@"";
        // NSMutableArray *newarray = [_computers mutableCopy];
//        if(_arrat2==nil){
//            _arrat2=[NSMutableDictionary dictionary];
//        }else if(oo!=path.row){
//             _arrat2=[NSMutableDictionary dictionary];
//        }
        UITextField *textfield=(UITextField *)[cell viewWithTag:[cc intValue]];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        if([textfield.text compare:empty]== 0){
            NSMutableArray *newarray;
            if(delegate.update==nil){
                newarray = [_computers mutableCopy];
            }else{
                newarray=[delegate.update mutableCopy];
            }
            
            NSMutableDictionary *rowData=newarray[[dd intValue]];
            NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
            [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
            [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
            [rowData1 setObject:rowData[@"MSI_ItemName"] forKey:@"MSI_ItemName"];
            if(rowData[@"GetScore"]==nil){
                _arrat2=[NSMutableDictionary dictionary];
                
            }else{
                _arrat2=rowData[@"GetScore"];
            }

            if([_arrat2 count]==0){
                [_arrat2 setObject:_score[a] forKey:[NSString stringWithFormat:@"%d",a]];
                
            }
            [_arrat2 setObject:_score[a] forKey:[NSString stringWithFormat:@"%d",a]];
            
            //[_arrat2 insertObject:_score[oo] atIndex:oo];
            //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
            [rowData1 setObject:_arrat2 forKey:@"GetScore"];
            [newarray replaceObjectAtIndex:[dd intValue] withObject:rowData1];
            _computers=newarray;
            delegate.update=newarray;
            UITextField *textfield=(id)[cell viewWithTag:[cc intValue]];
            textfield.text=_score[([cc intValue]-1)];
           
            
        }else{
            UITextField *textfield=(UITextField *)[cell viewWithTag:[cc intValue]];
            int num=[textfield.text intValue];
           if(num==[_score[a] intValue]){
            
              }else{
            NSString *stringInt = [NSString stringWithFormat:@"%d",num+1];
            NSMutableArray *newarray;
            if(delegate.update==nil){
                newarray = [_computers mutableCopy];
            }else{
                newarray=[delegate.update mutableCopy];
            }
            
            NSMutableDictionary *rowData=newarray[[dd intValue]];
            NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
            [rowData1 setObject:rowData[@"MSI_Item"]forKey:@"MSI_Item"];
            [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
            [rowData1 setObject:rowData[@"MSI_ItemName"]  forKey:@"MSI_ItemName"];
            //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
                  if(rowData[@"GetScore"]==nil){
                      _arrat2=[NSMutableDictionary dictionary];
                      
                  }else{
                      _arrat2=rowData[@"GetScore"];
                  }

            if([_arrat2 count]==0){
              [_arrat2 setObject:stringInt forKey:[NSString stringWithFormat:@"%d",a]];
                
            }
                  [_arrat2 setObject:stringInt forKey:[NSString stringWithFormat:@"%d",a]];
            [rowData1 setObject:_arrat2 forKey:@"GetScore"];
            [newarray replaceObjectAtIndex:[dd intValue] withObject:rowData1];
            delegate.update=newarray;      _computers=newarray;     textfield.text=stringInt;//[_tableview reloadData];
            
        }
        }
        
    }else if([bb compare:@"3"]==0){
        NSString *empty=@"";
//        if(_arrat2==nil){
//            _arrat2=[NSMutableDictionary dictionary];
//
//        }else if(oo!=path.row){
//            _arrat2=[NSMutableDictionary dictionary];
//
//        }
        //NSMutableArray *newarray = [_computers mutableCopy];
        UITextField *textfield=(UITextField *)[cell viewWithTag:[cc intValue]];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        if([textfield.text compare:empty]== 0){
            
        }else{
            UITextField *textfield=(UITextField *)[cell viewWithTag:[cc intValue]];
            int num=[textfield.text intValue];
            if(num==0){
                NSMutableArray *newarray;
                if(delegate.update==nil){
                    newarray = [_computers mutableCopy];
                }else{
                    newarray=[delegate.update mutableCopy];
                }
                
                NSMutableDictionary *rowData=newarray[[dd intValue]];
                NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
                [rowData1 setObject:rowData[@"MSI_Item"] forKey:@"MSI_Item"];
                [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
                [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
                //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
                if(rowData[@"GetScore"]==nil){
                    _arrat2=[NSMutableDictionary dictionary];
                    
                }else{
                    _arrat2=rowData[@"GetScore"];
                }
                [_arrat2 setObject:@"0" forKey:[NSString stringWithFormat:@"%d",a]];                [rowData1 setObject:_arrat2 forKey:@"GetScore"];
                [newarray replaceObjectAtIndex:[dd intValue] withObject:rowData1];
                delegate.update=newarray;
                _computers=newarray;
                
            }else{
                NSString *stringInt = [NSString stringWithFormat:@"%d",num-1];
                NSMutableArray *newarray;
                if(delegate.update==nil){
                    newarray = [_computers mutableCopy];
                }else{
                    newarray=[delegate.update mutableCopy];
                }
                
                NSMutableDictionary *rowData=newarray[[dd intValue]];
                NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
                [rowData1 setObject:rowData[@"MSI_Item"]forKey:@"MSI_Item"];
                [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
                [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
                //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
                if(rowData[@"GetScore"]==nil){
                    _arrat2=[NSMutableDictionary dictionary];
                    
                }else{
                    _arrat2=rowData[@"GetScore"];
                }

                [_arrat2 setObject:stringInt forKey:[NSString stringWithFormat:@"%d",a]];
                
                
                [rowData1 setObject:_arrat2 forKey:@"GetScore"];
                [newarray replaceObjectAtIndex:[dd intValue] withObject:rowData1];
                delegate.update=newarray;
                _computers=newarray;
                UITextField *textfield=(id)[cell viewWithTag:[cc intValue]];
                              textfield.text=stringInt;
                //[_tableview reloadData];
            }
        }
    }else if([bb compare:@"4"]==0){
//        if(_arrat2==nil){
//            _arrat2=[NSMutableDictionary dictionary];
//        }else if(oo!=path.row){
//            _arrat2=[NSMutableDictionary dictionary];
//        }
//        if(_arrat4==nil){
//            _arrat4=[NSMutableDictionary dictionary];
//            
//        }else if(oo!=path.row){
//            _arrat4=[NSMutableDictionary dictionary];
//        }
        UITextField *textfield=(id)[cell viewWithTag:[cc intValue]];
        UIButton *button1=(id)[cell viewWithTag:(500+10*[dd intValue]+[cc intValue])];
        textfield.text=_score[a];
        [button setImage:[UIImage imageNamed:@"btnduis.png"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"btncuo.png"] forState:UIControlStateNormal];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        NSMutableArray *newarray;
        if(delegate.update==nil){
            newarray = [_computers mutableCopy];
        }else{
            newarray=[delegate.update mutableCopy];
        }
        NSMutableDictionary *rowData=newarray[[dd intValue]];
        NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
        [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
        [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
        [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
        if(rowData[@"GetScore"]==nil){
            _arrat2=[NSMutableDictionary dictionary];

        }else{
            _arrat2=rowData[@"GetScore"];
        }
        if(rowData[@"Flag"]==nil){
            _arrat4=[NSMutableDictionary dictionary];
        }else{
            _arrat4=rowData[@"Flag"];
        }
        [_arrat2 setObject:_score[a]forKey:[NSString stringWithFormat:@"%d",a]];
        [_arrat4 setObject:@"YES" forKey:[NSString stringWithFormat:@"%d",a]];
        //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
        [rowData1 setObject:_arrat2 forKey:@"GetScore"];
        [rowData1 setObject:_arrat4 forKey:@"Flag"];
        // NSLog(@"%@",_arrat4);
        [newarray replaceObjectAtIndex:[dd intValue] withObject:rowData1];
        _computers=newarray;
        delegate.update=newarray;
        //[_tableview reloadData];
    }else if([bb compare:@"5"]==0){
        UITextField *textfield=(id)[cell viewWithTag:[cc intValue]];
//        if(_arrat2==nil){
//            _arrat2=[NSMutableDictionary dictionary];
//        }else if(oo!=path.row){
//            _arrat2=[NSMutableDictionary dictionary];
//        }
//        if(_arrat4==nil){
//            _arrat4=[NSMutableDictionary dictionary];
//            
//        }else if(oo!=path.row){
//            _arrat4=[NSMutableDictionary dictionary];
//        }
        
        textfield.text=@"0";
        UIButton *button1=(id)[cell viewWithTag:(400+10*[dd intValue]+[cc intValue])];
        [button setImage:[UIImage imageNamed:@"btncuos.png"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"btndui.png"] forState:UIControlStateNormal];
        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
        NSMutableArray *newarray;
        if(delegate.update==nil){
            newarray = [_computers mutableCopy];
        }else{
            newarray=[delegate.update mutableCopy];
        }
        
        // NSMutableArray *newarray = [_computers mutableCopy];
        NSMutableDictionary *rowData=newarray[[dd intValue]];
        NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
        [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
        [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
        [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
        if(rowData[@"GetScore"]==nil){
            _arrat2=[NSMutableDictionary dictionary];
            
        }else{
            _arrat2=rowData[@"GetScore"];
        }
        if(rowData[@"Flag"]==nil){
            _arrat4=[NSMutableDictionary dictionary];
        }else{
            _arrat4=rowData[@"Flag"];
        }

        //[rowData1 setObject:rowData[@"Size"] forKey:@"Size"];
        [_arrat2 setObject:@"0" forKey:[NSString stringWithFormat:@"%d",a]];
        [rowData1 setObject:_arrat2 forKey:@"GetScore"];
        [_arrat4 setObject:@"NO" forKey:[NSString stringWithFormat:@"%d",a]];
        [rowData1 setObject:_arrat4 forKey:@"Flag"];
        // NSLog(@"%@",_arrat4);
        [newarray replaceObjectAtIndex:[dd intValue] withObject:rowData1];
        _computers=newarray;
        delegate.update=newarray;
      //  [_tableview reloadData];
    }
    oo=path.row;
}
- (void)popoverdismiss
{
    if(_poc){
        [_poc dismissPopoverAnimated:NO];
        
        //_getscore.text=delegate.stringvalue;
    }
    
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *aa=[NSString stringWithFormat:@"%d",textField.tag];
    NSString *bb=[aa substringWithRange:NSMakeRange(0, 2)];
    NSString *cc=[aa substringWithRange:NSMakeRange(2, 1)];
     NSString *dd=[aa substringWithRange:NSMakeRange(1, 1)];
    _indexpath=[dd intValue];
   // oo=[cc intValue];
    NSString *text=textField.text;
    //CGFloat keyboardHeight = 216.0f;
    CGRect textFrame =  textField.frame;
    float textY = textFrame.origin.y+textFrame.size.height;
    float bottomY = self.view.frame.size.height-textY;
    if(_indexpath>0){
        if(bottomY>1200)  //判断当前的高度是否已经有216，如果超过了就不需要再移动主界面的View高度
        {
            prewTag = -1;
            return;
        }    prewTag = textField.tag;
        prewTag = textField.tag;
        float moveY = 1200-bottomY;
        prewMoveY = moveY;
        
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.x +=moveY;//view的Y轴上移
        frame.size.height +=moveY; //View的高度增加
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];//设置调整界面的动画效果
    }else{
        if(bottomY==750){
            prewTag = textField.tag;
            float moveY = 800-bottomY;
            prewMoveY = moveY;
            
            NSTimeInterval animationDuration = 0.30f;
            CGRect frame = self.view.frame;
            frame.origin.x +=moveY;//view的Y轴上移
            frame.size.height +=moveY; //View的高度增加
            self.view.frame = frame;
            [UIView beginAnimations:@"ResizeView" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.view.frame = frame;
            [UIView commitAnimations];//设置调整界面的动画效果

        }else{
        prewTag = -1;
        return;
        }
    }
   
}
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    textField.layer.cornerRadius=8.0f;
//    textField.layer.masksToBounds=YES;
//    textField.layer.borderColor=[[UIColor blueColor]CGColor];
//    textField.layer.borderWidth= 1.0f;
//    return YES;
//}
//该方法为点击虚拟键盘Return，要调用的代理方法：隐藏虚拟键盘

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

//该方法为完成输入后要调用的代理方法：虚拟键盘隐藏后，要恢复到之前的文本框地方
-(void)textFieldDidEndEditing:(UITextField *)textField{
    float moveY ;
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    if(prewTag == textField.tag) //当结束编辑的View的TAG是上次的就移动
    {   //还原界面
        moveY =  prewMoveY;
        frame.origin.x -=moveY;
        frame.size. height -=moveY;
        self.view.frame = frame;
    }
    //self.view移回原位置
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    NSMutableArray *newarray;
    if(delegate.update==nil){
        newarray = [_computers mutableCopy];
    }else{
        newarray=[delegate.update mutableCopy];
    }
//    if(_arrat5==nil){
//        _arrat5=[NSMutableDictionary dictionary];
//    }else if(oo!=_indexpath){
//        _arrat5=[NSMutableDictionary dictionary];
//    }
    NSString *aa=[NSString stringWithFormat:@"%d",textField.tag];
    NSString *bb=[aa substringWithRange:NSMakeRange(0, 2)];
    NSString *cc=[aa substringWithRange:NSMakeRange(2, 1)];
    int a=[cc intValue]-1;
    //oo=[cc intValue];
    NSString *text=textField.text;
    // NSMutableArray *newarray = [_computers mutableCopy];
    NSMutableDictionary *rowData=newarray[_indexpath];
    NSMutableDictionary *rowData1=[NSMutableDictionary dictionary]; ;
    [rowData1 setObject:rowData[@"MSI_Item"]  forKey:@"MSI_Item"];
    [rowData1 setObject:rowData[@"MSI_Score"] forKey:@"MSI_Score"];
    [rowData1 setObject:rowData[@"MSI_ItemName"]forKey:@"MSI_ItemName"];
    if(rowData[@"GetScore"]!=nil){
        [rowData1 setObject:rowData[@"GetScore"] forKey:@"GetScore"];
    }
    if(rowData[@"Flag"]!=nil){
        [rowData1 setObject:rowData[@"Flag"] forKey:@"Flag"];
    }
    if(rowData[@"Commet"]==nil){
        _arrat5=[NSMutableDictionary dictionary];
        
    }else{
        _arrat5=rowData[@"Commet"];
    }

    [_arrat5  setObject:textField.text forKey:[NSString stringWithFormat:@"%d",a]];
    _size1=textField.text;
    [rowData1 setObject:_arrat5 forKey:@"Commet"];
    [newarray replaceObjectAtIndex:_indexpath withObject:rowData1];
    _computers=newarray;
    delegate.update=newarray;
    //textField.text=_methodmessage.text;
    if(prewTag == -1) //当编辑的View不是需要移动的View
    {
        return;
    }
    

    [textField resignFirstResponder];
     oo=_indexpath;
}

//- (IBAction)dropdown:(id)sender {
//    comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 26, 138, 140)];
//	comboBoxTableView.dataSource =self;
//	comboBoxTableView.delegate =self;
//    comboBoxTableView.hidden=YES;
//    [self addSubview:comboBoxTableView];
//
//}
#pragma mark -
#pragma mark - popover delegate
- (IBAction)downlist:(id)sender {
    
    //    comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(516, 48, 138, 340)];
    //	comboBoxTableView.dataSource =self;
    //	comboBoxTableView.delegate =self;
    NSMutableArray *arrat=[[NSMutableArray alloc]init];
    //    for (int i=0; i<=[_score intValue]; i++) {
    //        [arrat addObject:[NSString stringWithFormat:@"%d",i]];
    //        }
    
   // test.getscore=self.getscore;
    [self.poc setPopoverContentSize:CGSizeMake(138, 23*([arrat count]+1))];
    CGRect rect =CGRectMake(364, 49, 138, 23*([arrat count]+1));
    //设置箭头坐标--也是设置如何显示这个浮动框
    [self.poc presentPopoverFromRect:rect
                              inView:self
            permittedArrowDirections:UIPopoverArrowDirectionLeft//可以任意换--换换看，你立马就知道
                            animated:NO];
    //    [self addSubview:comboBoxTableView];
}
#pragma mark -
#pragma mark - popover delegate
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //    NSLog(@"%@",@"谢谢");
    //    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    //   // _getscore.text=delegate.stringvalue;
    //
    //    _getscore.text=delegate.stringvalue;
}
- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskLandscape;//只支持这一个方向(正常的方向)
    
}

@end
