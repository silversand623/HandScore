//
//  LoginViewController.h
//  HandScore
//
//  Created by lyn on 14-5-12.
//  Copyright (c) 2014年 TY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *username;//用户名
@property (weak, nonatomic) IBOutlet UITextField *password;//用户密码
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollView;//滚动视图
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;//登录按钮

- (IBAction)setupIP:(id)sender;

- (IBAction)jump:(id)sender;

typedef enum
{
    //以下是枚举成员
    LoginError = -3,
    PwdError = -2,
    UserError = -1,
    NoExam = 0,
    Success = 1
}LoginResult;//枚举名称

//#define iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)


@end
