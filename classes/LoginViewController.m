//
//  LoginViewController.m
//  HandScore
//
//  Created by lyn on 14-5-12.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WTRequestCenter.h"
#import "RMMapper.h"
#import "LoginInfoType.h"
#import "TYAppDelegate.h"
#import "MBProgressHUD.h"
#import "CustomIOS7AlertView.h"

@implementation LoginViewController

{
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
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *username=[defaults objectForKey:@"username"];
    if(username!=nil){
        self.username.text=username;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)jump:(id)sender {
    
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    
    NSString *usertext=self.username.text;
    NSString *passwordtext=self.password.text;
    if([usertext compare:@""]==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"请输入用户名" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if([usertext compare:@""]!=0&&[passwordtext compare:@""]==0){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"请输入密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *ipmessage=[defaults objectForKey:@"IPConfig"];
        if(ipmessage==nil){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"错误信息" message:@"请设置IP地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }else{
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:self.username.text forKey:@"username"];
            
            [defaults synchronize];
            
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HUD setLabelText:@"正在登陆"];
            [self getExamInfo];
        }
        
    }
}

-(void) getExamInfo
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setObject:self.username.text forKey:@"U_Name"];
    [params setObject:self.password.text forKey:@"U_PWD"];
    //[params setObject:@"1" forKey:@"test"];
    
    NSString *BaseUrl=[defaults objectForKey:@"IPConfig"];
    NSString *url=@"http://";
    url=[url stringByAppendingString:BaseUrl];
    url=[url stringByAppendingFormat:@"%@",@"/AppDataInterface/UserLogin.aspx/HandScoreUserLogin"];
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
                                          LoginInfoType* logInfo = [RMMapper objectWithClass:[LoginInfoType class]
                                                                              fromDictionary:obj];
                                          
                                          TYAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
                                          appDelegate.gLoginItem = logInfo;
                                          
                                          MainViewController *mainViewController=[[MainViewController alloc]init];
                                          
                                          [self presentViewController:mainViewController animated:YES completion:nil];
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

-(int)dealError:(NSString *) result{
    int nCase = [result integerValue];
    switch (nCase) {
        case UserError:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"用户名密码错误" message:@"用户名输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case PwdError:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"用户名密码错误" message:@"密码输入错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case NoExam:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"考试信息" message:@"当前时间没有考试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        UITextField *tf=[alertView textFieldAtIndex:0];
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:tf.text forKey:@"IPConfig"];
        [defaults synchronize];
        
    }
}


- (BOOL)shouldAutorotate

{
    
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations

{
    
    return UIInterfaceOrientationMaskLandscape;//只支持这一个方向(正常的方向)
    
}

- (IBAction)setupIP:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"设置IP" message:@"请输入IP地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil ] ;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *tf=[alert textFieldAtIndex:0];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    tf.text=[defaults objectForKey:@"IPConfig"];
    tf.keyboardType=UIKeyboardTypeNumberPad;
    [alert show];
    
}

@end
