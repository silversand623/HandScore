//
//  PreviewViewController.m
//  HandScore
//
//  Created by lyn on 14-5-13.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "PreviewViewController.h"
#import "LoginViewController.h"
#import "ScoreTableViewController.h"
#import "SelectTableViewController.h"
#import "Previewcell.h"
#import "MyUIView.h"
#import "TYAppDelegate.h"
@interface PreviewViewController ()

@end

@implementation PreviewViewController
UIActivityIndicatorView *indicator;
static NSString *CellTalbeIdentifier=@"CellTableIdentifier";
static NSString * const FORM_FLE_INPUT = @"image";
int sum = 0,get=0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
       [super viewDidLoad];
    [self setlayout];
    //UITableView *tableView=(id)[self.view viewWithTag:1];
    //tableView.rowHeight=65;
    //UINib *nib=[UINib nibWithNibName:@"Previewcell" bundle:nil];
    //[tableView registerNib:nib forCellReuseIdentifier:CellTalbeIdentifier];
    MyUIView *myView=[[MyUIView alloc]initWithFrame:CGRectMake(589, 91, 418, 586)];
    myView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:myView];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)writenameok:(id)sender {
    
}

- (IBAction)writenamecancel:(id)sender {
}

- (IBAction)back:(id)sender {
    ScoreTableViewController *scoretableviewController=[[ScoreTableViewController alloc]init];
    scoretableviewController.previewreturn=YES;
    [self presentViewController:scoretableviewController animated:YES completion:nil];
}

- (IBAction)submit:(id)sender {
    TYAppDelegate *delegate=(TYAppDelegate*)[[UIApplication sharedApplication]delegate];
    if(delegate.flag==NO){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"没有进行数字签名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }else{
    
        
        
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, 1284, self.view.frame.size.height)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(self.view.frame.size.width/2+130, self.view.frame.size.height/2-130)];
    indicator.backgroundColor=[UIColor grayColor];
    indicator.alpha=0.5;
    [self.view addSubview:indicator];
    [indicator startAnimating];
         NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];NSString *aa=@"http://";
        aa=[aa stringByAppendingString:BaseUrl];
        aa=[aa stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/SaveExamResult"];
        NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
        [params setObject:@"image" forKey:@"name"];

        NSString *bb= [self postRequestWithURL:aa postParems:nil picFilePath:delegate.filename picFileName:@"test" ];
         NSString *BaseUrl1=[defaults objectForKey:@"IPConfig"];NSString *aa1=@"http://";
         aa1=[aa1 stringByAppendingString:BaseUrl1];
        aa1=[aa1 stringByAppendingFormat:@"%@",@"/AppDataInterface/HandScore.aspx/AddScoreInfo"];
        NSMutableDictionary *params1=[[NSMutableDictionary alloc] init];
        [params1 setObject:[defaults objectForKey:@"examid"] forKey:@"Exam_ID"];
        [params1 setObject:[defaults objectForKey:@"ES_ID"] forKey:@"ExamStation_ID"];
        [params1 setObject:[defaults objectForKey:@"Room_ID"] forKey:@"Room_ID"];
        [params1 setObject:[defaults objectForKey:@"U_StudentID"] forKey:@"Student_ID"];
        [params1 setObject:[defaults objectForKey:@"U_ID"] forKey:@"Rater_ID"];
        [params1 setObject:[defaults objectForKey:@"MS_ID"] forKey:@"MS_ID"];
        [params1 setObject:[defaults objectForKey:@"SI_Score"] forKey:@"SI_Score"];
//        NSMutableArray *newarray = [self.computers mutableCopy];
//         NSMutableArray *array5=[NSMutableArray arrayWithCapacity:100];
//        for(int i=0;i<[_computers count];i++){
//            NSMutableDictionary *rowData=newarray[i];
//            NSArray *array=rowData[@"MSI_Score"];
//              NSString *array2=rowData[@"MSI_ID"];
//             NSArray *array4=rowData[@"MSI_Item_ID"];
//            NSMutableDictionary *array1=rowData[@"GetScore"];
//            NSMutableArray *array3=[NSMutableArray arrayWithCapacity:100];
//            for (int j=0; j<[array count]; j++) {
//                NSMutableDictionary * mutableDictionary = [NSMutableDictionary dictionaryWithCapacity:100];
//                [mutableDictionary setValue:array4[j] forKey:@"MSI_Item_ID"];
//                [mutableDictionary setValue:array1[[NSString stringWithFormat:@"%d",j] ]forKey:@"MSI_Item_Score"];
//                [array3 insertObject:mutableDictionary atIndex:j];
//                          }
//               NSMutableDictionary * mutableDictionary1 = [NSMutableDictionary dictionaryWithCapacity:100];
//            [mutableDictionary1 setValue:array2 forKey:@"MSI_ID"];
//            [mutableDictionary1 setValue:array3 forKey:@"MSI_Item_List"];
//            [array5 insertObject:mutableDictionary1 atIndex:i];
//        }
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array5 options:NSJSONWritingPrettyPrinted error:&error];
//        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
 //[params1 setObject:[[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding] forKey:@"SI_Items"];
        [params1 setObject:@"" forKey:@"SI_Items"];
        NSData *resultData=[self getResultDataByPost:params1 seturl:aa1];
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
        NSString *result=[weatherDic objectForKey:@"result"];
        if([result compare:@"1"]==0){
            //clear user data
            delegate.update=nil;
            
            NSTimer *connectionTimer;
            connectionTimer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(haha:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:connectionTimer forMode:NSDefaultRunLoopMode];
        }else if ([result compare:@"-1"]==0){
            delegate.update=nil;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提交数据" message:@"已经提交过打分" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate=self;
            [alert show];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提交数据" message:@"数据提交失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }

   
    }
}
- (void) haha:(NSTimer *) timer{
   [indicator stopAnimating];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提交数据" message:@"数据已提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alert.delegate=self;
    [alert show];

   
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL bTag = FALSE;
    if(buttonIndex==0){
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"num"]==nil){
            [defaults setObject:@"1" forKey:@"num"];
        }else{
            int a=[[defaults objectForKey:@"num"]intValue];
            int b=a+1;
            [defaults setObject:[NSString stringWithFormat:@"%d",b] forKey:@"num"];
            [defaults synchronize];
            int ncount = [defaults integerForKey:@"Student_Count"];
            if (b >= ncount) {
                    bTag = TRUE;
                }
            
        }
        if (bTag) {
            [defaults removeObjectForKey:@"num"];
            [defaults synchronize];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示信息" message:@"恭喜您！所有用户打分完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [indicator stopAnimating];
            LoginViewController *selecttableViewController=[[LoginViewController alloc]init];
            [self presentViewController:selecttableViewController animated:YES completion:nil];
        }
        else {
            
            SelectTableViewController *selecttableViewController=[[SelectTableViewController alloc]init];
            [self presentViewController:selecttableViewController animated:YES completion:nil];
        }
    }
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
    self.showstudentexamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamnum.text=[defaults objectForKey:@"U_StudentCode"];
    self.studentname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentname.text=[defaults objectForKey:@"U_TrueName"];
    self.showstudentnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentnum.text=[defaults objectForKey:@"studentcode"];
    self.showstudentclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentclassnum.text=[defaults objectForKey:@"O_Name"];
    self.showstudentexamclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamclassnum.text=[defaults objectForKey:@"ES_Name"];
    self.showstudentexamname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentexamname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentexamname.text=[defaults objectForKey:@"examname"];
    self.showstudentroomnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.showstudentroomnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.showstudentroomnum.text=[defaults objectForKey:@"Room_Name"];
    self.studentexamnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamnum.text=@"考号：";
    self.showstudentname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentname.text=@"姓名：";
    self.studentnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentnum.text=@"学号：";
    self.studentclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentclassnum.text=@"班级：";
    self.studentexamname.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamname.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamname.text=@"考试名：";
    self.studentexamclassnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentexamclassnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentexamclassnum.text=@"考站号：";
    self.studentroomnum.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
    self.studentroomnum.font=[UIFont fontWithName:@"Helvetica-Bold" size:18];
    self.studentroomnum.text=@"房间号：";
    self.showcolor.backgroundColor=[UIColor colorWithRed:21.0/255 green:162.0/255 blue:213.0/255 alpha:1.0f];
    self.studentimg.image=[UIImage imageNamed:@"studentimg.jpg"];
    self.methoidid.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methoidid.font=[UIFont systemFontOfSize:18.0];
    self.methoidid.text=@"步骤";
    self.methodcontent.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methodcontent.font=[UIFont systemFontOfSize:18.0];
    self.methodcontent.text=@"内容";
    self.methodgetscore.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
        self.methodgetscore.font=[UIFont systemFontOfSize:18.0];
    self.methodgetscore.text=@"得分";
    self.methodmessage.textColor=[UIColor colorWithRed:224.0/255 green:239.0/255 blue:1.0f alpha:1.0f];
    self.methodmessage.font=[UIFont systemFontOfSize:18.0];
    self.methodmessage.text=@"评论";

    
  
    
    NSMutableArray *newarray = [self.computers mutableCopy];
    sum = 0;
    get = 0;
    for(int i=0;i<[_computers count];i++){
        NSMutableDictionary *rowData=newarray[i];
        NSArray *array=rowData[@"MSI_Score"];
       NSMutableDictionary *array1=rowData[@"GetScore"];
        for (int j=0; j<[array count]; j++) {
            sum+=[array[j] intValue];
            get+=[array1[[NSString stringWithFormat:@"%d",j]] intValue];
        }
           }
    [defaults setObject:[NSString stringWithFormat:@"%d",get] forKey:@"SI_Score"];
    [defaults synchronize];
    
    NSString *string=[NSString stringWithFormat:@"当前考站总分为:%@，考生得分为:%@",[NSString stringWithFormat:@"%d",sum],[NSString stringWithFormat:@"%d",get]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSString *strScore = [NSString stringWithFormat:@"%d",get];
    
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(string.length-strScore.length,strScore.length)];
        [str addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:@"Helvetica-Bold" size:18]
                    range:NSMakeRange(0,string.length)];
    
    
    

    self.messageresume.attributedText=str;
}
- (void)loginback{
    LoginViewController *loginviewController=[[LoginViewController alloc]init];
    [self presentViewController:loginviewController animated:YES completion:nil];
    
}
#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.computers count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
   
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
         NSDictionary *rowData;
                   rowData=self.computers[indexPath.row];
              //_indexpath=indexPath.row;
        // cell.computers=self.computers;
       
        _id=[rowData[@"MSI_ItemName"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _content=rowData[@"MSI_Item"];
        _score=rowData[@"GetScore"];
        // cell.size=rowData[@"Size"];
       // _value=rowData[@"GetScore"];
       // _flag=rowData[@"Flag"];
        _message=rowData[@"Commet"];
        //        [[NSNotificationCenter defaultCenter] addObserver:self
        //                                                 selector:@selector(keyboardHide:)
        //                                                     name:UIKeyboardWillHideNotification
        //                                                   object:nil];
        //  [self setUpForDismissKeyboard];
        
        
        UILabel  *lable1=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 88, 39*[_content count])];
        lable1.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
        lable1.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        lable1.text=_id;
        lable1.layer.masksToBounds=YES;
        lable1.layer.borderColor=[[UIColor colorWithRed:0.0/255 green:140.0/255 blue:230.0/255 alpha:1.0f]CGColor];
        lable1.layer.borderWidth= 1.0f;
         [lable1 setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:lable1];
        for(int i=0;i<[_content count];i++){
            UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(98,8+39*i,292,35)];
            label2.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label2.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label2.text=[_content[i]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(355,8+39*i,51,35) ];
            label3.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label3.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
            label3.text=_score[[NSString stringWithFormat:@"%d",i]];
            [label3 setTextAlignment:NSTextAlignmentCenter];
            UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(455,8+39*i,51,35) ];
            label4.textColor=[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0f];
            label4.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
            if([_message count]>i){
                label4.text=_message[[NSString stringWithFormat:@"%d",i]];
            }
            [cell addSubview:label2];
            [cell addSubview:label3];
            [cell addSubview:label4];
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
        return 46*[aa count];
    }else{
        return 44*[aa count];
    }
    
}
- (BOOL)shouldAutorotate

{
    
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskLandscape;//只支持这一个方向(正常的方向)
    
}
/**
 * 保存图片
 */
-(NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
    NSData* imageData;
    
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(tempImage)) {
        //返回为png图像。
        imageData = UIImagePNGRepresentation(tempImage);
    }else {
        //返回为JPEG图像。
        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
    }
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
    NSLog(@"===fullPathToFile===%@",fullPathToFile);
    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}
-(NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN
                     picFilePath: (NSString *)picFilePath  // IN
                     picFileName: (NSString *)picFileName;  // IN
{
    
    
    NSString *TWITTERFON_FORM_BOUNDARY = @"0xKhTmLbOuNdArY";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    if(picFilePath){
        
        UIImage *image=[UIImage imageWithContentsOfFile:picFilePath];
        //判断图片是不是png格式的文件
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    if(picFilePath){
        ////添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        
        //声明pic字段，文件名为boris.png
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
        //声明上传文件的格式
        [body appendFormat:@"Content-Type: image/jpge,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    }
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    if(picFilePath){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        return result;
    }
    return nil;
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
@end
