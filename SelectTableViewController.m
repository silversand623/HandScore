//
//  SelectTableViewController.m
//  HandScore
//
//  Created by lyn on 14-5-12.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "SelectTableViewController.h"
#import "LoginViewController.h"
#import "ScoreTableViewController.h"
#import "AutocompletionTableView.h"
#import "TYAppDelegate.h"
@interface SelectTableViewController ()
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@end

@implementation SelectTableViewController
@synthesize autoCompleter = _autoCompleter;
UIActivityIndicatorView *indicator;
UIView * view ;
bool isTrue=YES;
bool upOrdown;
ZBarReaderView *readerView;
NSArray *studentarray;
NSArray *data;
NSArray *tabledata;
NSDictionary *data1;
NSArray *tabledata1;
int position;
int position1;
 int num;
NSString *bb;
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
    self.texxtfiledexamnum.delegate=self;
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1284, self.view.frame.size.height+255)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    indicator.backgroundColor=[UIColor grayColor];
    indicator.alpha=0.5;
    [self.view addSubview:indicator];
    [indicator startAnimating];
     NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:[defaults objectForKey:@"examid"] forKey:@"E_ID"];
    [params setObject:[defaults objectForKey:@"U_ID"] forKey:@"U_ID"];
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
    aa=[aa stringByAppendingString:BaseUrl];
    aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchExamInfo"];
    
    NSData *resultData=[self getResultDataByPost:params seturl:aa];
    if(resultData==nil){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
      NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
        studentarray=[weatherDic objectForKey:@"ExamStudentCodeList"];
        //save student count
        [defaults setInteger:studentarray.count forKey:@"Student_Count"];
        
        NSString *exammid=[weatherDic objectForKey:@"ES_ID"];
        NSString *exammname=[[weatherDic objectForKey:@"ES_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *roomid=[weatherDic objectForKey:@"Room_ID"];
        NSString *roomname=[[weatherDic objectForKey:@"Room_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        data=[weatherDic objectForKey:@"MarkSheetList"];
       // data1=[NSJSONSerialization JSONObjectWithData:[weatherDic objectForKey:@"MarkSheetList"] options:NSJSONReadingMutableLeaves error:nil];
        data1=data[0];
        NSString *tablenameid=[data1 objectForKey:@"MS_ID"];
       NSString *tablename=[[data1 objectForKey:@"MS_Name"]
                            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        tabledata=[data1 objectForKey:@"MarkSheetItemList"];
        [defaults setObject:tablename forKey:@"Table_Name"];
        [defaults setObject:exammname forKey:@"ES_Name"];
        [defaults setObject:roomid forKey:@"Room_ID"];
        [defaults setObject:roomname forKey:@"Room_Name"];
         [defaults setObject:tablenameid forKey:@"MS_ID"];
        [defaults setObject:exammid forKey:@"ES_ID"];
        [defaults synchronize];
        
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        if([defaults objectForKey:@"num"]==nil){
             [params setObject:studentarray[0] forKey:@"Exam_student_Code"];
            [params setObject:[defaults objectForKey:@"examid"] forKey:@"E_ID"];
                   }else{
            int a=[[defaults objectForKey:@"num"]intValue];
            if(a==[studentarray count]){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                alert.delegate=self;
            }else{
                 int a=[[defaults objectForKey:@"num"]intValue];
            
             [params setObject:studentarray[a] forKey:@"Exam_student_Code"];
                [params setObject:[defaults objectForKey:@"examid"] forKey:@"E_ID"];

                               }
        }
        NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
        aa=[aa stringByAppendingString:BaseUrl];
        aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchStudentInfo"];
        
        NSData *resultData=[self getResultDataByPost:params seturl:aa];
        if(resultData==nil){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }else{
 NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
            NSString *U_turename=[[weatherDic objectForKey:@"U_TrueName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *O_name=[[weatherDic objectForKey:@"O_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [defaults setObject:[weatherDic objectForKey:@"U_StudentCode"] forKey:@"U_StudentCode"];
            NSString *U_turenameid=[weatherDic objectForKey:@"U_ID"];
            [defaults setObject:U_turename forKey:@"U_TrueName"];
            [defaults setObject:O_name forKey:@"O_Name"];
            [defaults setObject:U_turenameid forKey:@"U_StudentID"];
            [defaults synchronize];
    NSTimer *connectionTimer;
    connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setlayout:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    self.texxtfiledexamnum.layer.masksToBounds=YES;
    self.texxtfiledexamnum.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
    self.texxtfiledexamnum.layer.borderWidth= 1.0f;
    [self settable];
            self.texxtfiledexamnum.keyboardType=UIKeyboardTypeNumberPad;
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(keyboardHide:)
                                                name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.texxtfiledexamnum addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    //[NSThread detachNewThreadSelector:@selector(updateDate:) toTarget:self ////withObject:@"yuzhou"];
   // [self setUpForDismissKeyboard];
   //    self.appuser.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
//    self.appuser.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
//        ZBarReaderViewController *reader = [ZBarReaderViewController new];
//   reader.readerDelegate = self;
//   reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//
//   ZBarImageScanner *scanner = reader.scanner;
//
//   [scanner setSymbology: ZBAR_I25
//                  config: ZBAR_CFG_ENABLE
//                      to: 0];
//
//    [self presentViewController:reader animated:YES completion:Nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) imagePickerController: (UIImagePickerController*) reader{
//didFinishPickingMediaWithInfo: (NSDictionary*) info

self.view = [[UIView alloc] initWithFrame:CGRectMake(20, 400, 320, 400)];

[self.view addSubview:self.view];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
//   ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//   reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//   ZBarImageScanner *scanner = reader.scanner;
//   
//   [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                     to: 0];
//   [self presentViewController:reader animated:YES completion:Nil];
}

- (void) setlayout:(NSTimer *) timer{
    
     NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
    aa=[aa stringByAppendingString:BaseUrl];
   
    int a=[[defaults objectForKey:@"num"]intValue];
    aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchStudentPhoto?Exam_Student_Code="];
    aa=[aa stringByAppendingFormat:@"%@",studentarray[a]];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aa]]];
    [indicator stopAnimating];
    [self.studentimg setImage:image];
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
    UITapGestureRecognizer *tapRecongizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backlogin:)];
    self.labellogout.userInteractionEnabled=YES;
    [self.labellogout addGestureRecognizer:tapRecongizer];
    self.studentesamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentesamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentnum.text=[defaults objectForKey:@"U_StudentCode"];
    self.studentname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentname.text=[defaults objectForKey:@"U_TrueName"];
    self.studentnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    if([defaults objectForKey:@"num"]==nil){
        self.studentesamnum.text=studentarray[0];
        [defaults setObject:studentarray[0] forKey:@"studentcode"];
        [defaults synchronize];
    }else{
        int a=[[defaults objectForKey:@"num"]intValue];
        self.studentesamnum.text=studentarray[a];
        [defaults setObject:studentarray[a] forKey:@"studentcode"];
        [defaults synchronize];

           }

    self.studentnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
   // self.studentnum.text=@"2014041058";
    self.studentclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentclassnum.text=[defaults objectForKey:@"O_Name"];
    self.studentexamclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamclassnum.text=[defaults objectForKey:@"ES_Name"];
    self.studentexamname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamname.text=[defaults objectForKey:@"examname"];
    self.studentrootnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentrootnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentrootnum.text=[defaults objectForKey:@"Room_Name"];
    
    self.texxtfiledexamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.texxtfiledexamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    if([defaults objectForKey:@"num"]==nil){
        self.texxtfiledexamnum.text=studentarray[0];
    }else{
        int a=[[defaults objectForKey:@"num"]intValue];
        self.texxtfiledexamnum.text=studentarray[a];
        
    }
    
    self.showstudentesamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentesamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentesamnum.text=@"考号：";
    self.showstudentname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentname.text=@"姓名：";
    self.showstudentnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentnum.text=@"学号：";
    self.showstudentclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentclassnum.text=@"班级：";
    self.showstudentexamname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamname.text=@"考试名：";
    self.showstudentexamclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamclassnum.text=@"考站号：";
    self.showstudentrootnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentrootnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentrootnum.text=@"房间号：";
      [self.scannerselect addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];//添加事件
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(589, 101, 418, 576)];
     view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    UILabel *tablename=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 418, 21)];
   tablename.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    tablename.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    tablename.text=[defaults objectForKey:@"Table_Name"];
    tablename.layer.masksToBounds=YES;
       tablename.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
        tablename.layer.borderWidth= 1.0f;
    [tablename setTextAlignment:NSTextAlignmentCenter];    [view addSubview:tablename];
    for (int i=0; i<[tabledata count]; i++) {
        NSDictionary *aa=tabledata[i];
        NSArray *bb=aa[@"MSI_Item"];
        NSString *itemname=[aa[@"MSI_ItemName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *cc=aa[@"MSI_Score"];
        UILabel *lable1;
        int e;
        if(i==0){
            lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 21, 128, 21*[bb count])];
            position=21;
            lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            lable1.text=itemname;
            lable1.layer.masksToBounds=YES;
            lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            lable1.layer.borderWidth= 1.0f;
             [lable1 setTextAlignment:NSTextAlignmentCenter];
        }else{
           
            NSDictionary *aa=tabledata[i-1];
             NSDictionary *dd=tabledata[i];
            NSArray *bb=aa[@"MSI_Item"];
            NSString *itemname=[dd[@"MSI_ItemName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *cc=dd[@"MSI_Score"];
           e=position+21*[bb count];
            position1=position;
            position=e;
            lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, e, 128, 21*[cc count])];
            lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            lable1.text=itemname;
            lable1.layer.masksToBounds=YES;
            lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            lable1.layer.borderWidth= 1.0f;
             [lable1 setTextAlignment:NSTextAlignmentCenter];        }
        
        [view addSubview:lable1];
        for(int j=0;j<[bb count];j++){
            int t=position+21*j;
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(128,t,203,21)];
            label2.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            label2.text=[bb[j]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(331,t,87,21) ];
            label3.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label3.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            label3.text=cc[j];
            label2.layer.masksToBounds=YES;
            label2.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            label2.layer.borderWidth= 1.0f;
            label3.layer.masksToBounds=YES;
            label3.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            label3.layer.borderWidth= 1.0f;
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:label2];
            [view addSubview:label3];
        }
       
    }
}
- (void) setlayout1:(NSTimer *) timer{
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *stuCode = [defaults objectForKey:@"U_StudentCode"];
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
    aa=[aa stringByAppendingString:BaseUrl];
    self.texxtfiledexamnum.text=stuCode;
    int a=[[defaults objectForKey:@"num"]intValue];
    aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchStudentPhoto?Exam_Student_Code="];
    aa=[aa stringByAppendingFormat:@"%@",studentarray[a]];
    UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aa]]];
    [indicator stopAnimating];
    [self.studentimg setImage:image];
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
    UITapGestureRecognizer *tapRecongizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backlogin:)];
    self.labellogout.userInteractionEnabled=YES;
    [self.labellogout addGestureRecognizer:tapRecongizer];
    self.studentesamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentesamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentnum.text=[defaults objectForKey:@"U_StudentCode"];
    self.studentname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentname.text=[defaults objectForKey:@"U_TrueName"];
    self.studentnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    
        self.studentesamnum.text=stuCode;
        //[defaults setObject:bb forKey:@"studentcode"];
        //[defaults synchronize];
    
    self.studentnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    // self.studentnum.text=@"2014041058";
    self.studentclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentclassnum.text=[defaults objectForKey:@"O_Name"];
    self.studentexamclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamclassnum.text=[defaults objectForKey:@"ES_Name"];
    self.studentexamname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamname.text=[defaults objectForKey:@"examname"];
    self.studentrootnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentrootnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentrootnum.text=[defaults objectForKey:@"Room_Name"];
    
    self.texxtfiledexamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.texxtfiledexamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
//    if([defaults objectForKey:@"num"]==nil){
//        self.texxtfiledexamnum.text=studentarray[0];
//    }else{
//        int a=[[defaults objectForKey:@"num"]intValue];
//        self.texxtfiledexamnum.text=studentarray[a];
//        
//    }
    
    self.showstudentesamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentesamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentesamnum.text=@"考号：";
    self.showstudentname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentname.text=@"姓名：";
    self.showstudentnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentnum.text=@"学号：";
    self.showstudentclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentclassnum.text=@"班级：";
    self.showstudentexamname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamname.text=@"考试名：";
    self.showstudentexamclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamclassnum.text=@"考站号：";
    self.showstudentrootnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentrootnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentrootnum.text=@"房间号：";
    [self.scannerselect addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];//添加事件
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(589, 101, 418, 576)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    UILabel *tablename=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 418, 21)];
    tablename.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    tablename.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
    tablename.text=[defaults objectForKey:@"Table_Name"];
    tablename.layer.masksToBounds=YES;
    tablename.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
    tablename.layer.borderWidth= 1.0f;
    [tablename setTextAlignment:NSTextAlignmentCenter];    [view addSubview:tablename];
    for (int i=0; i<[tabledata count]; i++) {
        NSDictionary *aa=tabledata[i];
        NSArray *bb=aa[@"MSI_Item"];
        NSString *itemname=[aa[@"MSI_ItemName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray *cc=aa[@"MSI_Score"];
        UILabel *lable1;
        int e;
        if(i==0){
            lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 21, 128, 21*[bb count])];
            position=21;
            lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            lable1.text=itemname;
            lable1.layer.masksToBounds=YES;
            lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            lable1.layer.borderWidth= 1.0f;
            [lable1 setTextAlignment:NSTextAlignmentCenter];
        }else{
            
            NSDictionary *aa=tabledata[i-1];
            NSDictionary *dd=tabledata[i];
            NSArray *bb=aa[@"MSI_Item"];
            NSString *itemname=[dd[@"MSI_ItemName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *cc=dd[@"MSI_Score"];
            e=position+21*[bb count];
            position1=position;
            position=e;
            lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, e, 128, 21*[cc count])];
            lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            lable1.text=itemname;
            lable1.layer.masksToBounds=YES;
            lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            lable1.layer.borderWidth= 1.0f;
            [lable1 setTextAlignment:NSTextAlignmentCenter];        }
        
        [view addSubview:lable1];
        for(int j=0;j<[bb count];j++){
            int t=position+21*j;
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(128,t,203,21)];
            label2.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            label2.text=[bb[j]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(331,t,87,21) ];
            label3.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label3.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
            label3.text=cc[j];
            label2.layer.masksToBounds=YES;
            label2.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            label2.layer.borderWidth= 1.0f;
            label3.layer.masksToBounds=YES;
            label3.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
            label3.layer.borderWidth= 1.0f;
            [label3 setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:label2];
            [view addSubview:label3];
        }
        
    }
}

-(void)segmentChanged:(UISegmentedControl *)paramSender{
    if ([paramSender isEqual:self.scannerselect]) {
        //获得索引位置
        NSInteger selectedSegmentIndex = [paramSender selectedSegmentIndex];
        if(selectedSegmentIndex==0){
//                ZBarReaderViewController * reader = [ZBarReaderViewController new];
//            //设置代理
//            reader.readerDelegate = self;
//            //支持界面旋转
//            reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//            reader.showsHelpOnFail = NO;
//            reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
//            ZBarImageScanner * scanner = reader.scanner;
//            [scanner setSymbology:ZBAR_I25
//                           config:ZBAR_CFG_ENABLE
//                               to:0];
//            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
//            view.backgroundColor = [UIColor clearColor];
//            reader.cameraOverlayView = view;
//            
//            
//            
//            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
//            label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
//            label.textColor = [UIColor whiteColor];
//            label.textAlignment = 1;
//            label.lineBreakMode = 0;
//            label.numberOfLines = 2;
//            label.backgroundColor = [UIColor clearColor];
//            [view addSubview:label];
//            
//            UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
//            image.frame = CGRectMake(20, 80, 280, 280);
//            [view addSubview:image];
//            
//            
//            _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
//            _line.image = [UIImage imageNamed:@"line.png"];
//            [image addSubview:_line];
//            [self presentViewController:reader animated:YES completion:Nil];
            num = 0;
            upOrdown = NO;
               readerView = [[ZBarReaderView alloc]init];
            readerView.frame = CGRectMake(124, 364, 320, 320);
            readerView.readerDelegate = self;
            //readerView.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);
            //关闭闪光灯
            readerView.torchMode = 0;
            readerView.previewTransform=CGAffineTransformMakeRotation(-M_PI/2);
            //扫描区域
            CGRect scanMaskRect = CGRectMake(0, 0, 320, 320);
            
            //处理模拟器
            if (TARGET_IPHONE_SIMULATOR) {
                ZBarCameraSimulator *cameraSimulator
                = [[ZBarCameraSimulator alloc]initWithViewController:self];
                cameraSimulator.readerView = readerView;
            }
            readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:readerView.bounds];
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
                        label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
                       label.textColor = [UIColor whiteColor];
                        label.textAlignment = 1;
                        label.lineBreakMode = 0;
                        label.numberOfLines = 2;
                        label.backgroundColor = [UIColor clearColor];
                      [readerView addSubview:label];
            
                        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
                       image.frame = CGRectMake(1, 1, 320, 320);
                        [readerView addSubview:image];
            
            
                        _line = [[UIImageView alloc] initWithFrame:CGRectMake(1, 5, 320, 2)];
                        _line.image = [UIImage imageNamed:@"line.png"];
                        [readerView addSubview:_line];
//            ZBarImageScanner *scanner=readerView.scanner;
//            [scanner setSymbology: ZBAR_I25
//                          config: ZBAR_CFG_ENABLE
//                              to: 0];
            [self.view addSubview:readerView];
            //扫描区域计算
           // readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:self.readerView.bounds];
           // readerView.scanCrop=[Z]
            
            [readerView start];
          NSTimer *connectionTimer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
        }else if(selectedSegmentIndex==1){
           readerView.hidden=YES;
        }
       
    }
}
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    
    return CGRectMake(x, y, width, height);
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    [timer invalidate];
//    _line.frame = CGRectMake(30, 10, 220, 2);
//    num = 0;
//    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSString *name=[[NSString alloc]init];
    for (ZBarSymbol *symbol in symbols) {
        name = symbol.data;
        break;
    }
    readerView.hidden=YES;
    bb=name;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"扫瞄结果" message:[NSString stringWithFormat:@"扫描到的学号为：%@",name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消"];
    [alert show];
    [readerView stop];
}
- (void)imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =  [info objectForKey: ZBarReaderControllerResults];
    
    NSString *name = [[NSString alloc] init];
    for(ZBarSymbol *symbol in results)
    {
        name = symbol.data;
      //  [readerView stop];
        break;
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:name message:name delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [reader dismissViewControllerAnimated:YES completion:nil];
    //StepListViewController * controller = [[StepListViewController alloc] initWithName:name];
    //[self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)scanner:(id)sender {
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    [self presentViewController:reader animated:YES completion:Nil];
}


- (IBAction)backlogin:(id)sender {
    LoginViewController *loginviewController=[[LoginViewController alloc]init];
    [self presentViewController:loginviewController animated:YES completion:nil];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1284, self.view.frame.size.height+255)];
        indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        [indicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
        indicator.backgroundColor=[UIColor grayColor];
        indicator.alpha=0.5;
        [self.view addSubview:indicator];
        [indicator startAnimating];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:[defaults objectForKey:@"examid"] forKey:@"E_ID"];
        NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
        aa=[aa stringByAppendingString:BaseUrl];
        aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchExamInfo"];
        
        NSData *resultData=[self getResultDataByPost:params seturl:aa];
        if(resultData==nil){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
            studentarray=[weatherDic objectForKey:@"ExamStudentCodeList"];
            NSString *exammname=[[weatherDic objectForKey:@"ES_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
             NSString *exammid=[weatherDic objectForKey:@"ES_ID"];
            NSString *roomname=[[weatherDic objectForKey:@"Room_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            data=[weatherDic objectForKey:@"MarkSheetList"];
            // data1=[NSJSONSerialization JSONObjectWithData:[weatherDic objectForKey:@"MarkSheetList"] options:NSJSONReadingMutableLeaves error:nil];
            data1=data[0];
            NSString *tablename=[[data1 objectForKey:@"MS_Name"]
                                 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            tabledata=[data1 objectForKey:@"MarkSheetItemList"];
            [defaults setObject:tablename forKey:@"Table_Name"];
            [defaults setObject:exammname forKey:@"ES_Name"];
            [defaults setObject:roomname forKey:@"Room_Name"];
             [defaults setObject:exammid forKey:@"ES_ID"];
            [defaults synchronize];
            
            
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setObject:bb forKey:@"Exam_student_Code"];
//            if([defaults objectForKey:@"num"]==nil){
//                [params setObject:studentarray[0] forKey:@"Exam_student_Code"];
//            }else{
//                int a=[[defaults objectForKey:@"num"]intValue];
//                if(a==[studentarray count]){
//                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                    [alert show];
//                    alert.delegate=self;
//                }else{
//                    int a=[[defaults objectForKey:@"num"]intValue];
//                    
//                    [params setObject:studentarray[a] forKey:@"Exam_student_Code"];
//                }
//            }
            NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
            aa=[aa stringByAppendingString:BaseUrl];
            aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchStudentInfo"];
            
            NSData *resultData=[self getResultDataByPost:params seturl:aa];
            if(resultData==nil){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }else{
                NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
                NSString *U_turename=[[weatherDic objectForKey:@"U_TrueName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *O_name=[[weatherDic objectForKey:@"O_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [defaults setObject:[weatherDic objectForKey:@"U_StudentCode"] forKey:@"U_StudentCode"];
                [defaults setObject:U_turename forKey:@"U_TrueName"];
                [defaults setObject:O_name forKey:@"O_Name"];
                [defaults synchronize];
                readerView.hidden=YES;
                _scannerselect.selectedSegmentIndex=1;
                NSTimer *connectionTimer;
                connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setlayout1:) userInfo:nil repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    }
        }
    }
    else if(buttonIndex==1){
        readerView.hidden=NO;
        [readerView start];
    }
}
- (IBAction)forwardscore:(id)sender {
    ScoreTableViewController *scoretableviewController=[[ScoreTableViewController alloc]init];
    scoretableviewController.computers=tabledata;
    [self presentViewController:scoretableviewController animated:YES completion:nil];

}
- (void)settable{
//    self.label1.layer.masksToBounds=YES;
//    self.label1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label1.layer.borderWidth= 1.0f;
//    self.label2.layer.masksToBounds=YES;
//    self.label2.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label2.layer.borderWidth= 1.0f;
//    self.label3.layer.masksToBounds=YES;
//    self.label3.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label3.layer.borderWidth= 1.0f;
//    self.label4.layer.masksToBounds=YES;
//    self.label4.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label4.layer.borderWidth= 1.0f;
//    self.label5.layer.masksToBounds=YES;
//    self.label5.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label5.layer.borderWidth= 1.0f;
//    self.label6.layer.masksToBounds=YES;
//    self.label6.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label6.layer.borderWidth= 1.0f;
//    self.label7.layer.masksToBounds=YES;
//    self.label7.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label7.layer.borderWidth= 1.0f;
//    self.label8.layer.masksToBounds=YES;
//    self.label8.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label8.layer.borderWidth= 1.0f;
//    self.label9.layer.masksToBounds=YES;
//    self.label9.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label9.layer.borderWidth= 1.0f;
//    self.label10.layer.masksToBounds=YES;
//    self.label10.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label10.layer.borderWidth= 1.0f;
//    self.label11.layer.masksToBounds=YES;
//    self.label11.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label11.layer.borderWidth= 1.0f;
//    self.label12.layer.masksToBounds=YES;
//    self.label12.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label12.layer.borderWidth= 1.0f;
//    self.label13.layer.masksToBounds=YES;
//    self.label13.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label13.layer.borderWidth= 1.0f;
//    self.label14.layer.masksToBounds=YES;
//    self.label14.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label14.layer.borderWidth= 1.0f;
//    self.label15.layer.masksToBounds=YES;
//    self.label15.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label15.layer.borderWidth= 1.0f;
//    self.label16.layer.masksToBounds=YES;
//    self.label16.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label16.layer.borderWidth= 1.0f;
//    self.label17.layer.masksToBounds=YES;
//    self.label17.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label17.layer.borderWidth= 1.0f;
//    self.label18.layer.masksToBounds=YES;
//    self.label18.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label18.layer.borderWidth= 1.0f;
//    self.label19.layer.masksToBounds=YES;
//    self.label19.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label19.layer.borderWidth= 1.0f;
//    self.label20.layer.masksToBounds=YES;
//    self.label20.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label20.layer.borderWidth= 1.0f;
//    self.label21.layer.masksToBounds=YES;
//    self.label21.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label21.layer.borderWidth= 1.0f;
//    self.label22.layer.masksToBounds=YES;
//    self.label22.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label22.layer.borderWidth= 1.0f;
//    self.label23.layer.masksToBounds=YES;
//    self.label23.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label23.layer.borderWidth= 1.0f;
//    self.label24.layer.masksToBounds=YES;
//    self.label24.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label24.layer.borderWidth= 1.0f;
//    self.label25.layer.masksToBounds=YES;
//    self.label25.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label25.layer.borderWidth= 1.0f;
//    self.label26.layer.masksToBounds=YES;
//    self.label26.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label26.layer.borderWidth= 1.0f;
//    self.label27.layer.masksToBounds=YES;
//    self.label27.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label27.layer.borderWidth= 1.0f;
//    self.label28.layer.masksToBounds=YES;
//    self.label28.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label28.layer.borderWidth= 1.0f;
//    self.label29.layer.masksToBounds=YES;
//    self.label29.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label29.layer.borderWidth= 1.0f;
//    self.label30.layer.masksToBounds=YES;
//    self.label30.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label30.layer.borderWidth= 1.0f;
//    self.label31.layer.masksToBounds=YES;
//    self.label31.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label31.layer.borderWidth= 1.0f;
//    self.label32.layer.masksToBounds=YES;
//    self.label32.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label32.layer.borderWidth= 1.0f;
//    self.label33.layer.masksToBounds=YES;
//    self.label33.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label33.layer.borderWidth= 1.0f;
//    self.label34.layer.masksToBounds=YES;
//    self.label34.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label34.layer.borderWidth= 1.0f;
//    self.label35.layer.masksToBounds=YES;
//    self.label35.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label35.layer.borderWidth= 1.0f;
//    self.label36.layer.masksToBounds=YES;
//    self.label36.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label36.layer.borderWidth= 1.0f;
//    self.label37.layer.masksToBounds=YES;
//    self.label37.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label37.layer.borderWidth= 1.0f;
//    self.label38.layer.masksToBounds=YES;
//    self.label38.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label38.layer.borderWidth= 1.0f;
//    self.label39.layer.masksToBounds=YES;
//    self.label39.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label39.layer.borderWidth= 1.0f;
//    self.label40.layer.masksToBounds=YES;
//    self.label40.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label40.layer.borderWidth= 1.0f;
//    self.label41.layer.masksToBounds=YES;
//    self.label41.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label41.layer.borderWidth= 1.0f;
//    self.label42.layer.masksToBounds=YES;
//    self.label42.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label42.layer.borderWidth= 1.0f;
//    self.label43.layer.masksToBounds=YES;
//    self.label43.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label43.layer.borderWidth= 1.0f;
//    self.label44.layer.masksToBounds=YES;
//    self.label44.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label44.layer.borderWidth= 1.0f;
//    self.label45.layer.masksToBounds=YES;
//    self.label45.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label45.layer.borderWidth= 1.0f;
//    self.label46.layer.masksToBounds=YES;
//    self.label46.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label40.layer.borderWidth= 1.0f;
//    self.label40.layer.masksToBounds=YES;
//    self.label40.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label46.layer.borderWidth= 1.0f;
//    self.label47.layer.masksToBounds=YES;
//    self.label47.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label47.layer.borderWidth= 1.0f;
//    self.label48.layer.masksToBounds=YES;
//    self.label48.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label48.layer.borderWidth= 1.0f;
//    self.label49.layer.masksToBounds=YES;
//    self.label49.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label49.layer.borderWidth= 1.0f;
//    self.label50.layer.masksToBounds=YES;
//    self.label50.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label50.layer.borderWidth= 1.0f;
//    self.label51.layer.masksToBounds=YES;
//    self.label51.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label51.layer.borderWidth= 1.0f;
//    self.label52.layer.masksToBounds=YES;
//    self.label52.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label52.layer.borderWidth= 1.0f;
//    self.label53.layer.masksToBounds=YES;
//    self.label53.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label53.layer.borderWidth= 1.0f;
//    self.label54.layer.masksToBounds=YES;
//    self.label54.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
//    self.label54.layer.borderWidth= 1.0f;
    
}
- (void)keyboardHide:(NSNotification *)notif {
    isTrue=NO;
//    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
//    if(delegate!=nil){
//        self.texxtfiledexamnum.text=delegate.updateflag;
//    }
    
    
    
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1284, self.view.frame.size.height+255)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(self.view.frame.size.width/2+100, self.view.frame.size.height/2-150)];
    indicator.backgroundColor=[UIColor grayColor];
    indicator.alpha=0.5;
    [self.view addSubview:indicator];
    //self.studentesamnum.text=self.texxtfiledexamnum.text;
    [indicator startAnimating];
    
    NSTimer *connectionTimer;
    connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(stop:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    
  }

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
    aa=[aa stringByAppendingString:BaseUrl];
    aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SearchStudentInfo"];
    
    BOOL result = FALSE;
    int nCount=0;
    for(NSString *str in studentarray)
    {
        result = [self.texxtfiledexamnum.text isEqualToString:str];
        if (result) {
            break;
        }
        nCount++;
    }
    if (!result) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //NSString *studentcode=[[NSString alloc] init];
    //[defaults setObject:studentcode forKey:@"Exam_student_Code"];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:[defaults objectForKey:@"examid"] forKey:@"E_ID"];
    [params setObject:self.texxtfiledexamnum.text forKey:@"Exam_student_Code"];
    
    NSData *resultData=[self getResultDataByPost:params seturl:aa];
    if(resultData==nil){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"数据获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
        NSString *U_turename=[[weatherDic objectForKey:@"U_TrueName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *O_name=[[weatherDic objectForKey:@"O_Name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [defaults setObject:[weatherDic objectForKey:@"U_StudentCode"] forKey:@"U_StudentCode"];
        NSString *U_turenameid=[weatherDic objectForKey:@"U_ID"];
        [defaults setObject:U_turename forKey:@"U_TrueName"];
        [defaults setObject:O_name forKey:@"O_Name"];
        [defaults setObject:U_turenameid forKey:@"U_StudentID"];
        //[defaults setInteger:nCount forKey:@"num" ]; //不保存最后选择的那个学生在数组里的位置
        [defaults synchronize];
        readerView.hidden=YES;
        _scannerselect.selectedSegmentIndex=1;
        NSTimer *connectionTimer;
        connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setlayout1:) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    }
    [textField resignFirstResponder];
}

- (void)updateDate:(NSString*)str
{
//    while (isTrue) {
//        NSLog(@"haha");
//        TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
//        if(delegate.updateflag==YES){
//             isTrue=NO;
//            indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1284, self.view.frame.size.height)];
//            indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
//            [indicator setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-150)];
//            indicator.backgroundColor=[UIColor grayColor];
//            indicator.alpha=0.5;
//            [self.view addSubview:indicator];
//            [indicator startAnimating];
//            delegate.updateflag=NO;
//                    [NSThread detachNewThreadSelector:@selector(stop:) toTarget:self withObject:@"yuzhou"];           }
//
//    }
    }
- (AutocompletionTableView *)autoCompleter
{
    if (!_autoCompleter)
    {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:YES] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.texxtfiledexamnum inViewController:self withOptions:options];
        _autoCompleter.suggestionsDictionary = studentarray;
    }
    return _autoCompleter;
}
- (void) mytest:(NSNotification*) notification

{
    [indicator stopAnimating];

   // id obj = [notification object];//获取到传递的对象
    
}
-(void)stop:(NSString*)str{
    
    [indicator stopAnimating];
}
- (void)setUpForDismissKeyboard {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.texxtfiledexamnum resignFirstResponder];
    if(isTrue){
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1284, self.view.frame.size.height+255)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(self.view.frame.size.width/2+100, self.view.frame.size.height/2-150)];
    indicator.backgroundColor=[UIColor grayColor];
    indicator.alpha=0.5;
    [self.view addSubview:indicator];
    [indicator startAnimating];
       
    NSTimer *connectionTimer;
    connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(stop:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
    }
}
- (NSString *)createPostURL:(NSMutableDictionary *)params

{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
        
    {
        
        NSString *value=[params objectForKey:key];
        
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
        
    }
    
    if([postString length]>1)
        
    {
        
        postString=[postString substringToIndex:[postString length]-1];
        
    }
    
    return postString;
    
}
- (NSData *)getResultDataByPost:(NSMutableDictionary *)params seturl:(NSString *)url

{
    
    //NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    NSString *postURL=[self createPostURL:params];
    NSString*postLength = [NSString stringWithFormat:@"%d", [postURL length]];
  //  NSError *error;
    
   // NSURLResponse *theResponse;
    
    NSMutableURLRequest *theRequest=[[NSMutableURLRequest alloc]init];
    [theRequest setURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
    return [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex==0){
//       LoginViewController  *loginViewontroller=[[LoginViewController alloc]init];
//        [self presentViewController:loginViewontroller animated:YES completion:nil];
//           //        NSTimer *connectionTimer;
//        //        connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(haha:) userInfo:nil repeats:NO];
//        //        [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
//    }
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskLandscapeRight;//只支持这一个方向(正常的方向)
    
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}@end
